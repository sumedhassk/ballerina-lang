// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# When a transaction block in Ballerina code begins, it will call this function to begin a transaction.
# If this is a new transaction (transactionId == () ), then this instance will become the initiator and will
# create a new transaction context.
# If the participant and initiator are in the same process, this transaction block will register with the local
# initiator via a local function call.
# If the participant and initiator are in different processes, this transaction block will register with the remote
# initiator via a network call.
#
# + transactionId - Globally unique transaction ID. If this is a new transaction which is initiated, then this
#                   will be null.
#                   If this is a participant in an existing transaction, then it will have a value.
# + transactionBlockId - ID of the transaction block. Each transaction block in a process has a unique ID.
# + registerAtUrl - The URL of the initiator
# + coordinationType - Coordination type of this transaction
# + return - Newly created/existing TransactionContext for this transaction.
function beginTransaction(string? transactionId, string transactionBlockId, string registerAtUrl,
                          string coordinationType) returns TransactionContext|error {
    if (transactionId is string) {
        if (initiatedTransactions.hasKey(transactionId)) { // if participant & initiator are in the same process
            // we don't need to do a network call and can simply do a local function call
            return registerLocalParticipantWithInitiator(transactionId, transactionBlockId, registerAtUrl);
        } else {
            //TODO: set the proper protocol
            string protocolName = PROTOCOL_DURABLE;
            RemoteProtocol[] protocols = [{
            name:protocolName, url:getParticipantProtocolAt(protocolName, transactionBlockId)
            }];
            return registerParticipantWithRemoteInitiator(transactionId, transactionBlockId, registerAtUrl, protocols);
        }
    } else {
        return createTransactionContext(coordinationType, transactionBlockId);
    }
}

# When an abort statement is executed, this function gets called.
#
# + transactionId - Globally unique transaction ID.
# + transactionBlockId - ID of the transaction block. Each transaction block in a process has a unique ID.
# + return - nil or error when transaction abortion is successful or not respectively.
function abortTransaction(string transactionId, string transactionBlockId) returns error? {
    string participatedTxnId = getParticipatedTransactionId(transactionId, transactionBlockId);
    var txn = participatedTransactions[participatedTxnId];
    if (txn is TwoPhaseCommitTransaction) {
        return txn.markForAbortion();
    } else if (txn is ()) {
        var initiatedTxn = initiatedTransactions[transactionId];
        if (initiatedTxn is TwoPhaseCommitTransaction) {
            return initiatedTxn.markForAbortion();
        } else {
            error err = error("Unknown transaction");
            panic err;
        }
    } else {
        // TODO: Ideally there shouldn't be an `else if` above but else. Once the limitations in type checking are fixed
        // this `else` block should be removed and the above `else if` block should be replaced with an else.
        error e = error("Unreachable code");
        panic e;
    }
}

# When a transaction block in Ballerina code ends, it will call this function to end a transaction.
# Ending a transaction by a participant has no effect because it is the initiator who can decide whether to
# commit or abort a transaction.
# Depending on the state of the transaction, the initiator decides to commit or abort the transaction.
#
# + transactionId - Globally unique transaction ID.
# + transactionBlockId - ID of the transaction block. Each transaction block in a process has a unique ID.
# + return - A string or an error representing the transaction end succcess status or failure respectively.
function endTransaction(string transactionId, string transactionBlockId) returns string|error {
    string participatedTxnId = getParticipatedTransactionId(transactionId, transactionBlockId);
    if (!initiatedTransactions.hasKey(transactionId) && !participatedTransactions.hasKey(participatedTxnId)) {
        error err = error("Transaction: " + participatedTxnId + " not found");
        panic err;
    }

    // Only the initiator can end the transaction. Here we check whether the entity trying to end the transaction is
    // an initiator or just a local participant
    if (!participatedTransactions.hasKey(participatedTxnId)) {
        var initiatedTxn = initiatedTransactions[transactionId];
        if (initiatedTxn is ()) {
            return "";
        } else if (initiatedTxn is TwoPhaseCommitTransaction) {
            if (initiatedTxn.state == TXN_STATE_ABORTED) {
                return initiatedTxn.abortInitiatorTransaction();
            } else {
                string|error ret = initiatedTxn.twoPhaseCommit();
                removeInitiatedTransaction(transactionId);
                return ret;
            }
        } else {
            // TODO: Ideally there shouldn't be an `else if` above but `else`. Once the limitations in type checking are
            // fixed this `else` block should be removed and the above `else if` block should be replaced with an else.
            error e = error("Unreachable code");
            panic e;
        }
    } else {
        return "";  // Nothing to do on endTransaction if you are a participant
    }
}

# Checks whether this instance is an initiator. Returns true if initiator.
#
# + transactionId - Globally unique transaction ID.
# + transactionBlockId - ID of the transaction block. Each transaction block in a process has a unique ID.
# + return - true or false representing whether this instance is an intiator or not.
function isInitiator(string transactionId, string transactionBlockId) returns boolean {
    if (initiatedTransactions.hasKey(transactionId)) {
        string participatedTxnId = getParticipatedTransactionId(transactionId, transactionBlockId);
        if (!participatedTransactions.hasKey(participatedTxnId)) {
            return true;
        }
    }
    return false;
}

# Prepare local resource managers.
#
# + transactionId - Globally unique transaction ID.
# + transactionBlockId - ID of the transaction block. Each transaction block in a process has a unique ID.
# + return - true or false representing whether the resource manager preparation is successful or not.
extern function prepareResourceManagers(string transactionId, string transactionBlockId) returns boolean;

# Commit local resource managers.
#
# + transactionId - Globally unique transaction ID.
# + transactionBlockId - ID of the transaction block. Each transaction block in a process has a unique ID.
# + return - true or false representing whether the commit is successful or not.
extern function commitResourceManagers(string transactionId, string transactionBlockId) returns boolean;

# Abort local resource managers.
#
# + transactionId - Globally unique transaction ID.
# + transactionBlockId - ID of the transaction block. Each transaction block in a process has a unique ID.
# + return - true or false representing whether the resource manager abortion is successful or not.
extern function abortResourceManagers(string transactionId, string transactionBlockId) returns boolean;

# Get the current transaction id. This function is useful for user code to save state against a transaction ID,
# so that when the `oncommit` or `onabort` functions registered for a transaction can retrieve that state using the
# transaction  that is passed in to those functions.
#
# + return - A string representing the ID of the current transaction.
public extern function getCurrentTransactionId() returns string;

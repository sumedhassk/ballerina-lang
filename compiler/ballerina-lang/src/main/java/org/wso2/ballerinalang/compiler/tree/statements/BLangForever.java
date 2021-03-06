/*
*  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
*
*  WSO2 Inc. licenses this file to you under the Apache License,
*  Version 2.0 (the "License"); you may not use this file except
*  in compliance with the License.
*  You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing,
*  software distributed under the License is distributed on an
*  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
*  KIND, either express or implied.  See the License for the
*  specific language governing permissions and limitations
*  under the License.
*/
package org.wso2.ballerinalang.compiler.tree.statements;

import org.ballerinalang.model.tree.NodeKind;
import org.ballerinalang.model.tree.SimpleVariableNode;
import org.ballerinalang.model.tree.statements.ForeverNode;
import org.ballerinalang.model.tree.statements.StreamingQueryStatementNode;
import org.wso2.ballerinalang.compiler.semantics.model.SymbolEnv;
import org.wso2.ballerinalang.compiler.tree.BLangNodeVisitor;
import org.wso2.ballerinalang.compiler.tree.BLangSimpleVariable;

import java.util.ArrayList;
import java.util.List;

/**
 * @since 0.95.0
 */
public class BLangForever extends BLangExpressionStmt implements ForeverNode {

    private List<StreamingQueryStatementNode> streamingQueryStatementNodeList = new ArrayList<>();
    private String siddhiQuery;
    private SymbolEnv env;
    private boolean isSiddhiRuntimeEnabled = true;
    public List<BLangSimpleVariable> params;

    public BLangForever() {
        String siddhiRuntimeEnabledProperty = System.getProperty("enable.siddhiRuntime");
        if (siddhiRuntimeEnabledProperty != null) {
            isSiddhiRuntimeEnabled = Boolean.parseBoolean(siddhiRuntimeEnabledProperty);
        }
    }

    @Override
    public void accept(BLangNodeVisitor visitor) {
        visitor.visit(this);
    }

    @Override
    public NodeKind getKind() {
        return NodeKind.FOREVER;
    }

    @Override
    public void addStreamingQueryStatement(StreamingQueryStatementNode streamingQueryStatementNode) {
        this.streamingQueryStatementNodeList.add(streamingQueryStatementNode);
    }

    @Override
    public List<StreamingQueryStatementNode> getStreamingQueryStatements() {
        return streamingQueryStatementNodeList;
    }

    @Override
    public List<BLangSimpleVariable> getParameters() {
        return params;
    }

    @Override
    public void addParameter(SimpleVariableNode param) {
        this.getParameters().add((BLangSimpleVariable) param);
    }

    public String getSiddhiQuery() {
        return siddhiQuery;
    }


    public void setSiddhiQuery(String siddhiQuery) {
        this.siddhiQuery = siddhiQuery;
    }

    public SymbolEnv getEnv() {
        return env;
    }

    public void setEnv(SymbolEnv env) {
        this.env = env;
    }

    public boolean isSiddhiRuntimeEnabled() {
        return isSiddhiRuntimeEnabled;
    }
}

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
package org.ballerinalang.model.values;

import org.ballerinalang.bre.bvm.Strand;
import org.ballerinalang.model.types.BType;

/**
 * Ballerina base value for the "future" type.
 */
public interface BFuture extends BRefType<Strand> {

    /**
     * Cancels the current future, if its possible to do so.
     * 
     * @return true if the target process was cancelled, or else, false
     */
    boolean cancel();
    
    /**
     * Checks if the current future is done. This can be done if the
     * target process finished naturally, or else, if it was cancelled.
     * 
     * @return true if its done, or else, false
     */
    boolean isDone();
    
    /**
     * Checks if the current future is cancelled. 
     * 
     * @return true if its cancelled, or else, false
     */
    boolean isCancelled();

    @Override
    default void stamp(BType type) {

    }
}

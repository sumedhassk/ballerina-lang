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
package org.ballerinalang.langserver.completion.annotations;

import org.ballerinalang.langserver.LSAnnotationCache;
import org.ballerinalang.langserver.completion.CompletionTest;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.DataProvider;

/**
 * Completion item tests for annotation attachments.
 */
public class AnnotationAttachments extends CompletionTest {
    
    @BeforeClass
    public void loadAnnotationCache() {
        LSAnnotationCache.initiate();
    }

    @DataProvider(name = "completion-data-provider")
    @Override
    public Object[][] dataProvider() {
        return new Object[][] {
                {"serviceAnnotation1.json", "annotation"},
                {"serviceAnnotation2.json", "annotation"},
                {"resourceAnnotation1.json", "annotation"},
//                {"resourceAnnotation2.json", "annotation"},
//                {"functionAnnotation1.json", "annotation"},
        };
    }
}

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

import ballerina/runtime;

type Teacher record {
    string name;
    int age;
    string status;
    string school;
};

type TeacherOutput record{
    string name;
    int count;
};

int index = 0;
stream<Teacher> inputStreamLengthBatchTest1 = new;
stream<TeacherOutput > outputStreamLengthBatchTest1 = new;
TeacherOutput[] globalEmployeeArray = [];

function startLengthBatchwindowTest1() returns (TeacherOutput[]) {

    Teacher[] teachers = [];
    Teacher t1 = { name: "Mohan", age: 30, status: "single", school: "Hindu College" };
    Teacher t2 = { name: "Raja", age: 45, status: "single", school: "Hindu College" };

    teachers[0] = t1;
    teachers[1] = t2;

    testLengthBatchwindow();

    outputStreamLengthBatchTest1.subscribe(function(TeacherOutput e) {printTeachers(e);});
    foreach var t in teachers {
        inputStreamLengthBatchTest1.publish(t);
    }

    int count = 0;
    while(true) {
        runtime:sleep(500);
        count += 1;
        if((globalEmployeeArray.length()) == 1 || count == 10) {
            break;
        }
    }

    return globalEmployeeArray;
}

function testLengthBatchwindow() {

    forever {
        from inputStreamLengthBatchTest1 window lengthBatchWindow(2)
        select inputStreamLengthBatchTest1.name, count() as count
        group by inputStreamLengthBatchTest1.school
        => (TeacherOutput [] emp) {
            foreach var e in emp {
                outputStreamLengthBatchTest1.publish(e);
            }
        }
    }
}

function printTeachers(TeacherOutput e) {
    addToGlobalEmployeeArray(e);
}

function addToGlobalEmployeeArray(TeacherOutput e) {
    globalEmployeeArray[index] = e;
    index = index + 1;
}
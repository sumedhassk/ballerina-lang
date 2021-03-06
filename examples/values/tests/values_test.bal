import ballerina/test;
import ballerina/io;

any[] outputs = [];
int counter = 0;

// This is the mock function which will replace the real function
@test:Mock {
    moduleName: "ballerina/io",
    functionName: "println"
}
public function mockPrint(any... s) {
    outputs[counter] = s[0];
    counter += 1;
}

@test:Config
function testFunc() {
    // Invoking the main function
    main();
    test:assertEquals(outputs[0], 10);
    test:assertEquals(outputs[1], 20.0);
    test:assertEquals(outputs[2], true);
    test:assertEquals(outputs[3], true);
    test:assertEquals(outputs[4], true);
    // TODO: Change it to decimal comparison once issue #12393 is fixed
    test:assertEquals(string.convert(outputs[5]), "27.5");
    test:assertEquals(outputs[6], 23);
    test:assertEquals(outputs[7], "Ballerina");
    test:assertEquals(outputs[8], true);
}

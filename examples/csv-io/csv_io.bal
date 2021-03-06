import ballerina/io;
import ballerina/log;

type Employee record {
    string id;
    string name;
    float salary;
};

// This function reads records one by one and prints the records.
function process(io:ReadableCSVChannel csvChannel) returns error? {
    // Read all the records from the provided file
    // until there are no more records.
    while (csvChannel.hasNext()) {
        // Read the records.
        var records = check csvChannel.getNext();
        // Print the records.
        if (records is string[]) {
            io:println(records);
        }
    }
    return;
}

//Specify the location of the `.CSV` file.
public function main() {
    string srcFileName = "./files/sample.csv";
    // Open a CSV channel in `write` mode and write some data to
    // ./files/sample.csv for later use.
    // The record separator of the `.CSV` file is a
    // new line, and the field separator is a comma (,).
    io:WritableCSVChannel wCsvChannel = io:openWritableCsvFile(srcFileName);
    string[][] data = [["1", "James", "10000"], ["2", "Nathan", "150000"],
    ["3", "Ronald", "120000"], ["4", "Roy", "6000"], ["5", "Oliver", "1100000"]];
    writeDataToCSVChannel(wCsvChannel, ...data);
    closeWritableCSVChannel(wCsvChannel);
    // Open a CSV channel in `read` mode which is the default mode.
    io:ReadableCSVChannel rCsvChannel = io:openReadableCsvFile(srcFileName);
    io:println("Start processing the CSV file from ", srcFileName);
    var processedResult = process(rCsvChannel);
    if (processedResult is error) {
        log:printError("An error occurred while processing the records: ",
                        err = processedResult);
    }
    io:println("Processing completed.");
    // Close the CSV channel.
    closeReadableCSVChannel(rCsvChannel);
    // Open a CSV channel in `read` mode which is the default mode.
    io:ReadableCSVChannel rCsvChannel2 = io:openReadableCsvFile(srcFileName);
    // Read the `.CSV` file as a table.
    io:println("Reading  " + srcFileName + " as a table");
    var tblResult = rCsvChannel2.getTable(Employee);
    if (tblResult is table<Employee>) {
        foreach var rec in tblResult {
            io:println(rec);
        }
    } else if (tblResult is error) {
        log:printError("An error occurred while creating table: ",
                        err = tblResult);
    }
    closeReadableCSVChannel(rCsvChannel2);
    // Writing the a table to a `.CSV` file.
    string targetFileName = "./files/output.csv";
    // Opening CSV channel in "write" mode.
    io:WritableCSVChannel wCsvChannel2 = io:openWritableCsvFile(targetFileName);
    io:println("Creating a table and adding data");
    table<Employee> employeeTable = createTableAndAddData();
    io:println("Writing the table to " + targetFileName);
    foreach var entry in employeeTable {
        string[] rec = [entry.id, entry.name, <string>entry.salary];
        writeDataToCSVChannel(wCsvChannel2, rec);
    }
    closeWritableCSVChannel(wCsvChannel2);
}

// Creates a table and adds some data.
function createTableAndAddData() returns table<Employee> {
    table<Employee> employeeTable = table{};
    Employee[] employees = [];
    employees[0] = { id: "1", name: "Allen", salary: 300000.0 };
    employees[1] = { id: "2", name: "Wallace", salary: 200000.0 };
    employees[2] = { id: "3", name: "Sheldon", salary: 1000000.0 };
    foreach var employee in employees {
        var result = employeeTable.add(employee);
        if (result is error) {
            log:printError("Error occurred while adding data to table: ",
                            err = result);
        }
    }
    return employeeTable;
}

// Write data to a given CSV Channel.
function writeDataToCSVChannel(io:WritableCSVChannel csvChannel,
                                string[]... data) {
    foreach var rec in data {
        var returnedVal = csvChannel.write(rec);
        if (returnedVal is error) {
            log:printError("Record was successfully written to target file: ",
                            err = returnedVal);
        }
    }
}

// Close Readable CSV channel.
function closeReadableCSVChannel(io:ReadableCSVChannel csvChannel) {
    var result = csvChannel.close();
    if (result is error) {
        log:printError("Error occured while closing the channel: ",
                        err = result);
    }
}

// Close Writable CSV channel.
function closeWritableCSVChannel(io:WritableCSVChannel csvChannel) {
    var result = csvChannel.close();
    if (result is error) {
        log:printError("Error occured while closing the channel: ",
                        err = result);
    }
}

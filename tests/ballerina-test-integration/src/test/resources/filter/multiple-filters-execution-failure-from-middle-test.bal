import ballerina.net.http;
import ballerina.log;

// Filter1

public struct Filter1 {
    function (http:Request request, http:FilterContext context) returns (http:FilterResult) filterRequest;
    function (http:Response response, http:FilterContext context) returns (http:FilterResult) filterResponse;
}

public function <Filter1 filter> init () {
    log:printInfo("Initializing filter 1");
}

public function <Filter1 filter> terminate () {
    log:printInfo("Stopping filter 1");
}

public function interceptRequest1 (http:Request request, http:FilterContext context) (http:FilterResult) {
    log:printInfo("Intercepting request for filter 1");
    http:FilterResult filterResponse = {canProceed:true, statusCode:200, message:"successful"};
    return filterResponse;
}

public function interceptResponse1 (http:Response response, http:FilterContext context) (http:FilterResult) {
    log:printInfo("Intercepting response for filter 1");
    http:FilterResult filterResponse = {canProceed:true, statusCode:200, message:"successful"};
    return filterResponse;
}

Filter1 filter1 = {filterRequest:interceptRequest1, filterResponse:interceptResponse1};

// Filter2

public struct Filter2 {
    function (http:Request request, http:FilterContext context) returns (http:FilterResult) filterRequest;
    function (http:Response response, http:FilterContext context) returns (http:FilterResult) filterResponse;
}

public function <Filter2 filter> init () {
    log:printInfo("Initializing filter 2");
}

public function <Filter2 filter> terminate () {
    log:printInfo("Stopping filter 2");
}

public function interceptRequest2 (http:Request request, http:FilterContext context) (http:FilterResult) {
    log:printInfo("Intercepting request for filter 2");
    http:FilterResult filterResponse = {canProceed:false, statusCode:405, message:"Not Allowed"};
    return filterResponse;
}

public function interceptResponse2 (http:Response response, http:FilterContext context) (http:FilterResult) {
    log:printInfo("Intercepting response for filter 2");
    http:FilterResult filterResponse = {canProceed:true, statusCode:200, message:"successful"};
    return filterResponse;
}

Filter2 filter2 = {filterRequest:interceptRequest2, filterResponse:interceptResponse2};

// Filter3

public struct Filter3 {
    function (http:Request request, http:FilterContext context) returns (http:FilterResult) filterRequest;
    function (http:Response response, http:FilterContext context) returns (http:FilterResult) filterResponse;
}

public function <Filter3 filter> init () {
    log:printInfo("Initializing filter 3");
}

public function <Filter3 filter> terminate () {
    log:printInfo("Stopping filter 3");
}

public function interceptRequest3 (http:Request request, http:FilterContext context) (http:FilterResult) {
    log:printInfo("Intercepting request for filter 3");
    http:FilterResult filterResponse = {canProceed:true, statusCode:200, message:"successful"};
    return filterResponse;
}

public function interceptResponse3 (http:Response response, http:FilterContext context) (http:FilterResult) {
    log:printInfo("Intercepting response for filter 3");
    http:FilterResult filterResponse = {canProceed:true, statusCode:200, message:"successful"};
    return filterResponse;
}

Filter3 filter3 = {filterRequest:interceptRequest3, filterResponse:interceptResponse3};

endpoint http:ServiceEndpoint echoEP {
    port:9090,
    filters:[filter1,filter2,filter3]
};

@http:serviceConfig {
    basePath:"/echo"
}
service<http:Service> echo bind echoEP {
    @http:resourceConfig {
        methods:["GET"],
        path:"/test"
    }
    echo (endpoint client, http:Request req) {
        http:Response res = {};
        _ = client -> respond(res);
    }
}

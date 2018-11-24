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


# Provides the HTTP actions for interacting with an HTTP server. Apart from the standard HTTP methods, `forward()`
# and `execute()` functions are provided. More complex and specific endpoint types can be created by wrapping this
# generic HTTP actions implementation.
#
# + serviceUri - The URL of the remote HTTP endpoint
public type HttpCaller client object {

    public ClientEndpointConfig config = {};
    private Client caller;

    public function __init(string serviceUri, ClientEndpointConfig config) {
        self.config = config;
        self.caller = createSimpleHttpClient(serviceUri, self.config);
    }

    # The `post()` function can be used to send HTTP POST requests to HTTP endpoints.
    #
    # + path - Resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ReadableByteChannel` or `mime:Entity[]`
    # + return - The response for the request or an `error` if failed to establish communication with the upstream server
    public remote function post(@sensitive string path, Request|string|xml|json|byte[]|io:ReadableByteChannel|mime:Entity[]|()
                                                    message) returns Response|error {
        Request req = buildRequest(message);
        return nativePost(self.config, path, req);
    }

    # The `head()` function can be used to send HTTP HEAD requests to HTTP endpoints.
    #
    # + path - Resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ReadableByteChannel` or `mime:Entity[]`
    # + return - The response for the request or an `error` if failed to establish communication with the upstream server
    public remote function head(@sensitive string path, Request|string|xml|json|byte[]|io:ReadableByteChannel|mime:Entity[]|()
                                                    message = ()) returns Response|error {
        Request req = buildRequest(message);
        return nativeHead(self.config, path, req);
    }

    # The `put()` function can be used to send HTTP PUT requests to HTTP endpoints.
    #
    # + path - Resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ReadableByteChannel` or `mime:Entity[]`
    # + return - The response for the request or an `error` if failed to establish communication with the upstream server
    public remote function put(@sensitive string path, Request|string|xml|json|byte[]|io:ReadableByteChannel|mime:Entity[]|()
                                                        message) returns Response|error {
        Request req = buildRequest(message);
        return nativePut(self.config, path, req);
    }

    # Invokes an HTTP call with the specified HTTP verb.
    #
    # + httpVerb - HTTP verb value
    # + path - Resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ReadableByteChannel` or `mime:Entity[]`
    # + return - The response for the request or an `error` if failed to establish communication with the upstream server
    public remote function execute(@sensitive string httpVerb, @sensitive string path, Request|string|xml|json|byte[]
                                                        |io:ReadableByteChannel|mime:Entity[]|() message) returns Response|error {
        Request req = buildRequest(message);
        return nativeExecute(self.config, httpVerb, path, req);
    }

    # The `patch()` function can be used to send HTTP PATCH requests to HTTP endpoints.
    #
    # + path - Resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ReadableByteChannel` or `mime:Entity[]`
    # + return - The response for the request or an `error` if failed to establish communication with the upstream server
    public remote function patch(@sensitive string path, Request|string|xml|json|byte[]|io:ReadableByteChannel|mime:Entity[]|()
                                                            message) returns Response|error {
        Request req = buildRequest(message);
        return nativePatch(self.config, path, req);
    }

    # The `delete()` function can be used to send HTTP DELETE requests to HTTP endpoints.
    #
    # + path - Resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ReadableByteChannel` or `mime:Entity[]`
    # + return - The response for the request or an `error` if failed to establish communication with the upstream server
    public remote function delete(@sensitive string path, Request|string|xml|json|byte[]|io:ReadableByteChannel|mime:Entity[]|()
                                                            message) returns Response|error {
        Request req = buildRequest(message);
        return nativeDelete(self.config, path, req);
    }

    # The `get()` function can be used to send HTTP GET requests to HTTP endpoints.
    #
    # + path - Request path
    # + message - An optional HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ReadableByteChannel` or `mime:Entity[]`
    # + return - The response for the request or an `error` if failed to establish communication with the upstream server
    public remote function get(@sensitive string path, Request|string|xml|json|byte[]|io:ReadableByteChannel|mime:Entity[]|()
                                                        message = ()) returns Response|error {
        Request req = buildRequest(message);
        return nativeGet(self.config, path, req);
    }

    # The `options()` function can be used to send HTTP OPTIONS requests to HTTP endpoints.
    #
    # + path - Request path
    # + message - An optional HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ReadableByteChannel` or `mime:Entity[]`
    # + return - The response for the request or an `error` if failed to establish communication with the upstream server
    public remote function options(@sensitive string path, Request|string|xml|json|byte[]|io:ReadableByteChannel|mime:Entity[]|()
                                                            message = ()) returns Response|error {
        Request req = buildRequest(message);
        return nativeOptions(self.config, path, req);
    }

    # The `forward()` function can be used to invoke an HTTP call with inbound request's HTTP verb
    #
    # + path - Request path
    # + request - An HTTP inbound request message
    # + return - The response for the request or an `error` if failed to establish communication with the upstream server
    public remote extern function forward(@sensitive string path, Request request) returns Response|error;

    # Submits an HTTP request to a service with the specified HTTP verb.
    # The `submit()` function does not give out a `Response` as the result,
    # rather it returns an `HttpFuture` which can be used to do further interactions with the endpoint.
    #
    # + httpVerb - The HTTP verb value
    # + path - The resource path
    # + message - An HTTP outbound request message or any payload of type `string`, `xml`, `json`, `byte[]`,
    #             `io:ReadableByteChannel` or `mime:Entity[]`
    # + return - An `HttpFuture` that represents an asynchronous service invocation, or an `error` if the submission fails
    public remote function submit(@sensitive string httpVerb, string path, Request|string|xml|json|byte[]|
                                                    io:ReadableByteChannel|mime:Entity[]|() message)
                           returns HttpFuture|error {
        Request req = buildRequest(message);
        return nativeSubmit(self.config, httpVerb, path, req);
    }

    # Retrieves the `Response` for a previously submitted request.
    #
    # + httpFuture - The `HttpFuture` related to a previous asynchronous invocation
    # + return - An HTTP response message, or an `error` if the invocation fails
    public remote extern function getResponse(HttpFuture httpFuture) returns Response|error;

    # Checks whether a `PushPromise` exists for a previously submitted request.
    #
    # + httpFuture - The `HttpFuture` relates to a previous asynchronous invocation
    # + return - A `boolean` that represents whether a `PushPromise` exists
    public remote extern function hasPromise(HttpFuture httpFuture) returns (boolean);

    # Retrieves the next available `PushPromise` for a previously submitted request.
    #
    # + httpFuture - The `HttpFuture` relates to a previous asynchronous invocation
    # + return - An HTTP Push Promise message, or an `error` if the invocation fails
    public remote extern function getNextPromise(HttpFuture httpFuture) returns PushPromise|error;

    # Retrieves the promised server push `Response` message.
    #
    # + promise - The related `PushPromise`
    # + return - A promised HTTP `Response` message, or an `error` if the invocation fails
    public remote extern function getPromisedResponse(PushPromise promise) returns Response|error;

    # Rejects a `PushPromise`. When a `PushPromise` is rejected, there is no chance of fetching a promised
    # response using the rejected promise.
    #
    # + promise - The Push Promise to be rejected
    public remote extern function rejectPromise(PushPromise promise);
};

//Since the struct equivalency doesn't work with private keyword, following functions are defined outside the object
extern function nativePost(ClientEndpointConfig config, @sensitive string path, Request req) returns Response|error;

extern function nativeHead(ClientEndpointConfig config, @sensitive string path, Request req) returns Response|error;

extern function nativePut(ClientEndpointConfig config, @sensitive string path, Request req) returns Response|error;

extern function nativeExecute(ClientEndpointConfig config, @sensitive string httpVerb, @sensitive string path,
                                                        Request req) returns Response|error;

extern function nativePatch(ClientEndpointConfig config, @sensitive string path, Request req) returns Response|error;

extern function nativeDelete(ClientEndpointConfig config, @sensitive string path, Request req) returns Response|error;

extern function nativeGet(ClientEndpointConfig config, @sensitive string path, Request req) returns Response|error;

extern function nativeOptions(ClientEndpointConfig config, @sensitive string path, Request req) returns Response|error;

extern function nativeSubmit(ClientEndpointConfig config, @sensitive string httpVerb, string path, Request req)
                                                            returns HttpFuture|error;

# Defines a timeout error occurred during service invocation.
#
# + message - An explanation on what went wrong
# + cause - The error which caused the `HttpTimeoutError`
# + statusCode - HTTP status code
public type HttpTimeoutError record {
    string message = "";
    error? cause = ();
    int statusCode = 0;
    !...
};

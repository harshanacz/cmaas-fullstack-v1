import ballerina/http;
import ballerina/log;

configurable string appwriteEndpoint = ?;
configurable string appwriteProjectId = ?;
configurable string appwriteApiKey = ?;

service /api on new http:Listener(8080) {
    
    // CORS configuration
    resource function options .(http:Caller caller, http:Request req) returns error? {
        http:Response response = new;
        response.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
        response.setHeader("Access-Control-Allow-Credentials", "true");
        check caller->respond(response);
    }

    // Register user
    resource function post auth/register(http:Caller caller, http:Request req) returns error? {
        json|error payload = req.getJsonPayload();
        if payload is error {
            check caller->respond({"error": "Invalid request body"});
            return;
        }

        json requestBody = payload;
        string email = check requestBody.email;
        string password = check requestBody.password;
        string name = check requestBody.name;

        http:Client appwriteClient = check new (appwriteEndpoint);
        
        json registerPayload = {
            "userId": "unique()",
            "email": email,
            "password": password,
            "name": name
        };

        map<string> headers = {
            "X-Appwrite-Project": appwriteProjectId,
            "X-Appwrite-Key": appwriteApiKey,
            "Content-Type": "application/json"
        };

        http:Response|error response = appwriteClient->post("/v1/account", registerPayload, headers);
        
        if response is error {
            log:printError("Appwrite registration error", response);
            check caller->respond({"error": "Registration failed"});
            return;
        }

        json|error responsePayload = response.getJsonPayload();
        if responsePayload is error {
            check caller->respond({"error": "Invalid response from Appwrite"});
            return;
        }

        http:Response clientResponse = new;
        clientResponse.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
        clientResponse.setHeader("Access-Control-Allow-Credentials", "true");
        clientResponse.setJsonPayload(responsePayload);
        check caller->respond(clientResponse);
    }

    // Login user
    resource function post auth/login(http:Caller caller, http:Request req) returns error? {
        json|error payload = req.getJsonPayload();
        if payload is error {
            check caller->respond({"error": "Invalid request body"});
            return;
        }

        json requestBody = payload;
        string email = check requestBody.email;
        string password = check requestBody.password;

        http:Client appwriteClient = check new (appwriteEndpoint);
        
        json loginPayload = {
            "email": email,
            "password": password
        };

        map<string> headers = {
            "X-Appwrite-Project": appwriteProjectId,
            "Content-Type": "application/json"
        };

        http:Response|error response = appwriteClient->post("/v1/account/sessions/email", loginPayload, headers);
        
        if response is error {
            log:printError("Appwrite login error", response);
            check caller->respond({"error": "Login failed"});
            return;
        }

        json|error responsePayload = response.getJsonPayload();
        if responsePayload is error {
            check caller->respond({"error": "Invalid response from Appwrite"});
            return;
        }

        http:Response clientResponse = new;
        clientResponse.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
        clientResponse.setHeader("Access-Control-Allow-Credentials", "true");
        clientResponse.setJsonPayload(responsePayload);
        check caller->respond(clientResponse);
    }

    // Get current user
    resource function get auth/user(http:Caller caller, http:Request req) returns error? {
        string|error sessionToken = req.getHeader("Authorization");
        if sessionToken is error {
            check caller->respond({"error": "No authorization header"});
            return;
        }

        http:Client appwriteClient = check new (appwriteEndpoint);
        
        map<string> headers = {
            "X-Appwrite-Project": appwriteProjectId,
            "X-Appwrite-Session": sessionToken
        };

        http:Response|error response = appwriteClient->get("/v1/account", headers);
        
        if response is error {
            log:printError("Appwrite get user error", response);
            check caller->respond({"error": "Failed to get user"});
            return;
        }

        json|error responsePayload = response.getJsonPayload();
        if responsePayload is error {
            check caller->respond({"error": "Invalid response from Appwrite"});
            return;
        }

        http:Response clientResponse = new;
        clientResponse.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
        clientResponse.setHeader("Access-Control-Allow-Credentials", "true");
        clientResponse.setJsonPayload(responsePayload);
        check caller->respond(clientResponse);
    }

    // Logout user
    resource function delete auth/logout(http:Caller caller, http:Request req) returns error? {
        string|error sessionToken = req.getHeader("Authorization");
        if sessionToken is error {
            check caller->respond({"error": "No authorization header"});
            return;
        }

        http:Client appwriteClient = check new (appwriteEndpoint);
        
        map<string> headers = {
            "X-Appwrite-Project": appwriteProjectId,
            "X-Appwrite-Session": sessionToken
        };

        http:Response|error response = appwriteClient->delete("/v1/account/sessions/current", (), headers);
        
        if response is error {
            log:printError("Appwrite logout error", response);
            check caller->respond({"error": "Logout failed"});
            return;
        }

        http:Response clientResponse = new;
        clientResponse.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
        clientResponse.setHeader("Access-Control-Allow-Credentials", "true");
        clientResponse.setJsonPayload({"message": "Logged out successfully"});
        check caller->respond(clientResponse);
    }
}
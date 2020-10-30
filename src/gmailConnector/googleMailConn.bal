//--------------------------------------------------------------//
// Dhanushka-Simple Gmail  Connector Practice-WSO2-2020
//-------------------------------------------------------------//

//imported modules
import ballerina/oauth2;
import ballerina/http;
import ballerina/log;
import ballerina/config;

#Class for the connector.
public client class CalService {
    //client endpoint declaration
    http:Client mailClient;

    #construter for initialzation and Aouth2 direct token granttype. 
    public function init() returns error? {
        oauth2:OutboundOAuth2Provider oauth2Provider1 = new ({
            accessToken : config:getAsString("credentials.accessToken"), 
            refreshConfig : {
                refreshUrl :config:getAsString("credentials.refreshURL") , 
                refreshToken : config:getAsString("credentials.refreshToken"), 
                clientId : config:getAsString("credentials.clientId"), 
                clientSecret : config:getAsString("credentials.clientSecret"), 
                scopes : ["https://mail.google.com/"], 
                clientConfig : {
                    secureSocket : {
                        trustStore : {
                            path : config:getAsString("b7a.home") + "/bre/security/ballerinaTruststore.p12", 
                            password : "ballerina"
                        }
                    }
                }
            }
        });
        http:BearerAuthHandler oauth2Handler1 = new (oauth2Provider1);
        
        //Base URL
        self.mailClient = new ("https://www.googleapis.com/gmail",{
            auth : {
                authHandler : oauth2Handler1
            }
        });
        
    }

    #get user's profile information.
    # 
    # + return json json object.
    public remote function getUserProfile() returns json {
        var response1 = self.mailClient -> get("/v1/users/me/profile");
        if (response1 is http:Response) {
        var result = response1.getJsonPayload();
            if (result is json) {
                log:printInfo(result.toJsonString());
                return <@untainted>result;
            } else {
                log:printError("Failed to retrieve payload for client.");
            }
            } else {
                    log:printError("Failed to call the endpoint from client.", response1);
            }
        
    }

    #get gmail label list.
    # 
    # + return json object 
    public remote function getLabelList() returns json {
        var response1 = self.mailClient -> get("/v1/users/me/labels");
        if (response1 is http:Response) {
        var result = response1.getJsonPayload();
            if (result is json) {
                log:printInfo(result.toJsonString());
                return <@untainted>result;
            } else {
                log:printError("Failed to retrieve payload for client.");
            }
            } else {
                    log:printError("Failed to call the endpoint from client.", response1);
            }
    }

}

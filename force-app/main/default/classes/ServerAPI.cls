@RestResource(urlMapping='/TransactionItems/')
global with sharing class ServerAPI {
    @HttpPost
    global static void doPost() {        
        system.debug(RestContext.request.requestBody.toString());
    }
}
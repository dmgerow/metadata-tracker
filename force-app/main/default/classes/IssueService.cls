public with sharing class IssueService {

    public static void createIssue(IssueCreationModel request) {
        // Map<String,MetadataTrackerSettings__mdt> settingsByName =
        //         CustomMetadataSercice.getSettingsByDeveloperName();
        // HttpRequest req = new HttpRequest();
        // req.setEndpoint(settingsByName.get('Github_Issues_URL').Value__c);
        // req.setMethod('POST');
        // req.setHeader('Content-Type','application/json');
        // Blob headerValue = Blob.valueOf(settingsByName.get('Github_Username').Value__c
        //         + ':' + settingsByName.get('Github_API_Password').Value__c);
        // String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        // req.setHeader('Authorization', authorizationHeader);
        // req.setBody(JSON.serialize(request));
        // req.setTimeout(120000);
        // Http http = new Http();
        // System.debug(req);
        // System.debug(req.getBody());
        // HttpResponse res = http.send(req);
        // System.debug(res);
        // if(!String.valueOf(res.getStatusCode()).startsWith('2')) {
        //     throw new HttpException(String.valueOf(res.getStatusCode() + ': ' + res.getBody()));
        // }
    }

    public class HttpException extends Exception { }

}

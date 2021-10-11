public with sharing class PackageGenerator {

    public static String generatePackages(PackageGeneratorRequestModel requestModel) {
        String packageXmlString = generateXml(getMembersByType(requestModel,false));
        String destructiveChangesString = generateXml(getMembersByType(requestModel,true));
        String packageId = saveFile(packageXmlString, 'package.xml');
        String destructiveId = saveFile(destructiveChangesString, 'destructiveChanges.xml');
        return packageId + '/' + destructiveId;
    }

    public static String generateXml(Map<String,List<String>> membersByType) {
        Dom.Document doc = new Dom.Document();
        Dom.Xmlnode rootNode = doc.createRootElement('Package', null, null);
        rootNode.setAttribute('xmlns', 'http://soap.sforce.com/2006/04/metadata');
        for(String metadataType : membersByType.keySet()) {
            Dom.Xmlnode type = rootNode.addChildElement('types', null, null);
            for(String member : membersByType.get(metadataType)) {
                type.addChildElement('members', null, null).addTextNode(member);
            }
            type.addChildElement('name', null, null).addTextNode(metadataType);
        }
        Dom.Xmlnode version = rootNode.addChildElement('version', null, null).addTextNode('53.0');
        return doc.toXmlString();
    }

    public static Map<String,List<String>> getMembersByType(PackageGeneratorRequestModel requestModel,
            Boolean isDestructive) {
        Map<String,List<String>> membersByType = new Map<String,List<String>>();
        String queryString = generateQueryString(requestModel,isDestructive);
        for(MetadataFile__c file : (List<MetadataFile__c>)Database.query(queryString)) {
            List<String> members = new List<String>{file.Name};
            if(membersByType.containsKey(file.Type__c)) {
                members.addAll(membersByType.get(file.Type__c));
            }
            membersByType.put(file.Type__c,members);
        }
        return membersByType;
    }

    public static Id saveFile(String xmlString, String packageType) {
        String docId;
        for(ContentVersion version : [SELECT ContentDocumentId FROM ContentVersion
                WHERE MetadataTrackerType__c =: packageType AND Title =: packageType]) {
            docId = version.ContentDocumentId;
        }
        ContentVersion version = new ContentVersion();
        if(docId != null) {
            version.ContentDocumentId = docId;
        }
        version.Title = packageType;
        version.PathOnClient = packageType;
        version.VersionData = Blob.valueOf(xmlString);
        version.ContentLocation = 'S';
        version.Description = packageType + ' from WMP Metadata Tracker';
        version.Origin = 'C';
        version.MetadataTrackerType__c = packageType;
        insert version;
        return version.Id;
    }

    private static String generateQueryString(PackageGeneratorRequestModel requestModel,
            Boolean isDestructive) {
                System.debug(requestModel);
        String queryString = 'SELECT Name, IsDestructive__c, Type__c, LastTrackedDate__c FROM MetadataFile__c WHERE '
                + 'IsDestructive__c = ' + String.valueOf(isDestructive) + ' ';
        switch on requestModel.context {
            when 'date' {
                queryString += 'AND LastTrackedDate__c >= ' + String.valueOf(requestModel.lowerBound) + ' '
                        + 'AND LastTrackedDate__c <= ' +  String.valueOf(requestModel.upperBound);
            }
        }
        System.debug(queryString);
        return queryString;
    }

}

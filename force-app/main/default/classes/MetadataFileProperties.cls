public with sharing class MetadataFileProperties {

    public String type {get;set;}
    public String createdById {get;set;}
    public String createdByName {get;set;}
    public String createdDate {get;set;}
    // public String fileName {get;set;} this is not always a string and we aren't using it anyway
    public String fullName {get;set;}
    public String id {get;set;}
    public String lastModifiedById {get;set;}
    public String lastModifiedByName {get;set;}
    public String lastModifiedDate {get;set;}
    public String manageableState {get;set;}
    public String namespacePrefix {get;set;}

}

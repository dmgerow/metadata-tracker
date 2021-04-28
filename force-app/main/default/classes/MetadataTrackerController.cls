public with sharing class MetadataTrackerController {

    public static Set<String> customObjectChildrenTypes = new Set<String>{'ActionOverride',
            'BusinessProcess','CompactLayout','CustomField','FieldSet','HistoryRetentionPolicy',
            'ListView','RecordType','SearchLayouts','SharingReason','SharingRecalculation',
            'ValidationRule','WebLink'};

    public static Set<String> workflowChildrenTypes = new Set<String>{'WorkflowAlert',
            'WorkflowFieldUpdate','WorkflowFlowAction','WorkflowKnowledgePublish',
            'WorkflowOutboundMessage','WorkflowRule','WorkflowTask'};

    @AuraEnabled(cacheable=true)
    public static String getSettings(){
        UserSettings__c settings = UserSettings__c.getOrgDefaults();
        if(settings == null || settings.Id == null) {
            settings = CustomSettingsUtility.createDefaultCustomSettingRecord(false);
            Id jobID = System.enqueueJob(new QueueablePostInstallHandler());
        }
        return JSON.serialize(settings);
    }

    @AuraEnabled
    public static void updateTrackedMetadata(String fileString, String type) {
        try {
            MetadataFileModel file = (MetadataFileModel)JSON.deserialize(fileString, MetadataFileModel.class);
            switch on type {
                when 'track' {
                    upsert createFileFromModel(file, false) ExternalId__c;
                }
                when 'destroy' {
                    upsert createFileFromModel(file, true) ExternalId__c;
                }
                when 'untrack' {
                    delete [SELECT Id FROM MetadataFile__c WHERE ExternalId__c =: file.externalKey];
                }
            }
        } catch(Exception e) {
            throw new AuraHandledException('Oops, I couldn\'t save your metadata: ' + ExceptionUtility.generateExceptionString(e));
        }
    }

    @AuraEnabled
    public static String describeSingle(String filePropertyString) {
        try {
            List<MetadataFileModel> metadataTypes = new List<MetadataFileModel>();
            if(filePropertyString != null) {
                List<MetadataFileProperties> fileProperties =
                        (List<MetadataFileProperties>)JSON.deserialize(filePropertyString, List<MetadataFileProperties>.class);
                Map<String,MetadataFile__c> filesByExternalId = getFilesByExternalId(fileProperties[0].type);
                for(MetadataFileProperties fileProperty : fileProperties) {
                    MetadataFileModel metadata = new MetadataFileModel(fileProperty);
                    metadata.setButtonValues(filesByExternalId.get(metadata.externalKey));
                    metadataTypes.add(metadata);
                }
            }
            MetadataDescribeResponseModel response = new MetadataDescribeResponseModel();
            response.files = metadataTypes;
            return JSON.serialize(response);
        } catch(Exception e) {
            throw new AuraHandledException('Oops, I couldn\'t fetch metadata: ' + ExceptionUtility.generateExceptionString(e));
        }
    }

    public static Map<String,MetadataFile__c> getFilesByExternalId(String type) {
        Map<String,MetadataFile__c> filesByExternalId = new Map<String,MetadataFile__c>();
        for(MetadataFile__c file : [SELECT Name, Type__c, ExternalId__c, IsDestructive__c,
                LastTrackedDate__c FROM MetadataFile__c WHERE Type__c =: type]) {
            filesByExternalId.put(file.ExternalId__c,file);
        }
        return filesByExternalId;
    }

    public static MetadataFile__c createFileFromModel(MetadataFileModel file, Boolean isDestructive) {
        if(UserSettings__c.getOrgDefaults().TrackChildrenUnderParent__c && !isDestructive) {
            file.translateFileModel();
        }
        return new MetadataFile__c(
            Name = file.name,
            Type__c = file.type,
            IsDestructive__c = isDestructive,
            LastTrackedDate__c = Date.today(),
            ExternalId__c = file.externalKey);
    }

    public class MetadataDescribeResponseModel {
        @AuraEnabled public List<MetadataFileModel> files {get; set;}
        public MetadataDescribeResponseModel() {
            this.files = new List<MetadataFileModel>();
        }
    }
    public class MetadataFileModel {
        @AuraEnabled public Boolean trackDisabled {get;set;}
        @AuraEnabled public String trackIcon {get;set;}
        @AuraEnabled public Boolean untrackDisabled {get;set;}
        @AuraEnabled public Boolean destroyDisabled {get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String type {get;set;}
        // @AuraEnabled public String fileName {get;set;}
        @AuraEnabled public String externalKey {get;set;}
        @AuraEnabled public List<MetadataFileModel> children {get; set;}
        public MetadataFileModel(MetadataFileProperties fileProperty) {
            this.name = fileProperty.fullName;
            this.type = fileProperty.type;
            // this.fileName = fileProperty.fileName;
            this.children = new List<MetadataFileModel>();
            setExternalKey();
        }
        public void setExternalKey() {
            this.externalKey = this.type + '|' + this.name;
        }
        public void setButtonValues(MetadataFile__c file) {
            this.trackIcon = file != null && !file.IsDestructive__c ? 'utility:check' : 'utility:add';
            this.trackDisabled = false;
            this.untrackDisabled = file == null ? true :false;
            this.destroyDisabled = file != null && file.IsDestructive__c ? true : false;
        }
        public void translateFileModel() {
            if(this.type == null) {
                return;
            }
            if(MetadataTrackerController.customObjectChildrenTypes.contains(this.type)) {
                this.name = this.name.substringBefore('.');
                this.type = 'CustomObject';
            } else if(MetadataTrackerController.workflowChildrenTypes.contains(this.type)) {
                this.name = this.name.substringBefore('.');
                this.type ='Workflow';
            }
            setExternalKey();
        }
    }

}

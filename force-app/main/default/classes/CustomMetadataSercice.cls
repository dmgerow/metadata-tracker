public with sharing class CustomMetadataSercice {

    public static Map<String,MetadataTrackerSettings__mdt> getSettingsByDeveloperName() {
        Map<String,MetadataTrackerSettings__mdt> settingsByName = new Map<String,MetadataTrackerSettings__mdt>();
        for(MetadataTrackerSettings__mdt setting : [SELECT DeveloperName, Value__c
                FROM MetadataTrackerSettings__mdt]) {
            settingsByName.put(setting.DeveloperName,setting);
        }
        return settingsByName;
    }

}

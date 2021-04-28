public with sharing class CustomSettingsUtility {

    public static UserSettings__c createDefaultCustomSettingRecord(Boolean isInsert) {
        UserSettings__c settings = UserSettings__c.getOrgDefaults();
        if(settings.Id == null) {
            settings = new UserSettings__c();
        }
        settings.MaxResultSize__c = 5000;
        settings.TrackChildrenUnderParent__c = false;
        if(isInsert) {
            upsert settings;
        }
        return settings;
    }

}

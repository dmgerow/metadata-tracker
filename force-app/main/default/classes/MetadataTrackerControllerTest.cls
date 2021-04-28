@isTest
public class MetadataTrackerControllerTest {

    @testSetup static void insertTrackedMetadata() {
        List<sObject> ls = Test.loadData(MetadataFile__c.sObjectType, 'trackedMetadataTestData');
    }

    @isTest static void trackMetadata() {
        MetadataTrackerController.MetadataFileModel fileModel
                = new MetadataTrackerController.MetadataFileModel(getContactProperty());
        Test.startTest();
        MetadataTrackerController.updateTrackedMetadata(JSON.serialize(fileModel),'track');
        Test.StopTest();
        System.assertEquals(1,[SELECT count() FROM MetadataFile__c WHERE Name = 'Contact'
                AND IsDestructive__c = false], 'Contact file missing.');
    }

    @isTest static void trackMetadataParent() {
        UserSettings__c settings = CustomSettingsUtility.createDefaultCustomSettingRecord(false);
        settings.TrackChildrenUnderParent__c = true;
        insert settings;
        MetadataTrackerController.MetadataFileModel fileModel
                = new MetadataTrackerController.MetadataFileModel(getContactFieldProperty());
        Test.startTest();
        MetadataTrackerController.updateTrackedMetadata(JSON.serialize(fileModel),'track');
        Test.StopTest();
        System.assertEquals(1,[SELECT count() FROM MetadataFile__c WHERE Name = 'Contact'
                AND IsDestructive__c = false], 'Contact file missing.');
        System.assertEquals(0,[SELECT count() FROM MetadataFile__c WHERE Name = 'Contact.Name'
                AND IsDestructive__c = false], 'Contact field should not exist.');
    }

    @isTest static void unTrackMetadata() {
        MetadataTrackerController.MetadataFileModel fileModel
                = new MetadataTrackerController.MetadataFileModel(getAccountProperty());
        Test.startTest();
        MetadataTrackerController.updateTrackedMetadata(JSON.serialize(fileModel),'untrack');
        Test.StopTest();
        System.assertEquals(0,[SELECT count() FROM MetadataFile__c WHERE Name = 'Account'
                AND IsDestructive__c = true], 'Account file was not removed.');
    }

    @isTest static void destroyMetadata() {
        MetadataTrackerController.MetadataFileModel fileModel
                = new MetadataTrackerController.MetadataFileModel(getContactProperty());
        Test.startTest();
        MetadataTrackerController.updateTrackedMetadata(JSON.serialize(fileModel),'destroy');
        Test.StopTest();
        System.assertEquals(1,[SELECT count() FROM MetadataFile__c WHERE Name = 'Contact'
                AND IsDestructive__c = true], 'Contact file missing.');
    }

    @isTest static void describeSingle() {
        List<MetadataFileProperties> fileProperties = new List<MetadataFileProperties>();
        fileProperties.add(getContactProperty());
        Test.startTest();
        String response = MetadataTrackerController.describeSingle(JSON.serialize(fileProperties));
        Test.StopTest();
        MetadataTrackerController.MetadataDescribeResponseModel responseModel =
                (MetadataTrackerController.MetadataDescribeResponseModel)JSON.deserialize(
                response,MetadataTrackerController.MetadataDescribeResponseModel.class);
        System.assertEquals(1,responseModel.files.size(), 'Incorrect number of file models were returned.');
    }

    private static MetadataFileProperties getContactProperty() {
        MetadataFileProperties contactProperty = new MetadataFileProperties();
        contactProperty.type = 'CustomObject';
        // contactProperty.fileName = 'objects/Contact.object';
        contactProperty.fullName = 'Contact';
        contactProperty.createdById = 'meid';
        contactProperty.createdByName = 'me';
        contactProperty.createdDate = String.valueOf(System.now());
        contactProperty.id = 'id';
        contactProperty.lastModifiedById = 'meId';
        contactProperty.lastModifiedByName = 'me';
        contactProperty.lastModifiedDate = String.valueOf(System.now());
        contactProperty.manageableState = 'false';
        contactProperty.namespacePrefix = '';
        return contactProperty;
    }

    private static MetadataFileProperties getContactFieldProperty() {
        MetadataFileProperties contactProperty = new MetadataFileProperties();
        contactProperty.type = 'CustomField';
        // contactProperty.fileName = 'objects/Contact.object';
        contactProperty.fullName = 'Contact.Name';
        contactProperty.createdById = 'meid';
        contactProperty.createdByName = 'me';
        contactProperty.createdDate = String.valueOf(System.now());
        contactProperty.id = 'id';
        contactProperty.lastModifiedById = 'meId';
        contactProperty.lastModifiedByName = 'me';
        contactProperty.lastModifiedDate = String.valueOf(System.now());
        contactProperty.manageableState = 'false';
        contactProperty.namespacePrefix = '';
        return contactProperty;
    }

    private static MetadataFileProperties getAccountProperty() {
        MetadataFileProperties accountProperty = new MetadataFileProperties();
        accountProperty.type = 'CustomObject';
        // accountProperty.fileName = 'objects/Account.object';
        accountProperty.fullName = 'Account';
        accountProperty.createdById = 'meid';
        accountProperty.createdByName = 'me';
        accountProperty.createdDate = String.valueOf(System.now());
        accountProperty.id = 'id';
        accountProperty.lastModifiedById = 'meId';
        accountProperty.lastModifiedByName = 'me';
        accountProperty.lastModifiedDate = String.valueOf(System.now());
        accountProperty.manageableState = 'false';
        accountProperty.namespacePrefix = '';
        return accountProperty;
    }

}


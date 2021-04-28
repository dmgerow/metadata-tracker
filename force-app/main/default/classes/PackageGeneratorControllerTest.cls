@isTest
public class PackageGeneratorControllerTest {

    @testSetup static void insertTrackedMetadata() {
        List<sObject> ls = Test.loadData(MetadataFile__c.sObjectType, 'trackedMetadataTestData');
    }

    @isTest static void generatePackageAll() {
        Test.startTest();
        PackageGeneratorRequestModel requestModel = new PackageGeneratorRequestModel();
        requestModel.context = 'all';
        String docId = PackageGeneratorController.generatePackageXml(JSON.serialize(requestModel));
        Test.StopTest();
        System.assertNotEquals(null,docId, 'Package.xml missing.');
    }

    @isTest static void generatePackageDate() {
        Test.startTest();
        PackageGeneratorRequestModel requestModel = new PackageGeneratorRequestModel();
        requestModel.context = 'date';
        requestModel.lowerBound = Date.today();
        requestModel.upperBound = Date.today();
        String docId = PackageGeneratorController.generatePackageXml(JSON.serialize(requestModel));
        Test.StopTest();
        System.assertNotEquals(null,docId, 'Package.xml missing.');
    }

}
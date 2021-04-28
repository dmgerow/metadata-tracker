@isTest
public class PostInstallHandlerTest {

    @isTest
    static void testInstallScript() {
        Test.setMock(HttpCalloutMock.class, new IssueServiceMock());
        Test.startTest();
        UserSettings__c settings = UserSettings__c.getOrgDefaults();
        System.assertEquals(null, settings.Id);
        System.assertEquals(null, settings.MaxResultSize__c);
        try{
            PostInstallHandler postinstall = new PostInstallHandler();
            Test.testInstall(postinstall, null);
        } catch(Exception e) {
            System.assert(false);
        }
        Test.StopTest();
        settings = UserSettings__c.getOrgDefaults();
        System.assert(true);
        System.assertNotEquals(null, settings.Id);
        System.assertEquals(5000, settings.MaxResultSize__c);
    }

}

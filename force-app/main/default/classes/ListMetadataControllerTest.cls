@isTest
public class ListMetadataControllerTest {

    @isTest static void baseUrl() {
        ListMetadataController controller = new ListMetadataController();
        Test.startTest();
        System.assertNotEquals(null, controller.baseUrl, 'No Base URL returned');
        Test.StopTest();
    }

}

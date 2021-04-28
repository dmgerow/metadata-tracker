@isTest
public class FeedbackControllerTest {

    @isTest static void sendFeedback() {
        IssueCreationModel model = new IssueCreationModel();
        model.body = 'good feedback';
        Test.setMock(HttpCalloutMock.class, new IssueServiceMock());
        Test.startTest();
        try{
            FeedbackController.sendFeedback(JSON.serialize(model));
        } catch(Exception e) {
            System.assert(false);
        }
        Test.StopTest();
        System.assert(true);
    }

}

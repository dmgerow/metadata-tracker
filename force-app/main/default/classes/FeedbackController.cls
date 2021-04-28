public with sharing class FeedbackController {

    @AuraEnabled
    public static void sendFeedback(String request){
        try {
            IssueCreationModel model = (IssueCreationModel)JSON.deserialize(request, IssueCreationModel.class);
            model.labels = new List<String>{'feedback'};
            model.setParams();
            IssueService.createIssue(model);
        } catch(Exception e) {
            throw new AuraHandledException(ExceptionUtility.generateExceptionString(e));
        }
    }

}

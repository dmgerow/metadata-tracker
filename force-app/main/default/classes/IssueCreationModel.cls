public with sharing class IssueCreationModel {

    public String title {get;set;}
    public String body {get;set;}
    public List<String> labels {get;set;}

    public void setParams() {
        if(this.body == null) {
            this.body = '';
        }
        this.title = 'Feedback from ' + UserInfo.getUserEmail() + ' in '
                + UserInfo.getOrganizationName() + '(' + UserInfo.getOrganizationId()
                + ')';
    }

}

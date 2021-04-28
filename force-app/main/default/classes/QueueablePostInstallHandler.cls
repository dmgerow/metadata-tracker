public with sharing class QueueablePostInstallHandler implements Queueable, Database.AllowsCallouts {

    String organizationId;
    String installerId;


    public QueueablePostInstallHandler(InstallContext installationContext) {
        this.organizationId = installationContext.organizationId();
        this.installerId = installationContext.installerId();
    }

    public QueueablePostInstallHandler() {
        this.organizationId = UserInfo.getOrganizationId();
        this.installerId = UserInfo.getUserId();
    }

    public void execute(QueueableContext context) {
        User installationUser =[Select Id, Email, FirstName, LastName
                FROM User WHERE Id =: this.installerId LIMIT 1];
        Organization orgInfo =[Select Id, Name FROM Organization
                WHERE Id =: this.organizationId LIMIT 1];
        IssueCreationModel installIssue = new IssueCreationModel();
        installIssue.labels = new List<String>{'installation'};
        installIssue.title = 'Package Installation Completed by ' + installationUser.Email
                + ' in ' + this.organizationId;
        installIssue.body = 'Installer Email: ' + installationUser.Email + '||'
                + 'Installer Name: ' + installationUser.FirstName + ' ' + installationUser.LastName + '||'
                + 'Org ID: ' + this.organizationId + '||'
                + 'Org Name: ' + orgInfo.Name;
        IssueService.createIssue(installIssue);
        CustomSettingsUtility.createDefaultCustomSettingRecord(true);
    }

}
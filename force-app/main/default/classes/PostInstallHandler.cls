global class PostInstallHandler implements InstallHandler {

    global void onInstall(InstallContext context) {
        Id jobID = System.enqueueJob(new QueueablePostInstallHandler(context));
    }

}
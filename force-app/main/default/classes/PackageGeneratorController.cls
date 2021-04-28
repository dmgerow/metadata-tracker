public with sharing class PackageGeneratorController {

    @AuraEnabled
    public static String generatePackageXml(String request) {
        try {
            PackageGeneratorRequestModel requestModel =
                    (PackageGeneratorRequestModel)JSON.deserialize(request, PackageGeneratorRequestModel.class);
            return PackageGenerator.generatePackages(requestModel);
        } catch(Exception e) {
            throw new AuraHandledException('Oops, I couldn\'t generate your packages: ' + ExceptionUtility.generateExceptionString(e));
        }
    }

}

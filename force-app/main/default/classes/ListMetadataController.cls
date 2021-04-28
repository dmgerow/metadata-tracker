public with sharing class ListMetadataController {
  public String baseUrl {
    get {
      if (baseUrl == null) {
        baseUrl =
          URL.getSalesforceBaseUrl().toExternalForm().substringBefore('.').removeEnd('--c') +
          '.lightning.force.com';
      }
      return baseUrl;
    }
    private set;
  }
}

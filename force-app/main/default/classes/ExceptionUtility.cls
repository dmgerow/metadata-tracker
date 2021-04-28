public with sharing class ExceptionUtility {

    public static String generateExceptionString(Exception e) {
        return e.getMessage() + ' at ' + e.getStackTraceString();
    }

}

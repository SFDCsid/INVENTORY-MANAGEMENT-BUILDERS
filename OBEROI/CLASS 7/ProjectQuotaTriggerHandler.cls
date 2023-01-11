public with sharing class ProjectQuotaTriggerHandler {
    public static void handleBeforeInsert() {
        updateUniqueIdOnProjectQuota();
    }
    
    public static void handleBeforeUpdate() {
        updateUniqueIdOnProjectQuota();
    }
    
    public static void updateUniqueIdOnProjectQuota() {
        for(Project_Quota__c projectQuota : (List<Project_Quota__c>) Trigger.New) {
            projectQuota.Unique_Id__c = projectQuota.Project__c + '' + projectQuota.Month__c + '' + projectQuota.Year__c;
        }
    }
}
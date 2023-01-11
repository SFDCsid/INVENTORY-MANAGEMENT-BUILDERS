public with sharing class UserQuotaTriggerHandler {
    public static void handleBeforeInsert() {
        updateUniqueIdOnUserQuota();
        
    }
    
    public static void handleBeforeUpdate() {
        updateUniqueIdOnUserQuota();
    }
    
    public static void updateUniqueIdOnUserQuota() {
        for(User_Quota__c userQuota : (List<User_Quota__c>) Trigger.New) {
            userQuota.Unique_Id__c = userQuota.Project__c + '' + userQuota.Month__c + '' + userQuota.Year__c + '' + userQuota.User__c;
        }
    }
}
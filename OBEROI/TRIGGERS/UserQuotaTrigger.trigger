trigger UserQuotaTrigger on User_Quota__c (before insert, before update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            UserQuotaTriggerHandler.handleBeforeInsert();
        } else if( Trigger.isUpdate) {
            UserQuotaTriggerHandler.handleBeforeUpdate();
        }
    }
}
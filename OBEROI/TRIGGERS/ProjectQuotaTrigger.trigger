trigger ProjectQuotaTrigger on Project_Quota__c (before insert, before update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            ProjectQuotaTriggerHandler.handleBeforeInsert();
        } else if( Trigger.isUpdate) {
            ProjectQuotaTriggerHandler.handleBeforeUpdate();
        }
    }
}
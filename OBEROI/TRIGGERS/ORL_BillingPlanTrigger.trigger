trigger ORL_BillingPlanTrigger on Payment_Plan__c (before Insert, before update, after Insert,after update) {
    if(Trigger.isbefore){
        if(Trigger.isUpdate){
            BillingPlanTriggerHandler.pricingCalculation(Trigger.new,Trigger.OldMap,'Update');
        }
        if(Trigger.isInsert){
            BillingPlanTriggerHandler.pricingCalculation(Trigger.new,Trigger.OldMap,'Insert');
            BillingPlanTriggerHandler.insertRMDetails(Trigger.new);
        }
    }
        if(Trigger.isAfter){
        if(Trigger.isInsert){
            BillingPlanTriggerHandler.onAfterInsert(Trigger.new);
        }
    }
     if(Trigger.isAfter){
        if(Trigger.isUpdate){
            BillingPlanTriggerHandler.onAfterUpdate(Trigger.new,Trigger.OldMap);
        }
    }
}
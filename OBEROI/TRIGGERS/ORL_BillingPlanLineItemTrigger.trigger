trigger ORL_BillingPlanLineItemTrigger on Billing_Plan_Line_Item__c (after Insert) {
        if(Trigger.isAfter){
        if(Trigger.isInsert){
            BillingPlanLineItemTriggerHandler.onAfterInsert(Trigger.new);
          //BillingPlanLineItemTriggerHandler.handleAfterInsert(Trigger.new);
        }
    }
}
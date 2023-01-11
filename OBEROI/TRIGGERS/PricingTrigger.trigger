trigger PricingTrigger on Pricing__c (before update, After Insert,After Update, Before Insert) {
     if(trigger.isbefore) {
          system.debug('@@Trigger Call 1');
        if(trigger.isInsert){
        system.debug('@@Trigger Call');
                    PricingTriggerHandler.onBeforeInsert(Trigger.new);
                }
            if(trigger.isupdate) {
                    PricingTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.OldMap);
            }
        }
        if(trigger.isAfter) {
            if(trigger.isupdate) {
                    PricingTriggerHandler.onAfterUpdate(Trigger.new, Trigger.OldMap);
            }
        }
}
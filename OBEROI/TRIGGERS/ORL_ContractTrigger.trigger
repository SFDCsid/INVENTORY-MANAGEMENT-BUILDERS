trigger ORL_ContractTrigger on Contract (before Insert, before update, after Insert,after update) {
    ORL_ProcessSwitchSettings__c triggersetting  = ORL_ProcessSwitchSettings__c.getInstance();
    
    if((triggersetting.Id != null || triggersetting.setupownerId != null) && triggersetting.ContractTriggerSwitch__c){
        //TrigFlow: 1 after event
        if(trigger.isafter) {
            if(trigger.isinsert) {
                ORL_ContractTriggerHandler.onAfterInsert(Trigger.new);
            } else if(trigger.isupdate) {
                 ORL_ContractTriggerHandler.onAfterUpdate(Trigger.new, Trigger.OldMap);
            }
        }
        
        //TrigFlow: 1 before event
        if(trigger.isbefore) {
            if(trigger.isinsert) {
                ORL_ContractTriggerHandler.onBeforeInsert(Trigger.new);
            } else if(trigger.isupdate) {
                 ORL_ContractTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.OldMap);
            }
        }
    }
    
}
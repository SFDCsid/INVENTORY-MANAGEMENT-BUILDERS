/*
*  Author: Vivek S
*  Description: This trigger is used to handle different trigger actions for Property.
*  Change Log: Created-15022019
*/

trigger ORL_PropertyTrigger on Property__c (before Insert, before update, after Insert,after update) {
    
   // ORL_ProcessSwitchSettings__c triggersetting  = ORL_ProcessSwitchSettings__c.getInstance();
    
    /*if((triggersetting.Id != null || triggersetting.setupownerId != null) && triggersetting.PropertyTriggerSwitch__c) {
//TrigFlow: 1 after event
if(trigger.isafter) {
if(trigger.isinsert) {
ORL_PropertyTriggerHandler.onAfterInsert(Trigger.new);
} else if(trigger.isupdate) {
ORL_PropertyTriggerHandler.onAfterUpdate(Trigger.new, Trigger.OldMap);
}
}

//TrigFlow: 1 before event
if(trigger.isbefore) {
if(trigger.isinsert) {
ORL_PropertyTriggerHandler.onBeforeInsert(Trigger.new);
} else if(trigger.isupdate) {
ORL_PropertyTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.OldMap);
}
}
}*/
/*if(Trigger.isbefore){
       if(Trigger.isUpdate){
            system.debug('Before Update Trigger');
           // ORL_PropertyTriggerHandler.jodiCheck(Trigger.new,Trigger.OldMap);
            ORL_PropertyTriggerHandler.onBeforeUpdate(Trigger.new,Trigger.OldMap);            
            
            ORL_PropertyTriggerHandler.autoPopulateBlockedBy(Trigger.new,Trigger.OldMap);
            ORL_PropertyTriggerHandler.propertyCheck(Trigger.new,Trigger.OldMap);
            ORL_PropertyTriggerHandler.autoBlockGrande(Trigger.new,Trigger.OldMap);
            //ORL_PropertyTriggerHandler.jodiCheck(Trigger.new,Trigger.OldMap);
             //ORL_PropertyTriggerHandler.propertycheck(Trigger.new);
            
        }
    }*/
    if(Trigger.isafter){
        if(Trigger.isUpdate){
            system.debug('After Update Trigger');
            set<Id> unitId = new Set<Id>();
           // ORL_PropertyTriggerHandler.onAfterUpdate(Trigger.new,Trigger.OldMap);
           
   /******************** Added by VIKAS to Inactive quotation If unit linked milestone Update *****************/
           for(Property__c p : trigger.New){
               if((trigger.oldMap.get(p.id).BW__c != trigger.newMap.get(p.id).BW__c && p.BW__c) ||
                  (trigger.oldMap.get(p.id).ST__c != trigger.newMap.get(p.id).ST__c && p.ST__c) || 
                  (trigger.oldMap.get(p.id).PT__c != trigger.newMap.get(p.id).PT__c && p.PT__c) ||
                  (trigger.oldMap.get(p.id).EL__c != trigger.newMap.get(p.id).EL__c && p.EL__c)){
                   unitId.add(p.id);
               }
           }
           if(!unitId.isEmpty()){
               PropertyManagementServices.InactiveQuotation(unitId,null,null,null);
           }
            
        }
    }
}
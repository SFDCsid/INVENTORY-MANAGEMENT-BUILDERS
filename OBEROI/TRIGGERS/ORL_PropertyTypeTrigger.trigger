/*
*  Author: Vivek S
*  Description: This trigger is used to handle different trigger actions for Property Type.
*  Change Log: Created-15022019
*/

trigger ORL_PropertyTypeTrigger on Property_Type__c (before Insert, before update, after Insert,after update) {

ORL_ProcessSwitchSettings__c triggersetting  = ORL_ProcessSwitchSettings__c.getInstance();
  
  if((triggersetting.Id != null || triggersetting.setupownerId != null) && triggersetting.PropertyTypeTriggerSwitch__c) {
        //TrigFlow: 1 after event
        if(trigger.isafter) {
            if(trigger.isinsert) {
                ORL_PropertyTypeTriggerHandler.onAfterInsert(Trigger.new);
            } else if(trigger.isupdate) {
                 ORL_PropertyTypeTriggerHandler.onAfterUpdate(Trigger.new, Trigger.OldMap);
            }
        }
        
        //TrigFlow: 1 before event
        if(trigger.isbefore) {
            if(trigger.isinsert) {
                ORL_PropertyTypeTriggerHandler.onBeforeInsert(Trigger.new);
            } else if(trigger.isupdate) {
                 ORL_PropertyTypeTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.OldMap);
            }
        }
    }
}
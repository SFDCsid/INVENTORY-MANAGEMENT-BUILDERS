//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
trigger OpportunityTrigger on Opportunity__c (before insert, before update, after update) {
    if(trigger.isBefore && trigger.isInsert)
        OpportunityTriggerHandler.beforeInsert(trigger.new);
    if(trigger.isBefore && trigger.isUpdate)
        OpportunityTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
    if(trigger.isAfter && trigger.isUpdate)
        OpportunityTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
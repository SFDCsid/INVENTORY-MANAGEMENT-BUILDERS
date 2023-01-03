//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
trigger LeadTrigger on Lead__c (before insert, before update, after insert, after update) {
	if(trigger.isBefore && trigger.isInsert)
        LeadTriggerHandler.beforeInsert(trigger.new);
    if(trigger.isAfter && trigger.isInsert)
        LeadTriggerHandler.afterInsert(trigger.new);
    if(trigger.isBefore && trigger.isUpdate)
        LeadTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
    if(trigger.isAfter && trigger.isUpdate)
        LeadTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
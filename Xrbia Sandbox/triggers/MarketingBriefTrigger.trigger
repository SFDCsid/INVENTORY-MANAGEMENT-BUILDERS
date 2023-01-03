//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
trigger MarketingBriefTrigger on Marketing_Brief__c (before update, after update) {
	if(trigger.isBefore && trigger.isUpdate)
        MarketingBriefTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
    if(trigger.isAfter && trigger.isUpdate)
        MarketingBriefTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
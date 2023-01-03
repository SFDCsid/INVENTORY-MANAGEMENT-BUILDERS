//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
trigger CampaignPerformanceTrigger on Campaign_Performance__c (after update) {
    if(trigger.isAfter && trigger.isUpdate)
        CampaignPerformanceTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
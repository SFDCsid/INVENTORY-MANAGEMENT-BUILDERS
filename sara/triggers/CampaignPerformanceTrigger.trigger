trigger CampaignPerformanceTrigger on Campaign_Performance__c (after update) {
    if(trigger.isAfter && trigger.isUpdate)
        CampaignPerformanceTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
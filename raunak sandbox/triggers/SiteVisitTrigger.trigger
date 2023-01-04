trigger SiteVisitTrigger on Site_Visit__c (after update) {
    if(trigger.isAfter && trigger.isUpdate)
        SiteVisitTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
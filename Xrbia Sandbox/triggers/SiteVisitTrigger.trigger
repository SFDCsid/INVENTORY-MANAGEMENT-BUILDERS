//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
trigger SiteVisitTrigger on Site_Visit__c (after update) {
    if(trigger.isAfter && trigger.isUpdate)
        SiteVisitTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
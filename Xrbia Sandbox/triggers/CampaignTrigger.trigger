//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
trigger CampaignTrigger on Campaign__c (after update) {
  if(trigger.isAfter && trigger.isUpdate)
        CampaignTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
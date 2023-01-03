//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 16-11-2022
//-------------------------------------------//
trigger TowerTrigger on Tower__c (before update, after update) {
	if(trigger.isBefore && trigger.isUpdate)
        TowerTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
    if(trigger.isAfter && trigger.isUpdate)
        TowerTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
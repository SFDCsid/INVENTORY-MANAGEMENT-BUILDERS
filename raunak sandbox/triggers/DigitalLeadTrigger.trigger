//-------------------------------------------//
//  Project: Raunak Developers
//  Created By: Exceller Consultancy
//  Created Date: 17-11-2022
//-------------------------------------------//
trigger DigitalLeadTrigger on Digital_Lead__c (after insert, after update) {
	if(trigger.isAfter && trigger.isInsert)
        DigitalLeadTriggerHandler.afterInsert(trigger.new);
    if(trigger.isAfter && trigger.isUpdate)
        DigitalLeadTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
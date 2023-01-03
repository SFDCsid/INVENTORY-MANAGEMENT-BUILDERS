//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 27-10-2022
//-------------------------------------------//
trigger BookingTrigger on Booking__c (after insert,before update, after update) {
    if(trigger.isAfter && trigger.isInsert)
        BookingTriggerHandler.afterInsert(trigger.new);
	if(trigger.isBefore && trigger.isUpdate)
        BookingTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
    if(trigger.isAfter && trigger.isUpdate)
        BookingTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
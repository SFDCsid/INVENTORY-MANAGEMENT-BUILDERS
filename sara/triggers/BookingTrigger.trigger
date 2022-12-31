trigger BookingTrigger on Booking__c (before update, after update) {
	if(trigger.isBefore && trigger.isUpdate)
        BookingTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
    if(trigger.isAfter && trigger.isUpdate)
        BookingTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
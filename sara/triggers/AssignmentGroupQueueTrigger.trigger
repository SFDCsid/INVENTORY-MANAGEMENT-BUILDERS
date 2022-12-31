trigger AssignmentGroupQueueTrigger on Assignment_Group_Queue__c (before insert, before update) {
	if(trigger.isBefore && trigger.isInsert)
        AssignmentGroupQueueTriggerHandler.beforeInsert(trigger.new);
    if(trigger.isBefore && trigger.isUpdate)
        AssignmentGroupQueueTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
}
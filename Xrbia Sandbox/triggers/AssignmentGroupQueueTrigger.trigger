//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
trigger AssignmentGroupQueueTrigger on Assignment_Group_Queue__c (before insert, before update) {
  if(trigger.isBefore && trigger.isInsert)
        AssignmentGroupQueueTriggerHandler.beforeInsert(trigger.new);
    if(trigger.isBefore && trigger.isUpdate)
        AssignmentGroupQueueTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
}
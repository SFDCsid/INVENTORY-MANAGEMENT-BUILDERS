//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
trigger TaskTrigger on Task (before insert, after insert, before update, after update) {
    if(trigger.isBefore && trigger.isInsert)
        TaskTriggerHandler.beforeInsert(trigger.new);
    if(trigger.isAfter && trigger.isInsert)
        TaskTriggerHandler.afterInsert(trigger.new);
    if(trigger.isBefore && trigger.isUpdate)
        TaskTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
    if(trigger.isAfter && trigger.isUpdate)
        TaskTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
trigger AccountTrigger on Account (before insert, before update) {
    if(trigger.isBefore && trigger.isInsert)
        AccountTriggerHandler.beforeInsert(trigger.new);
    if(trigger.isBefore && trigger.isUpdate)
        AccountTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
}
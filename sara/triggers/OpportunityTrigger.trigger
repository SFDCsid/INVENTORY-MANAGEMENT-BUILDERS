trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update) {
    if(trigger.isBefore && trigger.isInsert)
        OpportunityTriggerHandler.beforeInsert(trigger.new);
    if(trigger.isAfter && trigger.isInsert)
        OpportunityTriggerHandler.afterInsert(trigger.new);
    if(trigger.isBefore && trigger.isUpdate)
        OpportunityTriggerHandler.beforeUpdate(trigger.oldMap, trigger.newMap);
    if(trigger.isAfter && trigger.isUpdate)
        OpportunityTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
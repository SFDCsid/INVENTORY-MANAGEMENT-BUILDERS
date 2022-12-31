trigger CampaignTrigger on Campaign (after insert, after update) {
	if(trigger.isAfter && trigger.isInsert)
        CampaignTriggerHandler.afterInsert(trigger.new);
    if(trigger.isAfter && trigger.isUpdate)
        CampaignTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
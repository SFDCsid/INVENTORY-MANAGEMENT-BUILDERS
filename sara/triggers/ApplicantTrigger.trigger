trigger ApplicantTrigger on Applicant__c (after insert, after update) {
	if(trigger.isAfter && trigger.isInsert)
        ApplicantTriggerHandler.afterInsert(trigger.new);
    if(trigger.isAfter && trigger.isUpdate)
        ApplicantTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
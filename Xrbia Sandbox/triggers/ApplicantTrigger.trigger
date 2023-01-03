//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 27-10-2022
//-------------------------------------------//
trigger ApplicantTrigger on Applicant__c ( after update) {
	
    if(trigger.isAfter && trigger.isUpdate)
        ApplicantTriggerHandler.afterUpdate(trigger.oldMap, trigger.newMap);
}
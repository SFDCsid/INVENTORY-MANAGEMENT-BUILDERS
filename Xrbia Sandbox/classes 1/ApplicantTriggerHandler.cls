//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 27-10-2022
//-------------------------------------------//
public class ApplicantTriggerHandler {
	
    
    public static void afterUpdate(Map<Id, Applicant__c> oldMap, Map<Id, Applicant__c> newMap) {
        Map<Id, Applicant__c> applicantMap = new Map<Id, Applicant__c>();
        
        for(Applicant__c oldApplicant: oldMap.values()) {
            Applicant__c newApplicant = newMap.get(oldApplicant.Id);
            
            if((oldApplicant.Applicant_Number__c != newApplicant.Applicant_Number__c || oldApplicant.Applicant_Title__c != newApplicant.Applicant_Title__c ||
               oldApplicant.Name != newApplicant.Name || oldApplicant.Mobile_Number__c != newApplicant.Mobile_Number__c ||
               oldApplicant.Email__c != newApplicant.Email__c) && newApplicant.Applicant_Number__c.equalsIgnoreCase('Primary Applicant')) 
            {
                applicantMap.put(newApplicant.Booking__c, newApplicant);
            }
        }
        if(!applicantMap.isEmpty() && applicantMap != null)
            ApplicantHandlerServices.rollUpOnBooking(applicantMap);
    }
}
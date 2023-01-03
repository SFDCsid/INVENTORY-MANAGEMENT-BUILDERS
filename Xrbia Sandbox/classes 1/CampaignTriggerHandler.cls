//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class CampaignTriggerHandler {
    public static void afterUpdate(Map<Id, Campaign__c> oldMap, Map<Id, Campaign__c> newMap) {
        Set<Id> cIdSet = new Set<Id>();
        Set<Id> camIdSet = new Set<Id>();
        Set<Id> mbIdSet = new Set<Id>();
        
        for(Campaign__c oldCam: oldMap.values()) {
            Campaign__c newCam = newMap.get(oldCam.Id);
            
            if(oldCam.Status__c != newCam.Status__c && newCam.Status__c == 'Approved') {
                cIdSet.add(newCam.Id);
                if(newCam.Marketing_Brief__c != null)
                    mbIdSet.add(newCam.Marketing_Brief__c);
            }
            if((oldCam.Amount__c != newCam.Amount__c || oldCam.GST__c != newCam.GST__c || oldCam.Discount__c != newCam.Discount__c || 
                oldCam.Actual_Leads__c != newCam.Actual_Leads__c || oldCam.Actual_Visits__c != newCam.Actual_Visits__c ||
                oldCam.Actual_Bookings__c != newCam.Actual_Bookings__c) && newCam.Active__c && newCam.Marketing_Brief__c != null) 
            {
                camIdSet.add(newCam.Marketing_Brief__c);
            }
        }
        if(!cIdSet.isEmpty() && cIdSet != null)
            CampaignHandlerServices.createCampaignPerformance(cIdSet);
        if(!mbIdSet.isEmpty() && mbIdSet != null)
            CampaignHandlerServices.rollUpOnMarketingBrief(mbIdSet, 'Planned');
       	if(!camIdSet.isEmpty() && camIdSet != null)
            CampaignHandlerServices.rollUpOnMarketingBrief(camIdSet, 'Actual');
    }
}
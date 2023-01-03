//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class CampaignPerformanceTriggerHandler {
    public static void afterUpdate(Map<Id, Campaign_Performance__c> oldMap, Map<Id, Campaign_Performance__c> newMap) {
        Set<Id> cIdSet = new Set<Id>();
        
        for(Campaign_Performance__c oldCP: oldMap.values()) {
            Campaign_Performance__c newCP = newMap.get(oldCP.Id);
            
            if(newCP.Campaign__c != null && (oldCP.Actual_Cost__c != newCP.Actual_Cost__c || oldCP.Actual_Leads__c != newCP.Actual_Leads__c || oldCP.Actual_Enquiries__c != newCP.Actual_Enquiries__c))
                cIdSet.add(newCP.Campaign__c);
        }
        if(!cIdSet.isEmpty() && cIdSet != null)
            CampaignPerformanceHandlerServices.updateCampaignDetails(cIdSet);
    }
}
//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class OpportunityTriggerHandler {
	public static void beforeInsert(List<Opportunity__c> opportunityList) {
        OpportunityHandlerServices.duplicationCheck(opportunityList);
    }
    
    public static void beforeUpdate(Map<Id, Opportunity__c> oldMap, Map<Id, Opportunity__c> newMap) {
        List<Opportunity__c> oppList = new List<Opportunity__c>();
        
        for(Opportunity__c oldOpp: oldMap.values()) {
            Opportunity__c newOpp = newMap.get(oldOpp.Id);
            
            if(oldOpp.Project__c != newOpp.Project__c || oldOpp.AccountId__c != newOpp.AccountId__c)
                oppList.add(newOpp);
        }
        if(!oppList.isEmpty() && oppList != null)
            OpportunityHandlerServices.duplicationCheck(oppList);
    }
    
    public static void afterUpdate(Map<Id, Opportunity__c> oldMap, Map<Id, Opportunity__c> newMap) {
        Set<Id> svCampaignIdSet = new Set<Id>();
        Set<Id> bookingCampaignIdSet = new Set<Id>();
        
        for(Opportunity__c oldOpp: oldMap.values()) {
            Opportunity__c newOpp = newMap.get(oldOpp.Id);
            
            if(oldOpp.Campaign_Custom__c != newOpp.Campaign_Custom__c) {
                if(newOpp.Site_Visit_Count__c > 0) {
                    svCampaignIdSet.add(newOpp.Campaign_Custom__c);
                    svCampaignIdSet.add(oldOpp.Campaign_Custom__c);
                }
                if(newOpp.Booking__c != null) {
                    bookingCampaignIdSet.add(newOpp.Campaign_Custom__c);
                    bookingCampaignIdSet.add(oldOpp.Campaign_Custom__c);
                }
            }
            if(oldOpp.Site_Visit_Count__c != newOpp.Site_Visit_Count__c && newOpp.Campaign_Custom__c != null)
                svCampaignIdSet.add(newOpp.Campaign_Custom__c);
            if(oldOpp.Booking__c != newOpp.Booking__c && newOpp.Campaign_Custom__c != null)
                bookingCampaignIdSet.add(newOpp.Campaign_Custom__c);
        }
        if(!svCampaignIdSet.isEmpty() && svCampaignIdSet != null)
            CampaignHandlerServices.updateCampaignDetails(svCampaignIdSet, 'Site Visit');
        if(!bookingCampaignIdSet.isEmpty() && bookingCampaignIdSet != null)
            CampaignHandlerServices.updateCampaignDetails(bookingCampaignIdSet, 'Booking');
    }
}
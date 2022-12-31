public class OpportunityTriggerHandler {
	public static void beforeInsert(List<Opportunity> opportunityList) {
        OpportunityHandlerServices.duplicationCheck(opportunityList);
    }
    
    public static void afterInsert(List<Opportunity> opportunityList) {
        Set<Id> cIdSet = new Set<Id>();
        
        for(Opportunity op: opportunityList) {
            if(op.Campaign_Custom__c != Null)
                cIdSet.add(op.Campaign_Custom__c);
        }
        if(!cIdSet.isEmpty() && cIdSet != null)
            CampaignHandlerServices.updateCampaignDetails(cIdSet, 'Opportunity');
    }
    
    public static void beforeUpdate(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Opportunity oldOpp: oldMap.values()) {
            Opportunity newOpp = newMap.get(oldOpp.Id);
            
            if(oldOpp.Project__c != newOpp.Project__c || oldOpp.AccountId != newOpp.AccountId)
                oppList.add(newOpp);
        }
        if(!oppList.isEmpty() && oppList != null)
            OpportunityHandlerServices.duplicationCheck(oppList);
    }
    
    public static void afterUpdate(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {
        Set<Id> cIdSet = new Set<Id>();
        Set<Id> svCampaignIdSet = new Set<Id>();
        Set<Id> bookingCampaignIdSet = new Set<Id>();
        
        for(Opportunity oldOpp: oldMap.values()) {
            Opportunity newOpp = newMap.get(oldOpp.Id);
            
            if(oldOpp.Campaign_Custom__c != newOpp.Campaign_Custom__c) {
                cIdSet.add(newOpp.Campaign_Custom__c);
            	cIdSet.add(oldOpp.Campaign_Custom__c);
                
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
        if(!cIdSet.isEmpty() && cIdSet != null)
            CampaignHandlerServices.updateCampaignDetails(cIdSet, 'Opportunity');
        if(!svCampaignIdSet.isEmpty() && svCampaignIdSet != null)
            CampaignHandlerServices.updateCampaignDetails(svCampaignIdSet, 'Site Visit');
        if(!bookingCampaignIdSet.isEmpty() && bookingCampaignIdSet != null)
            CampaignHandlerServices.updateCampaignDetails(bookingCampaignIdSet, 'Booking');
    }
}
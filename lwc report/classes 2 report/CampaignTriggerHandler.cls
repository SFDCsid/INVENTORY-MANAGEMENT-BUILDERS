public class CampaignTriggerHandler {
	
    public static void afterInsert(List<Campaign> campaignList) {
        Set<Id> cIdSet = new Set<Id>();
        Set<Id> parentCampaignIdSet = new Set<Id>();
        
        for(Campaign c: campaignList) {
            if(c.IsActive && c.ParentId != null)
                cIdSet.add(c.Id);
            if(c.ParentId != null)
                parentCampaignIdSet.add(c.parentId);
        }
        if(!cIdSet.isEmpty() && cIdSet != null)
            CampaignHandlerServices.createCampaignPerformance(cIdSet);
        if(!parentCampaignIdSet.isEmpty() && parentCampaignIdSet != null)
            CampaignHandlerServices.updateParenCampaigntDetails(parentCampaignIdSet);
    }
    
    public static void afterUpdate(Map<Id, Campaign> oldMap, Map<Id, Campaign> newMap) {
    	Set<Id> parentCampaignIdSet = new Set<Id>();
         
        for(Campaign oldCampaign: oldMap.values()) {
            Campaign newCampaign = newMap.get(oldCampaign.Id);
            
            if((oldCampaign.Budgeted_Leads__c != newCampaign.Budgeted_Leads__c || oldCampaign.BudgetedCost != newCampaign.BudgetedCost ||
                oldCampaign.ActualCost != newCampaign.ActualCost || oldCampaign.Lead_Count__c != newCampaign.Lead_Count__c ||
                oldCampaign.Enquiry_Count__c != oldCampaign.Enquiry_Count__c || oldCampaign.Converted_Leads_Count__c != newCampaign.Converted_Leads_Count__c ||
                oldCampaign.Site_Visit_Count__c != newCampaign.Site_Visit_Count__c || oldCampaign.Booking_Count__c != newCampaign.Booking_Count__c)
                && newCampaign.ParentId != null)
                parentCampaignIdSet.add(newCampaign.ParentId);
        }
        if(!parentCampaignIdSet.isEmpty() && parentCampaignIdSet != null)
            CampaignHandlerServices.updateParenCampaigntDetails(parentCampaignIdSet);
    }
}
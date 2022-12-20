public class CampaignPerformanceHandlerServices {
    
    public static void updateCampaignDetails(Set<Id> cIdSet) {
        List<Campaign> cList = new List<Campaign>();
        List<Campaign> updateCampaignList = new List<Campaign>();
    	List<AggregateResult> cpList = new List<AggregateResult>();
        Map<Id, Campaign> campaignMap = new Map<Id, Campaign>();
        
        cList = [Select Id, Lead_Count__c, Enquiry_Count__c, ActualCost from Campaign where Id IN: cIdSet];
        system.debug('cList: '+cList);
        
        if(!cList.isEmpty()) {
            for(Campaign c: cList) {
                campaignMap.put(c.Id, c);
            }
        }
        
        cpList = [Select Campaign__c, SUM(Lead_Count__c) leadCount, SUM(Enquiry_Count__c) enqCount, SUM(Amount_Spend__c) amtSpend from Campaign_Performance__c 
                  where Campaign__c IN: cIdSet GROUP BY Campaign__c];
		system.debug('cp: '+cpList);
        
        if(!cpList.isEmpty() && cpList != null) {
            for(AggregateResult ag: cpList) {
                if(campaignMap.containsKey((String) ag.get('Campaign__c'))) {
                    Campaign c = campaignMap.get((String) ag.get('Campaign__c'));
                    
                    c.ActualCost = (Decimal) ag.get('amtSpend');
                    c.Lead_Count__c = (Decimal) ag.get('leadCount');
                    c.Enquiry_Count__c = (Decimal) ag.get('enqCount');
                    updateCampaignList.add(c);
                }
            }
        }
        if(!updateCampaignList.isEmpty() && updateCampaignList != null)
            update updateCampaignList;
    }
}
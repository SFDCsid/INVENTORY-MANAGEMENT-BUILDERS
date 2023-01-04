public class CampaignPerformanceHandlerServices {
    
    public static void updateCampaignDetails(Set<Id> cIdSet) {
        List<Campaign__c> cList = new List<Campaign__c>();
        List<Campaign__c> updateCampaignList = new List<Campaign__c>();
    	List<AggregateResult> cpList = new List<AggregateResult>();
        Map<Id, Campaign__c> campaignMap = new Map<Id, Campaign__c>();
        
        cList = [Select Id, Lead_Count__c, Enquiry_Count__c, Actual_Cost__c from Campaign__c where Id IN: cIdSet];
        system.debug('cList: '+cList);
        
        if(!cList.isEmpty()) {
            for(Campaign__c c: cList) {
                campaignMap.put(c.Id, c);
            }
        }
        
        cpList = [Select Campaign_c__c, SUM(Lead_Count__c) leadCount, SUM(Enquiry_Count__c) enqCount, SUM(Amount_Spend__c) amtSpend from Campaign_Performance__c 
                  where Campaign_c__c IN: cIdSet GROUP BY Campaign_c__c];
		system.debug('cp: '+cpList);
        
        if(!cpList.isEmpty() && cpList != null) {
            for(AggregateResult ag: cpList) {
                if(campaignMap.containsKey((String) ag.get('Campaign_c__c'))) {
                    Campaign__c c = campaignMap.get((String) ag.get('Campaign_c__c'));
                    
                    c.Actual_Cost__c = (Decimal) ag.get('amtSpend');
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
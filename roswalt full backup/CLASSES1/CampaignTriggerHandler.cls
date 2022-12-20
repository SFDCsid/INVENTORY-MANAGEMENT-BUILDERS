public class CampaignTriggerHandler {
	
    public static void afterInsert(List<Campaign> campaignList) {
        Set<Id> cIdSet = new Set<Id>();
        
        for(Campaign c: campaignList) {
            if(c.IsActive)
                cIdSet.add(c.Id);
        }
        if(!cIdSet.isEmpty() && cIdSet != null)
            CampaignHandlerServices.createCampaignPerformance(cIdSet);
    }
}
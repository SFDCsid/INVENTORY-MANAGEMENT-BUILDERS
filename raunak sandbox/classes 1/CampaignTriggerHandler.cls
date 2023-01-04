public class CampaignTriggerHandler {
    
    public static void afterInsert(List<Campaign__c> campaignList) {
        Set<Id> cIdSet = new Set<Id>();
        
        for(Campaign__c c: campaignList) {
            //if(c.Active__c)
                cIdSet.add(c.Id);
        
        if(!cIdSet.isEmpty() && cIdSet != null)
            CampaignHandlerServices.createCampaignPerformance(cIdSet);
        }
    } 
    
    public static void AfterUpdate(Map<Id, Campaign__c> oldMap, Map<Id, Campaign__c> newMap) {
        Set<Id> upcIdSet = new Set<Id>();
        
        for(Campaign__c oldCam : oldMap.values()) {
            Campaign__c newCam = newMap.get(oldCam.Id);
            if(oldCam.Extension_Approval_Status__c != newCam.Extension_Approval_Status__c && newCam.Extension_Approval_Status__c == 'Approved'){
                upcIdSet.add(newCam.Id);
            }
        }
        if(!upcIdSet.isEmpty() && upcIdSet!= null)
            CampaignHandlerServices.UpdateCampaignPerformance(upcIdSet);
    }
          
}
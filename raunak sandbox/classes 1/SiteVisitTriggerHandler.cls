public class SiteVisitTriggerHandler {
    
    public static void afterUpdate(Map<Id, Site_Visit__c> oldMap, Map<Id, Site_Visit__c> newMap) {
        Set<Id> uIdSet = new Set<Id>();
        
        for(Site_Visit__c oldSV: oldMap.values()) {
            Site_Visit__c newSV = newMap.get(oldSV.Id);
            
            if(oldSV.SM_Comment__c != newSV.SM_Comment__c && newSV.SM_Comment__c != null)
                uIdSet.add(newSV.Sales_Manager__c);
        }
        if(!uIdSet.isEmpty() && uIdSet != null)
            SiteVisitHandlerServices.updateSalesManagerAvailability(uIdSet);
    }
}
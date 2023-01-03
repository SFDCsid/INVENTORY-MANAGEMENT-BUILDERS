//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class SiteVisitTriggerHandler {
    public static void afterUpdate(Map<Id, Site_Visit__c> oldMap, Map<Id, Site_Visit__c> newMap) {
        Set<Id> uIdSet = new Set<Id>();
        
        for(Site_Visit__c oldSV: oldMap.values()) {
            Site_Visit__c newSV = newMap.get(oldSV.Id);
            
            if(oldSV.Comments__c != newSV.Comments__c && newSV.Comments__c != null)
                uIdSet.add(newSv.Sales_Manager__c);
        }
        if(!uIdSet.isEmpty() && uIdSet != null)
            SiteVisitHandlerServices.updateSalesManagerAvailability(uIdSet);
    }
}
public class SiteVisitTriggerHandler {
    public static void beforeInsert(List<Site_Visit__c> svList) {
        List<Site_Visit__c> siteVisitList = new List<Site_Visit__c>();
        
        for(Site_Visit__c sv: svList) {
            if(sv.Sales_Manager__c == null && sv.Project__c != null && sv.Opportunity__c != null) {
                siteVisitList.add(sv);
            }
        }
        if(!siteVisitList.isEmpty() && siteVisitList != null)
            SiteVisitHandlerServices.applyRoundRobin(siteVisitList);
    }
    
    public static void afterUpdate(Map<Id, Site_Visit__c> oldMap, Map<Id, Site_Visit__c> newMap) {
        Map<Id, List<Site_Visit__c>> uIdSVMap = new Map<Id, List<Site_Visit__c>>();
        
        for(Site_Visit__c oldSV: oldMap.values()) {
            Site_Visit__c newSV = newMap.get(oldSV.Id);
            
            if(oldSV.Sales_Manager_Feedback__c != newSV.Sales_Manager_Feedback__c && newSV.Sales_Manager_Feedback__c != null) {
                if(uIdSVMap.containsKey(newSV.Sales_Manager__c)) {
                    uIdSVMap.get(newSV.Sales_Manager__c).add(newSV);
                } else {
                    List<Site_Visit__c> newList = new List<Site_Visit__c>();
                    newList.add(newSV);
                    uIdSVMap.put(newSV.Sales_Manager__c, newList);
                }
            }
            if(oldSV.Sales_Manager__c != newSV.Sales_Manager__c && newSV.Sales_Manager__c != null && newSV.RR_Assignment_Type__c.equalsIgnoreCase('Manual Assignment')) {
                if(uIdSVMap.containsKey(newSV.Sales_Manager__c)) {
                    uIdSVMap.get(newSV.Sales_Manager__c).add(newSV);
                } else {
                    List<Site_Visit__c> newList = new List<Site_Visit__c>();
                    newList.add(newSV);
                    uIdSVMap.put(newSV.Sales_Manager__c, newList);
                }
            }
        }
        if(!uIdSVMap.isEmpty() && uIdSVMap != null)
            SiteVisitHandlerServices.updateSalesManagerAvailability(uIdSVMap);
    }
}
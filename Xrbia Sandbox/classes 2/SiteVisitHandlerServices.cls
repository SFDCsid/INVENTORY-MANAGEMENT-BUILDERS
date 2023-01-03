//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class SiteVisitHandlerServices {
    public static void updateSalesManagerAvailability(Set<Id> uIdSet) {
        List<Team_Member__c> tmList = new List<Team_Member__c>();
        List<Team_Member__c> updateTMList = new List<Team_Member__c>();
        
        tmList = [Select Id, Availability__c, User__c from Team_Member__c 
                  where User__c IN: uIdSet AND Availability__c = false AND Team__r.Team_Type__c = 'Sales Team'];
        
        if(!tmList.isEmpty() && tmList != null) {
            for(Team_Member__c tm: tmList) {
                tm.Availability__c = true;
                updateTMList.add(tm);
            }
        }
        if(!updateTMList.isEmpty() && updateTMList != null)
            update updateTMList;
    }
}
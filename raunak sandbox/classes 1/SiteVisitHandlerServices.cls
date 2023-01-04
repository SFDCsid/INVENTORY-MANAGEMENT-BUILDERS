public class SiteVisitHandlerServices {
  
    public static void updateSalesManagerAvailability(Set<Id> uIdSet) {
        List<Team_Members__c> tmList = new List<Team_Members__c>();
        List<Team_Members__c> updateTMList = new List<Team_Members__c>();
        
        tmList = [Select Id, Availability__c, User__c from Team_Members__c 
                  where User__c IN: uIdSet AND Availability__c =: false AND Team__r.Team_Type__c =: 'Sales Team'];
        
        system.debug('Team :' +tmList);
        
        system.debug('User :' +uIdSet);
        
        if(!tmList.isEmpty() && tmList != null) {
            for(Team_Members__c tm: tmList) {
                tm.Availability__c = true;
                updateTMList.add(tm);
            }
        }
        if(!updateTMList.isEmpty() && updateTMList != null)
            update updateTMList;
    }
}
public class BookingHandlerServices {
    public static void getApprovalDetails(Map<Id, List<Booking__c>> bookingMap) {
        Map<Id, List<Team_Members__c>> approverMap = new Map<Id, List<Team_Members__c>>();
        List<Team_Members__c> tmList = new List<Team_Members__c>();
        List<Booking__c> bList = new List<Booking__c>();
        
        
        approverMap = getCancellationApprovalTeam(bookingMap.keySet());
        
        for(Id pId: bookingMap.keySet()) {
            if(approverMap.containsKey(pId)) {
                tmList = approverMap.get(pId);
                
                if(!tmList.isEmpty() && tmList != null) {
                    bList = bookingMap.get(pId);
                    
                    for(Booking__c b: bList) {
                        for(Integer i = 1; i <= tmList.size(); i++) {
                            b.put('Booking_Cancellation_Approver_'+i+'__c', tmList[i-1].User__c);
                        }
                    }
                }
            }
        }
    }
    
    public static void bookingCancellation(List<Booking__c> bList) {
        Set<Id> uIdSet = new Set<Id>();
        Set<Id> oIdSet = new Set<Id>();
        List<Unit__c> updateUnitList = new List<Unit__c>();
        List<Opportunity> updateOpportunityList = new List<Opportunity>();
        
        for(Booking__c b: bList) {
            if(b.Unit__c != null)
                uIdSet.add(b.Unit__c);
            if(b.Opportunity__c != null)
                oIdSet.add(b.Opportunity__c);
        }
        
        if(!uIdSet.isEmpty() && uIdSet != null) {
            List<Unit__c> uList = [Select Id, Name, Opportunity__c, Booking__c, Unit_Status__c from Unit__c where Id IN: uIdSet];
            system.debug('uList: '+uList);
            
            if(uList != null) {
                for(Unit__c u: uList) {
                    u.Unit_Status__c = 'Vacant';
                    u.Opportunity__c = null;
                    u.Booking__c = null;
                    updateUnitList.add(u);
                }
            }
        }
        
        if(!oIdSet.isEmpty() && oIdSet != null) {
            List<Opportunity> oppList = [Select Id, Name, StageName from Opportunity where Id IN: oIdSet];
            system.debug('oppList: '+oppList);
            
            if(oppList != null) {
                for(Opportunity op: oppList) {
                    op.StageName = 'Booking Cancelled';
                    updateOpportunityList.add(op);
                }
            }
        }
        if(!updateUnitList.isEmpty() && updateUnitList != null)
            update updateUnitList;
        if(!updateOpportunityList.isEmpty() && updateOpportunityList != null)
            update updateOpportunityList;
    }
    
    public static Map<Id, List<Team_Members__c>> getCancellationApprovalTeam(Set<Id> pIdSet) {
        Map<Id, List<Team_Members__c>> approverMap = new Map<Id, List<Team_Members__c>>();
        List<Team_Members__c> tmList = new List<Team_Members__c>();
        
        tmList = [Select Id, Name, User__c, Sequence_Number__c, User_Active_Status__c, Availability__c, Team__r.Project__c from Team_Members__c
                  where Team__r.Project__c IN: pIdSet AND Team__r.Team_Type__c = 'Cancellation Team' AND User_Active_Status__c = true ORDER BY Sequence_Number__c ASC];
        system.debug('tmList: '+tmList);
        
        if(!tmList.isEmpty() && tmList != null) {
            for(Team_Members__c tm: tmList) {
                if(!approverMap.containsKey(tm.Team__r.Project__c)) {
                    List<Team_Members__c> newList = new List<Team_Members__c>();
                    newList.add(tm);
                    approverMap.put(tm.Team__r.Project__c, newList);
                } else {
                    approverMap.get(tm.Team__r.Project__c).add(tm);
                }
            }
        }
        return approverMap;
    }
}
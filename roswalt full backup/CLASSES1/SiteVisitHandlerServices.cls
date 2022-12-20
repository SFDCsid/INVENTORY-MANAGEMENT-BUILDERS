public class SiteVisitHandlerServices {
    public static void applyRoundRobin(List<Site_Visit__c> siteVisitList) {
        List<Team_Members__c> teamMemberList = new List<Team_Members__c>();
        
        for(Site_Visit__c sv: siteVisitList) {
            if(sv.SV_Count__c == 1) {
            	// Fresh Visit Logic
                teamMemberList = getProjectTeamMemberList(sv.Project__c, null, 'Active');
                
                if(!teamMemberList.isEmpty() && teamMemberList != null) {
                    sv.Sales_Manager__c = teamMemberList[0].User__c;
                    sv.RR_Assignment_Type__c = 'Round Robin Available';
                    DateTime now = DateTime.now();
                    teamMemberList[0].Last_Assignment_DateTime__c = now;
                    teamMemberList[0].Last_Assigned_Milliseconds__c = now.millisecondGMT();
                    teamMemberList[0].Availability__c = false;
                    teamMemberList[0].Assignment_Counter__c = teamMemberList[0].Assignment_Counter__c + 1;
                    update teamMemberList[0];
                } else {
                    teamMemberList = getProjectTeamMemberList(sv.Project__c, null, 'Inactive');
                	
                    if(!teamMemberList.isEmpty() && teamMemberList != null) {
                        sv.Sales_Manager__c = teamMemberList[0].User__c;
                        sv.RR_Assignment_Type__c = 'Round Robin Not Available';
                        DateTime now = DateTime.now();
                        teamMemberList[0].Last_Assignment_DateTime__c = now;
                        teamMemberList[0].Last_Assigned_Milliseconds__c = now.millisecondGMT();
                        teamMemberList[0].Availability__c = false;
                        teamMemberList[0].Assignment_Counter__c = teamMemberList[0].Assignment_Counter__c + 1;
                        update teamMemberList[0];
                    }
                }
            } else {
                // Revisit Logic
                Opportunity op = [Select Id, Name, OwnerId, Owner.ManagerId from Opportunity where Id =: sv.Opportunity__c];
                teamMemberList = getProjectTeamMemberList(sv.Project__c, op.OwnerId, 'Revisit Owner');
                
                if(!teamMemberList.isEmpty() && teamMemberList != null) {
                    sv.Sales_Manager__c = teamMemberList[0].User__c;
                    sv.RR_Assignment_Type__c = 'Revisit Owner';
                    DateTime now = DateTime.now();
                    teamMemberList[0].Last_Assignment_DateTime__c = now;
                    teamMemberList[0].Last_Assigned_Milliseconds__c = now.millisecondGMT();
                    teamMemberList[0].Availability__c = false;
                    teamMemberList[0].Assignment_Counter__c = teamMemberList[0].Assignment_Counter__c + 1;
                    update teamMemberList[0];
                } else {
                    teamMemberList = getProjectTeamMemberList(sv.Project__c, op.Owner.ManagerId, 'Revisit Owner Manager');
                    
                    if(!teamMemberList.isEmpty() && teamMemberList != null) {
                        sv.Sales_Manager__c = teamMemberList[0].User__c;
                        sv.RR_Assignment_Type__c = 'Revisit Owner Manager';
                        DateTime now = DateTime.now();
                        teamMemberList[0].Last_Assignment_DateTime__c = now;
                        teamMemberList[0].Last_Assigned_Milliseconds__c = now.millisecondGMT();
                        teamMemberList[0].Availability__c = false;
                        teamMemberList[0].Assignment_Counter__c = teamMemberList[0].Assignment_Counter__c + 1;
                        update teamMemberList[0];
                    } else {
                        Project__c pro = [Select Id, Name, Site_Head__c from Project__c where Id =: sv.Project__c];
                        sv.Sales_Manager__c = pro.Site_Head__c;
                        sv.RR_Assignment_Type__c = 'Revisit Site Head';
                    }
                }
            }
        }
    }
    
    public static List<Team_Members__c> getProjectTeamMemberList(Id pId, Id uId, String memberType) {
        List<Team_Members__c> tmList = new List<Team_Members__c>();
        
        if(memberType.equalsIgnoreCase('Active')) {
            tmList = [Select Id, Team__c, Team__r.Project__c, User__c, Last_Assignment_DateTime__c, Last_Assigned_Milliseconds__c, Assignment_Counter__c from Team_Members__c
                      where Team__r.Project__c =: pId AND IsActive__c = true AND Availability__c = true AND Team__r.Team_Type__c = 'Sales Team' 
                      ORDER BY Last_Assignment_DateTime__c, Last_Assigned_Milliseconds__c];
            system.debug('tmList: '+tmList);
        } else if(memberType.equalsIgnoreCase('Inactive')) {
            tmList = [Select Id, Team__c, Team__r.Project__c, User__c, Last_Assignment_DateTime__c, Last_Assigned_Milliseconds__c, Assignment_Counter__c from Team_Members__c
                      where Team__r.Project__c =: pId AND IsActive__c = true AND Availability__c = false AND Team__r.Team_Type__c = 'Sales Team' 
                      ORDER BY Last_Assignment_DateTime__c, Last_Assigned_Milliseconds__c];
            system.debug('tmList: '+tmList);
        } else if(memberType.equalsIgnoreCase('Revisit Owner') || memberType.equalsIgnoreCase('Revisit Owner Manager')) {
            tmList = [Select Id, Team__c, Team__r.Project__c, User__c, User__r.ManagerId, Last_Assignment_DateTime__c, Last_Assigned_Milliseconds__c, Assignment_Counter__c from Team_Members__c
                      where Team__r.Project__c =: pId AND IsActive__c = true AND Availability__c = true AND User__c =: uId AND Team__r.Team_Type__c = 'Sales Team'];
            system.debug('tmList: '+tmList);
        }
        return tmList;
    }
    
    public static void updateSalesManagerAvailability(Map<Id, List<Site_Visit__c>> uIdSVMap) {
        List<Team_Members__c> tmList = new List<Team_Members__c>();
        List<Team_Members__c> updateTMList = new List<Team_Members__c>();
        
        tmList = [Select Id, Availability__c, User__c, Assignment_Counter__c from Team_Members__c 
                  where User__c IN: uIdSVMap.keySet() AND Availability__c = false AND Team__r.Team_Type__c = 'Sales Team'];
        
        if(!tmList.isEmpty() && tmList != null) {
            for(Team_Members__c tm: tmList) {
                if(uIdSVMap.containsKey(tm.User__c)) {
                    if(tm.Assignment_Counter__c < uIdSVMap.get(tm.User__c).size())
                        tm.Assignment_Counter__c = 0;
                    else
                    	tm.Assignment_Counter__c = tm.Assignment_Counter__c - uIdSVMap.get(tm.User__c).size();
                    if(tm.Assignment_Counter__c == 0)
                        tm.Availability__c = true;
                	updateTMList.add(tm);
                }
            }
        }
        if(!updateTMList.isEmpty() && updateTMList != null)
            update updateTMList;
    }
}
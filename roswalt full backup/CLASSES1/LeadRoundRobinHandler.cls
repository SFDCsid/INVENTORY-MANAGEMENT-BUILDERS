public class LeadRoundRobinHandler {
    //public string regionCode{get;set;}
   
    /*public List<Lead> lstLead {get;set;}
    public List<Team__c> lstTeam {get;set;}
    public List<Team_Members__c> lstTeamMember {get;set;}
    public Map<string, List<Id>> mapLeadList {get;set;}
    public Map<Id,List<sObject>> mapTeamMember{get;set;}
   
    public LeadRoundRobinHandler()
    {
       
       
        lstLead = new List<Lead>();
        lstTeam = new List<Team__c>();
        lstTeamMember = new List<Team_Members__c>();
        mapLeadList = new Map<string, List<Id>>();
        mapTeamMember = new Map<Id,List<sObject>>();
    }
   
    public static void roundRobinAssignment(List<Lead> leadListRoundRobin)
    {
        Decimal modResult = 0;
        String regionCode;
        String region;
        system.debug('Lead Received : ' + leadListRoundRobin);
        Map<string, List<Lead>> mapLeadList = new Map<string, List<Lead>>();
        Map<Id, List<Team_Members__c>> mapTeamMember = new Map<Id, List<Team_Members__c>>();
        List<Team__c> lstTeam = new List<Team__c>();
        List<Team_Members__c> lstTeamMember = new List<Team_Members__c>();
        List<Team_Members__c> lstTeamMemberForRoundRobin = new List<Team_Members__c>();
        List<Lead> lstAssignOwner = new List<Lead>();
       
        lstTeam = [Select Name,OwnerId, Project__c,Team_ID__c,Team_Type__c
                   from Team__c where Team_Type__c = 'Presales Team'];
       
        lstTeamMember = [Select Name, OwnerId, Availability__c, Sequence_Number__c,Team__c,User__c, IsActive__c
                         from Team_Members__c  where IsActive__c= true];
       
       system.debug('team : ' + lstTeam);
       system.debug('team member: ' + lstTeamMember);
         
        for(Team_Members__c tm: lstTeamMember)
        {
            if(mapTeamMember.containsKey(tm.Team__c))
            {
                mapTeamMember.get(tm.Team__c).Add(tm);
            }
            else
            {
                List<Team_Members__c> tempLstTM = new List<Team_Members__c>();
                tempLstTM.add(tm);
                mapTeamMember.put(tm.Team__c, tempLstTM);
            }
        }
        system.debug('Team Member Map:'+mapTeamMember);
      
        if(!leadListRoundRobin.isEmpty())
        {
            system.debug('Lead List Round Robin:'+leadListRoundRobin.size());
            for(Lead lsg: leadListRoundRobin)
            {
                 
                if(lsg.Project__c != NULL){
                if(mapLeadList.containsKey(lsg.Project__c))
                {
                    mapLeadList.get(lsg.Project__c).add(lsg);
                }
                else
                {
                    List<Lead> tempLSG = new List<Lead>();
                    tempLSG.add(lsg);
                    mapLeadList.put(lsg.Project__c,tempLSG);
                }
            }
            }
            system.debug('Lead Map: '+mapLeadList);
            if(!lstTeam.isEmpty())
            {
                for(Team__c t: lstTeam)
                {
                    if(mapLeadList.containsKey(t.Project__c))
                    {
                        lstTeamMemberForRoundRobin = mapTeamMember.get(t.id);
                        lstAssignOwner = mapLeadList.get(t.Project__c);
                        system.debug('Assign Owner list: '+ lstAssignOwner);
                        system.debug('List of Team Member For Round Robin: '+ lstTeamMemberForRoundRobin);
                    }
                }
               
                if(lstTeamMemberForRoundRobin != Null &&  !lstTeamMemberForRoundRobin.isEmpty())
                
                {
                    List<Lead> tempLeadUpdate = new List<Lead>();
                    system.debug(lstAssignOwner.size());
                    system.debug(lstAssignOwner);
                    for(Lead lsg : lstAssignOwner)
                    {  
                       
                       modResult = math.mod(Integer.valueOf(lsg.Lead_Seq__c) ,lstTeamMemberForRoundRobin.size());
                        for(Team_Members__c tm : lstTeamMemberForRoundRobin)
                        {  
                        if(tm.Sequence_Number__c != Null)
                        {
                     system.debug('Lead Seq:: '+lsg.Lead_Seq__c+' :: Mod Result:: '+ modResult);
                                if(tm.Sequence_Number__c == modResult )
                                    lsg.OwnerId = tm.User__c;
                              system.debug(lsg.OwnerId);
                                tempLeadUpdate.add(lsg);
                        }
                       }
                    }
                }
            }
        }
  }*/
}
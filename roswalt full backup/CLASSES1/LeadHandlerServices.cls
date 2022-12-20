public class LeadHandlerServices {
    /*public static void validationCheck(List<Lead> leadList) {
        for(Lead l: leadList) {
            if(l.MobilePhone == null) {
                l.addError('Please Provide Mobile.');
            } else {
                if(l.MobilePhone.length() != 10) {
                    l.addError('Please Provide Proper Mobile with 10 Digit.');
                }
            }
            if(l.Phone != null) {
                if(l.Phone.length() != 10) {
                    l.addError('Please Provide Proper Phone with 10 Digit.');
                }
            }
            if(l.Email != null) {
                String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
                Pattern MyPattern = Pattern.compile(emailRegex);
            	Matcher MyMatcher = MyPattern.matcher(l.Email);
            
                if(!MyMatcher.matches()) {
                	l.addError('Please Provide Proper Email.');
                }
            }
            if(l.Alternate_Email__c != null) {
                String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
                Pattern MyPattern = Pattern.compile(emailRegex);
            	Matcher MyMatcher = MyPattern.matcher(l.Alternate_Email__c);
            
                if(!MyMatcher.matches()) {
                	l.addError('Please Provide Proper Email.');
                }
            }
        }
    }*/
    
    public static void duplicationCheck(List<Lead> leadList) {
        Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
        Map<Id, List<Lead>> projectLeadMap = new Map<Id, List<Lead>>();
        
        for(Lead l: leadList) {
            String errMsg = '';
            if(duplicateWrapperMap.containsKey(l)) {
                for(DuplicationHandlerServices.duplicateWrapper dw: duplicateWrapperMap.get(l)) {
                    if(dw.objectType.equalsIgnoreCase('Lead'))
                        errMsg = 'Duplicate Lead Found with Name: '+dw.dupLead.LastName+' & Id: '+dw.dupLead.Lead_Id__c;
                    else if(dw.objectType.equalsIgnoreCase('Opportunity'))
                        errMsg = 'Duplicate Opportunity Found with Name: '+dw.dupOpp.Name+' & Id: '+dw.dupOpp.Opportunity_Id__c;
                }
                if(!test.isRunningTest() && errMsg != null)
                    l.addError(errMsg);
            } else {
                if(l.Apply_Round_Robin__c && l.Project__c != null) {
                    if(projectLeadMap.containsKey(l.Project__c)) {
                        projectLeadMap.get(l.Project__c).add(l);
                    } else {
                        List<Lead> newList = new List<Lead>();
                        newList.add(l);
                        projectLeadMap.put(l.Project__c, newList);
                    }
                }
            }
        }
        if(!projectLeadMap.isEmpty() && projectLeadMap != null)
            applyRoundRobinLogic(projectLeadMap);
    }
    
    public static void applyRoundRobinLogic(Map<Id, List<Lead>> projectLeadMap) {
        Map<Id, List<Team_Members__c>> projectTeamMemberMap = new Map<Id, List<Team_Members__c>>();
        Map<Id, Team_Members__c> memberMapToUpdate = new Map<Id, Team_Members__c>();
        
        projectTeamMemberMap = getProjectTeamMemberMap(projectLeadMap.keySet());
        system.debug('projectTeamMemberMap: '+projectTeamMemberMap);
        
        for(Id pId: projectLeadMap.keySet()) {
            List<Lead> leadList = projectLeadMap.get(pId);
            List<Team_Members__c> tmList = projectTeamMemberMap.get(pId);
            
            Integer index = 0;
            for(Lead l: leadList) {
                // Pick the next person to be assigned
                if(tmList != null) {
                    Team_Members__c member = tmList.get(Math.mod(index, tmList.size()));
                    
                    l.OwnerId = member.User__c;
                    DateTime now = DateTime.now();
                    member.Last_Assignment_DateTime__c = now;
                    member.Last_Assigned_Milliseconds__c = now.millisecondGMT();
                    member.Assignment_Counter__c = member.Assignment_Counter__c + 1;
                    memberMapToUpdate.put(member.Id, member);
                    index++;
                }
            }
        }
        if(!memberMapToUpdate.isEmpty() && memberMapToUpdate != null) {
            List<Team_Members__c> updateTMList = memberMapToUpdate.values();
            update updateTMList;
        }
    }
    
    public static Map<Id, List<Team_Members__c>> getProjectTeamMemberMap(Set<Id> pIdSet) {
        Map<Id, List<Team_Members__c>> projectTeamMemberMap = new Map<Id, List<Team_Members__c>>();
        List<Team_Members__c> tmList = new List<Team_Members__c>();
        
        tmList = [Select Id, Team__c, Team__r.Project__c, User__c, Last_Assignment_DateTime__c, Last_Assigned_Milliseconds__c, Assignment_Counter__c from Team_Members__c
                  where Team__r.Project__c =: pIdSet AND IsActive__c = true AND Availability__c = true AND Team__r.Team_Type__c = 'Presales Team' 
                  ORDER BY Last_Assignment_DateTime__c, Last_Assigned_Milliseconds__c];
        system.debug('tmList: '+tmList);
        
        if(!tmList.isEmpty() && tmList != null) {
            for(Team_Members__c tm: tmList) {
                if(projectTeamMemberMap.containsKey(tm.Team__r.Project__c)) {
                    projectTeamMemberMap.get(tm.Team__r.Project__c).add(tm);
                } else {
                    List<Team_Members__c> newList = new List<Team_Members__c>();
                    newList.add(tm);
                    projectTeamMemberMap.put(tm.Team__r.Project__c, newList);
                }
            }
        }
        return projectTeamMemberMap;
    }
}
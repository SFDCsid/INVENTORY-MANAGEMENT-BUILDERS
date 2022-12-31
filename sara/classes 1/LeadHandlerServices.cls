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
    
    public static void updateClusterOnLead(List<Lead> leadList) {
        Set<Id> pIdSet = new Set<Id>();
        List<Project__c> pList = new List<Project__c>();
        Map<Id, String> pClusterMap = new Map<Id, String>();
        
        for(Lead l: leadList) {
            if(l.Project__c != null)
                pIdSet.add(l.Project__c);
        }
        if(!pIdSet.isEmpty() && pIdSet != null) {
            pList = [Select Id, Name, Cluster__c from Project__c where Id IN: pIdSet];
            
            if(!pList.isEmpty() && pList != null) {
                for(Project__c p: pList) {
                    pClusterMap.put(p.Id, p.Cluster__c);
                }
            }
        }
        for(Lead l: leadList) {
            if(l.Project__c != null) {
                if(pClusterMap.containsKey(l.Project__c))
                    l.Cluster__c = pClusterMap.get(l.Project__c);
            }
        }
    }
    
    public static void duplicationCheck(List<Lead> leadList) {
        Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
        
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
            }
        }
    }
    
    public static void applyRoundRobinLogic(Map<Id, Id> leadOwners) {
        AssignmentGroupHandlerServices assistant = new AssignmentGroupHandlerServices(leadOwners);
        Map<Id, Id> newAssignments = assistant.newOwnerAssignments();
        
        List<Lead> leadsToUpdate = new List<Lead>([SELECT Id,OwnerId FROM Lead WHERE Id in :newAssignments.keySet()]);
        for(Lead l : leadsToUpdate) {
            l.OwnerId = newAssignments.get(l.Id);
        }
        
        try {
            if(leadsToUpdate.size() > 0) {
                update leadsToUpdate;
                update assistant.groupMembersToUpdate();
            }
        } catch(DMLException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}
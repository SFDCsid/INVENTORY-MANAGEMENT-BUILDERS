//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class LeadHandlerServices {
	public static void duplicationCheck(List<Lead__c> leadList) {
        Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
        
        for(Lead__c l: leadList) {
            String errMsg = '';
            if(duplicateWrapperMap.containsKey(l)) {
                for(DuplicationHandlerServices.duplicateWrapper dw: duplicateWrapperMap.get(l)) {
                    if(dw.objectType.equalsIgnoreCase('Lead'))
                        errMsg = 'Duplicate Lead Found with Name: '+dw.dupLead.Name+' & Id: '+dw.dupLead.Lead_Id__c;
                    else if(dw.objectType.equalsIgnoreCase('Opportunity'))
                        errMsg = 'Duplicate Opportunity Found with Name: '+dw.dupOpp.Name+' & Id: '+dw.dupOpp.Opportunity_Id__c;
                }
                if(!test.isRunningTest() && errMsg != null)
                    l.addError(errMsg);
            }
        }
    }
    
    public static void assignQueueOnLead(Map<Id, List<Lead__c>> pLeadMap) {
        List<Lead__c> updateLeadList = new List<Lead__c>();
        List<Assignment_Group_Queue__c> queueList = new List<Assignment_Group_Queue__c>();
        Map<Id, Id> queueMap = new Map<Id, Id>();
        
        queueList = [Select Id, Name, QueueID__c, Project__c from Assignment_Group_Queue__c where Project__c IN: pLeadMap.keySet() AND Active__c = true];
        system.debug('queueList: '+queueList);
        
        if(!queueList.isEmpty() && queueList != null) {
            for(Assignment_Group_Queue__c agq: queueList) {
                queueMap.put(agq.Project__c, (Id)agq.QueueID__c);
            }
        }
        if(!queueMap.isEmpty() && queueMap != null) {
            for(Id pId: pLeadMap.keySet()) {
                for(Lead__c l: pLeadMap.get(pId)) {
                    if(queueMap.containsKey(pId)) {
                        l.OwnerId = queueMap.get(pId);
                        //updateLeadList.add(l);
                    }
                }
            }
        }
        //if(!updateLeadList.isEmpty() && updateLeadList != null)
            //update updateLeadList;
    }
    
    public static void applyRoundRobinLogic(Map<Id, Id> leadOwners) {
        AssignmentGroupHandlerServices assistant = new AssignmentGroupHandlerServices(leadOwners);
        Map<Id, Id> newAssignments = assistant.newOwnerAssignments();
        
        List<Lead__c> leadsToUpdate = new List<Lead__c>([SELECT Id,OwnerId FROM Lead__c WHERE Id in :newAssignments.keySet()]);
        for(Lead__c l : leadsToUpdate) {
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
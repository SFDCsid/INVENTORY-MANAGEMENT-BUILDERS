//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class AssignmentGroupHandlerServices {
    Map<Id, Id> sobjectToOwnerMap;                         // Sobject ID -> Owner ID
    Map<Id, Id> ownerToAssgnGroupsMap;                     // Owner ID -> Assignment Group ID - via Assignment Group Queue
    Map<Id, Id> sobjectToAssgnGroupMap;                    // Sobject ID -> Assignment Group ID
    Map<Id, List<Id>> assgnGroupToSobjectMap;                // Assignment Group ID -> Sobject IDs[]
    Map<Id, List<Assignment_Group_Member__c>> assgnGroupsToMembersMap;  // Assignment Group ID -> Assignment Group Members[]
    Map<Id, Assignment_Group_Member__c> membersToUpdate;
    
    public AssignmentGroupHandlerServices(Map<Id, Id> sobjectOwners) {
        membersToUpdate = new Map<Id, Assignment_Group_Member__c>();
        sobjectToOwnerMap = sobjectOwners;
    }
    
    // @return Map{Sobject ID -> User ID}
    public Map<Id, Id> newOwnerAssignments() {
        Map<Id, Id> ownerAssignments = new Map<Id, Id>();
        
        for(Id assgnGroupId : assignmentGroupsToSobjects().keyset()) {
            List<Id> sobjectsToAssign = assignmentGroupsToSobjects().get(assgnGroupId);
            List<Assignment_Group_Member__c> groupMembers = assgnGroupsToMembers().get(assgnGroupId);
            
            Integer index = 0;
            
            for(Id lId : sobjectsToAssign) {
                // Pick the next person to be assigned
                Assignment_Group_Member__c member = groupMembers.get(Math.mod(index, groupMembers.size()));
                
                ownerAssignments.put(lId, member.User__c);
                logLastAssignment(member);
                index++;
            }
        }
        return ownerAssignments;
    }
    
    // @return Group members with new last-assigned dates
    public List<Assignment_Group_Member__c> groupMembersToUpdate() {
        return membersToUpdate.values();
    }
    
    // If Assignment_Group_Member__c was used in assignment, change its assignment date and queue for updating
    @TestVisible private void logLastAssignment(Assignment_Group_Member__c member) {
        // Log last assignment datetime
        DateTime now = DateTime.now();
        member.Last_Assigned__c = now;
        member.Last_Assigned_Milliseconds__c = now.millisecondGMT();
        
        Assignment_Group_Member__c tempMember = membersToUpdate.get(member.Id);
        if(tempMember != null) {
            if(tempMember.Last_Assigned__c < member.Last_Assigned__c || (tempMember.Last_Assigned__c == member.Last_Assigned__c && tempMember.Last_Assigned_Milliseconds__c < member.Last_Assigned_Milliseconds__c)) 
            {  // This Group Member has a later assignment
                membersToUpdate.put(member.Id, member);
            }
        } else {
            membersToUpdate.put(member.Id, member);
        }
    }
    
    // @return Map{Assignment Group ID -> List<Assignment Group Members>}
    @TestVisible private Map<Id, List<Assignment_Group_Member__c>> assgnGroupsToMembers() {
        if(assgnGroupsToMembersMap == null) {
            assgnGroupsToMembersMap = new Map<Id, List<Assignment_Group_Member__c>>();
            
            for(Assignment_Group_Member__c member : [Select Assignment_Group__c, User__c, Last_Assigned__c, Last_Assigned_Milliseconds__c
                                                     from Assignment_Group_Member__c
                                                     where Assignment_Group__c in :assignmentGroupsToSobjects().keyset()
                                                     AND User_Available__c = True
                                                     ORDER BY Last_Assigned__c, Last_Assigned_Milliseconds__c]) 
            {
                List<Assignment_Group_Member__c> memberList = assgnGroupsToMembersMap.get(member.Assignment_Group__c);
                if(memberList == null) {
                    memberList = new List<Assignment_Group_Member__c>();
                }
                memberList.add(member);
                assgnGroupsToMembersMap.put(member.Assignment_Group__c, memberList);
            }
        }
        return assgnGroupsToMembersMap;
    }
    
    // Filters the list of sobjects to those who are being reassigned
    // @return Map{Assignment Group ID -> Sobject IDs[]}
    @TestVisible private Map<Id, List<Id>> assignmentGroupsToSobjects() {
        if(assgnGroupToSobjectMap == null) {
            assgnGroupToSobjectMap = new Map<Id, List<Id>>();
            
            for(Id sobjectId : sobjectToOwnerMap.keySet()) {
                Id assgGroupId = ownersToAssignmentGroups().get( sobjectToOwnerMap.get(sobjectId) );
                
                if(assgGroupId != null ) {
                    List<Id> sobjects = assgnGroupToSobjectMap.get(assgGroupId);
                    
                    if(sobjects == null) {
                        sobjects = new List<Id>();
                    }
                    sobjects.add(sobjectId);
                    assgnGroupToSobjectMap.put(assgGroupId, sobjects);
                }
            }
        }
        return assgnGroupToSobjectMap;
    }
    
    // @return Map{Owner ID -> Assignment Group ID}
    @TestVisible private Map<Id, Id> ownersToAssignmentGroups() {
        if(ownerToAssgnGroupsMap == null) {
            ownerToAssgnGroupsMap = new Map<Id, Id>();
            
            List<Assignment_Group_Queue__c> agqs = new List<Assignment_Group_Queue__c>([Select Id, Name, Assignment_Group__c, QueueId__c from Assignment_Group_Queue__c
                                                                                        where Active__c = true AND QueueId__c in :sobjectToOwnerMap.values()]);
            
            for(Assignment_Group_Queue__c agq : agqs) {
                ownerToAssgnGroupsMap.put(agq.QueueId__c, agq.Assignment_Group__c);
            }
        }
        return ownerToAssgnGroupsMap;
    }
}
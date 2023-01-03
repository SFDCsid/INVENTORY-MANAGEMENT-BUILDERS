//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class AssignmentGroupQueueTriggerHandler {
    public static void beforeInsert(List<Assignment_Group_Queue__c> assGroupQueueList) {
        Map<Integer, Assignment_Group_Queue__c> agqsToValidate = new Map<Integer, Assignment_Group_Queue__c>();
        
        Integer index = 0;
        for(Assignment_Group_Queue__c agq: assGroupQueueList) {
            // Continue for new AGQs or when AGQ name changes
            agqsToValidate.put(index, agq);
            index++;
        }
        if(!agqsToValidate.isEmpty() && agqsToValidate != null)
            AssignmentGroupQueueHandlerServices.validateAssignmentGroupQueue(agqsToValidate);
    }
    
    public static void beforeUpdate(Map<Id, Assignment_Group_Queue__c> oldMap, Map<Id, Assignment_Group_Queue__c> newMap) {
        Map<Integer, Assignment_Group_Queue__c> agqsToValidate = new Map<Integer, Assignment_Group_Queue__c>();
        
        Integer index = 0;
        for(Assignment_Group_Queue__c oldAssGroupQueue: oldMap.values()) {
            Assignment_Group_Queue__c newAssGroupQueue = newMap.get(oldAssGroupQueue.Id);
            // Continue for new AGQs or when AGQ name changes
            if(oldAssGroupQueue.Name != newAssGroupQueue.Name) {
                agqsToValidate.put(index, newAssGroupQueue);
            }
            index++;
        }
        if(!agqsToValidate.isEmpty() && agqsToValidate != null)
            AssignmentGroupQueueHandlerServices.validateAssignmentGroupQueue(agqsToValidate);
    }
}
public class AssignmentGroupQueueHandlerServices {
	
    public static void validateAssignmentGroupQueue(Map<Integer, Assignment_Group_Queue__c> agqsToValidate) {
        Map<String, Group> standardQueues = new Map<String, Group>();
        Map<String, String> existingAGQueues = new Map<String, String>();
        
        for(Group q : [SELECT Id,Name FROM Group WHERE Type = 'Queue']) {
            // Todo: may be problematic when two queues have the same name, but different DeveloperNames
            standardQueues.put(q.Name, q);
        }
        
        for(Assignment_Group_Queue__c agq : [Select Name, Assignment_Group__r.Name from Assignment_Group_Queue__c]) {
            existingAGQueues.put(agq.Name, agq.Assignment_Group__r.Name);
        }
        
        for(Integer i : agqsToValidate.keySet()) {
            String agqName = agqsToValidate.get(i).Name;
            
            if(standardQueues.containsKey(agqName)) {  // AG-Queue Name matches a Salesforce Queue
                if(!existingAGQueues.containsKey(agqName)) {  // AG-Queue Name is unique among other AG-Queues
                    Id queueId = standardQueues.get(agqName).Id;
                    agqsToValidate.get(i).QueueId__c = queueId;
                } else {
                    agqsToValidate.get(i).addError('Assignment Group Queue "' + agqName + '" already connected to another Assignment Group ' + existingAGQueues.get(agqName));
                }
            } else {
                agqsToValidate.get(i).addError('Salesforce Queue cannot be found with the name: ' + agqName);
            }
        }
    }
}
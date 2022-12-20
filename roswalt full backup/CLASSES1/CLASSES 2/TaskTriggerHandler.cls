public class TaskTriggerHandler {
	
    public static void beforeInsert(List<Task> taskList) {
        Map<Id, List<Task>> taskMap = new Map<Id, List<Task>>();
        
        for(Task t: taskList) {
            if(Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Presales Call') {
                if(t.whoId != null && t.whoId.getSObjectType().getDescribe().getName() == 'Lead' && String.isBlank(t.CallObject)) {
                    if(!taskMap.containsKey(t.WhoId)) {
                        List<Task> tList = new List<Task>();
                        tList.add(t);
                        taskMap.put(t.WhoId, tList);
                    } else {
                        taskMap.get(t.WhoId).add(t);
                    }
                }
            }
        }
        if(!taskMap.isEmpty() && taskMap != null)
            TaskHandlerServices.validationCheckforPresaleCall(taskMap);
    }
    
    public static void afterInsert(List<Task> taskList) {
        Set<Id> taskIdSet = new Set<Id>();
        List<Task> enqList = new List<Task>();
        
        for(Task t: taskList) {
            if(t.Stage__c != null && Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Presales Call' || Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Sales Call')
                taskIdSet.add(t.Id);
            if(Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'Enquiry' && t.Campaign__c != null && t.Is_New_Lead_Created__c == false)
                enqList.add(t);
            if(Schema.SObjectType.Task.getRecordTypeInfosById().get(t.RecordTypeId).getName() == 'CP Log A Call')
            {
               taskIdSet.add(t.Id); 
            }
        }
        if(!taskIdSet.isEmpty() && taskIdSet != null)
            TaskHandlerServices.CallHandlerServices(taskIdSet);
        if(!taskIdSet.isEmpty() && taskIdSet != null)
            TaskHandlerServices.CallHandlerServices(taskIdSet, 'insert', true);
        if(!enqList.isEmpty() && enqList != null)
           CampaignHandlerServices.calculateCampaignPerformance('Task', null, enqList);
    }
    
    public static void beforeUpdate(Map<Id, Task> oldMap, Map<Id, Task> newMap) {
        Map<Id, List<Task>> taskMap = new Map<Id, List<Task>>();
        
        for(Task oldTask: oldMap.values()) {
            Task newTask = newMap.get(oldTask.Id);
            
            if(oldTask.Stage__c != newTask.Stage__c && newTask.Stage__c != null) {
                if(Schema.SObjectType.Task.getRecordTypeInfosById().get(newTask.RecordTypeId).getName() == 'Presales Call') {
                    if(newTask.whoId != null && newTask.whoId.getSObjectType().getDescribe().getName() == 'Lead') {
                        if(!taskMap.containsKey(newTask.WhoId)) {
                            List<Task> tList = new List<Task>();
                            tList.add(newTask);
                            taskMap.put(newTask.WhoId, tList);
                        } else {
                            taskMap.get(newTask.WhoId).add(newTask);
                        }
                    }
                }
            }
        }
        if(!taskMap.isEmpty() && taskMap != null)
            TaskHandlerServices.validationCheckforPresaleCall(taskMap);
    }
    
    public static void afterUpdate(Map<Id, Task> oldMap, Map<Id, Task> newMap) {
        Set<Id> taskIdSet = new Set<Id>();
        
        for(Task oldTask: oldMap.values()) {
            Task newTask = newMap.get(oldTask.Id);
            
            if(oldTask.Status != newTask.Status && newTask.Status == 'Completed')
                taskIdSet.add(newTask.Id);
        }
            if(!taskIdSet.isEmpty() && taskIdSet != null)
            TaskHandlerServices.CallHandlerServices(taskIdSet, 'update', true);
        
        if(!taskIdSet.isEmpty() && taskIdSet != null)
             TaskHandlerServices.CallHandlerServices(taskIdSet);
    }
}
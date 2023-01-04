trigger TaskTrigger on Task (after insert, after update, before insert, before update) {
    Set<Id> taskId = new Set<Id>();
    boolean count = false;
    List<Task> taskList = new List<Task>();
    Map<Id, List<Task>> taskMap = new Map<Id, List<Task>>();
    
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            for(Task t: Trigger.new) {
                RecordType rt = new RecordType();
                System.debug('Record Type:: '+t.RecordTypeId);
                if(t.RecordTypeId != Null)
                    rt = [Select Id, DeveloperName, Name from RecordType where Id =: t.RecordTypeId];
                System.debug(rt.DeveloperName);
                if(rt.Name == 'Presale Call' || rt.Name == 'Sales Call' || rt.Name == 'Site Visit'|| rt.Name == 'CP Meeting' || rt.Name == 'CP Call') {
                    taskId.add(t.Id);
                    count = true;
                }
                if(rt.Name == 'Enquiry' && t.Campaign_Custom__c != Null ) {
                    taskList.add(t);
                } 
                if(rt.Name == 'Presale Call')
                {
                    if(!taskMap.containsKey(t.whatId)) {
                        List<Task> tList = new List<Task>();
                        tList.add(t);
                        taskMap.put(t.whatId, tList);
                    } else {
                        taskMap.get(t.whatId).add(t);
                    }
                }
                if(rt.Name == 'Sales Call')
                {
                    if(!taskMap.containsKey(t.whatId)) {
                        List<Task> tList = new List<Task>();
                        tList.add(t);
                        taskMap.put(t.whatId, tList);
                    } else {
                        taskMap.get(t.whatId).add(t);
                    }
                }
               /* if(rt.Name == 'Site Visit')
                {
                    if(!taskMap.containsKey(t.whatId)) {
                        List<Task> tList = new List<Task>();
                        tList.add(t);
                        taskMap.put(t.whatId, tList);
                    } else {
                        taskMap.get(t.whatId).add(t);
                    }
                } */
                if(rt.Name == 'CP Meeting')
                {
                    if(!taskMap.containsKey(t.whatId)) {
                        List<Task> tList = new List<Task>();
                        tList.add(t);
                        taskMap.put(t.whatId, tList);
                    } else {
                        taskMap.get(t.whatId).add(t);
                    }
                }
                
                 if(rt.Name == 'CP Call')
                {
                    if(!taskMap.containsKey(t.whatId)) {
                        List<Task> tList = new List<Task>();
                        tList.add(t);
                        taskMap.put(t.whatId, tList);
                    } else {
                        taskMap.get(t.whatId).add(t);
                    }
                }
            }
            if(!taskMap.isEmpty() && taskMap != null)
               // TaskHandlerServices.validationCheckforPresaleCall(taskMap);    
            if(!taskId.isEmpty())
            {
                TaskHandlerServices.CallHandlerServices(taskId,'insert',count);
            }
               
            if(!taskList.isEmpty())
                CampaignHandlerServices.calculateCampaignPerformance('Task', null, taskList);

            
      }
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            for(Task t: Trigger.new) {
                if(trigger.oldMap.get(t.Id).Stage__c != trigger.newMap.get(t.Id).Stage__c)
                {
                    system.debug('Inside trigger update');
                    taskId.add(t.Id);
                    count = true;
                }
                if(trigger.oldMap.get(t.Id).Campaign_Custom__c != trigger.newMap.get(t.Id).Campaign_Custom__c &&   t.Campaign_Custom__c != Null)
                    taskList.add(t);
            }
            if(!taskId.isEmpty())
                TaskHandlerServices.CallHandlerServices(taskId,'update',count);

            if(!taskList.isEmpty())
            {
                system.debug('Campaign update'+ taskList);
                CampaignHandlerServices.calculateCampaignPerformance('Task', null, taskList);
            }    
        }
    }
}
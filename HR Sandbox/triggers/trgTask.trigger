trigger trgTask on Task (after insert, after update, before insert, before update) {
    Set<Id> taskId = new Set<Id>();
    boolean count = false;
    List<Task> taskList = new List<Task>();
    
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            for(Task t: Trigger.new) {
                RecordType rt = new RecordType();
                System.debug('Record Type:: '+t.RecordTypeId);
                if(t.RecordTypeId != Null)
                    rt = [Select Id, DeveloperName, Name from RecordType where Id =: t.RecordTypeId];
                System.debug(rt.DeveloperName);
                if(rt.Name == 'Call' || rt.Name == 'Email' || rt.Name == 'Meeting' || rt.Name == 'Whatsapp') {
                    taskId.add(t.Id);
                    count = true;
                }
                //if(rt.Name == 'Enquiry' && t.Campaign__c != Null && t.Campaign_Code__c != Null && t.Is_New_Lead_Created__c == false) {
                    taskList.add(t);
                }
            
       }
            if(!taskId.isEmpty())
                TaskHandlerServices.CallHandlerServices(taskId,'insert',count);
            //if(!taskList.isEmpty())
                //CampaignHandlerServices.calculateCampaignPerformance('Task', null, taskList);
        }
    
   
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            for(Task t: Trigger.new) {
                if(trigger.oldMap.get(t.Id).Opportunity_Stage__c == Null && trigger.oldMap.get(t.Id).Opportunity_Stage__c != trigger.newMap.get(t.Id).Opportunity_Stage__c)
                {
                    system.debug('Inside trigger update');
                    taskId.add(t.Id);
                    count = true;
                }
            }
            if(!taskId.isEmpty())
                TaskHandlerServices.CallHandlerServices(taskId,'update',count);
        }
    }
}
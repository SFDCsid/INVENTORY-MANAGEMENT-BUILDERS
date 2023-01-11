/**********************************************************************************************************************
Version v1.1 - AKohakade - 6-5-2019 - Added debug log
*********************************************************************************************************************/
trigger TaskTrigger on Task (After Insert, After Update, Before Insert, Before Update) {
     Set<id> tskId = new Set<id>();
     Set<id> oppid= new Set<id>();
     Set<id> taskcti= new Set<id>();
     List<Task> tskToUpdate = new List<Task>();
     if(trigger.isAfter && trigger.isUpdate){
         Id PresalesId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales').getRecordTypeId();    
         for(task tsk :Trigger.new){ 
             tskid.add(tsk.id);
             if(tsk.Status == 'Completed' && tsk.Next_Action_Date__c != null && tsk.RecordTypeId == PresalesId) {   
                 if(tsk.Next_Action_Date__c != Trigger.oldMap.get(tsk.Id).Next_Action_Date__c){ 
                     if(tsk.Status == 'Completed' &&  tsk.Next_Action_Date__c != null){
                         taskcti.add(tsk.id);
                     }   
                 }
             }
         }
         /*v1.1*/System.debug('tskid='+tskid);
         TaskTriggerHandler.updateResidentialLead(tskid);
         if(!taskcti.IsEmpty())
         {
             callOzonetelSchedulerAPI.scheduleCall(taskcti);
         }
         //TaskTriggerHandler.updateLead(tskid);
         //TaskTriggerHandler.updateResidentialOpty(tskid);
     }
      if(trigger.isBefore && trigger.isUpdate){
         TaskTriggerHandler.autoCompleteTaskOnOpportunity(Trigger.New,Trigger.OldMap);
     }
     if(trigger.isBefore && trigger.isInsert){
         System.debug('Inside Before Insert');
         for(task t :Trigger.new){
             System.debug('t.Subject Outside - '+t.Subject);
             if(t.Subject.contains('CTI Manual Dialing') || t.Subject.contains('CTI IncomingCall')){
                 System.debug('t.Subject Inside - '+tskid);
                 t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales').getRecordTypeId();    
             }
             if(t.ActivityDate==null){
                t.ActivityDate = system.today();
             }
               t.ActivityDate = system.today();
             IF(T.WhatId != Null){
                 if(T.WhatId.getSObjectType() == Opportunity.sObjectType){
                      oppid.add(T.WhatId);
                 }
             }
             Else{
                 Break;
             }
             
         }
         if(!oppid.isempty()){
             List<Opportunity> olist = [Select id,Name,Total_Final_Score__c From Opportunity Where Id in: oppid];
             if(olist.size() > 0){
                 for(task t1 :Trigger.new){
                     T1.Total_Final_Score__c = olist[0].Total_Final_Score__c;
                     tskToUpdate.add(t1);
                 }
             }
             //Update tskToUpdate;
         }
     }
}
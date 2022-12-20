public with sharing class leadformRoswaltclass {
    @AuraEnabled
    public static Task updateTask(string activityId ,  string callStage ,  DateTime visitdate , DateTime followupdate , string description ){
       list<Task> updatedTasklist = new  list<Task>();
        list<Lead> leadtoTask = [SELECT  (select id, Next_Followup_date__c , 	Stage__c from Tasks) FROM Lead Where Id =:activityId order by CreatedDate desc limit 1 ];
        string copyId;
        for(Lead getId:leadtoTask){
               copyId = getId.Tasks[0].id;
        }
        system.debug('taskid'+copyId);
        system.debug('needid'+leadtoTask);
            Task tSk = new Task();
            tSk.Id = copyId;
            tSk.Stage__c = callStage;
            tSk.Proposed_Date_of_Visit__c = visitdate;
            tSk.Next_Followup_date__c = followupdate;
            tSk.Description = description;
            updatedTasklist.add(tSk);
        update updatedTasklist;
           // update tSk;
        return tSk;
}


    @AuraEnabled
    public static List<Task> getStage (string activityId){
         List<Task> tasklist = [Select Id,Stage__c,Next_Followup_date__c ,WhoId,Description  From Task Where WhoId =:activityId AND Next_Followup_date__c = null AND Stage__c = null  order by CreatedDate desc limit 1];

         for(Task tsk : tasklist){
            system.debug(tsk);
          
         }
         return taskList;
    }

    @AuraEnabled
    public static List<Task> getButtons (){
        set<string> stagelist = new set<string>();
         list<Task> tklist = [Select Stage__c From Task WHERE task.RecordTypeId = '00N9D0000079JYC'  ];
         for(Task st:tklist){
            stagelist.add(st.Stage__c);
         }
         system.debug(stagelist);
         return tklist;
    }

    @AuraEnabled(cacheable=true)
    public static Task getData (string activity){
      string Id = [SELECT id from RecordType where Name ='Presales Call'].Id;
      system.debug(Id);
         List<Task> tlist = [Select Id,Stage__c,Next_Followup_date__c ,WhoId,Description ,Call_Status__c , recordtype.name  From Task Where WhoId =:activity AND RecordType.Id =: Id AND Next_Followup_date__c = null AND Stage__c = null AND 	Call_Status__c != null ];
         return tlist[0];
    }

   
   // AND recordtype.name = 'Presales Call' AND Next_Followup_date__c = null AND Stage__c = null AND 	Call_Status__c != null 
}
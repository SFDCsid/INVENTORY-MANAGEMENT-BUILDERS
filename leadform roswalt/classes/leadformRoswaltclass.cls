public with sharing class leadformRoswaltclass {
    @AuraEnabled
    public static Task updateTask(string activityId ,  string callStage ,  DateTime visitdate , DateTime followupdate , string description ){
       list<Task> updatedTasklist = new  list<Task>();
        list<Lead> leadtoTask = [SELECT  (select id from Tasks) FROM Lead Where Id =:activityId  ];
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
}

global class createTaskOnCBNA implements Database.Batchable<sObject>{
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string yesterday = string.valueOf(system.today()-1) ;
        string query = 'Select Id, Name, ownerId, project__c , Status, Lead_Stage__c from Lead WHERE  Lead_Stage__c	=  \'' + Label.Lead_Status_Contacted_But_Not_Answering_1  + '\' AND CBNA_Time__c = ' + yesterday ; 
        system.debug(query+'query');
        return database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<Lead> LeadList) {
        creatTask(LeadList);
    }
    
    global void finish(Database.BatchableContext BC) {
    }
    
    
    //Method Added to create Task
    public static void creatTask(list<Lead> ldList) {
        List<task> tList = new List<task>();
        for(Lead ld : ldList){
            Task t = new Task();
            t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Lead').getRecordTypeId();     
            t.Ownerid = ld.OwnerId;
            t.Priority = 'Normal';
            t.Status = 'In Progress';
            t.WhoId = ld.Id;
            t.ActivityDate = Date.Today().addDays(1);
            t.Completion_By_Date__c = DateTime.now().addDays(8);
            t.Stage__c = ld.Lead_Stage__c;
            t.Lead_Status__c = ld.Status;            
            t.Subject='Call Back Customer';
            t.Project__c = ld.Project__c;
            
            tList.add(t);
        }
        insert tList;
    }
}
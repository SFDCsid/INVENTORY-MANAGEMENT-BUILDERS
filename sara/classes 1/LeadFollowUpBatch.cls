global class LeadFollowUpBatch implements Database.Batchable <sObject>, Schedulable, Database.AllowsCallouts {
     
     global List < Lead > start(Database.BatchableContext BC) {
        Date currentTime = system.today();
        
        Datetime currentDatetime = Datetime.now();
        
        Datetime fetchTime = Datetime.valueOf(currentDatetime).addMinutes(60); // adding 60 minutes to current time

        return [SELECT Id, Name, LastName, Company, OwnerId,Presale_Next_Follow_up_Date__c,FirstName FROM Lead WHERE Presale_Next_Follow_up_Date__c >=: currentDatetime and Presale_Next_Follow_up_Date__c <=: fetchTime ];//Presale_Next_Follow_up_Date__c = Today];
     }
    
    global void execute(Database.BatchableContext BC, List < lead > scope) {
        
        System.debug('Lead list::'+ scope);
        
        List < Lead > leadList = new List < Lead >();
        
        Date currentDate = system.Today();
        Date followupDate;
        
        String FName = '';
        String Comp ='' ;
       
        
        if (scope.size()>0 && !scope.isEmpty()) {
            
            CustomNotificationType leadNotification = [SELECT Id,DeveloperName FROM CustomNotificationType WHERE DeveloperName='Next_followup_Notification']; 
               
            for(Lead ld :scope){ 
                if(ld.FirstName != Null)
                    FName = ld.FirstName;
                if(ld.Company != Null)
                    Comp = ld.Company;
                String body = 'Lead ' + FName + ld.LastName ; 
                Messaging.CustomNotification Notification = new Messaging.CustomNotification(); 
                Notification.setNotificationTypeId(leadNotification.id); 
                Notification.setSenderId(Userinfo.getUserId()); 
                Notification.setBody(body); 
                Notification.setTitle('Your Next Follow-up For Today'); 
                Notification.setTargetId(ld.id); 
                Notification.send(new Set<String> {ld.OwnerId}); 
             //leadList.add(ld);
        } 
               
               
            }
        
        
        if(!leadList.isEmpty()){
           // update leadList;
        }
        
     }
    
    global void finish(Database.BatchableContext BC) {}
    
    global void execute(SchedulableContext sc) {
        LeadFollowUpBatch b = new LeadFollowUpBatch(); 
        database.executebatch(b,1);
    }   
    
}
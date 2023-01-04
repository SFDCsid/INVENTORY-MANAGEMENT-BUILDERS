global class CampaignNotifyFollowUpBatch implements Database.Batchable <sObject>, Schedulable, Database.AllowsCallouts {
     
     global List < Campaign__c > start(Database.BatchableContext BC) {
        Date currentTime = system.today();
        
        Date currentDate = Date.Today();
        
        Date fetchTime = Date.valueOf(currentDate).addDays(3); 

        return [SELECT Id,Name,OwnerId,Start_Date__c,End_Date__c FROM Campaign__c WHERE End_Date__c =: fetchTime];
     }
    
    global void execute(Database.BatchableContext BC, List < Campaign__c > scope) {
        
        System.debug('Campaign list::'+ scope);
        
        List < Campaign__c > Campaign = new List < Campaign__c >();
        
        Date currentDate = system.Today();
        Date followupDate;
        
        String FName = '';
        String Comp ='' ;
       
        
        if (scope.size()>0 && !scope.isEmpty()) {
            
            CustomNotificationType CampaignNotification = [SELECT Id,DeveloperName FROM CustomNotificationType WHERE DeveloperName='CampaignOwnerNotification']; 
               
            for(Campaign__c cp :scope){ 
                if(cp.Name != Null)
                    FName = cp.Name;
                String body = 'Campaign ' + FName; 
                Messaging.CustomNotification Notification = new Messaging.CustomNotification(); 
                Notification.setNotificationTypeId(CampaignNotification.id); 
                Notification.setSenderId(Userinfo.getUserId()); 
                Notification.setBody(body); 
                Notification.setTitle('Your Campaign will be End after 3 days'); 
                Notification.setTargetId(cp.id); 
                Notification.send(new Set<String> {cp.OwnerId}); 
             //leadList.add(ld);
        } 
               
               
            }
        
        
       /* if(!leadList.isEmpty()){
           // update leadList;
        } */
        
     }
    
    global void finish(Database.BatchableContext BC) {}
    
    global void execute(SchedulableContext sc) {
        CampaignNotifyFollowUpBatch b = new CampaignNotifyFollowUpBatch(); 
        database.executebatch(b,1);
    }   
    
}
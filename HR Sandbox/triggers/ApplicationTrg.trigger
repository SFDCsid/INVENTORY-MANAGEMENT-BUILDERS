trigger ApplicationTrg on Application_Details__c (before insert,after update,after insert) {

    List<Application_Details__c> aplist = new List<Application_Details__c>();
    List<Application_Details__c> applist = new List<Application_Details__c>();
   
    if(trigger.isInsert){
        
        if(trigger.isAfter){
            for(Application_Details__c app:Trigger.new){
                applist.add(app);
            }
        }
        if(!applist.isEmpty()){
            ApplicationHelper.sendmailtoapp(applist);
        }
        
    }
    
    if(Trigger.isUpdate){
           
      if(Trigger.isAfter){
          for(Application_Details__c ap:Trigger.new){
              if(Trigger.OldMap.get(ap.id).Application_Status__c!=Trigger.NewMap.get(ap.id).Application_Status__c&&Trigger.NewMap.get(ap.id).Application_Status__c=='Application Accepted'){
                  aplist.add(ap);
              }
          }
      }

    }
    if(!aplist.isEmpty()){
        ApplicationHelper.sendApplAcceptedEmail(aplist);
    }
    
 
}
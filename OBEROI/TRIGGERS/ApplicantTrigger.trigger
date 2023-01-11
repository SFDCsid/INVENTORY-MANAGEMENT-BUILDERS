trigger ApplicantTrigger on Applicant__c (after update) {

    Map<String,Applicant__c> appMap = new  Map<String,Applicant__c>();  
    
     if(trigger.isupdate && trigger.isAfter){
          for (Applicant__c a: Trigger.new) {
              if(Trigger.OldMap.get(a.id).Name!=Trigger.NewMap.get(a.id).Name){
                 appMap.put(Trigger.OldMap.get(a.id).Name, a);
              }
          }
         if(!appMap.isEmpty()){
          ApplicantHelper.sendApplicantNameChange(appMap);   
         }
     }
}
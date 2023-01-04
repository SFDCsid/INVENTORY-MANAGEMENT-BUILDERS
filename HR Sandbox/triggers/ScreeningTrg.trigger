trigger ScreeningTrg on Screening_Questionnaire__c (after insert) {
 
    Map<Id,Screening_Questionnaire__c> scMap = new Map<Id,Screening_Questionnaire__c>();
    if(Trigger.isInsert){
           
      if(Trigger.isAfter){
          for(Screening_Questionnaire__c sc:Trigger.new){
              if(sc.Application_Detail__c!=null){
                   scMap.put(sc.Application_Detail__c,sc);
              }
                  
           }
      }

    }
    if(!scMap.isEmpty()){
        ApplicationHelper.updateScreeningCreated(scMap);
    }
    
}
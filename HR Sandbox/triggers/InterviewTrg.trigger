trigger InterviewTrg on Interview__c (before insert,after insert,after update) {

    List<Application_Details__c> appList = new List<Application_Details__c>();
    List<Application_Details__c> appListToUpdate = new List<Application_Details__c>();
    List<Interview__c> intlist=new List<Interview__c>();
    List<Interview__c> intlistToupdate=new List<Interview__c>();
    Set<Id> setids=new Set<Id>(); 
   
     if(Trigger.isInsert){
           
      if(Trigger.isBefore){
          for(Interview__c interview:Trigger.new){    
              appList = [Select Id,Name,Position__r.Interview_Rounds__c,Position__c,Current_Interview_Round__c ,Latest_Interview__c,Latest_Interview__r.Interview_Status__c,
                         Latest_Interview__r.Current_Interview_Round__c,Latest_Interview__r.Feedback_given__c,Latest_Interview__r.Name,
                         Position__r.Interview_Type_1__c,Position__r.interviewer1__c,
                         Position__r.Interview_Type_2__c,Position__r.interviewer2__c,
                         Position__r.Interview_Type_3__c,Position__r.interviewer3__c,
                         Position__r.Interview_Type_4__c,Position__r.interviewer4__c,
                         Position__r.Interview_Type_5__c,Position__r.interviewer5__c,Position__r.Name
                         FROM Application_Details__c WHERE id=:interview.Application_Detail__c];
   
               if(appList[0].Position__c!=null){ 
                  system.debug('Position'+appList[0].Position__c);
                       interview.Interview_Status__c = 'Scheduled';
                       interview.Position__c = appList[0].Position__c;
                //       interview.Interview_Rounds__c = appList[0].Position__r.Interview_Rounds__c;
                  /* if(appList[0].Latest_Interview__c==null||appList[0].Latest_Interview__r.Interview_Status__c=='Cancelled'){
                        interview.Interview_Rounds__c = appList[0].Position__r.Interview_Rounds__c;
                        interview.Current_Interview_Round__c = 1;
                        interview.Interview_Type__c = appList[0].Position__r.Interview_Type_1__c; 
                        interview.Interviewer_Name__c = appList[0].Position__r.interviewer1__c;
                   }*/
                   
               /* if(appList[0].Latest_Interview__c!=null||appList[0].Latest_Interview__r.Interview_Status__c=='Completed'){
                        interview.Interview_Rounds__c = appList[0].Position__r.Interview_Rounds__c;
                        interview.Current_Interview_Round__c = appList[0].Latest_Interview__r.Current_Interview_Round__c+1;
                    
                    if(interview.Current_Interview_Round__c==1){
                        interview.Interview_Type__c = appList[0].Position__r.Interview_Type_1__c; 
                        interview.Interviewer_Name__c = appList[0].Position__r.interviewer1__c; 
                    }
                    if(interview.Current_Interview_Round__c==2){	
                        interview.Interview_Type__c = appList[0].Position__r.Interview_Type_2__c; 
                        interview.Interviewer_Name__c = appList[0].Position__r.interviewer2__c; 
                    }
                    if(interview.Current_Interview_Round__c==3){
                        interview.Interview_Type__c = appList[0].Position__r.Interview_Type_3__c; 
                        interview.Interviewer_Name__c = appList[0].Position__r.interviewer3__c; 
                    }
                    if(interview.Current_Interview_Round__c==4){
                        interview.Interview_Type__c = appList[0].Position__r.Interview_Type_4__c; 
                        interview.Interviewer_Name__c = appList[0].Position__r.interviewer4__c; 
                    }
                    if(interview.Current_Interview_Round__c==5){
                        interview.Interview_Type__c = appList[0].Position__r.Interview_Type_5__c; 
                        interview.Interviewer_Name__c = appList[0].Position__r.interviewer5__c; 
                    }
                 }*/

                   if(appList[0].Latest_Interview__c!=null&&appList[0].Latest_Interview__r.Interview_Status__c!='Completed' && appList[0].Latest_Interview__r.Interview_Status__c!='Cancelled'&&appList[0].Latest_Interview__r.Feedback_given__c==false){
                      interview.addError('Please Mark Latest interview as "Completed"(Feedback Pending): '+appList[0].Latest_Interview__r.Name+'');
                   }else{
                    if(appList[0].Current_Interview_Round__c!=null&&appList[0].Current_Interview_Round__c!=''){
                        if (appList[0].Position__r.Interview_Rounds__c != Null) {
                            if(interview.Current_Interview_Round__c>Decimal.valueOf(appList[0].Position__r.Interview_Rounds__c)){
                                interview.addError('All Interview Rounds Already Scheduled. You can not schedule another interview. Previous Interview: '+appList[0].Latest_Interview__r.Name+'');
                             }
                        }else {
                            interview.addError('Please mention interview rounds on position: '+appList[0].Position__r.Name);
                        }
                        
                    }
                   }
                }else{
                    if(appList[0].Position__c==null){
                         interview.addError('Please add "Position" Field on Application and try again...');
                   }
              }
          }
      }

    }
    
     if(Trigger.isInsert){
           
      if(Trigger.isAfter){
        
          
          for(Interview__c interview:Trigger.new){ 
              
              Application_Details__c ap = new Application_Details__c();
              ap.id = interview.Application_Detail__c;
              ap.Latest_Interview__c = interview.id;
              ap.Application_Status__c = 'Interview Scheduled';
              appListToUpdate.add(ap);
              
              intlist.add(interview);    
          }
          
      }
         if(!appListToUpdate.isEmpty()){
             system.debug('appListToUpdate='+appListToUpdate);
            update appListToUpdate; 
         }
         if(!intlist.isEmpty()){
              EmailUtility.sendScheduledmail(intlist);
         }
     }
    
   if(trigger.IsUpdate){
        if(trigger.IsAfter){
            for(Interview__c interview1:Trigger.new){
               
                if(trigger.oldMap.get(interview1.Id).Scheduled_Date__c!=trigger.newMap.get(interview1.Id).Scheduled_Date__c && trigger.newMap.get(interview1.Id).Scheduled_Date__c!=null ){
                    intlistToupdate.add(interview1);
                }
                
        }
        if(!intlistToupdate.isEmpty()){
            EmailUtility.sendReScheduledmail(intlistToupdate);
         }
    }
    }   
}
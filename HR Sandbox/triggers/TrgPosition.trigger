trigger TrgPosition on Position__c (After update) {


    if(Trigger.isAfter){
        if(Trigger.isUpdate){
    for(Position__c p:Trigger.New){
       /*
        if(Trigger.oldMap.get(p.id).Position_Approval_Status__c=='Pending for Approval'&&Trigger.oldMap.get(p.id).Position_Approval_Status__c!=Trigger.newMap.get(p.id).Position_Approval_Status__c ){
           p.addError('You can not add new Vacancy. Position/Vacancies Already Submitted For Approval.');  
        }
     */
    }
    
    }
 
  }
}
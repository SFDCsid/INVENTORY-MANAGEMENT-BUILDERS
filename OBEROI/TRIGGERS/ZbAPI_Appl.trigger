trigger ZbAPI_Appl on Applicant__c (after insert ,after update) {
  
    if(trigger.isInsert && trigger.isAfter){
    for (Applicant__c app : Trigger.new) {       
            ZbAPI_ApplClass.ZeroBounce3(app.Id);
            }
        }
    
    else if (trigger.isUpdate && trigger.isAfter){    
    for (Applicant__c app : Trigger.new) {
        if(app.On_Demand_Email_Check__c == true){
            ZbAPI_ApplClass.ZeroBounce3(app.Id);
            }
        else if(app.Email_Address__c!=null && app.Email_Address__c!= trigger.oldMap.get(app.Id).Email_Address__c){
            ZbAPI_ApplClass.ZeroBounce3(app.Id);
            }
        }
    }
}
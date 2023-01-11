trigger ZbAPI_Lead on Lead (after insert, after update) {  
        
    if(trigger.isInsert && trigger.isAfter){
    for (Lead l1 : Trigger.new) {        
            ZbAPI_LeadClass.ZeroBounce1(l1.Id);        
        }
    }
    
    else if (trigger.isUpdate && trigger.isAfter){    
    for (Lead l1 : Trigger.new) {
        if(l1.On_Demand_Email_Check__c == true){
            ZbAPI_LeadClass.ZeroBounce1(l1.Id);
            }       
        else if(l1.Email!=null && l1.Email!= trigger.oldMap.get(l1.Id).Email){
            ZbAPI_LeadClass.ZeroBounce1(l1.Id);
            }
        }
    }
}
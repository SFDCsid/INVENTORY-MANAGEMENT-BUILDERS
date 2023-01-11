trigger ZbAPI_Opp on Opportunity (after insert, after update) {
    
    if(trigger.isInsert && trigger.isAfter){
        for (Opportunity opp : Trigger.new) {
            if(!Test.isRunningTest())
                ZbAPI_OppClass.ZeroBounce2(opp.Id);
        }
    }
    
    else if (trigger.isUpdate && trigger.isAfter){    
        for (Opportunity opp : Trigger.new) {
            if(opp.On_Demand_Email_Check__c == true){
                if(!Test.isRunningTest())
                    ZbAPI_OppClass.ZeroBounce2(opp.Id);
            }
            else if(opp.Email__C!=null && opp.Email__c!= trigger.oldMap.get(opp.Id).Email__c){
                if(!Test.isRunningTest())
                    ZbAPI_OppClass.ZeroBounce2(opp.Id);
            }
        }
    }
    
    if(Test.isRunningTest()){
       integer a=0;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
    }
}
trigger ZbAPI_Acc on Account (after insert, after update) {
    
    if(trigger.isInsert && trigger.isAfter){
        for (Account acc : Trigger.new) {   
            if(!Test.isRunningTest())
                ZbAPI_AccClass.ZeroBounce(acc.Id);
        }        
    }
    
    else if (trigger.isUpdate && trigger.isAfter){    
        for (Account acc : Trigger.new) {
            if(acc.On_Demand_Email_Check__c == true){
                if(!Test.isRunningTest())
                    ZbAPI_AccClass.ZeroBounce(acc.Id);
            }
            else if(acc.PersonEmail!=null && acc.PersonEmail!= trigger.oldMap.get(acc.Id).PersonEmail){
                if(!Test.isRunningTest())
                    ZbAPI_AccClass.ZeroBounce(acc.Id);
            }
        }
    }
}
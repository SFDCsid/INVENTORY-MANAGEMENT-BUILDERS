trigger TrgProperty on Property__c (before insert,before update) {
    
    if(trigger.isInsert && trigger.isbefore){
        
        for(Property__c propObj : trigger.new){
            if(propObj.Floor_No__c!=null&&propObj.Floor_No__c>=0){
                if(propObj.Floor_No__c<=20){
                    propObj.Flat_grouping_by_zones__c = 'Lower'; 
                }else{
                    if(propObj.Floor_No__c>20&&propObj.Floor_No__c<=35){
                        propObj.Flat_grouping_by_zones__c = 'Middle'; 
                    }else{
                        if(propObj.Floor_No__c>35){
                            propObj.Flat_grouping_by_zones__c = 'Top'; 
                        }
                    } 
                }
            }
        } 
    }
    
    if(trigger.isUpdate && trigger.isbefore){
        
        for(Property__c propObj : trigger.new){
            if(Trigger.newMap.get(propObj.id).Floor_No__c!=Trigger.oldMap.get(propObj.id).Floor_No__c && propObj.Floor_No__c!=null&&propObj.Floor_No__c>=0){
                if(propObj.Floor_No__c<=20){
                    propObj.Flat_grouping_by_zones__c = 'Lower'; 
                }else{
                    if(propObj.Floor_No__c>20&&propObj.Floor_No__c<=35){
                        propObj.Flat_grouping_by_zones__c = 'Middle'; 
                    }else{
                        if(propObj.Floor_No__c>35){
                            propObj.Flat_grouping_by_zones__c = 'Top'; 
                        }
                    } 
                }
            }
        }
    }
    
}
trigger RoundrobinTrg on Lead_c__c(before insert, after insert, before update, after update) {
   /* if(trigger.isInsert){
        if(trigger.isBefore){
            for(Lead_c__c ld:trigger.new)
           {
               if(ld.Apply_Round_Robin__c==true && ld.Project_Name__c!= Null){
                    LeadRoundRobinHandler.roundRobinAssignment(trigger.new);
               }
        } 
                
     }
    } */
    
    
    if(trigger.isUpdate)
    {
        if(trigger.isBefore)
        {
            for(Lead_c__c lsg : trigger.new)
            {
                //if(l.Apply_Round_Robin__c == False && (l.CreatedById == '0055g00000D8j12AAB' || l.CreatedById == '0055g00000E7IJ2AAN'))
                    
                if(Trigger.oldMap.get(lsg.id).Apply_Round_Robin__c != Trigger.newMap.get(lsg.Id).Apply_Round_Robin__c) 
                	LeadRoundRobinHandler.roundRobinAssignment(trigger.new);
                
                if(lsg.Apply_Round_Robin__c == true &&  Trigger.oldMap.get(lsg.Id).Project_Name__c == Null && Trigger.oldMap.get(lsg.Id).Project_Name__c != Trigger.newMap.get(lsg.Id).Project_Name__c ) 
                	LeadRoundRobinHandler.roundRobinAssignment(trigger.new);
               
            }
            
        }
    }
}
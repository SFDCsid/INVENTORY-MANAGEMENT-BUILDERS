public class OpportunityScoring
{
    @InvocableMethod
    public static void ScoreOnTask(List<Id> OpportunityIds)
    {
        system.debug('opportunity id chi list'+ OpportunityIds);
        
        List<Opportunity> opps =[select id,Name,Total_Final_Score__c from Opportunity where Id in: OpportunityIds];
        system.debug('opps chi size '+ opps.size());
        
        List<Task> Tasklist =[select id,Total_Final_Score__c from task Where WhatId in :OpportunityIds];
        system.debug('Tasklist chi size '+ Tasklist.size());                  
        
        List<Task> TlistToUpdate = new List<Task>();
        
        for(Opportunity o :opps){
            for(Task T : Tasklist){
            system.debug('Task cha Total_Final_Score__c '+ T.Total_Final_Score__c );
            system.debug('Opp cha Total_Final_Score__c '+ O.Total_Final_Score__c );
           
            T.Total_Final_Score__c = o.Total_Final_Score__c ;
            TlistToUpdate.add(t);                        
            }     
        }
        system.debug('TlistToUpdate chi size '+ TlistToUpdate.size());
        Update TlistToUpdate;
    }
}
public class CopyLeadToTask {
   
    
     @AuraEnabled
    public static id getTypeFromLead(string recId)
    {
        Id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Commerical Visit').getRecordTypeId();
        // Task tk = [Select id, Broker_IPC__c,WhoId,Contact__c,Concerned_Person_Name__c,description,Approximate_Area_Requirement__c,Client_Name__c,Remarks_Comments__c,Sector_Industry__c,Rate__c,recordtypeId,ActivityDate from Task where id =: recId LIMIT 1];
        Lead ld = [SELECT id, Broker_IPC__c,Name,Contact__c,Concerned_Person_Name__c,Carpet_Area__c,activity_date__c,Industry,Internal_Comments__c,Rate__c,company,recordtypeId FROM Lead where id =: recId LIMIT 1]; 
        
        Task tk = new Task();
        
        system.debug('in apex class');
        tk.Copy_Lead_Data__c =true;
        tk.Client_Name__c = ld.Name;
        tk.whoId = recId;
        tk.description = ld.Internal_Comments__c;
        tk.Sector_Industry__c = ld.Industry;
        tk.Rate__c = ld.Rate__c;
       
        tk.ActivityDate = ld.activity_date__c;
        tk.Contact__c = ld.Contact__c;
        tk.Approximate_Area_Requirement__c = ld.Carpet_Area__c;
        tk.Concerned_Person_Name__c = ld.Concerned_Person_Name__c;
        tk.Broker_IPC__c =ld.Broker_IPC__c;
        tk.recordtypeId = taskRecordTypeId;
        tk.Subject ='New Commercial Visit with '+ld.Name;
        
        insert tk;
        return tk.Id;
    }
    
    
    
    
    
    /*  @AuraEnabled
public static Task getTypeFromLead(string recId)
{
Task tk = [Select id, Broker_IPC__c,WhoId,Contact__c,Concerned_Person_Name__c,description,Approximate_Area_Requirement__c,Client_Name__c,Remarks_Comments__c,Sector_Industry__c,Rate__c,recordtypeId,ActivityDate from Task where id =: recId LIMIT 1];
Lead ld = [SELECT id, Broker_IPC__c,Name,Contact__c,Concerned_Person_Name__c,Carpet_Area__c,activity_date__c,Industry,Internal_Comments__c,Rate__c,company,recordtypeId FROM Lead where id =: tk.WhoId]; 

tk.Client_Name__c = ld.Name;
tk.description = ld.Internal_Comments__c;
tk.Sector_Industry__c = ld.Industry;
tk.Rate__c = ld.Rate__c;
tk.ActivityDate = ld.activity_date__c;
tk.Contact__c = ld.Contact__c;
tk.Approximate_Area_Requirement__c = ld.Carpet_Area__c;
tk.Concerned_Person_Name__c = ld.Concerned_Person_Name__c;
tk.Broker_IPC__c =ld.Broker_IPC__c;

update tk;
return tk;
}

*/
   
    
    
}
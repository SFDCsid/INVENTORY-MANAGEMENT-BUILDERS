@isTest
public class TestTaskHandlerServices {
    @isTest
    public static Project__c createProject() {
    	Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
        return p;
    }
     
	@isTest
    public static void createPresaleCall() {
        Project__c p = createProject();
        
        Lead l1 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Incoming', MobilePhone = '1122334455', Project__c = p.Id);
        insert l1;
        
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t.Subject = 'Call';
        t.WhoId = l1.Id;
        t.Type = 'Presales Call';
        t.CallType = 'Inbound';
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.Call_Status__c = 'Call Complete'; 
        insert t;
        
        t.Stage__c = 'Follow-up';
        t.Next_Followup_date__c = system.today().addDays(1);
        t.Description = 'Test Call';
        t.Status = 'Completed';
        update t;
        
        Task t1 = new Task();
        t1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t1.Subject = 'Call';
        t1.WhoId = l1.Id;
        t1.Type = 'Presales Call';
        t1.CallType = 'Inbound';
        t1.Priority = 'Normal';
        t1.Call_Status__c = 'Call Complete';
        t1.Stage__c = 'Follow-up';
        t1.Next_Followup_date__c = system.today().addDays(1);
        t1.Description = 'Test Call';
        t1.Status = 'Completed';
        insert t1;
    }
    
     @isTest
    public static void createSalesCall() {
        Project__c p = createProject();
		        
        Account a = new Account(FirstName = 'Test', LastName = 'Account', PersonMobilePhone = '1122334455');
        insert a;
        Opportunity op = new Opportunity(Name = 'Test Opp', AccountId = a.Id, StageName = 'Follow-up', CloseDate = system.today().addDays(30), Project__c = p.Id);
        insert op;
        
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Call').getRecordTypeId();
        t.Subject = 'Call';
        t.WhatId = op.Id;
        t.Type = 'Sales Call';
        t.CallType = 'Inbound';
        t.Status = 'Completed';
        t.Priority = 'Normal';
        t.Call_Status__c = 'Call Complete';
        insert t;
        
        t.Stage__c = 'Follow-up';
        t.Next_Followup_date__c = system.today().addDays(1);
        t.Description = 'Test Call';
        t.Status = 'Completed';
        update t;
    }
    
    @isTest
    public static void createCPlogaCall() {
        //Project__c p = createProject();
        
        Account a1 = new Account( Name = 'test',  Phone = '1122334455');
        insert a1;
        
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Log A Call').getRecordTypeId();
        t.Call_Meeting_Status__c = 'CP Call';
        t.Subject = 'Call';
        t.WhatId = a1.Id;
        t.Type = 'CP Log A Call';
        t.CallType = 'Inbound';
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.Call_Meeting_Status__c = 'Call Complete'; 
        insert t;
        
        t.CP_Stage__c = 'Prospect';
        t.CP_Sub_stage__c = 'High Potential';
        t.Next_Action_Date__c = system.now().addDays(1);
        t.Call_Meeting_Date__c = system.today();
        t.Remarks__c = 'Test Call';
        t.Status = 'Completed';
        update t;
        
        
         Task t1 = new Task();
        t1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Log A Call').getRecordTypeId();
        
        t1.Subject = 'CP Meeting';
        t1.WhatId = a1.Id;
        t1.Type = 'CP Log A Call';
        t1.CallType = 'Inbound';
        t1.Status = 'Open';
        t1.Priority = 'Normal';
        t1.Call_Meeting_Status__c = 'Meeting Completed';
        insert t1;
        
        t1.CP_Stage__c = 'Prospect';
        t1.CP_Sub_stage__c = 'High Potential';
        t1.Next_Action_Date__c = system.now().addDays(1);
        t1.Call_Meeting_Date__c = system.today();
        t1.Remarks__c = 'Test Call';
        t1.Status = 'Completed';
        update t1;
        
    }
  
}
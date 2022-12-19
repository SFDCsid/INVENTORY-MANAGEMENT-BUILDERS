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
        t.Status = 'Completed';
        t.Priority = 'Normal';
        t.Call_Status__c = 'Call Complete';
        insert t;
        
        t.Stage__c = 'Incoming';
        t.Sub_Stage__c = 'Open';
        t.Sub_Stage_Reason__c = 'Incoming call or lead which is not serviced';
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        t.Description = 'Test Call';
        update t;
    }
    
    @isTest
    public static void createSalesCall() {
        Project__c p = createProject();
        
        Account a = new Account(FirstName = 'Test', LastName = 'Account', PersonMobilePhone = '1122334455');
        insert a;
        Opportunity op = new Opportunity(Name = 'Test Opp', AccountId = a.Id, StageName = 'In Follow-up', CloseDate = system.today().addDays(30), Project__c = p.Id);
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
        
        t.Stage__c = 'In Follow-up';
        t.Sub_Stage__c = 'Hot';
        t.Sub_Stage_Reason__c = 'All Good Expected Closure';
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        t.Description = 'Test Call';
        update t;
    }
}
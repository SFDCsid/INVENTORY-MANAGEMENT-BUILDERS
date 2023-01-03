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
        
        Lead__c l1 = new Lead__c(First_Name__c = 'Test', Last_Name__c = 'Lead 1', Status__c = 'Incoming', MobilePhone__c = '1122334455', Project__c = p.Id);
        insert l1;
        
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t.Subject = 'Call';
        t.WhatId = l1.Id;
        t.Type = 'Presales Call';
        t.CallType = 'Inbound';
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.Call_Status__c = 'Call Complete'; 
        insert t;
        
        t.Stage__c	 = 'Incoming';
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        t.Description = 'Test Call';
        t.Status = 'Completed';
        update t;
        
        Task t1 = new Task();
        t1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t1.Subject = 'Call';
        t1.WhatId = l1.Id;
        t1.Type = 'Presales Call';
        t1.CallType = 'Inbound';
        t1.Priority = 'Normal';
        t1.Call_Status__c = 'Call Complete';
        t1.Stage__c = 'Incoming';
        t1.Next_Follow_up_Date__c = system.today().addDays(1);
        t1.Description = 'Test Call';
        t1.Status = 'Completed';
        insert t1;
    }
    
     @isTest
    public static void createSalesCall() {
        Project__c p = createProject();
		        
        Account a = new Account(FirstName = 'Test', LastName = 'Account', PersonMobilePhone = '1122334455');
        insert a;
        Opportunity__c op = new Opportunity__c(Name = 'Test Opp', AccountId__c = a.Id, StageName__c = 'Under Conversion', CloseDate__c = system.today().addDays(30), Project__c = p.Id);
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
        
        t.Stage__c = 'Under Conversion';
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        t.Description = 'Test Call';
        update t;
        
        
        Task t1 = new Task();
        t1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Call').getRecordTypeId();
        t1.Subject = 'Call';
        t1.WhatId = op.Id;
        t1.Type = 'Sales Call';
        t1.CallType = 'Inbound';
        t1.Priority = 'Normal';
        t1.Call_Status__c = 'Call Complete';
        t1.Stage__c = 'Unqualified';
        t1.Next_Follow_up_Date__c = system.today().addDays(1);
        t1.Description = 'Test Call';
        t1.Status = 'Completed';
        insert t1;
    }
    
    
    @isTest
    public static void createChannelPartner() {      
        
        Channel_Partner__c cp = new Channel_Partner__c();
        cp.Name = 'Test';
        cp.Stage__c = 'Prospect';
        cp.Sub_Stage__c = 'High Potential';
        cp.Mobile__c = '7887475065';
        cp.PAN_No__c = 'ABCTZ1234E';
        insert cp;
        
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Call / Meeting').getRecordTypeId();
        t.Subject = 'Call';
        t.WhatId = cp.Id;
        t.Type = 'CP Call / Meeting';
        t.CallType = 'Inbound';
        t.Status = 'Completed';
        t.Priority = 'Normal';
        t.Call_Status__c = 'Call Complete';
        insert t;
        
        t.Stage__c = 'Prospect';
        t.Sub_Stage__c = 'High Potential';
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        t.Next_Action_Date__c = system.today().addDays(1);
        t.Description = 'Test Call';
        update t;
        
        
        Task t1 = new Task();
        t1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Call / Meeting').getRecordTypeId();
        t1.Subject = 'Call';
        t1.WhatId = cp.Id;
        t1.Type = 'CP Call / Meeting';
        t1.CallType = 'Inbound';
        t1.Priority = 'Normal';
        t1.Call_Status__c = 'Call Complete';
        t1.Stage__c = 'Prospect';
        t1.Sub_Stage__c = 'High Potential';
        t1.Next_Follow_up_Date__c = system.today().addDays(1);
        t1.Next_Action_Date__c = system.today().addDays(1);
        t1.Description = 'Test Call';
        t1.Status = 'Completed';
        insert t1;
    }
  	
    @isTest
    public static void billingCampaign() {
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
        
        Marketing_Brief__c Mb = new Marketing_Brief__c();
        Mb.Project__c = p.id;
        Mb.Start_Date__c = system.today();
        Mb.End_Date__c = system.today().addDays(30);
        Mb.Planned_Cost__c = 200;
        Mb.Planned_Bookings__c = 10;
        Mb.Planned_Leads__c = 2;
        Mb.Planned_Visits__c = 1;
        Mb.Status__c = 'In-process';
        insert Mb;
        
        Campaign__c c2 = new Campaign__c();
        c2.RecordTypeId = Schema.SObjectType.Campaign__c.getRecordTypeInfosByName().get('TV Plan').getRecordTypeId();
        c2.Name = 'Test Project';
        c2.IsActive__c = true;
        c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.StartDate__c = system.today();
        c2.EndDate__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.Campaign_Code__c = '123';
        c2.Campaign_Type__c =  'TV Plan';
        c2.Media__c = 'Print';
        c2.Status__c = 'Approved';
        c2.Marketing_Brief__c = Mb.Id;
        insert c2;
        c2.Campaign_Code__c = c2.Id;
        update c2;
        
        Task t = new Task();
        t.WhatId = c2.Id;
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        t.Amount__c = 10000;
        t.GST__c = 'GST 5%';
        t.Priority = 'Normal';
        t.Status = 'Completed';
        insert t;
    }
}
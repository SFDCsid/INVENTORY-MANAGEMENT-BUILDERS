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
        
        Lead_c__c l1 = new Lead_c__c(First_Name__c = 'Test', Last_Name__c = 'Lead 1', Lead_Stage__c = 'SNP',Lead_Sub_Stage__c = 'SNP', Mobile__c = '1122334455', Project_Name__c = p.Id);
        insert l1;
        
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presale Call').getRecordTypeId();
        t.Subject = 'Call';
        t.WhatId = l1.Id;
        t.Type = 'Presale Call';
        t.CallType = 'Inbound';
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.Call_Status__c = 'Call Complete'; 
        insert t;
        
        
        Task t5 = new Task();
        t5.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Call').getRecordTypeId();
        t5.Subject = 'Call';
        t5.WhatId = l1.Id;
        t5.Type = 'Sales Call';
        t5.CallType = 'Inbound';
        t5.Status = 'Open';
        t5.Priority = 'Normal';
        t5.Call_Status__c = 'Call Complete'; 
        insert t5;
      
        Task t3 = new Task();
        t3.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Meeting').getRecordTypeId();
        t3.Subject = 'Call';
        t3.WhatId = l1.Id;
        t3.Type = 'CP Meeting';
        t3.CallType = 'Inbound';
        t3.Status = 'Open';
        t3.Priority = 'Normal';
        t3.Call_Status__c = 'Call Complete'; 
        insert t3;
        
        
        Task t4 = new Task();
        t4.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Call').getRecordTypeId();
        t4.Subject = 'Call';
        t4.WhatId = l1.Id;
        t4.Type = 'CP Call';
        t4.CallType = 'Inbound';
        t4.Status = 'Open';
        t4.Priority = 'Normal';
        t4.Call_Status__c = 'Call Complete'; 
        insert t4;
        
        
     
        
        t.Stage__c	 = 'SNP';
        t.Sub_Stage__c = 'SNP';
       // t.Sub_Stage_Reason__c = 'Switched off';
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        t.Description = 'Test Call';
        t.Status = 'Completed';
        update t;
        
        Task t1 = new Task();
        t1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presale Call').getRecordTypeId();
        t1.Subject = 'Call';
        t1.WhatId = l1.Id;
        t1.Type = 'Presale Call';
        t1.CallType = 'Inbound';
        t1.Priority = 'Normal';
        t1.Call_Status__c = 'Call Complete';
        t1.Stage__c	 = 'SNP';
        t1.Sub_Stage__c = 'SNP';
        //t1.Sub_Stage_Reason__c = 'Switched off';
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
        Opportunity_c__c op = new Opportunity_c__c(First_Name__c = 'Test Opp', Last_Name__c = 'Test Opp2', Account_Name__c = a.Id, Opportunity_Stage__c = 'In Follow-up', Opportunity_Sub_Stage__c = 'Hot', Opportunity_Sub_Stage_Reason__c = 'All Good Expected Closure' , Project__c = p.Id);
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
        
        
        Task t1 = new Task();
        t1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Call').getRecordTypeId();
        t1.Subject = 'Call';
        t1.WhatId = op.Id;
        t1.Type = 'Sales Call';
        t1.CallType = 'Inbound';
        t1.Priority = 'Normal';
        t1.Call_Status__c = 'Call Complete';
        t.Stage__c = 'In Follow-up';
        t.Sub_Stage__c = 'Hot';
        t.Sub_Stage_Reason__c = 'All Good Expected Closure';
        t1.Next_Follow_up_Date__c = system.today().addDays(1);
        t1.Description = 'Test Call';
        t1.Status = 'Completed';
        insert t1;
    }
    
    
    @isTest
    public static void createCpProject() {   
        
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
        
        Account a = new Account(FirstName = 'Test', LastName = 'Account', PersonMobilePhone = '1122334455');
        insert a;
        
        CP_Project__c cp = new CP_Project__c();
        cp.CP_Stage__c = 'Prospect';
        cp.CP_Sub_Stage__c = 'High Potential';
        cp.CP_Account__c = a.id;
        cp.CP_Project_Name__c = p.id;
        cp.CP_Call_Next_Action_Date__c = system.today();
        
        insert cp;
        
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Meeting').getRecordTypeId();
        t.Subject = 'Call';
        t.WhatId = cp.Id;
        t.Type = 'CP Meeting';
        t.CallType = 'Inbound';
        t.Status = 'Completed';
        t.Priority = 'Normal';
        t.Call_Status__c = 'Call Complete';
        t.Next_Follow_up_Date__c = system.today();
        insert t;
        
        t.CP_Stage__c = 'Prospect';
        t.CP_Sub_Stage__c = 'High Potential';
        t.CP_Meeting_Next_Action_Date__c = system.today().addDays(1);
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        t.Description = 'Test Call';
        update t;
        
        
        Task t1 = new Task();
        t1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Meeting').getRecordTypeId();
        t1.Subject = 'Call';
        t1.WhatId = cp.Id;
        t1.Type = 'CP Meeting';
        t1.CallType = 'Inbound';
        t1.Priority = 'Normal';
        t1.Call_Status__c = 'Call Complete';
        t.CP_Stage__c = 'Prospect';
        t.CP_Sub_Stage__c = 'High Potential';
        t.CP_Meeting_Next_Action_Date__c = system.today().addDays(1);
        t1.Description = 'Test Call';
        t1.Status = 'Completed';
        t1.Next_Follow_up_Date__c = system.today();
        insert t1;
    }
    
    
    
     @isTest
    public static void createCpProject2() {   
        
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
        
        Account a = new Account(FirstName = 'Test', LastName = 'Account', PersonMobilePhone = '1122334455');
        insert a;
        
        CP_Project__c cp = new CP_Project__c();
        cp.CP_Stage__c = 'Prospect';
        cp.CP_Sub_Stage__c = 'High Potential';
        cp.CP_Account__c = a.id;
        cp.CP_Project_Name__c = p.id;
        insert cp;
        
        Task t = new Task();
        t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Call').getRecordTypeId();
        t.Subject = 'Call';
        t.WhatId = cp.Id;
        t.Type = 'CP Call';
        t.CallType = 'Inbound';
        t.Status = 'Completed';
        t.Priority = 'Normal';
        t.Call_Status__c = 'Call Complete';
        t.Next_Follow_up_Date__c = system.today();
        insert t;
        
        t.CP_Stage__c = 'Prospect';
        t.CP_Sub_Stage__c = 'High Potential';
        t.CP_Meeting_Next_Action_Date__c = system.today().addDays(1);
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        t.Description = 'Test Call';
        update t;
        
        
        Task t1 = new Task();
        t1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Call').getRecordTypeId();
        t1.Subject = 'Call';
        t1.WhatId = cp.Id;
        t1.Type = 'CP Call';
        t1.CallType = 'Inbound';
        t1.Priority = 'Normal';
        t1.Call_Status__c = 'Call Complete';
        t.CP_Stage__c = 'Prospect';
        t.CP_Sub_Stage__c = 'High Potential';
        t.CP_Meeting_Next_Action_Date__c = system.today().addDays(1);
        t1.Description = 'Test Call';
        t1.Status = 'Completed';
        t1.Next_Follow_up_Date__c = system.today();
        insert t1;
    }
    
  
}
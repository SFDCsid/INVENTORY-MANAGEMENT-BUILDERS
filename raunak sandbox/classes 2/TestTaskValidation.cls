@isTest
public class TestTaskValidation {
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
        t.Next_Follow_up_Date__c = System.today().addDays(1);
        t.Call_Status__c = 'Call Complete'; 
        insert t;
        
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
    public static void createPresaleCall22() {
        Project__c p = createProject();
        
        Lead_c__c l1 = new Lead_c__c(First_Name__c = 'Test', Last_Name__c = 'Lead 1', Lead_Stage__c = 'Contact',Lead_Sub_Stage__c = 'Unserviced', Mobile__c = '1122334455', Project_Name__c = p.Id);
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
        t.Stage__c	 = 'SNP';
        t.Sub_Stage__c = 'SNP';
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        insert t;
        
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
        t1.Stage__c	 = 'Contact';
        t1.Sub_Stage__c = 'Unserviced';
        //t1.Sub_Stage_Reason__c = 'Switched off';
        t1.Next_Follow_up_Date__c = system.today().addDays(1);
        t1.Description = 'Test Call';
        t1.Status = 'Completed';
        insert t1;
    }
    
    
    @isTest
    public static void createPresaleCall24() {
        Project__c p = createProject();
        
        Lead_c__c l1 = new Lead_c__c(First_Name__c = 'Test', Last_Name__c = 'Lead 1', Lead_Stage__c = 'Contact',Lead_Sub_Stage__c = 'Not Answering', Mobile__c = '1122334455', Project_Name__c = p.Id);
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
        t.Stage__c	 = 'Contact';
        t.Sub_Stage__c = 'Not Answering';
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        insert t;
        
        t.Stage__c	 = 'Contact';
        t.Sub_Stage__c = 'Not Answering';
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
        t1.Stage__c	 = 'Contact';
        t1.Sub_Stage__c = 'Not Answering';
        //t1.Sub_Stage_Reason__c = 'Switched off';
        t1.Next_Follow_up_Date__c = system.today().addDays(1);
        t1.Description = 'Test Call';
        t1.Status = 'Completed';
        insert t1;
    }
}
@isTest
public class Test_followupreport {
     @isTest
    public static void testfollowupreport(){
        Test.startTest();
        Project__c p = new Project__c();
        p.Name = 'All';
        insert p;
        
        Project__c p1 = new Project__c();
        p1.Name = 'test project1';
        insert p1;
        
		Project__c p2 = new Project__c();
        p2.Name = 'test project2';
        p2.OwnerId = UserInfo.getUserId();
        insert p2;        
        
        Lead__c ld = new Lead__c();
        ld.Project__c = p2.Id;
        ld.OwnerId = UserInfo.getUserId();
        ld.Not_Responding_Count__c = 10;
        ld.Status__c ='Unqualified';
        insert ld;
        
        Lead__c ld1 = new Lead__c();
        ld1.Project__c = p1.Id;
        ld1.OwnerId = UserInfo.getUserId();
        ld1.Not_Responding_Count__c = 10;
        ld1.Status__c ='Unqualified';
        insert ld1;       
        
        Lead__c ld2 = new Lead__c();
        ld2.Project__c = p1.Id;
        ld2.OwnerId = UserInfo.getUserId();
        ld2.CNR_Counter__c = 10;
        ld2.Not_Responding_Count__c = 10;
        insert ld2;
        
        Task t1 = new Task();
        t1.OwnerId = UserInfo.getUserId();
        t1.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
      	t1.Stage__c ='In-Followup' ;
        t1.Call_Status__c ='Answered' ;
        t1.Next_Follow_up_Date__c = system.today();
        t1.Next_Follow_up_Date__c = system.today().addDays(0);
        t1.whatId = ld.Id;
		t1.Project__c = p2.Id; 
        insert t1;	
        
        
        Task t2 = new Task();
        t2.OwnerId = UserInfo.getUserId();
        t2.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
      	t2.Call_Status__c ='Call Complete' ;
        t2.Next_Follow_up_Date__c = system.today();
        t2.Next_Follow_up_Date__c = system.today();
        t2.whatId = ld.Id;
		t2.Project__c = p.Id; 
        insert t2;	
        
        Task t3 = new Task();
        t3.OwnerId = UserInfo.getUserId();
        t3.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
      	t3.Call_Status__c ='Answered' ;
        t3.Next_Follow_up_Date__c = system.today();
        t3.Next_Follow_up_Date__c = system.today();
        t3.whatId = ld2.Id;
		t3.Project__c = p.Id; 
        insert t3;	
        
        Task t4 = new Task();
        t4.OwnerId = UserInfo.getUserId();
        t4.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t4.Call_Status__c ='Answered' ;
      	t4.Stage__c ='In-Followup' ;
        t4.Next_Follow_up_Date__c = system.today();
        t4.Next_Follow_up_Date__c = system.today();
        t4.Project__c = p2.id;
        t4.WhatId = ld2.id;
        insert t4;	
        
        Task t5 = new Task();
        t5.OwnerId =  UserInfo.getUserId();
        t5.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t5.WhatId = ld2.id;
        t5.Project__c = p.id;
        t5.Call_Status__c ='Answered' ;
        t5.Stage__c = 'In-Followup';
        t5.Next_Follow_up_Date__c = system.today();
        t5.Next_Follow_up_Date__c = system.today();
        insert t5;

        
        set<Lead__c> ldset = new set<Lead__c>();
        ldset.add(ld);
        ldset.add(ld1);
        ldset.add(ld2);
        
        set<Date> followdate = new set<Date>();
        followdate.add(system.today());
        
        followupReportData sv = new followupReportData();
        followupReportData.getProject();
        followupReportData.reportDataWrapperClass rr = new followupReportData.reportDataWrapperClass();
    
        
 		followupReportData.Wrapper('All', system.today(), system.today().addDays(1));
        followupReportData.Wrapper(p.id, system.today(), system.today().addDays(1));
        
        
        Test.stopTest();
    }  
}
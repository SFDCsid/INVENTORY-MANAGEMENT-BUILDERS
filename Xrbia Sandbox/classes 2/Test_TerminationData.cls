@isTest
public class Test_TerminationData {
	@isTest
    public static void Testnew1(){
        
        Test.startTest();
        
        Project__c p = new Project__c();
        p.Name = 'All';
        insert p;
        
        Project__c p1 = new Project__c();
        p1.Name = 'test project1';
        insert p1;
        
        Lead__c ld = new Lead__c();
        ld.Project__c = p1.Id;
        ld.OwnerId = UserInfo.getUserId();
        ld.Status__c = 'Unqualified';
        insert ld;

		Lead__c ld1 = new Lead__c();
        ld1.Project__c = p.Id;
        ld1.OwnerId = UserInfo.getUserId();
        ld1.Status__c ='Incoming';
        ld1.Lead_Sub_Stage__c ='Call Back';
        insert ld1;
        
        Lead__c ld2 = new Lead__c();
        ld2.Project__c = p.Id;
        ld2.OwnerId = UserInfo.getUserId();
        ld2.Lead_Sub_Stage__c ='Not Responding';
        insert ld2;
      	
        
        task t1 = new task();
        t1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t1.Project__c = p.id;
        t1.WhatId = ld1.id;
        t1.Call_Status__c ='Answered';
        t1.Hangup_By__c = 'UserHangup';
        insert t1;
        
        task t2 = new task();
        t2.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t2.OwnerId =  UserInfo.getUserId();
        t2.Project__c = p1.id;
        t2.Hangup_By__c ='AgentHangup';
       
        insert t2;
        
        task t5 = new task();
        t5.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t5.OwnerId =  UserInfo.getUserId();
        t5.Project__c = p.id;
        t5.Hangup_By__c ='AgentHangup';
       
        insert t5;
        
        task t3 = new task();
        t3.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t3.OwnerId =  UserInfo.getUserId();
        t3.Hangup_By__c ='UserHangup';
        t3.Project__c = p.id;
        insert t3;
        
        task t4 = new task();
        t4.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t4.Project__c = p.id;
        t4.WhatId = ld1.id;
        t4.Call_Status__c ='Wrong Number';
        t4.Hangup_By__c = 'UserHangup';
        insert t4;
        
        List<Task> userHangup = new List<Task>();
        userHangup.add(t3);

        terminationData td =new terminationData();
        terminationData.getProject();
        terminationData.reportDataWrapperClass rr = new terminationData.reportDataWrapperClass();
        
        decimal l= 7;
        decimal e = 35 ;
        decimal f ;
       
        l = rr.overAllConnected;
        e = rr.agentHangUp;
        f = rr.userHangup;
       
 	
       	terminationData.Wrapper('All', system.today().addDays(+0), system.today().addDays(+1));
        terminationData.Wrapper(p1.Id,system.today().addDays(+0),  system.today().addDays(+1));
        terminationData.Wrapper('test project', system.today().addDays(+0), system.today().addDays(+1));


        Test.stopTest();
    }
    
   
}
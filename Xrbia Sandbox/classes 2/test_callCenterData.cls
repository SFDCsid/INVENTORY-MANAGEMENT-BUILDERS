@isTest
public class test_callCenterData {
    @isTest
    public static void Test1(){
        Test.startTest();
        Project__c p = new Project__c();
        p.Name = 'test project';
        insert p;
        
        Project__c p1 = new Project__c();
        p1.Name = 'test project1';
        insert p1;
        
        Lead__c ld = new Lead__c();
        ld.Project__c = p1.Id;
        ld.CNR_Counter__c = 20;
        ld.OwnerId = UserInfo.getUserId();
        ld.Status__c = 'Unqualified';
        insert ld;

		Lead__c ld1 = new Lead__c();
        ld1.Project__c = p.Id;
        ld.CNR_Counter__c = 2;
        ld1.OwnerId = UserInfo.getUserId();
        ld1.Status__c ='Incoming';
        ld1.Lead_Sub_Stage__c ='Call Back';
        insert ld1;
        
        Lead__c ld2 = new Lead__c();
        ld2.Project__c = p.Id;
        ld2.OwnerId = UserInfo.getUserId();
        ld2.Lead_Sub_Stage__c ='Not Responding';
        ld2.CNR_Counter__c = 14;
        insert ld2;
        
        Lead__c ld3 = new Lead__c();
        ld3.Project__c = p.Id;
        ld3.OwnerId = UserInfo.getUserId();
        ld3.Lead_Sub_Stage__c ='Not Responding';
        ld3.CNR_Counter__c = 18;
        //ld3.Project__c = p.Id;
        //ld3.Status__c = 'Unqualified';
        insert ld3;
        
        Lead__c ld4 = new Lead__c();
        ld4.CNR_Counter__c = 14;
        ld4.Status__c = 'Unqualified';
        ld4.Project__c = p.Id;
        insert ld4;
        
        Lead__c ld5 = new Lead__c();
        ld5.Project__c = p.Id;
        ld5.OwnerId = UserInfo.getUserId();
        ld5.Lead_Sub_Stage__c ='Not Responding';
        ld5.CNR_Counter__c = 8;
        insert ld5;
        
        Lead__c ld6 = new Lead__c();
        ld6.Project__c = p1.Id;
        ld6.OwnerId = UserInfo.getUserId();
        ld6.CNR_Counter__c = 25;
        insert ld6;
        
        Lead__c ld7 = new Lead__c();
        ld7.Project__c = p1.Id;
        ld7.OwnerId = UserInfo.getUserId();
        ld7.CNR_Counter__c = 25;
        insert ld7;
        
        Lead__c ld8 = new Lead__c();
        ld8.Project__c = p1.Id;
        ld8.OwnerId = UserInfo.getUserId();
       // ld8.CNR_Counter__c = 25;
        insert ld8;
        
        task t7 = new task();
        t7.OwnerId = UserInfo.getUserId();
        t7.CallType= 'Outbound';
        t7.Call_Status__c = 'NotAnswered';
        t7.whatId = ld7.Id;
		t7.Project__c = p1.id; 
        //t7.CreatedDate = system.today();
        //t7.CreatedDate = system.today();
        t7.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        insert t7;
        
        task t8 = new task();
        t8.OwnerId = UserInfo.getUserId();
        t8.CallType= 'Outbound';
        t8.Call_Status__c = 'Answered';
        //t8.CreatedDate = system.today();
        //t8.CreatedDate = system.today();
		t8.Project__c = p.id; 
        t8.WhatId = ld.id;
        t8.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        insert t8;
     
        task t1 = new task();
        t1.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t1.OwnerId = UserInfo.getUserId();
        t1.CallType= 'Inbound';
        t1.whatId = ld6.Id;
		t1.Project__c = p1.id;        
        insert t1;
        
        task t2 = new task();
        t2.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t2.OwnerId = UserInfo.getUserId();
        t2.CallType= 'Inbound';
        t2.whatId = ld3.Id;
		t2.Project__c = p.Id;   
        t2.Is_New_Lead_Created__c = false;
        t2.CallDurationInSeconds = 19;
        t2.Subject = 'Missed' ;
        t2.Call_Status__c = 'Answered';
        insert t2;
        
        task t3 = new task();
        t3.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t3.OwnerId = UserInfo.getUserId();
        //t3.CallType= 'Inbound';
        t3.whatId = ld3.Id;
		t3.Project__c = p.Id; 
        t3.Stage__c = 'Incoming';
        t3.Sub_Stage__c = 'Call Back';
        t3.Next_Follow_up_Date__c = system.today().addDays(+1);
        insert t3;
        
        task t4 = new task();
        t4.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();	
        t4.OwnerId = UserInfo.getUserId();
        t4.CallType= 'Inbound';
        t4.Is_New_Lead_Created__c = true;
        t4.CallDurationInSeconds = 21;
        t4.WhatId = ld4.id;
        t4.Project__c = p.id;
        
        insert t4;
        
        task t5 = new task();
        t5.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t5.OwnerId = UserInfo.getUserId();
        t5.CallType = 'Outbound';
        t5.Is_New_Lead_Created__c = true;
        t5.CallDurationInSeconds = 21;
        t5.WhatId = ld5.id;
        t5.Project__c = p.id;
        insert t5;
        
        task t6 = new task();
        t6.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t6.OwnerId = UserInfo.getUserId();
        t6.CallType = 'Inbound';
        t6.Is_New_Lead_Created__c = false;
        //t6.CallDurationInSeconds = 21;
        t6.WhatId = ld8.id;
        t6.Project__c = p.id;
      
        insert t6;
        
        task t9 = new task();
        t9.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t9.OwnerId = UserInfo.getUserId();
        t9.CallType = 'Inbound';
        t9.Is_New_Lead_Created__c = false;
        t9.WhatId = ld6.id;
        t9.Project__c = p.id;   
        t9.Subject = '%missed%';
        insert t9;
        
        task t10 = new task();
        t10.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t10.OwnerId = UserInfo.getUserId();
        t10.CallType = 'Inbound';
        t10.WhatId = ld1.id;
        t10.Project__c = p.id;
        t10.Subject = '%missed%';
        insert t10;
        
        task t12 = new task();
        t12.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t12.OwnerId = UserInfo.getUserId();
        t12.CallType = 'Inbound';
        t12.WhatId = ld8.id;
        t12.Project__c = p.id;
        t12.Subject = '%missed%';
        insert t12;

        
        
        List<Task> t11 = new List<Task>();
        t11.add(t1);
        t11.add(t2);
        t11.add(t9);
        t11.add(t8);
        t11.add(t10);

        
        List<Lead__c> ldlist = new List<Lead__c>();
        ldlist.add(ld5);
        ldlist.add(ld4);
        ldlist.add(ld1);
        ldlist.add(ld);
        ldlist.add(ld6);
        ldlist.add(ld3);

        callCenterData cd =new callCenterData();
        callCenterData.getProject();
        callCenterData.reportDataWrapperClass rr = new callCenterData.reportDataWrapperClass();
        
        decimal l ;
        decimal e ;
        decimal f = 60;
        decimal h =1 ;
        decimal a ;
        l = rr.incomingCalls;
        e = rr.incomingAssignedCalls;
        f = rr.incomingFormingLeads;
        h = rr.callReceivedByUnique;
        a = rr.incomingNotFormingLeads;
        
        

        callCenterData.Wrapper('All', system.today().addDays(-1), system.today().addDays(1));
        callCenterData.Wrapper(p.Id,system.today().addDays(-1), system.today());
        callCenterData.Wrapper('test project1', system.today().addDays(-1), system.today().addDays(1));
        
     
     
        Test.stopTest();

    }

}
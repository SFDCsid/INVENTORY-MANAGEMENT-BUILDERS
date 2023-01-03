@isTest
public class Test_svschedulereport {
     @isTest
    public static void testnewschedule(){
        
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
        insert ld;
        
        Lead__c ld1 = new Lead__c();
        ld1.Project__c = p1.Id;
        ld1.OwnerId = UserInfo.getUserId();
        ld1.Not_Responding_Count__c = 10;
        ld1.Status__c ='Unqualified';
        insert ld1;
        
        Task t1 = new Task();
        t1.OwnerId = UserInfo.getUserId();
        t1.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t1.Stage__c ='Site Visit Scheduled';
        t1.Next_Follow_up_Date__c = system.today();
        t1.Next_Follow_up_Date__c = system.today();
        t1.Date_of_Visit__c = system.today();
        t1.whatId = ld.Id;
		t1.Project__c = p.Id; 
        t1.Call_Status__c ='Answered';
        insert t1;	
        
        set<Lead__c> ldset = new set<Lead__c>();
        ldset.add(ld);
        set<Date> followdate = new set<Date>();
        followdate.add(system.today());
        
        Task t2 = new Task();
        t2.OwnerId = UserInfo.getUserId();
        t2.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t2.whatId = ld.Id;
		t2.Project__c = p.Id; 
        t2.Call_Status__c ='Answered';
        insert t2;	
               
        Task t3 = new Task();
        t3.OwnerId = UserInfo.getUserId();
        t3.RecordTypeId =Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t3.whatId = ld1.Id;
		t3.Project__c = p1.Id; 
        t3.Call_Status__c ='NotAnswered';
        insert t3;	
        
        svScheduleReport sv = new svScheduleReport();
        svScheduleReport.getProject();
        svScheduleReport.reportDataWrapperClass rr = new svScheduleReport.reportDataWrapperClass();
        
        decimal l ;
        decimal e ;
        decimal f ;
        decimal g ;
        decimal h ;
        decimal i ;
        decimal j ;
        decimal z ;
        
        l = rr.leadCount;
        e = rr.callAnswered;
        f = rr.callUnanswered;
        g = rr.cnrCounter;
        h = rr.totalFollowupConducted;
        i = rr.totalFollowupNotConducted;
        j = rr.unqualifiedCount;
 
        svScheduleReport.Wrapper('All', system.today().addDays(+0), system.today().addDays(+0));
        svScheduleReport.Wrapper(p.id, system.today().addDays(+0), system.today().addDays(+0));
        svScheduleReport.Wrapper('test project1', system.today().addDays(+0), system.today().addDays(+0));
        
        Test.stopTest();
        
        
    }

}
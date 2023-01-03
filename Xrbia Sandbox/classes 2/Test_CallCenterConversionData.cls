@isTest
public class Test_CallCenterConversionData {
    @isTest
     public static void test1()
    {     
        Test.startTest();
        Account a = new Account();
        a.Name = 'test account';
        insert a;
        
        Project__c p = new Project__c();
        p.Name = 'test project';
        insert p;
        
        Project__c p1 = new Project__c();
        p1.Name = 'test project1';
        insert p1;
        
        Lead__c ld = new Lead__c();
        ld.Project__c = p1.Id;
        ld.OwnerId = UserInfo.getUserId();
        ld.Call_Status__c='Answered';
        ld.Total_Call_Duration__c = 1;
        insert ld;

		Lead__c ld1 = new Lead__c();
        ld1.Project__c = p.Id;
        ld1.OwnerId = UserInfo.getUserId();
        ld1.Status__c ='Site Visit Scheduled';
        ld1.Total_Call_Duration__c = 1;
        insert ld1;
        
        Lead__c ld2 = new Lead__c();
        ld2.Project__c = p.Id;
        ld2.OwnerId = UserInfo.getUserId();
        ld2.Status__c ='In-Followup';
        ld2.Total_Call_Duration__c = 1;
        insert ld2;
        
        Lead__c ld3 = new Lead__c();
        ld3.Project__c = p.Id;
        ld3.OwnerId = UserInfo.getUserId();
        ld3.Status__c ='Site Visit Conducted';
        ld3.Total_Call_Duration__c = 1;
        insert ld3;
        
        Lead__c ld4 = new Lead__c();
        ld4.Project__c = p.Id;
        ld4.OwnerId = UserInfo.getUserId();
        ld4.Status__c ='Unqualified';
        ld4.Call_Status__c= 'Answered';
        ld4.Total_Call_Duration__c = 1;
        insert ld4;

        
        task t1 = new task();
        t1.OwnerId =  UserInfo.getUserId();
        t1.Call_Status__c ='Answered';
        insert t1;
        
        task t2 = new task();
        t2.OwnerId =  UserInfo.getUserId();
        t2.Call_Status__c ='Call Complete';
        insert t2;
        
        Site_Visit__c sv = new Site_Visit__c();
        sv.OwnerId = UserInfo.getUserId();
        sv.SV_Count__c = 1;
        sv.SV_Date_Time__c = system.today();
        sv.Project__c = p1.id;
        insert sv;
        
        List<Lead__c> lcount1 = new List<Lead__c>();
        lcount1.add(ld2);
        lcount1.add(ld1);
        lcount1.add(ld);
        lcount1.add(ld3);
        lcount1.add(ld4);
        
        List<Site_Visit__c> svList = new List<Site_Visit__c>();
        svList.add(sv);

        callCenterConversionData rd = new callCenterConversionData();
        callCenterConversionData.getProjects();
        callCenterConversionData.reportDataWrapperClass rr = new callCenterConversionData.reportDataWrapperClass();
        
        decimal l = 0 ;
        decimal e = 0;
        decimal f = 0;
        decimal g = 0;
        decimal h = 0;
        decimal i = 0;
        l = rr.conversionRatio;
        e = rr.followupCount;
        f = rr.svConductedCount;
        g = rr.svScheduleCount;
        h = rr.totalCalls;
        i = rr.unqualifiedCount;

        callCenterConversionData.Wrapper('All', system.today().addDays(-1), system.today().addDays(1));
        callCenterConversionData.Wrapper(p.Id,system.today().addDays(-1), system.today());
        Test.stopTest();
        
    }
}
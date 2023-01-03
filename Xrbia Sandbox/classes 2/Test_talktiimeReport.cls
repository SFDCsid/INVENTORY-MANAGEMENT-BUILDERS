@isTest
public class Test_talktiimeReport {
    @isTest
    public static void test22()
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
        ld.Status__c = 'Unqualified';
        ld.Call_Received__c = true;
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
        
        Lead__c ld3 = new Lead__c();
        ld3.Project__c = p.Id;
        ld3.OwnerId = UserInfo.getUserId();
        ld3.Lead_Sub_Stage__c ='Not Responding';
        insert ld3;

        
        task t1 = new task();
        t1.OwnerId =  UserInfo.getUserId();
        t1.Call_Status__c ='Answered';
        t1.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t1.CallDurationInSeconds = 220;
        t1.Project__c = p.id;
        insert t1;
         system.debug('Call Duration' +t1.CallDurationInSeconds);
        
        task t2 = new task();
        t2.OwnerId =  UserInfo.getUserId();
        t2.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId();
        t2.Call_Status__c ='Answered';
        t2.CallDurationInSeconds = 200;
       // t2.Project__c = p1.id;
        insert t2;
        
        List<Lead__c> lcount1 = new List<Lead__c>();
        lcount1.add(ld2);
        lcount1.add(ld1);
        
        List<Task> ttlist = new List<Task>();
        ttlist.add(t1);
        ttlist.add(t2);
                            
        talktimeReport rd =new talktimeReport();
        talktimeReport.getProject();
        talktimeReport.reportDataWrapperClass rr = new talktimeReport.reportDataWrapperClass();
        
        decimal l = 5 ;
        decimal e = 4 ;
        decimal f ;
        l = rr.totalTalkTime;
        e = rr.avgTalkTime;
        f = rr.totalTalkTime/3600;
   
        talktimeReport.Wrapper('All', system.today().addDays(-1), system.today().addDays(1));
        talktimeReport.Wrapper(p1.Id,system.today().addDays(-1), system.today());
    
        Test.stopTest();
        
    }
   
    }
@isTest
public class Test_reportdata {
    
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
        
        Lead__c ld3 = new Lead__c();
        ld3.Project__c = p.Id;
        ld3.OwnerId = UserInfo.getUserId();
        ld3.Lead_Sub_Stage__c ='Not Responding';
        insert ld3;

        
        task t1 = new task();
        t1.OwnerId =  UserInfo.getUserId();
        t1.Call_Status__c ='Answered';
        insert t1;
        
        task t2 = new task();
        t2.OwnerId =  UserInfo.getUserId();
        t2.Call_Status__c ='Call Complete';
        insert t2;
      
      
        Opportunity__c Opp = new Opportunity__c();
        Opp.Presales_Manager__c = UserInfo.getUserId();
        system.debug('Opp.Presales_Manager__c:::::::::'+Opp.Presales_Manager__c);
        Opp.Name = 'Test1';
        Opp.StageName__c = 'Assigned';
        Opp.Project__c = p.Id;
        Opp.AccountId__c = a.id;
        Opp.StageName__c = 'Booking Confirmed';
        Opp.Sub_Stage__c ='Booking Approved';
        insert Opp;
        
        Site_Visit__c sv = new Site_Visit__c();
        sv.OwnerId = UserInfo.getUserId();
        sv.Presales_Manager__c = Opp.Presales_Manager__c;
        sv.SV_Count__c = 1;
        sv.SV_Date_Time__c = system.today();
        sv.Project__c = p1.id;
        sv.Opportunity__c = Opp.id;
        
        insert sv;
        
        List<Lead__c> lcount1 = new List<Lead__c>();
        lcount1.add(ld2);
        lcount1.add(ld1);
        
        List<Site_Visit__c> svList = new List<Site_Visit__c>();
        svList.add(sv);
        
        Booking__c b = new Booking__c();
        b.Opportunity__c = Opp.id;
        b.Project__c = p.id;
        insert b;
        List<Booking__c> bkList = new List<Booking__c>();
        bkList.add(b);
        
                            
        reportData rd =new reportData();
        reportData.getProject();
        reportData.reportDataWrapperClass rr = new reportData.reportDataWrapperClass();
        
        decimal l ;
        decimal e ;
        decimal f = 60 ;
        l = rr.lCount;
        e = rr.totalConnectedCount;
        f = rr.dailyConnectedCount;
        

        reportData.Wrapper('All', system.today().addDays(-1), system.today().addDays(1));
        reportData.Wrapper(p.Id,system.today().addDays(-1), system.today());
       // reportData.Wrapper('ownerName', system.today().addDays(-2), system.today());
       // reportData.Wrapper('test project', system.today().addDays(-1), system.today().addDays(1));
     
        Test.stopTest();
        
    }
 }
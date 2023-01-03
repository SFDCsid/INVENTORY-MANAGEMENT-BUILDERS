@isTest
public class Test_DigitalleadReport {
    @isTest
    public static void testdigitialreport(){
        
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
        ld.Lead_Created_From__c = 'Facebook';
        ld.Call_Type__c = 'Outbound';
        insert ld;
        
        Lead__c ld1 = new Lead__c();
        ld1.Project__c = p1.Id;
        ld1.OwnerId = UserInfo.getUserId();
        ld1.Lead_Created_From__c = 'Facebook';
        ld1.Call_Type__c = 'Outbound';
        insert ld1;
        
        Lead__c ld2 = new Lead__c();
        ld2.Project__c = p1.Id;
        ld2.OwnerId = UserInfo.getUserId();
        ld2.Lead_Created_From__c = 'Facebook';
        ld2.Call_Type__c = 'Outbound';
        ld2.Last_Presale_Call_Date__c = system.today();
        insert ld2;
        
        Lead__c ld3 = new Lead__c();
        ld3.Project__c = p1.Id;
        ld3.OwnerId = UserInfo.getUserId();
        ld3.Lead_Created_From__c = 'Facebook';
        ld3.Call_Type__c = 'Outbound';
        ld3.Last_Presale_Call_Date__c = null;
        insert ld3;
        
        
        Lead__c ld4 = new Lead__c();
        ld4.Project__c = p1.Id;
        ld4.OwnerId = UserInfo.getUserId();
        ld4.Lead_Created_From__c = 'Facebook';
        ld4.Call_Type__c = 'Outbound';
        ld4.Call_Received__c = true;
        ld4.Last_Presale_Call_Date__c = system.today();
        insert ld4;
        
        Lead__c ld5 = new Lead__c();
        ld5.Project__c = p1.Id;
        ld5.OwnerId = UserInfo.getUserId();
        ld5.Lead_Created_From__c = 'Facebook';
        ld5.Call_Type__c = 'Outbound';
        ld5.Call_Received__c = false;
        ld5.Total_Call_Duration__c = 100;
        ld5.Presales_Call_Count__c = 50;
        ld5.Last_Presale_Call_Date__c = system.today();
        insert ld5;
        
        Lead__c ld6 = new Lead__c();
        ld6.Project__c = p1.Id;
        ld6.OwnerId = UserInfo.getUserId();
        ld6.Lead_Created_From__c = 'Facebook';
        ld6.Call_Type__c = 'Outbound';
        ld6.Not_Responding_Count__c = 10;
        ld6.Presales_Call_Count__c = 10;
        ld6.Last_Presale_Call_Date__c = system.today();
        insert ld6;
        
        Lead__c ld7 = new Lead__c();
        ld7.Project__c = p1.Id;
        ld7.OwnerId = UserInfo.getUserId();
        ld7.Lead_Created_From__c = 'Facebook';
        ld7.Call_Type__c = 'Outbound';
        ld7.Not_Responding_Count__c = 10;
        ld7.Presales_Call_Count__c = 10;
        ld7.Status__c = 'Unqualified';
        ld7.Last_Presale_Call_Date__c = system.today();
        insert ld7;
        
        Lead__c ld8 = new Lead__c();
        ld8.Project__c = p1.Id;
        ld8.OwnerId = UserInfo.getUserId();
        //ld8.CreatedDate = system.today();
        //ld8.CreatedDate = system.today()-2;
        ld8.Lead_Created_From__c = 'Facebook';
        ld8.Call_Type__c = 'Outbound';
        ld8.Not_Responding_Count__c = 40;
        ld8.Presales_Call_Count__c = 10;
        ld8.Status__c = 'Unqualified';
        insert ld8;
        
        Lead__c ld9 = new Lead__c();
        ld9.OwnerId = UserInfo.getUserId();
        ld9.Project__c = p.Id;
        ld9.Lead_Created_From__c = 'Web';
        ld9.Call_Type__c = 'Outbound';
        ld9.Not_Responding_Count__c = 10;
        ld9.Status__c = 'Unqualified';
        insert ld9;
        
        
        List<Lead__c> ldlist = new List<Lead__c>();
        ldlist.add(ld5);
        ldlist.add(ld6);
        ldlist.add(ld1);
        ldlist.add(ld);
        ldlist.add(ld8);
        ldlist.add(ld9);
        ldlist.add(ld7);
        ldlist.add(ld4);
        ldlist.add(ld3);
        
        DigitalLeadReport dl = new DigitalLeadReport();
        DigitalLeadReport.getProject();
        DigitalLeadReport.reportDataWrapperClass rr = new DigitalLeadReport.reportDataWrapperClass();
        
        decimal l ;
        decimal e ;
        decimal f ;
        decimal g ;
        decimal h ;
        decimal i ;
        decimal j = 10 ;
        
        l = rr.AssignedLeads;
        e = rr.callsAttempted;
        f = rr.callsNotAttempted;
        g = rr.callsReceivedByUniqueLeads;
        h = rr.callsNotReceivedByUniqueLeads;
        i = rr.cnrMoreThan5;
        j = rr.unqualifiedDueToCNR;
        
        
        DigitalLeadReport.Wrapper('All', system.today().addDays(+0), system.today().addDays(+1));
        DigitalLeadReport.Wrapper(p.id, system.today().addDays(+0), system.today().addDays(+1));
        DigitalLeadReport.Wrapper('test project1', system.today().addDays(+0), system.today().addDays(+1));
        
        Test.stopTest();
 
    }

}
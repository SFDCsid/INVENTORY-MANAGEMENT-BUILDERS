@isTest
public class test_unqualifiedData {
	@isTest
    public static void test1(){
        Test.startTest();
        
        Project__c p = new Project__c();
        p.Name = 'test project';
        insert p;
        
        Lead__c ld = new Lead__c();
        ld.OwnerId = UserInfo.getUserId();
        ld.Project__c = p.Id;
        ld.OwnerId = UserInfo.getUserId();
        ld.Status__c = 'Unqualified';
        insert ld;
        
        unqualifiedData rd =new unqualifiedData();
        unqualifiedData.getProject();
        unqualifiedData.reportDataWrapperClass rr = new unqualifiedData.reportDataWrapperClass();
        
        decimal l ;
        decimal e ;
        
        l = rr.totalLeads;
        e = rr.unqualifiedLeads;
        
        unqualifiedData.Wrapper('All', system.today().addDays(-1), system.today().addDays(1));
        unqualifiedData.Wrapper(p.Id,system.today().addDays(-1), system.today());

        Test.stopTest();
    }
 }
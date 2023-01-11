@isTest
public class CloneOpportunity_test {
    @isTest public static void method1(){
        //CloneOpportunityWithSpecificFieldsCtrl c=new CloneOpportunityWithSpecificFieldsCtrl();
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'test2';
        u.Email = 'test@test.com';
        u.Username = 'test@tstt.com';
        u.MobilePhone = '1234567890';
        u.CommunityNickname = 'testshvbsihv';
        Profile p = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator'];
        u.ProfileId = p.id;
        u.LastName = 'test';
        u.Alias = 'tst';
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = True;
        insert u;
        
         Account ac = new Account();
        ac.LastName = 'test';
        ac.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        insert ac;
        
        Site__c s = new Site__c();
        s.Name = 'test';
        s.Active__c = true;
        insert s;
        Project__c pr = new Project__c();
        pr.Active__c = true;
        pr.Name = 'test';
        pr.Site__c = s.Id;
        pr.CFO__c = u.Id;
        pr.Front_Desk_User__c = u.Id;
        pr.Marcom_Head__c = u.Id;
        pr.Marcom_Manager__c = u.Id;
        pr.MD__c = u.Id;
        pr.Sales_Head__c = u.Id;
        pr.Site_Head__c = u.Id;
        pr.Plant__c = '4788';
        pr.Company_name__c = '4788';
        pr.Amount__c = 1000000;
        pr.Payment_Options__c = 'Payment not Required';
        insert pr;
        
         Opportunity o = new Opportunity();
        o.AccountId = ac.Id;
        o.Name = 'test';
        o.Project__c = pr.Id;
        o.Site__c = s.Id;
         o.name='test';
        o.CloseDate=System.today();
        
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        o.StageName = 'New';
        o.CloseDate = system.today() + 10;
        insert o;
       
        CloneOpportunityWithSpecificFieldsCtrl.cloneToOpportunity(o.id,'Shubham');
        String oppname=CloneOpportunityWithSpecificFieldsCtrl.getOppName( o.id);
    }
}
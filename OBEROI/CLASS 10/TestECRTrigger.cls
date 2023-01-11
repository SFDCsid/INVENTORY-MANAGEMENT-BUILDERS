@isTest
public class TestECRTrigger {
    @isTest
    public static void app(){
        Site__c s = new Site__c();
        s.Name = 'test';
        s.Active__c = true;
        insert s;
        
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'test2';
        u.Email = 'test@test.com';
        u.Username = 'test@tsaddhjasdatt.com';
        u.MobilePhone = '1234567890';
        u.CommunityNickname = 'tesdasdatshvbsihv';
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
        pr.EOI_Validity_Date__c = system.today() + 20;
        insert pr;
        
        Team__c t = new Team__c();
        t.Name = 'EOI Approver Team';
        t.Project__c = pr.Id;
        t.Team_Type__c = 'EOI Approver Team';
        insert t;
        
        Team_Members__c tm = new Team_Members__c();
        tm.Team__c = t.Id;
        tm.Approver_Type__c = 'First Level';
        tm.User__c = u.Id;
        tm.User_Active__c = true;
        insert tm;
        
        Team_Members__c tm1 = new Team_Members__c();
        tm1.Team__c = t.Id;
        tm1.Approver_Type__c = 'Second Level';
        tm1.User__c = u.Id;
        tm1.User_Active__c = true;
        insert tm1;

        Team_Members__c tm2 = new Team_Members__c();
        tm2.Team__c = t.Id;
        tm2.Approver_Type__c = 'Third Level';
        tm2.User__c = u.Id;
        tm2.User_Active__c = true;
        insert tm2;
        
        Account acc = new Account();
        acc.LastName = 'test name';
        acc.PersonEmail = 'test@stetig.in';
        acc.PersonMobilePhone = '0990995442';
        insert acc;
        
        Opportunity op = new Opportunity();
        op.name = 'test oppty';
        op.StageName = 'Contacted';
        op.Project__c = pr.id;
        op.AccountId = acc.Id;
        op.Booking__c = null;
        op.CloseDate = System.today() + 5;
        op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        insert op;
        
        ECR__c ec = new ECR__c();
        ec.Opportunity__c = op.Id;
        insert ec;
    }
}
@isTest
public class TestEOITrigger{
    
    @isTest
    public static void scenario1(){
        Site__c s = new Site__c();
        s.Name = 'test';
        s.Active__c = true;
        insert s;
        
        Site__c s1 = new Site__c();
        s1.Name = 'test';
        s1.Active__c = true;
        insert s1;
        
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
        insert pr;
        
        EOI__c enq = new EOI__c();
        enq.Applicant_Name_1__c = 'Test';
        enq.Project__c = pr.Id;
        enq.Mobile_No_1__c = '1234567890';
        enq.Email__c = 'test@stetig.in';
        insert enq;
        
        EOI__c enq1 = new EOI__c();
        enq1.Applicant_Name_1__c = 'Test';
        enq1.Project__c = pr.Id;
        enq1.Mobile_No_1__c = '0990995442';
        enq1.Email__c = 'test@stetig.in';
        enq1.Is_Channel_Partner_EOI__c = true;
        insert enq1;
        
        List<Id> eoList = new List<Id>();
        eoList.add(enq.Id);
        eoList.add(enq1.Id);
        SendEOISMS.sendSMS(eoList);
        SendEOIPDF.sendSMSwithPDF(eoList);
    }
    
    @isTest
    public static void scenario2(){
        Site__c s = new Site__c();
        s.Name = 'test';
        s.Active__c = true;
        insert s;
        
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'test2';
        u.Email = 'test@test.com';
        u.Username = 'test@tsaddasdatt.com';
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
        insert pr;
        
        Account acc = new Account();
        acc.LastName = 'test name';
        acc.PersonEmail = 'test@stetig.in';
        acc.PersonMobilePhone = '9889009775';
        insert acc;
        
        EOI__c enq = new EOI__c();
        enq.Applicant_Name_1__c = 'Test';
        enq.Project__c = pr.Id;
        enq.Mobile_No_1__c = '1234567890';
        enq.Email__c = 'test@stetig.in';
        insert enq;
        
        apexpages.currentpage().getparameters().put('eoId',enq.Id);
        EOI_ThankyouPageController et = new EOI_ThankyouPageController();
        EOIPDFController ec = new EOIPDFController();
    }
    
    @isTest
    public static void scenario3(){
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
        insert pr;
        
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
        
        EOI__c enq = new EOI__c();
        enq.Applicant_Name_1__c = 'Test';
        enq.Project__c = pr.Id;
        enq.Mobile_No_1__c = '0990995442';
        enq.Email__c = 'test@stetig.in';
        insert enq;
        
        List<Opportunity> opList = new List<Opportunity>();
        opList.add(op);
        List<Account> accList = new List<Account>();
        accList.add(acc);
        DeDupeChecker.findOptyDupeByProject(opList);
        DeDupeChecker.findPADupeByEmail(accList);
        DeDupeChecker.findPADupeByMobile(accList);
    }
}
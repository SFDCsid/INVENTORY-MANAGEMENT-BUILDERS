@isTest
public class TestSiteVisitFormController {
	@isTest
    public static void freshWalkIn() {
        Test.startTest();
        
        Account a = new Account();
        a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        a.Name = 'Test CP';
        a.phone = '1212121212';
        a.Alternate_Email__c = 'Test23@gmail.com';
        insert a;
        
        Profile pr = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email='standardTest@testing.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = pr.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUser1@t1estorg.com'
                               );
        insert u;
        
        Project__c p = new Project__c();
        p.Name = 'Project';
        p.Site_Head__c = u.Id;
        insert p;
        
        Team__c t = new Team__c();
        t.Name = 'Sales Team';
        t.Project__c = p.Id;
        t.Team_Type__c = 'Sales Team';
        insert t;
        
        Team_Members__c tm = new Team_Members__c();
        tm.User__c = u.Id;
        tm.Team__c = t.Id;
        tm.Assignment_Counter__c = 0;
        tm.Availability__c = true;
        insert tm;
        
        PageReference pageRef = Page.SearchPage;
        Test.setCurrentPage(pageRef);        
        SearchPageController sp = new SearchPageController();
        sp.l.MobilePhone = '1122334455';
        sp.l.Email = 'Test@gmail.com';
        sp.l.Project__c = p.id;
        sp.cancel();
        sp.search();
        sp.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('Test@gmail.com'));
        SiteVisitFormController svf = new SiteVisitFormController();
        svf.sv.Salutation__c = 'Mr.';
        svf.sv.First_Name__c = 'SV';
        svf.sv.Last_Name__c = 'Test';
        svf.sv.Age_Group__c = '25 to 30 Years';
        svf.sv.Company_Name__c = 'Test Company';
        svf.sv.Occupation__c = 'Shop owner';
        svf.sv.Designation__c = 'Owner';
        svf.sv.Project__c = p.id;
        svf.sv.Configuration_Required__c = '1BHK';
        svf.sv.Budget__c = 'Budget less than 80 lakhs';
        svf.sv.Master_Source__c = 'Channel Partner';
        svf.sv.Lead_Source__c = 'Channel Partner';
        svf.cpName = 'Test CP-1212121212';
        
            
        svf.closeForm();
        ApexPages.currentPage().getParameters().put('currentTab', '0');
        svf.validateInput();
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        svf.submit();
        
        Site_Visit__c getSV = [Select Id, Sales_Manager_Feedback__c from Site_Visit__c ORDER BY CreatedDate DESC LIMIT 1];
        getSV.Sales_Manager_Feedback__c = 'Test';
        update getSV;
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.MobilePhone = '1122334455';
        sp1.l.Email = 'Test@gmail.com';
        sp1.l.Project__c = p.id;
        sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('Test@gmail.com'));
        SiteVisitFormController svf1 = new SiteVisitFormController();
        svf1.getTypes2();
        svf1.getTypes3();
        svf1.getTypes4();
        svf1.getTypes5();
        svf1.getTypes6();
        svf1.getTypes7();
        svf1.getTypes8();
        svf1.getTypes9();
        svf1.getTypes10();
        svf1.getTypes11();
        svf1.getTypes12();
        svf1.getTypes13();
        svf1.submit();
        
        PageReference pageRef2 = Page.SearchPage;
        Test.setCurrentPage(pageRef2);        
        SearchPageController sp2 = new SearchPageController();
        sp2.l.MobilePhone = '1122334455';
        sp2.l.Email = 'Test@gmail.com';
        sp2.l.Project__c = p.id;
        sp2.search();
        sp2.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('Test@gmail.com'));
        SiteVisitFormController svf2 = new SiteVisitFormController();
        svf2.sv.Configuration_Required__c = '1BHK';
        svf2.sv.Budget__c = 'Budget less than 80 lakhs';
        svf2.sv.Master_Source__c = 'Channel Partner';
        svf2.sv.Lead_Source__c = 'Channel Partner';
        svf2.cpName = 'Test CP-1212121212';
        svf2.submit();
        
        Test.stopTest();
    }
    
    @isTest
    public static void walkInforLead() {
        Test.startTest();
        Profile pr = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email='standardTest@testing.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = pr.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUser1@t1estorg.com'
                               );
        insert u;
        
        Project__c p = new Project__c();
        p.Name = 'Project';
        p.Site_Head__c = u.Id;
        insert p;
        
        Team__c t = new Team__c();
        t.Name = 'Sales Team';
        t.Project__c = p.Id;
        t.Team_Type__c = 'Sales Team';
        insert t;
        
        Team_Members__c tm = new Team_Members__c();
        tm.User__c = u.Id;
        tm.Team__c = t.Id;
        tm.Assignment_Counter__c = 0;
        tm.Availability__c = true;
        insert tm;
        
		Lead l = new Lead();
        l.Salutation = 'Mr.';
        l.FirstName = 'Test';
        l.LastName = 'Customer';
        l.Alternate_Email_Id__c = 'Test240@gmail.com';
        l.MobilePhone = '1122334455';
        l.Email = 'test@gmail.com';
        l.Project__c = p.Id;
        l.Age_Group__c = '25 to 30 Years';
        l.Gender__c = 'Male';
        l.Designation__c = 'Owner';
        l.Martial_Status__c = 'Married';
        l.Occupation__c = 'Shop owner';
        l.Configuration_Required__c = '1BHK';
        l.Current_Residence_Status__c = 'Rented';
        l.Budget__c = 'Budget less than 80 lakhs';
        l.Master_Source__c = 'Digital';
        l.Lead_Source__c = 'Aggregator';
        l.Lead_Sub_Source__c = 'Magicbricks';
        l.Lead_Sub_Source_Details__c = 'Magicbricks';
        l.Purchase_Timeframe__c = 'Ready to move-in	';
        l.Possession_Timeframe_Required__c = 'Ready to Move in (RTMI)';
        insert l;
        
        PageReference pageRef = Page.SearchPage;
        Test.setCurrentPage(pageRef);        
        SearchPageController sp = new SearchPageController();
        sp.l.MobilePhone = '1122334455';
        sp.l.Email = 'Test@gmail.com';
        sp.l.Project__c = p.id;
        sp.search();
        sp.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('test@gmail.com'));
        SiteVisitFormController svf = new SiteVisitFormController();
        svf.submit();
        
        PageReference pageRef3 = Page.SearchPage;
        Test.setCurrentPage(pageRef3);        
        SearchPageController sp3 = new SearchPageController();
        sp3.l.MobilePhone = '1122334444';
        sp3.l.Email = 'Test4@gmail.com';
        sp3.l.Project__c = p.id;
        sp3.cancel();
        sp3.search();
        sp3.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334444'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('Test4@gmail.com'));
        SiteVisitFormController svf3 = new SiteVisitFormController();
        svf3.sv.Salutation__c = 'Mr.';
        svf3.sv.First_Name__c = 'SV';
        svf3.sv.Last_Name__c = 'Test';
        svf3.sv.Age_Group__c = '25 to 30 Years';
        svf3.sv.Company_Name__c = 'Test Company';
        svf3.sv.Occupation__c = 'Shop owner';
        svf3.sv.Designation__c = 'Owner';
        svf3.sv.Project__c = p.id;
        svf3.sv.Configuration_Required__c = '1BHK';
        svf3.sv.Budget__c = 'Budget less than 80 lakhs';
        svf3.sv.Master_Source__c = 'Channel Partner';
        svf3.sv.Lead_Source__c = 'Channel Partner';
        svf3.cpName = 'Test CP-1212121212';
        svf3.submit();
        
        Site_Visit__c sv = [Select Id, Name from Site_Visit__c ORDER BY CreatedDate ASC LIMIT 1];
        
        Site_Visit__c cSV = SM_AssignmentController.getSVRecord(sv.Id);
        List<Team_Members__c> tmList = SM_AssignmentController.getAllSalesManager(cSV);
        Team_Members__c getTM = SM_AssignmentController.checkUserAvailability(tmList[0].Id);
        Boolean result = SM_AssignmentController.assignSalesManager(cSV, tmList[0]);
        
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project';
        p1.Site_Head__c = u.Id;
        insert p1;
        
        Team__c t1 = new Team__c();
        t1.Name = 'Sales Team';
        t1.Project__c = p1.Id;
        t1.Team_Type__c = 'Sales Team';
        insert t1;
        
        Team_Members__c tm1 = new Team_Members__c();
        tm1.User__c = u.Id;
        tm1.Team__c = t1.Id;
        tm1.Assignment_Counter__c = 0;
        tm1.Availability__c = true;
        insert tm1;
        
        Account a = new Account();
        a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        a.LastName = 'Test Customer';
        a.PersonMobilePhone = '1212121212';
        a.PersonEmail = 'Test23@gmail.com';
        insert a;
        
		Lead l1 = new Lead();
        l1.Salutation = 'Mr.';
        l1.FirstName = 'Test';
        l1.LastName = 'Customer';
        l1.Alternate_Email_Id__c = 'Test240@gmail.com';
        l1.MobilePhone = '1122334455';
        l1.Email = 'test@gmail.com';
        l1.Project__c = p1.Id;
        l1.Age_Group__c = '25 to 30 Years';
        l1.Gender__c = 'Male';
        l1.Designation__c = 'Owner';
        l1.Martial_Status__c = 'Married';
        l1.Occupation__c = 'Shop owner';
        l1.Configuration_Required__c = '1BHK';
        l1.Current_Residence_Status__c = 'Rented';
        l1.Budget__c = 'Budget less than 80 lakhs';
        l1.Master_Source__c = 'Digital';
        l1.Lead_Source__c = 'Aggregator';
        l1.Lead_Sub_Source__c = 'Magicbricks';
        l1.Lead_Sub_Source_Details__c = 'Magicbricks';
        l1.Purchase_Timeframe__c = 'Ready to move-in	';
        l1.Possession_Timeframe_Required__c = 'Ready to Move in (RTMI)';
        insert l1;
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.MobilePhone = '1122334455';
        sp1.l.Email = 'Test@gmail.com';
        sp1.l.Project__c = p1.id;
        sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p1.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('test@gmail.com'));
        SiteVisitFormController svf1 = new SiteVisitFormController();
        svf.sv.Master_Source__c = 'Recommended by Friends/Relatives';
        svf.sv.Lead_Source__c = 'Customers';
        svf.refName = 'Test Customer-1212121212';
        svf1.submit();
        
        Test.stopTest();
    }
    
    @isTest
    public static void validationCheck() {
        Project__c p = new Project__c();
        p.Name = 'Project';
        insert p;
        
        Test.startTest();
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.MobilePhone = '1122334455';
        sp1.l.Email = 'Test@gmail.com';
        sp1.l.Project__c = p.id;
        sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('Test@gmail.com'));
        SiteVisitFormController svf = new SiteVisitFormController();
        ApexPages.currentPage().getParameters().put('currentTab', '0');
        svf.validateInput();
        
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        
        svf.sv.Master_Source__c = 'Channel Partner';
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        
        svf.sv.Master_Source__c = 'Channel Partner';
        svf.sv.Lead_Source__c = 'Channel Partner';
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        
        svf.sv.Master_Source__c = 'Recommended by Friends/Relatives	';
        svf.sv.Lead_Source__c = 'Customers';
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        
        svf.sv.Master_Source__c = 'Recommended by Friends/Relatives	';
        svf.sv.Lead_Source__c = 'Employees';
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        
        svf.sv.Master_Source__c = 'Other';
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        
        ApexPages.currentPage().getParameters().put('currentTab', '3');
        svf.validateInput();
        
        Test.stopTest();
    }
}
@isTest
public class TestSiteVisitFormController {
    @isTest
    public static Project__c createProject() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        
        
        User u = new User(
            Username = uniqueName + '@test' + orgId + '.org',
            Email = uniqueName + '@test' + orgId + '.org',
            LastName = 'LastName',
            FirstName = 'FirstName',
            Alias = uniqueName.substring(18, 23),
            ProfileId = UserInfo.getProfileId(),
            EmailEncodingKey='UTF-8',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Los_Angeles',
            Country = 'US',
            Title = 'Territory Manager'
        );
        insert u;
        
        Project__c p = new Project__c();
        p.Name = 'Project';
        insert p;
        
        Team__c t = new Team__c();
        t.Name = 'Project Sales Team';
        t.Project__c = p.Id;
        t.Team_Type__c = 'Sales Team';
        insert t;
        
        Team_Member__c tm = new Team_Member__c();
        tm.Team__c = t.Id;
        tm.Availability__c = true;
        tm.User__c = u.Id;
        insert tm;
        
        return p; 
    }
    
    
    public static void  createLead() {
        
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p; 
        
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.IsActive__c = true;
        c2.Type__c = 'Event'; 
        c2.Project__c = p.Id;
        c2.StartDate__c = system.today();
        c2.EndDate__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        insert c2;
        
        Account a = new Account();
        a.FirstName = 'Test';
        a.LastName = 'Account';
        a.PersonMobilePhone = '2121212121';
        a.Alternate_Email__c = 'Test2@gmail.com';
        a.PersonEmail = 'Test24@gmail.com';
        a.Phone = 'Testq@gmail.com';
        insert a;
        
        Channel_Partner__c cp = new Channel_Partner__c();
        cp.Name = 'Test';
        cp.CP_Type__c = 'ICP';
        cp.CP_Firm_Type__c = 'Individual';
        cp.Alternate_Email__c = 'Test@gmail.com';
        insert cp;
        
        Lead__c l = new Lead__c();
        l.First_Name__c = 'Test';
        l.Last_Name__c = 'Customer';
        l.MobilePhone__c = '1122334455';
        l.Email__c = 'customer@test.in';
        l.Project__c = p.id;
        l.Channel_Partner__c = cp.id;
        l.Age_Group__c = '25 to 30 Years';
        l.Gender__c = 'Male';
        l.Designation__c = 'Owner';
        l.Marital_Status__c = 'Married';
        l.Occupation__c = 'Shop owner';
        l.Family_Size__c = 'Joint Family';
        l.Highest_Education__c = 'Engineer';
        l.Current_Residence_Configuration__c = '1 BHK';
        l.Current_Residence_Status__c = 'Rented';
        l.Ethinicity__c = 'Marathi';
        l.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        l.Industry__c = 'Consulting';
        l.Configuration_Required__c = '2 BHK';
        l.Budget__c = 'Budget of 50 to 60 lakhs';
        l.Referrer_Name__c = a.Id;
        l.Campaign_Custom__c = c2.Id;
        insert l;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Name = 'Test';
        opp.AccountId__c = a.id;
        opp.Campaign_Custom__c = c2.id;
        opp.Project__c = p.id;
        opp.StageName__c = 'Booking Confirmed';
        opp.Referrer_Name__c = userinfo.getName();
        opp.Presales_Manager__c = userinfo.getUserId();
        insert opp;
        
        
        Lead__c l2 = new Lead__c();
        l2.First_Name__c = 'Test';
        l2.Last_Name__c = 'Customer';
        l2.MobilePhone__c = '1122334455';
        l2.Email__c = 'customer@test.in';
        l2.Alternate_Email__c = 'customer24@test.in';
        l2.Project__c = p.id;
        l2.Age_Group__c = '25 to 30 Years';
        l2.Gender__c = 'Male';
        l2.Designation__c = 'Owner';
        l2.Marital_Status__c = 'Married';
        l2.Occupation__c = 'Shop owner';
        l2.Family_Size__c = 'Joint Family';
        l2.Highest_Education__c = 'Engineer';
        l2.Current_Residence_Configuration__c = '1 BHK';
        l2.Current_Residence_Status__c = 'Rented';
        l2.Ethinicity__c = 'Marathi';
        l2.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        l2.Industry__c = 'Consulting';
        l2.Configuration_Required__c = '2 BHK';
        l2.Budget__c = 'Budget of 50 to 60 lakhs';
        l2.Referrer_Name__c = a.Id;
        l2.Campaign_Custom__c = c2.Id;
        l2.ConvertedAccountId__c = a.id;
        l2.ConvertedOpportunityId__c = opp.id;
        l2.IsConverted__c = true;
        insert l2;
        
        
    }
    
    @isTest
    public static Channel_Partner__c createCP() {
        Channel_Partner__c a = new Channel_Partner__c();
        a.Name = 'Test CP';
        a.Mobile__c = '1212121212';
        a.PAN_No__c = 'ASDFR1234E';
        insert a;
        return a;
    }
    
    @isTest
    public static void freshWalkIn() {
        Test.startTest();
        
        Channel_Partner__c a = createCP();
        Project__c p = createProject();
        Project__c p1 = new Project__c();
        p1.Name = 'New Project';
        insert p1;
        
        PageReference pageRef = Page.SearchPage;
        Test.setCurrentPage(pageRef);        
        SearchPageController sp = new SearchPageController();
        sp.l.MobilePhone__c = '1478596300';
        sp.l.Email__c = 'sv@test.in';
        sp.cancel();
        sp.search();
        sp.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1478596300'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('sv@test.in'));
        SiteVisitFormController svf = new SiteVisitFormController();
        svf.sv.Salutation__c = 'Mr.';
        svf.sv.First_Name__c = 'SV';
        svf.sv.Last_Name__c = 'Test';
        svf.sv.Email__c = 'Test@gmail.com';
        svf.sv.Purchase_Timeframe__c = 'Ready to move-in';
        svf.sv.Project_Type__c = 'RTMI';
        svf.sv.Possession_Timeframe_Required__c = 'Ready to Move in (RTMI)';
        svf.sv.Buying_Purpose__c = 'Self-Use';
        svf.sv.Citizenship__c = 'Indian';
        svf.sv.Street_1__c = 'Test1';
        svf.sv.Locality__c = 'IND';
        svf.sv.City__c = 'Test24'; 
        svf.sv.State__c = 'MH';
        svf.sv.Country__c = 'India';
        svf.sv.Pincode__c = '450331';
        svf.sv.House_No__c = '787q';
        svf.sv.Media__c = 'Print';
        svf.sv.Company_Name__c = 'Test';
        svf.sv.Age_Group__c = '25 to 30 Years';
        svf.sv.Company_Name__c = 'Test Company';
        svf.sv.Occupation__c = 'Shop owner';
        svf.sv.Designation__c = 'Owner';
        svf.sv.Configuration_Required__c = '1 BHK';
        svf.sv.Budget__c = 'Budget of 50 to 60 lakhs';
        svf.sv.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        
        svf.cpName = 'Test CP-1212121212';
        svf.closeForm();
        ApexPages.currentPage().getParameters().put('currentTab', '0');
        svf.validateInput();
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        svf.submit();
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.MobilePhone__c = '1478596300';
        sp1.l.Email__c = 'sv@test.in';
        sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1478596300'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('sv@test.in'));
        SiteVisitFormController svf1 = new SiteVisitFormController();
        svf1.submit();
        
        Site_Visit__c sv = [Select Id,Citizenship__c,Company_Name__c,House_No__c,Street_1__c,Locality__c,City__c,State__c,
                           Country__c,Pincode__c,Media__c, Comments__c, StageName__c, Sub_Stage__c,Opportunity__c
                            from Site_Visit__c ORDER BY CreatedDate ASC LIMIT 1];
        
        Site_Visit__c cSV = SM_AssignmentController.getSVRecord(sv.Id);
        List<Team_Member__c> tmList = SM_AssignmentController.getAllSalesManager(cSV);
        Team_Member__c tm = SM_AssignmentController.checkUserAvailability(tmList[0].Id);
        Boolean result = SM_AssignmentController.assignSalesManager(cSV, tmList[0]);
        
        sv.Comments__c = 'Test SV';
        sv.StageName__c = 'Inventory Selected';
        sv.Sub_Stage__c = 'Inventory Selected';
        sv.Next_Follow_up_Date__c = system.now().addDays(1);
        update sv;
        
        PageReference pageRef2 = Page.SearchPage;
        Test.setCurrentPage(pageRef2);        
        SearchPageController sp2 = new SearchPageController();
        sp2.l.MobilePhone__c = '1478596300';
        sp2.l.Email__c = 'sv@test.in';
        sp2.search();
        sp2.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p1.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1478596300'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('sv@test.in'));
        SiteVisitFormController svf2 = new SiteVisitFormController();
        svf2.sv.Configuration_Required__c = '1 BHK';
        svf2.sv.Budget__c = '50 Lakhs and above';
        svf2.sv.Media__c = 'Channel Partner';
        svf2.cpName = 'Test CP-1212121212';
        svf2.submit();
        
        Test.stopTest();
    }
    
    @isTest
    public static void walkInforLead() {
        Test.startTest();
        
        Project__c p = createProject();
        //Lead__c l = createLead(p.Id);
      
        
        Account a = new Account();
        a.FirstName = 'Test';
        a.LastName = 'Account';
        a.PersonMobilePhone = '2121212121';
        a.Alternate_Email__c = 'Test2@gmail.com';
        a.PersonEmail = 'Test24@gmail.com';
    	insert a;
        
        Lead__c l = new Lead__c();
        l.Salutation__c = 'Mr.';
        l.First_Name__c = 'Test';
        l.Last_Name__c = 'Customer';
        l.MobilePhone__c = '1122334455';
        l.Email__c = 'customer@test.in';
        l.Project__c = p.id;
        l.Age_Group__c = '25 to 30 Years';
        l.Gender__c = 'Male';
        l.Designation__c = 'Owner';
        l.Marital_Status__c = 'Married';
        l.Occupation__c = 'Shop owner';
        l.Family_Size__c = 'Joint Family';
        l.Highest_Education__c = 'Engineer';
        l.Current_Residence_Configuration__c = '1 BHK';
        l.Current_Residence_Status__c = 'Rented';
        l.Ethinicity__c = 'Marathi';
        l.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        l.Industry__c = 'Consulting';
        l.Configuration_Required__c = '2 BHK';
        l.Budget__c = 'Budget of 50 to 60 lakhs';
        insert l;
        
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.IsActive__c = true;
        c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        //c2.Marketing_Brief__c = Mb.id;
        c2.StartDate__c = system.today();
        c2.EndDate__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.Status__c = 'Completed';
        c2.Amount__c = 0;
        c2.GST__c = 'GST 5%';
        c2.Discount__c = 0;
        c2.Actual_Leads__c = 0;
        c2.Actual_Visits__c = 0;
        c2.Actual_Bookings__c = 0;
        c2.Planned_Leads__c = 20;
        c2.Planned_Visits__c = 10;
        c2.Planned_Cost__c = 100;
        c2.Campaign_Code__c = 'AVJH7';
        insert c2;
        
        Project__c p1 = new Project__c();
        p1.Name = 'New Project';
        insert p1;
        //Lead l1 = createLead(p1.Id);

        Channel_Partner__c cp = new Channel_Partner__c();
        cp.Name = 'Test';
        cp.CP_Type__c = 'ICP';
        cp.CP_Firm_Type__c = 'Individual';
        cp.Alternate_Email__c = 'Test@gmail.com';
        cp.PAN_No__c = 'SDFGC8888F';
        insert cp;
        
        Lead__c l1 = new Lead__c();
        l1.Salutation__c = 'Mr.';
        l1.First_Name__c = 'Test';
        l1.Last_Name__c = 'Customer';
        l1.MobilePhone__c = '1122334455';
        l1.Email__c = 'customer@test.in';
        l1.Project__c = p1.id;
        l1.Age_Group__c = '25 to 30 Years';
        l1.Gender__c = 'Male';
        l1.Designation__c = 'Owner';
        l1.Marital_Status__c = 'Married';
        l1.Occupation__c = 'Shop owner';
        l1.Family_Size__c = 'Joint Family';
        l1.Highest_Education__c = 'Engineer';
        l1.Current_Residence_Configuration__c = '1 BHK';
        l1.Current_Residence_Status__c = 'Rented';
        l1.Ethinicity__c = 'Marathi';
        l1.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        l1.Industry__c = 'Consulting';
        l1.Configuration_Required__c = '2 BHK';
        l1.Budget__c = 'Budget of 50 to 60 lakhs';
        l1.Buying_Purpose__c = 'Self-Use';
        l1.Channel_Partner__c = cp.id;
        insert l1;
        
        PageReference pageRef = Page.SearchPage;
        Test.setCurrentPage(pageRef);        
        SearchPageController sp = new SearchPageController();
        sp.l.MobilePhone__c = '1122334455';
        sp.l.Email__c = 'customer@test.in';
        
        sp.search();
        sp.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('customer@test.in'));
        SiteVisitFormController svf = new SiteVisitFormController();
        svf.submit();
        
        Opportunity__c op = [Select Id, Campaign_Custom__c,AccountId__c,Project__c,StageName__c from Opportunity__C ORDER BY CreatedDate ASC LIMIT 1];
        op.Campaign_Custom__c = c2.Id;
        op.AccountId__c = a.id;
        op.Project__c = p1.id;
        op.StageName__c = 'Booking Confirmed';
        update op;
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.MobilePhone__c = '1122334455';
        sp1.l.Email__c = 'customer@test.in';
        sp1.search();
        sp1.continueMethod();
        
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p1.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('customer@test.in'));
        SiteVisitFormController svf1 = new SiteVisitFormController();
        SiteVisitFormController.getChannelPartner(cp.Name);
        SiteVisitFormController.getReferrerName(a.Name);
        svf1.submit();
        
        Test.stopTest();
    }
    
    
    
     @isTest
    public static void walkInforLead22() {
        Test.startTest();
        
        Project__c p = createProject();
        //Lead__c l = createLead(p.Id);
        
        Project__c p1 = new Project__c();
        p1.Name = 'New Project';
        insert p1;
      
        Account a = new Account();
        a.FirstName = 'Test';
        a.LastName = 'Account';
        a.PersonMobilePhone = '2121212121';
        a.Alternate_Email__c = 'Test2@gmail.com';
        a.PersonEmail = 'Test24@gmail.com';
    	insert a;
        
        Lead__c l = new Lead__c();
        l.Salutation__c = 'Mr.';
        l.First_Name__c = 'Test';
        l.Last_Name__c = 'Customer';
        l.MobilePhone__c = '1122334455';
        l.Email__c = 'customer@test.in';
        l.Project__c = p1.id;
        l.Age_Group__c = '25 to 30 Years';
        l.Gender__c = 'Male';
        l.Designation__c = 'Owner';
        l.Marital_Status__c = 'Married';
        l.Occupation__c = 'Shop owner';
        l.Family_Size__c = 'Joint Family';
        l.Highest_Education__c = 'Engineer';
        l.Current_Residence_Configuration__c = '1 BHK';
        l.Current_Residence_Status__c = 'Rented';
        l.Ethinicity__c = 'Marathi';
        l.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        l.Industry__c = 'Consulting';
        l.Configuration_Required__c = '2 BHK';
        l.Budget__c = 'Budget of 50 to 60 lakhs';
        insert l;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.IsActive__c = true;
        c2.Type__c = 'Event'; 
        c2.Project__c = p1.id;
        //c2.Marketing_Brief__c = Mb.id;
        c2.StartDate__c = system.today();
        c2.EndDate__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.Status__c = 'Completed';
        c2.Amount__c = 0;
        c2.GST__c = 'GST 5%';
        c2.Discount__c = 0;
        c2.Actual_Leads__c = 0;
        c2.Actual_Visits__c = 0;
        c2.Actual_Bookings__c = 0;
        c2.Planned_Leads__c = 20;
        c2.Planned_Visits__c = 10;
        c2.Planned_Cost__c = 100;
        c2.Campaign_Code__c = 'AVJH7';
        insert c2;
        //Lead l1 = createLead(p1.Id);
        
        Lead__c l1 = new Lead__c();
        l1.Salutation__c = 'Mr.';
        l1.First_Name__c = 'Test';
        l1.Last_Name__c = 'Customer';
        l1.MobilePhone__c = '1122334455';
        l1.Email__c = 'customer@test.in';
        l1.Alternate_Email__c = 'customer24@test.in';
        l1.Project__c = p1.id;
        l1.Age_Group__c = '25 to 30 Years';
        l1.Gender__c = 'Male';
        l1.Designation__c = 'Owner';
        l1.Marital_Status__c = 'Married';
        l1.Occupation__c = 'Shop owner';
        l1.Family_Size__c = 'Joint Family';
        l1.Highest_Education__c = 'Engineer';
        l1.Current_Residence_Configuration__c = '1 BHK';
        l1.Current_Residence_Status__c = 'Rented';
        l1.Ethinicity__c = 'Marathi';
        l1.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        l1.Industry__c = 'Consulting';
        l1.Configuration_Required__c = '2 BHK';
        l1.Budget__c = 'Budget of 50 to 60 lakhs';
        l1.IsConverted__c = false;
        
        insert l1;
        
        PageReference pageRef = Page.SearchPage;
        Test.setCurrentPage(pageRef);        
        SearchPageController sp = new SearchPageController();
        sp.l.MobilePhone__c = '1122334455';
        sp.l.Email__c = 'customer@test.in';
        
        sp.search();
        sp.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p1.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('Test24@gmail.com'));
        SiteVisitFormController svf = new SiteVisitFormController();
        svf.submit();
        
        Opportunity__c op = [Select Id, Campaign_Custom__c,AccountId__c,Project__c,StageName__c from Opportunity__C ORDER BY CreatedDate ASC LIMIT 1];
        op.Campaign_Custom__c = c2.Id;
        op.AccountId__c = a.id;
       // op.Project__c = p1.id;
        op.StageName__c = 'Booking Confirmed';
        update op;
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.MobilePhone__c = '1122334455';
        sp1.l.Email__c = 'customer@test.in';
        sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p1.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('Test24@gmail.com'));
        SiteVisitFormController svf1 = new SiteVisitFormController();
        svf1.submit();
        
        Test.stopTest();
    }
    
    
    
    @isTest
    public static void validationCheck() {
        Project__c p = createProject();
        
        Test.startTest();
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.MobilePhone__c = '1122334455';
        sp1.l.Email__c = 'customer@test.in';
        sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('customer@test.in'));
        SiteVisitFormController svf = new SiteVisitFormController();
        ApexPages.currentPage().getParameters().put('currentTab', '0');
        svf.validateInput();
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        svf.sv.Pincode__c = '454545';
        svf.sv.Last_Name__c = 'test';
        svf.sv.First_Name__c = 'test';
        svf.sv.Salutation__c = 'Mr.';
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.sv.Locality__c = 'Test';
        svf.sv.City__c = 'Pune';
        svf.validateInput();
        //svf.sv.Master_Source__c = 'Channel Partner';
        //svf.sv.Lead_Source__c = 'Channel Partner';
        ApexPages.currentPage().getParameters().put('currentTab', '2');
        svf.sv.Media__c = 'Print';
        svf.validateInput();
        //svf.sv.Master_Source__c = 'Reference';
        //svf.sv.Lead_Source__c = 'Customers';
        ApexPages.currentPage().getParameters().put('currentTab', '2');
        svf.validateInput();
        //svf.sv.Master_Source__c = 'Reference';
        //svf.sv.Lead_Source__c = 'Employees';
        ApexPages.currentPage().getParameters().put('currentTab', '2');
        svf.validateInput();
        //svf.sv.Master_Source__c = 'Other';
        ApexPages.currentPage().getParameters().put('currentTab', '2');
        svf.validateInput();
        ApexPages.currentPage().getParameters().put('currentTab', '3');
        svf.sv.Budget__c = 'Budget of 30 to 40 lakhs';
        svf.sv.Configuration_Required__c = '1.5 BHK';
        svf.validateInput();
        
        Test.stopTest();
    }
}
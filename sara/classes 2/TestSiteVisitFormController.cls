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
        p.Cluster__c = 'Cluster A';
        insert p;
        
        Team__c t = new Team__c();
        t.Name = 'Project Sales Team';
        t.Project__c = p.Id;
        t.Team_Type__c = 'Sales Team';
        insert t;
        
        Team_Members__c tm = new Team_Members__c();
        tm.Team__c = t.Id;
        tm.Availability__c = true;
        tm.User__c = u.Id;
        insert tm;
        
        return p;
    }
    
    
    public static Lead createLead(Id pId) {
        Campaign c1 = new Campaign();
        c1.Name = 'Parent Campaign';
        c1.IsActive = true;
        insert c1;
        
        Campaign c2 = new Campaign();
        c2.Name = 'Test Project';
        c2.ParentId = c1.Id;
        c2.IsActive = true;
        c2.Type = 'Advertisement'; 
        c2.Master_Source__c = 'Digital';
        c2.Lead_Source__c = 'Aggregator';
        c2.Lead_Sub_Source__c = 'Magicbricks';
        c2.Project__c = pId;
        c2.StartDate = system.today();
        c2.EndDate = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        insert c2;
        
        Lead l = new Lead();
        l.Salutation = 'Mr.';
        l.FirstName = 'Test';
        l.LastName = 'Customer';
        l.MobilePhone = '1122334455';
        l.Email = 'customer@test.in';
        l.Project__c = pId;
        l.DOB__c = system.today() - 10000;
        l.Age_Group__c = '25 to 30 Years';
        l.Gender__c = 'Male';
        l.Designation__c = 'Owner';
        l.Marital_Status__c = 'Married';
        l.Occupation__c = 'Shop owner';
        l.Family_Size__c = 'Joint Family';
        l.Highest_Education__c = 'Engineer';
        l.Current_Residence_Configuration__c = '1 BHK';
        l.Citizenship__c = 'Indian';
        l.Current_Residence_Status__c = 'Rented';
        l.Ethinicity__c = 'Marathi';
        l.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        l.Industry = 'Consulting';
        l.Company_Name__c = 'Test Company';
        l.Configuration_Required__c = '2 BHK';
        l.Budget__c = '50 Lakhs and above';
        l.Master_Source__c = 'Reference';
        l.Lead_Source__c = 'Customers';
        l.Reference_Name__c = 'Test Customer 2';
        l.Campaign_Custom__c = c2.Id;
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
        Database.SaveResult sr = Database.insert(l, dml);
        //insert l;
        return l;
    }
    
    @isTest
    public static void freshWalkIn() {
        Test.startTest();
        
        Project__c p = createProject();
        Project__c p1 = new Project__c();
        p1.Name = 'New Project';
        p1.Cluster__c = 'Cluster B';
        insert p1;
        
        PageReference pageRef = Page.SearchPage;
        Test.setCurrentPage(pageRef);        
        SearchPageController sp = new SearchPageController();
        sp.l.MobilePhone = '1478596300';
        sp.l.Email = 'sv@test.in';
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
        svf.sv.Birth_Date__c = system.today() - 100000;
        svf.sv.Anniversary_Date__c = system.today() - 100;
        svf.sv.Age_Group__c = '25 to 30 Years';
        svf.sv.Company_Name__c = 'Test Company';
        svf.sv.Occupation__c = 'Shop owner';
        svf.sv.Designation__c = 'Owner';
        svf.sv.Configuration_Required__c = '1 BHK';
        svf.sv.Budget__c = '50 Lakhs and above';
        svf.sv.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        svf.sv.Visit_For__c = '1st Time';
        svf.sv.Master_Source__c = 'Channel Partner';
        svf.sv.Lead_Source__c = 'Channel Partner';
        svf.sv.Channel_Partner_Name__c = 'Test CP';
        svf.closeForm();
        ApexPages.currentPage().getParameters().put('currentTab', '0');
        svf.validateInput();
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        svf.submit();
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.MobilePhone = '1478596300';
        sp1.l.Email = 'sv@test.in';
        sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1478596300'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('sv@test.in'));
        SiteVisitFormController svf1 = new SiteVisitFormController();
        svf1.submit();
        
        Site_Visit__c sv = [Select Id, Comments__c, StageName__c, Sub_Stage__c, Sub_Stage_Reason__c from Site_Visit__c ORDER BY CreatedDate ASC LIMIT 1];
        
        Site_Visit__c cSV = SM_AssignmentController.getSVRecord(sv.Id);
        List<Team_Members__c> tmList = SM_AssignmentController.getAllSalesManager(cSV);
        Team_Members__c tm = SM_AssignmentController.checkUserAvailability(tmList[0].Id);
        Boolean result = SM_AssignmentController.assignSalesManager(cSV, tmList[0]);
        
        sv.Comments__c = 'Test SV';
        sv.StageName__c = 'In Follow-up';
        sv.Sub_Stage__c = 'Hot';
        sv.Sub_Stage_Reason__c = 'All Good Expected Closure';
        sv.Next_Follow_up_Date__c = system.now().addDays(1);
        update sv;
        
        PageReference pageRef2 = Page.SearchPage;
        Test.setCurrentPage(pageRef2);        
        SearchPageController sp2 = new SearchPageController();
        sp2.l.MobilePhone = '1478596300';
        sp2.l.Email = 'sv@test.in';
        sp2.search();
        sp2.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p1.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1478596300'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('sv@test.in'));
        SiteVisitFormController svf2 = new SiteVisitFormController();
        svf2.sv.Configuration_Required__c = '1 BHK';
        svf2.sv.Budget__c = '50 Lakhs and above';
        svf2.sv.Visit_For__c = '1st Time';
        svf2.sv.Master_Source__c = 'Channel Partner';
        svf2.sv.Lead_Source__c = 'Channel Partner';
        svf2.sv.Channel_Partner_Name__c = 'Test CP';
        svf2.submit();
        
        Test.stopTest();
    }
    
    @isTest
    public static void walkInforLead() {
        Test.startTest();
        
        Project__c p = createProject();
        Lead l = createLead(p.Id);
        
        Campaign c1 = new Campaign();
        c1.Name = 'Parent Campaign';
        c1.IsActive = true;
        insert c1;
        
        Campaign c2 = new Campaign();
        c2.Name = 'Test Project';
        c2.ParentId = c1.Id;
        c2.IsActive = true;
        c2.Type = 'Advertisement'; 
        c2.Master_Source__c = 'Digital';
        c2.Lead_Source__c = 'Aggregator';
        c2.Lead_Sub_Source__c = 'Magicbricks';
        c2.Project__c = p.Id;
        c2.StartDate = system.today();
        c2.EndDate = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        insert c2;
        
        Project__c p1 = new Project__c();
        p1.Name = 'New Project';
        p1.Cluster__c = 'Cluster B';
        insert p1;
        Lead l1 = createLead(p1.Id);
        
        PageReference pageRef = Page.SearchPage;
        Test.setCurrentPage(pageRef);        
        SearchPageController sp = new SearchPageController();
        sp.l.MobilePhone = '1122334455';
        sp.l.Email = 'customer@test.in';
        sp.search();
        sp.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('customer@test.in'));
        SiteVisitFormController svf = new SiteVisitFormController();
        svf.submit();
        
        Opportunity op = [Select Id, Campaign_Custom__c from Opportunity ORDER BY CreatedDate ASC LIMIT 1];
        op.Campaign_Custom__c = c2.Id;
        update op;
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.MobilePhone = '1122334455';
        sp1.l.Email = 'customer@test.in';
        //sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p1.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('customer@test.in'));
        SiteVisitFormController svf1 = new SiteVisitFormController();
        svf1.submit();
        
        Test.stopTest();
    }
    
    @isTest
    public static void walkInonDiffProject() {
        Test.startTest();
        
        Project__c p = createProject();
        Lead l = createLead(p.Id);
        
        Project__c p1 = new Project__c();
        p1.Name = 'New Project';
        p1.Cluster__c = 'Cluster A';
        insert p1;
        //Lead l1 = createLead(p1.Id);
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.MobilePhone = '1122334455';
        sp1.l.Email = 'customer@test.in';
        sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p1.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('customer@test.in'));
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
        sp1.l.MobilePhone = '1122334455';
        sp1.l.Email = 'customer@test.in';
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
        svf.sv.Master_Source__c = 'Channel Partner';
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        svf.sv.Master_Source__c = 'Channel Partner';
        svf.sv.Lead_Source__c = 'Channel Partner';
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        svf.sv.Master_Source__c = 'Reference';
        svf.sv.Lead_Source__c = 'Customers';
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        svf.sv.Master_Source__c = 'Reference';
        svf.sv.Lead_Source__c = 'Employees';
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        svf.sv.Master_Source__c = 'Other';
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        
        Test.stopTest();
    }
}
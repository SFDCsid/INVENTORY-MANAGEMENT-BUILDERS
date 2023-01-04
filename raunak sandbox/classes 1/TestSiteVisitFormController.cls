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
        
        /* Team__c t = new Team__c();
t.Name = 'Project Sales Team';
t.Project__c = p.Id;
t.Team_Type__c = 'Sales Team';
insert t;

Team_Members__c tm = new Team_Members__c();
tm.Team__c = t.Id;
tm.Availability__c = true;
tm.User__c = u.Id;
insert tm;  */
        
        return p; 
    }
    
    @isTest 
    public static void  createLead() {
        
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p; 
        
         Team__c tm1 = new Team__c();
        tm1.Project__c = p.id;
        tm1.Name = 'Test24';
        tm1.Team_Type__c = 'Presales Team';
        
        insert tm1;
        
        Team_Members__c tmm1 = new Team_Members__c();
        tmm1.Team__c = tm1.id;
        tmm1.User_Active__c = true;
        tmm1.Sequence_Number__c = 10;
        tmm1.Availability__c = true;
        tmm1.User__c = userinfo.getUserId();
        insert tmm1;
        
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true;
       // c2.Type__c = 'Event'; 
        c2.Project__c = p.Id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        insert c2;
        
        Account a = new Account();
        a.FirstName = 'Test';
        a.LastName = 'Account';
        a.PersonMobilePhone = '2121212121';
       // a.Alternate_Email__c = 'Test2@gmail.com';
        a.PersonEmail = 'Test24@gmail.com';
        a.Phone = 'Testq@gmail.com';
        insert a;
        
        CP_Project__c cp = new CP_Project__c();
        cp.CP_Account__c = a.id;
        cp.CP_Project_Name__c = p.id;
      
         insert cp;
        
        Lead_c__c l = new Lead_c__c();
        l.First_Name__c = 'Test';
        l.Last_Name__c = 'Customer';
        l.Mobile__c = '1122334455';
        l.Email__c = 'customer@test.in';
        l.Project_Name__c = p.id;
        l.CP_Project__c = cp.id;
        l.Age_Group__c = '25 to 30 Years';
        l.Gender__c = 'Male';
        l.Designation__c = 'Owner';
        l.Martial_Status__c = 'Married';
        l.Master_Source_Category__c = 'Hoardings';
        l.Lead_Source__c = 'Billboard';
        l.Occupation__c = 'Shop owner';
        l.Family_Size__c = 'Joint Family';
        l.Lead_Stage__c = 'Visit Done';
        l.Highest_Education__c = 'Engineer';
        l.Current_Residence_Configuration__c = '1 BHK';
        l.Current_Residence_Status__c = 'Rented';
        l.Ethinicity__c = 'Marathi';
        l.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        l.Industry__c = 'Consulting';
        l.OwnerId = userinfo.getUserId();
        l.Configuration_Required__c = '2 BHK';
        l.Budget__c = 'Budget of 50 to 60 lakhs';
        l.Referrer_Name__c = a.Id;
        l.Campaign_Custom__c = c2.Id;
        
        
        insert l;
        l.Apply_Round_Robin__c = true;
        update l;
        
        Opportunity_c__c opp = new Opportunity_c__c();
        opp.First_Name__c = 'Test';
        opp.Last_Name__c = 'Test2';
        opp.Account_Name__c = a.id;
        opp.Campaign_Custom__c = c2.id;
        opp.Project__c = p.id;
        opp.CP_Project__c = cp.id;
        opp.Opportunity_Stage__c = 'Lost';
        opp.Referrer_Name__c = a.id;
        opp.Presales_Manager__c = userinfo.getUserId();
        opp.Buying_Purpose__c = 'Investment';
        opp.Last_SV_Date__c = system.today();
        insert opp;
        
        
        Lead_c__c l2 = new Lead_c__c();
        l2.First_Name__c = 'Test';
        l2.Last_Name__c = 'Customer';
        l2.Mobile__c = '1122334455';
        l2.Email__c = 'customer@test.in';
        l2.Project_Name__c = p.id;
        l2.CP_Project__c = cp.id;
        l2.Age_Group__c = '25 to 30 Years';
        l2.Gender__c = 'Male';
        l2.Designation__c = 'Owner';
        l2.Martial_Status__c = 'Married';
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
        l2.Account__c = a.id;
        l2.Opportunity_c__c = opp.id;
        l2.IsConverted__c = true;
        insert l2;
        
        
        Site_Visit__c sv = new Site_Visit__c();
        sv.Opportunity_c__c = opp.id;
        sv.Buying_Purpose__c = 'Investment';
        sv.CP_Project__c = cp.id;
        sv.Referrer_Name__c = a.id;
        insert sv;
        
        
    }
    
   /* @isTest
public static Account createCP() {
Account a = new Account();
a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
a.Name = 'Test CP';
a.phone = '1212121212';
insert a;
return a;
} */
    
    @isTest
    public static void freshWalkIn() {
        Test.startTest();
        
      //  Account a = createCP();
        Project__c p = createProject();
        
        Project__c p1 = new Project__c();
        p1.Name = 'New Project';
        insert p1;
        
        Team__c tm = new Team__c();
        tm.Project__c = p.id;
        tm.Name = 'Test24';
        tm.Team_Type__c = 'Sales Team';
        
        insert tm;
        
        Team_Members__c tmm = new Team_Members__c();
        tmm.Team__c = tm.id;
        tmm.User_Active__c = true;
        tmm.Sequence_Number__c = 10;
        tmm.Availability__c = false;
        tmm.User__c = userinfo.getUserId();
        insert tmm;
        
        
        
        Team__c tm1 = new Team__c();
        tm1.Project__c = p.id;
        tm1.Name = 'Test24';
        tm1.Team_Type__c = 'Presales Team';
        
        insert tm1;
        
        Team_Members__c tmm1 = new Team_Members__c();
        tmm1.Team__c = tm1.id;
        tmm1.User_Active__c = true;
        tmm1.Sequence_Number__c = 10;
        tmm1.Availability__c = false;
        tmm1.User__c = userinfo.getUserId();
        insert tmm1;
        
        
         Account a = new Account();
        a.FirstName = 'Test';
        a.LastName = 'Account';
        a.PersonMobilePhone = '2121212121';
       // a.Alternate_Email__c = 'Test2@gmail.com';
        a.PersonEmail = 'Test24@gmail.com';
        a.Phone = 'Testq@gmail.com';
        insert a;
        
               
        PageReference pageRef = Page.SearchPage;
        Test.setCurrentPage(pageRef);        
        SearchPageController sp = new SearchPageController();
        sp.l.Mobile__c = '1478596300';
        sp.l.Email__c = 'sv@test.in';
        sp.l.Project_Name__c = p.id;
        sp.cancel();
        sp.search();
        sp.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1478596300'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('sv@test.in'));
        EX_SiteVisitFormController svf = new EX_SiteVisitFormController();
        svf.sv.Salutation__c = 'Mr.';
        svf.sv.Sales_Manager__c = userinfo.getUserId();
        svf.sv.First_Name__c = 'SV';
        svf.sv.Last_Name__c = 'Test';
        svf.sv.Email__c = 'Test@gmail.com';
        svf.sv.Possession_Timeframe_Required__c = 'Ready to Move in (RTMI)';
        svf.sv.Buying_Purpose__c = 'Investment';
        svf.sv.Street_1__c = 'Test1';
        svf.sv.Locality__c = 'IND';
        svf.sv.City__c = 'Test24';  
        svf.sv.State__c = 'MH';
        svf.sv.House_No__c = '787q';
        svf.sv.Age_Group__c = '25 to 30 Years';
        svf.sv.Occupation__c = 'Shop owner';
        svf.sv.Configuration_Required__c = '1 BHK';
        svf.sv.Budget__c = 'Budget of 50 to 60 lakhs';
        svf.sv.SV_Count__c = 1;
        svf.sv.Master_Source__c = 'Hoardings';
        svf.sv.Lead_Source__c = 'Bus Shelter';
        svf.sv.Source__c = 'In Follow-up';
        svf.sv.Referrer_Name__c = a.id;
        svf.sv.Employee_Referrer_Name__c = 'Test2';
        svf.sv.Possession_Timeframe_Required__c = 'Ready to Move in (RTMI)';
        
        
        //svf.cpName = 'Test CP-1212121212';
        svf.closeForm();
        ApexPages.currentPage().getParameters().put('currentTab', '0');
        svf.validateInput();
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        svf.submit();
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.Mobile__c = '1478596300';
        sp1.l.Email__c = 'sv@test.in';
        sp1.l.Project_Name__c = p.id;
        sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1478596300'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('sv@test.in'));
        EX_SiteVisitFormController svf1 = new EX_SiteVisitFormController();
        svf1.submit();
        
     List<Site_Visit__c> sv = [Select Id,Name,House_No__c,Street_1__c,Locality__c,Referrer_Name__c,City__c,State__c,SV_Count__c,Master_Source__c,Email__c,Buying_Purpose__c,
                                 Lead_Source__c,Source__c,Possession_Timeframe_Required__c, Employee_Referrer_Name__c,StageName__c, Sub_Stage__c,Sub_Stage_Reason__c,Opportunity_c__c,Project__c,SM_Comment__c
                            from Site_Visit__c ORDER BY CreatedDate ASC LIMIT 1];
        
        //Site_Visit__c cSV = SM_AssignmentController.getSVRecord(sv[0].id);
      /* List<Team_Members__c> tmList = SM_AssignmentController.getAllSalesManager(cSV);
        Team_Members__c tm = SM_AssignmentController.checkUserAvailability(tmList[0].Id);
        Boolean result = SM_AssignmentController.assignSalesManager(cSV, tmList[0]); */
        
        sv[0].SM_Comment__c = 'Test SV';
        sv[0].StageName__c = 'In Follow-up';
        sv[0].Sub_Stage__c = 'Hot';
        sv[0].Sub_Stage_Reason__c = 'All Good Expected Closure';    
        sv[0].Project__c = p.id;
        sv[0].Budget__c = 'Budget of 30 to 40 lakhs';
        
        //sv.Sub_Stage_Reason__c = 'All Good Expected Closure';
        sv[0].Next_Follow_up_Date__c = system.now().addDays(1);
       
            
        update sv[0];
     
        PageReference pageRef2 = Page.SearchPage;
        Test.setCurrentPage(pageRef2);        
        SearchPageController sp2 = new SearchPageController();
        sp2.l.Mobile__c = '1478596300';
        sp2.l.Email__c = 'sv@test.in';
        sp2.l.Project_Name__c = p.id;
        sp2.search();
        sp2.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p1.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1478596300'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('sv@test.in'));
        EX_SiteVisitFormController svf2 = new EX_SiteVisitFormController();
        svf2.sv.Configuration_Required__c = '1 BHK';
        svf2.sv.Budget__c = '50 Lakhs and above';
        //svf2.sv.Master_Source__c = 'Channel Partner';
        //svf2.sv.Lead_Source__c = 'Channel Partner';
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
        a.PersonMobilePhone = '1128888455';
        //a.Alternate_Email__c = 'Test2@gmail.com';
        a.PersonEmail = 'Test24@gmail.com';
        insert a;
        
        CP_Project__c cp = new CP_Project__c();
        cp.CP_Account__c = a.id;
        cp.CP_Project_Name__c = p.id;
        insert cp;
        
        Lead_c__c l = new Lead_c__c();
        l.First_Name__c = 'Test';
        l.Last_Name__c = 'Customer';
        l.Mobile__c = '1129999455';
        l.Email__c = 'customer@test.in';
        l.Project_Name__c = p.id;
        l.Age_Group__c = '25 to 30 Years';
        l.Gender__c = 'Male';
        l.Designation__c = 'Owner';
        l.Martial_Status__c = 'Married';
        l.Occupation__c = 'Shop owner';
        l.Family_Size__c = 'Joint Family';
        l.Highest_Education__c = 'Engineer';
        l.Current_Residence_Configuration__c = '1 BHK';
        l.Current_Residence_Status__c = 'Rented';
        l.Ethinicity__c = 'Marathi';
        l.Lead_Stage__c = 'Visit Done';
        l.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        l.Industry__c = 'Consulting';
        l.Configuration_Required__c = '2 BHK';
        l.Buying_Purpose__c = 'Self-Use';
        l.Budget__c = 'Budget of 50 to 60 lakhs';
        l.Possession_Timeframe_Required__c = 'Ready to Move in (RTMI)';
        l.Master_Source_Category__c = 'Digital';
        l.Lead_Source__c = 'Affiliate';
        l.Lead_Sub_Source__c = 'Mindicator';
        l.Sub_Source_Details__c = 'Mindicator Exit';
        l.CP_Project__c = cp.id;
        l.Referrer_Name__c = a.id;
        insert l;
        
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true;
        c2.Project__c = p.id;
        //c2.Marketing_Brief__c = Mb.id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.Status__c = 'Completed';
        c2.Amount_Spend__c = 0;
       //c2.GST__c = 'GST 5%';
       //c2.Discount__c = 0;
        c2.Actual_Leads__c = 0;
        c2.Site_Visit_Count__c = 0;
        c2.Booking_Count__c = 0;
        c2.Lead_Count__c = 0;
        c2.SRD_Code__c = 'AVJH7';
        insert c2;
        
        Project__c p1 = new Project__c();
        p1.Name = 'New Project';
        insert p1;
        //Lead l1 = createLead(p1.Id);

       // Channel_Partner__c cp = new Channel_Partner__c();
      //  cp.Name = 'Test';
        //  insert cp;
        
        Lead_c__c l1 = new Lead_c__c();
        l1.First_Name__c = 'Test';
        l1.Last_Name__c = 'Customer';
        l1.Mobile__c = '1127777455';
        l1.Email__c = 'customer@test.in';
        l1.Project_Name__c = p.id;
        l1.Age_Group__c = '25 to 30 Years';
        l1.Gender__c = 'Male';
        l1.Designation__c = 'Owner';
        l1.Martial_Status__c = 'Married';
        l1.Occupation__c = 'Shop owner';
        l1.Family_Size__c = 'Joint Family';
        l1.Highest_Education__c = 'Engineer';
        l1.Current_Residence_Configuration__c = '1 BHK';
        l1.Current_Residence_Status__c = 'Rented';
        l1.Ethinicity__c = 'Marathi';
        l1.Household_Income_Annual__c = 'Rs. 16 Lakhs to 20 Lakhs';
        l1.Industry__c = 'Consulting';
        l1.Lead_Stage__c = 'Visit Done';
        l1.Configuration_Required__c = '2 BHK';
        l1.Budget__c = 'Budget of 50 to 60 lakhs';
        l1.Buying_Purpose__c = 'Self-Use';
       // l1.Channel_Partner__c = cp.id;
        l1.Possession_Timeframe_Required__c = 'Ready to Move in (RTMI)';
        l1.Master_Source_Category__c = 'Digital';
        l1.Lead_Source__c = 'Affiliate';
        l1.Lead_Sub_Source__c = 'Mindicator';
        l1.Sub_Source_Details__c = 'Mindicator Exit';
        
        insert l1;
        
        PageReference pageRef = Page.SearchPage;
        Test.setCurrentPage(pageRef);        
        SearchPageController sp = new SearchPageController();
        sp.l.Mobile__c = '1128888455';
        sp.l.Email__c = 'customer@test.in';
        sp.l.Project_Name__c = p.id;
        sp.search();
        sp.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('customer@test.in'));
        EX_SiteVisitFormController svf = new EX_SiteVisitFormController();
        svf.submit();
        
       /*List<Opportunity_c__c> op = [Select Id, Campaign_Custom__c,Master_Source__c,Opportunity_Sub_Stage__c,
                                    Opportunity_Source__c,Opportunity_Sub_Stage_Reason__c,Account_Name__c,Is_Active__c,Project__c,Opportunity_Stage__c from Opportunity_c__c ORDER BY CreatedDate ASC LIMIT 1];
        
        
             
        op[0].Campaign_Custom__c = c2.Id;
        op[0].Account_Name__c = a.id;
        op[0].Project__c = p.id;
        op[0].Opportunity_Stage__c = 'Lost';
        op[0].Opportunity_Sub_Stage__c = 'General Enquiry';
        op[0].Master_Source__c = 'Hoardings';
        op[0].Opportunity_Source__c = 'Bus Shelter';
      */
             
        
       
        
        
        
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.Mobile__c = '1126666455';
        sp1.l.Email__c = 'customer@test.in';
        sp1.l.Project_Name__c = p.id;
        sp1.search();
        sp1.continueMethod();
        
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('customer@test.in'));
        EX_SiteVisitFormController svf1 = new EX_SiteVisitFormController();
       //iteVisitFormController.getChannelPartner(cp.Name);
       //iteVisitFormController.getReferrerName(a.Name);
        svf1.submit();
        
        Test.stopTest();
    }
    
    
    
     @isTest
    public static void walkInforLead22() {
        Test.startTest();
        
        Project__c p = createProject();
        //Lead__c l = createLead(p.Id);
        //
       
        Project__c p1 = new Project__c();
        p1.Name = 'New Project';
        insert p1;
      
        
        Account a = new Account();
        a.FirstName = 'Test';
        a.LastName = 'Account';
       // a.PersonMobilePhone = '2121212121';
      //  a.Alternate_Email__c = 'Test2@gmail.com';
        a.PersonEmail = 'Test24@gmail.com';
    
     
        insert a;
        
        
        Lead_c__c l = new Lead_c__c();
        l.First_Name__c = 'Test';
        l.Last_Name__c = 'Customer';
        l.Mobile__c = '1122334455';
        l.Email__c = 'customer@test.in';
        l.Project_Name__c = p.id;
        l.Age_Group__c = '25 to 30 Years';
        l.Gender__c = 'Male';
        l.Designation__c = 'Owner';
        l.Martial_Status__c = 'Married';
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
        l.Lead_Stage__c = 'Visit done';
        insert l;
        
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true; 
        c2.Project__c = p.id;
        //c2.Marketing_Brief__c = Mb.id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.Status__c = 'Completed';
        c2.Amount_Spend__c = 0;
        c2.Lead_Count__c = 0;
        c2.Site_Visit_Count__c = 0;
        c2.Booking_Count__c = 0;
        c2.SRD_Code__c = 'AVJH7';
        insert c2;
        //Lead l1 = createLead(p1.Id);
        
        Lead_c__c l1 = new Lead_c__c();
        l1.First_Name__c = 'Test';
        l1.Last_Name__c = 'Customer';
        l1.Mobile__c = '1122334455';
        l1.Email__c = 'customer@test.in';
        l1.Alternate_Email_Id__c = 'customer24@test.in';
        l1.Project_Name__c = p.id;
        l1.Age_Group__c = '25 to 30 Years';
        l1.Gender__c = 'Male';
        l1.Designation__c = 'Owner';
        l1.Martial_Status__c = 'Married';
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
        l1.Lead_Stage__c = 'Visit done';
        insert l1;
        
        PageReference pageRef = Page.SearchPage;
        Test.setCurrentPage(pageRef);        
        SearchPageController sp = new SearchPageController();
        sp.l.Mobile__c = '1122334455';
        sp.l.Email__c = 'customer@test.in';
        sp.l.Project_Name__c = p.id;
        sp.search();
        sp.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('Test24@gmail.com'));
        EX_SiteVisitFormController svf = new EX_SiteVisitFormController();
        svf.submit();
        
        /*List<Opportunity_c__c> op = [Select Id, Campaign_Custom__c,Account_Name__c,Project__c,Opportunity_Stage__c from Opportunity_c__c ORDER BY CreatedDate ASC LIMIT 1];
          
        op[0].Campaign_Custom__c = c2.Id;
        op[0].Account_Name__c = a.id;
        op[0].Project__c = p.id;
        op[0].Opportunity_Stage__c = 'In Follow-up';
        op[0].Opportunity_Sub_Stage__c = 'Hot';
        op[0].Opportunity_Sub_Stage_Reason__c = 'All Good Expected Closure';
            */
       
        PageReference pageRef1 = Page.SearchPage;
        Test.setCurrentPage(pageRef1);        
        SearchPageController sp1 = new SearchPageController();
        sp1.l.Mobile__c = '1122334455';
        sp1.l.Email__c = 'customer@test.in';
        sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('Test24@gmail.com'));
        EX_SiteVisitFormController svf1 = new EX_SiteVisitFormController();
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
        sp1.l.Mobile__c = '1122334455';
        sp1.l.Email__c = 'customer@test.in';
        sp1.l.Project_Name__c = p.id;
        sp1.search();
        sp1.continueMethod();
        ApexPages.currentPage().getParameters().put('project', String.valueOf(p.id));
        ApexPages.currentPage().getParameters().put('mobile', String.valueOf('1122334455'));
        ApexPages.currentPage().getParameters().put('email', String.valueOf('customer@test.in'));
        EX_SiteVisitFormController svf = new EX_SiteVisitFormController();
        ApexPages.currentPage().getParameters().put('currentTab', '0');
        svf.validateInput();
        ApexPages.currentPage().getParameters().put('currentTab', '1');
        svf.validateInput();
        //svf.sv.Pincode__c = '454545';
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
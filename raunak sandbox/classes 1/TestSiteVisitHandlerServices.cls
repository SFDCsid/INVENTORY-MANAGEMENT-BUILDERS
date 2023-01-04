@isTest
public class TestSiteVisitHandlerServices {
    
 @isTest 
    public static void  createLead() {
        
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p; 
        
        Team__c tm = new Team__c();
        tm.Project__c = p.id;
        tm.Name = 'Test24';
        tm.Team_Type__c = 'Presales Team';
        insert tm;
        
        Team_Members__c tmm = new Team_Members__c();
        tmm.Team__c = tm.id;
        tmm.User_Active__c = true;
        tmm.Sequence_Number__c = 10;
        tmm.Availability__c = true;
        tmm.User__c = userinfo.getUserId();
        insert tmm;
        
        
        
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
        
         Test.startTest();
        SiteVisitHandlerServices sv2 = new SiteVisitHandlerServices();
        LeadRoundRobinHandler ldw = new LeadRoundRobinHandler();
         Test.stopTest();
        
    } 
    
    
     @isTest 
    public static void  createLead22() {
        
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p; 
        
        Team__c tm = new Team__c();
        tm.Project__c = p.id;
        tm.Name = 'Test24';
        tm.Team_Type__c = 'Sales Team';
        
        insert tm;
        
        Team_Members__c tmm = new Team_Members__c();
        tmm.Team__c = tm.id;
        tmm.User_Active__c = true;
       // tmm.Sequence_Number__c = 10;
        tmm.Availability__c = false;
        tmm.User__c = userinfo.getUserId();
        insert tmm;
        
        
        
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
        
         Test.startTest();
        SiteVisitHandlerServices sv2 = new SiteVisitHandlerServices();
        LeadRoundRobinHandler ldw = new LeadRoundRobinHandler();
         Test.stopTest();
        
    } 
  
 }
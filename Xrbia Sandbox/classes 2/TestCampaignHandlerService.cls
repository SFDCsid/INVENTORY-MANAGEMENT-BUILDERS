@isTest
public class TestCampaignHandlerService {
  
    	@isTest
       public static void CreateCampaign() {
       
       Account a = new Account ();
       a.LastName = 'acc 2';
       a.Phone = '9822341223';
       a.PersonMobilePhone = '9922341223';
       a.Alternate_Email__c = 'acc12@gmail.com';
       a.PersonEmail = 'acc32@gmail.com';
       
        insert a;
           
       Project__c p = new Project__c();
       p.Name = 'Test Project';
       insert p;
       
       Project__c p1 = new Project__c();
       p1.Name = 'Test Project1';
       insert p1;
        
        Marketing_Brief__c Mb = new Marketing_Brief__c();
        Mb.Project__c = p.id;
        Mb.Start_Date__c = system.today();
        Mb.End_Date__c = system.today();
        Mb.Actual_Bookings__c = 0;
        Mb.Actual_Cost__c = 0;
        Mb.Actual_Leads__c = 2;
        Mb.Actual_Visits__c = 3;
        Mb.Planned_Cost__c = 200;
        Mb.Planned_Bookings__c = 10;
        Mb.Planned_Leads__c = 2;
        Mb.Planned_Visits__c = 1;
        Mb.Status__c = 'In-process';
        insert Mb;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.IsActive__c = true;
        c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.Marketing_Brief__c = Mb.id;
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
           
        c2.Amount__c = 100;
        c2.GST__c = 'GST 5%';
        c2.Discount__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Actual_Visits__c = 6;
        c2.Actual_Bookings__c = 5;
        c2.Campaign_Code__c = 'ANCUYTEE';
        update c2;
       
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.IsActive__c = true;
        c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Marketing_Brief__c = Mb.id;
        c4.StartDate__c = system.today();
        c4.EndDate__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Weekly';
        c4.Status__c = 'Completed';
        c4.Amount__c = 0;
       
        insert c4;
        c4.Amount__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.IsActive__c = true;
        c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.StartDate__c = system.today();
        c3.EndDate__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';      
        c3.Marketing_Brief__c = Mb.id;
        c3.Status__c = 'Approved';
        c3.Amount__c = 0;
        insert c3;
           
        c3.Amount__c = 100;
        update c3;
        
           
        Lead__c Ld = new Lead__c();
        Ld.Last_Name__c = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project__c = p.id;
        insert Ld;
        
       
       Opportunity__c Opp = new Opportunity__c();
       opp.Name = 'Test Opp';
       opp.AccountId__c = a.id;
       opp.StageName__c = 'Assigned';
       opp.CloseDate__c = system.today().addDays(1);
       opp.Project__c = p.Id;
       opp.Sales_Next_Follow_up_Date__c = system.now();
       opp.Site_Visit_Count__c = 0;
       opp.Campaign_Custom__c = c2.id;
        insert opp;
        
        opp.Site_Visit_Count__c = 10;
        update opp;
           
       Booking__c bk = new Booking__c();
       bk.Opportunity__c = opp.id;
       bk.Project__c = p.id;
       insert bk;
           
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Actual_Leads__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign__c = c2.id;
        
        insert cpl;
       
           
    // CampaignHandlerServices cs = new CampaignHandlerServices();
		
    }
    @isTest
       public static void CreateCampaign5() {
       
       Account a = new Account ();
       a.LastName = 'acc 2';
       a.Phone = '9822341223';
       a.PersonMobilePhone = '9922341223';
       a.Alternate_Email__c = 'acc12@gmail.com';
       a.PersonEmail = 'acc32@gmail.com';
       
        insert a;
           
       Project__c p = new Project__c();
       p.Name = 'Test Project';
       insert p;
       
       Project__c p1 = new Project__c();
       p1.Name = 'Test Project1';
       insert p1;
        
        Marketing_Brief__c Mb = new Marketing_Brief__c();
        Mb.Project__c = p.id;
        Mb.Start_Date__c = system.today();
        Mb.End_Date__c = system.today();
        Mb.Actual_Bookings__c = 0;
        Mb.Actual_Cost__c = 0;
        Mb.Actual_Leads__c = 2;
        Mb.Actual_Visits__c = 3;
        Mb.Planned_Cost__c = 200;
        Mb.Planned_Bookings__c = 10;
        Mb.Planned_Leads__c = 2;
        Mb.Planned_Visits__c = 1;
        Mb.Status__c = 'In-process';
        insert Mb;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.IsActive__c = true;
        c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.Marketing_Brief__c = Mb.id;
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
           
        c2.Amount__c = 100;
        c2.GST__c = 'GST 5%';
        c2.Discount__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Actual_Visits__c = 6;
        c2.Actual_Bookings__c = 5;
        c2.Campaign_Code__c = 'ANCUYTEE';
        update c2;
       
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.IsActive__c = true;
        c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Marketing_Brief__c = Mb.id;
        c4.StartDate__c = system.today();
        c4.EndDate__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Weekly';
        c4.Status__c = 'Completed';
        c4.Amount__c = 0;
       
        insert c4;
        c4.Amount__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.IsActive__c = true;
        c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.StartDate__c = system.today();
        c3.EndDate__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';      
        c3.Marketing_Brief__c = Mb.id;
        c3.Status__c = 'Approved';
        c3.Amount__c = 0;
        insert c3;
           
        c3.Amount__c = 100;
        update c3;
        
           
        Lead__c Ld = new Lead__c();
        Ld.Last_Name__c = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project__c = p.id;
        insert Ld;
        
       
       Opportunity__c Opp = new Opportunity__c();
       opp.Name = 'Test Opp';
       opp.AccountId__c = a.id;
       opp.StageName__c = 'Assigned';
       opp.CloseDate__c = system.today().addDays(1);
       opp.Project__c = p.Id;
       opp.Sales_Next_Follow_up_Date__c = system.now();
       opp.Site_Visit_Count__c = 0;
       opp.Campaign_Custom__c = c2.id;
       insert opp;
        
       opp.project__c = p1.Id;
       update opp;
           
       Booking__c bk = new Booking__c();
       bk.Opportunity__c = opp.id;
       bk.Project__c = p.id;
       insert bk;
           
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Actual_Leads__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign__c = c2.id;
        
        insert cpl;
       
           
    // CampaignHandlerServices cs = new CampaignHandlerServices();
		
    }
    @isTest
       public static void CreateCampaign6() {
       
       Account a = new Account ();
       a.LastName = 'acc 2';
       a.Phone = '9822341223';
       a.PersonMobilePhone = '9922341223';
       a.Alternate_Email__c = 'acc12@gmail.com';
       a.PersonEmail = 'acc32@gmail.com';
       
        insert a;
           
       Project__c p = new Project__c();
       p.Name = 'Test Project';
       insert p;
       
       Project__c p1 = new Project__c();
       p1.Name = 'Test Project1';
       insert p1;
        
        Marketing_Brief__c Mb = new Marketing_Brief__c();
        Mb.Project__c = p.id;
        Mb.Start_Date__c = system.today();
        Mb.End_Date__c = system.today();
        Mb.Actual_Bookings__c = 0;
        Mb.Actual_Cost__c = 0;
        Mb.Actual_Leads__c = 2;
        Mb.Actual_Visits__c = 3;
        Mb.Planned_Cost__c = 200;
        Mb.Planned_Bookings__c = 10;
        Mb.Planned_Leads__c = 2;
        Mb.Planned_Visits__c = 1;
        Mb.Status__c = 'In-process';
        insert Mb;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.IsActive__c = true;
        c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.Marketing_Brief__c = Mb.id;
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
           
        c2.Amount__c = 100;
        c2.GST__c = 'GST 5%';
        c2.Discount__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Actual_Visits__c = 6;
        c2.Actual_Bookings__c = 5;
        c2.Campaign_Code__c = 'ANCUYTEE';
        update c2;
       
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.IsActive__c = true;
        c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Marketing_Brief__c = Mb.id;
        c4.StartDate__c = system.today();
        c4.EndDate__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Weekly';
        c4.Status__c = 'Completed';
        c4.Amount__c = 0;
       
        insert c4;
        c4.Amount__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.IsActive__c = true;
        c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.StartDate__c = system.today();
        c3.EndDate__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';      
        c3.Marketing_Brief__c = Mb.id;
        c3.Status__c = 'Approved';
        c3.Amount__c = 0;
        insert c3;
           
        c3.Amount__c = 100;
        update c3;
        
           
        Lead__c Ld = new Lead__c();
        Ld.Last_Name__c = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project__c = p.id;
        insert Ld;
        
       
       Opportunity__c Opp = new Opportunity__c();
       opp.Name = 'Test Opp';
       opp.AccountId__c = a.id;
       opp.StageName__c = 'Assigned';
       opp.CloseDate__c = system.today().addDays(1);
       opp.Project__c = p.Id;
       opp.Sales_Next_Follow_up_Date__c = system.now();
       opp.Site_Visit_Count__c = 0;
       opp.Campaign_Custom__c = c2.id;
       insert opp;
        
       opp.Campaign_Custom__c = c3.id;
       update opp;
           
       Booking__c bk = new Booking__c();
       bk.Opportunity__c = opp.id;
       bk.Project__c = p.id;
       insert bk;
           
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Actual_Leads__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign__c = c2.id;
        
        insert cpl;
       
           
    // CampaignHandlerServices cs = new CampaignHandlerServices();
		
    }
    @isTest
       public static void CreateCampaign2() {
       Project__c p = new Project__c();
      
           
        Marketing_Brief__c Mb = new Marketing_Brief__c();
        Mb.Project__c = p.id;
        Mb.Start_Date__c = system.today();
        Mb.End_Date__c = system.today();
        Mb.Actual_Bookings__c = 0;
        Mb.Actual_Cost__c = 0;
        Mb.Actual_Leads__c = 2;
        Mb.Actual_Visits__c = 3;
        Mb.Planned_Cost__c = 200;
        Mb.Planned_Bookings__c = 10;
        Mb.Planned_Leads__c = 2;
        Mb.Planned_Visits__c = 1;
        Mb.Status__c = 'In-process';
        insert Mb;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.IsActive__c = true;
        c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.Marketing_Brief__c = Mb.id;
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
           
        c2.Amount__c = 100;
        c2.GST__c = 'GST 5%';
        c2.Discount__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Actual_Visits__c = 6;
        c2.Actual_Bookings__c = 5;
        c2.Status__c = 'Approved';   
        update c2;
     
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.IsActive__c = true;
        c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Marketing_Brief__c = Mb.id;
        c4.StartDate__c = system.today();
        c4.EndDate__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Weekly';
        c4.Status__c = 'Completed';
        c4.Amount__c = 0;
       
        insert c4;
        c4.Amount__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.IsActive__c = true;
        c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.StartDate__c = system.today();
        c3.EndDate__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';      
        c3.Marketing_Brief__c = Mb.id;
        c3.Status__c = 'Approved';
        c3.Amount__c = 0;
        insert c3;
           
        c3.Amount__c = 100;
        update c3;
        
           
        Lead__c Ld = new Lead__c();
        Ld.Last_Name__c = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project__c = p.id;
        insert Ld;
           
           
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Actual_Leads__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign__c = c2.id;
        
        insert cpl;
       
           
    // CampaignHandlerServices cs = new CampaignHandlerServices();
		
    }
    
    
    @isTest
       public static void CreateCampaign3() {
       Project__c p = new Project__c();
      
           
        Marketing_Brief__c Mb = new Marketing_Brief__c();
        Mb.Project__c = p.id;
        Mb.Start_Date__c = system.today();
        Mb.End_Date__c = system.today();
        Mb.Actual_Bookings__c = 0;
        Mb.Actual_Cost__c = 0;
        Mb.Actual_Leads__c = 2;
        Mb.Actual_Visits__c = 3;
        Mb.Planned_Cost__c = 200;
        Mb.Planned_Bookings__c = 10;
        Mb.Planned_Leads__c = 2;
        Mb.Planned_Visits__c = 1;
        Mb.Status__c = 'In-process';
        insert Mb;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.IsActive__c = true;
        c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.Marketing_Brief__c = Mb.id;
        c2.StartDate__c = system.today();
        c2.EndDate__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Weekly'; 
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
           
        c2.Amount__c = 100;
        c2.GST__c = 'GST 5%';
        c2.Discount__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Actual_Visits__c = 6;
        c2.Actual_Bookings__c = 5;
        c2.Status__c = 'Approved';   
        update c2;
     
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.IsActive__c = true;
        c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Marketing_Brief__c = Mb.id;
        c4.StartDate__c = system.today();
        c4.EndDate__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Daily';
        c4.Status__c = 'Completed';
        c4.Amount__c = 0;
       
        insert c4;
        c4.Amount__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.IsActive__c = true;
        c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.StartDate__c = system.today();
        c3.EndDate__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';      
        c3.Marketing_Brief__c = Mb.id;
        c3.Status__c = 'Approved';
        c3.Amount__c = 0;
        insert c3;
           
        c3.Amount__c = 100;
        update c3;
        
           
        Lead__c Ld = new Lead__c();
        Ld.Last_Name__c = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project__c = p.id;
        insert Ld;
           
           
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Actual_Leads__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign__c = c2.id;
        
        insert cpl;
       
           
    // CampaignHandlerServices cs = new CampaignHandlerServices();
		
    }
    
    @isTest
       public static void CreateCampaign4() {
       Project__c p = new Project__c();
      
           
        Marketing_Brief__c Mb = new Marketing_Brief__c();
        Mb.Project__c = p.id;
        Mb.Start_Date__c = system.today();
        Mb.End_Date__c = system.today();
        Mb.Actual_Bookings__c = 0;
        Mb.Actual_Cost__c = 0;
        Mb.Actual_Leads__c = 2;
        Mb.Actual_Visits__c = 3;
        Mb.Planned_Cost__c = 200;
        Mb.Planned_Bookings__c = 10;
        Mb.Planned_Leads__c = 2;
        Mb.Planned_Visits__c = 1;
        Mb.Status__c = 'In-process';
        insert Mb;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.IsActive__c = true;
        c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.Marketing_Brief__c = Mb.id;
        c2.StartDate__c = system.today();
        c2.EndDate__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Monthly'; 
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
           
        c2.Amount__c = 100;
        c2.GST__c = 'GST 5%';
        c2.Discount__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Actual_Visits__c = 6;
        c2.Actual_Bookings__c = 5;
        c2.Status__c = 'Approved';   
        update c2;
     
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.IsActive__c = true;
        c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Marketing_Brief__c = Mb.id;
        c4.StartDate__c = system.today();
        c4.EndDate__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Daily';
        c4.Status__c = 'Completed';
        c4.Amount__c = 0;
       
        insert c4;
        c4.Amount__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.IsActive__c = true;
        c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.StartDate__c = system.today();
        c3.EndDate__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Weekly';      
        c3.Marketing_Brief__c = Mb.id;
        c3.Status__c = 'Approved';
        c3.Amount__c = 0;
        insert c3;
           
        c3.Amount__c = 100;
        update c3;
        
           
        Lead__c Ld = new Lead__c();
        Ld.Last_Name__c = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project__c = p.id;
        insert Ld;
           
           
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Actual_Leads__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign__c = c2.id;
        
        insert cpl;
       
           
    // CampaignHandlerServices cs = new CampaignHandlerServices();
		
    }
 }
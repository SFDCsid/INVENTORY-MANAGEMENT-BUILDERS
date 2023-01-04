@isTest
public class TestCampaignHandlerService {
  
    	@isTest
       public static void CreateCampaign() {
       
       Account a = new Account ();
       a.LastName = 'acc 2';
       a.Phone = '9822341223';
       a.PersonMobilePhone = '9922341223';
       a.Alternate_Email_Id__c = 'acc12@gmail.com';
       a.PersonEmail = 'acc32@gmail.com';
       
        insert a;
           
       Project__c p = new Project__c();
       p.Name = 'Test Project';
       insert p;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true;
        c2.Project__c = p.id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.Status__c = 'Completed';
        c2.Amount_Spend__c = 0;
        c2.Actual_Leads__c = 0;
        c2.Site_Visit_Count__c = 0;
        c2.Booking_Count__c = 0;
        //c2.SRD_Code__c = '5525';
        c2.Extended_Date__c = system.today().addDays(1);
        c2.Approval_Status__c = 'Approved';
        c2.Extension_Approval_Status__c = 'Pending';
        insert c2;
           
        c2.Amount_Spend__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Site_Visit_Count__c = 0;
        c2.Booking_Count__c = 0;
        c2.Extended_Date__c = system.today().addDays(1);
        c2.Approval_Status__c = 'Approved';
        c2.Extension_Approval_Status__c = 'Approved';
        //c2.SRD_Code__c = '12345';
        update c2;
       
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.Active__c = true;
        //c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Start_Date__c = system.today();
        c4.End_Date__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Weekly';
        c4.Status__c = 'Completed';
        c4.Amount_Spend__c = 0;
        c4.Extended_Date__c = system.today().addDays(1);
        c4.Approval_Status__c = 'Pending';
        c4.Extension_Approval_Status__c = 'Pending';
        insert c4;
           c4.Extended_Date__c = system.today().addDays(7);
           c4.Extension_Approval_Status__c = 'Approved';
        c4.Amount_Spend__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.Active__c = true;
        //c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.Start_Date__c = system.today();
        c3.End_Date__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';      
        c3.Status__c = 'Approved';
        c3.Amount_Spend__c = 0;
        c3.Extended_Date__c = system.today().addDays(1);
        c3.Approval_Status__c = 'Approved';
        c3.Extension_Approval_Status__c = 'Approved';
        insert c3;
           
        c3.Amount_Spend__c = 100;
        update c3;
        
           
        Lead_c__c Ld = new Lead_c__c ();
        Ld.Last_Name__c = 'test'; 
        Ld.Mobile__c = '9857485965';
        Ld.Campaign_Custom__c = c2.id;
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project_Name__c = p.id;
        insert Ld;
        
       
       Opportunity_c__c Opp = new Opportunity_c__c();
       opp.Last_Name__c = 'Test Opp';
       opp.Account_Name__c = a.id;
       opp.Opportunity_Stage__c = 'Assigned';
       //opp.CloseDate__c = system.today().addDays(1);
       opp.Project__c = p.Id;
       opp.Next_Follow_up_Date__c = system.now();
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
        cpl.Lead_Count__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign_c__c = c2.id;
        
        insert cpl;
		
    }
    @isTest
       public static void CreateCampaign5() {
       
       Account a = new Account ();
       a.LastName = 'acc 2';
       a.Phone = '9822341223';
       a.PersonMobilePhone = '9922341223';
       a.Alternate_Email_Id__c = 'acc12@gmail.com';
       a.PersonEmail = 'acc32@gmail.com';
       
        insert a;
           
       Project__c p = new Project__c();
       p.Name = 'Test Project';
       insert p;
       
       Project__c p1 = new Project__c();
       p1.Name = 'Test Project1';
       insert p1;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true;
        //c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.Amount_Spend__c = 0;
        c2.Actual_Leads__c = 0;
        c2.Site_Visit_Count__c = 0;
        c2.Booking_Count__c = 0;
        c2.SRD_Code__c = '6525';
        c2.Extended_Date__c = system.today();
        c2.Approval_Status__c = 'Pending';
        c2.Extension_Approval_Status__c = 'Pending';
        insert c2;
           
        c2.Amount_Spend__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Site_Visit_Count__c = 6;
        c2.Booking_Count__c = 0;
		c2.Extended_Date__c = system.today();
        c2.Approval_Status__c = 'Pending';
        c2.Extension_Approval_Status__c = 'Pending';
        c2.SRD_Code__c = '6965';
        update c2;
       
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.Active__c = true;
        //c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Start_Date__c = system.today();
        c4.End_Date__c = system.today().addDays(30);
        c4.Performance_Measure_On__c = 'Weekly';
        c4.Status__c = 'Completed';
        c4.Amount_Spend__c = 0;
        c4.Extended_Date__c = system.today();
        c4.Approval_Status__c = 'Approved';
        c4.Extension_Approval_Status__c = 'Pending';
        insert c4;
           c4.Extended_Date__c = system.today().addDays(60);
           c4.Extension_Approval_Status__c = 'Approved';
        c4.Amount_Spend__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.Active__c = true;
        //c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.Start_Date__c = system.today();
        c3.End_Date__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';      
        c3.Status__c = 'Approved';
        c3.Amount_Spend__c = 0;
        c3.Extended_Date__c = system.today();
        c3.Approval_Status__c = 'Approved';
        c3.Extension_Approval_Status__c = 'Approved';
        insert c3;
           
        c3.Amount_Spend__c = 100;
        update c3;
        
           
        Lead_c__c Ld = new Lead_c__c();
        Ld.Last_Name__c = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Mobile__c = '9847485965';
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project_Name__c = p.id;
        insert Ld;
        
       
       Opportunity_c__c Opp = new Opportunity_c__c();
       opp.Last_Name__c = 'Test Opp';
       opp.Account_Name__c = a.id;
       opp.Opportunity_Stage__c = 'Assigned';
       //opp.CloseDate__c = system.today().addDays(1);
       opp.Project__c = p.Id;
       opp.Next_Follow_up_Date__c = system.now();
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
        cpl.Lead_Count__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign_c__c = c2.id;
        
        insert cpl;
   	
    }
    @isTest
       public static void CreateCampaign6() {
       
       Account a = new Account ();
       a.LastName = 'acc 2';
       a.Phone = '9822341223';
       a.PersonMobilePhone = '9922341223';
       a.Alternate_Email_Id__c = 'acc12@gmail.com';
       a.PersonEmail = 'acc32@gmail.com';
       
        insert a;
           
       Project__c p = new Project__c();
       p.Name = 'Test Project';
       insert p;
       
       Project__c p1 = new Project__c();
       p1.Name = 'Test Project1';
       insert p1;
      
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true;
        //c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.Status__c = 'Completed';
        c2.Amount_Spend__c = 0;
        c2.Actual_Leads__c = 0;
        c2.Site_Visit_Count__c = 0;
        c2.Booking_Count__c = 0;
        c2.SRD_Code__c = '78562';
        c2.Extended_Date__c = system.today();
        c2.Approval_Status__c = 'Approved';
        c2.Extension_Approval_Status__c = 'Approved';
        insert c2;
           
        c2.Amount_Spend__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Site_Visit_Count__c = 0;
        c2.Booking_Count__c = 0;
        c2.Extended_Date__c = system.today();
        c2.Approval_Status__c = 'Approved';
        c2.Extension_Approval_Status__c = 'Approved';
        c2.SRD_Code__c = '9695';
        update c2;
       
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.Active__c = true;
        //c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Start_Date__c = system.today();
        c4.End_Date__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Weekly';
        c4.Status__c = 'Completed';
        c4.Amount_Spend__c = 0;
        c4.Extended_Date__c = system.today();
        c4.Approval_Status__c = 'Approved';
        c4.Extension_Approval_Status__c = 'Approved';
        insert c4;
        c4.Amount_Spend__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.Active__c = true;
        //c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.Start_Date__c = system.today();
        c3.End_Date__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';     
        c3.Status__c = 'Approved';
        c3.Amount_Spend__c = 0;
        c3.Extended_Date__c = system.today();
        c3.Approval_Status__c = 'Pending';
        c3.Extension_Approval_Status__c = 'Pending';
        insert c3;
        c3.Extended_Date__c = system.today().addDays(90);
           c3.Extension_Approval_Status__c = 'Approved';
        c3.Amount_Spend__c = 100;
        update c3;
        
           
        Lead_c__c Ld = new Lead_c__c();
        Ld.Last_Name__c = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Mobile__c = '9857485961';
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project_Name__c = p.id;
        insert Ld;
        
       
       Opportunity_c__c Opp = new Opportunity_c__c();
       opp.Last_Name__c = 'Test Opp';
       opp.Account_Name__c = a.id;
       opp.Opportunity_Stage__c = 'Assigned';
       //opp.CloseDate__c = system.today().addDays(1);
       opp.Project__c = p.Id;
       opp.Next_Follow_up_Date__c = system.now();
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
        cpl.Lead_Count__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign_c__c = c2.id;
        
        insert cpl;
       
           
    // CampaignHandlerServices cs = new CampaignHandlerServices();
		
    }
    @isTest
       public static void CreateCampaign2() {
       Project__c p = new Project__c();
      
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true;
        //c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.Status__c = 'Completed';
        c2.Amount_Spend__c = 0;
        c2.Actual_Leads__c = 0;
        c2.Site_Visit_Count__c = 0;
        c2.Booking_Count__c = 0;
        c2.SRD_Code__c = '12635';
        c2.Extended_Date__c = system.today();
        c2.Approval_Status__c = 'Rejected';
        c2.Extension_Approval_Status__c = 'Rejected';
        insert c2;
           
        c2.Amount_Spend__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Site_Visit_Count__c = 6;
        c2.Booking_Count__c = 5;
        c2.Status__c = 'Approved';   
        update c2;
     
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.Active__c = true;
        //c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Start_Date__c = system.today();
        c4.End_Date__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Weekly';
        c4.Status__c = 'Completed';
        c4.Amount_Spend__c = 0;
        c4.Extended_Date__c = system.today();
        c4.Approval_Status__c = 'Approved';
        c4.Extension_Approval_Status__c = 'Approved';
       
        insert c4;
        c4.Amount_Spend__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.Active__c = true;
        //c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.Start_Date__c = system.today();
        c3.End_Date__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';      
        c3.Status__c = 'Approved';
        c3.Amount_Spend__c = 0;
        c3.Extended_Date__c = system.today();
        c3.Approval_Status__c = 'Pending';
        c3.Extension_Approval_Status__c = 'Pending';
        insert c3;
           
        c3.Amount_Spend__c = 100;
        update c3;
        
           
        Lead_c__c Ld = new Lead_c__c();
        Ld.Last_Name__c = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Mobile__c = '7857485965';
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project_Name__c = p.id;
        insert Ld;
           
           
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Lead_Count__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign_c__c = c2.id;
        
        insert cpl;
       
		
    }
    
    
    @isTest
       public static void CreateCampaign3() {
       Project__c p = new Project__c();
      
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true;
        //c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Weekly'; 
        c2.Status__c = 'Completed';
        c2.Amount_Spend__c = 0;
        c2.Actual_Leads__c = 0;
        c2.Site_Visit_Count__c = 0;
        c2.Booking_Count__c = 0;
        c2.SRD_Code__c = '88552';
        c2.Extended_Date__c = system.today();
        c2.Approval_Status__c = 'Approved';
        c2.Extension_Approval_Status__c = 'Approved';
        insert c2;
           
        c2.Amount_Spend__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Site_Visit_Count__c = 6;
        c2.Booking_Count__c = 5;
        c2.Status__c = 'Approved';   
        update c2;
     
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.Active__c = true;
        //c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Start_Date__c = system.today();
        c4.End_Date__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Daily';
        c4.Status__c = 'Completed';
        c4.Amount_Spend__c = 0;
        c4.Extended_Date__c = system.today();
        c4.Approval_Status__c = 'Approved';
        c4.Extension_Approval_Status__c = 'Approved';
       
        insert c4;
        c4.Amount_Spend__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.Active__c = true;
        //c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.Start_Date__c = system.today();
        c3.End_Date__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';      
        c3.Status__c = 'Approved';
        c3.Amount_Spend__c = 0;
        c3.Extended_Date__c = system.today();
        c3.Approval_Status__c = 'Approved';
        c3.Extension_Approval_Status__c = 'Approved';
        insert c3;
           
        c3.Amount_Spend__c = 100;
        update c3;
        
           
        Lead_c__c Ld = new Lead_c__c();
        Ld.Last_Name__c = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Mobile__c = '9857185965';
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project_Name__c = p.id;
        insert Ld;
           
           
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Lead_Count__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign_c__c = c2.id;
        
        insert cpl;
       
      }
    
    @isTest
       public static void CreateCampaign4() {
       Project__c p = new Project__c();
     
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true;
       // c2.Type__c = 'Event'; 
        c2.Project__c = p.id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Monthly'; 
        c2.Status__c = 'Completed';
        c2.Amount_Spend__c = 0;
        c2.Actual_Leads__c = 0;
        c2.Site_Visit_Count__c = 6;
        c2.Booking_Count__c = 5;
        c2.SRD_Code__c = '6852';
        c2.Extended_Date__c = system.today();
        c2.Approval_Status__c = 'Pending';
        c2.Extension_Approval_Status__c = 'Pending';
        insert c2;
           
        c2.Amount_Spend__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Site_Visit_Count__c = 6;
        c2.Booking_Count__c = 5;
        c2.Status__c = 'Approved';   
        update c2;
     
        
        
        Campaign__c c4 = new Campaign__c();
        c4.Name = 'Test Project';
        c4.Active__c = true;
        //c4.Type__c = 'Email'; 
        c4.Project__c = p.id;
        c4.Start_Date__c = system.today();
        c4.End_Date__c = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Daily';
        c4.Status__c = 'Completed';
        c4.Amount_Spend__c = 0;
        c4.Extended_Date__c = system.today();
        c4.Approval_Status__c = 'Rejected';
        c4.Extension_Approval_Status__c = 'Rejected';
        insert c4;
        c4.Amount_Spend__c = 100;
        update c4;
		
        
        
        Campaign__c c3 = new Campaign__c();
        c3.Name = 'Test Project';
        c3.Active__c = true;
        //c3.Type__c = 'Social Media'; 
        c3.Project__c = p.id;
        c3.Start_Date__c = system.today();
        c3.End_Date__c = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Weekly';      
        c3.Status__c = 'Approved';
        c3.Amount_Spend__c = 0;
        c2.Extended_Date__c = system.today();
        c2.Approval_Status__c = 'Approved';
        c2.Extension_Approval_Status__c = 'Approved';
        insert c3;
           
        c3.Amount_Spend__c = 100;
        update c3;
        
           
        Lead_c__c Ld = new Lead_c__c();
        Ld.Last_Name__c = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Mobile__c = '9257485965';
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1 BHK';
        Ld.Project_Name__c = p.id;
        insert Ld;
           
           
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Lead_Count__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign_c__c = c2.id;
        cpl.Extended_Date__c = system.today();
        
        insert cpl;
       
		
    }
 }
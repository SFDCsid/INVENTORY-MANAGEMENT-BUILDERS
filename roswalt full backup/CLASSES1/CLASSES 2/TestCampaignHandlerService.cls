@isTest
public class TestCampaignHandlerService {
  
    	@isTest
       public static void CreateCampaign() {
        Project__c p = new Project__c();
        
        Campaign c2 = new Campaign();
        c2.Name = 'Test Project';
        c2.IsActive = true;
        c2.Type = 'Advertisement'; 
        c2.Master_Source__c = 'Hoardings';
        c2.Lead_Source__c = 'Billboard';
      //  c2.Lead_Sub_Source__c = 'Mindicator';
        c2.Project__c = p.id;
        c2.StartDate = system.today();
        c2.EndDate = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        insert c2;
        // c2.Campaign_Code__c = c2.Id;
        // update c2;
     
        
        
        Campaign c4 = new Campaign();
        c4.Name = 'Test Project';
        c4.IsActive = true;
        c4.Type = 'Advertisement'; 
        c4.Master_Source__c = 'Hoardings';
        c4.Lead_Source__c = 'Billboard';
        //c3.Lead_Sub_Source__c = 'Mindicator';
        c4.Project__c = p.id;
        c4.StartDate = system.today();
        c4.EndDate = system.today().addDays(60);
        c4.Performance_Measure_On__c = 'Weekly';
        insert c4;
        // c4.Campaign_Code__c = c4.Id;
        // update c4;
		
        
        
        Campaign c3 = new Campaign();
        c3.Name = 'Test Project';
        c3.IsActive = true;
        c3.Type = 'Advertisement'; 
        c3.Master_Source__c = 'Hoardings';
        c3.Lead_Source__c = 'Billboard';
        //c3.Lead_Sub_Source__c = 'Mindicator';
        c3.Project__c = p.id;
        c3.StartDate = system.today();
        c3.EndDate = system.today().addDays(60);
        c3.Performance_Measure_On__c = 'Monthly';
       
        insert c3;
       //  c4.Campaign_Code__c = c4.Id;
        // update c4;
        
           
        Lead Ld = new Lead();
        Ld.LastName = 'test';   
        Ld.Campaign_Custom__c = c2.id;
        Ld.Budget__c = 'Budget of 80 to 90 lakhs';
        Ld.Configuration_Required__c = '1BHK';
        Ld.Project__c = p.id;
        insert Ld;
        
        Campaign_Performance__c cpl = new Campaign_Performance__c();
        cpl.Lead_Count__c = 0;
        cpl.Start_Date__c = system.today();
        cpl.End_Date__c = system.today();
        cpl.Campaign__c = c2.id;
        
        insert cpl;
        cpl.Lead_Count__c = 1;
        update cpl;   
     //CampaignHandlerServices cs = new CampaignHandlerServices();
		
    }
 }
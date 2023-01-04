@istest
public class Ex_TestSiteVisitHandler {
 @istest
    public static void smmethod(){
        Test.startTest();
        project__c pr = createProject();
        Tower__c tw =  createTower();
          Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'Test';
        u.Username = 'testtesttetsteette@test.com';
        u.Email = 'test@test.com';
        u.Alias = 'test';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.ProfileId = profileId.id ;
        u.LanguageLocaleKey = 'en_US';
        insert u;
        Team__c t = new Team__c();
        t.Name = 'SM Team'; 
        t.Team_Type__c = 'SM Team';
        t.Project__c = pr.Id;
        insert t;
        
        Team_Members__c tm = new Team_Members__c();
        tm.Availability__c = false;
        tm.Team__c = t.Id;
        tm.User__c = u.Id;
        
        insert tm;
        
        Team_Members__c tm1 = new Team_Members__c();
        tm1.Availability__c = true;
        tm1.Team__c = t.Id;
        tm1.User__c = userInfo.getUserId();
        insert tm1;
         
       
         Id rctId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account a = new Account ();
        a.LastName = 'acc 2';
        a.Phone = '9822341223';
        a.PersonMobilePhone = '9922341223';
        a.PersonEmail = 'acc32@gmail.com';
        a.recordTypeId = rctId;
     
        insert a;
        
        
        Opportunity_c__c opp = new Opportunity_c__c();
        opp.Account_Name__c = a.id;
        opp.Opportunity_Stage__c = 'In Follow-up';
     //   opp.CloseDate = system.today().addDays(1);
        opp.Project__c = pr.Id;
        opp.Next_Follow_up_Date__c = system.now();
        opp.Master_Source__c = 'Events';
       
        insert opp;
    
        
         Site_Visit__c  sv = new Site_Visit__c  ();
   //     u.FirstName = 'Test';
  //      u.LastName = 'Test';
        sv.Pincode__c = 411111;
        sv.City__c = 'Pune';
        sv.Locality__c = 'Test';
        sv.Opportunity_c__c = opp.Id;
        sv.Occupation__c = 'Retired';
        sv.Sales_Manager__c = u.id;
        sv.SM_Comment__c = '';
        insert sv;
        
        sv.SM_Comment__c = 'Test 1';
        sv.Sales_Manager__c = u.id;
        update sv;
        
        

       /* Site_Visit__c  sv1 = new Site_Visit__c  ();
      //  u.FirstName = 'Test';
    //    u.LastName = 'Test';
        sv1.CP_Address__c = 'Test';
        sv1.Pin_code__c = '411111';
        sv1.City__c = 'Pune';
        sv1.Locality__c = 'Test';
        sv1.Opportunity__c = opp.Id;
        sv1.Country__c = 'India';
        sv1.Occupation__c = 'Retired';
        sv.SM_Comment__c = 'Test 3';
		sv1.SM_Comment__c = sv.SM_Comment__c;
        insert sv1;

        opp.SM_Comment__c = sv.Comment__c;
        update opp;
        */
		//tm1.Availability__c = true;
        //update tm1;
        
       // tm.Availability__c = true;
//tm.User__c = UserInfo.getUserId();
        //tm.Team__c = t.Id;
       // update tm;
           
        //sv.SM_Comment__c = 'Test 2';
        //update sv;

        //opp.SM_Comment__c = sv.Comment__c;
        //update opp;
        
        
        SM_AssignmentController.getSVRecord(sv.Id);
        SM_AssignmentController.getAllSalesManager(sv);
        //SM_AssignmentController.checkUserAvailability(tm.Id);
		SM_AssignmentController.assignSalesManager(sv,tm);
        
        /*Set<Id> uSet = new Set<Id>();
        uSet.add(u.id);
        SiteVisitHandlerServices.updateSalesManagerAvailability(uSet);
        
        SiteVisitTriggerHandler svt = new SiteVisitTriggerHandler();
        */
               Test.stopTest(); 
 
    }
    
     public static project__c createProject()
    {
        Project__c pr = new Project__c();
        pr.Name = 'test project';
        insert pr;
        return pr;
    }
    
    public static Tower__c createTower()
    {
        Tower__c tw = new Tower__c();
        tw.Name = 'test Tower';
        
        tw.Project__c = createProject().Id;
        
        insert tw;
        return tw;
    }
    
}
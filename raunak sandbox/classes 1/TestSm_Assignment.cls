@istest
public class TestSm_Assignment {

    @istest
    public static void smmethod(){
        Test.startTest();
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
        
        project__c pr = createProject();
       // pr.CRM_Approver__c	 = userinfo.getUserId();
        //pr.Project_CRM_Lead__c = userinfo.getUserId();
      //  pr.Manager_Approver__c	 = userinfo.getUserId();
        Tower__c tw =  createTower();
        
        Team__c t = new Team__c();
        t.Name = 'Sales Team'; 
        t.Project__c = pr.Id;
      //  t.Tower__c = tw.Id;
        insert t;
        
        Team_Members__c tm = new Team_Members__c();
        tm.Availability__c = true;
        tm.Team__c = t.Id;
        tm.User__c = UserInfo.getUserId();
        insert tm;
        
        Team_Members__c tm1 = new Team_Members__c();
        tm1.Availability__c = false;
        tm1.Team__c = t.Id;
        tm1.User__c = UserInfo.getUserId();
        insert tm1;
        
        Site_Visit__c  sv = new Site_Visit__c  ();
        u.FirstName = 'Test';
        u.LastName = 'Test';
       // sv.CP_Address__c = 'Test';
       // sv.Pin_code__c = '411111';
        sv.City__c = 'Pune';
        sv.Locality__c = 'Test';
     //   sv.State__c = 'Maharashtra';
       
        sv.Occupation__c = 'Retired';
     //   sv.Reason_for_buying__c = 'Investment';
    //    sv.Current_Residence_Type__c = '3 BHK';
        sv.Budget__c = 'Budget of 30 to 40 lakhs';
        insert sv;
        
      /*  SM_AssignmentController sm1 = new SM_AssignmentController();
        Site_Visit__c result1=SM_AssignmentController.getSVRecord(sv.Id);
        List<User> result2 = SM_AssignmentController.getAllSalesManager(sv);
         User result3 = SM_AssignmentController.checkUserAvailability(u.Id);
         SM_AssignmentController.assignSalesManager(sv,u);
       List<Site_Visit__c> result4=SM_AssignmentController.GetUser(u.Id,sv.Id); 
       List<User> result5 = SM_AssignmentController.GetUserafterassign(u.Id); 
       List<User> result6 = SM_AssignmentController.GetSMAvailable(u.Id); 
       List<User> result7 = SM_AssignmentController.GetSMbsy(u.id);
       List<User> result8 = SM_AssignmentController.GetSMUser();
    */ 
        SM_AssignmentController.getSVRecord(sv.Id);
        SM_AssignmentController.getAllSalesManager(sv);
        SM_AssignmentController.checkUserAvailability(tm.Id);
		SM_AssignmentController.assignSalesManager(sv,tm);
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
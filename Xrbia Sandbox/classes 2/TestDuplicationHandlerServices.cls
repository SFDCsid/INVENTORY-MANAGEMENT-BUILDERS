//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 02-11-2022
//-------------------------------------------//
@isTest
public class TestDuplicationHandlerServices {
	@isTest
    public static Project__c createProject() {
    	Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
        return p;
    }
    
    @isTest
    public static void leadMobileDuplicate() {
        List<Lead__c> leadList = new List<Lead__c>();
        List<Lead__c> leadList2 = new List<Lead__c>();
        Project__c p = createProject();
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;
        system.debug('group: '+ testGroup);
        QueuesObject q1 = new QueueSObject();
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            q1.QueueID = testGroup.id; 
            q1.SObjectType = 'Lead__c';
            insert q1;
        }
        Assignment_Group__c ag = new Assignment_Group__c();
        ag.Name = 'test group';
        insert ag;
        
        Assignment_Group_Queue__c agq = new Assignment_Group_Queue__c();
        agq.Name = 'test group';
        agq.Project__c = p.id;
        agq.QueueID__c = testGroup.id;
        agq.Assignment_Group__c = ag.id;
        agq.Active__c = true;
        insert agq;
        
        Assignment_Group_Member__c agm = new Assignment_Group_Member__c();
        agm.Assignment_Group__c = ag.id;
        agm.Active__c = true;
        agm.User__c = UserInfo.getUserId();
        insert agm;
            
        
		system.debug('queue: '+ q1.id);
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
         c2.Campaign_Code__c = 'AVJH7';
        update c2;
           
      /*  c2.Amount__c = 100;
        c2.GST__c = 'GST 5%';
        c2.Discount__c = 100;
        c2.Actual_Leads__c = 10;
        c2.Actual_Visits__c = 6;
        c2.Actual_Bookings__c = 5;
        c2.Campaign_Code__c = 'ANCUYTEE';
        update c2; */
       
         Lead__c l3 = new Lead__c();
         l3.First_Name__c = 'Test';
         l3.Last_Name__c = 'Lead 1';
         l3.Campaign_Custom__c = c2.id;
         l3.Apply_Round_Robin__c = true;
         l3.Status__c = 'Incoming';
         l3.MobilePhone__c = '1122334455';
         l3.Phone__c = '7887755663';
         l3.Project__c = p.Id;
         l3.OwnerId = testGroup.Id;
         l3.Alternate_Email__c = 'Test@gmail.com';
         l3.Email__c = 'Test2@gmail.com';
         insert l3;
        
         l3.Campaign_Custom__c = c2.id;
         l3.Apply_Round_Robin__c = true;
         l3.Project__c = p.Id;
         l3.Alternate_Email__c = 'Test@gmail.com';
         l3.Email__c = 'Test2@gmail.com';
         l3.MobilePhone__c = '1122334455';
         l3.Phone__c = '7887755663';
         
         update l3;
        leadList.add(l3);
        
			        
        Lead__c l1 = new Lead__c(First_Name__c = 'Test', Campaign_Custom__c = c2.id ,  Apply_Round_Robin__c = true,  Last_Name__c = 'Lead 1', Status__c = 'Incoming', MobilePhone__c = '1122334455', Project__c = p.Id);
        insert l1;
        Lead__c l11 = new Lead__c(First_Name__c = 'Test', ownerId = userInfo.getUserId(),Campaign_Custom__c = c2.id , Apply_Round_Robin__c = true, Last_Name__c = 'Lead 1', Status__c = 'Incoming', MobilePhone__c = '1122334455', Project__c = p.Id);
        insert l11;
        leadList2.add(l11);
        Lead__c l2 = new Lead__c(First_Name__c = 'Test', Campaign_Custom__c = c2.id ,  Apply_Round_Robin__c = true, Last_Name__c = 'Lead 2', Status__c = 'Incoming', MobilePhone__c = '1122334455', Project__c = p.Id);
        leadList.add(l2);
        
        Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
        LeadConversionServices.convertLead(leadList2);
    }
    
    @isTest
    public static void leadEmailDuplicate() {
        List<Lead__c> leadList = new List<Lead__c>();
        Project__c p = createProject();
        
        Lead__c l1 = new Lead__c(First_Name__c = 'Test', Last_Name__c = 'Lead 1',  Apply_Round_Robin__c = true, Status__c = 'Incoming', MobilePhone__c = '1122334455', Email__c = 'lead@test.in', Project__c = p.Id);
        insert l1;
        Lead__c l2 = new Lead__c(First_Name__c = 'Test', Last_Name__c = 'Lead 2', Apply_Round_Robin__c = true, Status__c = 'Incoming', MobilePhone__c = '1122334456', Email__c = 'lead@test.in', Project__c = p.Id);
        leadList.add(l2);
        
        Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
    }
    
    @isTest
    public static void leadPhoneDuplicate() {
        List<Lead__c> leadList = new List<Lead__c>();
        Project__c p = createProject();
        
        Lead__c l1 = new Lead__c(First_Name__c = 'Test', Last_Name__c = 'Lead 1',  Apply_Round_Robin__c = true, Status__c = 'Incoming', MobilePhone__c = '1122334455', Email__c = 'lead@test.in', Phone__c = '6677889900', Project__c = p.Id);
        insert l1;
        Lead__c l2 = new Lead__c(First_Name__c = 'Test', Last_Name__c = 'Lead 2', Apply_Round_Robin__c = true,  Status__c = 'Incoming', MobilePhone__c = '1122334456', Email__c = 'lead1@test.in', Phone__c = '6677889900', Project__c = p.Id);
        leadList.add(l2);
        
        Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
    }
    
    @isTest
    public static void leadAlternateEmailDuplicate() {
        List<Lead__c> leadList = new List<Lead__c>();
        Project__c p = createProject();
        
        Lead__c l1 = new Lead__c(First_Name__c = 'Test', Last_Name__c = 'Lead 1', Apply_Round_Robin__c = true, Status__c = 'Incoming', MobilePhone__c = '1122334455', Email__c = 'lead1@test.in', Alternate_Email__c = 'lead@test.in', Project__c = p.Id);
        insert l1;
        Lead__c l2 = new Lead__c(First_Name__c = 'Test', Last_Name__c = 'Lead 2', Apply_Round_Robin__c = true, Status__c = 'Incoming', MobilePhone__c = '1122334456', Email__c = 'lead2@test.in', Alternate_Email__c = 'lead@test.in', Project__c = p.Id);
        leadList.add(l2);
        
        Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead__c, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
    }
    
    @isTest
    public static void accountMobileDuplicate() {
        List<Account> accList = new List<Account>();
        List<Lead__c> leadList = new List<Lead__c>();
        Project__c p = createProject();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455');
        insert a1;
        Account a11 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455');
        insert a11;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334455');
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
    
    @isTest
    public static void accountEmailDuplicate() {
        List<Account> accList = new List<Account>();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455', PersonEmail = 'lead@test.in');
        insert a1;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334456', PersonEmail = 'lead@test.in');
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
    
    @isTest
    public static void accountPhoneDuplicate() {
        List<Account> accList = new List<Account>();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455', PersonEmail = 'lead@test.in', Phone = '6677889900');
        insert a1;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334456', PersonEmail = 'lead1@test.in', Phone = '6677889900');
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
    
    @isTest
    public static void accountAlternateEmailDuplicate() {
        List<Account> accList = new List<Account>();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455', PersonEmail = 'lead1@test.in', Alternate_Email__c = 'lead@test.in');
        insert a1;
        a1.Phone = '6677889900';
        update a1;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334456', PersonEmail = 'lead2@test.in', Alternate_Email__c = 'lead@test.in');
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
    @isTest
    public static void OpportunityPhoneDuplicate() {
        List<Opportunity__c> oppList = new List<Opportunity__c>();
        
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334456', PersonEmail = 'lead2@test.in', Alternate_Email__c = 'lead@test.in');
        insert a2;
        Account a3 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334456', PersonEmail = 'lead2@test.in', Alternate_Email__c = 'lead@test.in');
        insert a3;
        Project__c p = createProject();
        
        Opportunity__c o1 = new Opportunity__c(Name = 'Test1', StageName__c = 'Assigned', Project__c = p.Id,AccountId__c = a2.id);
        insert o1;

        Opportunity__c o2 = new Opportunity__c(Name = 'Test1', StageName__c = 'Assigned', Project__c = p.Id,AccountId__c = a3.id);
        oppList.add(o2);
        
        Map<Opportunity__c, List<DuplicationHandlerServices.duplicateWrapper>> oppDuplicateMap = new Map<Opportunity__c, List<DuplicationHandlerServices.duplicateWrapper>>();
    //    oppDuplicateMap = DuplicationHandlerServices.duplicationCheckOpportunity(oppList);
    }
   
    
    
    
}
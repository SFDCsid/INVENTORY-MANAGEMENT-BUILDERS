@isTest
public class Test_DuplicateLogic {
    @isTest
    public static void duplicateLeadUpdateTest()
    {
        Test.StartTest();
        Id rtCall = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Call').getRecordTypeId();
        Id rtMeeting = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Meeting').getRecordTypeId();
        Id rtWhatsapp = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Whatsapp').getRecordTypeId();
        
        List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];

        Task t = new Task();
        //t.WhoId = l.id;
        t.Subject= 'Call';
        t.Opportunity_Stage__c ='01-Created';
        t.Next_Action_Date__c= system.today().addDays(1);
        t.RecordTypeId = rtCall ;
        insert t;
        
        Task t4 = new Task();
        //t4.WhoId = l.id;
        t4.Subject= 'Meeting';
        t4.Opportunity_Stage__c  ='02-Requirement Gathering';
        t4.Next_Action_Date__c= system.today().addDays(1);
        t4.RecordTypeId = rtMeeting ;
        insert t4;
        
        Task tt= [select id,Opportunity_Stage__c ,Next_Action_Date__c,Date__c from task where id =: t4.id];
        
        tt.Opportunity_Stage__c ='03-Negotiation';
        //tt.Sub_Opportunity_Stage__c  = 'Unserviced';
        tt.Next_Action_Date__c= system.today().addDays(1);
        update tt;
        
        Task t1 = new Task();
        //t1.WhoId = l.id;
        t1.Subject= 'Whatsapp';
        t1.Opportunity_Stage__c  ='04-Closed (Won)';
        //t1.Sub_Opportunity_Stage__c  = 'Hot';
        t1.Next_Action_Date__c= system.today().addDays(1);
        t1.RecordTypeId = rtWhatsapp;
        insert t1;
        
        //Task t2 = new Task();
        //t2.WhoId = l.id;
        //t1.Subject= 'Whatsapp';
        //t2.Opportunity_Stage__c  = '04-Closed (Won)';
        //t1.Sub_Opportunity_Stage__c  = 'Hot';
        //t2.Next_Action_Date__c= system.today().addDays(1);
        //t2.RecordTypeId = rtWhatsapp ;
        //insert t2;
              
        Account a = new Account ();
        a.Name = 'acc';
        a.Phone = '7770090201';
        //a.PersonMobilePhone = '7770090202';
        //a2.Alternate_Email__c = 'acc@gmail.com';
        //a.PersonEmail = 'ac18@gmail.com';
        a.recordTypeId = personAccountRecordType[0].Id;

        insert a;
        
        a.Phone = '7770090203';
        //a.PersonEmail = 't17@gmail.com';
        update a;
        
        Account a1 = new Account ();
        a1.Name = 'acc 1';
       // a1.PersonEmail = 'a16@gmail.com';
        insert a1;
        Test.StopTest();
    }
    
    /*@isTest(SeeAllData=true)
    public static void duplicateLeadInsertTest()
    {
        Test.StartTest();
        Lead l = new Lead();
        l.LastName = 'Test 1';
        l.MobilePhone = '9001202121';
        l.Phone = '9001202122';
        l.Alternate_Email__c = 'test44@gmail.com';
        l.Email = 'test22@gmail.com';
        insert l;
        
        /// BY Phone
        Lead l1 = new Lead();
        l1.LastName = 'Test 2';
        l1.MobilePhone = '9001202121';
        l1.Phone = '9001202123';
        l1.Alternate_Email__c = 'test@gmail.com';
        l1.Email = 'test2@gmail.com';
        l1.Presale_Next_Follow_up_Date__c = system.now();
        insert l1;
        
        //LeadFollowUpBatch b1 = new LeadFollowUpBatch(); 
        //database.executebatch(b1,1);
        
        Lead l2 = new Lead();
        l2.LastName = 'Test 3';
        //l2.MobilePhone = '9001202124';
       // l2.Phone = '9001202123';
        l2.Alternate_Email__c = 'test@gmail.com';
        //l2.Email = 'test2@gmail.com';
        insert l2;
        List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account a = new Account ();
        a.Name = 'acc 2';
        a.Phone = '9822341223';
        //a.PersonMobilePhone = '9922341223';
        a.Alternate_Email__c = 'acc12@gmail.com';
        //a.PersonEmail = 'acc32@gmail.com';
        a.recordTypeId = personAccountRecordType[0].Id;
        insert a;
        */
          
    @isTest(SeeAllData=true)
    public static void duplicateLeadInsertTest()
    {
    
       Test.StartTest();

        
        Id rtCall = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Call').getRecordTypeId();
        Id rtMeeting = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Meeting').getRecordTypeId();
        Id rtWhatsapp = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Whatsapp').getRecordTypeId();
        
        //Project__c pr = createProject();
        
        List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
 
        Account a2 = new Account ();
        a2.Name = 'acc 2';
        a2.Phone = '7770090205';
        //a2.PersonMobilePhone = '7770090206';
        //a2.Alternate_Email__c = 'acc@gmail.com';
        //a2.PersonEmail = 'a15@gmail.com';
        a2.recordTypeId = personAccountRecordType[0].Id;

        insert a2;
        
        a2.Phone = '7770090207';
        //a2.PersonEmail = 'a14@gmail.com';
        update a2;
        
        
        Opportunity Opp = new Opportunity();
        Opp.Name = 'Testet';
        Opp.AccountId = a2.id;
        Opp.Opportunity_Stage__c='04-Closed (Won)';
        Opp.CloseDate = system.today().addDays(1);
        Opp.StageName = 'Size and Impact Study';
        //opp.Project__c = pr.Id;
        //opp.Sales_Next_Follow_up_Date__c = system.now();
        insert Opp;
        
        Opportunity Opp1 = new Opportunity();
        Opp1.Name = 'Test Opp';
        Opp1.AccountId = a2.id;
        Opp1.Opportunity_Stage__c= '01-Created';
        Opp1.CloseDate = system.today().addDays(1);
        Opp1.StageName = 'Proposal Submitted';
        //opp1.Project__c = pr.Id;
        //opp1.Sales_Next_Follow_up_Date__c = system.now();
        insert Opp1;
        
        //opportunityFollowUpBatch b = new opportunityFollowUpBatch(); 
        //database.executebatch(b,1);
        
        //Contact c = new Contact(lastname='test');
        
        Task t5 = new Task();
        //t2.WhoId = c.Id;
        t5.WhatId = Opp.id;
        t5.Subject= 'Call';
        //t2.Opportunity_Stage__c  = '02-Requirement Gathering    ';
        //t2.Sub_Opportunity_Stage__c  = 'Unserviced';
        t5.Next_Action_Date__c= system.today().addDays(1);
        t5.RecordTypeId = rtCall ;
        insert t5;
        
        t5.Opportunity_Stage__c  = '03-Negotiation  ';
        //t2.Sub_Opportunity_Stage__c  = 'Loan Issues';
        t5.RecordTypeId = rtCall ;
        update t5;
        
        Task t6 = new Task();
        //t13.WhoId = c.Id;
        t6.WhatId = Opp.id;
        t6.Subject= 'Meeting';
        t6.Opportunity_Stage__c  = '02-Requirement Gathering   ';
        //t13.Sub_Opportunity_Stage__c  = 'Loan Issues';
        t6.Next_Action_Date__c= system.today().addDays(1);
        t6.RecordTypeId = rtMeeting ;
        insert t6;
        
        t6.Opportunity_Stage__c  = '02-Requirement Gathering';
        //t13.Sub_Opportunity_Stage__c  = 'Unserviced';
        t6.RecordTypeId = rtMeeting ;
        
        Update t6;
        
        Task t7= new Task();
        //t14.WhoId = c.Id;
        t7.WhatId = Opp.id;
        t7.Subject= 'Whatsapp';
        t7.Opportunity_Stage__c  = '03-Negotiation    ';
        //t13.Sub_Opportunity_Stage__c  = 'Loan Issues';
        t7.Next_Action_Date__c= system.today().addDays(1);
        t7.RecordTypeId = rtWhatsapp;
        insert t7;
        
        t7.Opportunity_Stage__c  = '03-Negotiation ';
        //t13.Sub_Opportunity_Stage__c  = 'Unserviced';
        t7.RecordTypeId = rtWhatsapp ;
        
         Update t7;
        
        Account a3 = new Account ();
        a3.Name = 'acc 21';
        a3.Phone = '7770090208';
        //a3.PersonMobilePhone = '7770090209';
        //a2.Alternate_Email__c = 'acc@gmail.com';
        //a3.PersonEmail = 'a13@gmail.com';
        insert a3;
        
        a3.Phone = '7870090202';
        //a.Alternate_Email__c = 'test@gmail.com';
        update a3;
        Test.StopTest();
        
    }
    
    @isTest
    public static void dupeOppNewMethod()
    {   
    
        Id rtCall = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Call').getRecordTypeId();
        Id rtMeeting = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Meeting').getRecordTypeId();
        Id rtWhatsapp = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Whatsapp').getRecordTypeId();
        
        
        //Contact c = new Contact(lastname='test');
        //Project__c pr = createProject();
        List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
  
        Account a4 = new Account ();
        a4.Name = 'acc 222';
        a4.Phone = '1770090202';
        //a4.PersonMobilePhone = '2770090202';
        //a.Alternate_Email__c = 'acc12@gmail.com';
        //a4.PersonEmail = 'a12@gmail.com';
        a4.recordTypeId = personAccountRecordType[0].Id;

        insert a4;
        
        Opportunity Opp2 = new Opportunity();
        Opp2.Name = 'Test Opp';
        Opp2.AccountId = a4.id;
        Opp2.Opportunity_Stage__c  = '04-Closed (Won)';
        Opp2.CloseDate = system.today().addDays(1);
        Opp2.StageName = 'Negotiation	';

        //opp.Project__c = pr.Id;
        //opp.Sales_Next_Follow_up_Date__c = system.now();
        insert Opp2;
        
        Task t8 = new Task();
        //t2.WhoId = c.Id;
        t8.WhatId = Opp2.id;
        t8.Subject= 'Call';
        t8.Opportunity_Stage__c  = '02-Requirement Gathering';
        //t2.Sub_Opportunity_Stage__c  = 'Unserviced';
        t8.Next_Action_Date__c= system.today().addDays(1);
        t8.RecordTypeId = rtCall ;
        insert t8;
        
        Task t9 = new Task();
        //t22.WhoId = c.Id;
        t9.WhatId = Opp2.id;
        t9.Subject= 'Meeting';
        t9.Opportunity_Stage__c  ='01-Created';
        //t2.Sub_Opportunity_Stage__c  = 'Unserviced';
        t9.Next_Action_Date__c= system.today().addDays(1);
        t9.RecordTypeId = rtMeeting ;
        insert t9;
        
        Task t10 = new Task();
        //t222.WhoId = c.Id;
        t10.WhatId = Opp2.id;
        t10.Subject= 'Whatsapp';
        t10.Opportunity_Stage__c  = '05-Closed (Lost)  ';
        //t2.Sub_Opportunity_Stage__c  = 'Unserviced';
        t10.Next_Action_Date__c= system.today().addDays(1);
        t10.RecordTypeId = rtWhatsapp ;
        insert t10;
    }
    
    @isTest
    public static void duplicateAccountUpdateTest()
    {
        Id rtCall = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Call').getRecordTypeId();
        Id rtMeeting = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Meeting').getRecordTypeId();
        Id rtWhatsapp = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Whatsapp').getRecordTypeId();
        
        List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];

        Account a4 = new Account ();
        a4.Name = 'acc 29';
        a4.Phone = '3770090202';
        //a4.PersonMobilePhone = '4770090202';
        //a.Alternate_Email__c = 'acc12@gmail.com';
        //a4.PersonEmail = 'a11@gmail.com';
        a4.recordTypeId = personAccountRecordType[0].Id;

        insert a4;
        
        
        Account a5 = new Account ();
        a5.Name = 'acc 29';
        a5.Phone = '5770090202';
        //a5.PersonMobilePhone = '6770090202';
        //a2.Alternate_Email__c = 'acc@gmail.com';
        //a5.PersonEmail = 'a10@gmail.com';
        insert a5;
        
        a5.Phone = '9770090202';
        //a5.PersonEmail = 'a9@gmail.com';
        update a5;

       
    }
    
    @isTest
    public static void duplicateAccountInsertTest()
    {
        
        List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account a6 = new Account ();
        a6.Name = 'acc 299';
        a6.Phone = '9604024759';
        //a6.PersonMobilePhone = '9604024758';
        //a.Alternate_Email__c = 'acc12@gmail.com';
        //a6.PersonEmail = 'a8@gmail.com';
        a6.recordTypeId = personAccountRecordType[0].Id;

        insert a6;
        
        
        Account a7 = new Account ();
        a7.Name = 'acc 2555';
        a7.Phone = '9604024757';
        //a7.PersonMobilePhone = '9604024756';
        //a2.Alternate_Email__c = 'acc@gmail.com';
        //a7.PersonEmail = 'a7@gmail.com';
        insert a7;
        

    }
    
     @isTest
    public static void duplicateAccountEmailCheckTest()
    {
     
        List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
  
        Account a8 = new Account ();
        a8.Name = 'acc 2555';
        //a.Alternate_Email__c = 'acc12@gmail.com';
        //a8.PersonEmail = 'a6@gmail.com';
        a8.recordTypeId = personAccountRecordType[0].Id;

        insert a8;
        
        Account a9 = new Account ();
        a9.Name = 'acc 255';
        //a2.Alternate_Email__c = 'acc@gmail.com';
        //a9.PersonEmail = 'a5@gmail.com';
        insert a9;
        
        //a9.PersonEmail = 'a4@gmail.com';
        //update a9;

    }
    
    @isTest
    public static void taskUpdateTest()
    {
        Test.StartTest();
        
        Id rtCall = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Call').getRecordTypeId();
        Id rtMeeting = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Meeting').getRecordTypeId();
        Id rtWhatsapp = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Whatsapp').getRecordTypeId();
        
        
        List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];

        Task t12 = new Task();
        //t4.WhoId = l.id;
        t12.Subject= 'Meeting';
        t12.Opportunity_Stage__c  = Null;
        //t4.Sub_Opportunity_Stage__c  = Null;
        t12.Next_Action_Date__c= system.today().addDays(1);
        t12.RecordTypeId = rtCall ;
        insert t12;
        
        
        Task t13 = new Task();
        //t1.WhoId = l.id;
        t13.Subject= 'Meeting';
        t13.Opportunity_Stage__c  = '05-Closed (Lost)';
        //t1.Sub_Opportunity_Stage__c  = 'Hot';
        t13.Next_Action_Date__c= system.today().addDays(1);
        t13.RecordTypeId = rtMeeting;
        insert t13;
        
        t13.Subject= 'Meeting';
        t13.Opportunity_Stage__c  = '04-Closed (Won)';
        //t4.Sub_Opportunity_Stage__c  = 'Unserviced';
        t13.Next_Action_Date__c= system.today().addDays(1);
        
        update t13;
        
        Task t14 = new Task();
        //t11.WhoId = l.id;
        t14.Subject= 'Whatsapp';
        t14.Opportunity_Stage__c  = '01-Created ';
        //t1.Sub_Opportunity_Stage__c  = 'Hot';
        t14.Next_Action_Date__c= system.today().addDays(1);
        t14.RecordTypeId = rtWhatsapp ;
        insert t14;
        
        
        Account a10 = new Account ();
        a10.Name = 'acc 28';
        a10.Phone = '9604024751';
        //a10.PersonMobilePhone = '9604024752';
        //a.Alternate_Email__c = 'acc12@gmail.com';
        //a10.PersonEmail = 'a3@gmail.com';
        a10.recordTypeId = personAccountRecordType[0].Id;

        insert a10;
       
        
        Account a11 = new Account ();
        a11.Name = 'acc 288';
        a11.Phone = '9822341224';
        //a11.PersonMobilePhone = '9922341222';
        //a2.Alternate_Email__c = 'a@gmail.com';
        //a11.PersonEmail = 'a2@gmail.com';
        insert a11;
        
        a11.Phone = '9822341221';
        //a11.PersonEmail = 'a1@gmail.com';
        update a11;
        
        Account a12 = new Account ();
        a12.Name = 'acc 298';
        //a12.PersonEmail = 'a@gmail.com';
        insert a12;
        
        Task tt1= [select id,Opportunity_Stage__c ,Next_Action_Date__c,Date__c from task where id =: t14.id];
        
            tt1.Subject= 'Meeting';
            tt1.Opportunity_Stage__c  = '02-Requirement Gathering ';
            //tt.Sub_Opportunity_Stage__c  = 'Unserviced';
            tt1.Next_Action_Date__c= system.today().addDays(1);
            update tt1;
        Test.StopTest();
    }
    
    /*public static project__c createProject()
    {
        Project__c pr = new Project__c();
            pr.Name = 'test project';
        insert pr;
        return pr;
    }*/
}
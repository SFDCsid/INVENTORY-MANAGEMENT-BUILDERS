@isTest
public class TestCustomDuplicationHandlerServices {
    @isTest
    public static void duplicateLeadUpdateTest()
    {
        Test.StartTest();
        Id rtPresales = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presale Call').getRecordTypeId();
        Id rtSales = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Call').getRecordTypeId();
        
        Lead_c__c l = new Lead_c__c();
        //l.Name= 'Test 1';
        l.Last_Name__c ='Test';
        l.Mobile__c= '9001202121';
        l.Alternate_Mobile_No__c= '9001202122';
        l.Alternate_Email_Id__c	 = 'test44@gmail.com';
        l.Email__c= 'test22@gmail.com';
        insert l;
        
        Task t = new Task();
        t.WhatId = l.id;
        t.Status = 'Call complete';
        t.Stage__c = 'SNP';
        t.Sub_Stage__c = 'SNP';
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        t.RecordTypeId = rtPresales;
        insert t;
        
        Task t4 = new Task();
        t4.WhatId = l.id;
        t4.Status = 'Call complete';
        t4.Stage__c = 'SNP';
        t4.Sub_Stage__c = 'SNP';
        t4.Next_Follow_up_Date__c = system.today().addDays(1);
        t4.RecordTypeId = rtPresales;
        insert t4;
        
        Task tt= [select id, whoid,stage__c, sub_stage__c,Next_Follow_up_Date__c from task where id =: t4.id];
        
        tt.Stage__c = 'Visit Done';
        tt.Sub_Stage__c = 'Visit Done';
        tt.Next_Follow_up_Date__c = system.today().addDays(1);
        update tt;
        
        Task t1 = new Task();
        t1.WhatId = l.id;
        t1.Status = 'Call complete';
        t1.Stage__c = 'Visit Done';
        t1.Sub_Stage__c = 'Visit Done';
        t1.Next_Follow_up_Date__c = system.today().addDays(1);
        t1.RecordTypeId = rtSales;
        insert t1;
        
        update t1;
        
        /// BY Phone
        Lead_c__c l1 = new Lead_c__c();
        //l1.Name = 'Test 1';
        l1.Last_Name__c ='Test';
        l1.Mobile__c= '9001202124';
        l1.Alternate_Mobile_No__c= '9001202123';
        l1.Alternate_Email_Id__c = 'test@gmail.com';
        l1.Email__c = 'test2@gmail.com';
        insert l1;
        
        //l.Name = 'Test 1';
        l.Last_Name__c ='Test1';
        l.Mobile__c= '9001202124';
        l.Alternate_Mobile_No__c= '9001202122';
        l.Alternate_Email_Id__c = 'test44@gmail.com';
        l.Email__c = 'test22@gmail.com';
        update l;
        
        Lead_c__c l2 = new Lead_c__c();
        l2.Last_Name__c ='Test';
        l2.Mobile__c = '9001202124';
       // l2.Phone = '9001202123';
        l2.Alternate_Email_Id__c = 'test@gmail.com';
        l2.Email__c = 'test2@gmail.com';
        insert l2;
        
        Account a = new Account ();
        a.LastName = 'acc 2';
        a.Phone = '9822341223';
        a.PersonMobilePhone = '9922341223';
        a.Alternate_Email_Id__c = 'acc12@gmail.com';
        a.PersonEmail = 'acc32@gmail.com';
        insert a;
        
        Account a2 = new Account ();
        a2.LastName = 'acc 2';
        a2.Phone = '9822341224';
        a2.PersonMobilePhone = '9922341223';
        a2.Alternate_Email_Id__c = 'acc@gmail.com';
        a2.PersonEmail = 'acc2@gmail.com';
        insert a2;
        
        a.Phone = '9822341224';
        a.PersonEmail = 'test2@gmail.com';
        update a;
        
        Account a3 = new Account ();
        a3.LastName = 'acc 2';
        a3.PersonEmail = 'acc2@gmail.com';
        insert a3;
        Test.StopTest();
    }
    
    @isTest
    public static void duplicateLeadInsertTest()
    {
        Test.StartTest();
        Lead_c__c l = new Lead_c__c();
        l.Last_Name__c = 'Test 1';
        l.Mobile__c= '9001202121';
        l.Alternate_Mobile_No__c= '9001202122';
        l.Alternate_Email_Id__c = 'test44@gmail.com';
        l.Email__c  = 'test2@gmail.com';
        insert l;
        
        /// BY Phone
        Lead_c__c l1 = new Lead_c__c();
        l1.Last_Name__c = 'Test 2';
        l1.Mobile__c = '9001202121';
        l1.Alternate_Mobile_No__c = '9001202123';
        l1.Alternate_Email_Id__c = 'test@gmail.com';
        l1.Email__c = 'test2@gmail.com';
        l1.Follow_up_Date__c = system.now();
        insert l1;
        List<Lead_c__c> listLead = new List<Lead_c__c>();
        listLead.add(l1);
        LeadConversionServices.convertLead(listLead);
        //CustomLeadFollowUpBatch b1 = new CustomLeadFollowUpBatch(); 
        //database.executebatch(b1,1);
        
        Lead_c__c l2 = new Lead_c__c();
        l2.Last_Name__c	 = 'Test 3';
        l2.Mobile__c = '9001202124';
        l2.Alternate_Mobile_No__c = '9001202123';
        l2.Alternate_Email_Id__c = 'test@gmail.com';
        l2.Email__c = 'test2@gmail.com';
        insert l2;
         List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account a = new Account ();
        a.lastname = 'acc 2';
        a.Phone = '9822341223';
        //a.PersonMobilePhone = '9922341223';
        a.Alternate_Email_Id__c = 'acc12@gmail.com';
        //a.PersonEmail = 'acc32@gmail.com';
        //a.recordTypeId = personAccountRecordType[0].id;
        insert a;
        
        Id rtPresales = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presale Call').getRecordTypeId();
        Id rtSales = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Call').getRecordTypeId();
        
        Project__c pr = createProject();

        l1.Project_Name__c = pr.id;
        update l1;
        
        Opportunity Opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = a.id;
        opp.StageName = 'Qualification';
        opp.CloseDate = system.today().addDays(1);
        //opp.Project__c = pr.Id;
        //opp.Sales_Next_Follow_up_Date__c = system.now();
        insert opp;
        
        Opportunity Opp1 = new Opportunity();
        opp1.Name = 'Test Opp';
        opp1.AccountId = a.id;
        opp1.StageName = 'Booked';
        opp1.CloseDate = system.today().addDays(1);
        //opp1.Project__c = pr.Id;
        //opp1.Sales_Next_Follow_up_Date__c = system.now();
        insert opp1;
       
        Contact c = new Contact(lastname='test');
        
        Task t2 = new Task();
        t2.WhoId = c.Id;
        t2.WhatId = opp.id;
        t2.Status = 'Call complete';
        t2.Stage__c = 'Contact';
        t2.Sub_Stage__c = 'Unserviced';
        t2.Next_Follow_up_Date__c = system.today().addDays(1);
        t2.RecordTypeId = rtPresales;
        insert t2;
        
        t2.Stage__c = 'Lost';
        t2.Sub_Stage__c = 'Loan Issues';
        t2.RecordTypeId = rtPresales;
        update t2;
        
        Task t13 = new Task();
        t13.WhoId = c.Id;
        t13.WhatId = opp.id;
        t13.Status = 'Call complete';
        t13.Stage__c = 'Lost';
        t13.Sub_Stage__c = 'Loan Issues';
        t13.Next_Follow_up_Date__c = system.today().addDays(1);
        t13.RecordTypeId = rtSales;
        insert t13;
        
        t13.Stage__c = 'Contact';
        t13.Sub_Stage__c = 'Unserviced';
        t13.RecordTypeId = rtPresales;
        
        Update t13;
        
        Account a2 = new Account ();
        a2.lastname = 'acc 2';
        a2.Phone = '9822341224';
        a2.PersonMobilePhone = '9922341223';
        a2.Alternate_Email_Id__c = 'acc@gmail.com';
        a2.PersonEmail = 'test22@gmail.com';
        insert a2;
        
        a.Phone = '9822341224';
        a.Alternate_Email_Id__c = 'test@gmail.com';
        update a;
        Test.StopTest();
        
    }
    
    @isTest
    public static void CustomInsertTest()
    {
        Test.StartTest();
        Lead_c__c l = new Lead_c__c();
        l.Last_Name__c = 'Test 1';
        l.Mobile__c= '9001202121';
        l.Alternate_Mobile_No__c= '9001202122';
        l.Alternate_Email_Id__c = 'test44@gmail.com';
        l.Email__c  = 'test22@gmail.com';
        insert l;
        
        /// BY Phone
        Lead_c__c l1 = new Lead_c__c();
        l1.Last_Name__c = 'Test 2';
        l1.Mobile__c= '9001202121';
        l1.Alternate_Mobile_No__c= '9001202123';
        l1.Alternate_Email_Id__c = 'test@gmail.com';
        l1.Email__c = 'test2@gmail.com';
        l1.Follow_up_Date__c = system.now();
        insert l1;
        
        Lead_c__c l2 = new Lead_c__c();
        l2.Last_Name__c = 'Test 3';
        l2.Mobile__c = '9001202124';
        l2.Alternate_Mobile_No__c = '9001202123';
        l2.Alternate_Email_Id__c = 'test@gmail.com';
        l2.Email__c = 'test2@gmail.com';
        insert l2;
        
         List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        Account a = new Account ();
        a.LastName = 'acc';
        a.Phone = '9822341223';
        //a.PersonMobilePhone = '9922341223';
        a.Alternate_Email_Id__c = 'acc12@gmail.com';
        //a.PersonEmail = 'acc32@gmail.com';
        //a.recordTypeId = personAccountRecordType[0].id;
        insert a;
        
        Id rtPresales = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presale Call').getRecordTypeId();
        Id rtSales = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Call').getRecordTypeId();
        
        Project__c pr = createProject();
        
        Opportunity_c__c Opp = new Opportunity_c__c();
        opp.Last_Name__c = 'Test Opp';
        opp.Account_Name__c = a.id;
        opp.Opportunity_Stage__c = 'In Follow-up';
        //opp.Close_Date__c = system.today().addDays(1);
        opp.Project__c = pr.Id;
        opp.Next_Follow_up_Date__c = system.now();
        insert opp;
        
        Opportunity_c__c Opp1 = new Opportunity_c__c();
        opp1.Last_Name__c = 'Test Opp';
        opp1.Account_Name__c = a.id;
        opp1.Opportunity_Stage__c = 'In Follow-up';
        //opp1.Close_Date__c = system.today().addDays(1);
        opp1.Project__c = pr.Id;
        opp1.Next_Follow_up_Date__c = system.now();
        insert opp1;
       
        Contact c = new Contact(lastname='test');
        
        Task t2 = new Task();
        t2.WhoId = c.Id;
        t2.WhatId = opp.id;
        t2.Status = 'Call complete';
        t2.Stage__c = 'Contact';
        t2.Sub_Stage__c = 'Unserviced';
        t2.Next_Follow_up_Date__c = system.today().addDays(1);
        t2.RecordTypeId = rtPresales;
        insert t2;
        
        t2.Stage__c = 'Lost';
        t2.Sub_Stage__c = 'Loan Issues';
        t2.RecordTypeId = rtPresales;
        update t2;
        
        Task t13 = new Task();
        t13.WhoId = c.Id;
        t13.WhatId = opp.id;
        t13.Status = 'Call complete';
        t13.Stage__c = 'Lost';
        t13.Sub_Stage__c = 'Loan Issues';
        t13.Next_Follow_up_Date__c = system.today().addDays(1);
        t13.RecordTypeId = rtSales;
        insert t13;
        
        t13.Stage__c = 'Contact';
        t13.Sub_Stage__c = 'Unserviced';
        t13.RecordTypeId = rtPresales;
        
        Update t13;
        
        Account a2 = new Account ();
        a2.LastName = 'acc 2';
        a2.Phone = '9822341224';
        a2.PersonMobilePhone = '9922341223';
        a2.Alternate_Email_Id__c = 'acc@gmail.com';
        a2.PersonEmail = 'test22@gmail.com';
        insert a2;
        
        a.Phone = '9822341224';
        a.Alternate_Email_Id__c = 'test@gmail.com';
        update a;
        Test.StopTest();
        
    }
    @isTest
    public static void duplicateAccountUpdateTest()
    {
        Id rtPresales = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presale Call').getRecordTypeId();
        Id rtSales = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Call').getRecordTypeId();
        Account a = new Account ();
        a.LastName = 'acc 2';
        a.Phone = '9822341223';
        a.PersonMobilePhone = '9922341223';
        a.Alternate_Email_Id__c = 'acc12@gmail.com';
        a.PersonEmail = 'acc32@gmail.com';
        insert a;
        
        Lead_c__c l1 = new Lead_c__c();
        l1.Last_Name__c = 'Test 1';
        l1.Mobile__c= '9001202124';
        l1.Alternate_Mobile_No__c= '9001202123';
        l1.Alternate_Email_Id__c = 'test@gmail.com';
        l1.Email__c = 'test2@gmail.com';
        insert l1;
        
        Account a2 = new Account ();
        a2.LastName = 'acc 2';
        a2.Phone = '9822341224';
        a2.PersonMobilePhone = '9001202124';
        a2.Alternate_Email_Id__c = 'acc@gmail.com';
        a2.PersonEmail = 'acc2@gmail.com';
        insert a2;
        
        a.Phone = '9822341224';
        a.PersonEmail = 'acc2@gmail.com';
        update a;

        l1.Last_Name__c = 'Test 1';
        l1.Mobile__c= '9001202124';
        l1.Alternate_Mobile_No__c= '9001202122';
        l1.Alternate_Email_Id__c = 'test44@gmail.com';
        l1.Email__c= 'acc2@gmail.com';
        update l1;
        
    }
    
    @isTest
    public static void duplicateAccountInsertTest()
    {
        
        Account a = new Account ();
        a.LastName = 'acc 2';
        a.Phone = '9822341223';
        a.PersonMobilePhone = '9922341223';
        a.Alternate_Email_Id__c = 'acc12@gmail.com';
        a.PersonEmail = 'acc32@gmail.com';
        insert a;
        
        Lead_c__c l = new Lead_c__c();
        l.Last_Name__c = 'Test 1';
        l.Mobile__c= '9001202124';
        l.Alternate_Mobile_No__c= '9001202123';
        l.Alternate_Email_Id__c = 'test@gmail.com';
        l.Email__c= 'acc32@gmail.com';
        insert l;
        
        Account a2 = new Account ();
        a2.LastName = 'acc 2';
        a2.Phone = '9822341224';
        a2.PersonMobilePhone = '9922341223';
        a2.Alternate_Email_Id__c = 'acc@gmail.com';
        a2.PersonEmail = 'acc2@gmail.com';
        insert a2;
        
        Lead_c__c l1 = new Lead_c__c();
        l1.Last_Name__c = 'Test 1';
        l1.Mobile__c = '9001202124';
        l1.Alternate_Mobile_No__c= '9001202123';
        l1.Alternate_Email_Id__c = 'test@gmail.com';
        l1.Email__c = 'acc2@gmail.com';
        insert l1;
       
    }
    
     @isTest
    public static void duplicateAccountEmailCheckTest()
    {
        
        Account a = new Account ();
        a.LastName = 'acc 2';
        a.Alternate_Email_Id__c = 'acc12@gmail.com';
        a.PersonEmail = 'acc32@gmail.com';
        insert a;
        
        Account a2 = new Account ();
        a2.LastName = 'acc 2';
        a2.Alternate_Email_Id__c = 'acc@gmail.com';
        a2.PersonEmail = 'acc2@gmail.com';
        insert a2;
        
        a.PersonEmail = 'acc2@gmail.com';
        update a;

    }
    
    @isTest
    public static void taskUpdateTest()
    {
        Test.StartTest();
        Id rtPresales = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presale Call').getRecordTypeId();
        Id rtSales = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Call').getRecordTypeId();
        
        Lead_c__c l = new Lead_c__c();
        l.Last_Name__c = 'Test 1';
        l.Mobile__c= '9001202121';
        l.Alternate_Mobile_No__c= '9001202122';
        l.Alternate_Email_Id__c = 'test44@gmail.com';
        l.Email__c= 'test22@gmail.com';
        insert l;
        
        Task t = new Task();
        t.WhatId = l.id;
        t.Status = 'Call complete';
        t.Stage__c = 'SNP';
        t.Sub_Stage__c = 'SNP';
        t.Next_Follow_up_Date__c = system.today().addDays(1);
        t.RecordTypeId = rtPresales;
        insert t;
        
        Task t4 = new Task();
        t4.WhatId = l.id;
        t4.Status = 'Call complete';
        t4.Stage__c = 'SNP';
        t4.Sub_Stage__c = 'SNP';
        t4.Next_Follow_up_Date__c = system.today().addDays(1);
        t4.RecordTypeId = rtPresales;
        insert t4;
        
        
        Task t1 = new Task();
        t1.WhatId = l.id;
        t1.Status = 'Call complete';
        t1.Stage__c = 'In Follow-up';
        t1.Sub_Stage__c = 'Hot';
        t1.Next_Follow_up_Date__c = system.today().addDays(1);
        t1.RecordTypeId = rtSales;
        insert t1;
        
        t4.Status = 'Completed';
        t4.Stage__c = 'Contact';
        t4.Sub_Stage__c = 'Unserviced';
        t4.Next_Follow_up_Date__c = system.today().addDays(1);
        
        update t4;
        
        /// BY Phone
        Lead_c__c l1 = new Lead_c__c();
        l1.Last_Name__c = 'Test 1';
        l1.Mobile__c = '9001202124';
        l1.Alternate_Mobile_No__c= '9001202123';
        l1.Alternate_Email_Id__c = 'test@gmail.com';
        l1.Email__c= 'test2@gmail.com';
        insert l1;
        
        l1.Mobile__c = '9001202124';
        update l1;
        l.Last_Name__c = 'Test 1';
        l.Mobile__c  = '9001202124';
        l.Alternate_Mobile_No__c= '9001202122';
        l.Alternate_Email_Id__c = 'test44@gmail.com';
        l.Email__c= 'test22@gmail.com';
        update l;
        
        Lead_c__c l2 = new Lead_c__c();
        l2.Last_Name__c = 'Test 1';
        l2.Mobile__c = '9001202124';
        l2.Alternate_Mobile_No__c = '9001202123';
        l2.Alternate_Email_Id__c = 'test@gmail.com';
        l2.Email__c = 'test2@gmail.com';
        insert l2;
        
        Account a = new Account ();
        a.LastName = 'acc 2';
        a.Phone = '9822341223';
        a.PersonMobilePhone = '9922341223';
        a.Alternate_Email_Id__c = 'acc12@gmail.com';
        a.PersonEmail = 'acc32@gmail.com';
        insert a;
        
        Account a2 = new Account ();
        a2.LastName = 'acc 2';
        a2.Phone = '9822341224';
        a2.PersonMobilePhone = '9922341223';
        a2.Alternate_Email_Id__c = 'acc@gmail.com';
        a2.PersonEmail = 'acc2@gmail.com';
        insert a2;
        
        a.Phone = '9822341224';
        a.PersonEmail = 'test2@gmail.com';
        update a;
        
        Account a3 = new Account ();
        a3.LastName = 'acc 2';
        a3.PersonEmail = 'acc2@gmail.com';
        insert a3;
        
        Task tt= [select id, whoid,stage__c, sub_stage__c,Next_Follow_up_Date__c from task where id =: t4.id];
        
            tt.Status = 'Call complete';
            tt.Stage__c = 'Contact';
            tt.Sub_Stage__c = 'Unserviced';
            tt.Next_Follow_up_Date__c = system.today().addDays(1);
            update tt;
        Test.StopTest();
    }
    
    public static project__c createProject()
    {
        Project__c pr = new Project__c();
            pr.Name = 'test project';
        insert pr;
        return pr;
    }
}
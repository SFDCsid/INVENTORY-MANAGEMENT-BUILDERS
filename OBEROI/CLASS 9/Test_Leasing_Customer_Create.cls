@isTest
Public Class Test_Leasing_Customer_Create{
    @isTest
    Public static void Leasing_Customer_Create(){
        Account ac = new Account(Name = 'Test Bhagyashri',Company__c = 'Stetig');
        insert ac;
        
        Leasing_Project__c LP = new Leasing_Project__c();
        LP.Company_Code__c = '1200';
        LP.Business_Entity_Number__c = '1200';
        LP.Customer_Account_Group__c = '3400';
        LP.Leasing_Team__c = UserInfo.getUserId();
        LP.Sales_Organization__c = '1131';
        LP.Plant__c = '11AM';
        LP.Leasing_HOD__c = UserInfo.getUserId();
        insert LP;      
        
        Leasing_Rental_Unit__c lr = new Leasing_Rental_Unit__c();
        lr.INTRENO__c = 'IM00100001590';
        lr.Company_Code__c = '1200';
        //lr.Business_Entity_Number1__c = '1200';
        //lr.Number_of_Rental_Object1__c = 'F40';
        lr.Rental_Object_Type_ID__c = 'RU';
        lr.Rental_Object_Type_Description__c = 'Rental Unit';
        lr.Object_Valid_From__c = System.Today();
        lr.Usage_Type_ID__c = '5';
        lr.Usage_Type_Description__c = 'Usage Des';
        lr.Rental_Object_Name__c = 'F-40';
        lr.Building__c = LP.Id;
        lr.Building_Name__c = '00007030';
        lr.Cash_Flow_From__c = System.Today();
        lr.Unit_Type__c = 'Main Entity';
        insert lr;
        
        Account ca = new Account();
        ca.Name = 'Aakash Desai';
        ca.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        ca.Legacy_ID__c = 31100461;
        ca.Broker_Code__c = '31100461';
        insert ca;
        
        Channel_Partner_Project__c cpp = new Channel_Partner_Project__c();
        cpp.Account__c = ca.Id;
        cpp.Leasing_Project__c = LP.Id;
        insert cpp;
        
        
        Opportunity o = new Opportunity();
        o.Name = 'Kraft';
        o.CloseDate = System.Today();
        o.StageName = 'New';
        o.AccountId = ac.Id;
        o.Brand__c = 'Oreo';
        o.Leasing_Project__c = LP.id;
        o.Leasing_Rental_Unit__c = lr.Id;
        o.Cust_Name_1__c = 'Ms.Test Demo';
        o.Cust_Name_2__c = 'Cust Name 2';
        o.Mobile_Number_1__c = '6688995544';
        o.Email_Address_1__c = 'testdemo@gmail.com';
        o.Mobile_Number_2__c = '1212121212';
        o.Email_Address_2__c = 'testdemo2@gmail.com';
        //o.Account_Group1__c = '3400';
        //o.Company_Code1__c = '1200';
        //o.Business_Entity_Number1__c = '1200';
        o.Title_Mr_Company__c = 'Company';
        o.PAN_Number__c = 'ASDF12345J';
        o.PAN_Reference__c = 'Pan Ref';
        o.GST__c = 'GST';
        o.House_No__c = '123';
        o.Str_Suppl1__c = 'Street1';
        o.Str_Suppl2__c = 'Street2';
        o.Str_Suppl3__c = 'Street3';
        o.Building_Soc_House__c = 'Building';
        o.Location_2__c = 'Lo2';
        o.Post_Code1__c = '123456';
        o.City__c = 'Pune';
        o.Country_Picklist__c = 'India';
        o.Region1__c = 'Maharashtra';
        insert o;
        
        Opportunity o1 = new Opportunity();
        o1.Name = 'Kraft';
        o1.Source_of_Walk_in_Booking__c = 'Channel Partner';
        o1.Broker_Account__c = ca.Id;
        o1.CloseDate = System.Today();
        o1.StageName = 'New';
        o1.AccountId = ac.Id;
        o1.Brand__c = '';
        o1.Leasing_Project__c = LP.id;
        o1.Leasing_Rental_Unit__c = lr.Id;
        o1.Cust_Name_1__c = '';
        o1.Cust_Name_2__c = '';
        o1.Cust_Name_3__c = 'Ms.Test Demo';
        o1.Cust_Name_4__c = 'Ms.Test Demo';
        o1.Cust_Name_5__c = 'Ms.Test Demo';
        o1.Mobile_Number_1__c = '6688995544';
        o1.Email_Address_1__c = 'testdemo@gmail.com';
        o1.Mobile_Number_2__c = '1212121212';
        o1.Email_Address_2__c = 'testdemo2@gmail.com';
        o1.Mobile_Number_3__c = '6688995544';
        o1.Email_Address_3__c = 'testdemo@gmail.com';
        o1.Mobile_Number_4__c = '6688995544';
        o1.Email_Address_4__c = 'testdemo@gmail.com';
        o1.Mobile_Number_5__c = '6688995544';
        o1.Email_Address_5__c = 'testdemo@gmail.com';
        //o.Account_Group1__c = '3400';
        //o.Company_Code1__c = '1200';
        //o1.Business_Entity_Number__c = '';
        o1.Title_Mr_Company__c = '';
        //o1.Number_of_Rental_Object__c = '100';
        o1.PAN_Number__c = '';
        o1.PAN_Reference__c = '';
        o1.GST__c = '';
        o1.House_No__c = '';
        o1.Str_Suppl1__c = '';
        o1.Str_Suppl2__c = '';
        o1.Str_Suppl3__c = '';
        o1.Building_Soc_House__c = '';
        o1.Location_2__c = '';
        o1.Post_Code1__c = '';
        o1.City__c = 'Pune';
        o1.Country_Picklist__c = 'India';
        o1.Region1__c = 'Maharashtra';
        insert o1;
        
        Opportunity o2 = new Opportunity();
        o2.Name = 'Kraft';
        o2.Source_of_Walk_in_Booking__c = 'Channel Partner';
        o2.Broker_Account__c = ca.Id;
        o2.CloseDate = System.Today();
        o2.StageName = 'New';
        o2.AccountId = ac.Id;
        o2.Brand__c = '';
        o2.Leasing_Project__c = LP.id;
        o2.Leasing_Rental_Unit__c = lr.Id;
        o2.Cust_Name_1__c = '';
        o2.Cust_Name_2__c = '';
        o2.Cust_Name_3__c = 'Ms.Test Demo';
        o2.Cust_Name_4__c = 'Ms.Test Demo';
        o2.Cust_Name_5__c = 'Ms.Test Demo';
        o2.Mobile_Number_1__c = '6688995544';
        o2.Email_Address_1__c = 'testdemo@gmail.com';
        o2.Mobile_Number_2__c = '1212121212';
        o2.Email_Address_2__c = 'testdemo2@gmail.com';
        o2.Mobile_Number_3__c = '6688995544';
        o2.Email_Address_3__c = 'testdemo@gmail.com';
        o2.Mobile_Number_4__c = '6688995544';
        o2.Email_Address_4__c = 'testdemo@gmail.com';
        o2.Mobile_Number_5__c = '6688995544';
        o2.Email_Address_5__c = 'testdemo@gmail.com';
        o2.Customer_Number__c = '0034001306';
        //o.Account_Group1__c = '3400';
        //o.Company_Code1__c = '1200';
        //o2.Business_Entity_Number__c = '';
        o2.Title_Mr_Company__c = '';
        //o2.Number_of_Rental_Object__c = '100';
        o2.PAN_Number__c = '';
        o2.PAN_Reference__c = '';
        o2.GST__c = '';
        o2.House_No__c = '';
        o2.Str_Suppl1__c = '';
        o2.Str_Suppl2__c = '';
        o2.Str_Suppl3__c = '';
        o2.Building_Soc_House__c = '';
        o2.Location_2__c = '';
        o2.Post_Code1__c = '';
        o2.City__c = 'Pune';
        o2.Country_Picklist__c = 'India';
        o2.Region1__c = 'Maharashtra';
        insert o2;
        
        Tan_Table__c tt = new Tan_Table__c();
        tt.Opportunity__c = o.id;
        tt.Section_code__c = '123';
        tt.Certficate_no__c = 'xxxx';
        tt.Exem_Rate__c = 100;
        tt.Exem_from__c = System.today();
        tt.Exem_To__c = System.today();
        insert tt;
        
        Tan_Table__c tt1 = new Tan_Table__c();
        tt1.Opportunity__c = o2.id;
        tt1.Section_code__c = '123';
        tt1.Certficate_no__c = 'xxxx';
        tt1.Exem_Rate__c = 100;
        tt1.Exem_from__c = System.today();
        tt1.Exem_To__c = System.today();
        insert tt1;
        
        SAP_Credentials_Master__c SCM = New SAP_Credentials_Master__c();
        SCM.Name = 'Leasing Create Customer';
        SCM.URL__c = 'http://110.173.186.22:8003/zsfdcapi/customer_leasing?sap-client=100';
        SCM.User_ID__c = 'Stetig';
        SCM.Password__c = 'Stetig@2022  ';
        Insert SCM;
        
        SAP_Credentials_Master__c SCM1 = New SAP_Credentials_Master__c();
        SCM1.Name = 'CP Extend';
        SCM1.URL__c = 'http://110.173.186.22:8003/zsfdcapi/broker_ext?sap-client=100';
        SCM1.User_ID__c = 'Stetig';
        SCM1.Password__c = 'Stetig@2022  ';
        Insert SCM1;
        
        Test.StartTest();
        PageReference pageRef = Page.Lease_Customer_To_SAP;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id',String.valueOf(o.Id));
        LeaseCustomerToSAP LC = new LeaseCustomerToSAP();
        LC.flow();
        LC.incrementCounter();
        LC.BackToBooking();
        
        PageReference pageRef1 = Page.Lease_Customer_To_SAP;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('Id',String.valueOf(o1.Id));
        LeaseCustomerToSAP LC1 = new LeaseCustomerToSAP();
        LC1.flow();
        LC1.incrementCounter();
        LC1.BackToBooking();
        
        Rest_Create_Leasing_customer RCL = new Rest_Create_Leasing_customer();
        RCL.CreateLCust(o.Id);
        Rest_Create_Leasing_customer RCL1 = new Rest_Create_Leasing_customer();
        RCL1.CreateLCust(o1.Id);
        
        PageReference pageRef2 = Page.Lease_Customer_To_SAP;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('Id',String.valueOf(o2.Id));
        UpdateLeaseCustomer ULC = new UpdateLeaseCustomer();
        ULC.flow();
        ULC.incrementCounter();
        ULC.BackToBooking();
        
        Rest_Update_Leasing_customer UCL = new Rest_Update_Leasing_customer();
        UCL.UpdateLCust(o2.Id);
        
        Test.StopTest();
    }
}
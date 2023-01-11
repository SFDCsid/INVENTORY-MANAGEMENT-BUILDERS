@isTest
Public Class Test_REST_LeaseContractOAuth{
    @isTest
    Public static void LeaseContract(){
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
        lr.Business_Entity_Number__c = '1200';
        lr.Number_of_Rental_Object__c = 'F40';
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
        
        Opportunity o1 = new Opportunity();
        o1.Name = 'Kraft';
        o1.Customer_Number__c = '0034001324';
        o1.Source_of_Walk_in_Booking__c = 'Direct';
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
        //o1.Business_Entity_Number1__c = '';
        o1.Title_Mr_Company__c = '';
        //o1.Number_of_Rental_Object1__c = '100';
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
        
        Opportunity opp = [Select id,Opportunity_Number__c from Opportunity where id =: o1.id];
        Test.StartTest();
        
        List<REST_LeaseContractOAuth.Rental_Unit_List> RUL = new List<REST_LeaseContractOAuth.Rental_Unit_List>();
        
        REST_LeaseContractOAuth.Rental_Unit_List RL = new REST_LeaseContractOAuth.Rental_Unit_List();
        RL.INTRE_NO = 'IM00100001590';
        RL.INTRE_NO = 'IM00100000072';
        RL.INTRE_NO = 'IM00100000005';
        RUL.add(RL);
        
        List<REST_LeaseContractOAuth.Condition_Detail_List> CDL = new List<REST_LeaseContractOAuth.Condition_Detail_List>();
        REST_LeaseContractOAuth.Condition_Detail_List CD = new REST_LeaseContractOAuth.Condition_Detail_List();
        CD.CONDITION_TYPE = 'Z001';
        CD.UNIT_PRICE = 100000;
        CD.VALIDTO = '2021-09-24';
        CD.VALIDFROM = '2021-09-24';
        CD.CONDITION_TYPE_DES = 'Licence fees';
        CD.MEASUREMENT_ID = 'Z001';
        CD.MEASUREMENT_DESCRIPTION = 'Meas Des';
        CDL.add(CD);
        
        REST_LeaseContractOAuth.LeaseContractUpdate('0006021200567','IS00100007520','ZO02','Contract for License Fees','','1200','Miniso Pvt Ltd','0','Indian tenancy law',o1.Customer_Number__c,'Miniso Pvt Ltd','00001200','G01','','2021-09-24','2021-09-24','2021-09-24','2021-09-24','2021-09-24',RUL,opp.Opportunity_Number__c,'2021-09-24','2021-09-24','2021-09-24','2021-09-24',CDL);
        REST_LeaseContractOAuth.LeaseContractUpdate('0006021200567','IS00100007520','ZO01','Contract for License Fees','','1200','Miniso Pvt Ltd','0','Indian tenancy law',o1.Customer_Number__c,'Miniso Pvt Ltd','00001200','G01','','2021-09-24','2021-09-24','2021-09-24','2021-09-24','2021-09-24',RUL,opp.Opportunity_Number__c,'2021-09-24','2021-09-24','2021-09-24','2021-09-24',CDL);
        Test.StopTest();
    }
}
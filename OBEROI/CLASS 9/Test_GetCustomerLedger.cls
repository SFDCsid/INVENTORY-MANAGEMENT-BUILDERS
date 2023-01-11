@isTest
public class Test_GetCustomerLedger{
    @isTest
    Public static void GetLedger(){
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
        
        Opportunity o = new Opportunity();
        o.Name = 'Kraft';
        o.CloseDate = System.Today();
        o.StageName = 'New';
        o.AccountId = ac.Id;
        o.Brand__c = 'Oreo';
        o.Leasing_Project__c = LP.id;
        o.Leasing_Rental_Unit__c = lr.Id;
        o.Cust_Name_1__c = 'Ms.Test Demo';
        o.Customer_Number__c = '0034001325';
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
        
        SAP_Credentials_Master__c SCM = New SAP_Credentials_Master__c();
        SCM.Name = 'Get Customer Leger';
        SCM.URL__c = 'http://110.173.186.22:8003/zsfdcapi/refx_cust_os?sap-client=100';
        SCM.User_ID__c = 'Stetig';
        SCM.Password__c = 'Stetig@2022';
        Insert SCM;
        
        Test.StartTest();
        PageReference pageRef2 = Page.Get_Account_Statement;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('Id',o.Id);
        GetCustomerLedger GCL = new GetCustomerLedger();
        GCL.GetDocument();
        GCL.BackToBooking();
        GCL.SaveToBooking();
        Test.StopTest();    
    }
    
    static testMethod void testParse() {
        String json = '{\"EP_XSTRING\":\"JVBERi0xLjMNCiXi48/TDQolUlNUWFBERjMgUGFyYW1ldGVyczogRFJTVFhoDQoyIDAgb2JqDQo8PA0KL0ZpbHRlciAzIDAgUg0KL0VnN0YXJ0eHJlZg0KNDg2NTcNCiUlRU9GDQo=\",\"ERROR_MESSAGE\":\"\"}';
        GetCustomerLegerJ2A obj = GetCustomerLegerJ2A.parse(json);
        System.assert(obj != null);
    }
}
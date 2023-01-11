@isTest
public class TEST_REST_SAP_CP_Extend_Leasing {
    @isTest
    public static void method1(){
        
        SAP_Credentials_Master__c SCM1 = New SAP_Credentials_Master__c();
        SCM1.Name = 'CP Extend';
        SCM1.URL__c = 'http://110.173.186.22:8003/zsfdcapi/broker_ext?sap-client=100';
        SCM1.User_ID__c = 'Stetig';
        SCM1.Password__c = 'Stetig@2022  ';
        Insert SCM1;
        SAP_Credentials_Master__c SCM2 = New SAP_Credentials_Master__c();
        SCM2.Name = 'Leasing Create Customer';
        SCM2.URL__c = 'http://110.173.186.22:8003/zsfdcapi/broker_ext?sap-client=100';
        SCM2.User_ID__c = 'Stetig';
        SCM2.Password__c = 'Stetig@2022  ';
        Insert SCM2;
        
        Site__c st = new Site__c( Name = 'Test site' + Math.random());
        insert st;
        
        Project__c prj = new Project__c(
            Name = 'Elysian Tower A',Plant__c ='767c',
            CFO__c = UserInfo.getUserId(),Company_name__c='test',
            Front_Desk_User__c = UserInfo.getUserId(),site__c =st.id,
            Marcom_Head__c = UserInfo.getUserId(),
            Marcom_Manager__c = UserInfo.getUserId(),
            Sales_Head__c =UserInfo.getUserId(),Site_Head__c=UserInfo.getUserId(), MD__c =UserInfo.getUserId());
        insert prj;
        
        
        Leasing_Project__c LP = new Leasing_Project__c();
        LP.Company_Code__c = '1200';
        LP.Business_Entity_Number__c = '1200';
        LP.Customer_Account_Group__c = '3400';
        LP.Leasing_Team__c = UserInfo.getUserId();
        LP.Sales_Organization__c = '1131';
        LP.Plant__c = '11AM';
        LP.Leasing_HOD__c = UserInfo.getUserId();
        insert LP;  
        
        Id cpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        
        Account cp = new Account();
        cp.RecordTypeId = cpRecordTypeId;
        CP.Name = 'TEst Cp';
        CP.MAHA_RERA_Registration__c = '1q2w3e4r5t6y7u8';
        CP.Name_1__c = 'TEst Cp';
        CP.PAN_1__c = 'TEstC1234p';
        CP.Email_1__c = 'Email@1.c';
        CP.Mobile_1__c = '9897867564';
        CP.Street__c = 'HN1';
        CP.City__c = 'Pune';
        CP.Street_2__c = 'ST1';
        CP.Region_List__c = 'Maharashtra';
        CP.Street_3__c = 'ST2';
        CP.Country_List__c = 'India';
        CP.Street_4__c = 'ST3';
        CP.Postal_code__c = '414002';
        CP.Locality__c = 'Lo';
        CP.Broker_Code__c = '12345678';
        insert CP;
        
        Account ac = new Account();
        ac.firstName = 'shubham';
        ac.lastName='test';
        ac.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ac.personEmail = 'shubhamtest@stetig.in';
        ac.personMobilePhone = '1111122222';
        
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                          AccountId = ac.id);
        opp.Name = 'abc test';
        opp.CloseDate = System.today().AddDays(15);
        opp.AccountId = ac.id;
        opp.StageName = 'New';
        opp.Leasing_Project__c=LP.Id;
        insert opp;
        
        Channel_Partner_Project__c cpp = new Channel_Partner_Project__c();
        cpp.Account__c = CP.Id;
        cpp.Leasing_Project__c = LP.Id;
        insert cpp;
        
        
        REST_SAP_CP_Extend_Leasing.ExtendCP(CP, String.valueOf(opp.id));
    }
}
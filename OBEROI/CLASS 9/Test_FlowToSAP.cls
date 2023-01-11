@isTest
Public Class Test_FlowToSAP{
    Public static User dummyUser =createUser('ORL Admin', 'CFO_Director');
    Public static User FrontDesk =createUser('Front Desk','' );
    public static User createUser(String profileName, String roleName){
        Integer randomNumber = Integer.valueof((Math.random() * 100));
        UserRole role;
        
        if(!String.isBlank(roleName)){
            role = [SELECT Id FROM UserRole WHERE DeveloperName =: roleName LIMIT 1];
            if(role == null){
                role = new UserRole(DeveloperName = roleName, Name = roleName);
                INSERT role;
            }
        }
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name =: profileName].Id,
            LastName = 'last',
            Email = 'Oberoi'+randomNumber+'@test.com',
            Username = 'Oberoi'+randomNumber+'@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        
        if(role != null)
            u.UserRoleId = role.Id;
        
        Profile pro = [SELECT Id FROM Profile WHERE Name=:'System Administrator'];
        User admin = [SELECT id, NAme FROM USer where profileId =: pro.ID AND isActive=: true LIMIT 1];
        system.runAs(admin){
            INSERT u;
            //CFO =createUser('ORL Admin', 'CFO_Director'); 
        }  
        return u;
    }
    @isTest
    Public static void FLowController(){
        Account ac = new Account(Name = 'Test Bhagyashri',Company__c = 'Stetig');
        insert ac;
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
        cp.Broker_Code__c = '12345678';
        insert cp;
        
        Account cp2 = new Account();
        cp2.RecordTypeId = cpRecordTypeId;
        CP2.Name = 'TEst 1Cp';
        CP2.MAHA_RERA_Registration__c = '11q2w3e4r5t6y7u8';
        CP2.Name_1__c = 'TEst1 Cp';
        CP2.PAN_1__c = 'TEstC1234p';
        CP2.Email_1__c = 'Email1@1.c';
        CP2.Mobile_1__c = '8897867564';
        CP2.Street__c = 'HN1';
        CP2.City__c = 'Pune';
        CP2.Street_2__c = 'ST1';
        CP2.Region_List__c = 'Maharashtra';
        CP2.Street_3__c = 'ST2';
        CP2.Country_List__c = 'India';
        CP2.Street_4__c = 'ST3';
        CP2.Postal_code__c = '414002';
        CP2.Locality__c = 'Lo';
        cp2.Broker_Code__c = '12340678';
        insert cp2;
        
        Opportunity o = new Opportunity();
        o.Name = 'Capt Spiderman Test';
        o.Enquiry_Type__c = 'Partner';
        o.AccountId = ac.Id;
        o.Partner_s_Office_Address__c = 'Partner Address';
        o.Nationality__c = 'Indian';
        o.OwnerId = UserInfo.getUserId();
        o.Referred_Project__c = 'Elysian';
        o.Referred_By__c = 'Vikas Sir';
        o.Referred_Tower__c = 'A';
        o.Referred_Flat__c = '36';
        o.Referred_EMP_code__c = '12345';
        o.StageName = 'Booked';
        o.CloseDate = System.today();
        o.broker_account__c = cp.id;
        insert o;
        
        Opportunity o2 = new Opportunity();
        o2.Name = 'Capt Spiderman Test';
        o2.Enquiry_Type__c = 'Partner';
        o2.AccountId = ac.Id;
        o2.Partner_s_Office_Address__c = 'Partner Address';
        o2.Nationality__c = 'Indian';
        o2.OwnerId = UserInfo.getUserId();
        o2.Referred_Project__c = 'Elysian';
        o2.Referred_By__c = 'Vikas Sir';
        o2.Referred_Tower__c = 'A';
        o2.Referred_Flat__c = '36';
        o2.Referred_EMP_code__c = '12345';
        o2.StageName = 'Booked';
        o2.CloseDate = System.today();
        o2.broker_account__c = cp2.id;
        insert o2;
        
        Opportunity o3 = new Opportunity();
        o3.Name = 'Capt Spiderman Test';
        o3.Enquiry_Type__c = 'Direct';
        o3.AccountId = ac.Id;
        o3.Partner_s_Office_Address__c = 'Partner Address';
        o3.Nationality__c = 'Indian';
        o3.OwnerId = UserInfo.getUserId();
        o3.Referred_Project__c = 'Elysian';
        o3.Referred_By__c = 'Vikas Sir';
        o3.Referred_Tower__c = 'A';
        o3.Referred_Flat__c = '36';
        o3.Referred_EMP_code__c = '12345';
        o3.StageName = 'Booked';
        o3.CloseDate = System.today();
        //o3.broker_account__c = cp2.id;
        insert o3;
                        
        Quotation__c q = new Quotation__c();
        q.Opportunity__c = o.Id;
        q.Quote_Status__c = 'Valid';
        insert q;
        
        Quotation__c q2 = new Quotation__c();
        q2.Opportunity__c = o.Id;
        q2.Quote_Status__c = 'Valid';
        insert q2;
   
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
        
        Tower__c tw = new Tower__c(Tower_Name__c = 'A',Project_Name__c=prj.Id);
        insert tw;
        
        Property_Type__c PropertyType = new Property_Type__c(
        Material_No__c = '1239996'+string.valueOf(1),Project1__c= prj.Id,Description__c='TestPropertyType');
        Insert PropertyType;
        
        Property__c prop = new Property__c(
        Property_Type__c=PropertyType.id,Material_No__c = '99999'+string.valueOf(5));
        insert prop;
        
        Channel_Partner_Project__c CPProj = new Channel_Partner_Project__c ();
        CPProj.Account__c = cp.id;
        CPProj.Project__c = prj.id ;
        //CPProj.Extended__c = True ;       
        insert CPProj; 
        
        Channel_Partner_Project__c CPProj2 = new Channel_Partner_Project__c ();
        CPProj2.Account__c = cp2.id;
        CPProj2.Project__c = prj.id ;
        CPProj2.Extended__c = True ;       
        insert CPProj2; 
        
        Booking__c b = new Booking__c();
        b.Opportunity__c = o.Id;
        b.Booking_Date__c = System.today();
        b.Status__c = 'Booked';
        b.Doc_Verification_Status__c = 'Level 2 Accepted';
        b.Quotation__c = q.Id;
        b.Default_Address_of__c = '1st Applicant';
        b.Future_Correspondence_Contact_Name__c = 'Test Stetig';      //Future Correspondence Details
        b.Future_Correspondence_Contact_Email__c = 'test123@gmail.com';
        b.Future_Correspondence_Contact__c = '1st Applicant';
        b.Future_Correspondence_Contact_Relation__c = '1st Applicant';
        b.Future_Correspondence_Contact_Phone__c = '7658493820';
        b.Site__c = st.Id;  
        b.Project__c = prj.Id;
        b.Property_Name__c = 'OEY-A-5701';
        b.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b.Property__c = prop.Id;
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        insert b;
        
        Booking__c b2 = new Booking__c();
        b2.Opportunity__c = o2.Id;
        b2.Booking_Date__c = System.today();
        b2.Status__c = 'Booked';
        b2.Doc_Verification_Status__c = 'Level 2 Accepted';
        b2.Quotation__c = q.Id;
        b2.Default_Address_of__c = '1st Applicant';
        b2.Future_Correspondence_Contact_Name__c = 'Test Stetig';      //Future Correspondence Details
        b2.Future_Correspondence_Contact_Email__c = 'test123@gmail.com';
        b2.Future_Correspondence_Contact__c = '1st Applicant';
        b2.Future_Correspondence_Contact_Relation__c = '1st Applicant';
        b2.Future_Correspondence_Contact_Phone__c = '7658493820';
        b2.Site__c = st.Id;  
        b2.Project__c = prj.Id;
        b2.Property_Name__c = 'OEY-A-5701';
        b2.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b2.Property__c = prop.Id;
        b2.TDS_Paid_By__c = 'Authorization to Company';
        b2.Mode_of_Funding__c = 'Self';
        b2.Loan_Required__c = 'Yes';
        insert b2;
        
        Booking__c b3 = new Booking__c();
        b3.Opportunity__c = o.Id;
        b3.Booking_Date__c = System.today();
        b3.Status__c = 'Booked';
        b3.Doc_Verification_Status__c = 'Level 2 Accepted';
        b3.Quotation__c = q.Id;
        b3.Default_Address_of__c = '1st Applicant';
        b3.Future_Correspondence_Contact_Name__c = 'Test Stetig';      //Future Correspondence Details
        b3.Future_Correspondence_Contact_Email__c = 'test123@gmail.com';
        b3.Future_Correspondence_Contact__c = '1st Applicant';
        b3.Future_Correspondence_Contact_Relation__c = '1st Applicant';
        b3.Future_Correspondence_Contact_Phone__c = '7658493820';
        b3.Site__c = st.Id;  
        b3.Project__c = prj.Id;
        b3.Property_Name__c = 'OEY-A-5701';
        b3.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b3.Property__c = prop.Id;
        b3.TDS_Paid_By__c = 'Authorization to Company';
        b3.Mode_of_Funding__c = 'Self';
        b3.Loan_Required__c = 'Yes';
        b3.Customer_Code__c = '1232';
        b3.Sales_Document_SAP__c = '100232';
        b3.Pricing_Flown_to_SAP__c = true;
        b3.Billing_Plan_flown_to_SAP__c = true;
        insert b3;
        
        Booking__c b4 = new Booking__c();
        b4.Opportunity__c = o3.Id;
        b4.Booking_Date__c = System.today();
        b4.Status__c = 'Booked';
        b4.Doc_Verification_Status__c = 'Level 2 Accepted';
        b4.Quotation__c = q.Id;
        b4.Default_Address_of__c = '1st Applicant';
        b4.Future_Correspondence_Contact_Name__c = 'Test Stetig';      //Future Correspondence Details
        b4.Future_Correspondence_Contact_Email__c = 'test123@gmail.com';
        b4.Future_Correspondence_Contact__c = '1st Applicant';
        b4.Future_Correspondence_Contact_Relation__c = '1st Applicant';
        b4.Future_Correspondence_Contact_Phone__c = '7658493820';
        b4.Site__c = st.Id;  
        b4.Project__c = prj.Id;
        b4.Property_Name__c = 'OEY-A-5701';
        b4.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b4.Property__c = prop.Id;
        b4.TDS_Paid_By__c = 'Authorization to Company';
        b4.Mode_of_Funding__c = 'Self';
        b4.Loan_Required__c = 'Yes';
        b4.Customer_Code__c = '1232';
        b4.Sales_Document_SAP__c = '123112';
        b4.Pricing_Flown_to_SAP__c = true;
        b4.Billing_Plan_flown_to_SAP__c = False;
        insert b4;
        
        Booking__c b5 = new Booking__c();
        b5.Opportunity__c = o3.Id;
        b5.Booking_Date__c = System.today();
        b5.Status__c = 'Booked';
        b5.Doc_Verification_Status__c = 'Level 2 Accepted';
        b5.Quotation__c = q.Id;
        b5.Default_Address_of__c = '1st Applicant';
        b5.Future_Correspondence_Contact_Name__c = 'Test Stetig';      //Future Correspondence Details
        b5.Future_Correspondence_Contact_Email__c = 'test123@gmail.com';
        b5.Future_Correspondence_Contact__c = '1st Applicant';
        b5.Future_Correspondence_Contact_Relation__c = '1st Applicant';
        b5.Future_Correspondence_Contact_Phone__c = '7658493820';
        b5.Site__c = st.Id;  
        b5.Project__c = prj.Id;
        b5.Property_Name__c = 'OEY-A-5701';
        b5.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b5.Property__c = prop.Id;
        b5.TDS_Paid_By__c = 'Authorization to Company';
        b5.Mode_of_Funding__c = 'Self';
        b5.Loan_Required__c = 'Yes';
        b5.Customer_Code__c = '1232';
        b5.Sales_Document_SAP__c = '';
        b5.Pricing_Flown_to_SAP__c = true;
        b5.Billing_Plan_flown_to_SAP__c = true;
        insert b5;
        
        SAP_Credentials_Master__c SCM = New SAP_Credentials_Master__c();
        SCM.Name = 'CP Extend';
        SCM.URL__c = 'http://110.173.186.14:8003/zsfdcapi/broker_ext?sap-client=100';
        SCM.User_ID__c = 'Stetig';
        SCM.Password__c = 'Stetig#2021';
        Insert SCM;
        
        Test.StartTest();
        PageReference pageRef = Page.Flow_Customer_To_SAP;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id',String.valueOf(b.Id));
        FlowCustomerToSAP FLOW = new FlowCustomerToSAP();
        FLOW.flow();
        FLOW.incrementCounter();
        FLOW.BackToBooking();
        
        PageReference pageRef3 = Page.Flow_Customer_To_SAP;
        Test.setCurrentPage(pageRef3);
        pageRef3.getParameters().put('Id',String.valueOf(b2.Id));
        FlowCustomerToSAP FLOW3 = new FlowCustomerToSAP();
        FLOW3.flow();
        FLOW3.incrementCounter();
        FLOW3.BackToBooking();
        
        PageReference pageRef2 = Page.Flow_Customer_To_SAP;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('Id',String.valueOf(b3.Id));
        FlowCustomerToSAP FLOW2 = new FlowCustomerToSAP();
        FLOW2.flow();
        FLOW2.incrementCounter();
        FLOW2.BackToBooking();
        
        PageReference pageRef4 = Page.Flow_Customer_To_SAP;
        Test.setCurrentPage(pageRef4);
        pageRef4.getParameters().put('Id',String.valueOf(b4.Id));
        FlowCustomerToSAP FLOW4 = new FlowCustomerToSAP();
        FLOW4.flow();
        FLOW4.incrementCounter();
        FLOW4.BackToBooking();
        
        PageReference pageRef5 = Page.Flow_Customer_To_SAP;
        Test.setCurrentPage(pageRef5);
        pageRef5.getParameters().put('Id',String.valueOf(b5.Id));
        FlowCustomerToSAP FLOW5 = new FlowCustomerToSAP();
        FLOW5.flow();
        FLOW5.incrementCounter();
        FLOW5.BackToBooking();
        Test.StopTest();
    }
}
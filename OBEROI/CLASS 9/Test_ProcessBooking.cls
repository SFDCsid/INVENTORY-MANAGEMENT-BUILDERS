@isTest
Public Class Test_ProcessBooking{
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
    Public static void Process(){
        Account ac = new Account(Name = 'Test Bhagyashri',Company__c = 'Stetig');
        insert ac;
        
        Opportunity o = new Opportunity();
        o.Name = 'Capt Spiderman Test';
        o.Enquiry_Type__c = 'Customer Referral';
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
        insert o;
        
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
        
        for(Integer i = 0; i <= 5; i++){
        Applicant__c ap = new Applicant__c();
        if(i == 1)
        ap.Applicant_Number__c = 'Primary Applicant';
        if(i == 2)
        ap.Applicant_Number__c = 'Second Applicant';
        if(i == 3)
        ap.Applicant_Number__c = 'Third Applicant';
        if(i == 4)
        ap.Applicant_Number__c = 'Fourth Applicant';
        if(i == 5)
        ap.Applicant_Number__c = 'Fifth Applicant';
        ap.Salutation__c = 'Mr.';
        ap.Name = 'Bhagyashree Stetig';
        ap.Mobile_Number__c = '7796377643';
        ap.Alternate_Mobile_No__c = '8956789234';
        ap.Email_Address__c = 'abc@gmail.com';
        ap.Alternate_Email_Id__c = 'test123@gmail.com';
        ap.Occupation__c = 'Business';
        ap.Designation__c = 'Test 1';
        ap.Nationality__c = 'Indian';
        ap.PancardNo__c  = 'ABCDE1234K';
        ap.Subtype_Of_Applicant__c = 'Indian National';
        ap.Mailing_Address_same_as_PermanentAddress__c = false;
        ap.Preferred_address_for_all_correspondence__c = 'Permanent';
        ap.House_No__c = 'HN1';
        ap.City__c = 'Pune';
        ap.Street_1__c = 'ST1';
        ap.State__c = 'Maharashtra';
        ap.Street_2__c = 'ST2';
        ap.Country__c = 'India';
        ap.Street_3__c = 'ST3';
        ap.Pincode__c = '414002';
        ap.Locality__c = 'Lo';
        ap.Mailing_House_No__c = 'HN1';
        ap.Mailing_Street_1__c = 'ST1';
        ap.Mailing_Street_2__c = 'ST2';
        ap.Mailing_Street_3__c = 'ST3';
        ap.Mailing_Locality__c = 'Lo';
        ap.Mailing_City__c = 'Pune';
        ap.Mailing_State__c = 'Maharashtra';
        ap.Mailing_Country__c = 'India';
        ap.Mailing_Pincode__c = '411002';
        ap.Opportunity__c = o.Id;
        ap.Booking__c = b.Id;
        insert ap;
        }
        
        Booking__c b2 = new booking__c();
        b2.Opportunity__c = o.Id;
        b2.Booking_Date__c = System.today();
        b2.Status__c = 'UnProcessed';
        b2.Doc_Verification_Status__c = 'Level 2 Accepted';
        b2.Quotation__c = q2.Id;
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
        
        for(Integer i = 0; i <= 5; i++){
        Applicant__c ap2 = new Applicant__c();
        if(i == 1)
        ap2.Applicant_Number__c = 'Primary Applicant';
        if(i == 2)
        ap2.Applicant_Number__c = 'Second Applicant';
        if(i == 3)
        ap2.Applicant_Number__c = 'Third Applicant';
        if(i == 4)
        ap2.Applicant_Number__c = 'Fourth Applicant';
        if(i == 5)
        ap2.Applicant_Number__c = 'Fifth Applicant';
        ap2.Salutation__c = 'Mr.';
        ap2.Name = 'Bhagyashree Stetig';
        ap2.Mobile_Number__c = '7796377643';
        ap2.Alternate_Mobile_No__c = '8956789234';
        ap2.Email_Address__c = 'abc@gmail.com';
        ap2.Alternate_Email_Id__c = 'test123@gmail.com';
        ap2.Occupation__c = 'Business';
        ap2.Designation__c = 'Test 1';
        ap2.Nationality__c = 'Indian';
        ap2.PancardNo__c  = 'ABCDE1234K';
        ap2.Subtype_Of_Applicant__c = 'Indian National';
        ap2.Mailing_Address_same_as_PermanentAddress__c = false;
        ap2.Preferred_address_for_all_correspondence__c = 'Permanent';
        ap2.House_No__c = 'HN1';
        ap2.City__c = 'Pune';
        ap2.Street_1__c = 'ST1';
        ap2.State__c = 'Maharashtra';
        ap2.Street_2__c = 'ST2';
        ap2.Country__c = 'India';
        ap2.Street_3__c = 'ST3';
        ap2.Pincode__c = '414002';
        ap2.Locality__c = 'Lo';
        ap2.Mailing_House_No__c = 'HN1';
        ap2.Mailing_Street_1__c = 'ST1';
        ap2.Mailing_Street_2__c = 'ST2';
        ap2.Mailing_Street_3__c = 'ST3';
        ap2.Mailing_Locality__c = 'Lo';
        ap2.Mailing_City__c = 'Pune';
        ap2.Mailing_State__c = 'Maharashtra';
        ap2.Mailing_Country__c = 'India';
        ap2.Mailing_Pincode__c = '411002';
        ap2.Opportunity__c = o.Id;
        ap2.Booking__c = b2.Id;
        insert ap2;
        }
        
        Booking__c b3 = new booking__c();
        b3.Opportunity__c = o.Id;
        b3.Booking_Date__c = System.today();
        b3.Status__c = 'UnProcessed';
        b3.Doc_Verification_Status__c = 'Level 2 Accepted';
        b3.Quotation__c = q2.Id;
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
        b3.Pricing_Flown_to_SAP__c = True;
        b3.Customer_Code__c = '0033238499';
        insert b3;
        
        for(Integer i = 0; i <= 5; i++){
        Applicant__c ap3 = new Applicant__c();
        if(i == 1)
        ap3.Applicant_Number__c = 'Primary Applicant';
        if(i == 2)
        ap3.Applicant_Number__c = 'Second Applicant';
        if(i == 3)
        ap3.Applicant_Number__c = 'Third Applicant';
        if(i == 4)
        ap3.Applicant_Number__c = 'Fourth Applicant';
        if(i == 5)
        ap3.Applicant_Number__c = 'Fifth Applicant';
        ap3.Salutation__c = 'Mr.';
        ap3.Name = 'Bhagyashree Stetig';
        ap3.Mobile_Number__c = '7796377643';
        ap3.Alternate_Mobile_No__c = '8956789234';
        ap3.Email_Address__c = 'abc@gmail.com';
        ap3.Alternate_Email_Id__c = 'test123@gmail.com';
        ap3.Occupation__c = 'Business';
        ap3.Designation__c = 'Test 1';
        ap3.Nationality__c = 'Indian';
        ap3.PancardNo__c  = 'ABCDE1234K';
        ap3.Subtype_Of_Applicant__c = 'Indian National';
        ap3.Mailing_Address_same_as_PermanentAddress__c = false;
        ap3.Preferred_address_for_all_correspondence__c = 'Permanent';
        ap3.House_No__c = 'HN1';
        ap3.City__c = 'Pune';
        ap3.Street_1__c = 'ST1';
        ap3.State__c = 'Maharashtra';
        ap3.Street_2__c = 'ST2';
        ap3.Country__c = 'India';
        ap3.Street_3__c = 'ST3';
        ap3.Pincode__c = '414002';
        ap3.Locality__c = 'Lo';
        ap3.Mailing_House_No__c = 'HN1';
        ap3.Mailing_Street_1__c = 'ST1';
        ap3.Mailing_Street_2__c = 'ST2';
        ap3.Mailing_Street_3__c = 'ST3';
        ap3.Mailing_Locality__c = 'Lo';
        ap3.Mailing_City__c = 'Pune';
        ap3.Mailing_State__c = 'Maharashtra';
        ap3.Mailing_Country__c = 'India';
        ap3.Mailing_Pincode__c = '411002';
        ap3.Opportunity__c = o.Id;
        ap3.Booking__c = b3.Id;
        insert ap3;
        }
        
        Test.StartTest();
        PageReference pageRef = Page.ProcessBooking;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id',String.valueOf(b.Id));
        ProcessBooking PB = new ProcessBooking();
        PB.Process();
        PB.incrementCounter();
        
        PageReference pageRef2 = Page.ProcessBooking;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('Id',String.valueOf(b2.Id));
        ProcessBooking PB2 = new ProcessBooking();
        PB2.Process();
        PB2.incrementCounter();
        Pb2.BackToBooking();
        
        PageReference pageRef3 = Page.ProcessBooking;
        Test.setCurrentPage(pageRef3);
        pageRef3.getParameters().put('Id',String.valueOf(b3.Id));
        ProcessBooking PB3 = new ProcessBooking();
        PB3.Process();
        PB3.incrementCounter();
        Pb3.BackToBooking();
        Test.StopTest();
    }
    @isTest
    Public static void Rest_Create_customer(){
        Account ac = new Account(Name = 'Test Bhagyashri',Company__c = 'Stetig');
        insert ac;
        
        Opportunity o = new Opportunity();
        o.Name = 'Capt Spiderman Test';
        o.Enquiry_Type__c = 'Customer Referral';
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
        insert o;
        
        Quotation__c q = new Quotation__c();
        q.Opportunity__c = o.Id;
        q.Quote_Status__c = 'Valid';
        insert q;
        
        Quotation__c q2 = new Quotation__c();
        q2.Opportunity__c = o.Id;
        q2.Quote_Status__c = 'Valid';
        insert q2;
   
        Customer_Account_Group__c CAG = new Customer_Account_Group__c();
        CAG.Name = '1013';
        CAG.Customer_A_C_Group__c = 1013;
        CAG.Number_Id__c = 'A1';
        Insert CAG;
        
        Number_Range__c NR = New Number_Range__c();
        NR.Name = 'A1';
        NR.Number_Id__c = 'A1';
        NR.From_Number__c = '0010130001';
        NR.To_Number__c = '0010139999';
        NR.Last_Number_Used__c = '0010131543';
        Insert NR;
        
        SAP_Credentials_Master__c SCM = New SAP_Credentials_Master__c();
        SCM.Name = 'SAP Customer Creation';
        SCM.URL__c = 'http://110.173.186.14:8003/zsfdcapi/customer_create?sap-client=100';
        SCM.User_ID__c = 'Stetig';
        SCM.Password__c = 'Stetig#2021';
        Insert SCM;
        
        /*SAP_Credentials_Master__c SCM2 = New SAP_Credentia1s_Master__c();
        SCM2.Name = 'SAP Specific Customer';
        SCM2.URL__c = 'http://110.173.186.14:8003/zsfdcapi/customer_pricing?sap-client=100';
        SCM2.User_ID__c = 'Stetig';
        SCM2.Password__c = 'Stetig#2021';
        Insert SCM2;*/
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        Integer saleableArea = 1600;
        Integer carpetArea = 1050;
        Integer balconyArea = 600;
        
        Site__c st = new Site__c( Name = 'Test site' + Math.random());
        insert st;
        
        Project__c pj = new Project__c( 
        Name = 'Test Proj' + Math.random(), Plant__c ='767c' ,site__c =st.id,
        Active__c=true,Company_name__c='test', recordtypeId= PrRecordTypeId,
        Front_Desk_User__c = FrontDesk.id,Marcom_Head__c =dummyUser.Id, 
        Sales_Head__c =dummyUser.Id,Site_Head__c=dummyUser.Id, MD__c =dummyUser.Id, 
        Marcom_Manager__c = dummyUser.Id,CFO__c =dummyUser.Id);
        insert pj;
        
        Tower__c sinlgeTower = new Tower__c(Project_Name__c=pj.Id,tower_name__c='A',Customer_A_C_Group__c = 1013);
        insert sinlgeTower;
        
        Property_Type__c PropertyType = new Property_Type__c(
        Material_No__c = '1239996'+string.valueOf(1),Description__c='TestPropertyType',Control_Code__c='Test',
        Saleable_Area__c=saleableArea,Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea,Project1__c= pj.Id);
        Insert PropertyType;
        
        Property__c sinlgeproperty = new Property__c(Property_Type__c=PropertyType.id,Material_No__c = '99999'+string.valueOf(5),
        Description__c='TestPropertyType',Control_Code__c='Test',Saleable_Area__c=saleableArea,
        Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea);
        insert sinlgeproperty;
        
        Booking__c b3 = new booking__c();
        b3.Opportunity__c = o.Id;
        b3.Booking_Date__c = System.today();
        b3.Status__c = 'UnProcessed';
        b3.Doc_Verification_Status__c = 'Level 2 Accepted';
        b3.Quotation__c = q2.Id;
        b3.Default_Address_of__c = '1st Applicant';
        b3.Future_Correspondence_Contact_Name__c = 'Test Stetig';      //Future Correspondence Details
        b3.Future_Correspondence_Contact_Email__c = 'test123@gmail.com';
        b3.Future_Correspondence_Contact__c = '1st Applicant';
        b3.Future_Correspondence_Contact_Relation__c = '1st Applicant';
        b3.Future_Correspondence_Contact_Phone__c = '7658493820';
        b3.Site__c = st.Id;  
        b3.Project__c = pj.Id;
        b3.Property_Name__c = 'OEY-A-5701';
        b3.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b3.Property__c = sinlgeproperty.Id;
        b3.Tower__c = sinlgeTower.id;
        b3.TDS_Paid_By__c = 'Authorization to Company';
        b3.Mode_of_Funding__c = 'Self';
        b3.Loan_Required__c = 'Yes';
        b3.Pricing_Flown_to_SAP__c = True;
        b3.Customer_Code__c = '0033238499';
        insert b3;
        
        for(Integer i = 0; i <= 5; i++){
        Applicant__c ap3 = new Applicant__c();
        if(i == 1)
        ap3.Applicant_Number__c = 'Primary Applicant';
        if(i == 2)
        ap3.Applicant_Number__c = 'Second Applicant';
        if(i == 3)
        ap3.Applicant_Number__c = 'Third Applicant';
        if(i == 4)
        ap3.Applicant_Number__c = 'Fourth Applicant';
        if(i == 5)
        ap3.Applicant_Number__c = 'Fifth Applicant';
        ap3.Salutation__c = 'Mr.';
        ap3.Name = 'Bhagyashree Stetig';
        ap3.Mobile_Number__c = '7796377643';
        ap3.Alternate_Mobile_No__c = '8956789234';
        ap3.Email_Address__c = 'abc@gmail.com';
        ap3.Alternate_Email_Id__c = 'test123@gmail.com';
        ap3.Occupation__c = 'Business';
        ap3.Designation__c = 'Test 1';
        ap3.Nationality__c = 'Indian';
        ap3.PancardNo__c  = 'ABCDE1234K';
        ap3.Subtype_Of_Applicant__c = 'Indian National';
        ap3.Mailing_Address_same_as_PermanentAddress__c = false;
        ap3.Preferred_address_for_all_correspondence__c = 'Permanent';
        ap3.House_No__c = 'HN1';
        ap3.City__c = 'Pune';
        ap3.Street_1__c = 'ST1';
        ap3.State__c = 'Maharashtra';
        ap3.Street_2__c = 'ST2';
        ap3.Country__c = 'India';
        ap3.Street_3__c = 'ST3';
        ap3.Pincode__c = '414002';
        ap3.Locality__c = 'Lo';
        ap3.Mailing_House_No__c = 'HN1';
        ap3.Mailing_Street_1__c = 'ST1';
        ap3.Mailing_Street_2__c = 'ST2';
        ap3.Mailing_Street_3__c = 'ST3';
        ap3.Mailing_Locality__c = 'Lo';
        ap3.Mailing_City__c = 'Pune';
        ap3.Mailing_State__c = 'Maharashtra';
        ap3.Mailing_Country__c = 'India';
        ap3.Mailing_Pincode__c = '411002';
        ap3.Opportunity__c = o.Id;
        ap3.Booking__c = b3.Id;
        insert ap3;
        }
        Test.StartTest();
        Rest_Create_customer RCC = new Rest_Create_customer();
        rcc.CreateJSON(b3.id);
        Test.stopTest();
    }
    @isTest
    Public static void Rest_SAP_Customer_Specific_Pricing(){
        Account ac = new Account(Name = 'Test Bhagyashri',Company__c = 'Stetig');
        insert ac;
        
        Opportunity o = new Opportunity();
        o.Name = 'Capt Spiderman Test';
        o.Enquiry_Type__c = 'Customer Referral';
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
        insert o;
        
        Customer_Account_Group__c CAG = new Customer_Account_Group__c();
        CAG.Name = '1013';
        CAG.Customer_A_C_Group__c = 1013;
        CAG.Number_Id__c = 'A1';
        Insert CAG;
        
        Number_Range__c NR = New Number_Range__c();
        NR.Name = 'A1';
        NR.Number_Id__c = 'A1';
        NR.From_Number__c = '0010130001';
        NR.To_Number__c = '0010139999';
        NR.Last_Number_Used__c = '0010131543';
        Insert NR;
        
        SAP_Credentials_Master__c SCM2 = New SAP_Credentials_Master__c();
        SCM2.Name = 'SAP Specific Customer';
        SCM2.URL__c = 'http://110.173.186.14:8003/zsfdcapi/customer_pricing?sap-client=100';
        SCM2.User_ID__c = 'Stetig';
        SCM2.Password__c = 'Stetig#2021';
        Insert SCM2;
        
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        Integer saleableArea = 1600;
        Integer carpetArea = 1050;
        Integer balconyArea = 600;
        
        Site__c st = new Site__c( Name = 'Test site' + Math.random());
        insert st;
        
        Project__c pj = new Project__c( 
        Name = 'Test Proj' + Math.random(), Plant__c ='767c' ,site__c =st.id,
        Active__c=true,Company_name__c='test', recordtypeId= PrRecordTypeId,
        Front_Desk_User__c = FrontDesk.id,Marcom_Head__c =dummyUser.Id, 
        Sales_Head__c =dummyUser.Id,Site_Head__c=dummyUser.Id, MD__c =dummyUser.Id, 
        Marcom_Manager__c = dummyUser.Id,CFO__c =dummyUser.Id,Sales_Organization__c = '1102');
        insert pj;
        
        Tower__c sinlgeTower = new Tower__c(Project_Name__c=pj.Id,tower_name__c='A',Customer_A_C_Group__c = 1013);
        insert sinlgeTower;
        
        Property_Type__c PropertyType = new Property_Type__c(
        Material_No__c = '1239996'+string.valueOf(1),Description__c='TestPropertyType',Control_Code__c='Test',
        Saleable_Area__c=saleableArea,Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea,Project1__c= pj.Id);
        Insert PropertyType;
        
        Property__c sinlgeproperty = new Property__c(Property_Type__c=PropertyType.id,Material_No__c = '99999'+string.valueOf(5),
        Description__c='TestPropertyType',Control_Code__c='Test',Saleable_Area__c=saleableArea,
        Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea);
        insert sinlgeproperty;
        
        Quotation__c q2 = new Quotation__c();
        q2.Opportunity__c = o.Id;
        q2.Project__c = pj.id;
        q2.Quote_Status__c = 'Valid';
        q2.property__c = sinlgeproperty.id;
        q2.Carpet_Area__c = 1100;
        q2.Charge_1_Name__c = 'Basic';
        q2.Charge_1_Value_Modified__c = 1200;
        q2.Charge_2_Name__c = 'Car Parking';
        q2.Charge_2_Value_Modified__c = 1200;
        q2.Charge_3_Name__c = 'Floor Rise';
        q2.Charge_3_Value_Modified__c = 1200;
        q2.Charge_4_Name__c = 'PLC';
        q2.Charge_4_Value_Modified__c = 1200;
        q2.Charge_5_Name__c = 'Other';
        q2.Charge_5_Value_Modified__c = 1200;
        insert q2;
        
        Booking__c b3 = new booking__c();
        b3.Opportunity__c = o.Id;
        b3.Booking_Date__c = System.today();
        b3.Status__c = 'UnProcessed';
        b3.Doc_Verification_Status__c = 'Level 2 Accepted';
        b3.Quotation__c = q2.Id;
        b3.Default_Address_of__c = '1st Applicant';
        b3.Future_Correspondence_Contact_Name__c = 'Test Stetig';      //Future Correspondence Details
        b3.Future_Correspondence_Contact_Email__c = 'test123@gmail.com';
        b3.Future_Correspondence_Contact__c = '1st Applicant';
        b3.Future_Correspondence_Contact_Relation__c = '1st Applicant';
        b3.Future_Correspondence_Contact_Phone__c = '7658493820';
        b3.Site__c = st.Id;  
        b3.Project__c = pj.Id;
        b3.Property_Name__c = 'OEY-A-5701';
        b3.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b3.Property__c = sinlgeproperty.Id;
        b3.Tower__c = sinlgeTower.id;
        b3.TDS_Paid_By__c = 'Authorization to Company';
        b3.Mode_of_Funding__c = 'Self';
        b3.Loan_Required__c = 'Yes';
        b3.Pricing_Flown_to_SAP__c = True;
        b3.Customer_Code__c = '0033238499';
        b3.Site_Support__c = dummyUser.id;
        insert b3; 
        
        q2.booking__c = b3.id;
        q2.Additional_Car_Park_Applied__c = True;
        Update q2; 
        
        Quotation__c q = new Quotation__c();
        q.Opportunity__c = o.Id;
        q.Project__c = pj.id;
        q.Quote_Status__c = 'Valid';
        q.property__c = sinlgeproperty.id;
        q.Carpet_Area__c = 1100;
        q.Charge_1_Name__c = 'Basic';
        q.Charge_1_Value_Modified__c = 1200;
        q.Charge_2_Name__c = 'Car Parking';
        q.Charge_2_Value_Modified__c = 1200;
        q.Charge_3_Name__c = 'Floor Rise';
        q.Charge_3_Value_Modified__c = 1200;
        q.Charge_4_Name__c = 'PLC';
        q.Charge_4_Value_Modified__c = 1200;
        q.Charge_5_Name__c = 'Other';
        q.Charge_5_Value_Modified__c = 1200;
        insert q;
        
        Booking__c b = new booking__c();
        b.Opportunity__c = o.Id;
        b.Booking_Date__c = System.today();
        b.Status__c = 'UnProcessed';
        b.Doc_Verification_Status__c = 'Level 2 Accepted';
        b.Quotation__c = q.Id;
        b.Default_Address_of__c = '1st Applicant';
        b.Future_Correspondence_Contact_Name__c = 'Test Stetig';      //Future Correspondence Details
        b.Future_Correspondence_Contact_Email__c = 'test123@gmail.com';
        b.Future_Correspondence_Contact__c = '1st Applicant';
        b.Future_Correspondence_Contact_Relation__c = '1st Applicant';
        b.Future_Correspondence_Contact_Phone__c = '7658493820';
        b.Site__c = st.Id;  
        b.Project__c = pj.Id;
        b.Property_Name__c = 'OEY-A-5701';
        b.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b.Property__c = sinlgeproperty.Id;
        b.Tower__c = sinlgeTower.id;
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        b.Pricing_Flown_to_SAP__c = True;
        b.Customer_Code__c = '0033238490';
        b.Site_Support__c = dummyUser.id;
        insert b; 
        
        q.booking__c = b.id;
        //q.Additional_Car_Park_Applied__c = True;
        Update q; 
        
        
        for(Integer i = 0; i <= 5; i++){
        Applicant__c ap3 = new Applicant__c();
        if(i == 1)
        ap3.Applicant_Number__c = 'Primary Applicant';
        if(i == 2)
        ap3.Applicant_Number__c = 'Second Applicant';
        if(i == 3)
        ap3.Applicant_Number__c = 'Third Applicant';
        if(i == 4)
        ap3.Applicant_Number__c = 'Fourth Applicant';
        if(i == 5)
        ap3.Applicant_Number__c = 'Fifth Applicant';
        ap3.Salutation__c = 'Mr.';
        ap3.Name = 'Bhagyashree Stetig';
        ap3.Mobile_Number__c = '7796377643';
        ap3.Alternate_Mobile_No__c = '8956789234';
        ap3.Email_Address__c = 'abc@gmail.com';
        ap3.Alternate_Email_Id__c = 'test123@gmail.com';
        ap3.Occupation__c = 'Business';
        ap3.Designation__c = 'Test 1';
        ap3.Nationality__c = 'Indian';
        ap3.PancardNo__c  = 'ABCDE1234K';
        ap3.Subtype_Of_Applicant__c = 'Indian National';
        ap3.Mailing_Address_same_as_PermanentAddress__c = false;
        ap3.Preferred_address_for_all_correspondence__c = 'Permanent';
        ap3.House_No__c = 'HN1';
        ap3.City__c = 'Pune';
        ap3.Street_1__c = 'ST1';
        ap3.State__c = 'Maharashtra';
        ap3.Street_2__c = 'ST2';
        ap3.Country__c = 'India';
        ap3.Street_3__c = 'ST3';
        ap3.Pincode__c = '414002';
        ap3.Locality__c = 'Lo';
        ap3.Mailing_House_No__c = 'HN1';
        ap3.Mailing_Street_1__c = 'ST1';
        ap3.Mailing_Street_2__c = 'ST2';
        ap3.Mailing_Street_3__c = 'ST3';
        ap3.Mailing_Locality__c = 'Lo';
        ap3.Mailing_City__c = 'Pune';
        ap3.Mailing_State__c = 'Maharashtra';
        ap3.Mailing_Country__c = 'India';
        ap3.Mailing_Pincode__c = '411002';
        ap3.Opportunity__c = o.Id;
        ap3.Booking__c = b3.Id;
        insert ap3;
        }
        Test.StartTest();
        Rest_SAP_Customer_Specific_Pricing RSP = new Rest_SAP_Customer_Specific_Pricing();
        RSP.sendSpecificPricingDetailsZPRO(q2.id,b3.Customer_Code__c);
        
        Rest_SAP_Customer_Specific_Pricing RSP1 = new Rest_SAP_Customer_Specific_Pricing();
        RSP1.sendSpecificPricingDetailsZPRO(q.id,b.Customer_Code__c);
        Test.stopTest();  
    }
    
}
@isTest
public class TestDemandAgeingEmailBatch{
    
    static testMethod void DemandAgeingEmail(){
    
        Map<String,Id> dataMap = TestDataFactory1.createData();
        
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id);
        insert opp;
        
        BillingPlanLineItemGroupingController.createBillingLineItemsFuture(dataMap.get('BILLING_PLAN'));
        Id unitId = dataMap.get('PROPERTY');
        Id projectId = dataMap.get('PROJECT');
        Id proprtyId = dataMap.get('PROPERTY_TYPE');
        Id towerId = dataMap.get('TOWER');
        Id planId = dataMap.get('BILLING_PLAN');
        
        PageReference pageRef = Page.Quotation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('unitId', unitId);
        pageRef.getParameters().put('oppId', opp.Id);
        
        Property__c property = Quotation.getProperty(unitId);
        Opportunity op = Quotation.getOpportunity(opp.Id);
        
        List<QuotationManagmentServices.AdditionalChargesWrapper> additionalCharges = Quotation.getAdditionChargsList(proprtyId);
        string othercharges_serialize = JSON.serialize(additionalCharges);
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, false, 0);
        
        string sap_serialize = JSON.serialize(SAPChrges);

        List<QuotationManagmentServices.PlanDetailsWrapper> planDetails = Quotation.getPlanDetail(sap_serialize,planId,unitId);
        string planDetails_serialize = JSON.serialize(planDetails);
        
        string discountList_serialize = '[]'; // = JSON.serialize(discountList);
        string carParKList = '[]'; //= '["TANDEM",1,100000]'; 
        string fieldSet = '[{"label":"unitId","value":"' + unitId +'"},{"label":"editschedule","value":false},{"label":"oppId","value":"' + opp.id +'"},{"label":"additionalComments","value":""},{"label":"selectedPlan","value":"' + planId + '"},{"label":"changeInSource","value":false},{"label":"revisedBookingSource","value":null},{"label":"referredBy","value":null},{"label":"referProject","value":null},{"label":"referTower","value":null},{"label":"referFlat","value":null},{"label":"referEmpCode","value":null}]';
        string qId = Quotation.saveQuotation(sap_serialize, othercharges_serialize, discountList_serialize, planDetails_serialize, carParKList, fieldSet);
        
        string st1 = QuotationManagmentServices.INFormat(10);
        
        SAP_Credentials_Master__c SCM = New SAP_Credentials_Master__c();
        SCM.Name = 'Customer Specific Billing plan';
        SCM.URL__c = 'http://110.173.186.14:8003/zsfdcapi/billingplan_change?sap-client=100';
        SCM.User_ID__c = 'Stetig';
        SCM.Password__c = 'Stetig#2021';
        Insert SCM;
        
        Booking__c b = new Booking__C();
        b.Opportunity__c = opp.id;
        b.Booking_Date__c = system.today();
        b.Acceptance_Form_Template__c = 'Acceptance_Form';
        b.Status__c = 'Booking In Process';
        b.Future_Correspondence_Contact_Email__c = 'Email@gmail.com';
        //b.Booking_Through__c = 'Direct';
        b.Quotation__c = qId;
        b.Default_Address_of__c = '1st Applicant';
        b.Project__c = projectId;
        b.Tower__c = towerId;
        b.Property__c = unitId;
        b.Sales_Document_SAP__c = '0671900355';
        insert b;
        
        Test.startTest();
        
        DemandAgeingEmailBatch dae = new DemandAgeingEmailBatch();
        database.executebatch(dae,100);
        List<Booking__c> book1 = new List<Booking__c>();
        book1.add(b);
        Database.QueryLocator ql1 = dae.start(null);
        dae.execute(null,book1);
        dae.Finish(null);
        
        DemandAgeingSchedule das = new DemandAgeingSchedule();
        das.execute(null);
        Test.stopTest();
    }
    
    static testmethod void bookingtest(){
        Account acc = new Account();
        acc.LastName = 'test name';
        acc.PersonEmail = 'test@stetig.in';
        acc.PersonMobilePhone = '9889009775';
        insert acc;
        
        Opportunity o = new Opportunity();
        o.Name = 'Capt Spiderman Test';
        o.Enquiry_Type__c = 'Partner';
        o.AccountId = acc.Id;
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
        o.Enquiry_Type__c = '';
        insert o;
        
        Quotation__c q = new Quotation__c();
        q.Opportunity__c = o.Id;
        q.Quote_Status__c = 'Valid';
        insert q;
        
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
        prop.Floor_No__c = 11;
        insert prop;
        
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'test2';
        u.Email = 'test@test.com';
        u.Username = 'test@tstt.com';
        u.MobilePhone = '1234567890';
        u.CommunityNickname = 'testshvbsihv';
        Profile p = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator'];
        u.ProfileId = p.id;
        u.LastName = 'test';
        u.Alias = 'tst';
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = True;
        insert u;
        
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
        b.RM_User__c = u.Id;
        b.C_o_Name_Billing_Address__c = 'Test';
        b.Billing_Str_Suppl3__c = 'test';
        b.Billing_Str_Suppl2__c = 'test';
        b.Billing_Location__c = 'test';
        b.Billing_City__c = 'test';
        b.Billing_Post_Code__c = 'test';
        b.Billing_Region__c = 'test';
        b.Billing_Country__c = 'test';
        b.Billing_Street__c = 'test';
        b.Project__c = prj.Id;
       // b.Property_Name__c = 'OEY-A-5701';
       // b.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b.Property__c = prop.Id;
        b.Largest_Bucket__c = 'Ageing 4-22 Days';
        b.Ageing_4_22_Days_Reminder_Sent__c = false;
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        insert b;
        List<Booking__c> book1 = new List<Booking__c>();
        book1.add(b);
        
        DemandAgeingEmailBatchHelper.creatCase(book1);
    }
    
    static testmethod void bookingtest1(){
        Account acc = new Account();
        acc.LastName = 'test name';
        acc.PersonEmail = 'test@stetig.in';
        acc.PersonMobilePhone = '9889009775';
        insert acc;
        
        Opportunity o = new Opportunity();
        o.Name = 'Capt Spiderman Test';
        o.Enquiry_Type__c = 'Partner';
        o.AccountId = acc.Id;
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
        o.Enquiry_Type__c = '';
        insert o;
        
        Quotation__c q = new Quotation__c();
        q.Opportunity__c = o.Id;
        q.Quote_Status__c = 'Valid';
        insert q;
        
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
        prop.Floor_No__c = 11;
        insert prop;
        
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'test2';
        u.Email = 'test@test.com';
        u.Username = 'test@tstt.com';
        u.MobilePhone = '1234567890';
        u.CommunityNickname = 'testshvbsihv';
        Profile p = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator'];
        u.ProfileId = p.id;
        u.LastName = 'test';
        u.Alias = 'tst';
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = True;
        insert u;
        
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
        b.C_o_Name_Billing_Address__c = 'Test';
        b.Billing_Str_Suppl3__c = 'test';
        b.Billing_Str_Suppl2__c = 'test';
        b.Billing_Location__c = 'test';
        b.Billing_City__c = 'test';
        b.Billing_Post_Code__c = 'test';
        b.Billing_Region__c = 'test';
        b.Billing_Country__c = 'test';
        b.Billing_Street__c = 'test';
        b.Project__c = prj.Id;
       // b.Property_Name__c = 'OEY-A-5701';
       // b.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b.Property__c = prop.Id;
        b.Largest_Bucket__c = 'Ageing 23-52 Days';
        b.Ageing_23_52_Days_Reminder_Sent__c = false;
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        b.RM_User__c = u.Id;
        insert b;
        List<Booking__c> book1 = new List<Booking__c>();
        book1.add(b);
        
        DemandAgeingEmailBatchHelper.creatCase(book1);
    }
    
    static testmethod void bookingtest2(){
        Account acc = new Account();
        acc.LastName = 'test name';
        acc.PersonEmail = 'test@stetig.in';
        acc.PersonMobilePhone = '9889009775';
        insert acc;
        
        Opportunity o = new Opportunity();
        o.Name = 'Capt Spiderman Test';
        o.Enquiry_Type__c = 'Partner';
        o.AccountId = acc.Id;
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
        o.Enquiry_Type__c = '';
        insert o;
        
        Quotation__c q = new Quotation__c();
        q.Opportunity__c = o.Id;
        q.Quote_Status__c = 'Valid';
        insert q;
        
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
        prop.Floor_No__c = 11;
        insert prop;
        
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'test2';
        u.Email = 'test@test.com';
        u.Username = 'test@tstt.com';
        u.MobilePhone = '1234567890';
        u.CommunityNickname = 'testshvbsihv';
        Profile p = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator'];
        u.ProfileId = p.id;
        u.LastName = 'test';
        u.Alias = 'tst';
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = True;
        insert u;
        
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
        b.C_o_Name_Billing_Address__c = 'Test';
        b.Billing_Str_Suppl3__c = 'test';
        b.Billing_Str_Suppl2__c = 'test';
        b.Billing_Location__c = 'test';
        b.Billing_City__c = 'test';
        b.Billing_Post_Code__c = 'test';
        b.Billing_Region__c = 'test';
        b.Billing_Country__c = 'test';
        b.Billing_Street__c = 'test';
        b.Project__c = prj.Id;
       // b.Property_Name__c = 'OEY-A-5701';
       // b.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b.Property__c = prop.Id;
        b.Largest_Bucket__c = 'Ageing 53-82 Days';
        b.Ageing_53_82_Days_Reminder_Sent__c = false;
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        b.RM_User__c = u.Id;
        insert b;
        List<Booking__c> book1 = new List<Booking__c>();
        book1.add(b);
        
        DemandAgeingEmailBatchHelper.creatCase(book1);
    }
    
    static testmethod void bookingtest3(){
        Account acc = new Account();
        acc.LastName = 'test name';
        acc.PersonEmail = 'test@stetig.in';
        acc.PersonMobilePhone = '9889009775';
        insert acc;
        
        Opportunity o = new Opportunity();
        o.Name = 'Capt Spiderman Test';
        o.Enquiry_Type__c = 'Partner';
        o.AccountId = acc.Id;
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
        o.Enquiry_Type__c = '';
        insert o;
        
        Quotation__c q = new Quotation__c();
        q.Opportunity__c = o.Id;
        q.Quote_Status__c = 'Valid';
        insert q;
        
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
        prop.Floor_No__c = 11;
        insert prop;
        
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'test2';
        u.Email = 'test@test.com';
        u.Username = 'test@tstt.com';
        u.MobilePhone = '1234567890';
        u.CommunityNickname = 'testshvbsihv';
        Profile p = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator'];
        u.ProfileId = p.id;
        u.LastName = 'test';
        u.Alias = 'tst';
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = True;
        insert u;
        
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
        b.C_o_Name_Billing_Address__c = 'Test';
        b.Billing_Str_Suppl3__c = 'test';
        b.Billing_Str_Suppl2__c = 'test';
        b.Billing_Location__c = 'test';
        b.Billing_City__c = 'test';
        b.Billing_Post_Code__c = 'test';
        b.Billing_Region__c = 'test';
        b.Billing_Country__c = 'test';
        b.Billing_Street__c = 'test';
        b.Project__c = prj.Id;
       // b.Property_Name__c = 'OEY-A-5701';
       // b.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b.Property__c = prop.Id;
        b.Largest_Bucket__c = 'Ageing 83-112 Days';
        b.Ageing_83_112_Days_Reminder_Sent__c = false;
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        b.RM_User__c = u.Id;
        insert b;
        List<Booking__c> book1 = new List<Booking__c>();
        book1.add(b);
        
        DemandAgeingEmailBatchHelper.creatCase(book1);
    }
    
    static testmethod void bookingtest4(){
        Account acc = new Account();
        acc.LastName = 'test name';
        acc.PersonEmail = 'test@stetig.in';
        acc.PersonMobilePhone = '9889009775';
        insert acc;
        
        Opportunity o = new Opportunity();
        o.Name = 'Capt Spiderman Test';
        o.Enquiry_Type__c = 'Partner';
        o.AccountId = acc.Id;
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
        o.Enquiry_Type__c = '';
        insert o;
        
        Quotation__c q = new Quotation__c();
        q.Opportunity__c = o.Id;
        q.Quote_Status__c = 'Valid';
        insert q;
        
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
        prop.Floor_No__c = 11;
        insert prop;
        
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'test2';
        u.Email = 'test@test.com';
        u.Username = 'test@tstt.com';
        u.MobilePhone = '1234567890';
        u.CommunityNickname = 'testshvbsihv';
        Profile p = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator'];
        u.ProfileId = p.id;
        u.LastName = 'test';
        u.Alias = 'tst';
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = True;
        insert u;
        
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
        b.C_o_Name_Billing_Address__c = 'Test';
        b.Billing_Str_Suppl3__c = 'test';
        b.Billing_Str_Suppl2__c = 'test';
        b.Billing_Location__c = 'test';
        b.Billing_City__c = 'test';
        b.Billing_Post_Code__c = 'test';
        b.Billing_Region__c = 'test';
        b.Billing_Country__c = 'test';
        b.Billing_Street__c = 'test';
        b.Project__c = prj.Id;
       // b.Property_Name__c = 'OEY-A-5701';
       // b.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b.Property__c = prop.Id;
        b.Largest_Bucket__c = 'Ageing >112 Days';
        b.Ageing_112_Days_Reminder__c = false;
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.L5_Case_Creation_Date__c = system.today()-29;
        b.Loan_Required__c = 'Yes';
        b.RM_User__c = u.Id;
        insert b;
        List<Booking__c> book1 = new List<Booking__c>();
        book1.add(b);
        
        DemandAgeingEmailBatchHelper.creatCase(book1);
    }
}
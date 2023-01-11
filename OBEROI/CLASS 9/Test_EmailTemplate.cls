@isTest
public class Test_EmailTemplate {
	@isTest
    public static void test(){
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
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        insert b;
        
        Applicant__c ap = new Applicant__c();
        ap.Name = 'Test';
        ap.Applicant_Number__c = 'Second Applicant';
        ap.Salutation__c = 'Mr.';
        ap.Booking__c = b.Id;
        insert ap;
        
        Applicant__c ap1 = new Applicant__c();
        ap1.Name = 'Test';
        ap1.Applicant_Number__c = 'Primary Applicant';
        ap1.Salutation__c = 'Mr.';
        ap1.Booking__c = b.Id;
        insert ap1;
        
        Applicant__c ap2 = new Applicant__c();
        ap2.Name = 'Test';
        ap2.Applicant_Number__c = 'Third Applicant';
        ap2.Salutation__c = 'Mr.';
        ap2.Booking__c = b.Id;
        insert ap2;
        
        Applicant__c ap3 = new Applicant__c();
        ap3.Name = 'Test';
        ap3.Applicant_Number__c = 'Fourth Applicant';
        ap3.Salutation__c = 'Mr.';
        ap3.Booking__c = b.Id;
        insert ap3;
        
        Applicant__c ap4 = new Applicant__c();
        ap4.Name = 'Test';
        ap4.Applicant_Number__c = 'Fifth Applicant';
        ap4.Salutation__c = 'Mr.';
        ap4.Booking__c = b.Id;
        insert ap4;
        
        SAP_Demands_and_Debits__c sd = new SAP_Demands_and_Debits__c();
        sd.Ageing_0_3_Days__c = 1000000000;
        sd.Booking__c = b.Id;
        sd.Is_canceled__c = false;
        insert sd;
        
        Demand_Reminder_Cont drc = new Demand_Reminder_Cont();
        drc.BookingId = b.Id;
        
        BankDetails bd = new BankDetails();
        bd.bId = b.Id;
        
        SummaryOfAmounts soa = new SummaryOfAmounts();
        soa.bId = b.Id;
    }
    
    @isTest
    public static void test1(){
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
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        insert b;
        
        Applicant__c ap = new Applicant__c();
        ap.Name = 'Test';
        ap.Applicant_Number__c = 'Second Applicant';
        ap.Salutation__c = 'Mr.';
        ap.Booking__c = b.Id;
        insert ap;
        
        Applicant__c ap1 = new Applicant__c();
        ap1.Name = 'Test';
        ap1.Applicant_Number__c = 'Primary Applicant';
        ap1.Salutation__c = 'Mr.';
        ap1.Booking__c = b.Id;
        insert ap1;
        
        Applicant__c ap2 = new Applicant__c();
        ap2.Name = 'Test';
        ap2.Applicant_Number__c = 'Third Applicant';
        ap2.Salutation__c = 'Mr.';
        ap2.Booking__c = b.Id;
        insert ap2;
        
        Applicant__c ap3 = new Applicant__c();
        ap3.Name = 'Test';
        ap3.Applicant_Number__c = 'Fourth Applicant';
        ap3.Salutation__c = 'Mr.';
        ap3.Booking__c = b.Id;
        insert ap3;
        
        Applicant__c ap4 = new Applicant__c();
        ap4.Name = 'Test';
        ap4.Applicant_Number__c = 'Fifth Applicant';
        ap4.Salutation__c = 'Mr.';
        ap4.Booking__c = b.Id;
        insert ap4;
        
        SAP_Demands_and_Debits__c sd1 = new SAP_Demands_and_Debits__c();
        sd1.Ageing_0_3_Days__c = 100000000;
        sd1.Booking__c = b.Id;
        sd1.Is_canceled__c = false;
        insert sd1;
        
        Demand_Reminder_Cont drc = new Demand_Reminder_Cont();
        drc.BookingId = b.Id;
        
        BankDetails bd = new BankDetails();
        bd.bId = b.Id;
        
        SummaryOfAmounts soa = new SummaryOfAmounts();
        soa.bId = b.Id;
    }
    
    @isTest
    public static void test2(){
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
        prop.Floor_No__c = 21;
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
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        insert b;
        
        Applicant__c ap = new Applicant__c();
        ap.Name = 'Test';
        ap.Applicant_Number__c = 'Second Applicant';
        ap.Salutation__c = 'Mr.';
        ap.Booking__c = b.Id;
        insert ap;
        
        Applicant__c ap1 = new Applicant__c();
        ap1.Name = 'Test';
        ap1.Applicant_Number__c = 'Primary Applicant';
        ap1.Salutation__c = 'Mr.';
        ap1.Booking__c = b.Id;
        insert ap1;
        
        Applicant__c ap2 = new Applicant__c();
        ap2.Name = 'Test';
        ap2.Applicant_Number__c = 'Third Applicant';
        ap2.Salutation__c = 'Mr.';
        ap2.Booking__c = b.Id;
        insert ap2;
        
        Applicant__c ap3 = new Applicant__c();
        ap3.Name = 'Test';
        ap3.Applicant_Number__c = 'Fourth Applicant';
        ap3.Salutation__c = 'Mr.';
        ap3.Booking__c = b.Id;
        insert ap3;
        
        Applicant__c ap4 = new Applicant__c();
        ap4.Name = 'Test';
        ap4.Applicant_Number__c = 'Fifth Applicant';
        ap4.Salutation__c = 'Mr.';
        ap4.Booking__c = b.Id;
        insert ap4;
        
        SAP_Demands_and_Debits__c sd1 = new SAP_Demands_and_Debits__c();
        sd1.Ageing_0_3_Days__c = 10000000;
        sd1.Booking__c = b.Id;
        sd1.Is_canceled__c = false;
        insert sd1;
        
        Demand_Reminder_Cont drc = new Demand_Reminder_Cont();
        drc.BookingId = b.Id;
        
        BankDetails bd = new BankDetails();
        bd.bId = b.Id;
        
        SummaryOfAmounts soa = new SummaryOfAmounts();
        soa.bId = b.Id;
    }
    
    @isTest
    public static void test3(){
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
        prop.Floor_No__c = 32;
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
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        insert b;
        
        Applicant__c ap = new Applicant__c();
        ap.Name = 'Test';
        ap.Applicant_Number__c = 'Second Applicant';
        ap.Salutation__c = 'Mr.';
        ap.Booking__c = b.Id;
        insert ap;
        
        Applicant__c ap1 = new Applicant__c();
        ap1.Name = 'Test';
        ap1.Applicant_Number__c = 'Primary Applicant';
        ap1.Salutation__c = 'Mr.';
        ap1.Booking__c = b.Id;
        insert ap1;
        
        Applicant__c ap2 = new Applicant__c();
        ap2.Name = 'Test';
        ap2.Applicant_Number__c = 'Third Applicant';
        ap2.Salutation__c = 'Mr.';
        ap2.Booking__c = b.Id;
        insert ap2;
        
        Applicant__c ap3 = new Applicant__c();
        ap3.Name = 'Test';
        ap3.Applicant_Number__c = 'Fourth Applicant';
        ap3.Salutation__c = 'Mr.';
        ap3.Booking__c = b.Id;
        insert ap3;
        
        Applicant__c ap4 = new Applicant__c();
        ap4.Name = 'Test';
        ap4.Applicant_Number__c = 'Fifth Applicant';
        ap4.Salutation__c = 'Mr.';
        ap4.Booking__c = b.Id;
        insert ap4;
        
        SAP_Demands_and_Debits__c sd1 = new SAP_Demands_and_Debits__c();
        sd1.Ageing_0_3_Days__c = 10000000;
        sd1.Booking__c = b.Id;
        sd1.Is_canceled__c = false;
        insert sd1;
        
        Demand_Reminder_Cont drc = new Demand_Reminder_Cont();
        drc.BookingId = b.Id;
        
        BankDetails bd = new BankDetails();
        bd.bId = b.Id;
        
        SummaryOfAmounts soa = new SummaryOfAmounts();
        soa.bId = b.Id;
    }
    
    @isTest
    public static void test4(){
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
        prop.Floor_No__c = 33;
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
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        insert b;
        
        Applicant__c ap = new Applicant__c();
        ap.Name = 'Test';
        ap.Applicant_Number__c = 'Second Applicant';
        ap.Salutation__c = 'Mr.';
        ap.Booking__c = b.Id;
        insert ap;
        
        Applicant__c ap1 = new Applicant__c();
        ap1.Name = 'Test';
        ap1.Applicant_Number__c = 'Primary Applicant';
        ap1.Salutation__c = 'Mr.';
        ap1.Booking__c = b.Id;
        insert ap1;
        
        Applicant__c ap2 = new Applicant__c();
        ap2.Name = 'Test';
        ap2.Applicant_Number__c = 'Third Applicant';
        ap2.Salutation__c = 'Mr.';
        ap2.Booking__c = b.Id;
        insert ap2;
        
        Applicant__c ap3 = new Applicant__c();
        ap3.Name = 'Test';
        ap3.Applicant_Number__c = 'Fourth Applicant';
        ap3.Salutation__c = 'Mr.';
        ap3.Booking__c = b.Id;
        insert ap3;
        
        Applicant__c ap4 = new Applicant__c();
        ap4.Name = 'Test';
        ap4.Applicant_Number__c = 'Fifth Applicant';
        ap4.Salutation__c = 'Mr.';
        ap4.Booking__c = b.Id;
        insert ap4;
        
        SAP_Demands_and_Debits__c sd1 = new SAP_Demands_and_Debits__c();
        sd1.Ageing_0_3_Days__c = 100000;
        sd1.Booking__c = b.Id;
        sd1.Is_canceled__c = false;
        insert sd1;
        
        Demand_Reminder_Cont drc = new Demand_Reminder_Cont();
        drc.BookingId = b.Id;
        
        BankDetails bd = new BankDetails();
        bd.bId = b.Id;
        
        SummaryOfAmounts soa = new SummaryOfAmounts();
        soa.bId = b.Id;
    }
    
    @isTest
    public static void test5(){
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
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        insert b;
        
        Applicant__c ap = new Applicant__c();
        ap.Name = 'Test';
        ap.Applicant_Number__c = 'Second Applicant';
        ap.Salutation__c = 'Mr.';
        ap.Booking__c = b.Id;
        insert ap;
        
        Applicant__c ap1 = new Applicant__c();
        ap1.Name = 'Test';
        ap1.Applicant_Number__c = 'Primary Applicant';
        ap1.Salutation__c = 'Mr.';
        ap1.Booking__c = b.Id;
        insert ap1;
        
        Applicant__c ap2 = new Applicant__c();
        ap2.Name = 'Test';
        ap2.Applicant_Number__c = 'Third Applicant';
        ap2.Salutation__c = 'Mr.';
        ap2.Booking__c = b.Id;
        insert ap2;
        
        Applicant__c ap3 = new Applicant__c();
        ap3.Name = 'Test';
        ap3.Applicant_Number__c = 'Fourth Applicant';
        ap3.Salutation__c = 'Mr.';
        ap3.Booking__c = b.Id;
        insert ap3;
        
        Applicant__c ap4 = new Applicant__c();
        ap4.Name = 'Test';
        ap4.Applicant_Number__c = 'Fifth Applicant';
        ap4.Salutation__c = 'Mr.';
        ap4.Booking__c = b.Id;
        insert ap4;
        
        SAP_Demands_and_Debits__c sd1 = new SAP_Demands_and_Debits__c();
        sd1.Ageing_0_3_Days__c = 10000;
        sd1.Booking__c = b.Id;
        sd1.Is_canceled__c = false;
        insert sd1;
        
        Demand_Reminder_Cont drc = new Demand_Reminder_Cont();
        drc.BookingId = b.Id;
        
        BankDetails bd = new BankDetails();
        bd.bId = b.Id;
        
        SummaryOfAmounts soa = new SummaryOfAmounts();
        soa.bId = b.Id;
    }
    
    @isTest
    public static void test6(){
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
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        insert b;
        
        Applicant__c ap = new Applicant__c();
        ap.Name = 'Test';
        ap.Applicant_Number__c = 'Second Applicant';
        ap.Salutation__c = 'Mr.';
        ap.Booking__c = b.Id;
        insert ap;
        
        Applicant__c ap1 = new Applicant__c();
        ap1.Name = 'Test';
        ap1.Applicant_Number__c = 'Primary Applicant';
        ap1.Salutation__c = 'Mr.';
        ap1.Booking__c = b.Id;
        insert ap1;
        
        Applicant__c ap2 = new Applicant__c();
        ap2.Name = 'Test';
        ap2.Applicant_Number__c = 'Third Applicant';
        ap2.Salutation__c = 'Mr.';
        ap2.Booking__c = b.Id;
        insert ap2;
        
        Applicant__c ap3 = new Applicant__c();
        ap3.Name = 'Test';
        ap3.Applicant_Number__c = 'Fourth Applicant';
        ap3.Salutation__c = 'Mr.';
        ap3.Booking__c = b.Id;
        insert ap3;
        
        Applicant__c ap4 = new Applicant__c();
        ap4.Name = 'Test';
        ap4.Applicant_Number__c = 'Fifth Applicant';
        ap4.Salutation__c = 'Mr.';
        ap4.Booking__c = b.Id;
        insert ap4;
        
        SAP_Demands_and_Debits__c sd1 = new SAP_Demands_and_Debits__c();
        sd1.Ageing_0_3_Days__c = 1000000;
        sd1.Booking__c = b.Id;
        sd1.Is_canceled__c = false;
        insert sd1;
        
        Demand_Reminder_Cont drc = new Demand_Reminder_Cont();
        drc.BookingId = b.Id;
        
        BankDetails bd = new BankDetails();
        bd.bId = b.Id;
        
        SummaryOfAmounts soa = new SummaryOfAmounts();
        soa.bId = b.Id;
    }
}
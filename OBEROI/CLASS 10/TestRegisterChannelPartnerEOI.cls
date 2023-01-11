@isTest
public class TestRegisterChannelPartnerEOI {
    private class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = 'your Json Response';
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    @isTest
    public static void RegisterEOI(){
        Site__c s = new Site__c();
        s.Name = 'test';
        s.Active__c = true;
        insert s;
        
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
        
        Account ac = new Account(Name = 'Test Bhagyashri',Company__c = 'Stetig');
        insert ac;
        
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
        o.StageName = 'New';
        o.CloseDate = System.today();
        insert o;
        
        Project__c pr = new Project__c();
        pr.Active__c = true;
        pr.Name = 'test';
        pr.Site__c = s.Id;
        pr.CFO__c = u.Id;
        pr.Front_Desk_User__c = u.Id;
        pr.Marcom_Head__c = u.Id;
        pr.Marcom_Manager__c = u.Id;
        pr.MD__c = u.Id;
        pr.Sales_Head__c = u.Id;
        pr.Site_Head__c = u.Id;
        pr.Plant__c = '4788';
        pr.Company_name__c = '4788';
        pr.Amount__c = 1000000;
        pr.Payment_Options__c = 'Payment not Required';
        insert pr;
        
        EOI__c rp = New EOI__c();
        rp.Nationality__c = 'Pakistan';
        rp.Pincode1__c = '123456';
        rp.Company_Pincode__c = '123456';
        rp.Country_Code_Mobile_1__c = '+91';
        rp.Email__c = 'test@test.com';
        insert rp;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rp);
        registerPageController RpController = new registerPageController(sc);      
        PageReference pageRef = Page.RegisterPage;
        pageRef.getParameters().put('id', String.valueOf(rp.Id));
        Test.setCurrentPage(pageRef);
        RpController.getdynamiclist();
        RpController.getAddressofcorrespondencelist();
        RpController.getBudgetlist();
        RpController.getCarpetArealist();
        RpController.getContactPersonlist();
        RpController.getCustomerCategorylist();
        RpController.getHowdidyouhearaboutuslist();
        RpController.getHowdowecontactyoulist();
        RpController.getOccupationlist();
        RpController.getRequirementslist();
        RpController.getResidenceStatuslist();
        RpController.getSourceofEOIlist();
        RpController.add2();
        RpController.add3();
        RpController.add4();
        RpController.add5();
        RpController.rem2();
        RpController.rem3();
        RpController.rem4();
        RpController.rem5();
        RpController.seconds = 2;
        RpController.e.Opportunity__c = o.id;
        RpController.e.Nationality__c = 'Pakistan';
        RpController.e.Pincode1__c = '123456';
        RpController.e.Company_Pincode__c = '123456';
        RpController.e.Country_Code_Mobile_1__c = '+91';
        RpController.e.Email__c = 'test@test.com';
        RpController.phone = '1234567890';
        RpController.phone2 = '1234567890';
        RpController.projs = pr.Id;
        RpController.e.Id = rp.id;
        RpController.pincode1 = '123456';
        RpController.telres = '123456';
        RpController.teloff = '6789088';
        RpController.contpertel = '34567';
        RpController.e.Street_1__c = 'test';
        RpController.e.City__c = 'test';
        RpController.e.Pincode1__c = '123456';
        RpController.e.Company_Pincode__c = '123455';
        RpController.occup = 'Business';
        RpController.cpsa1 = 'Yes';
        RpController.e.Contact_Person_Name__c = 'test';
        RpController.e.Contact_Person_Relation_Designation__c = 'test';
        RpController.e.Country_Code_Contact_Person_Mobile__c = '+91';
        RpController.contpermob = '1234567890';
        RpController.custCat = 'Investor';
        RpController.hdwcy1 = 'Mobile';   
        RpController.aoc1 = 'Office Address';
        RpController.hdyhau1 = 'Hoardings';
        RpController.budget1 = '1.5 cr - 2.5 cr';
        RpController.req = 'Duplex';
        RpController.ca1 = 'Below 800';
        RpController.sob1 = 'Direct';
        RpController.sendOTP();
        RpController.ResendOTP();
        RpController.validateOTP();
        RpController.callMethod();
        RpController.save();
        List<String> rpl=registerPageController.getpincodeDetails('123456');
        Test.setMock(HttpCalloutMock.class, new RestMock());
        RpController.pay();
        RpController.thank(); 
        
        
        Payment__c pt = new Payment__c();
        pt.EOI__c = rp.Id;
        pt.Amount__c = 100;
        insert pt; 
        
        ApexPages.currentPage().getParameters().put('paymentSubInstType', 'Phicom Test bank');
        ApexPages.currentPage().getParameters().put('paymentMode', 'NB');
        ApexPages.currentPage().getParameters().put('amount', '100000.00');
        ApexPages.currentPage().getParameters().put('responseCode', '0000');
        ApexPages.currentPage().getParameters().put('respDescription', 'Transaction successful');
        ApexPages.currentPage().getParameters().put('merchantId', 'T_99928');
        ApexPages.currentPage().getParameters().put('merchantTxnNo', 'a1tp0000002yE2CAAU');
        ApexPages.currentPage().getParameters().put('txnID', 'T002487866686');
        ApexPages.currentPage().getParameters().put('paymentDateTime', '20210820160113');
        ApexPages.currentPage().getParameters().put('paymentID', '98358231657');
        ApexPages.currentPage().getParameters().put('secureHash', 'a5d3fa76a3d4a9e79b61f249db7d50b480ed6aed7ee68ce610ecafe713836e54');
        Payment_Response_Controller prc = new Payment_Response_Controller();
        prc.insertPayment();
        
        ApexPages.currentPage().getParameters().put('paymentSubInstType', 'Phicom Test bank');
        ApexPages.currentPage().getParameters().put('paymentMode', 'NB');
        ApexPages.currentPage().getParameters().put('amount', '100000.00');
        ApexPages.currentPage().getParameters().put('responseCode', '0000');
        ApexPages.currentPage().getParameters().put('respDescription', 'Transaction rejected');
        ApexPages.currentPage().getParameters().put('merchantId', 'T_99928');
        ApexPages.currentPage().getParameters().put('merchantTxnNo', 'a1tp0000002yE2CAAU');
        ApexPages.currentPage().getParameters().put('txnID', 'T002487866686');
        ApexPages.currentPage().getParameters().put('paymentDateTime', '20210820160113');
        ApexPages.currentPage().getParameters().put('paymentID', '98358231657');
        ApexPages.currentPage().getParameters().put('secureHash', 'a5d3fa76a3d4a9e79b61f249db7d50b480ed6aed7ee68ce610ecafe713836e54');
        Payment_Response_Controller prc1 = new Payment_Response_Controller();
        prc1.insertPayment();
    }
    
    @isTest
    public static void ChannelPartnerEOI(){
        Site__c s = new Site__c();
        s.Name = 'test';
        s.Active__c = true;
        insert s;
        
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
        
        Account ac = new Account(Name = 'Test Bhagyashri',Company__c = 'Stetig');
        insert ac;
        
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
        o.StageName = 'New';
        o.CloseDate = System.today();
        insert o;
        
        Project__c pr = new Project__c();
        pr.Active__c = true;
        pr.Name = 'test';
        pr.Site__c = s.Id;
        pr.CFO__c = u.Id;
        pr.Front_Desk_User__c = u.Id;
        pr.Marcom_Head__c = u.Id;
        pr.Marcom_Manager__c = u.Id;
        pr.MD__c = u.Id;
        pr.Sales_Head__c = u.Id;
        pr.Site_Head__c = u.Id;
        pr.Plant__c = '4788';
        pr.Company_name__c = '4788';
        pr.Amount__c = 1000000;
        pr.Payment_Options__c = 'Payment not Required';
        insert pr;
        
        EOI__c cp = New EOI__c();
        cp.Nationality__c = 'Pakistan';
        cp.Pincode1__c = '123456';
        cp.Company_Pincode__c = '123456';
        cp.Country_Code_Mobile_1__c = '+91';
        cp.Email__c = 'test@test.com';
        insert cp;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cp);
        channelPartnerPageController CpController = new channelPartnerPageController(sc);      
        PageReference pageRef = Page.RegisterPage;
        pageRef.getParameters().put('id', String.valueOf(cp.Id));
        Test.setCurrentPage(pageRef);
        CpController.getdynamiclist();
        CpController.getAddressofcorrespondencelist();
        CpController.getBudgetlist();
        CpController.getCarpetArealist();
        CpController.getContactPersonlist();
        CpController.getCustomerCategorylist();
        CpController.getHowdidyouhearaboutuslist();
        CpController.getHowdowecontactyoulist();
        CpController.getOccupationlist();
        CpController.getRequirementslist();
        CpController.getResidenceStatuslist();
        CpController.getSourceofEOIlist();
        CpController.add2();
        CpController.add3();
        CpController.add4();
        CpController.add5();
        CpController.rem2();
        CpController.rem3();
        CpController.rem4();
        CpController.rem5();
        CpController.pincode1 = '123456';
        CpController.parttel = '1234567890';
        CpController.e.Id = cp.id;
        CpController.e.Opportunity__c = o.id;
        CpController.city = 'pune';
        CpController.partmob = '1234567890';
        CpController.e.Property_Consultant_s_Firm_Name__c = 'test';
        CpController.e.Property_Consultant_s_Name__c = 'test';
        CpController.e.RERA_Registration_No__c = '1234567890op';
        CpController.e.Property_Consultant_s_Email__c = 'test@test.com';
        CpController.e.Nationality__c = 'Pakistan';
        CpController.e.Pincode1__c = '123456';
        CpController.e.Company_Pincode__c = '123456';
        CpController.e.Country_Code_Mobile_1__c = '+91';
        CpController.e.Email__c = 'test@test.com';
        CpController.phone = '1234567890';
        CpController.phone2 = '1234567890';
        CpController.projs = pr.Id;
        CpController.telres = '123456';
        CpController.teloff = '6789088';
        CpController.contpertel = '34567';
        CpController.e.Street_1__c = 'test';
        CpController.e.City__c = 'test';
        CpController.e.Pincode1__c = '123456';
        CpController.e.Company_Pincode__c = '123455';
        CpController.occup = 'Business';
        CpController.cpsa1 = 'Yes';
        CpController.e.Salutation_1__c = 'Mr.';
        CpController.e.Applicant_Name_1__c = 'test';
        CpController.e.Contact_Person_Name__c = 'test';
        CpController.e.Contact_Person_Relation_Designation__c = 'test';
        CpController.e.Country_Code_Contact_Person_Mobile__c = '+91';
        CpController.contpermob = '1234567890';
        CpController.custCat = 'Investor';
        CpController.hdwcy1 = 'Mobile';   
        CpController.aoc1 = 'Office Address';
        CpController.hdyhau1 = 'Hoardings';
        CpController.budget1 = '1.5 cr - 2.5 cr';
        CpController.req = 'Duplex';
        CpController.ca1 = 'Below 800';
        CpController.sob1 = 'Direct';
        //CpController.locality = 'Andheri';
        CpController.sendOTP();
        CpController.ResendOTP();
        CpController.validateOTP();
        CpController.callMethod();
        CpController.save();
        List<String> rpl=channelPartnerPageController.getpincodeDetails('123456');
        Test.setMock(HttpCalloutMock.class, new RestMock());
        CpController.pay();
        CpController.thank(); 
        
        Payment__c pt = new Payment__c();
        pt.EOI__c = cp.Id;
        pt.Amount__c = 100;
        insert pt; 
        
        ApexPages.currentPage().getParameters().put('paymentSubInstType', 'Phicom Test bank');
        ApexPages.currentPage().getParameters().put('paymentMode', 'NB');
        ApexPages.currentPage().getParameters().put('amount', '100000.00');
        ApexPages.currentPage().getParameters().put('responseCode', '0000');
        ApexPages.currentPage().getParameters().put('respDescription', 'Transaction successful');
        ApexPages.currentPage().getParameters().put('merchantId', 'T_99928');
        ApexPages.currentPage().getParameters().put('merchantTxnNo', 'a1tp0000002yE2CAAU');
        ApexPages.currentPage().getParameters().put('txnID', 'T002487866686');
        ApexPages.currentPage().getParameters().put('paymentDateTime', '20210820160113');
        ApexPages.currentPage().getParameters().put('paymentID', '98358231657');
        ApexPages.currentPage().getParameters().put('secureHash', 'a5d3fa76a3d4a9e79b61f249db7d50b480ed6aed7ee68ce610ecafe713836e54');
        Payment_Response_Controller prc = new Payment_Response_Controller();
        prc.insertPayment();
        
        ApexPages.currentPage().getParameters().put('paymentSubInstType', 'Phicom Test bank');
        ApexPages.currentPage().getParameters().put('paymentMode', 'NB');
        ApexPages.currentPage().getParameters().put('amount', '100000.00');
        ApexPages.currentPage().getParameters().put('responseCode', '0000');
        ApexPages.currentPage().getParameters().put('respDescription', 'Transaction rejected');
        ApexPages.currentPage().getParameters().put('merchantId', 'T_99928');
        ApexPages.currentPage().getParameters().put('merchantTxnNo', 'a1tp0000002yE2CAAU');
        ApexPages.currentPage().getParameters().put('txnID', 'T002487866686');
        ApexPages.currentPage().getParameters().put('paymentDateTime', '20210820160113');
        ApexPages.currentPage().getParameters().put('paymentID', '98358231657');
        ApexPages.currentPage().getParameters().put('secureHash', 'a5d3fa76a3d4a9e79b61f249db7d50b480ed6aed7ee68ce610ecafe713836e54');
        Payment_Response_Controller prc1 = new Payment_Response_Controller();
        prc1.insertPayment();
    }
}
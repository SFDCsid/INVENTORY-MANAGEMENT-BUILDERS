@isTest
public class TestViewBooking {
    @isTest 
    public static void testBooking(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
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
        
        BillingPlanLineItemGroupingController.createBillingLineItemsFuture(dataMap.get('BILLING_PLAN'));
        Id unitId = dataMap.get('PROPERTY');
        Id projectId = dataMap.get('PROJECT');
        Id site = dataMap.get('SITE');
        Id proprtyId = dataMap.get('PROPERTY_TYPE');
        Id towerId = dataMap.get('TOWER');
        Id planId = dataMap.get('BILLING_PLAN');
        PageReference pageRef = Page.Quotation;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('unitId', unitId);
        pageRef.getParameters().put('oppId', o.Id);
        
        Property__c property = Quotation.getProperty(unitId);
        Opportunity op = Quotation.getOpportunity(o.Id);
        
        List<QuotationManagmentServices.AdditionalChargesWrapper> additionalCharges = Quotation.getAdditionChargsList(proprtyId);
        string othercharges_serialize = JSON.serialize(additionalCharges);
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, false, 0);
        
        string sap_serialize = JSON.serialize(SAPChrges);

        List<QuotationManagmentServices.PlanDetailsWrapper> planDetails = Quotation.getPlanDetail(sap_serialize,planId,unitId);
        string planDetails_serialize = JSON.serialize(planDetails);
        
        string discountList_serialize = '[]'; // = JSON.serialize(discountList);
        string carParKList = '[]'; //= '["TANDEM",1,100000]'; 
        string fieldSet = '[{"label":"unitId","value":"' + unitId +'"},{"label":"editschedule","value":false},{"label":"oppId","value":"' + o.id +'"},{"label":"additionalComments","value":""},{"label":"selectedPlan","value":"' + planId + '"},{"label":"changeInSource","value":false},{"label":"revisedBookingSource","value":null},{"label":"referredBy","value":null},{"label":"referProject","value":null},{"label":"referTower","value":null},{"label":"referFlat","value":null},{"label":"referEmpCode","value":null}]';
        string qId = Quotation.saveQuotation(sap_serialize, othercharges_serialize, discountList_serialize, planDetails_serialize, carParKList, fieldSet);
        
        Booking__c b = new Booking__c();
        b.Opportunity__c = o.Id;
        b.Booking_Date__c = System.today();
        b.Status__c = 'Booked';
        b.Doc_Verification_Status__c = 'Level 2 Accepted';
        if(qId!=null){
           if(qId.contains(',')){
               qId = qId.substring(0, qId.lastIndexOf(','));
           }
           b.Quotation__c = qId;  
        }
        b.Default_Address_of__c = '1st Applicant';
        b.Future_Correspondence_Contact_Name__c = 'Test Stetig';            //Future Correspondence Details
        b.Future_Correspondence_Contact_Email__c = 'test123@gmail.com';
        b.Future_Correspondence_Contact__c = '1st Applicant';
        b.Future_Correspondence_Contact_Relation__c = '1st Applicant';
        b.Future_Correspondence_Contact_Phone__c = '7658493820';
        b.Site__c = site;   
        b.Project__c = projectId;
        b.Property_Name__c = 'OEY-A-5701';
        b.Property_Type_Name__c = 'OEY _ 4 BHK Signature';
        b.Property__c = unitId;
        b.TDS_Paid_By__c = 'Authorization to Company';
        b.Mode_of_Funding__c = 'Self';
        b.Loan_Required__c = 'Yes';
        insert b;
        
        Applicant__c ap = new Applicant__c();
        ap.Applicant_Type__c = 'Primary';
        ap.Applicant_Number__c = 'Primary Applicant';
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
        
        Applicant__c ap1 = new Applicant__c();
        ap1.Salutation__c = 'Mr.';
        ap1.Name = 'Bhagyashree Stetig';
        ap1.Booking__c = b.Id;
        insert ap1;
        
        Applicant__c ap2 = new Applicant__c();
        ap2.Salutation__c = 'Mr.';
        ap2.Name = 'Bhagyashree Stetig';
        ap2.Booking__c = b.Id;
        insert ap2;
        
        Applicant__c ap3 = new Applicant__c();
        ap3.Salutation__c = 'Mr.';
        ap3.Name = 'Bhagyashree Stetig';
        ap3.Booking__c = b.Id;
        insert ap3;
        
        Applicant__c ap4 = new Applicant__c();
        ap4.Salutation__c = 'Mr.';
        ap4.Name = 'Bhagyashree Stetig';
        ap4.Booking__c = b.Id;
        insert ap4;
        
        Payment__c payment = new Payment__c();
        payment.RTGS_Cheque_Draft_No__c = '1254';
        payment.Instrument_Date__c = System.today();
        payment.Variable_Narration__c = 'Booking amount';
        payment.Project__c = projectId;
        payment.Property__c = unitId;
        payment.Is_Token__c = false;
        payment.Branch_Name__c = 'Pune';
        payment.Booking__c = b.Id;
        payment.Payment_Mode__c = 'Cheque';
        payment.Bank_Name__c = 'AXIS BANK';
        payment.Bank_Address__c = 'Pune';
        payment.Amount__c = 1000000.00;
        insert payment;
        
        Test.StartTest();
        PageReference pageRef1 = Page.ViewBooking;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('id', b.Id);
        ViewBooking vb = new ViewBooking();
        ViewBooking.PaymentWrapper payW = new ViewBooking.PaymentWrapper();
        vb.SaveQuote1();
        vb.BackToBooking();
        
        PageReference pageRef2 = Page.Booking_Conf;
        Test.setCurrentPage(pageRef2);
        BookingConfirmationCont bcon = new BookingConfirmationCont();
        bcon.BookingId = b.Id;
        bcon.getcreateBookingList();
        
          PageReference pageRef3 = Page.Booking_ConfNew;
        Test.setCurrentPage(pageRef3);
        BookingConfirmationCont bcon3 = new BookingConfirmationCont();
        bcon3.BookingId = b.Id;
        bcon3.getcreateBookingList();
        Test.StopTest();
        
        
    }
}
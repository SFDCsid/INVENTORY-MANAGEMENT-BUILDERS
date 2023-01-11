@isTest
public class TestApplicationTrg {

    @isTest
    public static void TestBooking2(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id, Enquiry_Type__c = 'Direct');
        insert opp;
        
        Account coOwner1  = new Account(firstName = 'Co',lastName='Owner1', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome2@stetig.in', personMobilePhone = '1111133333',Contact_category__pc = 'Second Applicant');
        insert coOwner1;        
        Co_Owner__c co1 = new Co_Owner__c();
        co1.Person_Account__c = coOwner1.id;
        co1.Opportunity__c = opp.id;
        insert co1;
                
        Account coOwner2  = new Account(firstName = 'Co',lastName='Owner3', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome3@stetig.in', personMobilePhone = '1111144444',Contact_category__pc = 'Third Applicant');
        insert coOwner2;
        Co_Owner__c co2 = new Co_Owner__c();
        co2.Person_Account__c = coOwner2.id;
        co2.Opportunity__c = opp.id;
        insert co2;
        
        Account coOwner3  = new Account(firstName = 'Co',lastName='Owner3', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome4@stetig.in', personMobilePhone = '1111155555',Contact_category__pc = 'Fourth Applicant');
        insert coOwner3;
        Co_Owner__c co3 = new Co_Owner__c();
        co3.Person_Account__c = coOwner3.id;
        co3.Opportunity__c = opp.id;
        insert co3;
        
        Account coOwner4  = new Account(firstName = 'Co',lastName='Owner4', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome5@stetig.in', personMobilePhone = '1111166666',Contact_category__pc = 'Fifth Applicant');
        insert coOwner4;
        Co_Owner__c co4 = new Co_Owner__c();
        co4.Person_Account__c = coOwner4.id;
        co4.Opportunity__c = opp.id;
        insert co4;
        
        //BillingPlanLineItemGroupingController.createBillingLineItemsFuture(dataMap.get('BILLING_PLAN'));
        Id unitId = dataMap.get('PROPERTY');
        Id projectId = dataMap.get('PROJECT');
        Id proprtyId = dataMap.get('PROPERTY_TYPE');
        Id towerId = dataMap.get('TOWER');
        Id planId = dataMap.get('BILLING_PLAN');
        
        PageReference pageRef = Page.Quotation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('unitId', unitId);
        pageRef.getParameters().put('oppId', opp.Id);
        
        /*Property__c property = Quotation.getProperty(unitId);
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
        */
        Quotation__C q = new Quotation__c();
        q.Opportunity__C = opp.id;
        q.Property__C = unitId;
        q.Billing_Plan__c = planId;
        q.Total_Agreement_Value_Modified__c = 100000;
        q.Project__c = projectId;
        q.Tower__c = towerId;
        q.Carpet_Area__c = 1000;
        q.Quote_Status__c = 'Valid';
        q.Final_Approved_Date__c = system.today();
        q.Customized_Billing_Plan__c = false;
        q.Discount_Applied__c = false;
        insert q;
        string qId = q.id;
        Quotation_Billing_Line_Item__c qb = new Quotation_Billing_Line_Item__c();
        qb.Quotation__C = q.id;
        qb.Due_After_Days__c = 0;
        qb.Due_Date__c = system.today();
        insert qb;
        
        PageReference pRef = Page.BookingPageForm2;
        Test.setCurrentPage(pRef);
        ApexPages.currentPage().getParameters().put('optyid',opp.Id);
        ApexPages.currentPage().getParameters().put('projectId',projectId);
        BookingClassNew book = new BookingClassNew();
        book.getquotation();
        List < SelectOption > queryResult = book.getQuote;
        book.selectedQuote = qId;
        book.getTokenAmount(); 
        book.getaddressstatus();
        book.addReciept();
        ApexPages.currentPage().getParameters().put('rowIndex','1');
        book.deleteReciept();
        book.boookingObj.Future_Correspondence_Contact__c = '1st Applicant';
        book.boookingObj.Default_Address_of__c = '1st Applicant';
        book.boookingObj.Mode_of_Funding__c = 'Self';
        book.boookingObj.TDS_Paid_By__c = 'Self';
        book.applicant.Salutation__c = 'Mr.';
        book.applicant.Name = '1st Applicant';
        book.firstApplicantDOB = system.today();
        book.applicant.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant.Country__c = 'India';
        book.applicant.State__c = 'Maharashtra';
        book.applicant.Gender__c = 'Male';
        book.applicant.Mobile_Number__c = '1234567890';
        book.applicant.Email_Address__c = 'applicant1@stetig.in';
        book.applicant.Nationality__c = 'Indian';
        book.applicant.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant.Pancard__c = true;
        book.applicant.Address_Proof__c = true;
        book.applicant.Address_Proof_Document__c = 'Passport';
        book.applicant.PassportNumber__c = true;
        book.applicant.PassportNoDetails__c = 'ABCDE1234S';
        book.applicant.PancardNo__c = 'ABCDE1234S';
        book.applicant.House_No__c = '111';
        book.applicant.Street_1__c = 'strret1';
        book.applicant.Street_2__c = 'strret2';
        book.applicant.Street_3__c = 'strret3';
        book.applicant.Locality__c = 'Mumabi';
        book.applicant.Pincode__c = '123456';
        book.applicant.City__c = 'Mumbai';
        book.addressCheck = true;    
        //book.boookingObj.Booking_Through__c = 'Partner';
        
        book.receiptlist[0].Payment_Mode__c = 'Cheque';
        book.receiptlist[0].RTGS_Cheque_Draft_No__c = '12345';
        book.receiptlist[0].Instrument_Date__c = system.today();
        book.receiptlist[0].Amount__c = 50000;
        book.receiptlist[0].Bank_Name__c = 'Bank of India';
        
        book.Save();
        Booking__c b= new Booking__c();
        b.Opportunity__c = opp.id;
        b.Site_Support__c = UserInfo.getUserId();
        b.Central_Support__c = UserInfo.getUserId();   
        insert b;
        
        book.applicant.Booking__c = b.id;
        insert book.applicant;
       
        Applicant__c a = new Applicant__c();
        a.Name = '1st Applicant Name Changed';
        a.id = book.applicant.id;
       
        update a;
        
         book.Cancel();
        BookingClassNew.INFormat(1000);
    }
    
}
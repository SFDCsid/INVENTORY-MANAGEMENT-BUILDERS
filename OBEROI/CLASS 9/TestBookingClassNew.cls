@isTest
public class TestBookingClassNew {
  @isTest
    public static void TestBooking(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id);
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
        
        /* Property__c property = Quotation.getProperty(unitId);
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
        book.boookingObj.Future_Correspondence_Contact__c = 'Other';
        book.boookingObj.Default_Address_of__c = null;
        book.boookingObj.Mode_of_Funding__c = null;
        book.boookingObj.TDS_Paid_By__c = null;
        book.applicant.Salutation__c = null;
        book.applicant.Name = null;
        book.firstApplicantDOB = null;
        book.applicant.Preferred_address_for_all_correspondence__c = null;
        book.applicant.Country__c = 'India';
        book.applicant.State__c = null;
        book.applicant.Gender__c = null;
        book.applicant.Country__c = null;
        book.applicant.Mobile_Number__c = null;
        book.applicant.Email_Address__c = null;
        book.applicant.Nationality__c = null;
        book.applicant.Type_Of_Applicant__c = null;
        book.applicant.Subtype_Of_Applicant__c = null;
        book.Save();
        book.applicant.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant2.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant3.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant4.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant5.Subtype_Of_Applicant__c = 'Indian National';
        book.boookingObj.Future_Correspondence_Contact__c = '1st Applicant';
        book.Save();
        book.applicant.Subtype_Of_Applicant__c = 'Foreign Nationals Of Indian Origin';
        book.applicant.PanCard_of_Authority_Signatory__c = false;
        book.applicant2.Subtype_Of_Applicant__c = 'Foreign Nationals Of Indian Origin';
        book.applicant2.PanCard_of_Authority_Signatory__c = false;
        book.applicant3.Subtype_Of_Applicant__c = 'Foreign Nationals Of Indian Origin';
        book.applicant3.PanCard_of_Authority_Signatory__c = false;
        book.applicant4.Subtype_Of_Applicant__c = 'Foreign Nationals Of Indian Origin';
        book.applicant4.PanCard_of_Authority_Signatory__c = false;
        book.applicant5.Subtype_Of_Applicant__c = 'Foreign Nationals Of Indian Origin';
        book.applicant5.PanCard_of_Authority_Signatory__c = false;
        book.boookingObj.Future_Correspondence_Contact__c = '2nd Applicant';
        book.Save();
        book.applicant.Subtype_Of_Applicant__c = 'For NRI';
        book.applicant.Pancard__c = false;
        book.applicant2.Subtype_Of_Applicant__c = 'For NRI';
        book.applicant2.Pancard__c = false;
        book.applicant3.Subtype_Of_Applicant__c = 'For NRI';
        book.applicant3.Pancard__c = false;
        book.applicant4.Subtype_Of_Applicant__c = 'For NRI';
        book.applicant4.Pancard__c = false;
        book.applicant5.Subtype_Of_Applicant__c = 'For NRI'; 
        book.applicant5.Pancard__c = false;
        book.boookingObj.Future_Correspondence_Contact__c = '3rd Applicant';
        book.Save();
        book.applicant.Subtype_Of_Applicant__c = 'For Company';
        book.applicant.PanCard_of_Authority_Signatory__c = false;
        book.applicant.Pan_Card_Number_of_Authority_Signatory__c = '';
        book.applicant2.Subtype_Of_Applicant__c = 'For Company';
        book.applicant2.PanCard_of_Authority_Signatory__c = false;
        book.applicant2.Pan_Card_Number_of_Authority_Signatory__c = '';
        book.applicant3.Subtype_Of_Applicant__c = 'For Company';
        book.applicant3.PanCard_of_Authority_Signatory__c = false;
        book.applicant3.Pan_Card_Number_of_Authority_Signatory__c = '';
        book.applicant4.Subtype_Of_Applicant__c = 'For Company';
        book.applicant4.PanCard_of_Authority_Signatory__c = false;
        book.applicant4.Pan_Card_Number_of_Authority_Signatory__c = '';
        book.applicant5.Subtype_Of_Applicant__c = 'For Company';
        book.applicant5.PanCard_of_Authority_Signatory__c = false;
        book.applicant5.Pan_Card_Number_of_Authority_Signatory__c = '';
        book.boookingObj.Future_Correspondence_Contact__c = '4th Applicant';
        book.Save();
        book.applicant.Subtype_Of_Applicant__c = 'Partnership Firm';
        book.applicant.PanCard_of_Authority_Signatory__c = false;
        book.applicant2.Subtype_Of_Applicant__c = 'Partnership Firm';
        book.applicant2.PanCard_of_Authority_Signatory__c = false;
        book.applicant3.Subtype_Of_Applicant__c = 'Partnership Firm';
        book.applicant3.PanCard_of_Authority_Signatory__c = false;
        book.applicant4.Subtype_Of_Applicant__c = 'Partnership Firm';
        book.applicant4.PanCard_of_Authority_Signatory__c = false;
        book.applicant5.Subtype_Of_Applicant__c = 'Partnership Firm';
        book.applicant5.PanCard_of_Authority_Signatory__c = false;
        book.addressCheck = false;
        book.addressCheckApplicant2 = false;
        book.addressCheckApplicant3 = false;
        book.addressCheckApplicant4 = false;
        book.addressCheckApplicant5 = false;
        book.boookingObj.Future_Correspondence_Contact__c = '5th Applicant';
        book.Save();
     
    }
    
    @isTest
    public static void TestBooking2(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id, Enquiry_Type__c = 'Partner');
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
        book.applicant.Salutation__c = 'Mr';
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
        book.applicant.Address_Proof_Document__c = 'Pancard';
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
        
        book.applicant2.Salutation__c = 'Mr';
        book.applicant2.Name = '2nd Applicant';
        book.secondApplicantDOB = system.today();
        book.applicant2.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant2.Country__c = 'India';
        book.applicant2.State__c = 'Maharashtra';
        book.applicant2.Gender__c = 'Male';
        book.applicant2.Mobile_Number__c = '1234567891';
        book.applicant2.Email_Address__c = 'applicant2@stetig.in';
        book.applicant2.Nationality__c = 'Indian';
        book.applicant2.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant2.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant2.Pancard__c = true;
        book.applicant2.Address_Proof__c = true;
        book.applicant2.Address_Proof_Document__c = 'Pancard';
        book.applicant2.PancardNo__c = 'ABCDE1234R';
        book.applicant2.City__c = 'Mumbai';
        book.applicant2.Pincode__c = '123456';
        book.addressCheckApplicant2 = true;
        
        book.applicant3.Salutation__c = 'Mr';
        book.applicant3.Name = '3rd Applicant';
        book.thirdApplicantDOB = system.today();
        book.applicant3.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant3.Country__c = 'India';
        book.applicant3.State__c = 'Maharashtra';
        book.applicant3.Gender__c = 'Male';
        book.applicant3.Mobile_Number__c = '1234567892';
        book.applicant3.Email_Address__c = 'applicant3@stetig.in';
        book.applicant3.Nationality__c = 'Indian';
        book.applicant3.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant3.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant3.Pancard__c = true;
        book.applicant3.Address_Proof__c = true;
        book.applicant3.Address_Proof_Document__c = 'Pancard';
        book.applicant3.PancardNo__c = 'ABCDE1234T';
        book.applicant3.City__c = 'Mumbai';
        book.applicant3.Pincode__c = '123456';
        book.addressCheckApplicant3 = true;
        
        book.applicant4.Salutation__c = 'Mr';
        book.applicant4.Name = '4th Applicant';
        book.fourthApplicantDOB = system.today();
        book.applicant4.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant4.Country__c = 'India';
        book.applicant4.State__c = 'Maharashtra';
        book.applicant4.Gender__c = 'Male';
        book.applicant4.Mobile_Number__c = '1234567893';
        book.applicant4.Email_Address__c = 'applicant4@stetig.in';
        book.applicant4.Nationality__c = 'Indian';
        book.applicant4.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant4.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant4.Pancard__c = true;
        book.applicant4.Address_Proof__c = true;
        book.applicant4.Address_Proof_Document__c = 'Pancard';
        book.applicant4.PancardNo__c = 'ABCDE1234R';
        book.applicant4.City__c = 'Mumbai';
        book.applicant4.Pincode__c = '123456';
        book.addressCheckApplicant4 = true;
        
        book.applicant5.Salutation__c = 'Mr';
        book.applicant5.Name = '5th Applicant';
        book.fifthApplicantDOB = system.today();
        book.applicant5.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant5.Country__c = 'India';
        book.applicant5.State__c = 'Maharashtra';
        book.applicant5.Gender__c = 'Male';
        book.applicant5.Mobile_Number__c = '1234567894';
        book.applicant5.Email_Address__c = 'applicant5@stetig.in';
        book.applicant5.Nationality__c = 'Indian';
        book.applicant5.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant5.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant5.Pancard__c = true;
        book.applicant5.Address_Proof__c = true;
        book.applicant5.Address_Proof_Document__c = 'Pancard';
        book.applicant5.PancardNo__c = 'ABCDE1234U';
        book.applicant5.City__c = 'Mumbai';
        book.applicant5.Pincode__c = '123456';
        book.addressCheckApplicant5 = true;
        
        book.receiptlist[0].Payment_Mode__c = 'Cheque';
        book.receiptlist[0].RTGS_Cheque_Draft_No__c = '12345';
        book.receiptlist[0].Instrument_Date__c = system.today();
        book.receiptlist[0].Amount__c = 50000;
        book.receiptlist[0].Bank_Name__c = 'Bank of India';
        book.Save();
        book.Cancel();
        
        BookingClassNew.INFormat(1000);
    }
    
    @isTest
    public static void TestBooking3(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id);
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
        
       // BillingPlanLineItemGroupingController.createBillingLineItemsFuture(dataMap.get('BILLING_PLAN'));
        Id unitId = dataMap.get('PROPERTY');
        Id projectId = dataMap.get('PROJECT');
        Id proprtyId = dataMap.get('PROPERTY_TYPE');
        Id towerId = dataMap.get('TOWER');
        Id planId = dataMap.get('BILLING_PLAN');
        
        PageReference pageRef = Page.Quotation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('unitId', unitId);
        pageRef.getParameters().put('oppId', opp.Id);
        
       /* Property__c property = Quotation.getProperty(unitId);
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
        book.boookingObj.Future_Correspondence_Contact__c = '2nd Applicant';
        book.boookingObj.Default_Address_of__c = '2nd Applicant';
        book.boookingObj.Mode_of_Funding__c = 'Self';
        book.boookingObj.TDS_Paid_By__c = 'Self';
        book.applicant.Salutation__c = 'Mr';
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
        book.applicant.Address_Proof_Document__c = 'Pancard';
        book.applicant.PancardNo__c = 'ABCDE1234S';
        book.applicant.House_No__c = '111';
        book.applicant.Street_1__c = 'strret1';
        book.applicant.Street_2__c = 'strret2';
        book.applicant.Street_3__c = 'strret3';
        book.applicant.Locality__c = 'Mumabi';
        book.applicant.Pincode__c = '123456';
        book.applicant.City__c = 'Mumbai';
        book.addressCheck = true;    
        
        book.applicant2.Salutation__c = 'Mr';
        book.applicant2.Name = '2nd Applicant';
        book.secondApplicantDOB = system.today();
        book.applicant2.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant2.Country__c = 'India';
        book.applicant2.State__c = 'Maharashtra';
        book.applicant2.Gender__c = 'Male';
        book.applicant2.Mobile_Number__c = '1234567891';
        book.applicant2.Email_Address__c = 'applicant2@stetig.in';
        book.applicant2.Nationality__c = 'Indian';
        book.applicant2.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant2.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant2.Pancard__c = true;
        book.applicant2.Address_Proof__c = true;
        book.applicant2.Address_Proof_Document__c = 'Pancard';
        book.applicant2.PancardNo__c = 'ABCDE1234R';
        book.applicant2.City__c = 'Mumbai';
        book.applicant2.Pincode__c = '123456';
        book.addressCheckApplicant2 = true;
        
        book.applicant3.Salutation__c = 'Mr';
        book.applicant3.Name = '3rd Applicant';
        book.thirdApplicantDOB = system.today();
        book.applicant3.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant3.Country__c = 'India';
        book.applicant3.State__c = 'Maharashtra';
        book.applicant3.Gender__c = 'Male';
        book.applicant3.Mobile_Number__c = '1234567892';
        book.applicant3.Email_Address__c = 'applicant3@stetig.in';
        book.applicant3.Nationality__c = 'Indian';
        book.applicant3.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant3.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant3.Pancard__c = true;
        book.applicant3.Address_Proof__c = true;
        book.applicant3.Address_Proof_Document__c = 'Pancard';
        book.applicant3.PancardNo__c = 'ABCDE1234T';
        book.applicant3.City__c = 'Mumbai';
        book.applicant3.Pincode__c = '123456';
        book.addressCheckApplicant3 = true;
        
        book.applicant4.Salutation__c = 'Mr';
        book.applicant4.Name = '4th Applicant';
        book.fourthApplicantDOB = system.today();
        book.applicant4.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant4.Country__c = 'India';
        book.applicant4.State__c = 'Maharashtra';
        book.applicant4.Gender__c = 'Male';
        book.applicant4.Mobile_Number__c = '1234567893';
        book.applicant4.Email_Address__c = 'applicant4@stetig.in';
        book.applicant4.Nationality__c = 'Indian';
        book.applicant4.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant4.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant4.Pancard__c = true;
        book.applicant4.Address_Proof__c = true;
        book.applicant4.Address_Proof_Document__c = 'Pancard';
        book.applicant4.PancardNo__c = 'ABCDE1234R';
        book.applicant4.City__c = 'Mumbai';
        book.applicant4.Pincode__c = '123456';
        book.addressCheckApplicant4 = true;
        
        book.applicant5.Salutation__c = 'Mr';
        book.applicant5.Name = '5th Applicant';
        book.fifthApplicantDOB = system.today();
        book.applicant5.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant5.Country__c = 'India';
        book.applicant5.State__c = 'Maharashtra';
        book.applicant5.Gender__c = 'Male';
        book.applicant5.Mobile_Number__c = '1234567894';
        book.applicant5.Email_Address__c = 'applicant5@stetig.in';
        book.applicant5.Nationality__c = 'Indian';
        book.applicant5.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant5.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant5.Pancard__c = true;
        book.applicant5.Address_Proof__c = true;
        book.applicant5.Address_Proof_Document__c = 'Pancard';
        book.applicant5.PancardNo__c = 'ABCDE1234U';
        book.applicant5.City__c = 'Mumbai';
        book.applicant5.Pincode__c = '123456';
        book.addressCheckApplicant5 = true;
        
        book.receiptlist[0].Payment_Mode__c = 'Cheque';
        book.receiptlist[0].RTGS_Cheque_Draft_No__c = '12345';
        book.receiptlist[0].Instrument_Date__c = system.today();
        book.receiptlist[0].Amount__c = 50000;
        book.receiptlist[0].Bank_Name__c = 'Bank of India';
        book.Save();
        book.Cancel();
        BookingClassNew.INFormat(1000);
    }
    
    @isTest
    public static void TestBooking4(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id);
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
        book.boookingObj.Future_Correspondence_Contact__c = '3rd Applicant';
        book.boookingObj.Default_Address_of__c = '3rd Applicant';
        book.boookingObj.Mode_of_Funding__c = 'Self';
        book.boookingObj.TDS_Paid_By__c = 'Self';
        book.applicant.Salutation__c = 'Mr';
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
        book.applicant.Address_Proof_Document__c = 'Pancard';
        book.applicant.PancardNo__c = 'ABCDE1234S';
        book.applicant.House_No__c = '111';
        book.applicant.Street_1__c = 'strret1';
        book.applicant.Street_2__c = 'strret2';
        book.applicant.Street_3__c = 'strret3';
        book.applicant.Locality__c = 'Mumabi';
        book.applicant.Pincode__c = '123456';
        book.applicant.City__c = 'Mumbai';
        book.addressCheck = true;    
        
        book.applicant2.Salutation__c = 'Mr';
        book.applicant2.Name = '2nd Applicant';
        book.secondApplicantDOB = system.today();
        book.applicant2.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant2.Country__c = 'India';
        book.applicant2.State__c = 'Maharashtra';
        book.applicant2.Gender__c = 'Male';
        book.applicant2.Mobile_Number__c = '1234567891';
        book.applicant2.Email_Address__c = 'applicant2@stetig.in';
        book.applicant2.Nationality__c = 'Indian';
        book.applicant2.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant2.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant2.Pancard__c = true;
        book.applicant2.Address_Proof__c = true;
        book.applicant2.Address_Proof_Document__c = 'Pancard';
        book.applicant2.PancardNo__c = 'ABCDE1234R';
        book.applicant2.City__c = 'Mumbai';
        book.applicant2.Pincode__c = '123456';
        book.addressCheckApplicant2 = true;
        
        book.applicant3.Salutation__c = 'Mr';
        book.applicant3.Name = '3rd Applicant';
        book.thirdApplicantDOB = system.today();
        book.applicant3.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant3.Country__c = 'India';
        book.applicant3.State__c = 'Maharashtra';
        book.applicant3.Gender__c = 'Male';
        book.applicant3.Mobile_Number__c = '1234567892';
        book.applicant3.Email_Address__c = 'applicant3@stetig.in';
        book.applicant3.Nationality__c = 'Indian';
        book.applicant3.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant3.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant3.Pancard__c = true;
        book.applicant3.Address_Proof__c = true;
        book.applicant3.Address_Proof_Document__c = 'Pancard';
        book.applicant3.PancardNo__c = 'ABCDE1234T';
        book.applicant3.City__c = 'Mumbai';
        book.applicant3.Pincode__c = '123456';
        book.addressCheckApplicant3 = true;
        
        book.applicant4.Salutation__c = 'Mr';
        book.applicant4.Name = '4th Applicant';
        book.fourthApplicantDOB = system.today();
        book.applicant4.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant4.Country__c = 'India';
        book.applicant4.State__c = 'Maharashtra';
        book.applicant4.Gender__c = 'Male';
        book.applicant4.Mobile_Number__c = '1234567893';
        book.applicant4.Email_Address__c = 'applicant4@stetig.in';
        book.applicant4.Nationality__c = 'Indian';
        book.applicant4.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant4.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant4.Pancard__c = true;
        book.applicant4.Address_Proof__c = true;
        book.applicant4.Address_Proof_Document__c = 'Pancard';
        book.applicant4.PancardNo__c = 'ABCDE1234R';
        book.applicant4.City__c = 'Mumbai';
        book.applicant4.Pincode__c = '123456';
        book.addressCheckApplicant4 = true;
        
        book.applicant5.Salutation__c = 'Mr';
        book.applicant5.Name = '5th Applicant';
        book.fifthApplicantDOB = system.today();
        book.applicant5.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant5.Country__c = 'India';
        book.applicant5.State__c = 'Maharashtra';
        book.applicant5.Gender__c = 'Male';
        book.applicant5.Mobile_Number__c = '1234567894';
        book.applicant5.Email_Address__c = 'applicant5@stetig.in';
        book.applicant5.Nationality__c = 'Indian';
        book.applicant5.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant5.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant5.Pancard__c = true;
        book.applicant5.Address_Proof__c = true;
        book.applicant5.Address_Proof_Document__c = 'Pancard';
        book.applicant5.PancardNo__c = 'ABCDE1234U';
        book.applicant5.City__c = 'Mumbai';
        book.applicant5.Pincode__c = '123456';
        book.addressCheckApplicant5 = true;
        
        book.receiptlist[0].Payment_Mode__c = 'Cheque';
        book.receiptlist[0].RTGS_Cheque_Draft_No__c = '12345';
        book.receiptlist[0].Instrument_Date__c = system.today();
        book.receiptlist[0].Amount__c = 50000;
        book.receiptlist[0].Bank_Name__c = 'Bank of India';
        book.Save();
        book.Cancel();
        BookingClassNew.INFormat(1000);
    }
    
    @isTest
    public static void TestBooking5(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id);
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
        
       // BillingPlanLineItemGroupingController.createBillingLineItemsFuture(dataMap.get('BILLING_PLAN'));
        Id unitId = dataMap.get('PROPERTY');
        Id projectId = dataMap.get('PROJECT');
        Id proprtyId = dataMap.get('PROPERTY_TYPE');
        Id towerId = dataMap.get('TOWER');
        Id planId = dataMap.get('BILLING_PLAN');
        
        PageReference pageRef = Page.Quotation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('unitId', unitId);
        pageRef.getParameters().put('oppId', opp.Id);
        
       /* Property__c property = Quotation.getProperty(unitId);
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
        book.boookingObj.Future_Correspondence_Contact__c = '4th Applicant';
        book.boookingObj.Default_Address_of__c = '4th Applicant';
        book.boookingObj.Mode_of_Funding__c = 'Self';
        book.boookingObj.TDS_Paid_By__c = 'Self';
        book.applicant.Salutation__c = 'Mr';
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
        book.applicant.Address_Proof_Document__c = 'Pancard';
        book.applicant.PancardNo__c = 'ABCDE1234S';
        book.applicant.House_No__c = '111';
        book.applicant.Street_1__c = 'strret1';
        book.applicant.Street_2__c = 'strret2';
        book.applicant.Street_3__c = 'strret3';
        book.applicant.Locality__c = 'Mumabi';
        book.applicant.Pincode__c = '123456';
        book.applicant.City__c = 'Mumbai';
        book.addressCheck = true;    
        
        book.applicant2.Salutation__c = 'Mr';
        book.applicant2.Name = '2nd Applicant';
        book.secondApplicantDOB = system.today();
        book.applicant2.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant2.Country__c = 'India';
        book.applicant2.State__c = 'Maharashtra';
        book.applicant2.Gender__c = 'Male';
        book.applicant2.Mobile_Number__c = '1234567891';
        book.applicant2.Email_Address__c = 'applicant2@stetig.in';
        book.applicant2.Nationality__c = 'Indian';
        book.applicant2.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant2.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant2.Pancard__c = true;
        book.applicant2.Address_Proof__c = true;
        book.applicant2.Address_Proof_Document__c = 'Pancard';
        book.applicant2.PancardNo__c = 'ABCDE1234R';
        book.applicant2.City__c = 'Mumbai';
        book.applicant2.Pincode__c = '123456';
        book.addressCheckApplicant2 = true;
        
        book.applicant3.Salutation__c = 'Mr';
        book.applicant3.Name = '3rd Applicant';
        book.thirdApplicantDOB = system.today();
        book.applicant3.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant3.Country__c = 'India';
        book.applicant3.State__c = 'Maharashtra';
        book.applicant3.Gender__c = 'Male';
        book.applicant3.Mobile_Number__c = '1234567892';
        book.applicant3.Email_Address__c = 'applicant3@stetig.in';
        book.applicant3.Nationality__c = 'Indian';
        book.applicant3.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant3.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant3.Pancard__c = true;
        book.applicant3.Address_Proof__c = true;
        book.applicant3.Address_Proof_Document__c = 'Pancard';
        book.applicant3.PancardNo__c = 'ABCDE1234T';
        book.applicant3.City__c = 'Mumbai';
        book.applicant3.Pincode__c = '123456';
        book.addressCheckApplicant3 = true;
        
        book.applicant4.Salutation__c = 'Mr';
        book.applicant4.Name = '4th Applicant';
        book.fourthApplicantDOB = system.today();
        book.applicant4.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant4.Country__c = 'India';
        book.applicant4.State__c = 'Maharashtra';
        book.applicant4.Gender__c = 'Male';
        book.applicant4.Mobile_Number__c = '1234567893';
        book.applicant4.Email_Address__c = 'applicant4@stetig.in';
        book.applicant4.Nationality__c = 'Indian';
        book.applicant4.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant4.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant4.Pancard__c = true;
        book.applicant4.Address_Proof__c = true;
        book.applicant4.Address_Proof_Document__c = 'Pancard';
        book.applicant4.PancardNo__c = 'ABCDE1234R';
        book.applicant4.City__c = 'Mumbai';
        book.applicant4.Pincode__c = '123456';
        book.addressCheckApplicant4 = true;
        
        book.applicant5.Salutation__c = 'Mr';
        book.applicant5.Name = '5th Applicant';
        book.fifthApplicantDOB = system.today();
        book.applicant5.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant5.Country__c = 'India';
        book.applicant5.State__c = 'Maharashtra';
        book.applicant5.Gender__c = 'Male';
        book.applicant5.Mobile_Number__c = '1234567894';
        book.applicant5.Email_Address__c = 'applicant5@stetig.in';
        book.applicant5.Nationality__c = 'Indian';
        book.applicant5.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant5.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant5.Pancard__c = true;
        book.applicant5.Address_Proof__c = true;
        book.applicant5.Address_Proof_Document__c = 'Pancard';
        book.applicant5.PancardNo__c = 'ABCDE1234U';
        book.applicant5.City__c = 'Mumbai';
        book.applicant5.Pincode__c = '123456';
        book.addressCheckApplicant5 = true;
        
        book.receiptlist[0].Payment_Mode__c = 'Cheque';
        book.receiptlist[0].RTGS_Cheque_Draft_No__c = '12345';
        book.receiptlist[0].Instrument_Date__c = system.today();
        book.receiptlist[0].Amount__c = 50000;
        book.receiptlist[0].Bank_Name__c = 'Bank of India';
        book.Save();
        book.Cancel();
        BookingClassNew.INFormat(1000);
    }
    
    @isTest
    public static void TestBooking6(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id);
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
        book.boookingObj.Future_Correspondence_Contact__c = '5th Applicant';
        book.boookingObj.Default_Address_of__c = '5th Applicant';
        book.boookingObj.Mode_of_Funding__c = 'Self';
        book.boookingObj.TDS_Paid_By__c = 'Self';
        book.applicant.Salutation__c = 'Mr';
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
        book.applicant.Address_Proof_Document__c = 'Pancard';
        book.applicant.PancardNo__c = 'ABCDE1234S';
        book.applicant.House_No__c = '111';
        book.applicant.Street_1__c = 'strret1';
        book.applicant.Street_2__c = 'strret2';
        book.applicant.Street_3__c = 'strret3';
        book.applicant.Locality__c = 'Mumabi';
        book.applicant.Pincode__c = '123456';
        book.applicant.City__c = 'Mumbai';
        book.addressCheck = true;    
        
        book.applicant2.Salutation__c = 'Mr';
        book.applicant2.Name = '2nd Applicant';
        book.secondApplicantDOB = system.today();
        book.applicant2.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant2.Country__c = 'India';
        book.applicant2.State__c = 'Maharashtra';
        book.applicant2.Gender__c = 'Male';
        book.applicant2.Mobile_Number__c = '1234567891';
        book.applicant2.Email_Address__c = 'applicant2@stetig.in';
        book.applicant2.Nationality__c = 'Indian';
        book.applicant2.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant2.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant2.Pancard__c = true;
        book.applicant2.Address_Proof__c = true;
        book.applicant2.Address_Proof_Document__c = 'Pancard';
        book.applicant2.PancardNo__c = 'ABCDE1234R';
        book.applicant2.City__c = 'Mumbai';
        book.applicant2.Pincode__c = '123456';
        book.addressCheckApplicant2 = true;
        
        book.applicant3.Salutation__c = 'Mr';
        book.applicant3.Name = '3rd Applicant';
        book.thirdApplicantDOB = system.today();
        book.applicant3.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant3.Country__c = 'India';
        book.applicant3.State__c = 'Maharashtra';
        book.applicant3.Gender__c = 'Male';
        book.applicant3.Mobile_Number__c = '1234567892';
        book.applicant3.Email_Address__c = 'applicant3@stetig.in';
        book.applicant3.Nationality__c = 'Indian';
        book.applicant3.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant3.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant3.Pancard__c = true;
        book.applicant3.Address_Proof__c = true;
        book.applicant3.Address_Proof_Document__c = 'Pancard';
        book.applicant3.PancardNo__c = 'ABCDE1234T';
        book.applicant3.City__c = 'Mumbai';
        book.applicant3.Pincode__c = '123456';
        book.addressCheckApplicant3 = true;
        
        book.applicant4.Salutation__c = 'Mr';
        book.applicant4.Name = '4th Applicant';
        book.fourthApplicantDOB = system.today();
        book.applicant4.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant4.Country__c = 'India';
        book.applicant4.State__c = 'Maharashtra';
        book.applicant4.Gender__c = 'Male';
        book.applicant4.Mobile_Number__c = '1234567893';
        book.applicant4.Email_Address__c = 'applicant4@stetig.in';
        book.applicant4.Nationality__c = 'Indian';
        book.applicant4.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant4.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant4.Pancard__c = true;
        book.applicant4.Address_Proof__c = true;
        book.applicant4.Address_Proof_Document__c = 'Pancard';
        book.applicant4.PancardNo__c = 'ABCDE1234R';
        book.applicant4.City__c = 'Mumbai';
        book.applicant4.Pincode__c = '123456';
        book.addressCheckApplicant4 = true;
        
        book.applicant5.Salutation__c = 'Mr';
        book.applicant5.Name = '5th Applicant';
        book.fifthApplicantDOB = system.today();
        book.applicant5.Preferred_address_for_all_correspondence__c = 'Permanent';
        book.applicant5.Country__c = 'India';
        book.applicant5.State__c = 'Maharashtra';
        book.applicant5.Gender__c = 'Male';
        book.applicant5.Mobile_Number__c = '1234567894';
        book.applicant5.Email_Address__c = 'applicant5@stetig.in';
        book.applicant5.Nationality__c = 'Indian';
        book.applicant5.Type_Of_Applicant__c = 'Indiviual Buyer';
        book.applicant5.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant5.Pancard__c = true;
        book.applicant5.Address_Proof__c = true;
        book.applicant5.Address_Proof_Document__c = 'Pancard';
        book.applicant5.PancardNo__c = 'ABCDE1234U';
        book.applicant5.City__c = 'Mumbai';
        book.applicant5.Pincode__c = '123456';
        book.addressCheckApplicant5 = true;
        
        book.receiptlist[0].Payment_Mode__c = 'Cheque';
        book.receiptlist[0].RTGS_Cheque_Draft_No__c = '12345';
        book.receiptlist[0].Instrument_Date__c = system.today();
        book.receiptlist[0].Amount__c = 50000;
        book.receiptlist[0].Bank_Name__c = 'Bank of India';
        book.Save();
        book.Cancel();
        BookingClassNew.INFormat(1000);
    }
    
    @isTest
    public static void TestBooking7(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id);
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
        
        PageReference pRef = Page.BookingPageForm2;
        Test.setCurrentPage(pRef);
        ApexPages.currentPage().getParameters().put('optyid',opp.Id);
        ApexPages.currentPage().getParameters().put('projectId',projectId);
        BookingClassNew book = new BookingClassNew();
        book.applicant.Country__c = null;
        book.applicant.City__c = null;
        book.Save();
        book.applicant.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant2.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant3.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant4.Subtype_Of_Applicant__c = 'Indian National';
        book.applicant5.Subtype_Of_Applicant__c = 'Indian National';
        book.boookingObj.Future_Correspondence_Contact__c = '1st Applicant';
        book.boookingObj.Default_Address_of__c = '1st Applicant';
        book.applicant.name = null;
        book.Save();
        book.applicant.Subtype_Of_Applicant__c = 'Foreign Nationals Of Indian Origin';
        book.applicant.PanCard_of_Authority_Signatory__c = false;
        book.applicant2.Subtype_Of_Applicant__c = 'Foreign Nationals Of Indian Origin';
        book.applicant2.PanCard_of_Authority_Signatory__c = false;
        book.applicant3.Subtype_Of_Applicant__c = 'Foreign Nationals Of Indian Origin';
        book.applicant3.PanCard_of_Authority_Signatory__c = false;
        book.applicant4.Subtype_Of_Applicant__c = 'Foreign Nationals Of Indian Origin';
        book.applicant4.PanCard_of_Authority_Signatory__c = false;
        book.applicant5.Subtype_Of_Applicant__c = 'Foreign Nationals Of Indian Origin';
        book.applicant5.PanCard_of_Authority_Signatory__c = false;
        book.boookingObj.Future_Correspondence_Contact__c = '2nd Applicant';
        book.boookingObj.Default_Address_of__c = '2nd Applicant';
        book.applicant2.name = null;
        book.Save();
        book.applicant.Subtype_Of_Applicant__c = 'For NRI';
        book.applicant.Pancard__c = false;
        book.applicant2.Subtype_Of_Applicant__c = 'For NRI';
        book.applicant2.Pancard__c = false;
        book.applicant3.Subtype_Of_Applicant__c = 'For NRI';
        book.applicant3.Pancard__c = false;
        book.applicant4.Subtype_Of_Applicant__c = 'For NRI';
        book.applicant4.Pancard__c = false;
        book.applicant5.Subtype_Of_Applicant__c = 'For NRI'; 
        book.applicant5.Pancard__c = false;
        book.boookingObj.Future_Correspondence_Contact__c = '3rd Applicant';
        book.boookingObj.Default_Address_of__c = '3rd Applicant';
        book.applicant3.name = null;
        book.Save();
        book.applicant.Subtype_Of_Applicant__c = 'For Company';
        book.applicant.PanCard_of_Authority_Signatory__c = true;
        book.applicant.Pan_Card_Number_of_Authority_Signatory__c = 'qwer';
        book.applicant.Copy_of_Memorandum_of_Association__c = true;
        book.applicant.Certified_copy_of_Article_of_Association__c = true;
        book.applicant.Certified_copy_of_Board_Resolution__c = true;
        book.applicant.Self_attested_List_of_Directors__c = true;
        book.applicant.Copy_of_Workpermit_Employment_contract__c = false;
        
        book.applicant2.Subtype_Of_Applicant__c = 'For Company';
        book.applicant2.PanCard_of_Authority_Signatory__c = true;
        book.applicant2.Pan_Card_Number_of_Authority_Signatory__c = 'qwer';
        book.applicant2.Copy_of_Memorandum_of_Association__c = true;
        book.applicant2.Certified_copy_of_Article_of_Association__c = true;
        book.applicant2.Certified_copy_of_Board_Resolution__c = true;
        book.applicant2.Self_attested_List_of_Directors__c = true;
        book.applicant2.Copy_of_Workpermit_Employment_contract__c = false;
        
        book.applicant3.Subtype_Of_Applicant__c = 'For Company';
        book.applicant3.PanCard_of_Authority_Signatory__c = true;
        book.applicant3.Pan_Card_Number_of_Authority_Signatory__c = 'qwer';
        book.applicant3.Copy_of_Memorandum_of_Association__c = true;
        book.applicant3.Certified_copy_of_Article_of_Association__c = true;
        book.applicant3.Certified_copy_of_Board_Resolution__c = true;
        book.applicant3.Self_attested_List_of_Directors__c = true;
        book.applicant3.Copy_of_Workpermit_Employment_contract__c = false;
        
        book.applicant4.Subtype_Of_Applicant__c = 'For Company';
        book.applicant4.PanCard_of_Authority_Signatory__c = true;
        book.applicant4.Pan_Card_Number_of_Authority_Signatory__c = 'qwer';
        book.applicant4.Copy_of_Memorandum_of_Association__c = true;
        book.applicant4.Certified_copy_of_Article_of_Association__c = true;
        book.applicant4.Certified_copy_of_Board_Resolution__c = true;
        book.applicant4.Self_attested_List_of_Directors__c = true;
        book.applicant4.Copy_of_Workpermit_Employment_contract__c = false;
        
        book.applicant5.Subtype_Of_Applicant__c = 'For Company';
        book.applicant5.PanCard_of_Authority_Signatory__c = true;
        book.applicant5.Pan_Card_Number_of_Authority_Signatory__c = 'qwer';
        book.applicant5.Copy_of_Memorandum_of_Association__c = true;
        book.applicant5.Certified_copy_of_Article_of_Association__c = true;
        book.applicant5.Certified_copy_of_Board_Resolution__c = true;
        book.applicant5.Self_attested_List_of_Directors__c = true;
        book.applicant5.Copy_of_Workpermit_Employment_contract__c = false;
        
        book.boookingObj.Future_Correspondence_Contact__c = '4th Applicant';
        book.boookingObj.Default_Address_of__c = '4th Applicant';
        book.applicant4.name = null;
        book.Save();
        book.applicant.Subtype_Of_Applicant__c = 'Partnership Firm';
        book.applicant.PanCard_of_Authority_Signatory__c = false;
        book.applicant2.Subtype_Of_Applicant__c = 'Partnership Firm';
        book.applicant2.PanCard_of_Authority_Signatory__c = false;
        book.applicant3.Subtype_Of_Applicant__c = 'Partnership Firm';
        book.applicant3.PanCard_of_Authority_Signatory__c = false;
        book.applicant4.Subtype_Of_Applicant__c = 'Partnership Firm';
        book.applicant4.PanCard_of_Authority_Signatory__c = false;
        book.applicant5.Subtype_Of_Applicant__c = 'Partnership Firm';
        book.applicant5.PanCard_of_Authority_Signatory__c = false;
        book.addressCheck = false;
        book.addressCheckApplicant2 = false;
        book.addressCheckApplicant3 = false;
        book.addressCheckApplicant4 = false;
        book.addressCheckApplicant5 = false;
        book.boookingObj.Future_Correspondence_Contact__c = '5th Applicant';
        book.boookingObj.Default_Address_of__c = '5th Applicant';
        book.applicant5.name = null;
        book.Save();
        book.dummy();
        book.updateUnit();
    }
}
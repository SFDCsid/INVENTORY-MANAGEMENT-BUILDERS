@isTest
Public Class Test_AmountClearenceCase{
    @isTest
    public static void caseCreation(){
        
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                      personMobilePhone = '1111122222');
        insert ac; 
        
        Opportunity opp = new Opportunity(Name = 'Test Komal',StageName = 'New',CloseDate = System.today().AddDays(15),
                                          AccountId = ac.id,OwnerId = UserInfo.getUserId());
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
        
        Test.startTest();
        Booking__c b = new Booking__C();
        b.Opportunity__c = opp.id;
        b.Booking_Date__c = system.today();
        //b.Acceptance_Form_Template__c = 'Acceptance_Form';
        b.Status__c = 'Booking In Process';
        b.Future_Correspondence_Contact_Email__c = 'Email@gmail.com';
        //b.Booking_Through__c = 'Direct';
        b.Quotation__c = qId;
        b.Default_Address_of__c = '1st Applicant';
        b.Project__c = projectId;
        b.Tower__c = towerId;
        b.Property__c = unitId;
        b.Sales_Document_SAP__c = '0671900355';
        //b.Token_Amount_Clearence__c = false;
        b.Token_Amount_Clearence_Date__c = system.today();
        b.Registration_Process_Email__c = false;
        b.RM_User__c = UserInfo.getUserId();
        b.Site_Support__c = UserInfo.getUserId();
        b.Central_Support__c = UserInfo.getUserId();
        b.AR_Support__c = UserInfo.getUserId();
   
        insert b;
        
        Booking__c b1 = new Booking__C();
        b1.Opportunity__c = opp.id;
        b1.Booking_Date__c = system.today();
        //b.Acceptance_Form_Template__c = 'Acceptance_Form';
        b1.Status__c = 'Booking In Process';
        b1.Future_Correspondence_Contact_Email__c = 'Email@gmail.com';
        //b.Booking_Through__c = 'Direct';
        b1.Quotation__c = qId;
        b1.Default_Address_of__c = '1st Applicant';
        b1.Project__c = projectId;
        b1.Tower__c = towerId;
        b1.Property__c = unitId;
        b1.Sales_Document_SAP__c = '0671900355';
        //b.Token_Amount_Clearence__c = false;
        b1.Token_Amount_Clearence_Date__c = system.today();
        b1.Registration_Process_Email__c = false;
        b1.RM_User__c = UserInfo.getUserId();
        b1.Site_Support__c = UserInfo.getUserId();
        b1.Central_Support__c = UserInfo.getUserId();
        b1.AR_Support__c = UserInfo.getUserId();
   
        insert b1; 
        
        SAP_Receipts_and_Credit_Note__c src = new SAP_Receipts_and_Credit_Note__c();
        src.Booking__c = b.Id;
        src.Status__c = 'New';
        src.Payment_term_key__c = 'BD01';
        src.Doc_Type_Description__c = 'RECEIPT';
        src.Clearing_Date__c = system.today();
        insert src;
        
        src.Status__c = 'CLEAR';
      //  update src;
        
        SAP_Receipts_and_Credit_Note__c src1 = new SAP_Receipts_and_Credit_Note__c();
        src1.Booking__c = b1.Id;
        src1.Status__c = 'New';
        src1.Payment_term_key__c = 'BD01';
        src1.Clearing_Date__c = system.today();
        src1.Doc_Type_Description__c = 'CHEQUE_BOUNCE';
        insert src1; 
        
        src1.Status__c = 'Cheque bounce';
        update src1;
        SAP_Receipts_and_Credit_Note__c src2 = new SAP_Receipts_and_Credit_Note__c();
        src2.Booking__c = b.Id;
        src2.Status__c = 'CLEAR';
        src2.Payment_term_key__c = '';
        src2.Doc_Type_Description__c = 'RECEIPT';
        src2.Clearing_Date__c = system.today();
        insert src2;
        
        SAP_Receipts_and_Credit_Note__c src4 = new SAP_Receipts_and_Credit_Note__c();
        src4.Booking__c = b.Id;
        src4.Status__c = 'CLEAR';
        src2.Payment_term_key__c = 'BD01';
        src4.Doc_Type_Description__c = 'RECEIPT';
        src4.Clearing_Date__c = system.today();
        insert src4;
        
        src4.Payment_term_key__c = 'BD01';
     //   update src4;
        
        SAP_Receipts_and_Credit_Note__c src3 = new SAP_Receipts_and_Credit_Note__c();
        src3.Booking__c = b.Id;
        src3.Status__c = 'Cheque bounce';
        src3.Payment_term_key__c = 'BD01';
        src3.Clearing_Date__c = system.today();
        src3.Doc_Type_Description__c = 'CHEQUE_BOUNCE';
        insert src3;
        
        Test.stopTest();   
    }
   
    
}
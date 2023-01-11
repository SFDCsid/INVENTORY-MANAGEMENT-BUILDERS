@isTest
Public Class Test_REST_FlowReceiptsOAuth{
    @isTest
    public static void FlowReceipt(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
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
        
        Test.StartTest();
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
        b.Sales_Document_SAP__c = '0671900182';
        b.Customer_Code__c = '0033500184';
        b.Token_Amount_Clearence__c = false;
        //b.Token_Amount_Clearence_Date__c = system.today();
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
        //b1.Sales_Document_SAP__c = '0671900182';
        //b1.Customer_Code__c = '0033500184';
        b1.Token_Amount_Clearence__c = false;
        //b.Token_Amount_Clearence_Date__c = system.today();
        b1.Registration_Process_Email__c = false;
        b1.RM_User__c = UserInfo.getUserId();
        b1.Site_Support__c = UserInfo.getUserId();
        b1.Central_Support__c = UserInfo.getUserId();
        b1.AR_Support__c = UserInfo.getUserId();
   
        insert b1;
        
        List<REST_FlowReceiptsOAuth.ReceiptsCreditList> RCL = new List<REST_FlowReceiptsOAuth.ReceiptsCreditList>();
        
        REST_FlowReceiptsOAuth.ReceiptsCreditList RC = new REST_FlowReceiptsOAuth.ReceiptsCreditList();
        RC.SO_NO = '0671900182';
        RC.CUST_NO = '0033500184';
        RC.BELNR = '1400000026';
        RC.BUKRS = '1100';
        RC.GJAHR = '2021';
        RC.BLART = 'DZ';
        RC.LTEXT = 'RECEIPT';
        RC.STATUS = 'Cleared';
        RC.BLDAT = '2021-09-24';
        RC.BUDAT = '2021-09-24';
        RC.CPUDT = '2021-09-24';
        RC.AUGDT = '2021-09-24';
        RC.ZTERM = 'BD01';
        RC.DUE_DATE = '2021-09-24';
        RC.ZUONR = '444124';
        RC.DMBTR = '5249476';
        RC.TAX_AMOUNT = '1000';
        RC.SGTXT = 'Booking Amt + GST Agst Flat No.A-0602';
        RC.DC_TYPE = '2021-09-24';
        RC.PROP_DTL = unitId;
        RC.BOOK_DATE = '2021-09-24';
        RC.ALLOT_DATE = '2021-09-24';
        RC.URL = '';
        RC.MODE_OF_PAY = 'CHEQUE';
        RC.SUB_AMT = '100';
        RC.CUST_LINE_ITEM = '365238.10';
        RC.CONT_BANK_NAME = 'NEFT HDFC Bank';
        RC.BANK_AMT = '1000';
        RC.PROFIT_CENTER = 'AM10';
        RC.ASSIGNMENT = 'NEFT HDFC Bank';
        RC.VALUT = '2021-09-24';
        RCL.add(RC);
        
        REST_FlowReceiptsOAuth.FlowReceiptsOAuth(RCL);
        
        List<REST_FlowReceiptsOAuth.ReceiptsCreditList> RCL1 = new List<REST_FlowReceiptsOAuth.ReceiptsCreditList>();
        
        REST_FlowReceiptsOAuth.ReceiptsCreditList RC1 = new REST_FlowReceiptsOAuth.ReceiptsCreditList();
        RC1.SO_NO = '0671900182';
        RC1.CUST_NO = '0033500184';
        RC1.BELNR = '1400000026';
        RC1.BUKRS = '1100';
        RC1.GJAHR = '2021';
        RC1.BLART = 'DZ';
        RC1.LTEXT = 'RECEIPT';
        RC1.STATUS = 'Cleared';
        RC1.BLDAT = '2021-09-24';
        RC1.BUDAT = '2021-09-24';
        RC1.CPUDT = '2021-09-24';
        RC1.AUGDT = '2021-09-24';
        RC1.ZTERM = 'BD01';
        RC1.DUE_DATE = '2021-09-24';
        RC1.ZUONR = '444124';
        RC1.DMBTR = '5249476';
        RC1.TAX_AMOUNT = '1000';
        RC1.SGTXT = 'Booking Amt + GST Agst Flat No.A-0602';
        RC1.DC_TYPE = '2021-09-24';
        RC1.PROP_DTL = unitId;
        RC1.BOOK_DATE = '2021-09-24';
        RC1.ALLOT_DATE = '2021-09-24';
        RC1.URL = '';
        RC1.MODE_OF_PAY = 'CHEQUE';
        RC.SUB_AMT = '100';
        RC.CUST_LINE_ITEM = '365238.10';
        RC.CONT_BANK_NAME = 'NEFT HDFC Bank';
        RC.BANK_AMT = '1000';
        RC.PROFIT_CENTER = 'AM10';
        RC.ASSIGNMENT = 'NEFT HDFC Bank';
        RC.VALUT = '2021-09-24';
        RCL1.add(RC1);
        
        REST_FlowReceiptsOAuth.FlowReceiptsOAuth(RCL);
        
        List<REST_FlowReceiptsOAuth.ReceiptsCreditList> RCL2 = new List<REST_FlowReceiptsOAuth.ReceiptsCreditList>();
        
        REST_FlowReceiptsOAuth.ReceiptsCreditList RC2 = new REST_FlowReceiptsOAuth.ReceiptsCreditList();
        RC2.SO_NO = '';
        RC2.CUST_NO = '';
        RC2.BELNR = '1400000026';
        RC2.BUKRS = '1100';
        RC2.GJAHR = '2021';
        RC2.BLART = 'DZ';
        RC2.LTEXT = 'RECEIPT';
        RC2.STATUS = 'Cleared';
        RC2.BLDAT = '2021-09-24';
        RC2.BUDAT = '2021-09-24';
        RC2.CPUDT = '2021-09-24';
        RC2.AUGDT = '2021-09-24';
        RC2.ZTERM = 'BD01';
        RC2.DUE_DATE = '2021-09-24';
        RC2.ZUONR = '444124';
        RC2.DMBTR = '5249476';
        RC2.TAX_AMOUNT = '1000';
        RC2.SGTXT = 'Booking Amt + GST Agst Flat No.A-0602';
        RC2.DC_TYPE = '2021-09-24';
        RC2.PROP_DTL = unitId;
        RC2.BOOK_DATE = '2021-09-24';
        RC2.ALLOT_DATE = '2021-09-24';
        RC2.URL = '';
        RC2.MODE_OF_PAY = 'CHEQUE';
        RC.SUB_AMT = '100';
        RC.CUST_LINE_ITEM = '365238.10';
        RC.CONT_BANK_NAME = 'NEFT HDFC Bank';
        RC.BANK_AMT = '1000';
        RC.PROFIT_CENTER = 'AM10';
        RC.ASSIGNMENT = 'NEFT HDFC Bank';
        RC.VALUT = '2021-09-24';
        RCL2.add(RC2);
        
        REST_FlowReceiptsOAuth.FlowReceiptsOAuth(RCL2);
        Test.stopTest();
    }
}
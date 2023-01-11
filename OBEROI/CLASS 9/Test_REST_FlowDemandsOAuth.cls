@isTest
Public Class Test_REST_FlowDemandsOAuth{
    @isTest
    public static void FlowDemands(){
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
        
        List<REST_FlowDemandsOAuth.DEMANDINVOICEList> DIL = new List<REST_FlowDemandsOAuth.DEMANDINVOICEList>();
        
        REST_FlowDemandsOAuth.DEMANDINVOICEList DI = new REST_FlowDemandsOAuth.DEMANDINVOICEList();
        DI.SO_NO = '0671900182';
        DI.CUST_NO = '0033500184';
        DI.INV_NO = '0818000204';
        DI.INV_DATE = '2021-09-24';
        DI.CC = '1000';
        DI.PROP_DTL = unitId;
        DI.DUE_DATE = '2021-09-24';
        DI.MILESTONE = 'Booking';
        DI.NET_AMOUNT = 3777035;
        DI.TAX_AMOUNT = 188853;
        DI.TOTAL_AMOUNT = 3965888;
        DI.PRE_OS = 0;
        DI.BOOK_DATE = '2021-09-24';
        DI.ALLOT_DATE = '2021-09-24';
        DI.URL = '';
        DI.REFERENE_NO = 'IV0000000904';
        DIL.add(DI);
        
        REST_FlowDemandsOAuth.FlowDemandsOAuth(DIL);
        
        List<REST_FlowDemandsOAuth.DEMANDINVOICEList> DIL1 = new List<REST_FlowDemandsOAuth.DEMANDINVOICEList>();
        
        REST_FlowDemandsOAuth.DEMANDINVOICEList DI1 = new REST_FlowDemandsOAuth.DEMANDINVOICEList();
        DI1.SO_NO = '0671900182';
        DI1.CUST_NO = '0033500184';
        DI1.INV_NO = '0818000204';
        DI1.INV_DATE = '2021-09-24';
        DI1.CC = '1000';
        DI1.PROP_DTL = unitId;
        DI1.DUE_DATE = '2021-09-24';
        DI1.MILESTONE = 'Booking';
        DI1.NET_AMOUNT = 3777035;
        DI1.TAX_AMOUNT = 188853;
        DI1.TOTAL_AMOUNT = 3965888;
        DI1.PRE_OS = 0;
        DI1.BOOK_DATE = '2021-09-24';
        DI1.ALLOT_DATE = '2021-09-24';
        DI1.URL = '';
        DI1.REFERENE_NO = 'IV0000000904';
        DIL1.add(DI1);
        
        REST_FlowDemandsOAuth.FlowDemandsOAuth(DIL1);
        
        List<REST_FlowDemandsOAuth.DEMANDINVOICEList> DIL2 = new List<REST_FlowDemandsOAuth.DEMANDINVOICEList>();
        
        REST_FlowDemandsOAuth.DEMANDINVOICEList DI2 = new REST_FlowDemandsOAuth.DEMANDINVOICEList();
        DI2.SO_NO = '';
        DI2.CUST_NO = '0033500184';
        DI2.INV_NO = '0818000204';
        DI2.INV_DATE = '2021-09-24';
        DI2.CC = '1000';
        DI2.PROP_DTL = unitId;
        DI2.DUE_DATE = '2021-09-24';
        DI2.MILESTONE = 'Booking';
        DI2.NET_AMOUNT = 3777035;
        DI2.TAX_AMOUNT = 188853;
        DI2.TOTAL_AMOUNT = 3965888;
        DI2.PRE_OS = 0;
        DI2.BOOK_DATE = '2021-09-24';
        DI2.ALLOT_DATE = '2021-09-24';
        DI2.URL = '';
        DI2.REFERENE_NO = 'IV0000000904';
        DIL2.add(DI2);
        
        REST_FlowDemandsOAuth.FlowDemandsOAuth(DIL2);
 
        List<REST_CancelDemandOAuth.CancelDemandInvoiceList> CDIL = new List<REST_CancelDemandOAuth.CancelDemandInvoiceList>();
        
        REST_CancelDemandOAuth.CancelDemandInvoiceList CDI = new REST_CancelDemandOAuth.CancelDemandInvoiceList();
        CDI.SO_NO = '0671900182';
        CDI.CUST_NO = '0033500184';
        CDI.INV_NO = '0818000204';
        CDI.CANCEL_IND = 'X';
        CDI.CANCEL_DATE = System.Today();
        CDIL.add(CDI);
        
        REST_CancelDemandOAuth.CancelDemandOAuth(CDIL);
        
        List<REST_CancelDemandOAuth.CancelDemandInvoiceList> CDIL1 = new List<REST_CancelDemandOAuth.CancelDemandInvoiceList>();
        
        REST_CancelDemandOAuth.CancelDemandInvoiceList CDI1 = new REST_CancelDemandOAuth.CancelDemandInvoiceList();
        CDI1.SO_NO = '';
        CDI1.CUST_NO = '0033500184';
        CDI1.INV_NO = '0818000204';
        CDI1.CANCEL_IND = '';
        CDI1.CANCEL_DATE = System.Today();
        CDIL1.add(CDI1);
        
        REST_CancelDemandOAuth.CancelDemandOAuth(CDIL1);
   
    }
}
@isTest
Public Class Test_REST_DemandAgeingOAuth{
    @isTest
    public static void DemandAgeingOAuth(){
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
        
        SAP_Demands_and_Debits__c sdd = new SAP_Demands_and_Debits__c();
        sdd.Invoice_Number__c = '0818000204';
        sdd.Sales_Order_Number__c = '0671900375';
        sdd.Customer_No__c = '0033500270';
        sdd.Booking__c = b.id;
        insert sdd;
        
        List<REST_DemandAgeingOAuth.DemandAgeingList> DAL = new List<REST_DemandAgeingOAuth.DemandAgeingList>();
        
        REST_DemandAgeingOAuth.DemandAgeingList DA = new REST_DemandAgeingOAuth.DemandAgeingList();
        DA.INV_NO = '0818000204';
        DA.AGEING_0_3 = '9244992.84';
        DA.AGEING_4_22 = '9244993.84';
        DA.AGEING_23_52 = '9244994.84';
        DA.AGEING_53_82 = '9244995.84';
        DA.AGEING_83_112 = '9244996.84';
        DA.AGEING_112 = '9244997.84';
        DA.BILLING_STAGE = 'Agreement Execution';
        DAL.add(DA);
        
        REST_DemandAgeingOAuth.DemandAgeingOAuth(DAL);
        
        List<REST_DemandAgeingOAuth.DemandAgeingList> DAL1 = new List<REST_DemandAgeingOAuth.DemandAgeingList>();
        
        REST_DemandAgeingOAuth.DemandAgeingList DA1 = new REST_DemandAgeingOAuth.DemandAgeingList();
        DA1.INV_NO = '';
        DA1.AGEING_0_3 = '9244992.84';
        DA1.AGEING_4_22 = '9244993.84';
        DA1.AGEING_23_52 = '9244994.84';
        DA1.AGEING_53_82 = '9244995.84';
        DA1.AGEING_83_112 = '9244996.84';
        DA1.AGEING_112 = '9244997.84';
        DA1.BILLING_STAGE = 'Agreement Execution';
        DAL1.add(DA1);
        
        REST_DemandAgeingOAuth.DemandAgeingOAuth(DAL1);
        
        List<REST_DemandAgeingOAuth.DemandAgeingList> DAL2 = new List<REST_DemandAgeingOAuth.DemandAgeingList>();
        
        REST_DemandAgeingOAuth.DemandAgeingList DA2 = new REST_DemandAgeingOAuth.DemandAgeingList();
        DA2.INV_NO = '0819000426';
        DA2.AGEING_0_3 = '9244992.84';
        DA2.AGEING_4_22 = '9244993.84';
        DA2.AGEING_23_52 = '9244994.84';
        DA2.AGEING_53_82 = '9244995.84';
        DA2.AGEING_83_112 = '9244996.84';
        DA2.AGEING_112 = '9244997.84';
        DA2.BILLING_STAGE = 'Agreement Execution';
        DAL2.add(DA2);
        
        REST_DemandAgeingOAuth.DemandAgeingOAuth(DAL2);
        
        
        
     }
     
}
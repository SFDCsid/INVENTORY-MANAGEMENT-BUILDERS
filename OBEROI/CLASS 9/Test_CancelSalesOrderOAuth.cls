@isTest
Public Class Test_CancelSalesOrderOAuth{
    @isTest
    public static void CancelSalesOrderOAuth(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Test Komal',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id,OwnerId = UserInfo.getUserId());
        insert opp;
        
        
        SAP_Credentials_Master__c SCM2 = New SAP_Credentials_Master__c();
        SCM2.Name = 'Sales Order Creation';
        SCM2.URL__c = 'http://110.173.186.14:8003/zsfdcapi/salesorder_create?sap-client=100';
        SCM2.User_ID__c = 'Stetig';
        SCM2.Password__c = 'Stetig#2021';
        Insert SCM2;
        
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
        
        
        
        Car_Parking__c carp1 = new Car_Parking__c();
        carp1.Name = 'OEY-CP-SINGLE';
        carp1.Active__c = True;
        carp1.Project__c = projectId;
        carp1.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        carp1.Status__c = 'Allotted';
        carp1.Additional_Earmarked__c = 'Earmarked';
        Insert carp1;
        
        Car_Parking__c carp2 = new Car_Parking__c();
        carp2.Name = 'OEY-CP-Tandem';
        carp2.Active__c = True;
        carp2.Project__c = projectId;
        carp2.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        carp2.Status__c = 'Allotted';
        carp2.Additional_Earmarked__c = 'Earmarked';
        Insert carp2;
        
        Car_Parking__c carp3 = new Car_Parking__c();
        carp3.Name = 'OEY-CP-SINGLE';
        carp3.Active__c = True;
        carp3.Project__c = projectId;
        carp3.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        carp3.Status__c = 'Allotted';
        carp3.Additional_Earmarked__c = 'Additional';
        Insert carp3;
        
        Car_Parking__c carp4 = new Car_Parking__c();
        carp4.Name = 'OEY-CP-SINGLE';
        carp4.Active__c = True;
        carp4.Project__c = projectId;
        carp4.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        carp4.Status__c = 'Allotted';
        carp4.Additional_Earmarked__c = 'Earmarked';
        Insert carp4;
        
        Car_Parking__c carp5 = new Car_Parking__c();
        carp5.Name = 'OEY-CP-Tandem';
        carp5.Active__c = True;
        carp5.Project__c = projectId;
        carp5.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        carp5.Status__c = 'Allotted';
        carp5.Additional_Earmarked__c = 'Earmarked';
        Insert carp5;
        
        Car_Parking__c carp6 = new Car_Parking__c();
        carp6.Name = 'OEY-CP-Tandem';
        carp6.Active__c = True;
        carp6.Project__c = projectId;
        carp6.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        carp6.Status__c = 'Allotted';
        carp6.Additional_Earmarked__c = 'Additional';
        Insert carp6;
        
        Car_Parking__c carp7 = new Car_Parking__c();
        carp7.Name = 'OEY-CP-Tandem';
        carp7.Active__c = True;
        carp7.Project__c = projectId;
        carp7.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        carp7.Status__c = 'Allotted';
        carp7.Additional_Earmarked__c = 'Additional';
        Insert carp7;
        
        List<QuotationManagmentServices.AdditionalChargesWrapper> additionalCharges = Quotation.getAdditionChargsList(proprtyId);
        string othercharges_serialize = JSON.serialize(additionalCharges);
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, false, 0);
        
        string sap_serialize = JSON.serialize(SAPChrges);

        List<QuotationManagmentServices.PlanDetailsWrapper> planDetails = Quotation.getPlanDetail(sap_serialize,planId,unitId);
        string planDetails_serialize = JSON.serialize(planDetails);
        
        
        
        string discountList_serialize = '[]'; // = JSON.serialize(discountList);
        string carParKList = '["TANDEM",1,100000]'; //= '[]'; //
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
        
        Quotation__c Q = new Quotation__c();
        Q.id = qid;
        Q.booking__c = b.id;
        q.Earmarked_Car_Parking_Type_1__c = '';
        q.Earmarked_Car_Parking_Count_1__c = 0;
        q.Earmarked_Car_Parking_Type_2__c = '';
        q.Earmarked_Car_Parking_Count_2__c = 0;
        q.Car_Park_Type_1__c = '';
        q.Car_Park_Count_1__c = 0;
        q.Car_Park_Type_2__c = '';
        q.Car_Park_Count_2__c = 0;
        update q;
        
        REST_CancelSalesOrderOAuth.CancelSalesOrderOAuth('0671900182','0033500184','507','Test',system.today(),'0987676564');
        REST_CancelSalesOrderOAuth.CancelSalesOrderOAuth('','0033500184','507','Test',system.today(),'0987676564');
        REST_CancelSalesOrderOAuth.CancelSalesOrderOAuth('0671900182','','507','Test',system.today(),'0987676564');
        REST_CancelSalesOrderOAuth.CancelSalesOrderOAuth('0671900182','0033500184','','Test',system.today(),'0987676564');
        REST_CancelSalesOrderOAuth.CancelSalesOrderOAuth('0671900182','0033500184','507','',system.today(),'0987676564');
        REST_CancelSalesOrderOAuth.CancelSalesOrderOAuth('0671900182','0033500184','507','Test',null,'');
        
        opp.old_booking__c = b.id;
        Update opp;
        
        Test.StartTest();
        PageReference pageRef2 = Page.SO_Change_Vf;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('qId',q.Id);
        SyncPaymentPlan SO = new SyncPaymentPlan();
        SO.flow();
        SO.incrementCounter();
        SO.BackToBooking();
        //Test.StopTest(); 
        
        //Test.StartTest();
        PageReference pageRef3 = Page.ROFR_Quotation;
        Test.setCurrentPage(pageRef3);
        pageRef3.getParameters().put('optyId',opp.Id);
        ROFRQuotation ROFR = new ROFRQuotation();
        ROFR.Save();
        ROFR.Cancel();
        ROFR.CheckValidation();
        Test.StopTest(); 
     }
     
      @isTest
    public static void Release_parking(){
        
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Test Komal',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id,OwnerId = UserInfo.getUserId());
        insert opp;
        
        
        SAP_Credentials_Master__c SCM2 = New SAP_Credentials_Master__c();
        SCM2.Name = 'Sales Order Creation';
        SCM2.URL__c = 'http://110.173.186.14:8003/zsfdcapi/salesorder_create?sap-client=100';
        SCM2.User_ID__c = 'Stetig';
        SCM2.Password__c = 'Stetig#2021';
        Insert SCM2;
        
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
        string carParKList =  '[]'; //'["TANDEM",1,100000]'; //=
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
        
        Car_Parking__c carp = new Car_Parking__c();
        carp.Name = 'OEY-CP-SINGLE';
        carp.Active__c = True;
        carp.Project__c = projectId;
        carp.Remarks__c = 'OEY-CP-SINGLE - 1 NO.';
        carp.Status__c = 'Allotted';
        carp.Additional_Earmarked__c = 'Additional';
        Insert carp;
        
        Car_Parking__c carp1 = new Car_Parking__c();
        carp1.Name = 'OEY-CP-SINGLE';
        carp1.Active__c = True;
        carp1.Project__c = projectId;
        carp1.Remarks__c = 'OEY-CP-SINGLE';
        carp1.Status__c = 'Allotted';
        carp1.Additional_Earmarked__c = 'Earmarked';
        Insert carp1;
        
        Car_Parking__c carp2 = new Car_Parking__c();
        carp2.Name = 'OEY-CP-SINGLE';
        carp2.Active__c = True;
        carp2.Project__c = projectId;
        carp2.Remarks__c = 'OEY-CP-SINGLE - 1 NO.';
        carp2.Status__c = 'Allotted';
        carp2.Additional_Earmarked__c = 'Additional';
        Insert carp2;
        
        Car_Parking__c carp3 = new Car_Parking__c();
        carp3.Name = 'OEY-CP-SINGLE';
        carp3.Active__c = True;
        carp3.Project__c = projectId;
        carp3.Remarks__c = 'OEY-CP-SINGLE';
        carp3.Status__c = 'Allotted';
        carp3.Additional_Earmarked__c = 'Earmarked';
        Insert carp3;
        
        Car_Parking__c carp4 = new Car_Parking__c();
        carp4.Name = 'OEY-CP-TANDEM';
        carp4.Active__c = True;
        carp4.Project__c = projectId;
        carp4.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        carp4.Status__c = 'Allotted';
        carp4.Additional_Earmarked__c = 'Earmarked';
        Insert carp4;
        
        Car_Parking__c carp5 = new Car_Parking__c();
        carp5.Name = 'OEY-CP-TANDEM';
        carp5.Active__c = True;
        carp5.Project__c = projectId;
        carp5.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        carp5.Status__c = 'Allotted';
        carp5.Additional_Earmarked__c = 'Earmarked';
        Insert carp5;
        
        Car_Parking__c carp6 = new Car_Parking__c();
        carp6.Name = 'OEY-CP-TANDEM';
        carp6.Active__c = True;
        carp6.Project__c = projectId;
        carp6.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        carp6.Status__c = 'Allotted';
        carp6.Additional_Earmarked__c = 'Additional';
        Insert carp6;
        
        Car_Parking__c carp7 = new Car_Parking__c();
        carp7.Name = 'OEY-CP-TANDEM';
        carp7.Active__c = True;
        carp7.Project__c = projectId;
        carp7.Remarks__c = 'ELYSIAN TOWER A CARPARK - SINGLE - 1 NO.';
        carp7.Status__c = 'Allotted';
        carp7.Additional_Earmarked__c = 'Additional';
        Insert carp7;
        
        
        Quotation__c Q = new Quotation__c();
        Q.id = qid;
        Q.booking__c = b.id;
        q.Earmarked_Car_Parking_Type_1__c = 'TANDEM';
        q.Earmarked_Car_Parking_Count_1__c = 1;
        q.Earmarked_Car_Parking_Type_2__c = 'SINGLE';
        q.Earmarked_Car_Parking_Count_2__c = 1;
        q.Car_Park_Type_1__c = 'TANDEM';
        q.Car_Park_Count_1__c = 1;
        q.Car_Park_Type_2__c = 'SINGLE';
        q.Car_Park_Count_2__c = 1;
        update q;
        
        REST_CancelSalesOrderOAuth.releaseCarParks(q.id);

    }
     
}
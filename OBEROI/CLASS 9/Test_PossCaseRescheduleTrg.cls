@isTest
Public Class Test_PossCaseRescheduleTrg{
    @isTest
    public static void PossCaseReschedule(){
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
        string qId1 = Quotation.saveQuotation(sap_serialize, othercharges_serialize, discountList_serialize, planDetails_serialize, carParKList, fieldSet);
        
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
        b.Quotation__c = qId1;
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
        
        Case_Owner_Assignment_Matrix__c co = new Case_Owner_Assignment_Matrix__c();
        co.Case_Stage_Name__c = 'Confirm Reg schedule';
        co.Case_Stage_Owner__c = 'RM';
        co.Name = 'Possession';
        insert co;
      
        Entitlement ent = new Entitlement(Name='Case Process 2', AccountId = ac.Id, 
        StartDate = System.today(),
        EndDate = System.today().addDays(15));
        insert ent;
        
        Case c = new Case();
        c.EntitlementId = ent.Id;
        c.Booking__c = b.id;
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Possession').getRecordTypeId();
        c.Status = 'New';
        c.Stage__c = 'Proceed with Possession';
        c.Origin = 'Email';
        c.Type = 'Possession';
        c.Priority = 'Medium';
        
        c.Request_received_date__c = system.today();
        c.Possession_request_raised_by_RM_date__c = system.today();
        c.Possession_checklist_initiation_date__c = system.today();
        c.Possession_Checklist_received_from_CS_L1__c = system.today();
        c.Possession_Checklist_cleared_by_CS_L2__c = system.today();
        c.Possession_Checklist_cleared_by_AR__c = true;
        c.Possession_Scheduled_Date_1__c = system.today();
        c.Possession_Scheduled_Date_2__c = system.today();
        c.Possession_Scheduled_Date_3__c = system.today();
        c.Possession_Scheduled_Date_4__c = system.today();
        c.Possession_Scheduled_Date_5__c = system.today(); 
        c.Request_Rece_from_RM_to_release_Poss_Doc__c = true;
        c.Possession_Doc_Submission_to_CS_L2_date__c = system.today();
        c.CS_L2_Verification_date__c = system.today();
        c.Submission_to_Authorized_Signatory__c = system.today();
        c.Date_of_Possession_Doc_recd_by_RM__c = system.today();  
       
        insert c;
        
        Checklist__c ch = new Checklist__c();
        ch.Name = 'Possession';
        ch.Case__c = c.id;
        ch.Recordtypeid = Schema.SObjectType.Checklist__C.getRecordTypeInfosByName().get('Possession').getRecordTypeId();
        insert ch;
        
        Test.startTest();
        c.Next_Action__c = 'Possession Rejected';
        c.Date_of_Possession_Rejection_Rescheduled__c = system.today();
        c.Customer_Feedback__c = 'Possession Rejection';
        c.Reason_for_Poss_Rejection_Rescheduling__c = 'Car Park issue'; 
        update c;
        Test.stopTest();
    
    }
}
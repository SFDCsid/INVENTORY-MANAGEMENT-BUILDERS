@isTest
public class Test_GetBrokerageIntimationNote{
    @isTest
    Public static void GetBrokerageNote(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Account ac1 = new Account(Name = 'Test CP demo',Broker_Code__c = '0033101428',recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId());
        insert ac1;
        
        Opportunity opp = new Opportunity(Name = 'Test Komal',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id,OwnerId = UserInfo.getUserId(),Broker_Account__c=ac1.id,Enquiry_Type__c = 'Partner');
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
        
        Channel_Partner_Project__c cpp = new Channel_Partner_Project__c();
        cpp.Extended__c = false;
        cpp.Account__c = ac1.id;
        insert cpp;
        
        Booking__c b = new Booking__C();
        b.Opportunity__c = opp.id;
        b.Booking_Date__c = system.today();
        //b.Acceptance_Form_Template__c = 'Acceptance_Form';
        b.Status__c = 'Booking In Process';
        b.Future_Correspondence_Contact_Email__c = 'Email@gmail.com';
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
        b.Billing_Plan_flown_to_SAP__c = True;
        b.Pricing_Flown_to_SAP__c = True;
        b.RM_User__c = UserInfo.getUserId();
        b.Site_Support__c = UserInfo.getUserId();
        b.Central_Support__c = UserInfo.getUserId();
        b.AR_Support__c = UserInfo.getUserId();
   
        insert b;
        
        MD_Approval__c md = new MD_Approval__c();
        md.Booking__c = b.id;
        md.Approval_Name__c = 'Brokerage Release';
        md.Department__c = 'Sales';
        //md.Approval_Process_Name__c = 'No Deviation - Brokerage release process';
        md.Comments__c = 'Test';
        insert md;
        
        SAP_Credentials_Master__c SCM = New SAP_Credentials_Master__c();
        SCM.Name = 'Brokerage Intimation Note';
        SCM.URL__c = 'http://110.173.186.22:8003/zsfdcapi/broker_form?sap-client=100';
        SCM.User_ID__c = 'Stetig';
        SCM.Password__c = 'Oberoi@1';
        Insert SCM;
        
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the');
           
            ContentVersion contentVersion_1 = new ContentVersion(
                Title='SampleTitle',
                PathOnClient ='SampleTitle.pdf',
                VersionData = bodyBlob,
                origin = 'H'
            );
         insert contentVersion_1;
         
         ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId
                            FROM ContentVersion WHERE Id = :contentVersion_1.Id ];
           
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId =md.Id;
            contentlink.contentdocumentid = contentVersion_2.ContentDocumentId;
            contentlink.ShareType = 'V';
            insert contentlink;
        
        Test.StartTest();
        PageReference pageRef2 = Page.Get_Brokerage_Intimation_Note;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('Id',md.Id);
        GetBrokerageIntimationNote GBN = new GetBrokerageIntimationNote();
        GBN.GetDocument();
        GBN.BackToBooking();
        GBN.SaveToBooking();
        
        PageReference pageRef1 = Page.Broker_MDApproval_Page;
            Test.setCurrentPage(pageRef1);
            BrokerMDApprovalCont bcon = new BrokerMDApprovalCont();
            bcon.BMDId = md.Id;
            bcon.getCreateDocList();
        Test.StopTest();    
    }
    
     static testMethod void testParse() {
        String json = '{\"EP_XSTRING\":\"JVBERi0xLjMNCiXi48/TDQolUlNUWFBERjMgUGFyYW1ldGVyczogRFJTVFhoDQoyIDAgb2JqDQo8PA0KL0ZpbHRlciAzIDAgUg0KL0VnN0YXJ0eHJlZg0KNDg2NTcNCiUlRU9GDQo=\",\"ERROR_MESSAGE\":\"\"}';
        GetBrokerageStatementJ2A obj = GetBrokerageStatementJ2A.parse(json);
        System.assert(obj != null);
    }
}
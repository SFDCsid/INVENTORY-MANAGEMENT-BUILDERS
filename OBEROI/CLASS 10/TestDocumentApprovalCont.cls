@isTest
public class TestDocumentApprovalCont {
  @isTest
    public static void TestDocumentApprovalCont(){
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
        
        Annexures_Documents__c ad = new Annexures_Documents__c();
        ad.Name = 'Agreement Form';
        ad.Document_Name__c = 'Agreement Form';
        ad.Project__c = projectId;
        ad.Property__c = unitId;
        ad.Tower__c = towerId;
        insert ad;
        
        Blob bodyBlob1 =Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the');
           
            ContentVersion contentVersion_11 = new ContentVersion(
                Title='SampleTitle',
                PathOnClient ='SampleTitle.pdf',
                VersionData = bodyBlob1,
                origin = 'H'
            );
            insert contentVersion_11;
           
            ContentVersion contentVersion_21 = [SELECT Id, Title, ContentDocumentId
                            FROM ContentVersion WHERE Id = :contentVersion_11.Id LIMIT 1];
           
            ContentDocumentLink contentlink1 = new ContentDocumentLink();
            contentlink1.LinkedEntityId = ad.Id;
            contentlink1.contentdocumentid = contentVersion_21.ContentDocumentId;
            contentlink1.ShareType = 'V';
            insert contentlink1;
        
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
        
        Related_Document_History__c rdh = new Related_Document_History__c();
        rdh.Name = 'Agreement Form';
        rdh.Document_Name__c = 'Agreement Form';
        rdh.Document_Generated_Date_Time__c = system.today();
        rdh.Booking__c = b.id;
        rdh.Opportunity__c = opp.id;
        insert rdh;
        
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
            contentlink.LinkedEntityId =rdh.Id;
            contentlink.contentdocumentid = contentVersion_2.ContentDocumentId;
            contentlink.ShareType = 'V';
            insert contentlink;
            
            Test.StartTest();
            
            PageReference pageRef2 = Page.Doc_Approval_page;
            Test.setCurrentPage(pageRef2);
            DocumentApprovalCont bcon = new DocumentApprovalCont();
            bcon.RDHId = rdh.Id;
            bcon.getCreateDocList();
        DocumentApprovalCont.dum();
            Test.StopTest();
    }
}
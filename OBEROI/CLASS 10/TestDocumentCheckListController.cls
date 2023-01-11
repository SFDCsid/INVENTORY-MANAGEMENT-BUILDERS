@isTest
public class TestDocumentCheckListController {
  @isTest
    public static void TestDocumentCheckList(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Bhagyashree',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Mr Bhagyashree Test Stetig',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id);
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
        
        //Property__c property = Quotation.getProperty(unitId);
       // Opportunity op = Quotation.getOpportunity(opp.Id);
        
       // List<QuotationManagmentServices.AdditionalChargesWrapper> additionalCharges = Quotation.getAdditionChargsList(proprtyId);
        string othercharges_serialize = '[]';// = JSON.serialize(additionalCharges);
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, false, 0);
        
        string sap_serialize = JSON.serialize(SAPChrges);

        List<QuotationManagmentServices.PlanDetailsWrapper> planDetails = Quotation.getPlanDetail(sap_serialize,planId,unitId);
        string planDetails_serialize = JSON.serialize(planDetails);
        
        string discountList_serialize = '[]'; // = JSON.serialize(discountList);
        string carParKList = '[]'; //= '["TANDEM",1,100000]'; 
        string fieldSet = '[{"label":"unitId","value":"' + unitId +'"},{"label":"editschedule","value":false},{"label":"oppId","value":"' + opp.id +'"},{"label":"additionalComments","value":""},{"label":"selectedPlan","value":"' + planId + '"},{"label":"changeInSource","value":false},{"label":"revisedBookingSource","value":null},{"label":"referredBy","value":null},{"label":"referProject","value":null},{"label":"referTower","value":null},{"label":"referFlat","value":null},{"label":"referEmpCode","value":null}]';
        string qId = Quotation.saveQuotation(sap_serialize, othercharges_serialize, discountList_serialize, planDetails_serialize, carParKList, fieldSet);
        
        Booking__c b = new Booking__C();
        b.Opportunity__c = opp.id;
        b.Booking_Date__c = system.today();
        b.Acceptance_Form_Template__c = 'Acceptance_Form';
        b.Status__c = 'Booking In Process';
        //b.Booking_Through__c = 'Direct';
        b.Quotation__c = qId;
        b.Default_Address_of__c = '1st Applicant';
        b.Project__c = projectId;
        b.Tower__c = towerId;
        b.Property__c = unitId;
        b.Site_Head__c = UserInfo.getUserId();
        insert b;
        
        Applicant__c ap = new Applicant__c();
        ap.Booking__C = b.id;
        ap.Applicant_Number__c = 'Primary Applicant';
        ap.Opportunity__c = opp.id;
        ap.Type_Of_Applicant__c = 'Individual Buyer';
        ap.PancardNo__c = 'ABCDE1234E';
        ap.Salutation__c = 'Capt.';
        ap.Applicant_Type__c = 'Primary';
        ap.Name = 'Primary Applicant';
        ap.Mobile_Number__c = '1234567890';
        ap.Nationality__c = 'Indian';
        ap.Subtype_Of_Applicant__c = 'Indian National';
        ap.Mailing_Address_same_as_PermanentAddress__c = true;
        ap.House_No__c = 'House';
        ap.Street_1__c = 'Street1';
        ap.Street_2__c = 'Street2';
        ap.City__c = 'Mumbai';
        insert ap;
        
        Applicant__c ap2 = new Applicant__c();
        ap2.Booking__C = b.id;
        ap2.Applicant_Number__c = 'Second Applicant';
        ap2.Opportunity__c = opp.id;
        ap2.Type_Of_Applicant__c = 'Individual Buyer';
        ap2.PancardNo__c = 'ABCDE1234E';
        ap2.Salutation__c = 'Capt.';
        ap2.Applicant_Type__c = 'Second';
        ap2.Name = 'Second Applicant';
        ap2.Mobile_Number__c = '1234567890';
        ap2.Nationality__c = 'Indian';
        ap2.Subtype_Of_Applicant__c = 'Indian National';
        ap2.Mailing_Address_same_as_PermanentAddress__c = true;
        ap2.House_No__c = 'House';
        ap2.Street_1__c = 'Street1';
        ap2.Street_2__c = 'Street2';
        ap2.City__c = 'Mumbai';
        insert ap2;
        
        Applicant__c ap3 = new Applicant__c();
        ap3.Booking__C = b.id;
        ap3.Applicant_Number__c = 'Third Applicant';
        ap3.Opportunity__c = opp.id;
        ap3.Type_Of_Applicant__c = 'Individual Buyer';
        ap3.PancardNo__c = 'ABCDE1234E';
        ap3.Salutation__c = 'Capt.';
        ap3.Applicant_Type__c = 'Third';
        ap3.Name = 'Third Applicant';
        ap3.Mobile_Number__c = '1234567890';
        ap3.Nationality__c = 'Indian';
        ap3.Subtype_Of_Applicant__c = 'Indian National';
        ap3.Mailing_Address_same_as_PermanentAddress__c = true;
        ap3.House_No__c = 'House';
        ap3.Street_1__c = 'Street1';
        ap3.Street_2__c = 'Street2';
        ap3.City__c = 'Mumbai';
        insert ap3;
        
        Applicant__c ap4 = new Applicant__c();
        ap4.Booking__C = b.id;
        ap4.Applicant_Number__c = 'Fourth Applicant';
        ap4.Opportunity__c = opp.id;
        ap4.Type_Of_Applicant__c = 'Individual Buyer';
        ap4.PancardNo__c = 'ABCDE1234E';
        ap4.Salutation__c = 'Capt.';
        ap4.Applicant_Type__c = 'Fourth';
        ap4.Name = 'Fourth Applicant';
        ap4.Mobile_Number__c = '1234567890';
        ap4.Nationality__c = 'Indian';
        ap4.Subtype_Of_Applicant__c = 'Indian National';
        ap4.Mailing_Address_same_as_PermanentAddress__c = true;
        ap4.House_No__c = 'House';
        ap4.Street_1__c = 'Street1';
        ap4.Street_2__c = 'Street2';
        ap4.City__c = 'Mumbai';
        insert ap4;
        
        Applicant__c ap5 = new Applicant__c();
        ap5.Booking__C = b.id;
        ap5.Applicant_Number__c = 'Fifth Applicant';
        ap5.Opportunity__c = opp.id;
        ap5.Type_Of_Applicant__c = 'Individual Buyer';
        ap5.PancardNo__c = 'ABCDE1234E';
        ap5.Salutation__c = 'Capt.';
        ap5.Applicant_Type__c = 'Fifth';
        ap5.Name = 'Fifth Applicant';
        ap5.Mobile_Number__c = '1234567890';
        ap5.Nationality__c = 'Indian';
        ap5.Subtype_Of_Applicant__c = 'Indian National';
        ap5.Mailing_Address_same_as_PermanentAddress__c = true;
        ap5.House_No__c = 'House';
        ap5.Street_1__c = 'Street1';
        ap5.Street_2__c = 'Street2';
        ap5.City__c = 'Mumbai';
        insert ap5;
        
        opportunity opr = new Opportunity();
        opr.id = opp.id;
        opr.Booking__c = b.id;
        opr.Property__c = unitId;
        opr.project__c = projectId;
        update opr;
        
        Property__c pr = new Property__c();
        pr.id = unitId;
        pr.status__C = 'BIP - Sales';
        update pr;
        
        Test.StartTest();
       
        PageReference pRef4 = Page.DocumentCheckListPage;
        Test.setCurrentPage(pRef4);
        ApexPages.currentPage().getParameters().put('Id',b.Id);
        DocumentCheckListController adf = new DocumentCheckListController();
        //adf.reject();
        for(Integer i : adf.WP.keySet()){
            adf.docHeader.put('Level_1_Verified'+ i +'__c',true);
        }
        for(Integer i : adf.WPAPP.keySet()){
            adf.applicantDocument1.put('Level_1_Verified'+ i +'__c',true);
        }
        for(Integer i : adf.WPAPP.keySet()){
            adf.applicantDocument2.put('Level_1_Verified'+ i +'__c',true);
        }
        for(Integer i : adf.WPAPP.keySet()){
            adf.applicantDocument3.put('Level_1_Verified'+ i +'__c',true);
        }
        for(Integer i : adf.WPAPP.keySet()){
            adf.applicantDocument4.put('Level_1_Verified'+ i +'__c',true);
        }
        for(Integer i : adf.WPAPP.keySet()){
            adf.applicantDocument5.put('Level_1_Verified'+ i +'__c',true);
        }        
        adf.accept();
        //adf.SendMail();
        adf.home();
        
        PageReference pRef5 = Page.DocumentCheckListPage;
        Test.setCurrentPage(pRef5);
        ApexPages.currentPage().getParameters().put('Id',b.Id);
        DocumentCheckListController adf2 = new DocumentCheckListController();
        //adf.reject();
        for(Integer i : adf2.WP.keySet()){
            adf2.docHeader.put('Level_2_Verified'+ i +'__c',false);
            adf2.docHeader.put('Remarks'+ i +'__c','ok');
        }
        for(Integer i : adf2.WPAPP.keySet()){
            adf2.applicantDocument1.put('Level_2_Verified'+ i +'__c',false);
            adf2.applicantDocument1.put('Remarks'+ i +'__c','ok');
        }
        for(Integer i : adf2.WPAPP.keySet()){
            adf2.applicantDocument2.put('Level_2_Verified'+ i +'__c',false);
            adf2.applicantDocument2.put('Remarks'+ i +'__c','ok');
        }
        for(Integer i : adf2.WPAPP.keySet()){
            adf2.applicantDocument3.put('Level_2_Verified'+ i +'__c',false);
            adf2.applicantDocument3.put('Remarks'+ i +'__c','ok');
        }
        for(Integer i : adf2.WPAPP.keySet()){
            adf2.applicantDocument4.put('Level_2_Verified'+ i +'__c',false);
            adf2.applicantDocument4.put('Remarks'+ i +'__c','ok');
        }
        for(Integer i : adf2.WPAPP.keySet()){
            adf2.applicantDocument5.put('Level_2_Verified'+ i +'__c',false);
            adf2.applicantDocument5.put('Remarks'+ i +'__c','ok');
        }        
        adf2.reject();
        
        Test.StopTest();
    }
    
   
}
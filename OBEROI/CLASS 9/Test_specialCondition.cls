@isTest
Public Class Test_specialCondition{
    @isTest
    public static void ConditionOne(){
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
        
        //List<QuotationManagmentServices.AdditionalChargesWrapper> additionalCharges = Quotation.getAdditionChargsList(proprtyId);
        string othercharges_serialize = '[]';//JSON.serialize(additionalCharges);
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, false, 0);
        
        string sap_serialize = JSON.serialize(SAPChrges);

        List<QuotationManagmentServices.PlanDetailsWrapper> planDetails = Quotation.getPlanDetail(sap_serialize,planId,unitId);
        string planDetails_serialize = JSON.serialize(planDetails);
        
        string discountList_serialize = '[]'; // = JSON.serialize(discountList);
        string carParKList = '[]'; //= '["TANDEM",1,100000]'; 
        string fieldSet = '[{"label":"unitId","value":"' + unitId +'"},{"label":"editschedule","value":false},{"label":"oppId","value":"' + opp.id +'"},{"label":"additionalComments","value":""},{"label":"selectedPlan","value":"' + planId + '"},{"label":"changeInSource","value":false},{"label":"revisedBookingSource","value":null},{"label":"referredBy","value":null},{"label":"referProject","value":null},{"label":"referTower","value":null},{"label":"referFlat","value":null},{"label":"referEmpCode","value":null}]';
        string qId = Quotation.saveQuotation(sap_serialize, othercharges_serialize, discountList_serialize, planDetails_serialize, carParKList, fieldSet);
        
        string st1 = QuotationManagmentServices.INFormat(10);
        
        Booking__c b = new Booking__C();
        b.Opportunity__c = opp.id;
        b.Booking_Date__c = system.today();
        b.Acceptance_Form_Template__c = 'Acceptance_Form';
        b.Agreement_Form_Template__c = 'Agreement_Form';
        b.Allotment_Form_Template__c = 'Allotment_Form';
        b.Status__c = 'Booking In Process';
        //b.Booking_Through__c = 'Direct';
        if(qId!=null){
           if(qId.contains(',')){
               qId = qId.substring(0, qId.lastIndexOf(','));
           }
           b.Quotation__c = qId;  
        }
        b.Default_Address_of__c = '1st Applicant';
        b.Project__c = projectId;
        b.Tower__c = towerId;
        b.Property__c = unitId;
        insert b;
        
        Test.StartTest();
        PageReference pageRef2 = Page.Special_Condition_Page;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('id', b.id);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(b);
        
        String itc = '{!Booking__c.Future_Correspondence_Contact_Name__c}{!Account.LastName}{!Opportunity.Name}{!Project__c.ITC_BENEFIT__c}{!Tower__c.Tower_Name__c}{!Property__c.Carpet_Area__c}The Promoter shall, subject to the condition mentioned in Clause 3.5 in the Agreement, pass on to the Allottee/s the input tax credit benefit (“ITC Benefit”) of Rs.{!Quotation__c.ITC_Benefit__c} (Rupees  Only) as and when the invoices are raised';
        specialCondition sc = new specialCondition();
        List<SelectOption> pickListValuesList = sc.gettags;
        sc.createHTMLText();
        sc.Save();
        sc.preparemergefield();
        sc.Back();
        sc.findAndReplaceMergeFields(itc,b.id);
        Test.StopTest();
       
     }
  }
@isTest
public class TestPropertyManagementServices {
    @isTest
    public static void testProp(){
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
        ID ppl = dataMap.get('AG01');
        
        Quotation__C q = new Quotation__c();
        q.Opportunity__C = opp.id;
        q.Property__C = unitId;
        q.Billing_Plan__c = planId;
        q.Total_Agreement_Value_Modified__c = 100000;
        q.Project__c = projectId;
        q.Tower__c = towerId;
        q.Carpet_Area__c = 1000;
        q.Quote_Status__c = 'Valid';
        q.Final_Approved_Date__c = system.today();
        q.Customized_Billing_Plan__c = false;
        q.Discount_Applied__c = false;
        q.Revised_Booking_Source__c = 'Direct';
        q.Brokerage_Percentage__c = 2;
        q.Referred_By__c = 'abc';
        q.Referred_Project__c = 'abc';
        q.Referred_Tower__c = 'abc';
        q.Referred_Flat__c = 'abc';
        q.Referred_EMP_code__c = 'abc';
       // q.Referred_Tower__c = 'abc';
        insert q;
        update q;
        
        Test.StartTest();
        Payment_Plan_Line_Item__c pll = new Payment_Plan_Line_Item__c();
        pll.id = ppl;
        pll.Payment_Date__c = system.today().addDays(31);
        update pll;
        delete pll;
        
        
       /* PageReference pageRef = Page.Quotation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('unitId', unitId);
        pageRef.getParameters().put('oppId', opp.Id);
        
        Property__c property = Quotation.getProperty(unitId);
        Opportunity op = Quotation.getOpportunity(opp.Id);
        List<QuotationManagmentServices.CarParkWrapper> parkingList = Quotation.getCarParkingList(projectId);
        Map<string, Decimal> parkingCharges = Quotation.getParkingCharges(projectId);
        List<Discount__c> discountList = Quotation.getDiscountList(projectId);
        
        List<QuotationManagmentServices.AdditionalChargesWrapper> additionalCharges = Quotation.getAdditionChargsList(proprtyId);
        string othercharges_serialize = JSON.serialize(additionalCharges);
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, true, 12000);
        List<Payment_Plan__C> billingList = Quotation.getBillingPlanList(towerId);
        
        string sap_serialize = JSON.serialize(SAPChrges);
        //string earmarkedParking = Quotation.getEarmarkedParkingDetails(unitId);
        SAPChrges = Quotation.applyCarParking(sap_serialize,100000,unitId,1000,false,0);
        sap_serialize = JSON.serialize(SAPChrges);
        
        Object discount = JSON.deserializeStrict(JSON.serialize(discountList[0]),Discount__c.class);
        string discount_serialize = JSON.serialize(discount);
        
        SAPChrges = Quotation.applyDiscount(sap_serialize,discount_serialize,unitId,1000,true,100000);
        sap_serialize = JSON.serialize(SAPChrges);
        
        SAPChrges = Quotation.removeDiscount(sap_serialize,discount_serialize,unitId,100000);
        sap_serialize = JSON.serialize(SAPChrges);
        
        Discount__c dis = Quotation.getAppliedDiscounts(sap_serialize,discount_serialize,unitId,1000,true);

        List<QuotationManagmentServices.PlanDetailsWrapper> planDetails = Quotation.getPlanDetail(sap_serialize,planId,unitId);
        string planDetails_serialize = JSON.serialize(planDetails);
        QuotationManagmentServices.PlanDetailsWrapper pdNew = new QuotationManagmentServices.PlanDetailsWrapper();
        string pdNew_serialize = JSON.serialize(pdNew);
        
        planDetails = Quotation.addPlanRow(planDetails_serialize,pdNew_serialize,planDetails.size());
        planDetails.Clear();
        planDetails = Quotation.getPlanDetail(sap_serialize,planId,unitId);
        system.debug('planDetails::: '+planDetails.size());
        planDetails_serialize = JSON.serialize(planDetails);
        
        planDetails = Quotation.updatePlanDetails(planDetails_serialize,sap_serialize);
        planDetails_serialize = JSON.serialize(planDetails);
        string st = Quotation.INFormat(10);
        
        string discountList_serialize = JSON.serialize(discountList);
        string carParKList = '["TANDEM",1,100000]'; 
        string fieldSet = '[{"label":"unitId","value":"' + unitId +'"},{"label":"editschedule","value":false},{"label":"oppId","value":"' + opp.id +'"},{"label":"additionalComments","value":""},{"label":"selectedPlan","value":"' + planId + '"},{"label":"changeInSource","value":false},{"label":"revisedBookingSource","value":null},{"label":"referredBy","value":null},{"label":"referProject","value":null},{"label":"referTower","value":null},{"label":"referFlat","value":null},{"label":"referEmpCode","value":null}]';
        string qId = Quotation.saveQuotation(sap_serialize, othercharges_serialize, discountList_serialize, planDetails_serialize, carParKList, fieldSet);
        
        string st1 = QuotationManagmentServices.INFormat(10);
        
        set<Id> unId = new Set<Id>();
        set<Id> bpId = new Set<Id>();
        set<Id> quotId = new Set<Id>();
        set<Id> oppId = new Set<Id>();
        
        unId.add(unitId);
        bpId.add(planId);
        quotId.add(qId);
        oppId.add(opp.Id);
        
        PropertyManagementServices.InactiveQuotation(unId, bpId, quotID, oppId);
        PropertyManagementServices.InactivePaymentPlan(bpId);*/
        Test.StopTest();
    }
}
@isTest
public class TestQuotationApprovalComments {
    @isTest
    public static void testQuote(){
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
        
        Test.StartTest();
        PageReference pageRef = Page.Quotation;
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
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, false, 0);
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
        QuotationApprovalComments qp = new QuotationApprovalComments();
        qp.QuotationId = qId;
        qp.createQuotationList();
        qp.getLastApprovalStep();
        string st2 = qp.comments;
        Test.StopTest();
    }

}
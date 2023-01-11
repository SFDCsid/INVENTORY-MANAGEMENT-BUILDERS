@isTest
public class TestQuotation {
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
        property.Floor_No__c=25;
        update property;
        
       Property__c pp = new Property__c();
        pp.Floor_No__c = 25;
        pp.Project_Name__c = projectId;
        pp.Property_Type__c = property.Property_Type__c;
        insert pp;
        pp.Floor_No__c = 45;
        update pp;
        
         Property__c pp2 = new Property__c();
        pp2.Floor_No__c = 49;
        pp2.Project_Name__c = projectId;
        pp2.Property_Type__c = property.Property_Type__c;
        insert pp2;
        pp2.Floor_No__c =15;
        update pp2;
        
        Opportunity op = Quotation.getOpportunity(opp.Id);
        List<QuotationManagmentServices.CarParkWrapper> parkingList = Quotation.getCarParkingList(projectId);
        Map<string, Decimal> parkingCharges = Quotation.getParkingCharges(projectId);
        List<Discount__c> discountList = Quotation.getDiscountList(projectId);
        
        List<QuotationManagmentServices.AdditionalChargesWrapper> additionalCharges = Quotation.getAdditionChargsList(proprtyId);
        string othercharges_serialize = JSON.serialize(additionalCharges);
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, true, 12000);
        List<Payment_Plan__C> billingList = Quotation.getBillingPlanList(towerId);
        
        billingList[0].Type_Of_Billing_Plan__c='Bank Subvention';
        update billingList;
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
        
        if(qId.contains(',')){
           qId = qId.substring(0, qId.indexOf(','));  
        }
        
        List<project__c> plist = [SELECT ID,Name,Sanction_SalePrice_Percentage__c,Sanction_GST_Percentage__c FROM project__c WHERE ID=:projectId];
        plist[0].Sanction_SalePrice_Percentage__c = 75;
        plist[0].Sanction_GST_Percentage__c = 5;   
        update plist;
        Quotation__c qq= new Quotation__c();
           qq.id=qId;
           qq.Actual_Sanction_Received__c=120000;
        update qq;
        
        PageReference pageRef2 = Page.ViewQuotation;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('qId', qId);
        ViewQuotation vq = new ViewQuotation();
        
        PageReference pageRef3 = Page.QuotationApprovalTemplate;
        Test.setCurrentPage(pageRef3);
        pageRef3.getParameters().put('qId', qId);
        QuotationApprovalTemplate vqt = new QuotationApprovalTemplate();
        
        Test.StopTest();
    }
}
@isTest
private class Payment_Plan_ExtnCTRLTest {
    private static testmethod void paymentPlanTestMethod(){
        
        Payment_Plan_ExtnCTRL paymentPlanExtnCTRL = new Payment_Plan_ExtnCTRL();
        
        List<Account> accounts = TestDataFactory.createAccounts(1);
        Insert accounts;
        
        List<Opportunity> opportunities = TestDataFactory.createOpportunity(1);
        opportunities[0].accountId = accounts[0].id;
        Insert opportunities;
        
        List<Tower__c> towerList = TestDataFactory.createTowers(1);
        Insert towerList;
        
        List<Payment_Plan__c> paymentPlanListParent = TestDataFactory.createBillingPlan(1); 
        paymentPlanListParent[0].Discount_On_Basic_Cost__c = 10;
        paymentPlanListParent[0].Discount_Amount_On_Floor_Rise_Cost__c = 10;
        paymentPlanListParent[0].Discount_On_PLC_Cost__c = 10;
        paymentPlanListParent[0].Status__c = 'Approved'; 
        paymentPlanListParent[0].Active__c = true;
        paymentPlanListParent[0].Tower__c = towerList[0].id;
        
        Insert paymentPlanListParent;
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItemList = TestDataFactory.createBillingPlanLineItem(paymentPlanListParent);
        Insert billingPlanLineItemList;
        // system.debug('billingPlanLineItemList---------->'+billingPlanLineItemList);
        
        List<Payment_Plan__c> paymentPlanList = TestDataFactory.createBillingPlan(1); 
        paymentPlanList[0].Discount_On_Basic_Cost__c = 10;
        paymentPlanList[0].Discount_Amount_On_Floor_Rise_Cost__c = 10; 
        paymentPlanList[0].Discount_On_PLC_Cost__c = 10;
        paymentPlanList[0].Related_Jodi_Billing_Plan__c =paymentPlanListParent[0].id; 
        paymentPlanList[0].Tower__c = paymentPlanListParent[0].Tower__c;
        
        Insert paymentPlanList;
        //system.debug('paymentPlanList-------->'+paymentPlanList);
        
        List<Co_Owner__c> coowners = new List<Co_Owner__c>();
        Co_Owner__c coowner = new Co_Owner__c(Opportunity__c=paymentPlanList[0].Opportunity__c, Person_Account__c=accounts[0].id);
        coowners.add(coowner);
        Insert coowners; 
        
        paymentPlanExtnCTRL.billingPlanId = paymentPlanListParent[0].id;
        test.startTest();
        Payment_Plan_ExtnCTRL.BillingPaymentLI paymentPlanInnerClass = new Payment_Plan_ExtnCTRL.BillingPaymentLI();
        Payment_Plan__c paymentPlan = paymentPlanExtnCTRL.billingPlan;
        test.stopTest();        
    }
    
    private static testmethod void paymentPlanTestMethod2(){
        
        Payment_Plan_ExtnCTRL paymentPlanExtnCTRL = new Payment_Plan_ExtnCTRL();
        
        List<Account> accounts = TestDataFactory.createAccounts(1);
        Insert accounts;
        
        List<Opportunity> opportunities = TestDataFactory.createOpportunity(1);
        opportunities[0].accountId = accounts[0].id;
        Insert opportunities;
        
        List<Tower__c> towerList = TestDataFactory.createTowers(1);
        Insert towerList;
        
        List<Payment_Plan__c> paymentPlanListParent = TestDataFactory.createBillingPlan(1); 
        
        paymentPlanListParent[0].Discount_On_Basic_Cost__c = 10;
        paymentPlanListParent[0].Discount_Amount_On_Floor_Rise_Cost__c = 10;
        paymentPlanListParent[0].Discount_On_PLC_Cost__c = 10;
        paymentPlanListParent[0].Status__c = 'Approved'; 
        paymentPlanListParent[0].Active__c = true;
        paymentPlanListParent[0].Tower__c = towerList[0].id;
        
        Insert paymentPlanListParent;
        
        system.debug('paymentPlanListParent---->'+paymentPlanListParent);
        
        List<Payment_Plan__c> paymentPlanList = TestDataFactory.createBillingPlan(1); 
        paymentPlanList[0].Discount_On_Basic_Cost__c = 10;
        paymentPlanList[0].Discount_Amount_On_Floor_Rise_Cost__c = 10;
        paymentPlanList[0].Discount_On_PLC_Cost__c = 10;
        paymentPlanList[0].Related_Jodi_Billing_Plan__c =paymentPlanListParent[0].id;
        paymentPlanList[0].Tower__c = paymentPlanListParent[0].Tower__c;
        
        Insert paymentPlanList;
        //system.debug('paymentPlanList-------->'+paymentPlanList);
        
        List<Payment_Plan__c> jodipaymentPlanList = TestDataFactory.createBillingPlan(1);
        jodipaymentPlanList[0].Discount_On_Basic_Cost__c = 10;
        jodipaymentPlanList[0].Discount_Amount_On_Floor_Rise_Cost__c = 10; 
        jodipaymentPlanList[0].Discount_On_PLC_Cost__c = 10;
        jodipaymentPlanList[0].Related_Jodi_Billing_Plan__c =paymentPlanListParent[0].id;
        jodipaymentPlanList[0].Opportunity__c =opportunities[0].id;
        jodipaymentPlanList[0].Tower__c = paymentPlanListParent[0].Tower__c;
        Insert jodipaymentPlanList;
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItemListForChild = TestDataFactory.createBillingPlanLineItem(jodipaymentPlanList);
        Insert billingPlanLineItemListForChild;
        //system.debug('billingPlanLineItemListForChild---------->'+billingPlanLineItemListForChild);
        
        List<Co_Owner__c> coowners = new List<Co_Owner__c>();
        Co_Owner__c coowner = new Co_Owner__c(Opportunity__c=jodipaymentPlanList[0].Opportunity__c, Person_Account__c=accounts[0].id);
        coowners.add(coowner);
        Insert coowners; 
        if(!jodipaymentPlanList.isEmpty()){
            paymentPlanExtnCTRL.billingPlanId = jodipaymentPlanList[0].id;
            
            test.startTest();
            Payment_Plan_ExtnCTRL.BillingPaymentLI paymentPlanInnerClass = new Payment_Plan_ExtnCTRL.BillingPaymentLI();
            Billing_Plan_Line_Item__c baseLineItem = paymentPlanInnerClass.baseLineItem;
            List<Billing_Plan_Line_Item__c> customLineItem = paymentPlanInnerClass.customLineItem;
            List<Billing_Plan_Line_Item__c> customJodiLineItem = paymentPlanInnerClass.customJodiLineItem;
            Payment_Plan__c paymentPlan = paymentPlanExtnCTRL.billingPlan;
            Date dt = paymentPlanExtnCTRL.pdate;
            test.stopTest();    
        }
    }
    
    
}
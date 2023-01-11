@istest
private class SchemePayment_Plan_ExtnCTRLTest {
    
    static testmethod void billingPlanTest(){
        
        SchemePayment_Plan_ExtnCTRL schemePaymentPlan = new SchemePayment_Plan_ExtnCTRL();
        
        List<Account> accounts = TestDataFactory.createAccounts(1);
        Insert accounts;
        
        List<Opportunity> opportunities = TestDataFactory.createOpportunity(1);
        opportunities[0].accountId = accounts[0].id;
        Insert opportunities;
        
        List<Payment_Plan__c> paymentPlanListParent = TestDataFactory.createBillingPlan(1); 
        paymentPlanListParent[0].Discount_On_Basic_Cost__c = 10;
        paymentPlanListParent[0].Discount_Amount_On_Floor_Rise_Cost__c = 10; 
        //paymentPlanListParent[0].Scheme_Billing_Plan__c = paymentPlanListParent[0].id;
       // paymentPlanListParent[0].RecordType.DeveloperName = 'Scheme_Billing_Plan';
        Insert paymentPlanListParent;
        
        List<Payment_Plan__c> paymentPlanList = TestDataFactory.createBillingPlan(1); 
        paymentPlanList[0].Discount_On_Basic_Cost__c = 10;
        paymentPlanList[0].Discount_Amount_On_Floor_Rise_Cost__c = 10; 
        paymentPlanList[0].Related_Jodi_Billing_Plan__c =paymentPlanListParent[0].id;
        paymentPlanList[0].Scheme_Billing_Plan__c = paymentPlanListParent[0].id;
        //paymentPlanList[0].RecordType.DeveloperName = 'Scheme_Billing_Plan';
        Insert paymentPlanList;
        
        List<Co_Owner__c> coowners = new List<Co_Owner__c>();
        Co_Owner__c coowner = new Co_Owner__c(Opportunity__c=opportunities[0].id, Person_Account__c=accounts[0].id);
        coowners.add(coowner);
        Insert coowners;
        
        schemePaymentPlan.billingPlanId = paymentPlanList[0].id;
        test.startTest();
        SchemePayment_Plan_ExtnCTRL.BillingPaymentLI schemePaymentPlanInnerClass = new SchemePayment_Plan_ExtnCTRL.BillingPaymentLI();
        Payment_Plan__c paymentPlan = schemePaymentPlan.billingPlan;
        test.stopTest(); 
    }
    
}
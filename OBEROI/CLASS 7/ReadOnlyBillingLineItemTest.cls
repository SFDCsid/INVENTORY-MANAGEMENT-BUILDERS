@isTest(SeeAllData=false)

public class ReadOnlyBillingLineItemTest{
    
    @isTest
    static void testgetBillingPlan() {
        Id ppId;   
        
        List<Payment_Plan__c> paymentPlanList = TestDataFactory.createBillingPlan(1);
        Insert paymentPlanList;
        system.debug('paymentPlanList---------->'+paymentPlanList); 
        
        List<Billing_Plan_Line_Item__c> billingPlanLineItemList = TestDataFactory.createBillingPlanLineItem(paymentPlanList);
        Insert billingPlanLineItemList;
        system.debug('billingPlanLineItemList---------->'+billingPlanLineItemList);
        
        for(Payment_Plan__c paymentPlan:paymentPlanList){
            ppId = paymentPlan.Id;
            system.debug('ppId---------->'+ppId);
        }  
        Test.startTest();
        if(!String.isBlank(ppId)){
            // ReadOnlyBillingLineItem.getBillingPlan(ppId);
            system.debug('ppId------->'+ppId);
            ReadOnlyBillingLineItem.getBillingPlanDetails(ppId);
                }
        test.stopTest();
    }
    @isTest
    static void testgetBillingPlanNegativeScenario() {
        Id ppId;
        
        List<Tower__c> towerList = TestDataFactory.createTowers(1);
        Insert towerList;
        List<Payment_Plan__c> paymentPlanList = TestDataFactory.createBillingPlan(1);
        Insert paymentPlanList;
        system.debug('paymentPlanList---------->'+paymentPlanList); 
        
        //List<Billing_Plan_Line_Item__c> billingPlanLineItemList = TestDataFactory.createBillingPlanLineItem(paymentPlanList);
        //Insert billingPlanLineItemList;
        //system.debug('billingPlanLineItemList---------->'+billingPlanLineItemList);
        
        for(Payment_Plan__c paymentPlan:paymentPlanList){
            ppId = paymentPlan.Id;
            system.debug('ppId---------->'+ppId);
        }  
        Test.startTest();
        if(!String.isBlank(ppId)){
            // ReadOnlyBillingLineItem.getBillingPlan(ppId);
            system.debug('ppId------->'+ppId);
            ReadOnlyBillingLineItem.getBillingPlanLineItem(ppId);
                }
        test.stopTest();
    }
}
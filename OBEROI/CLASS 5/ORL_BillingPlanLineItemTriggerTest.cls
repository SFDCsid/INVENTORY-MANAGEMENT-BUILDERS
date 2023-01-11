@isTest
public class ORL_BillingPlanLineItemTriggerTest {
    
    @isTest
    public static void unitTest(){
        List<Payment_Plan__c> paymentPLan=TestDataFactory.createBillingPlan(1);
        insert paymentPLan;
        List<Billing_Plan_Line_Item__c> billingList=TestDataFactory.createBillingPlanLineItem(paymentPLan);
         insert billingList;
        
    }
    

}
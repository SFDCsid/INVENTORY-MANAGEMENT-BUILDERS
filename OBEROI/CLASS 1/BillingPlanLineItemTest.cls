@isTest
public class BillingPlanLineItemTest {
    
    @testSetup
    static void testDataSetup(){
        List<Opportunity> oppList=TestDataFactory.createOpportunity(1);
        insert oppList;
        
        List<Project__c> projects = TestDataFactory.createResProject(1);
        insert projects;
        
        List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].Opportunity__c = oppList[0].Id;
        paymentPlans[0].Payment_Plan_Type__c = 'Non Scheme';   
        paymentPlans[0].active__c = true;
        paymentPlans[0].project__C = projects[0].Id;
        
        List<Tower__c> towers = TestDataFactory.createTowers(1);
        towers[0].Project_Name__c = paymentPlans[0].Project__c;
        insert towers;
        
        paymentPlans[0].Tower__c = towers[0].Id;
        insert paymentPlans;
        
        
    }
    
    static testMethod void testCreateBillingLineItemsFutureScenario1()
    {
       List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c];

        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem1 = new Billing_Plan_Line_Item__c();
        billingPlanLineItem1.Payment_Plan__c = paymentPlans[0].Id;
		billingPlanLineItem1.Milestone_Number__c  = '1';  
        billingPlanLineItem1.Terms_of_Payment_Key__c = 'IND';
        billingPlanLineItems.add(billingPlanLineItem1);        
        insert billingPlanLineItems;
        
        List<Payment_Plan_Line_Item__c> paymentPlanLineItems = new List<Payment_Plan_Line_Item__c>();
        Payment_Plan_Line_Item__c paymentPlanLineItem = new Payment_Plan_Line_Item__c();
        paymentPlanLineItem.Payment_Plan__c =  paymentPlans[0].Id;
		paymentPlanLineItem.Terms_of_Payment_Key__c = 'IND';
        paymentPlanLineItem.Milestone_Number__c = '1';
        paymentPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '50';
        paymentPlanLineItems.add(paymentPlanLineItem);
        insert paymentPlanLineItems;
        
        BillingPlanLineItem.createBillingLineItemsFuture(paymentPlans[0].Id);
    }
    
    static testMethod void testCreateBillingLineItemsFutureScenario2()
    {
       List<Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c];

        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem2 = new Billing_Plan_Line_Item__c();
        billingPlanLineItem2.Payment_Plan__c = paymentPlans[0].Id;
        billingPlanLineItem2.Terms_of_Payment_Key__c = 'IND';
        billingPlanLineItems.add(billingPlanLineItem2);       
        insert billingPlanLineItems;
        
        List<Payment_Plan_Line_Item__c> paymentPlanLineItems = new List<Payment_Plan_Line_Item__c>();
        Payment_Plan_Line_Item__c paymentPlanLineItem = new Payment_Plan_Line_Item__c();
        paymentPlanLineItem.Payment_Plan__c =  paymentPlans[0].Id;
		paymentPlanLineItem.Terms_of_Payment_Key__c = 'IND';
        paymentPlanLineItem.Milestone_Number__c = '0';
        paymentPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '50';
        paymentPlanLineItems.add(paymentPlanLineItem);
        insert paymentPlanLineItems;
        
        BillingPlanLineItem.createBillingLineItemsFuture(paymentPlans[0].Id);
    }
    
    static testMethod void testCreateBillingLineItemsFutureScenario3()
    {
        list <Payment_Plan__c> paymentPlans = [select Id from Payment_Plan__c];
        List<Billing_Plan_Line_Item__c> billingPlanLineItems = new List<Billing_Plan_Line_Item__c>();
        Billing_Plan_Line_Item__c billingPlanLineItem3 = new Billing_Plan_Line_Item__c();
        billingPlanLineItem3.Payment_Plan__c = paymentPlans[0].Id;
        billingPlanLineItem3.Payment_Plan_Line_Item_Name__c = 'Proportionate';
        billingPlanLineItem3.Milestone_Number__c = '0';
        billingPlanLineItem3.Terms_of_Payment_Key__c = 'IND';
        billingPlanLineItems.add(billingPlanLineItem3);       
        insert billingPlanLineItems;
        
        List<Payment_Plan_Line_Item__c> paymentPlanLineItems = new List<Payment_Plan_Line_Item__c>();
        Payment_Plan_Line_Item__c paymentPlanLineItem = new Payment_Plan_Line_Item__c();
        paymentPlanLineItem.Payment_Plan__c =  paymentPlans[0].Id;
		paymentPlanLineItem.Terms_of_Payment_Key__c = 'IND';
        paymentPlanLineItem.Milestone_Number__c = '0';
        paymentPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '50';
        paymentPlanLineItems.add(paymentPlanLineItem);
        insert paymentPlanLineItems;
        
        BillingPlanLineItem.createBillingLineItemsFuture(paymentPlans[0].Id);
    }

}
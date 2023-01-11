@isTest
public class ORL_SAP_BillingPlanPullInterfaceTest {
    
    @isTest static void testORL_SAP_BillingPlanPullInterfaceTest() {
        
        ORL_SAP_BillingPlanPullInterface.BAPIRET2 obj = new 
            ORL_SAP_BillingPlanPullInterface.BAPIRET2();        
        
        ORL_SAP_BillingPlanPullInterface.ZSD_FM_BILLING_PLAN_element obj2 = new 
            ORL_SAP_BillingPlanPullInterface.ZSD_FM_BILLING_PLAN_element();    
        
        ORL_SAP_BillingPlanPullInterface.ZSDST_BILLING_PLAN obj3 = new 
            ORL_SAP_BillingPlanPullInterface.ZSDST_BILLING_PLAN();    
        
        
        ORL_SAP_BillingPlanPullInterface.ZSD_LEASE_INPUT obj4 = new 
            ORL_SAP_BillingPlanPullInterface.ZSD_LEASE_INPUT();    
        
        
        ORL_SAP_BillingPlanPullInterface.ZSD_FM_BILLING_PLANResponse_element obj5 = new 
            ORL_SAP_BillingPlanPullInterface.ZSD_FM_BILLING_PLANResponse_element();    
        
        
        ORL_SAP_BillingPlanPullInterface.TABLE_OF_BAPIRET2 obj6 = new 
            ORL_SAP_BillingPlanPullInterface.TABLE_OF_BAPIRET2();    
        
        
        ORL_SAP_BillingPlanPullInterface.TABLE_OF_ZSDST_BILLING_PLAN obj7 = new 
            ORL_SAP_BillingPlanPullInterface.TABLE_OF_ZSDST_BILLING_PLAN();    
        
        
        ORL_SAP_BillingPlanPullInterface.zbilling_plan obj8 = new 
            ORL_SAP_BillingPlanPullInterface.zbilling_plan();   
        
        ORL_SAP_BillingPlanPullInterface.TABLE_OF_ZSDST_BILLING_PLAN EX_BILLING_PLAN;
        ORL_SAP_BillingPlanPullInterface.ZSD_LEASE_INPUT IM_INPUT;
        ORL_SAP_BillingPlanPullInterface.TABLE_OF_BAPIRET2 RETURN_x  ;
        
        Test.setMock(WebServiceMock.class, new YourWebServiceMockImpl());
        Test.startTest();
        obj5 = obj8.ZSD_FM_BILLING_PLAN(EX_BILLING_PLAN,IM_INPUT,RETURN_x);
        test.stopTest();
    }        
}
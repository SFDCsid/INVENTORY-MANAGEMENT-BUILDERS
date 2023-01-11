@isTest
public class ORL_SAP_SalesOrderPullInterfaceTest {
    
    @isTest static void testORL_SAP_SalesOrderPullInterfaceTest() {
        
        ORL_SAP_SalesOrderPullInterface.TABLE_OF_ZSDST_SO_BROKER obj = new 
            ORL_SAP_SalesOrderPullInterface.TABLE_OF_ZSDST_SO_BROKER();        
        
        ORL_SAP_SalesOrderPullInterface.TABLE_OF_ZSDST_SO_BILLING_PLAN obj2 = new 
            ORL_SAP_SalesOrderPullInterface.TABLE_OF_ZSDST_SO_BILLING_PLAN();    
        
        ORL_SAP_SalesOrderPullInterface.ZSDST_SO_BILLING_PLAN obj3 = new 
            ORL_SAP_SalesOrderPullInterface.ZSDST_SO_BILLING_PLAN();    
        
        
        ORL_SAP_SalesOrderPullInterface.ZSD_LEASE_INPUT obj4 = new 
            ORL_SAP_SalesOrderPullInterface.ZSD_LEASE_INPUT();    
        
        
        ORL_SAP_SalesOrderPullInterface.ZSDST_SO_BROKER obj5 = new 
            ORL_SAP_SalesOrderPullInterface.ZSDST_SO_BROKER();    
        
        
        ORL_SAP_SalesOrderPullInterface.ZSD_FM_SO_BILLING_PLAN_element obj6 = new 
            ORL_SAP_SalesOrderPullInterface.ZSD_FM_SO_BILLING_PLAN_element();    
        
        
        ORL_SAP_SalesOrderPullInterface.ZSD_FM_SO_BILLING_PLANResponse_element obj7 = new 
            ORL_SAP_SalesOrderPullInterface.ZSD_FM_SO_BILLING_PLANResponse_element();    
        
        
        ORL_SAP_SalesOrderPullInterface.zso_billing_plan obj8 = new 
            ORL_SAP_SalesOrderPullInterface.zso_billing_plan();   
        
        ORL_SAP_SalesOrderPullInterface.TABLE_OF_ZSDST_SO_BILLING_PLAN EX_BILLING_PLAN;
        ORL_SAP_SalesOrderPullInterface.TABLE_OF_ZSDST_SO_BROKER EX_BROKER_DETAILS;
        ORL_SAP_SalesOrderPullInterface.ZSD_LEASE_INPUT IM_INPUT;
        
        Test.setMock(WebServiceMock.class, new YourWebServiceMock());
        Test.startTest();
        
        obj7 = obj8.ZSD_FM_SO_BILLING_PLAN(EX_BILLING_PLAN,EX_BROKER_DETAILS,IM_INPUT);
        
        test.stopTest();
    }
    
    
    private class YourWebServiceMock implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName, 
            String responseType) {
                 ORL_SAP_SalesOrderPullInterface.ZSD_FM_SO_BILLING_PLANResponse_element respElement = 
                    new  ORL_SAP_SalesOrderPullInterface.ZSD_FM_SO_BILLING_PLANResponse_element();
                respElement.EX_BROKER_DETAILS = null;
                response.put('response_x', respElement); 
            }
    }
    
    
}
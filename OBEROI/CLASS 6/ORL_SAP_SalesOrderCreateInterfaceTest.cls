@isTest
public class ORL_SAP_SalesOrderCreateInterfaceTest {
    
    
    @isTest static void testORL_SAP_SalesOrderCreateInterface() {
        ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_ORDER_ITEM obj = new 
            ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_ORDER_ITEM();
        
        ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_HEADER obj1 = new 
            ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_HEADER();
        
        ORL_SAP_SalesOrderCreateInterface.ZVBAK_ADD_FIELDS obj2 = new 
            ORL_SAP_SalesOrderCreateInterface.ZVBAK_ADD_FIELDS();
        
        ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM obj3 = new 
            ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM();
        
        
        ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_BILLING_PLAN obj4 = new 
            ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_BILLING_PLAN();
        
        
        ORL_SAP_SalesOrderCreateInterface.ZSD_FM_SALESORDER_CREATE_element obj5 = new 
            ORL_SAP_SalesOrderCreateInterface.ZSD_FM_SALESORDER_CREATE_element();
        
        
        ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_CONDITION obj6 = new 
            ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_CONDITION();
        
        
        ORL_SAP_SalesOrderCreateInterface.ZSD_FM_SALESORDER_CREATEResponse_element obj7 = new 
            ORL_SAP_SalesOrderCreateInterface.ZSD_FM_SALESORDER_CREATEResponse_element();
        
        
        ORL_SAP_SalesOrderCreateInterface.BAPIRET2 obj8 = new 
            ORL_SAP_SalesOrderCreateInterface.BAPIRET2();
        
        
        
        ORL_SAP_SalesOrderCreateInterface.ZSD_ST_CONDITION obj9 = new 
            ORL_SAP_SalesOrderCreateInterface.ZSD_ST_CONDITION();
        
        
        
        ORL_SAP_SalesOrderCreateInterface.TABLE_OF_BAPIRET2 obj10 = new 
            ORL_SAP_SalesOrderCreateInterface.TABLE_OF_BAPIRET2();
        
        
        
        ORL_SAP_SalesOrderCreateInterface.zcreate_so obj11 = new 
            ORL_SAP_SalesOrderCreateInterface.zcreate_so();
        
        ORL_SAP_SalesOrderCreateInterface.ZSD_ST_BILLING_PLAN obj12 = new 
            ORL_SAP_SalesOrderCreateInterface.ZSD_ST_BILLING_PLAN();
        
        ORL_SAP_SalesOrderCreateInterface.ZSD_FM_SALESORDER_CREATEResponse_element obj13 = new
            ORL_SAP_SalesOrderCreateInterface.ZSD_FM_SALESORDER_CREATEResponse_element();
        
        ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_BILLING_PLAN BILLING_PLAN;
        String CUSTOMERNUMBER;
        ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_CONDITION ORDER_CONDITIONS;
        ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_HEADER ORDER_HEADER;
        ORL_SAP_SalesOrderCreateInterface.ZVBAK_ADD_FIELDS ORDER_HEADER_ADDITIONAL_FIELDS;
        ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_ORDER_ITEM ORDER_ITEMS;
        ORL_SAP_SalesOrderCreateInterface.TABLE_OF_BAPIRET2 RETURN_x;
        
        Test.setMock(WebServiceMock.class, new YourWebServiceMock());
        
        test.startTest();
        obj13 = obj11.ZSD_FM_SALESORDER_CREATE(BILLING_PLAN,CUSTOMERNUMBER,ORDER_CONDITIONS,ORDER_HEADER,ORDER_HEADER_ADDITIONAL_FIELDS,ORDER_ITEMS,RETURN_x);   
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
                ORL_SAP_SalesOrderCreateInterface.ZSD_FM_SALESORDER_CREATEResponse_element respElement = 
                    new ORL_SAP_SalesOrderCreateInterface.ZSD_FM_SALESORDER_CREATEResponse_element ();
                respElement.BILLING_PLAN = null;
                response.put('response_x', respElement); 
            }
    }
}
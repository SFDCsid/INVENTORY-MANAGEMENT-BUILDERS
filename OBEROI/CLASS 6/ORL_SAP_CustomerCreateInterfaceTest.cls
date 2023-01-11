@isTest
public class ORL_SAP_CustomerCreateInterfaceTest {
    
    @isTest static void testORL_SAP_CustomerCreateInterface() {
        
        
        ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_COMMUNICATION obj = new ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_COMMUNICATION();
        ORL_SAP_CustomerCreateInterface.TABLE_OF_ZSDST_CUSTOMER_ADDRESS obj1 = new ORL_SAP_CustomerCreateInterface.TABLE_OF_ZSDST_CUSTOMER_ADDRESS();
        ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_ADDRESS obj4 = new ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_ADDRESS();
        ORL_SAP_CustomerCreateInterface.TABLE_OF_BAPIRET1 obj3 = new ORL_SAP_CustomerCreateInterface.TABLE_OF_BAPIRET1();
        ORL_SAP_CustomerCreateInterface.TABLE_OF_ZSDST_CUSTOMER_COMMUNICATION obj5 = new   ORL_SAP_CustomerCreateInterface.TABLE_OF_ZSDST_CUSTOMER_COMMUNICATION();
        ORL_SAP_CustomerCreateInterface.BAPIRET1 obj6 = new ORL_SAP_CustomerCreateInterface.BAPIRET1();  
        ORL_SAP_CustomerCreateInterface.ZSD_FM_CUSTOMER_CREATE_element obj7 = new ORL_SAP_CustomerCreateInterface.ZSD_FM_CUSTOMER_CREATE_element();  
        ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_HEADER obj8 = new ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_HEADER();     
        ORL_SAP_CustomerCreateInterface.ZSD_FM_CUSTOMER_CREATEResponse_element obj9 = new ORL_SAP_CustomerCreateInterface.ZSD_FM_CUSTOMER_CREATEResponse_element();     
        ORL_SAP_CustomerCreateInterface.zcreate_customer obj10 = new ORL_SAP_CustomerCreateInterface.zcreate_customer();  
        
        ORL_SAP_CustomerCreateInterface.TABLE_OF_ZSDST_CUSTOMER_ADDRESS CUSTOMER_ADDRESS;
        ORL_SAP_CustomerCreateInterface.TABLE_OF_ZSDST_CUSTOMER_COMMUNICATION CUSTOMER_COMMUNICATION;
        ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_HEADER CUSTOMER_HEADER;
        ORL_SAP_CustomerCreateInterface.TABLE_OF_BAPIRET1 RETURN_x;
        
        Test.setMock(WebServiceMock.class, new YourWebServiceMock());
        
        test.startTest();
        obj9 = obj10.ZSD_FM_CUSTOMER_CREATE(CUSTOMER_ADDRESS,CUSTOMER_COMMUNICATION,CUSTOMER_HEADER,RETURN_x);
        Test.stopTest();
        
        
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
                ORL_SAP_CustomerCreateInterface.ZSD_FM_CUSTOMER_CREATEResponse_element respElement = 
                    new ORL_SAP_CustomerCreateInterface.ZSD_FM_CUSTOMER_CREATEResponse_element();
                respElement.CUSTOMERNO = null;
                response.put('response_x', respElement); 
            }
    }
    
}
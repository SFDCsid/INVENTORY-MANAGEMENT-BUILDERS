@istest
public class ORL_SAP_CustomerUpdateInterfaceTest {

     @isTest static void testORL_SAP_CustomerUpdateInterfaceTest() {
        
        ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_COMMUNICATION obj = new 
            ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_COMMUNICATION();      
         
         
        ORL_SAP_CustomerUpdateInterface.TABLE_OF_ZSDST_CUSTOMER_ADDRESS obj1 = new 
            ORL_SAP_CustomerUpdateInterface.TABLE_OF_ZSDST_CUSTOMER_ADDRESS();      
         
         
        ORL_SAP_CustomerUpdateInterface.ZSD_FM_CUSTOMER_CHANGE_element obj2 = new 
            ORL_SAP_CustomerUpdateInterface.ZSD_FM_CUSTOMER_CHANGE_element();      
         
         
        ORL_SAP_CustomerUpdateInterface.TABLE_OF_BAPIRET1 obj3 = new 
            ORL_SAP_CustomerUpdateInterface.TABLE_OF_BAPIRET1();      
         
         
        ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_ADDRESS obj4 = new 
            ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_ADDRESS();      
         
         
        ORL_SAP_CustomerUpdateInterface.TABLE_OF_ZSDST_CUSTOMER_COMMUNICATION obj5 = new 
            ORL_SAP_CustomerUpdateInterface.TABLE_OF_ZSDST_CUSTOMER_COMMUNICATION();      
         
         
        ORL_SAP_CustomerUpdateInterface.BAPIRET1 obj6 = new 
            ORL_SAP_CustomerUpdateInterface.BAPIRET1();      
         
         
        ORL_SAP_CustomerUpdateInterface.ZSD_FM_CUSTOMER_CHANGEResponse_element obj7 = new 
            ORL_SAP_CustomerUpdateInterface.ZSD_FM_CUSTOMER_CHANGEResponse_element();      
         
         
        ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_HEADER_CHANGE obj8 = new 
            ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_HEADER_CHANGE();      
         
         
        ORL_SAP_CustomerUpdateInterface.zchange_customer obj9 = new 
            ORL_SAP_CustomerUpdateInterface.zchange_customer();  
         
         ORL_SAP_CustomerUpdateInterface.TABLE_OF_ZSDST_CUSTOMER_ADDRESS CUSTOMER_ADDRESS;
         ORL_SAP_CustomerUpdateInterface.TABLE_OF_ZSDST_CUSTOMER_COMMUNICATION CUSTOMER_COMMUNICATION;
         ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_HEADER_CHANGE CUSTOMER_HEADER;
         ORL_SAP_CustomerUpdateInterface.TABLE_OF_BAPIRET1 RETURN_x;
         
        Test.setMock(WebServiceMock.class, new YourWebServiceMock());
        
        
        test.startTest();
            
         obj7 = obj9.ZSD_FM_CUSTOMER_CHANGE(CUSTOMER_ADDRESS,CUSTOMER_COMMUNICATION,CUSTOMER_HEADER,RETURN_x);
         
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
                ORL_SAP_CustomerUpdateInterface.ZSD_FM_CUSTOMER_CHANGEResponse_element respElement = 
                    new ORL_SAP_CustomerUpdateInterface.ZSD_FM_CUSTOMER_CHANGEResponse_element();
                respElement.CUSTOMER_ADDRESS = null;
                response.put('response_x', respElement); 
            }
    }
    
}
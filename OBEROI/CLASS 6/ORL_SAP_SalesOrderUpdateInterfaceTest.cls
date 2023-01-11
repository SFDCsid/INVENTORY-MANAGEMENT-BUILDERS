@isTest
public class ORL_SAP_SalesOrderUpdateInterfaceTest {
    
    @isTest static void testORL_SAP_SalesOrderUpdateInterfaceTest() {
        
        ORL_SAP_SalesOrderUpdateInterface.ZSO_HEADER obj = new 
            ORL_SAP_SalesOrderUpdateInterface.ZSO_HEADER();        
        
        ORL_SAP_SalesOrderUpdateInterface.ZVBAK_ADD_FIELDS obj2 = new 
            ORL_SAP_SalesOrderUpdateInterface.ZVBAK_ADD_FIELDS();    
        
        ORL_SAP_SalesOrderUpdateInterface.ZSD_FM_SALESORDER_CHANGE_element obj3 = new 
            ORL_SAP_SalesOrderUpdateInterface.ZSD_FM_SALESORDER_CHANGE_element();    
        
        
        ORL_SAP_SalesOrderUpdateInterface.ZSD_FM_SALESORDER_CHANGEResponse_element obj4 = new 
            ORL_SAP_SalesOrderUpdateInterface.ZSD_FM_SALESORDER_CHANGEResponse_element();    
        
        
        ORL_SAP_SalesOrderUpdateInterface.BAPIRET2 obj5 = new 
            ORL_SAP_SalesOrderUpdateInterface.BAPIRET2();    
        
        
        ORL_SAP_SalesOrderUpdateInterface.TABLE_OF_BAPIRET2 obj6 = new 
            ORL_SAP_SalesOrderUpdateInterface.TABLE_OF_BAPIRET2();    
        
        
        ORL_SAP_SalesOrderUpdateInterface.zchange_so obj7 = new 
            ORL_SAP_SalesOrderUpdateInterface.zchange_so();    
        
        
        ORL_SAP_SalesOrderUpdateInterface.ZSO_HEADER ORDER_HEADER;
        ORL_SAP_SalesOrderUpdateInterface.ZVBAK_ADD_FIELDS ORDER_HEADER_ADDITIONAL_FIELDS;
        ORL_SAP_SalesOrderUpdateInterface.TABLE_OF_BAPIRET2 RETURN_x;
        String SALESDOCUMENT;
        
        Test.setMock(WebServiceMock.class, new YourWebServiceMock());
        Test.startTest();
        obj6 =  obj7.ZSD_FM_SALESORDER_CHANGE(ORDER_HEADER,ORDER_HEADER_ADDITIONAL_FIELDS,RETURN_x,SALESDOCUMENT);
        

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
                ORL_SAP_SalesOrderUpdateInterface.ZSD_FM_SALESORDER_CHANGEResponse_element respElement = 
                    new ORL_SAP_SalesOrderUpdateInterface.ZSD_FM_SALESORDER_CHANGEResponse_element();
               response.put('response_x', respElement); 
               
            }
    }
    
}
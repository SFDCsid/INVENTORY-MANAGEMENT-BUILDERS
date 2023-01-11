@isTest
public class ORL_SAP_InventoryPullInterfaceTest {
    
    @isTest static void testORL_SAP_InventoryPullInterface() {
        
        ORL_SAP_InventoryPullInterface.ZSD_FM_RENTAL_OBJECTS_element obj1 = new
        ORL_SAP_InventoryPullInterface.ZSD_FM_RENTAL_OBJECTS_element ();
        
        ORL_SAP_InventoryPullInterface.ZSD_FM_RENTAL_OBJECTSResponse_element obj2 = new
        ORL_SAP_InventoryPullInterface.ZSD_FM_RENTAL_OBJECTSResponse_element ();
        
        ORL_SAP_InventoryPullInterface.ZSD_LEASE_INPUT obj3 = new
        ORL_SAP_InventoryPullInterface.ZSD_LEASE_INPUT ();
        
        ORL_SAP_InventoryPullInterface.ZSDST_RENTAL_OBJ_STRUCTURE obj4 = new
        ORL_SAP_InventoryPullInterface.ZSDST_RENTAL_OBJ_STRUCTURE ();
        
        ORL_SAP_InventoryPullInterface.TABLE_OF_ZSDST_RENTAL_OBJ_STRUCTURE obj5 = new
        ORL_SAP_InventoryPullInterface.TABLE_OF_ZSDST_RENTAL_OBJ_STRUCTURE ();
        
        ORL_SAP_InventoryPullInterface.zlease_details obj6 = new
        ORL_SAP_InventoryPullInterface.zlease_details ();
        
        ORL_SAP_InventoryPullInterface.ZSD_LEASE_INPUT IM_INPUT;
        ORL_SAP_InventoryPullInterface.TABLE_OF_ZSDST_RENTAL_OBJ_STRUCTURE RENTAL_OBJECTS;
        
                Test.setMock(WebServiceMock.class, new YourWebServiceMock());

        test.startTest();
        
      obj5 = obj6.ZSD_FM_RENTAL_OBJECTS(IM_INPUT,RENTAL_OBJECTS);
        
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
                 ORL_SAP_InventoryPullInterface.ZSD_FM_RENTAL_OBJECTSResponse_element response_x = 
                    new  ORL_SAP_InventoryPullInterface.ZSD_FM_RENTAL_OBJECTSResponse_element();
                response.put('response_x',response_x); 
            }
    }
    
}
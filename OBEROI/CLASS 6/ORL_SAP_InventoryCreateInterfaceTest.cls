@isTest
public class ORL_SAP_InventoryCreateInterfaceTest {
    
    @isTest static void testORL_SAP_InventoryCreateInterface() {
        ORL_SAP_InventoryCreateInterface.BAPI_MATRETURN2 obj = new 
            ORL_SAP_InventoryCreateInterface.BAPI_MATRETURN2();
        
        ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATE_element obj1 = new 
            ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATE_element();
        
        
        ORL_SAP_InventoryCreateInterface.BAPIRET2 obj2 = new 
            ORL_SAP_InventoryCreateInterface.BAPIRET2();
        
        
        ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATEResponse_element obj3 = new 
            ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATEResponse_element();
        
        
        ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE obj4 = new 
            ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE();
        
        
        ORL_SAP_InventoryCreateInterface.TABLE_OF_BAPI_MATRETURN2 obj5 = new 
            ORL_SAP_InventoryCreateInterface.TABLE_OF_BAPI_MATRETURN2();
        
        
        ORL_SAP_InventoryCreateInterface.ZSDST_MATERIAL obj6 = new 
            ORL_SAP_InventoryCreateInterface.ZSDST_MATERIAL();
        
        
        ORL_SAP_InventoryCreateInterface.ZSDST_MATERIAL_STRUCTURE obj7 = new 
            ORL_SAP_InventoryCreateInterface.ZSDST_MATERIAL_STRUCTURE();
        
        
        ORL_SAP_InventoryCreateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE obj8 = new 
            ORL_SAP_InventoryCreateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE();
        
        
        ORL_SAP_InventoryCreateInterface.zcreate_material obj9 = new 
            ORL_SAP_InventoryCreateInterface.zcreate_material();
        
        ORL_SAP_InventoryCreateInterface.ZSDST_MATERIAL_STRUCTURE MATERIAL_DATA;
        ORL_SAP_InventoryCreateInterface.TABLE_OF_BAPI_MATRETURN2 RETURNMESSAGES;
        ORL_SAP_InventoryCreateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE UNITS_OF_MEASURE;
        
        Test.setMock(WebServiceMock.class, new YourWebServiceMock());
        
        test.startTest();
        obj3 = obj9.ZSD_FM_MATERIAL_CREATE(MATERIAL_DATA,RETURNMESSAGES,UNITS_OF_MEASURE);
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
                ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATEResponse_element respElement = 
                    new   ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATEResponse_element();
                respElement.MATERIAL_NUMBER = null;
                response.put('response_x', respElement); 
            }
    }
    
}
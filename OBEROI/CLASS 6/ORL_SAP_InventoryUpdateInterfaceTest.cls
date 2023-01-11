@isTest
public class ORL_SAP_InventoryUpdateInterfaceTest {
    @isTest static void testORL_SAP_InventoryUpdateInterface(){
        
        ORL_SAP_InventoryUpdateInterface.BAPI_MATRETURN2 obj1= new 
            ORL_SAP_InventoryUpdateInterface.BAPI_MATRETURN2();
        
        
        ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGE_element obj2= new
            ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGE_element();
        
        ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGEResponse_element obj3 = new
            ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGEResponse_element();
        
        ORL_SAP_InventoryUpdateInterface.BAPIRET2 obj4 = new
            ORL_SAP_InventoryUpdateInterface.BAPIRET2();
        
        ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE obj5 = new
            ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE();
        
        ORL_SAP_InventoryUpdateInterface.TABLE_OF_BAPI_MATRETURN2 obj6 = new
            ORL_SAP_InventoryUpdateInterface.TABLE_OF_BAPI_MATRETURN2();
        
        
        ORL_SAP_InventoryUpdateInterface.ZSDST_MATERIAL_STRUCTURE obj7 = new
            ORL_SAP_InventoryUpdateInterface.ZSDST_MATERIAL_STRUCTURE();  
        
        ORL_SAP_InventoryUpdateInterface.ZSDST_MATERIAL obj8 = new
            ORL_SAP_InventoryUpdateInterface.ZSDST_MATERIAL();  
        
        
        
        ORL_SAP_InventoryUpdateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE obj9 = new
            ORL_SAP_InventoryUpdateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE();
        
        ORL_SAP_InventoryUpdateInterface.zchange_material obj10 = new
            ORL_SAP_InventoryUpdateInterface.zchange_material();
        
        ORL_SAP_InventoryUpdateInterface.ZSDST_MATERIAL_STRUCTURE MATERIAL_DATA;
        ORL_SAP_InventoryUpdateInterface.TABLE_OF_BAPI_MATRETURN2 RETURNMESSAGES;
        ORL_SAP_InventoryUpdateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE UNITS_OF_MEASURE;
        
        Test.setMock(WebServiceMock.class, new YourWebServiceMock());

        test.startTest();
        obj3 = obj10.ZSD_FM_MATERIAL_CHANGE( MATERIAL_DATA,RETURNMESSAGES,UNITS_OF_MEASURE);
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
                 ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGEResponse_element respElement = 
                    new  ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGEResponse_element ();
                respElement.MATERIAL_NUMBER = null;
                response.put('response_x', respElement); 
            }
    }
    
    
}
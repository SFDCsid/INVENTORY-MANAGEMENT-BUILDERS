@isTest
public class ORL_SAP_InventoryIntegrationServiceTest {
    
    
    public static void createData()
    {
                
    }
    
    static testMethod void testORL_SAP_InventoryIntegrationService()
    {
        
        ORL_SAP_InventoryIntegrationService obj = new ORL_SAP_InventoryIntegrationService();
        
        list<string> invIds = new list<string>{'test','demo'}; 
        String objType = 'test';

        
        obj.createInventoryInSAP(invIds, objType);
        obj.updateInventoryInSAP(invIds, ObjType);
        
        Test.setMock(WebServiceMock.class, new CreateMockResponseClass());
        
        test.startTest();
        
        // Call the method that invokes a callout
        //obj.inventoryTestPullCall();
        obj.updateTestPropPushCall();
        obj.updateTestPropTypePushCall();
        obj.pullInventoryFromSAP();
        obj.createTestPropPushCall();
        obj.createTestPropTypePushCall();
        test.stopTest();
        
    }
    
}
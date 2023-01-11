@isTest(seeAllData=False)
public class ORL_SAP_IntegrationHelperTest {

    @isTest
    static void testORL_SAP_IntegrationHelperTest() {

        ORL_SAP_IntegrationHelper obj = new ORL_SAP_IntegrationHelper();
        
        Booking__c objBook = new Booking__c();
        Property_Type__c objPPType = new Property_Type__c();
        
        list<string> invIds = new list<string>{'',''};  
        ORL_SAP_IntegrationHelper.getBillingPlanFromSAPFuture();
        ORL_SAP_IntegrationHelper.getBrokerFromSAPFuture();
        ORL_SAP_IntegrationHelper.getInventoryFromSAPFuture();
        ORL_SAP_IntegrationHelper.createResidentialCustomerInSAPFuture(objBook.Id);
        ORL_SAP_IntegrationHelper.createSalesOrderInSAPFuture(objBook.Id);
        ORL_SAP_IntegrationHelper.updateSalesOrderInSAPFuture(objBook.Id);
       // ORL_SAP_IntegrationHelper.createInventoryInSAPFuture(invIds );
        //ORL_SAP_IntegrationHelper.updateInventoryInSAPFuture(invIds );
        
        List<Property_Type__c> propertyTypeList;
        List<string> invIdList = new List<string>();
        propertyTypeList = TestDataFactory.createProjectType(1);
        insert propertyTypeList[0];
        
        for(Property_Type__c ppt : propertyTypeList){
            invIdList.add(ppt.Id);
            system.debug('ppt--->'+ppt);
        }
       // List<string> invId = [select id FROM Property_Type__c WHERE id = propertyTypeList[0].ID];
        ORL_SAP_IntegrationHelper.createInventoryInSAPFuture(invIdList);
        ORL_SAP_IntegrationHelper.updateInventoryInSAPFuture(invIdList);
        
        ORL_SAP_IntegrationHelper.updateResidentialCustomerInSAPFuture(objBook.Id);
    }
}
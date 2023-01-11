/**
*  Author: IBM  
*  Description: Test Class for Integration service class for Broker.
*  Date : 15/03/2019
*/
@IsTest(seeAllData=false)
Public with sharing class ORL_SAP_BrokerIntegrationServiceTest{
    public static void createData()
    {
        Account accountRecord = new Account();
        Id accRecodtype = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        accountRecord.RecordTypeId = accRecodtype;
        accountRecord.Name = 'PYN estate';
        accountRecord.AccountNumber = '01235';
        insert accountRecord;
        
    }
    
    @IsTest    
    public static void testpullBrokerFromSAP(){
       createData();
        test.startTest();
        ORL_SAP_BrokerIntegrationService brokerIntegrationObj = new ORL_SAP_BrokerIntegrationService();
        Test.setMock(WebServiceMock.class, new CreateMockResponseClass());
        
        // Call the method that invokes a callout
        brokerIntegrationObj.pullBrokerFromSAP();
        test.stopTest();
        
     
    }
    
}
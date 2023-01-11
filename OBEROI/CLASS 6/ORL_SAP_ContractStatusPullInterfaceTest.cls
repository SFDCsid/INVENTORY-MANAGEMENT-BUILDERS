@isTest
public class ORL_SAP_ContractStatusPullInterfaceTest {
    
    @isTest static void testORL_SAP_ContractStatusPullInterface() {
        
        ORL_SAP_ContractStatusPullInterface.ZSDST_CONTRACT_DETAILS obj = new 
            ORL_SAP_ContractStatusPullInterface.ZSDST_CONTRACT_DETAILS();
        
        
        ORL_SAP_ContractStatusPullInterface.ZSDST_CONTRACT_CONDITION obj1 = new 
            ORL_SAP_ContractStatusPullInterface.ZSDST_CONTRACT_CONDITION();
        
        
        ORL_SAP_ContractStatusPullInterface.TABLE_OF_ZSDST_CONTRACT_CONDITION obj2 = new 
            ORL_SAP_ContractStatusPullInterface.TABLE_OF_ZSDST_CONTRACT_CONDITION();
        
        
        
        ORL_SAP_ContractStatusPullInterface.TABLE_OF_ZSDST_CONTRACT_DETAILS obj3 = new 
            ORL_SAP_ContractStatusPullInterface.TABLE_OF_ZSDST_CONTRACT_DETAILS();
        
        
        ORL_SAP_ContractStatusPullInterface.TABLE_OF_ZSDST_CONTRACT_CONDITION obj4 = new 
            ORL_SAP_ContractStatusPullInterface.TABLE_OF_ZSDST_CONTRACT_CONDITION();
        
        
        ORL_SAP_ContractStatusPullInterface.ZSD_LEASE_INPUT obj5 = new 
            ORL_SAP_ContractStatusPullInterface.ZSD_LEASE_INPUT();
        
        
        ORL_SAP_ContractStatusPullInterface.ZSD_FM_CONTRACT_DETAILS_element obj6 = new 
            ORL_SAP_ContractStatusPullInterface.ZSD_FM_CONTRACT_DETAILS_element();
        
        
        ORL_SAP_ContractStatusPullInterface.ZCONTRACT_DETAILS obj7 = new 
            ORL_SAP_ContractStatusPullInterface.ZCONTRACT_DETAILS();
        
        
        ORL_SAP_ContractStatusPullInterface.ZSD_FM_CONTRACT_DETAILSResponse_element obj8 = new
            ORL_SAP_ContractStatusPullInterface.ZSD_FM_CONTRACT_DETAILSResponse_element();
        
        ORL_SAP_ContractStatusPullInterface.TABLE_OF_ZSDST_CONTRACT_CONDITION EX_CONDITIONS;
        ORL_SAP_ContractStatusPullInterface.TABLE_OF_ZSDST_CONTRACT_DETAILS EX_CONTRACT_DETAILS;
        ORL_SAP_ContractStatusPullInterface.ZSD_LEASE_INPUT IM_INPUT;
        
        Test.setMock(WebServiceMock.class, new YourWebServiceMock());
        
        
        test.startTest();
        obj8 = obj7.ZSD_FM_CONTRACT_DETAILS(EX_CONDITIONS,EX_CONTRACT_DETAILS,IM_INPUT);
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
                ORL_SAP_ContractStatusPullInterface.ZSD_FM_CONTRACT_DETAILSResponse_element respElement = 
                    new ORL_SAP_ContractStatusPullInterface.ZSD_FM_CONTRACT_DETAILSResponse_element();
                respElement.EX_CONDITIONS = null;
                response.put('response_x', respElement); 
            }
    }
    
}
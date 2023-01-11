/****************************************************************************************************
Class covered :
1. ORL_SAP_BrokerPullInterface - 7/6/2019 - 100%

****************************************************************************************************/

@isTest(seeAlldata=false)
public class ORL_SAP_BrokerPullInterfaceTest { 
    
    @isTest static void testORL_SAP_BrokerPullInterface() {
        
        
        ORL_SAP_BrokerPullInterface.ZSD_FM_BROKER_DETAILS_element obj = new 
            ORL_SAP_BrokerPullInterface.ZSD_FM_BROKER_DETAILS_element();
        
        ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_COMM_STRUCTURE obj1 = new 
            ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_COMM_STRUCTURE();
        
        ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE obj2 = new 
            ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE();
        
        ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE obj3 = new 
            ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE();
        
        ORL_SAP_BrokerPullInterface.ZSD_FM_BROKER_DETAILSResponse_element obj4 = new 
            ORL_SAP_BrokerPullInterface.ZSD_FM_BROKER_DETAILSResponse_element();
        
        ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_COMM_STRUCTURE BROKER_EMAIL_COMMUNICATION;
        ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_FAX_STRUCTURE BROKER_FAX_COMMUNICATION;
        ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_STRUCTURE BROKER_HEADER;
        ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_MOB_STRUCTURE BROKER_MOB_COMMUNICATION;
        ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_TEL_STRUCTURE BROKER_TEL_COMMUNICATION;
        ORL_SAP_BrokerPullInterface.ZSD_LEASE_INPUT IM_INPUT;
        
        
        ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE obj5 = new 
            ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE();
        
        ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_TEL_STRUCTURE obj6 = new 
            ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_TEL_STRUCTURE();
        
        ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE obj7 = new 
            ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE();
        
        ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_MOB_STRUCTURE obj8 = new 
            ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_MOB_STRUCTURE();
        
        ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE obj9 = new 
            ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE();
        
        ORL_SAP_BrokerPullInterface.ZSD_LEASE_INPUT obj10 = new 
            ORL_SAP_BrokerPullInterface.ZSD_LEASE_INPUT();
        
        
        ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_FAX_STRUCTURE obj11 = new 
            ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_FAX_STRUCTURE();
        
        
        ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_STRUCTURE obj12 = new 
            ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_STRUCTURE();
        
        
        ORL_SAP_BrokerPullInterface.zvendor_details obj13 = new 
            ORL_SAP_BrokerPullInterface.zvendor_details();
        
        
        Test.setMock(WebServiceMock.class, new YourWebServiceMock());
        Test.startTest();
        
        obj4 = obj13.ZSD_FM_BROKER_DETAILS(BROKER_EMAIL_COMMUNICATION,BROKER_FAX_COMMUNICATION,
                                           BROKER_HEADER,
                                           BROKER_MOB_COMMUNICATION,
                                           BROKER_TEL_COMMUNICATION,
                                           IM_INPUT);
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
                ORL_SAP_BrokerPullInterface.ZSD_FM_BROKER_DETAILSResponse_element respElement = 
                    new ORL_SAP_BrokerPullInterface.ZSD_FM_BROKER_DETAILSResponse_element();
                respElement.BROKER_HEADER = null;
                response.put('response_x', respElement); 
            }
    }
    
}
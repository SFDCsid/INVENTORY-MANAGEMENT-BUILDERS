global class CreateMockResponseClass implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
           ORL_SAP_BrokerPullInterface.ZSD_FM_BROKER_DETAILSResponse_element responseElement = new ORL_SAP_BrokerPullInterface.ZSD_FM_BROKER_DETAILSResponse_element();
           
           List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE> listOfBrokerStrcture= new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE>();      
           List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE> listOfBrokerComm = new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE>();
           List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE> listOfBrokermobComm = new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE>(); 
           List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE> listOfBrokerTel = new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE>();  
           List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE> listOfBrokerFax = new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE>();  
           
           ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE brokerStructureObj = new ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE();
           brokerStructureObj.LIFNR = '01234';
           brokerStructureObj.TITLE = 'Company';
           brokerStructureObj.NAME1 = 'Royal estate';
           brokerStructureObj.NAME2 = 'ESTATE';
           brokerStructureObj.SEARCH_TERM1 = 'ROYAL';
           brokerStructureObj.SEARCH_TERM2 = '01234';
           brokerStructureObj.STREET = 'D -407';
           brokerStructureObj.STREET1 = 'opp kvsc club';
           brokerStructureObj.STREET3 = 'Kandivali west';
           brokerStructureObj.LOCATION = '01234';
           brokerStructureObj.POSTAL_CODE = '400030';
           brokerStructureObj.CITY = 'TestLocation';
           brokerStructureObj.COUNTRY = 'IN';
           brokerStructureObj.REGION = '13';
           brokerStructureObj.GST_NUMBER = '27456ATBPS5117U';
           brokerStructureObj.PAN_NUMBER = 'ATBPS5117U';
           listOfBrokerStrcture.add(brokerStructureObj);
           
           ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE brokerStructureObj1 = new ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE();
           brokerStructureObj1.LIFNR = '01235';
           brokerStructureObj1.TITLE = 'Company';
           brokerStructureObj1.NAME1 = 'PYN estate';
           brokerStructureObj1.NAME2 = 'ESTATE';
           brokerStructureObj1.SEARCH_TERM1 = 'PYN';
           brokerStructureObj1.SEARCH_TERM2 = '01235';
           brokerStructureObj1.STREET = 'w -567';
           brokerStructureObj1.STREET1 = 'opp kvsc club';
           brokerStructureObj1.STREET3 = 'Kandivali west';
           brokerStructureObj1.LOCATION = '01234';
           brokerStructureObj1.POSTAL_CODE = '400030';
           brokerStructureObj1.CITY = 'TestLocation';
           brokerStructureObj1.COUNTRY = 'IN';
           brokerStructureObj1.REGION = '13';
           brokerStructureObj1.GST_NUMBER = '27456ATBPS5117U';
           brokerStructureObj1.PAN_NUMBER = 'ATBPS5117U';
           listOfBrokerStrcture.add(brokerStructureObj1);
           
           ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE brokerStructureObj2 = new ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE();
           brokerStructureObj2.LIFNR = '01236';
           brokerStructureObj2.TITLE = 'Company';
           brokerStructureObj2.NAME1 = 'PUN estate';
           brokerStructureObj2.NAME2 = 'ESTATE';
           brokerStructureObj2.SEARCH_TERM1 = 'PUN';
           brokerStructureObj2.SEARCH_TERM2 = '01236';
           brokerStructureObj2.STREET = 'w -067';
           brokerStructureObj2.STREET1 = 'opp kvsc club';
           brokerStructureObj2.STREET3 = 'Kandivali west';
           brokerStructureObj2.LOCATION = '01234';
           brokerStructureObj2.POSTAL_CODE = '400030';
           brokerStructureObj2.CITY = 'TestLocation';
           brokerStructureObj2.COUNTRY = 'IN';
           brokerStructureObj2.REGION = '13';
           brokerStructureObj2.GST_NUMBER = '27456ATBPS5117U';
           brokerStructureObj2.PAN_NUMBER = 'ATBPS5117U';
           listOfBrokerStrcture.add(brokerStructureObj2);
           
           ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE brokerCommStructureObj = new  ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE();
           brokerCommStructureObj.LIFNR = '01234';
           brokerCommStructureObj.INDICATOR = 'I';
           brokerCommStructureObj.EMAIL = 'test@123.com';
           brokerCommStructureObj.EMAIL_DEFAULT = '';
           listOfBrokerComm.add(brokerCommStructureObj);
           
           ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE brokerCommStructureObj1 = new  ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE();
           brokerCommStructureObj1.LIFNR ='01235';
           brokerCommStructureObj1.INDICATOR = 'U';
           brokerCommStructureObj1.EMAIL = 'test@128.com';
           brokerCommStructureObj1.EMAIL_DEFAULT = '';
           listOfBrokerComm.add(brokerCommStructureObj1);
           
           ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE brokerCommStructureObj2 = new  ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE();
           brokerCommStructureObj2.LIFNR ='01236';
           brokerCommStructureObj2.INDICATOR = 'I';
           brokerCommStructureObj2.EMAIL = 'test@126.com';
           brokerCommStructureObj2.EMAIL_DEFAULT = '';
           listOfBrokerComm.add(brokerCommStructureObj2);
               
           ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE brokerCommStructureOb = new  ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE();
           brokerCommStructureOb.LIFNR ='01234';
           brokerCommStructureOb.INDICATOR = 'I';
           brokerCommStructureOb.MOB_NUMBER = '3657649191';
           brokerCommStructureOb.MOB_DEFAULT = '';
           listOfBrokermobComm.add(brokerCommStructureOb);   
               
           
           ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE brokerTelStructureOb = new  ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE();
           brokerTelStructureOb.LIFNR ='01234';
           brokerTelStructureOb.INDICATOR = 'I';
           brokerTelStructureOb.TEL_NUMBER = '3657649100';
           brokerTelStructureOb.TEL_DEFAULT = '';
           listOfBrokerTel.add(brokerTelStructureOb);
               
           ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE brokerFaxStructureOb = new  ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE();
           brokerFaxStructureOb.LIFNR ='01234';
           brokerFaxStructureOb.INDICATOR = 'I';
           brokerFaxStructureOb.FAX_NUMBER = '3657';
           brokerFaxStructureOb.FAX_DEFAULT = '';
           listOfBrokerFax.add(brokerFaxStructureOb);       
    
           
           ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_COMM_STRUCTURE brokerCommStructure = new ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_COMM_STRUCTURE();
           brokerCommStructure.item = listOfBrokerComm;
           
           ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_STRUCTURE brokerStructure = new ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_STRUCTURE();
           brokerStructure.item = listOfBrokerStrcture;
               
           ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_MOB_STRUCTURE brokermobCommStructure = new ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_MOB_STRUCTURE();
           brokermobCommStructure.item = listOfBrokermobComm;    
               
           ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_TEL_STRUCTURE brokerTelCommStructure = new ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_TEL_STRUCTURE();
           brokerTelCommStructure.item = listOfBrokerTel;        

           ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_FAX_STRUCTURE brokerFaxStructure = new ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_FAX_STRUCTURE();
           brokerFaxStructure.item = listOfBrokerFax;            
               
           responseElement.BROKER_EMAIL_COMMUNICATION = brokerCommStructure;
           responseElement.BROKER_HEADER =  brokerStructure;
           responseElement.BROKER_MOB_COMMUNICATION = brokermobCommStructure;
           responseElement.BROKER_TEL_COMMUNICATION = brokerTelCommStructure;
           responseElement.BROKER_FAX_COMMUNICATION = brokerFaxStructure;    
        // Create response element from the autogenerated class.
        // Populate response element.
        // Add response element to the response parameter, as follows:
           response.put('response_x', responseElement); 
   }
}
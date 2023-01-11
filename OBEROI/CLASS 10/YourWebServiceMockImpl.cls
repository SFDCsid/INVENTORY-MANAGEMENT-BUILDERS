global class YourWebServiceMockImpl implements WebServiceMock {
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
       ORL_SAP_BillingPlanPullInterface.ZSD_FM_BILLING_PLANResponse_element respElement = 
           new ORL_SAP_BillingPlanPullInterface.ZSD_FM_BILLING_PLANResponse_element();
       respElement.RETURN_x = null;
       response.put('response_x', respElement); 
   }
}
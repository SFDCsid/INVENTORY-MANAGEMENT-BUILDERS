@istest
global class ORL_SAP_BillingPlanPullServiceMock implements WebServiceMock{
    global void doinvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType)
    {
        ORL_SAP_BillingPlanPull.ZSD_FM_BILLING_PLANResponse_element response_x;
        Map<String, ORL_SAP_BillingPlanPull.ZSD_FM_BILLING_PLANResponse_element> response_map_x = new Map<String, ORL_SAP_BillingPlanPull.ZSD_FM_BILLING_PLANResponse_element>();
        response_x = response_map_x.get('response_x');
        response.put('response_x',response_x);
    }
    
}
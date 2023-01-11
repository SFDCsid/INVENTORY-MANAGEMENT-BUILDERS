@RestResource(urlMapping='/LeadOwner/*')
global with sharing class CTI_LeadOwnerLookup{

    @HttpPost
    global static void doPost(String virtualNumberCalled ,String callerPhoneCountryCode, String callerPhoneNumber) {

        String finalJsonResp = '{"responseCode" : "40", "agentId" : "null"}'; 
        try {
  
            String respAgentId = 'null';

            String strCtiHelperResp = null;
            if(Test.isRunningTest()){
                strCtiHelperResp = '{"leads": [{"CTI_Agent_ID":"test"}]}';
            } else {
                strCtiHelperResp = CTIHelper_PMT.doPost(virtualNumberCalled ,callerPhoneCountryCode,callerPhoneNumber);
            }
            
            Map<String, Object> ctiHelperResp= (Map<String, Object>) JSON.deserializeUntyped(strCtiHelperResp);
            List<Object> leads = (List<Object>) ctiHelperResp.get('leads');
            for (Object l : leads) {
                Map<String, Object> lead = (Map<String, Object>) l;
                respAgentId = String.valueOf(lead.get('CTI_Agent_ID'));
            }            
            
            if(respAgentId !='' && respAgentId != 'null'){
                finalJsonResp = '{"responseCode" : "0", "agentId" : '+ respAgentId +' }';
            }

            else{
                finalJsonResp = '{"responseCode" : "0", "agentId" : "null"}'; 
            }

            } catch (Exception ex) {
                finalJsonResp = '{"responseCode" : "40", "agentId" : "null"}'; 
            }

        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(finalJsonResp);
    }
}
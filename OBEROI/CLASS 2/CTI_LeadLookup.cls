@RestResource(urlMapping='/CTILeadLookup/*')
global with sharing class CTI_LeadLookup{

    @HttpPost
     global static void doPost(String virtualNumberCalled ,String callerPhoneCountryCode, String callerPhoneNumber) {
     
     //CTIHelper_PMT ctiHelperPmt = new CTIHelper_PMT();
      
      String strCtiHelperResp= CTIHelper_PMT.doPost(virtualNumberCalled ,callerPhoneCountryCode,callerPhoneNumber);
      //Map<String, Object> ctiHelperResp= (Map<String, Object>) JSON.deserializeUntyped(strCtiHelperResp);
       
       RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(strCtiHelperResp);
     }
}
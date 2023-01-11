@isTest
public class CTI_OpenCTIConnectorTest1{
    
    /*************************************************************
    * Test class for CTI_OpenConnectorTest 
    **************************************************************/
     static testMethod void testOpenCtiConnector(){
     
        Virtual_Number__c virtualObj=new Virtual_Number__c();
        virtualObj.Name='02268630701';
         insert virtualObj;

        Test.startTest();
        try{
        String strTestUser = CTI_OpenCTIConnector.getUserCtiDetails();
        System.debug('strTestUser='+strTestUser);
        Map<String, Object> jsonTestUser = (Map<String, Object>) JSON.deserializeUntyped(strTestUser);
    
        String testUserId = String.valueOf(jsonTestUser.get('Id'));
        System.debug('testUserId='+ testUserId);
        
        String testLeadInputString =  '{"FirstName":"New","LastName":"CTI Lead","MobilePhone":"1234567890","Campaign__c":null,"Country_Code__c":"+91","Virtual_Number_Text__c":"'+ virtualObj.NAme+'","Lead_Stage__c":"Open", "Status":"Open", "LeadSource":"Virtual No.","OwnerId":"'+testUserId+'","Original_PMT_Owner__c":"'+testUserId+'"}';
        System.debug('testLeadInputString='+ testLeadInputString);
       
        String strNewLeadResp = CTI_OpenCTIConnector.createLead(testLeadInputString);
        System.debug('strNewLeadResp='+ strNewLeadResp);
        Map<String, Object> jsonNewLeadResp = (Map<String, Object>) JSON.deserializeUntyped(strNewLeadResp);
        
        String testCreatedLeadId = String.valueOf(jsonNewLeadResp.get('Id'));
        System.debug('testCreatedLeadId='+ testCreatedLeadId);
            
        String countryCodeVirtualNumberResp = CTI_OpenCTIConnector.getCountryCodeVirtualNumberFromLead(testCreatedLeadId);
        System.debug('countryCodeVirtualNumberResp='+ countryCodeVirtualNumberResp);
        
        String strUpdateLeadResp = CTI_OpenCTIConnector.updateLead(testCreatedLeadId, virtualObj.Name ,testUserId);
        System.debug('strUpdateLeadResp='+strUpdateLeadResp);
        
        String testCallInputString = '{"sfCallId":"","sessionId":"'+testCreatedLeadId+'","calledNumber":"02268630706","callingCountrycode":"+91","callingNumber":"1234567890","leadId":"'+testCreatedLeadId+'","contactId":null,"opportunityId":null,"projectId":null,"tower":null,"property":null,"booking":null,"broker":null,"campaign":null,"site":null,"wasLeadIdNull":"yes","callStartDateTime":"1560325189190","callEndDateTime":"1560325195647","callDuration":"6.46","comments":"test","callTeam":"PMT","callType":"inbound","callStatus":"Missed","agent":"'+testUserId+'","recordingURL":"https://testurl.com"}';        
           System.debug('testCallInputString='+ testCallInputString);
        
        String strTestCall = CTI_OpenCTIConnector.disposeFullCall(testCallInputString);
        System.debug('strTestCall='+strTestCall);
        Map<String, Object> jsonTestCall = (Map<String, Object>) JSON.deserializeUntyped(strTestCall);
        
        String testCallId = String.valueOf(jsonTestCall.get('Id'));
        System.debug('testCallId='+ testCallId);
        
        String strUpdateCallResp = CTI_OpenCTIConnector.updateCallWithComments(testCallId,'test comment');
        System.debug('strUpdateCallResp='+ strUpdateCallResp);
        
        String strVirtualNumberResp = CTI_OpenCTIConnector.getVirtualNumberForLatestMissedCall('1234567890');
        System.debug('strVirtualNumberResp='+strVirtualNumberResp);
    }
    catch(exception e){
        System.debug(e);
    }
        Test.stopTest();
    }
}
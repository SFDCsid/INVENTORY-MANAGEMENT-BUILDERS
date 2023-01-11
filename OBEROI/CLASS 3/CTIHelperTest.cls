@isTest
public class CTIHelperTest {
    static String virtualNumberCalled, callerPhoneCountryCode, callerPhoneNumber;
    static List<Virtual_Number__c> vList;
    @TestSetup
    private static void createTestData() {
        vList=new List<Virtual_Number__c>();
        Virtual_Number__c virtualObj=new Virtual_Number__c();
        virtualObj.Name='ABC';
        vList.add(virtualObj);
        insert vList;
        
        virtualNumberCalled='ABC';
        callerPhoneCountryCode='9823989298';
        callerPhoneNumber='9834677833';
    }
    static testMethod void testDoPost(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
      
    
        req.requestURI = '/services/apexrest/abc/xyz/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
         CTIHelper.doPost(virtualNumberCalled, callerPhoneCountryCode, callerPhoneNumber);
         
        Test.stopTest();
        

    }   
    
  
    
   
    
}
@isTest
public class CTI_LeadLookupTest {
     static testMethod void testHttpPost() {
        Test.startTest();
        
        RestResponse res = new RestResponse();
       
        RestContext.response= res;
        
        CTI_LeadLookup.doPost('123', '456', '9876543123');
        Test.stopTest();
        
    }
}
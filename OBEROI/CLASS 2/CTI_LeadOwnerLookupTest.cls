@isTest
public class CTI_LeadOwnerLookupTest {
	static testMethod void testHttpPost() {
        
       	Lead  TestLead = new Lead ();
		TestLead.LastName ='TestOpp1';
   		TestLead.Lead_Stage__c='Open';
   		insert TestLead;
   		//CTI_LeadOwnerLookup reqst=new CTI_LeadOwnerLookup();
   		String JsonMsg=JSON.serialize(TestLead);
        system.debug('1:'+ TestLead );
        
        Test.startTest();
        RestResponse res = new RestResponse();
        RestContext.response= res;
        CTI_LeadOwnerLookup.doPost('123', '456', '9876543123');
        Test.stopTest();
    }
}
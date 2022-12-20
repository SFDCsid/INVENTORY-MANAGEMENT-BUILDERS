//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 08-11-2022
//-------------------------------------------//
@isTest
public class TestREST_CTIAgentServices {
	@isTest
    public static void getFreshLeadAgentId() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        String json = '{"mobileNo":"1234567890", "did":"1234"}';
 		req.requestBody = Blob.valueOf(json);
        RestContext.request = req;
        RestContext.response = res;
      
        Test.startTest();   
        	REST_CTIAgentServices.getAgentId('01234567890', '1234');
        Test.stopTest();
    }
}
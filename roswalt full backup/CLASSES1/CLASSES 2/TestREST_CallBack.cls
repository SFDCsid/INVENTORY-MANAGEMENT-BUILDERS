//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 08-11-2022
//-------------------------------------------//
@isTest
public class TestREST_CallBack {
	@isTest
    public static void missedCallLead() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User objUser = new User(Alias = 'standt', Email='standardTest@testing.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUser1@t1estorg.com'
                               );
        insert objUser;
        objUser.OzoneTel_AgentId__c = 'ozonetel_test';  
        update objUser;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String json = '{\"monitorUCID\": \"906182320867624\",\"UUI\": \"ozonetel_test\",\"Did\": \"918069808314\", \"CampaignName\": \"Hosted_918069808314\", \"Location\": \"Mumbai_HO\", \"CallerID\": \"09561044753\", \"PhoneName\": \"ozonetel_test -> ozonetel_test\", \"Skill\": \"General\", \"StartTime\": \"2022-07-19 17:31:35\", \"EndTime\": \"2022-07-19 17:31:53\", \"TimeToAnswer\": \"\", \"CallDuration\": \"00:00:18\", \"Duration\": \"00:00:00\", \"FallBackRule\": \"AgentDial\", \"DialedNumber\": \"9527980597\", \"Type\": \"InBound\", \"AgentID\": \"ozonetel_test -> ozonetel_test\", \"AgentPhoneNumber\": \"9527980597 -> 9527980597\", \"AgentUniqueID\": \"702\", \"AgentName\": \"Ozonetel Test\", \"Disposition\": \"\", \"HangupBy\": \"UserHangup\", \"Status\": \"NotAnswered\", \"AudioFile\": \"\", \"TransferType\": \"No Transfers\", \"TransferredTo\": \"\", \"Comments\":\"\", \"DialStatus\": \"NormalCallClearing -> user_disconnected\", \"Apikey\": \"KKf07f29dbd829ce9483bf5b9a17944604\", \"AgentStatus\": \"NormalCallClearing -> user_disconnected\", \"CustomerStatus\": \"\", \"UserName\": \"creditonepayments\", \"CallerConfAudioFile\": \"\", \"ConfDuration\": \"00:00:00\", \"CampaignStatus\": \"ONLINE\", \"DataUniqueId\": \"\", \"WrapUpDuration\": \"00:00:00\"}';
        res.responseBody = Blob.valueOf(json);
      	req.requestURI =  'https://edenlandmarksltd2--edensb.sandbox.my.salesforce-sites.com/CTIIntegration/services/apexrest/CTI/CallBack';
      	//req.requestURI = 'https://edenlandmarksltd2--eden.secure.force.com/CTIIntegration/services/apexrest/CTI/CallBack'; //Production URL
        req.httpMethod = 'POST';
        req.addParameter('data', json);    
        RestContext.request = req;
        RestContext.response = res;
        REST_CTICallBack.createCallDetails();
        
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();
        String json1 = '{\"monitorUCID\": \"906182320867624\",\"UUI\": \"ozonetel_test\",\"Did\": \"918069808314\", \"CampaignName\": \"Hosted_918069808314\", \"Location\": \"Mumbai_HO\", \"CallerID\": \"09561044753\", \"PhoneName\": \"ozonetel_test -> ozonetel_test\", \"Skill\": \"General\", \"StartTime\": \"2022-07-19 17:31:35\", \"EndTime\": \"2022-07-19 17:31:53\", \"TimeToAnswer\": \"\", \"CallDuration\": \"00:00:18\", \"Duration\": \"00:00:00\", \"FallBackRule\": \"AgentDial\", \"DialedNumber\": \"9527980597\", \"Type\": \"InBound\", \"AgentID\": \"ozonetel_test -> ozonetel_test\", \"AgentPhoneNumber\": \"9527980597 -> 9527980597\", \"AgentUniqueID\": \"702\", \"AgentName\": \"Ozonetel Test\", \"Disposition\": \"\", \"HangupBy\": \"UserHangup\", \"Status\": \"Answered\", \"AudioFile\": \"\", \"TransferType\": \"No Transfers\", \"TransferredTo\": \"\", \"Comments\":\"\", \"DialStatus\": \"NormalCallClearing -> user_disconnected\", \"Apikey\": \"KKf07f29dbd829ce9483bf5b9a17944604\", \"AgentStatus\": \"NormalCallClearing -> user_disconnected\", \"CustomerStatus\": \"\", \"UserName\": \"creditonepayments\", \"CallerConfAudioFile\": \"\", \"ConfDuration\": \"00:00:00\", \"CampaignStatus\": \"ONLINE\", \"DataUniqueId\": \"\", \"WrapUpDuration\": \"00:00:00\"}';
        res1.responseBody = Blob.valueOf(json1);
      	req1.requestURI =  'https://edenlandmarksltd2--edensb.sandbox.my.salesforce-sites.com/CTIIntegration/services/apexrest/CTI/CallBack';
      	//req.requestURI = 'https://edenlandmarksltd2--eden.secure.force.com/CTIIntegration/services/apexrest/CTI/CallBack'; //Production URL
        req1.httpMethod = 'POST';
        req1.addParameter('data', json1);    
        RestContext.request = req1;
        RestContext.response = res1;
        REST_CTICallBack.createCallDetails();
    }
}
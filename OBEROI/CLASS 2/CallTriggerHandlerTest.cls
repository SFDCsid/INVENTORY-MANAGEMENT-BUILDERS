/****************************************************************************************************
Class covered :
1. CallTriggerHandler - 7/6/2019 - 80%

****************************************************************************************************/
@isTest(seeAllData=false)
public class CallTriggerHandlerTest {
    static List<Lead> led;  
    static Call__c callRec; 
    static List<Contact> con;
    static List<Account> acc;
    static List<Call__c> lstOfCall;     
    
    private static void createTestData() {
        /*v1.1 start*/
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()]; 
        System.runAs(thisUser) 
        {                       
            EmailTemplate et = new EmailTemplate(); 
            et.isActive = true; 
            et.Name = 'Inbound call is answered at the SENT TO THE CUSTOMER'; 
            et.DeveloperName = 'Inbound_call_is_answered_at_the_SENT_TO_THE_CUSTOMER'; 
            et.TemplateType = 'TEXT'; 
            et.FolderId = UserInfo.getUserId(); 
            et.Body = '{!Call__c.Lead_Name__c} - {!Call__c.Called_Number__c}'; 
            //et.BrandTemplateId = bt.Id;
            insert et;
        }
        /*v1.1 end*/
        
        led = new List<Lead>(TestDataFactory.createResLead(3));       
        
        acc = new List<Account>(TestDataFactory.createAccounts(1));
        con = new List<Contact>(TestDataFactory.createContacts(3)); 
        //insert led;
        
        led[0].Phone='9848787687';
        led[0].MobilePhone='';
        led[0].Country_Code__c='+91';
        
        led[1].Phone='';
        led[1].MobilePhone='';
        led[1].Other_Mobile_Number__c='9848787687';
        led[1].Country_Code_for_Other_Mobile_Number__c='+91';
        
        led[2].MobilePhone='9848787687';
        led[2].Country_Code__c='+91';
        
        INSERT led;
        
        system.debug('My Lead List '+led);
        insert acc;
        insert con;
        /*v1.1 start*/
        lstOfCall = new List<Call__c>();
        Call__c callRec1 = new Call__c(Calling_Country_code__c='+91',Calling_Number__c='9848787687',Lead__c=led[0].id,Contact__c=con[0].id,Called_Number__c='9923452345');
        Call__c callRec2 = new Call__c(Calling_Country_code__c='+91',Calling_Number__c='9848787687',Lead__c=led[1].id,Contact__c=con[1].id,Called_Number__c='9923452345');
        Call__c callRec3 = new Call__c(Calling_Country_code__c='+91',Calling_Number__c='9848787687',Lead__c=led[2].id,Contact__c=con[2].id,Called_Number__c='9923452345');      
        lstOfCall.add(callRec1);
        lstOfCall.add(callRec2);
        lstOfCall.add(callRec3);
        
        insert lstOfCall;
        /*v1.1 end*/
            
    }
    
    static testMethod void callTrigHandMethod1() {
        createTestData();
        Map<id,Call__c> oldCallMap = new Map<id,Call__c>();
        for(Call__c call: lstOfCall){
            oldCallMap.put(call.id,call);
        }
        callRec = lstOfCall[0];
        test.startTest();
        
        CallTriggerHandler.updateLeadonCall(lstOfCall,oldCallMap,'testMehod'); /*v1.1 start*/
        CallTriggerHandler.sendEmail(callRec);
        CallTriggerHandler.sendSMS(callRec);
        test.stopTest();        
    }
    
    /*v1.1 start*/
    static testMethod void sendSMSTest(){        
        List<Call__c> lstOfCallRec = new List<Call__c>();
        List<Id> lstOfCallId = new List<Id>();
        Call__c callRec1 = new Call__c(Call_Status__c='Missed',Calling_Country_code__c='91',Calling_Number__c='9848787687',Call_Type__c='Inbound');
        Call__c callRec2 = new Call__c(Call_Status__c='Not Answered',Calling_Country_code__c='91',Calling_Number__c='9248787687',Call_Type__c='Outbound');
        Call__c callRec3 = new Call__c(Call_Status__c='Answered',Calling_Country_code__c='91',Calling_Number__c='9948787687',Call_Type__c='Inbound');       
        lstOfCallRec.add(callRec1);
        lstOfCallRec.add(callRec2);
        lstOfCallRec.add(callRec3);     
        insert lstOfCallRec;
        
        for(Call__c c: lstOfCallRec){
            lstOfCallId.add(c.Id);
        }
                
        
        Test.startTest();
        CallTriggerHandler.sendSMS(lstOfCallId);
        CallTriggerHandler.sendSMS(lstOfCallRec[0]);
        CallTriggerHandler.sendSMS(lstOfCallRec[1]);
        CallTriggerHandler.sendSMS(lstOfCallRec[2]);
        
        CallTriggerHandler.missedIncomingCall(lstOfCallRec, new Map<id,Call__c>{}, 'insert');
        
        Test.stopTest();        
    }
    /*v1.1 end*/
}
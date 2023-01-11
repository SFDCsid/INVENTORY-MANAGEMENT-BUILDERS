/*****************************************************************************************************
Class: UserTriggerHandlerTest 
Version: v1.0 - Created
    v1.1 - 1-5-2019 - AmitKohakade - Commenting updateUseronVirtualNumber method call as its not present in 
                                     UserTriggerHandler class. Resolution for UAT change set Apex Components V11

******************************************************************************************************/

@isTest 
public class UserTriggerHandlerTest {
static List<User> userList;  

    
   @TestSetup
   private static void createTestData() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        userList = new List<User>();
        while (userList.size() < 5) {
      Blob b = Crypto.GenerateAESKey(128);
      String h = EncodingUtil.ConvertTohex(b);
      String uid = h.SubString(0,8);
      User u = new User(Alias = uid, Email= uid + '@myorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', Virtual_Number__c='123',
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/New_York', UserName= uid + '@myorg.com');      
          userList.add(u);
    }
    insert(userList);
      
   }
    
   static testMethod void callTrigHandMethod1() {
       try{
       createTestData();  
        Map<id,User> oldCallMap = new Map<id,User>();
       User uCloned  = (userList[0]).clone(true, true);
       ucloned.Virtual_Number__c = 'ds';
        oldCallMap.put(userList[0].id,ucloned);  
       system.debug('Id -- '+ucloned.Id+' -- -'+ucloned.Virtual_Number__c +' -cloned- '+ userList[0].Virtual_Number__c);
        //UserTriggerHandler.updateUseronVirtualNumber(userList,oldCallMap,'update'); //v1.1
       }
       catch(Exception ex){}
      
    }
}
/**
*  Author: IBM  
*  Description: Test Class for Integration service class for Customer.
*  Date : 02/04/2019
*/

@isTest(seeAllData=false)
public class ORL_SAP_CustomerIntegrationServiceTest {
    
    @testSetup
    public static void createData()
    {
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        UserRole ur = new UserRole(Name = 'Test User');
        System.runAs ( thisUser ) {
            insert ur;
        }
        User tuser = new User(  firstname = 'TestDemo',
                              lastName = 'UserDemo',
                              email =  'test@test.com',
                              Username = uniqueName + '@test' + orgId + '.org',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Chicago',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = p.Id,
                              UserRoleId = ur.id,
                              EmailEncodingKey='UTF-8');
        
     
        System.runAs ( thisUser ) {
            insert tuser; 
        }
        
       // List<Booking__c> bookObjList=TestDataFactory.createBookings(1);
       // List<Opportunity> oppObjList  = TestDataFactory.createOpportunity(1);
        List<Contact> contactObjList = TestDataFactory.createContacts(1);
       // bookObjList.get(0).opportunity__c= oppObjList.get(0).id;
       // bookObjList.get(0).Primary_Applicant__c = contactObjList.get(0).id;
       // bookObjList.get(0).Search_Term__c = 'Test Search Term';
       // bookObjList.get(0).Sales_Head__c= tuser.id;
        //bookObjList.get(0).Sales_Head__c= tuser.id;
        //bookObjList.get(0).Sales_Head__c= tuser.id;
        //bookObjList.get(0).Sales_Head__c= tuser.id;
        //insert BookObjList; 
        
    }
    
    @IsTest    
    public static void testCreateResidentialCustomerInSAP(){
        List<Booking__c> bookingObj = [SELECT id,Name FROM Booking__c limit 1];
        test.startTest();
        ORL_SAP_CustomerIntegrationService customerIntegrationObj = new ORL_SAP_CustomerIntegrationService();
        //Test.setMock(WebServiceMock.class, new CreateMockResponseClass());
        
        // Call the method that invokes a callout
        customerIntegrationObj.createResidentialCustomerInSAP('123');
        customerIntegrationObj.updateResidentialCustomerInSAP('123');
        test.stopTest();
    }
    
}
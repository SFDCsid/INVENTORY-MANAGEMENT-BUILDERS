@isTest
public class PMTUserControllerTest {

    @isTest(seeAllData=true)
    static void testGetPMTUsers(){
        Test.startTest();
        List<User> users = PMTUserController.getPMTUsers();
        system.assert(users!=null && users.size()>0);
        Test.stopTest();
    }
    
    @isTest(seeAllData=true)
    static void testGetLastAssignedId(){
        Test.startTest();
        String result = PMTUserController.getLastAssignedId();
        system.assert(result!=null);
        Test.stopTest();
    }
    
    @isTest
    static void testGetLastAssignedIdNull(){
        Test.startTest();
        String result = PMTUserController.getLastAssignedId();
        system.assert(result==null);
        Test.stopTest();
    }
    
    @isTest
    static void testSavePMTUserRecords(){
        Test.startTest();
        User usr = TestDataFactory.createUser('ORL Admin', 'MD');
        usr.On_Leave__c = true;
        List<User> users = new List<User>();
        users.add(usr);
        string inputUsers = JSON.serialize(users);
        PMTUserController.savePMTUserRecords(inputUsers);
        Test.stopTest();
        
    }
}
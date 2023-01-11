@isTest 
public class CopyLeadToTaskTest {
static List<Lead> led;  

    
   @TestSetup
   private static void createTestData() {
      led = new List<Lead>(TestDataFactory.createResLead(1));
      insert led[0]; 
   
   }
    
    
   static testMethod void callTrigHandMethod1() {
        createTestData();
    
        CopyLeadToTask.getTypeFromLead(led[0].id);
       
      
              
    }
}
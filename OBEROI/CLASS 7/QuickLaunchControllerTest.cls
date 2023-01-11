@isTest
public class QuickLaunchControllerTest {
static List<Lead> led;  

    
   @TestSetup
   private static void createTestData() {
      led = new List<Lead>(TestDataFactory.createResLead(1));
      led[0].Data_Sheet_Submitted__c = TRUE;
      insert led; 
      
   }
    
   static testMethod void callTrigHandMethod1() {
       createTestData();
       List<Lead> ld=[Select id,Lead_Number__c from Lead where Lead_Number__c!=null limit 1 ];
       System.debug('Amol Tholbare'+ld[0].Lead_Number__c);
       String ldnumber = ld[0].Lead_Number__c;
       system.debug('ldnumber---'+ldnumber);
       Id OppId = QuickLaunchController.getleadConvertprocess(ldnumber);
    }
}
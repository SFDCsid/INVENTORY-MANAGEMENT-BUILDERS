@isTest
public class ORL_BrokerDomainTest {
    static List<Vendor__c>vs;
      @TestSetup
    private static void createVendorTestData() {
        vs=new List<Vendor__C>();
        vendor__c ven = new vendor__c();
        ven.Alternate_Email_Id__c ='Nueva@gmail.com';
        ven.Broker_Code__c='asdgha';
        ven.Advance_Amount__c=23;
        ven.Email_Id__c='ratd@sdf.com';
        vs.add(ven);
        //insert vs;
       
    }
     @isTest static void testVendor() {
         
         ORL_BrokerDomain orl_broker=new  ORL_BrokerDomain();
         test.startTest();
          orl_broker.insertBroker(vs);
           orl_broker.updateBroker(vs);
         test.stopTest();
     }

}
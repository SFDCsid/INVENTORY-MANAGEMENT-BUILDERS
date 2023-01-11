@isTest
public class LeadHandlerTest {
    static Lead ld;
    static Lead led;
    static Lead luxld;
    static site__c st ;
    static Project__c pjR;
    static Project__c pjL;
    
    static testMethod void createLeads() {
        //Residential
        ld = TestDataFactory.createResLead(1)[0];
        st = TestDataFactory.createSite(1)[0];
        pjR = TestDataFactory.createResProject(1)[0];
        insert st;
        pjR.Site__c =st.Id;
        insert pjR;
        ld.Project__c = pjR.Id;
        insert ld;
        
        //Luxury
        luxld = TestDataFactory.createLuxLead(1)[0];
        pjL = TestDataFactory.createLuxProject(1)[0];
        insert pjL;
        luxld.Project__c = pjL.Id;
        insert luxld;
        
        
        system.assertEquals(ld.firstName, 'ld');
        system.debug('767c'+ pjR.Plant__c);
        
    }
}
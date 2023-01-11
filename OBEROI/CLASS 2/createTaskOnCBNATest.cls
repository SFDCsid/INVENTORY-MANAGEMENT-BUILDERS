@isTest
public class createTaskOnCBNATest {
    static Lead ld;
    static list<QueueSobject> queue;
    static Project__c pjR;     
    
    
    static testMethod void updateOwnerBatch() {
        //  pjR = TestDataFactory.createResProject(1)[0];
        // insert pjR;
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name =: 'PMT Users'].Id,
            LastName = 'last',
            Email = 'Oberoi'+Math.random()+'@test.com',
            Username = 'Oberoi'+Math.random()+'@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        ); 
        Date yesterday = (system.today()-1) ;
        ld = TestDataFactory.createResLead(1)[0];
        ld.LeadSource = 'Virtual No.';
        ld.Lead_Stage__c = Label.Lead_Status_Contacted_But_Not_Answering_1;
        // ld.Project__c =pjR.Id; 
        system.runAs(u){     
            insert ld;
            ld.CBNA_Time__c = yesterday;
            update ld;
        }
        // ld.OwnerId =queue[0].queueId;
        //update ld;
        Test.startTest();
        createTaskOnCBNA x = new createTaskOnCBNA();
        database.executeBatch(x);
        Test.stopTest();
    }
}
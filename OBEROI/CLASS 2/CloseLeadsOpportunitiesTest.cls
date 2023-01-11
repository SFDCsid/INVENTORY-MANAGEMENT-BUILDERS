@isTest
public class CloseLeadsOpportunitiesTest {
    
    
    
    static Lead ld;
    //static list<QueueSobject> queue;
    //static Project__c pjR;     
    
    @isTest
    static void updateOwnerBatch() {
        
        //  pjR = TestDataFactory.createResProject(1)[0];
        // insert pjR;
        string oppId;
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
        
        //insert u;
        ld = TestDataFactory.createResLead(1)[0];        
        ld.LeadSource = 'Kisok/data-sheet';
        ld.Data_Sheet_Submitted__c = true;
        // ld.OwnerId = u.Id;
        
        // system.runAs(u){ 
        // }
        // ld.OwnerId =queue[0].queueId;
        //update ld;
        Test.startTest();
        //ld.CreatedDate =System.Now().addDays(-6) ;
        insert ld;
        LeadStatus Leads= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1]; 
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(ld.Id);
        system.debug('@@@@@'+oppId);
        lc.ConvertedStatus = Leads.MasterLabel;    
        // ld.OwnerId =queue[0].queueId;
        Database.LeadConvertResult lcr = Database.convertLead(lc);       
        if(lcr.isSuccess()){
            oppId = lcr.getOpportunityId();
        }
        system.debug('@@@@@'+oppId);
        
        Opportunity opp = new Opportunity();
        opp.Id = oppId;
        opp.StageName ='Lost';
        opp.Opportunity_Status__c ='Lost to competitor';
        update opp;
        CloseLEadsOpportunities x = new CloseLEadsOpportunities();
        database.executeBatch(x);
        Test.stopTest();
    }
    
    
    
}
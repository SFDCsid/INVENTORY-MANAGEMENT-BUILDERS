@isTest
public class TaskTriggerHandlerTest {
    @isTest 
    public static void testinsert()
    {
        
        //Test.startTest();
        
        String userId = UserInfo.getUserId();
        
        Account account = new Account(Name = 'Hello World');
        insert account;
        
        Opportunity opp = new Opportunity(Name = account.Name,StageName='Prospecting',CloseDate=System.today(),AccountId=account.Id);
        opp.OwnerId=UserInfo.getUserId() ;
        insert opp;
        
         
        Task task = new Task();
        
        task.WhatId = opp.Id;
        task.OwnerId = userId;
        task.Subject = 'Email: SOMETHING@TEST.COM';
        task.priority= 'Normal';
        task.status = 'Open';
        task.description = 'Additional To: SOMETHING';
        task.ActivityDate = date.today();
        task.Date_of_Site_Visit__c= datetime.newInstance(2019, 9, 15, 12, 30, 0);
//        task.Site_Visit__c=svt.id;
        insert task;
        
        Lead ld = new Lead();
        ld.LastName ='Test';
        ld.State='Open';
        ld.Lead_Stage__c='Converted to Opportunity';
        ld.Status='Converted to Opportunity';
        //ld.RecordTypeId=Schema.SObjectType.Task.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();         
        insert ld; 
        
        Task task2 = new Task();
        
        task2.WhoId =ld.Id;
        task2.Client_Name__c='Test';
        task2.OwnerId = userId;
        task2.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Commercial Lead').getRecordTypeId();         
        task2.Subject = 'Email: SOMETHING@TEST.COM';
        task2.priority= 'Normal';
        task2.status = 'Open';
        task2.description = 'Additional To: SOMETHING';
        task2.ActivityDate = date.today();
        task2.Date_of_Site_Visit__c= datetime.newInstance(2019, 9, 15, 12, 30, 0);
        
        insert task2;
       
        
        List<Opportunity> oppList = new List<Opportunity>(TestDataFactory.createOpportunity(1));
        List<Lead> leadList = new List<Lead>(TestDataFactory.createResLead(1));
        insert leadList;
        insert oppList;
        
        Set<Id> idSet=new Set<Id>();
        idSet.add(task.id);
        Set<Id> idSet2=new Set<Id>();
        idSet2.add(task2.id);
        Set<Id> oppSet=new Set<Id>();
        oppSet.add(oppList[0].id);
        Set<Id> leadSet=new Set<Id>();
        leadSet.add(leadList[0].id);
        
        //TaskTriggerHandler.updateCommercialLead(idSet2);
        TaskTriggerHandler.UpdateTaskOnOpportunity(task.id);
        TaskTriggerHandler.updateOpportunityManagerDetails(idSet,oppSet);
        TaskTriggerHandler.updateLeadManagerDetails(idSet,leadSet);
        //TaskTriggerHandler.updateResidentialLead(idSet);
        //Test.stopTest();  
        
    }
    
    public static testMethod void testResidentialLead(){
        Set<Id> taskIds = new Set<Id>();
        Id taskLeadRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Lead').getRecordTypeId();         
        List<Lead> leadList = TestDataFactory.createResLead(1);
        Insert leadList;
        
        system.debug('leadList----->'+leadList);
        String userId = UserInfo.getUserId();
        Task task = new Task();
        task.RecordTypeId = taskLeadRecordTypeId;
        task.Stage__c ='Open';
        task.WhoId = leadList[0].id;
        task.Status = leadList[0].status;
        task.OwnerId = userId;
        task.Lead_Status__c = 'Open';
        task.Status='Completed';
        task.Date_of_Site_Visit__c = datetime.newInstance(2019, 9, 15, 12, 30, 0);
        Insert task;
        
        system.debug('task------->'+task);
        
        taskIds.add(task.id);
        Test.startTest();
        TaskTriggerHandler.updateResidentialLead(taskIds);
        task.Status = 'Completed';
        update task;
        taskIds.add(task.id);
        TaskTriggerHandler.updateResidentialLead(taskIds);
        Test.stopTest();
    }
    //method to test stage with  'Site Visit Schedule'
    public static testMethod void testResidentialLeadResidentialOpportunity1(){
        Set<Id> taskIds = new Set<Id>();
        Set<Id> taskIds2 = new Set<Id>();
        Id taskLeadRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId();         
        List<Lead> leadList = TestDataFactory.createResLead(1);
        Insert leadList;
        List<Opportunity> oppList = new List<Opportunity>(TestDataFactory.createOpportunity(1));
        Insert oppList;
        system.debug('leadList----->'+leadList);
        String userId = UserInfo.getUserId();
        
        Site_Visit__c svt=new Site_Visit__c();
        
        svt.Opportunity__c=oppList[0].id;
         svt.OwnerId=UserInfo.getUserId() ;
        svt.Opportunity_Owner_Email__c='subham.mishra@stetig.com';
        svt.Walk_in_Source__c= 'Digital' ;
        svt.RecordTypeId= Schema.SObjectType.Site_Visit__c.getRecordTypeInfosByName().get('New Visit').getRecordTypeId();
         insert svt;
        
        Task task = new Task();
        task.RecordTypeId = taskLeadRecordTypeId;
        task.WhatId = oppList[0].id;
        task.Status = 'Completed';
        task.OwnerId = userId;
        task.Opportunity_Stage__c ='New';
        task.Opportunity_Status__c = 'Open';
        task.Date_of_Site_Visit__c = datetime.newInstance(2019, 9, 15, 12, 30, 0);
         task.Site_Visit__c=svt.id;
        Insert task;
        
        system.debug('task------->'+task);
        
        taskIds.add(task.id);
        Test.startTest();
        TaskTriggerHandler.updateResidentialLead(taskIds);
        task.Status = 'Completed';
        update task;
        taskIds.add(task.id);
        TaskTriggerHandler.updateResidentialLead(taskIds);
        Test.stopTest();
        
        
    }
    
    public static testMethod void testResidentialLeadResidentialOpportunity2(){
        Set<Id> taskIds = new Set<Id>();
        Set<Id> taskIds2 = new Set<Id>();
        Id taskOppRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId();           
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity oppt = new Opportunity( Name = 'Test Opp' + Math.random(),closeDate = system.Today(), 
                                           StageName= 'New',Country_Code__c='US',Mobile__c='1234567890');
        oppList.add(oppt);
        
        String userId = UserInfo.getUserId();
        Task task = new Task();
        task.RecordTypeId = taskOppRecordTypeId;
        task.WhatId = oppList[0].id;
        task.Status = 'In Progress';
        task.OwnerId = userId;
        task.Opportunity_Stage__c ='Follow Up';
        task.Opportunity_Status__c = 'Site Visit Scheduled';
        task.Date_of_Site_Visit__c = datetime.newInstance(2019, 9, 15, 12, 30, 0);
        Insert task;
        
        system.debug('task------->'+task);
        
        taskIds.add(task.id);
        /* Test.startTest();
TaskTriggerHandler.updateResidentialLead(taskIds);
Test.stopTest();*/
        
    }
    
    public static testMethod void testAutoCompleteTaskOnOpportunity(){
        Set<Id> taskIds = new Set<Id>();
        Id taskLeadRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Lead').getRecordTypeId();         
        List<Lead> leadList = TestDataFactory.createResLead(1);
        Insert leadList;
        
        List<Opportunity> opportunities = TestDataFactory.createOpportunity(1);
        Insert opportunities;
        
        system.debug('leadList----->'+leadList);
        system.debug('opportunities----->'+opportunities);
        
        String userId = UserInfo.getUserId();
        List<Task> taskList = new List<Task>();
        Task task = new Task(Subject = 'Email: SOMETHING@TEST.COM',priority= 'Normal',status = 'Open',description = 'Additional To: SOMETHING',
                             ActivityDate = date.today(),RecordTypeId = taskLeadRecordTypeId, WhoId = leadList[0].id,OwnerId = userId);
        taskList.add(task);
        Insert taskList;
        Map<Id,Task> taskIdToTask = new Map<Id,Task>();
        taskIdToTask.put(task.id, task);
        system.debug('task------->'+task);
        
        taskIds.add(task.id);
        Test.startTest();
        TaskTriggerHandler.autoCompleteTaskOnOpportunity(taskList,taskIdToTask);
        Test.stopTest();
    }
    public static testMethod void testTrigger()
    {
        Lead l = new Lead();
        l.FirstName = 'CRM Testing First';
        l.LastName = 'CRM Testing Last';
        l.Company = 'CRM Testing INCtest';
        l.description = 'Test descr';
        l.city = 'test';
        l.street = 'test';
        l.state = 'CA';
        l.country = 'United States';
        l.status = 'Open';
        l.email = 'test@testcrm.com';
        l.website = 'www.testcrm.com';
        l.Lead_Stage__c='Open';
        insert l;
        
        
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='No Subject';
        t.Status='Not Started';
        t.Priority='Normal';
        t.whoId = l.id ;
        t.Status = 'Open';
        //t.Due_Date_Time__c = System.today();
        //t.ISOOffice__Comment__c = 'demo comment';
        insert t;       
    }
    
    public static testMethod void testTriggerLead()
    {
        Lead l = new Lead();
        l.FirstName = 'CRM Testing First';
        l.LastName = 'CRM Testing Last';
        l.Company = 'CRM Testing INCtest';
        l.description = 'Test descr';
        l.city = 'test';
        l.street = 'test';
        l.state = 'CA';
        l.country = 'United States';
         l.status = 'Open'; 
        //l.Status = 'Converted to Opportunity';
        l.email = 'test@testcrm.com';
        l.website = 'www.testcrm.com';
        //l.Lead_Stage__c='Converted to Opportunity';
        l.Lead_Stage__c='Open';
        l.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Commercial Leasing').getRecordTypeId();
        insert l;
        Set<Id> setId = new Set<Id>();
        
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='No Subject';
        t.Status='Not Started';
        t.Priority='Normal';
        t.whoId = l.id ;
        t.recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Commercial Lead').getRecordTypeId();
        t.Concerned_Person_Name__c = 'hello World';
        t.Copy_Lead_Data__c = true;
        //t.ISOOffice__Comment__c = 'demo comment';
        insert t; 
        setId.add(t.Id);
        
        lead l1 = [select id, Concerned_Person_Name__c from Lead where id =: l.id];
        
        //TaskTriggerHandler.updateCommercialLead(setId);
        
    } 
    
}
//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 02-11-2022
//-------------------------------------------//
@isTest
public class TestAssignmentGroupQueue {
    @isTest static void testQueueIDCopied() {
        Group q = createQueue();
        Assignment_Group__c ag = createAssignmentGroup();
        
        Assignment_Group_Queue__c agq = new Assignment_Group_Queue__c(
            Name = q.Name,
            Assignment_Group__c = ag.Id
        );
        insert agq;
        
        // Matching Salesforce Queue ID is saved to the AG-Queue
        Assignment_Group_Queue__c updatedAGQ = [Select QueueId__c, Active__c from Assignment_Group_Queue__c where Id =: agq.Id][0];
        System.assertEquals(updatedAGQ.QueueID__c, q.Id);
        
        updatedAGQ.Active__c = false;
        update updatedAGQ; // Additional trigger coverage
    }
    
    @isTest static void testCatchSameName() {
        Group q = createQueue();
        Assignment_Group__c ag = createAssignmentGroup();
        
        Assignment_Group_Queue__c agq = new Assignment_Group_Queue__c(
            Name = q.Name,
            Assignment_Group__c = ag.Id
        );
        insert agq;
        
        // Expect errors when saving another AG-Queue using the same name
        Assignment_Group_Queue__c agq2 = new Assignment_Group_Queue__c(
            Name = q.Name, // Same Queue Name
            Assignment_Group__c = ag.Id
        );
        
        Database.SaveResult result = Database.insert(agq2, false);
        System.assert(!result.isSuccess());
    }
    
    @isTest static void testNonexistentQueue() {
        Assignment_Group__c ag = createAssignmentGroup();
        
        // Expect errors when saving an AG-Queue without a corresponding Queue
        Assignment_Group_Queue__c agq = new Assignment_Group_Queue__c(
            Name = 'Some Queue I Want',
            Assignment_Group__c = ag.Id
        );
        
        Database.SaveResult result = Database.insert(agq, false);
        System.assert(!result.isSuccess());
    }
    
    private static Group createQueue() {
        Group gLead = new Group(
            Name = 'Lead Test Queue',
            DeveloperName = 'Lead_Test_Queue',
            Type = 'Queue'
        );
        insert gLead;
        
        System.runAs(new User(Id = Userinfo.getUserId())) {
            QueueSobject qLead = new QueueSobject(
                QueueId = gLead.Id,
                SObjectType = 'Lead'
            );
            insert qLead;
        }
        
        return gLead;
    }
    
    private static Assignment_Group__c createAssignmentGroup() {
        Assignment_Group__c ag = new Assignment_Group__c(
            Name = 'Test Assignment Group'
        );
        insert ag;
        return ag;
    }
}
@isTest
public class TestAssignmentGroupHandlerServices {
	
    @isTest static void testLeadTrigger() {
        // Setup test objects
        Lead l = createLead();
        createGroups();
        User u = createTestUser();
        Group g = [Select Id, Name from Group where Name = 'Lead Test Queue'];
        Assignment_Group__c ag = createAssignmentGroup();
        Assignment_Group_Queue__c agq = createAssignmentGroupQueue(ag, g);
        Assignment_Group_Member__c member = createAssignmentGroupMember(ag, u);
        
        l.OwnerId = g.Id;
        update l;
        
        Lead updatedLead = [Select OwnerId FROM Lead WHERE Id =: l.Id];
        System.assertNotEquals(updatedLead.OwnerId, g.Id);
    }
    
    @isTest static void testGroupMembersToUpdate() {
        // Setup test objects
        Lead l = createLead();
        createGroups();
        User u = createTestUser();
        Group g = [Select Id,Name from Group where Name = 'Lead Test Queue'];
        Assignment_Group__c ag = createAssignmentGroup();
        Assignment_Group_Queue__c agq = createAssignmentGroupQueue(ag, g);
        Assignment_Group_Member__c member = createAssignmentGroupMember(ag, u);
        
        Map<Id, Id> leadOwners = new Map<Id, Id>();
        leadOwners.put(l.Id, g.Id);
        AssignmentGroupHandlerServices assistant = new AssignmentGroupHandlerServices(leadOwners);
        
        // Returns an empty list if owner assignments have not been generated yet
        System.assertEquals(assistant.groupMembersToUpdate().size(), 0);
        
        assistant.newOwnerAssignments();
        
        // Returns a list of the Assignment Group Members involved in assignment
        System.assertEquals(assistant.groupMembersToUpdate().size(), 1);
        System.assertEquals(assistant.groupMembersToUpdate()[0].Id, member.Id);
    }
    
    @isTest static void testAssgnGroupsToMembers() {
        // Setup test objects
        Lead l = createLead();
        createGroups();
        User u1 = createTestUser();
        User u2 = createTestUser();
        Group g = [Select Id,Name from Group where Name = 'Lead Test Queue'];
        Assignment_Group__c ag = createAssignmentGroup();
        Assignment_Group_Queue__c agq = createAssignmentGroupQueue(ag, g);
        Assignment_Group_Member__c member1 = createAssignmentGroupMember(ag, u1);
        Assignment_Group_Member__c member2 = createAssignmentGroupMember(ag, u2);
        
        // Manually modify Last Assignment to test SOQL sort order
        member2.Last_Assigned__c = DateTime.now().addDays(-3);
        update member2;
        
        Map<Id, Id> leadOwners = new Map<Id, Id>();
        leadOwners.put(l.Id, g.Id);
        AssignmentGroupHandlerServices assistant = new AssignmentGroupHandlerServices(leadOwners);
        
        // Verify there is a map of ID -> AG-Member list
        List<Assignment_Group_Member__c> members = assistant.assgnGroupsToMembers().get(ag.Id);
        
        System.assertEquals(members[0].Id, member1.Id);  // List is sorted based on last assignment date
        System.assertEquals(members[1].Id, member2.Id);
    }
    
    @isTest static void testAssignmentGroupsToSobjects() {
        // Setup test objects
        Lead l = createLead();
        createGroups();
        Group g = [Select Id,Name from Group where Name = 'Lead Test Queue'];
        Assignment_Group__c ag = createAssignmentGroup();
        Assignment_Group_Queue__c agq = createAssignmentGroupQueue(ag, g);
        
        // Change owner to a queue
        l.OwnerId = g.Id;
        
        // Setup expected test result
        Map<Id, List<Id>> testResult = new Map<Id, List<Id>>();
        List<Id> leadList = new List<Id>();
        leadList.add(l.Id);
        testResult.put(ag.Id, leadList);
        
        Map<Id, Id> leadOwners = new Map<Id, Id>();
        leadOwners.put(l.Id, l.OwnerId);
        AssignmentGroupHandlerServices assistant = new AssignmentGroupHandlerServices(leadOwners);
        System.assertEquals(assistant.assignmentGroupsToSobjects(), testResult);
    }
    
    @isTest static void testOwnersToAssignmentGroups() {
        // Setup test objects
        Lead l = createLead();
        createGroups();
        Group g = [Select Id,Name from Group where Name = 'Lead Test Queue'];
        Assignment_Group__c ag = createAssignmentGroup();
        Assignment_Group_Queue__c agq = createAssignmentGroupQueue(ag, g);
        
        // Change owner to a queue
        l.OwnerId = g.Id;
        
        // Setup expected test result
        Map<Id, Id> testResult = new Map<Id, Id>();
        testResult.put(g.Id, ag.Id);
        
        Map<Id, Id> leadOwners = new Map<Id, Id>();
        leadOwners.put(l.Id, l.OwnerId);
        AssignmentGroupHandlerServices assistant = new AssignmentGroupHandlerServices(leadOwners);
        System.assertEquals(assistant.ownersToAssignmentGroups(), testResult);
    }
    
    private static Lead createLead() {
        Lead l = new Lead(
            LastName = 'Tester',
            MobilePhone = '1122332211',
            Email = 'tester@test.co',
            Status = 'New'
        );
        insert l;
        return l;
    }
    
    private static Group[] createGroups() {
        Group[] groups = new Group[]{};
            Group gLead = new Group(
                Name = 'Lead Test Queue',
                DeveloperName = 'Lead_Test_Queue',
                Type = 'Queue'
            );
        groups.add(gLead);
        insert groups;
        
        // Avoid mixed DML operation error
        System.runAs(new User(Id = Userinfo.getUserId())) {
            QueueSobject[] qsos = new QueueSobject[]{};
                QueueSobject qLead = new QueueSobject(
                    QueueId = gLead.Id,
                    SObjectType = 'Lead'
                );
            qsos.add(qLead);
            insert qsos;
        }
        return groups;
    }
    
    private static Assignment_Group__c createAssignmentGroup() {
        Assignment_Group__c ag = new Assignment_Group__c(
            Name = 'Test Assignment Group'
        );
        
        insert ag;
        return ag;
    }
    
    private static Assignment_Group_Queue__c createAssignmentGroupQueue(Assignment_Group__c ag, Group g) {
        Assignment_Group_Queue__c agq = new Assignment_Group_Queue__c(
            Name = g.Name,
            QueueID__c = g.Id,
            Assignment_Group__c = ag.Id,
            Active__c = true
        );
        
        insert agq;
        return agq;
    }
    
    private static Assignment_Group_Member__c createAssignmentGroupMember(Assignment_Group__c ag, User u) {
        Assignment_Group_Member__c member = new Assignment_Group_Member__c(
            Assignment_Group__c = ag.Id,
            User__c = u.Id,
            Active__c = true
        );
        
        insert member;
        return member;
    }
    
    private static User createTestUser() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        User u = new User(
            Username = uniqueName + '@test' + orgId + '.org',
            Email = uniqueName + '@test' + orgId + '.org',
            LastName = 'LastName',
            FirstName = 'FirstName',
            Alias = uniqueName.substring(18, 23),
            ProfileId = UserInfo.getProfileId(),
            EmailEncodingKey='UTF-8',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Los_Angeles',
            Country = 'US',
            Title = 'Territory Manager'
        );
        insert u;
        return u;
    }
}
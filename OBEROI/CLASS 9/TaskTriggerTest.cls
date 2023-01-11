@isTest
public class TaskTriggerTest {
    
    static List<Lead> LeadList;
    static List<Opportunity> OpptyList;
    static testMethod void TestTaskTriggerHandler(){
        OpptyList = TestDataFactory.createOpportunity(10);
       
        LeadList = TestDataFactory.createResLead(10);
        insert OpptyList;
        insert LeadList;
        integer i;
        List<Task> TaskList = new List<Task>();
        for(i =0 ; i<10; i++){
             id opid= OpptyList[i].Id;
            Task T = new Task(WhoId = LeadList[i].Id
                             );
            Task T1 = new Task(
                WhatId = opid);
            TaskList.add(T);
            TaskList.add(T1);
        }
        Test.startTest();
        insert TaskList;
        update TaskList;
         Task T3 = new Task(
                WhatId = OpptyList[0].id);
        insert t3;
        Test.stopTest();
    }
    
}
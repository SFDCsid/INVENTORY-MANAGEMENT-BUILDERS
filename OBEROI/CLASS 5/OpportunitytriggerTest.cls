@isTest
public class OpportunitytriggerTest {
    	static List<Project__c> pjRList;
    	static List<Opportunity> oppList;
    static testMethod void insertNewOpportunity() {
        Test.startTest();
		pjRList = TestDataFactory.createResProject(1);
        insert pjRList;
        oppList = TestDataFactory.createOpportunity(1);
        insert oppList;

        Test.stopTest();
       }
     	
}
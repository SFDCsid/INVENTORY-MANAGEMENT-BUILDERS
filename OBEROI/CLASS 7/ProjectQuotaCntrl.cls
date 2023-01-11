public with sharing class ProjectQuotaCntrl {
	@AuraEnabled
    public static List<Project__c> getProjectList() {
        return [SELECT Id, Name FROM Project__c WHERE Status__c NOT IN ('On Hold', 'Construction Complete')];
    }
}
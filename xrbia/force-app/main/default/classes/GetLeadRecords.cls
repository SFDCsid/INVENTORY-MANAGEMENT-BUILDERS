public with sharing class GetLeadRecords {
    public GetLeadRecords() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Lead> getLeadList() {
        return [SELECT Id, FirstName, LastName,Company,Status
            FROM Lead Where Status !=null];
    }
}

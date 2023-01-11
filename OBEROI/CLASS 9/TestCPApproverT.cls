@isTest
Public Class TestCPApproverT{
    @isTest
    public static void cpApprover(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
    
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordtypeId = accRecordTypeId; 
        acc.Tax_Number_1__c = 'ABCDF1234J'; 
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'Test Account1';
        acc1.RecordtypeId = accRecordTypeId; 
        acc1.Tax_Number_1__c = 'ABCDF1234J'; 
        insert acc1;
        
        Account acc2 = new Account();
        acc2.Name = 'Test Account2';
        acc2.RecordtypeId = accRecordTypeId; 
        acc2.Tax_Number_1__c = 'ABCDF1234J'; 
        insert acc2;
        
        
    }
}
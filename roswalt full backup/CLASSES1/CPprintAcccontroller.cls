public class CPprintAcccontroller 
{
	public List<Account> aList{get;set;}
    public Id accId {get;set;}
    public CPprintAcccontroller() 
    { 
        accId = Null;
        accId = ApexPages.currentPage().getParameters().get('accId');
        system.debug('accId:::::::::::::::::::::::::::::::'+accId);
        RecordType rt = new RecordType();
        rt = [Select Id, DeveloperName, Name from RecordType where Name =: 'Channel Partner'];  
        system.debug('rt:::::::::::::::::::::::::::::::'+rt);
        aList = [Select Id, Name,CreatedDate,CreatedDate__c,Phone,Location1__c,Sourcing_Executive_Manager__r.Name,Point_of_Contact_Name__c,Point_of_Contact_Mobile__c,MahaRERA_Registration_No__c,CP_Type__c,CP_Stage__c,TAN_No__c,Location__c,CP_Firm_Type__c ,Point_of_Contact__c,Point_of_Contact__r.Name,Alternate_Mobile_No__c , BillingAddress , Email__c,PAN_No__c ,GST_No__c,PAN_Card__c,GST_Registration_Certificate__c,Passport__c,RERA_Certificate__c,Name_as_per_MahaRERA__c,
                 RecordTypeId,CP_Unique_Code__c,BillingCountry, BillingPostalCode, BillingState, BillingCity, BillingStreet
                 from Account  where Id =:accId AND RecordTypeId=:rt.id];
           system.debug('aList:::::::::::::::::::::::::::::::'+aList);
            }
}
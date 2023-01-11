public class PrimaryApplicantController {

    Public id bId{get;set;}
    Public List<Applicant__c> aplist{get;set;}
    
    Public void PrimaryApplicantController(){
        aplist = new List<Applicant__c>();
    }
    
    public void getPrimaryapplicant(){
        aplist = [Select id,Name,House_No__c,Street_1__c,Street_2__c,Street_3__c,Locality__c,City__c,State__c,Country__c,Pincode__c from Applicant__c where Booking__c =:bId and Applicant_Number__c =: 'Primary Applicant'];
    }
}
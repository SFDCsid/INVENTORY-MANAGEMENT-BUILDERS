public class ApplicantName {
    public Id bId{get;set;}
    Public Date tdate{get;set;}
    Public String SDate{get;set;}
    public list<Applicant__c> aplist {get;set;}
    public list<Applicant__c> aplist1 {get;set;}
    
    public ApplicantName(){
    aplist = new List<Applicant__c>();
        aplist1 = new List<Applicant__c>();
        tdate = Date.today();
        SDate = tdate.format();
    }
    
     public void getapplicant(){
         aplist = [Select id,Name,House_No__c,Street_1__c,Street_2__c,Street_3__c,Locality__c,City__c,State__c,Country__c,Pincode__c from Applicant__c where Booking__c =:bId];
     		aplist1 = [Select id,Name,House_No__c,Street_1__c,Street_2__c,Street_3__c,Locality__c,City__c,State__c,Country__c,Pincode__c from Applicant__c where Booking__c =:bId and Applicant_Number__c =: 'Primary Applicant'];
     }
    

}
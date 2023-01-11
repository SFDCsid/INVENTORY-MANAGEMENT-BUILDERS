public class NominationController {
    
    public id bkid;
    public Booking__c bk{get;set;}
    public List<Applicant__c> appList{get;set;}
    
    public NominationController(){
        bkid = apexpages.currentpage().getparameters().get('id');
        
        bk = [select id, Name,Project__r.Name,Tower__r.Name from Booking__c where id =: bkid];
        appList = [select id,Name,Salutation__c,Booking__c from Applicant__c where Booking__c =: bkid];
    }

}
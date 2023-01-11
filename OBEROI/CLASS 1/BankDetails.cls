public class BankDetails {
    public string bId {
        get;
        set{
            bId = value;
            if(bId != null)
                bankdetails();
        }
    }
    Public Booking__c blist{get;set;}
    Public Property__c plist{get;set;}
    
    public BankDetails(){
        blist = new Booking__c();
        plist = new Property__c();
    }
    
    public void bankdetails(){
        blist = [Select Id,Name,Project__c,Property__c from Booking__c where Id =: bId];
        plist = [Select Id,Name,Name_of_Account__c,Account_No__c,Branch__c,Cheque_Favoring__c,
                 IFS_Code__c,Bank_Name__c from Property__c where id =: blist.Property__c];
    }
}
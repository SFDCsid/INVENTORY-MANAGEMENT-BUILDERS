public class ChannelPartnerDuplication
{
    public List<account> ChannelPartnerDuplication(List<account> acccList)
    {  
        RecordType rt = new RecordType();
        List<Account> duplicateAccountList = new List<Account>();
        rt = [Select Id, DeveloperName, Name from RecordType where Name =: 'Channel Partner']; 
        duplicateAccountList = [Select Id, Name,Point_of_Contact_Mobile__c,MahaRERA_Registration_No__c,RecordTypeId from Account where RecordTypeId=:rt.id];
        return duplicateAccountList;
    }

}
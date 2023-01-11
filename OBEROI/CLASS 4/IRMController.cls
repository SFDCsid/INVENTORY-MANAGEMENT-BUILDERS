public class IRMController {
    
    public ContentVersion versionDetails{get;set;}
    public contentDocumentLink CDLink{get;set;}
    public IRMController() {
        String versionId = ApexPages.currentPage().getParameters().get('id');
        versionDetails = [Select Id ,VersionNumber,Description ,ContentDocumentId,SharingOption,SharingPrivacy,Title from ContentVersion where id=:versionId] ;
        //CDLink = [SELECT ContentDocumentid, LinkedEntityid FROM contentDocumentLink WHERE ContentDocumentid =:versionDetails.ContentDocumentId];
        //String objectName = Schema.GlobalDescribe.findObjectNameFromRecordIdPrefix('a1J'); 
        //System.debug(objectName);
    }
    

}
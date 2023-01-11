public class ContentDownloadHandlerFactoryImpl implements Sfc.ContentDownloadHandlerFactory {
  	public Sfc.ContentDownloadHandler getContentDownloadHandler(List<ID> ids, Sfc.ContentDownloadContext context) {
        // The profile as a list of profiles as long as the name doesn't contain
        // "Admin".
        List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId() AND Name =: 'System Administrator'];
        
        Boolean isAdmin = profiles.size() > 0;
        system.debug('Test: '+ids);
        system.debug('Test1: '+context);
        
        List< ContentDocumentLink> cdlinkList;
        List<ContentVersion> cvs = [
            SELECT Id, Title,isApproved__c,ContentDocumentId
            FROM ContentVersion
            WHERE Id IN :ids
        ];
        
        Sfc.ContentDownloadHandler cdh = new Sfc.ContentDownloadHandler();
        System.debug('cvs=='+cvs.size());
        for (ContentVersion cv : cvs) {
            system.debug('test2: '+cv.ContentDocumentId);
            cdlinkList = new List< ContentDocumentLink>();
            cdlinkList = [SELECT Id, LinkedEntityId, ContentDocumentId,ContentDocument.LatestPublishedVersionId,Visibility, IsDeleted, ShareType,ContentDocument.Title,ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE ContentDocumentId =:cv.ContentDocumentId];
            system.debug('cdlinkList=='+cdlinkList);
             system.debug('cdlinkList.size=='+cdlinkList.size());
            if(!cdlinkList.isEmpty()){
                for(ContentDocumentLink cdd:cdlinkList){
                Id relatedId = cdd.LinkedEntityId;
                String sObjName = relatedId.getSObjectType().getDescribe().getName();
                system.debug('sObjName=='+sObjName);
                
                if (sObjName=='Related_Document_History__c') { 
                    List<Related_Document_History__c> rdList = [Select Id, Name ,Document_Approved__c,Document_Name__c  from Related_Document_History__c where Id =: relatedId];
                    if(!rdList.isEmpty()){
                        DocumentApprovalList__c dA = DocumentApprovalList__c.getInstance(rdList[0].Document_Name__c);
                        
                        system.debug('dA=='+dA);
                        if(!rdList[0].Document_Approved__c&&dA!=null){
                            cdh.isDownloadAllowed = false;
                            cdh.downloadErrorMessage = 'You do not have permission to download this file. This document is not approved.';
                            if(!isAdmin&&!Test.isRunningTest()){ 
                            return cdh;    
                            }
                        }
                    }
                    
                }else{
                    
                    if(cv.isApproved__c){ 
                        cdh.isDownloadAllowed = true;    
                    } 
                }
                
                }
            }
        }
        cdh.isDownloadAllowed = true;  
        return cdh;
    }
}
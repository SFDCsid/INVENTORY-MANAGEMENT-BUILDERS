public class FileUtil {

    public Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType, Id contentDocumentId) { 
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.ContentDocumentId = contentDocumentId;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = fileName;
        cv.PathOnClient = filename;
        
        insert cv;
        
        //***This DEBUG statement must return an Id for the rest of the code to work***
        System.debug('contentDocumentId='+cv.ContentDocumentId);               
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = parentId;
        cdl.ShareType = 'V';
        insert cdl;        
        return cv.Id;
    }
}
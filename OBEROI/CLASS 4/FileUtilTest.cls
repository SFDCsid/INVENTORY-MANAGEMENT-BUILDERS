@isTest
public class FileUtilTest {
    static Id parentId,contentDocumentId;
    static String fileName,base64Data,contentType;
    @TestSetup
    public static void FileUtilTestData() {
        parentId='a0Fp0000004HWfvEAG';
        fileName='Hello';
        base64Data='azgdhdgshbsfcgschscvhs';
        contentType='pdf';
        contentDocumentId='a0Fp0000004HWfvEAG';
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
        contentDocumentId=content.ContentDocumentId;
        
        
    }
    @isTest static void testFileUtil() {
        FileUtilTestData();
        FileUtil file=new FileUtil();
        system.debug('parentId---'+parentId+'---fileName---'+fileName+'---base64Data---'+base64Data+'---'+contentType+'---'+contentDocumentId);
        file.saveTheFile(parentId,fileName, base64Data,contentType, contentDocumentId); 
        
    }
    
    
}
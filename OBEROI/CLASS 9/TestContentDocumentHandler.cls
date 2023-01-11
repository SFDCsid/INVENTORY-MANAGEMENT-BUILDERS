@isTest
public class TestContentDocumentHandler {

    
    @isTest
   public static void TestViewFiles(){
               List<DocumentApprovalList__c> daList = new List<DocumentApprovalList__c>();
        DocumentApprovalList__c da = new DocumentApprovalList__c();
        da.Name = 'Acceptance Form';
        daList.add(da);
        
         DocumentApprovalList__c da2 = new DocumentApprovalList__c();
        da2.Name = 'Agreement Form';
        daList.add(da2);
        
         DocumentApprovalList__c da3 = new DocumentApprovalList__c();
        da3.Name = 'Allotment Form';
        daList.add(da3);
        
        
         DocumentApprovalList__c da4 = new DocumentApprovalList__c();
        da4.Name = 'Bank NOC';
        daList.add(da4);
        
         DocumentApprovalList__c da5 = new DocumentApprovalList__c();
        da5.Name = 'Provisional NOC';
        daList.add(da5);
        
         DocumentApprovalList__c da6 = new DocumentApprovalList__c();
        da6.Name = 'TPA';
        daList.add(da6);
        
        if(!daList.isEmpty()){
            insert daList;
        }
       List<Related_Document_History__c> rlist = new List<Related_Document_History__c>();
        Related_Document_History__c r;
                r = new Related_Document_History__c();
                r.Name = 'Bank NOC';
                r.Submitted_for_Approval__c=true;
                rlist.add(r);
         if(!rlist.isEmpty()){
            insert rlist;         
        }
       
        
        Contentversion cv = new Contentversion();
        cv.Title = 'ABC';
        cv.PathOnClient = 'test';
        cv.isDocGen__c = true;
        cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.urlEncode('Unit Test Attachment Body','UTF-8'));
        insert cv;
       
         ContentDocumentLink cdl = new ContentDocumentLink();
      cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
      cdl.LinkedEntityId = rlist[0].id; // <----- put your record id here, example: an account tid
      cdl.ShareType = 'V';
      insert cdl;
       
         ContentDownloadHandlerFactoryImpl f = new ContentDownloadHandlerFactoryImpl() ;
        f.getContentDownloadHandler(new List<Id>{cv.Id}, null);
   }
}
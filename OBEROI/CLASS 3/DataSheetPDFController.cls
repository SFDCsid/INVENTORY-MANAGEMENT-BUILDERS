Public class DataSheetPDFController{
   
      @AuraEnabled
    public static string getLeadDetails(string recId)
    {   
        PageReference pdfPage = new PageReference('/apex/ORL_TDSSelfDeclaration');
        system.debug(recId);
        pdfPage.getParameters().put('Id', recId);
        Blob pdfContent = null;
        
        if(Test.isRunningTest()){
           pdfContent = Blob.valueOf('pdfContent'); 
        } else {
         pdfContent = pdfPage.getContent(); 
        }
        
        Attachment attach1= new Attachment();
        attach1.ParentId = recId;
        attach1.Name = 'Test Attachment for PDF';
        attach1.Body = pdfContent;
        attach1.contentType = 'application/pdf';
        insert attach1;
        system.debug(attach1+'**');
        redirect(recId);
        return attach1.Id;
       // Lead ld =[SELECT id, Name,address, LeadSource FROM Lead Where id=:recId];
        //return ld;
       // PageReference pg = new PageReference ('/apex/DataSheetVF');
        // return pg;
    }
    
    public static PageReference redirect(string recId){
        system.debug('In Redirect');
        PageReference pg = new PageReference ('/apex/DataSheetVF');
        pg.getParameters().put('Id', recId);
       
         return pg;  
    }
   /* 
    @auraEnabled
    public static void savePDFOpportunity(){
        PageReference pdfPage = new PageReference('/apex/TextVFPDF');
        pdfPage.getParameters().put('Id', '0062800000C044o');
        Blob pdfContent = pdfPage.getContent();
        
        Attachment attach1= new Attachment();
        attach1.ParentId = '0010K00001e2kcG';
        attach1.Name = 'Test Attachment for PDF';
        attach1.Body = pdfContent;
        attach1.contentType = 'application/pdf';
        insert attach1;
        
    }
 */
}
public class ViewQuotationPDF{
    public PageReference insertAttachment1(){
        string qId = apexpages.currentpage().getparameters().get('qId');
        List<Quotation__c> Qlist = new List<Quotation__c>();
        
        Qlist = [Select id,name FROM Quotation__c WHERE Id =: qId];
        
        /*PageReference pdfPage = new PageReference('/apex/ViewQuotation?qId='+qId);
        blob pg = null;
        DateTime d = system.NOW();
        system.debug('pg'+pg);
        
        if(Test.isRunningTest()){
            pg = Blob.valueOf('pg'); 
        } else {
            pg = pdfPage.getContentAsPDF(); 
        }
        
        Attachment attach1= new Attachment();
        attach1.ParentId = qId;
        attach1.Name = 'Quotation_'+qlist[0].Name+'_'+d;
        attach1.Body=pg;
        attach1.contentType = 'application/pdf';
        insert attach1;*/
        
        DateTime d = system.NOW();
        PageReference pageRef = new PageReference('/apex/ViewQuotationAttachment');
        pageRef.getParameters().put('qId', qId);
        
        Blob fileContent;
        fileContent = pageRef.getContentAsPDF();
        
        ContentVersion cont = new ContentVersion();
        cont.Title = 'Quotation_'+qlist[0].Name+'_'+d;
        cont.VersionData = fileContent;
        cont.PathOnClient =  'Quotation_'+qlist[0].Name+'_'+d+'.pdf';
        cont.ContentLocation = 'S';
        cont.Description =  'Quotation_'+qlist[0].Name+'_'+d;
        cont.TagCSV =  'Quotation_'+qlist[0].Name+'_'+d;
        insert cont;
        
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = cont.ContentDocumentId;
        cDe.LinkedEntityId = qId; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        insert cDe;
              
        return pageRef;
        
    }
}
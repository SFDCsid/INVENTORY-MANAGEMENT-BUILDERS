public class DataSheetPDF2 {
    public DataSheetPDF2(ApexPages.StandardController controller) {
    }
	public PageReference insertAttachment1( )
    {
        Id opId = apexpages.currentpage().getparameters().get('Id');
        PageReference pdfPage = new PageReference('/apex/DataSheetAttachment?id='+opId);
        blob pg = null;
        DateTime d = system.NOW();
		//String dateStr =  d.format('dd-MM') ;
        system.debug('pg'+pg);
        
        if(Test.isRunningTest()){
           pg = Blob.valueOf('pg'); 
        } else {
         pg = pdfPage.getContentAsPDF(); 
        }
        
        Attachment attach1= new Attachment();
                attach1.ParentId = opId;
                attach1.Name = 'Customer_Data_Sheet_'+d;
                
                attach1.Body=pg;
                attach1.contentType = 'application/pdf';
        insert attach1;
        return pdfPage;
        
    }
}
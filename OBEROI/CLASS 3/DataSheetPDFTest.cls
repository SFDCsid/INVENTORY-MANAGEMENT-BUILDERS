@isTest
public class DataSheetPDFTest { 
    
    private static testmethod void SendEmailCustomerDetailPdf1()
    {
        List<Opportunity> opps = TestDataFactory.createOpportunity(1);
        insert opps;
        ApexPages.CurrentPage().getparameters().put('id', opps[0].id);      
        
        Apexpages.StandardController sc = new Apexpages.StandardController(opps[0]);
        DataSheetPDF ext = new DataSheetPDF(sc);     
        
    }
    
    static testMethod void testInsertAttachments(){
        Blob input = Blob.valueOf('Hello Abc, Testing here');
        //DataSheetPDF.insertAttachment(input);
    }
    
    static testMethod void testGetRedir(){
        Blob input = Blob.valueOf('Hello Abc, Testing here');
        
        
        List<Opportunity> opps = TestDataFactory.createOpportunity(1);
        insert opps;
        Attachment a=  new Attachment(
            ContentType='image/jpeg',
            Body=input,
            Name='CP_Signature' 
            
        );
        a.ParentId = opps[0].id;
        insert a;
        Attachment a1=  new Attachment(
            ContentType='image/jpeg',
            Body=input,
            Name='Signature' 
            
        );
        a1.ParentId = opps[0].id;
        insert a1;
        ApexPages.CurrentPage().getparameters().put('id', opps[0].id);      
        
        Apexpages.StandardController sc = new Apexpages.StandardController(opps[0]);
        DataSheetPDF ext = new DataSheetPDF(sc); 
        //PageReference result = ext.getRedir();
        //system.assert(result!=null);
    }
}
@isTest
public class DataSheetPDF2Test {
    private static testmethod void demoMethod()
    {
        List<Opportunity> opps = TestDataFactory.createOpportunity(1);
        insert opps;
        ApexPages.CurrentPage().getparameters().put('id', opps[0].id);      
        
        Apexpages.StandardController sc = new Apexpages.StandardController(opps[0]);
        DataSheetPDF ext2 = new DataSheetPDF(sc);
        DataSheetPDF2 ext = new DataSheetPDF2(sc);   
        PageReference result = ext.insertAttachment1();
        system.assert(result!=null);
    }
}
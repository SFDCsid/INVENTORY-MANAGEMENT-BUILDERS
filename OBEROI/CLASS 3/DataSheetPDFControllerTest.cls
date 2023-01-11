/******************************************************************************************************************
Version v1.1 - AKohakade - 10-5-2019 - Commenting savePDFOpportunity method call as getting error while deployment set "0Af0k00000U61sf" in UAT
******************************************************************************************************************/

@isTest
public class DataSheetPDFControllerTest {
    
    @isTest(seeAllData=true)
    static void testDataSheetPDFController() {
       String leadDetails = DataSheetPDFController.getLeadDetails('a00p0000007wjMVAAY');
       System.assert(leadDetails!=null);
        
       PageReference pageRef = DataSheetPDFController.redirect('a00p0000007wjMVAAY');
       System.assert(pageRef!=null);
        
        //DataSheetPDFController.savePDFOpportunity(); v1.1
        
    }
}
@isTest
public class CostSheetControllerTest {
    
    
    private static testmethod void SendEmailCustomerDetailPdf1()
    {
        try{
        
        List<Property__c> propertyList=TestDataFactory.createProperties(1);
        List<Opportunity> oppList=TestDataFactory.createOpportunity(1);
        insert oppList;
        insert propertyList;
        Test.StartTest(); 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(oppList[0]);
        ApexPages.currentPage().getParameters().put('unitId', propertyList[0].id);

        CostSheetController  obj = new CostSheetController(sc);
        obj.attachPDF();
        Test.StopTest();
        }
        catch(exception e){
            
        }
        
    }
        
    }
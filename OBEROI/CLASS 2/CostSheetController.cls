public class CostSheetController {
    public Opportunity opp {get; set;}
    public String propertyId {get;set;}
    public Property__c prop {get; set;}
    public decimal sum {get;set;}
    public list <Billing_Plan_Line_item__c> paySchedule {get; set;}
    public CostSheetController (ApexPages.StandardController standardPageController) {
        this.opp = (Opportunity)standardPageController.getRecord();
        this.propertyId = ApexPages.currentPage().getParameters().get('unitId');
        prop = [select id, Name, House_Unit_No__c, Floor__r.Floor_Number__c, Tower__r.Tower_Name__c, Project_Name__r.Name, Property_Type__r.Name__c,Carpet_Area__c, Project_Name__r.Default_Car_Parking__c, Total_Sales_Price__c, Project_Name__r.Company_name__c
                from Property__c
                where id=: propertyId];
                
        RecordType rt = [select id
                         from RecordType
                         where DeveloperName='Default_Billing_Plan'
                         and SObjectType = 'Payment_Plan__c'];
        list <Payment_Plan__c> billingPlan = [select id
                                              from Payment_Plan__c
                                              where RecordTypeId=: rt.Id
                                              and Property__c =: propertyId
                                              LIMIT 1];
        //assuming that printable records reside here                                      
        paySchedule  = [select id, Name, Percentage_Of_Value_To_Be_Invoiced__c, Amount__c, Amount_Incl_S_Tax__c
                        from Billing_Plan_Line_item__c
                        where Payment_Plan__c =: billingPlan[0].Id
                        order by Sequence_Number__c];
                        
        sum = 0;
        for(Billing_Plan_Line_item__c pay : paySchedule  ){
           sum += pay.Amount__c;
        }
    }
    public PageReference attachPDF() {
        PageReference pdfPage = Page.ORL_CostSheetFormat; 
        Blob pdfBlob; 
        if (!Test.isRunningTest()) { //if we are not in testing context
            pdfBlob = pdfPage.getContent(); 
        } else { //otherwise, we are in testing context and getContent() gets funky so create the blob manually
            pdfBlob = Blob.valueOf('Some Text for a boring PDF file...');
        }
        Attachment attach = new Attachment(parentId = opp.Id, Name = 'CostSheet.pdf', body = pdfBlob); 
        insert attach; //insert the attachment

        //redirect the user
        PageReference pageWhereWeWantToGo = new ApexPages.StandardController(opp).view(); //we want to redirect the User back to the Account detail page
        pageWhereWeWantToGo.setRedirect(true); //indicate that the redirect should be performed on the client side
        return pageWhereWeWantToGo; //send the User on their way
    }
    
}
public with sharing class ROFRQuotation{

    public Id unitId{get;set;}
    public Id QuoteId{get;set;}
    public Id NewQuoteId{get;set;}
    public Id optyId{get;set;}
    public List<opportunity> optyList{get;set;}
    public List<Quotation__c> QoriginalList{get;set;}
    public List<Quotation__c> QcloneList{get;set;}
    public List<Quotation_Billing_Line_Item__c> QuoteLineItemslist{get;set;}
    public List<Quotation_Billing_Line_Item__c> QuoteLineItemscloneList{get;set;}
    
    
    public ROFRQuotation() {
    
    optyList = new List<opportunity>();
    QoriginalList = new List<Quotation__c>();
    QuoteLineItemslist = new List<Quotation_Billing_Line_Item__c>();
    
        if(ApexPages.currentPage().getParameters().get('optyid') != null && ApexPages.currentPage().getParameters().get('optyid') != '') {
            optyId = ApexPages.currentPage().getParameters().get('optyid');
            system.debug('inside contructor optyId' + optyId);
        }
        
       if(optyId != null){
            optyList = [Select Id, Name,Old_Booking__c,Refrence_Quotation__c,Previous_Customer_Name__c,Previous_SalesOrder_Number__c,Previous_Customer_Code__c,
            Old_Booking__r.Status__c,Old_Booking__r.Unitcode__c,Old_Booking__r.Tower_Name__c,Old_Booking__r.Project__r.Name,Old_Booking__r.Quotation__r.Unit_Floor_No__c,
            Old_Booking__r.Quotation__r.Carpet_Area__c,Old_Booking__r.Quotation__r.Unit_Configuration__c,Old_Booking__r.Quotation__r.Type_of_Booking__c,
            Old_Booking__r.Quotation__r.Total_Agreement_Value_Original__c,Old_Booking__r.Quotation__r.Total_Agreement_Value_Modified__c,Old_Booking__r.Quotation__r.Total_Additional_Charges_Original__c,
            Old_Booking__r.Quotation__r.Total_Additional_Charges_Modified__c,Old_Booking__r.Quotation__r.Total_CSGT_Original__c,Old_Booking__r.Quotation__r.Total_CSGT_Modified__c,
            Old_Booking__r.Quotation__r.Total_SGST_Original__c,Old_Booking__r.Quotation__r.Total_SGST_Modified__c,Old_Booking__r.Quotation__r.Discount_Applied__c,
            Old_Booking__r.Quotation__r.Customized_Billing_Plan__c,Old_Booking__r.Quotation__r.Additional_Car_Park_Applied__c
            From opportunity WHERE Id =: optyId];
            
            QuoteId = optyList[0].Old_Booking__r.Quotation__c;             
        }
        if(QuoteId != null){
            QuoteLineItemslist = [Select id, name,Sequence_Number__c,Line_Item_Name__c,Due_After_Days__c,Due_Date__c,Percentage_Of_Value_To_Be_Invoiced__c,
            Milestone_Amount__c,Total_GST__c,Is_Milestone_Billed__c FROM Quotation_Billing_Line_Item__c WHERE Quotation__c =: QuoteId ORDER BY Sequence_Number__c ASC];         
        }
        
    }
    
    public PageReference Save() {
        if(QuoteId != null){
            DescribeSObjectResult QuoteOBJ = Quotation__c.getSObjectType().getDescribe(); 
            List<String> Quotefield = new List<String>( QuoteOBJ.fields.getMap().keySet() );
            String QuoteQuery = ' SELECT ' + String.join( Quotefield, ',' ) +
            ' FROM ' + QuoteOBJ.getName() + ' where id=' + '\'' + QuoteId + '\''; 
            QoriginalList =  Database.query( QuoteQuery );
            QcloneList = QoriginalList.deepClone();
            System.debug('QcloneList::::::::::::'+QcloneList);
            for(Quotation__c q:QcloneList){
            q.booking__c = null;
            q.Final_Approved_Date__c = System.today();
            q.Opportunity__c = optyId;
            }
            Insert QcloneList;
            NewQuoteId = QcloneList[0].id;
            
            DescribeSObjectResult QLIobj = Quotation_Billing_Line_Item__c.getSObjectType().getDescribe(); 
            List<String> QLIfield = new List<String>( QLIobj.fields.getMap().keySet() );
            String QLIQuery = ' SELECT ' + String.join( QLIfield, ',' ) +
            ' FROM ' + QLIobj.getName() + ' where Quotation__c =' + '\'' + QuoteId + '\''; 
            QuoteLineItemslist =  Database.query( QLIQuery );
            QuoteLineItemscloneList = QuoteLineItemslist.deepClone();
            System.debug('QuoteLineItemscloneList::::::::::::'+QuoteLineItemscloneList);
            for(Quotation_Billing_Line_Item__c qli :QuoteLineItemscloneList){
                qli.Quotation__c = NewQuoteId;
            }
            Insert QuoteLineItemscloneList;
        }
    PageReference newpage = new Pagereference('/'+NewQuoteId);
    return newpage;
    }
    public PageReference Cancel() {
        PageReference newpage = new Pagereference('/'+optyId);
        return newpage;
    }
    public PageReference CheckValidation(){     
        if(optyList.size()>0){
            If(optyList[0].Old_Booking__c != null){
            }
            Else{ 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Refrence of old booking not found on this opportunity');
                ApexPages.addMessage(myMsg);
            }
            if(optyList[0].Old_Booking__r.Status__c != 'Cancelled'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Old booking tagged to this opportunity is not Cancelled yet');
                ApexPages.addMessage(myMsg);
            }
        }
        return null;   
    } 
}
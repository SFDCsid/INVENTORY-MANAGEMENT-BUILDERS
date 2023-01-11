public class UpdateQuoteLineItems {

    public Id QId {get; set;}
    public List<Quotation_Billing_Line_Item__c> quoteLineItems {get;set;}

    public UpdateQuoteLineItems(){
         if(ApexPages.currentPage().getParameters().get('QuoteId') != '')      
          QId = (Id)ApexPages.currentPage().getParameters().get('QuoteId');
          
          If(Qid != Null){
              quoteLineItems = [select Id, Name FROM Quotation_Billing_Line_Item__c WHERE Quotation__c =: Qid];
          }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Quotation_Billing_Line_Item__c> GetQuoteLineItems(string Quoteid) {
        List<Quotation_Billing_Line_Item__c> qlList = new List<Quotation_Billing_Line_Item__c>();
        qlList = [select Id, Name FROM Quotation_Billing_Line_Item__c WHERE Quotation__c =: Quoteid];
        system.debug('qlList::'+qlList);
        return qlList;
    }
}
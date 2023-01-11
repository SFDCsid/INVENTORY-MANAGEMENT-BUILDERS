public class CustomizedPaymentPlanController {
     
     @AuraEnabled
     public static opportunity saveWrapperDetails(Opportunity oppty ,list<Milestone__c> mnList )
    {    system.debug('In apex'+oppty+' '+mnList);
         //insert oppty;mnList
         string test ='t';      
        return null;
    }
    
    
    @AuraEnabled
    public static list<BillingPlanWrapper> getBillingPlanDetails(string recId)
    {
        list<BillingPlanWrapper> bpWrapperList = new list<BillingPlanWrapper>();
        Opportunity opp =  getOpptyDetails(recId);
        Id towRecId='a0Hp0000005UGp7';
        List<Payment_Plan_Line_Item__c> blList = billingLineItems(towRecId);
        BillingPlanWrapper bpw = new BillingPlanWrapper(opp,blList);
        system.debug(bpw+' *******');
        bpWrapperList.add(bpw);
        return bpWrapperList;
        
    }
    
    //Method to fetch Opportunity details
    @AuraEnabled
    public static Opportunity getOpptyDetails(string recId){        
        Opportunity opp = [SELECT id,name,project__r.name, Default_Payment_Plan__c,project__c,Property__c,Property__r.name,recordtypeId FROM Opportunity where id =: recId]; 
        return opp;
    }
    
    
    //Method to fetch Billing Plan line item details
    @AuraEnabled
    public static list<Payment_Plan_Line_Item__c> billingLineItems(string towRecId){
        Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
        List<Payment_Plan_Line_Item__c> billingPlanLineItemList = new List<Payment_Plan_Line_Item__c>();
        //Payment_Plan__c billingPlanObj = [SELECT Id
        //Code update.... 08/04/2019
        List<Payment_Plan__c> billingPlanObj = [SELECT Id
                                            FROM Payment_Plan__c
                                            WHERE Tower__c =:towRecId
                                            AND RecordTypeid =: defaultRecordTypeId
                                            AND Active__c = true ];
         
        if(billingPlanObj != NULL && billingPlanObj.size()>0){
            system.debug('@@billingPlanObj '+billingPlanObj );
            billingPlanLineItemList = [SELECT Id,Name,Description__c
                                       FROM Payment_Plan_Line_Item__c
                                       WHERE Payment_Plan__c =:billingPlanObj[0].Id];
            system.debug('@@billingPlanLineItemList'+billingPlanLineItemList);
            system.debug('@@billingPlanLineItemList'+billingPlanLineItemList.size());
            
        }
        return billingPlanLineItemList;
        
    }
    
    //Wrapper class for Oppty and Billing Plan Line Item List  
    public class BillingPlanWrapper {
          @AuraEnabled Public Opportunity oppObj { get; set;}
          @AuraEnabled Public list<Payment_Plan_Line_Item__c> bplitemList{get; set;}
        
        public BillingPlanWrapper(Opportunity oppty ,list<Payment_Plan_Line_Item__c> bplList ) {
            oppObj = oppty;
            bplitemList = bplList;
        }
    }   
    
   
}
public class ReadOnlyBillingLineItem{
    
    // To fetch Billing Plan and Billing Plan Line Item 
    @AuraEnabled
    public static list<BillingPlanWrapper> getBillingPlanDetails(Id bpID)
    {
        list<BillingPlanWrapper> bpWrapperList = new list<BillingPlanWrapper>();
        Payment_Plan__c BillingObj = getBillingPlan(bpID);
        List<Billing_Plan_Line_Item__c> bplList = getBillingPlanLineItem(bpID);
        BillingPlanWrapper bpw = new BillingPlanWrapper(BillingObj ,bplList);
        bpWrapperList.add(bpw);
        return bpWrapperList;
    }
    
    // To get Billing Plan Details
    @AuraEnabled
    public static Payment_Plan__c getBillingPlan(Id bpId){
        system.debug('@@xx--'+bpId);
        Payment_Plan__c  ppObj = [SELECT Id,Basic_Cost_Formula__c,Basic_Cost_After_Discount_Formula__c,Floor_Rise_Cost_Formula__c,Floor_Rise_Cost_After_Discount_Formula__c,
                                  PLC_Cost_Formula__c,PLC_Cost_After_Discount_Formula__c,Total_Sales_Amount__c,Total_Sales_Amount_Time_of_Booking__c
                                  FROM Payment_Plan__c 
                                  WHERE Id=:bpId];
        return ppObj ;
    }
    
    //Method to fetch Billing Plan line item details from existing or from Default Billing Plan
    @AuraEnabled
    public static list<Billing_Plan_Line_Item__c> getBillingPlanLineItem(Id bpId){
        Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
        List<Billing_Plan_Line_Item__c> billingPlanLineItemList = new List<Billing_Plan_Line_Item__c>();
        //Existing Billing Plan Line Item
        List<Billing_Plan_Line_Item__c> existingBillingPlanLineItemList = [SELECT Id,Line_Item_Amount__c,Name,Amount__c,Payment_Plan_Line_Item_Name__c,Payment_Group__c,
                                                                           Percentage_Of_Value_To_Be_Invoiced__c, Milestone_Number__c,
                                                                           Terms_of_Payment_Key__c,Line_Item_Type__c,Order__c,Due_After_Days__c
                                                                           FROM Billing_Plan_Line_Item__c
                                                                           WHERE Payment_Plan__c =:bpID order by order__c asc];
        system.debug('existingBillingPlanLineItemList--->'+existingBillingPlanLineItemList);
        if(existingBillingPlanLineItemList.size()>0){
            return existingBillingPlanLineItemList;
        }
        
        else{            
            Id towRecId = [SELECT Id,Tower__c 
                           FROM Payment_Plan__c
                           WHERE Id =:bpID].Tower__c;
            system.debug('towRecId--'+towRecId );
            Payment_Plan__c billingPlanObj = [SELECT Id, Tower__c
                                              FROM Payment_Plan__c
                                              WHERE Tower__c =:towRecId
                                              AND RecordTypeid =: defaultRecordTypeId
                                              AND Active__c = true
                                              AND Created_By_SAP__c=true ];
            system.debug('@@billingPlanObj '+billingPlanObj );           
            // Default Billing Plan Line Item
            billingPlanLineItemList = [SELECT Id,Line_Item_Amount__c,Name,Amount__c,Payment_Plan_Line_Item_Name__c,Payment_Group__c,
                                       Percentage_Of_Value_To_Be_Invoiced__c, Milestone_Number__c,
                                       Terms_of_Payment_Key__c,Line_Item_Type__c,Order__c,Due_After_Days__c
                                       FROM Billing_Plan_Line_Item__c
                                       WHERE Payment_Plan__c =:billingPlanObj.Id order by order__c asc];
            system.debug('@@billingPlanLineItemList'+billingPlanLineItemList);
            system.debug('@@billingPlanLineItemList'+billingPlanLineItemList.size());
            return billingPlanLineItemList;}
    }
    
    //Wrapper class for Oppty and Billing Plan Line Item List  
    public class BillingPlanWrapper {
        @AuraEnabled Public Payment_Plan__c billingPlanObj { get; set;}
        @AuraEnabled Public list<Billing_Plan_Line_Item__c> bplitemList{get; set;}
        
        public BillingPlanWrapper(Payment_Plan__c billingObj ,list<Billing_Plan_Line_Item__c> bplList) {
            billingPlanObj = billingObj;
            bplitemList = bplList;
        }
    }
}
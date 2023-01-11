/*
*  Author: IBM India Pvt. Ltd.
*/
public class PricingTriggerHandler{

    public static void onBeforeInsert(List<Pricing__c> priceList) { 
        Set<Id> setPropertyType = new Set<Id>();
        Set<Id> setPType = new Set<Id>();
        for(Pricing__c pr : priceList){
            if(pr.Type__c == 'Non Scheme' && pr.Active__c){
                setPropertyType.add(pr.Property_Type__c);
            }
        }
        if(setPropertyType != null && setPropertyType.size()> 0){
            for(Pricing__c pr : [select id,Type__c,Property_Type__c from Pricing__c where Active__c = true and Property_Type__c IN: setPropertyType]){
                if(pr.Type__c == 'Non Scheme'){
                    setPType.add(pr.Property_Type__c);
                }
            }
        }
        if(setPType != null && setPType.size()> 0){
            for(Pricing__c pr : priceList){
                if(setPType.contains(pr.Property_Type__c) && pr.Type__c == 'Non Scheme' && pr.Active__c){
                    pr.addError('Only one Non-Scheme can be Active at a time.');
                }
            }
        }
    }
    public static void onBeforeUpdate(List<Pricing__c> priceList, map<id,Pricing__c> oldPricingMap) { 
        Set<Id> setPropertyType = new Set<Id>();
        Set<Id> setPType = new Set<Id>();
        for(Pricing__c pr : priceList){
            if(pr.Type__c == 'Non Scheme' 
                && pr.Active__c && oldPricingMap.get(pr.Id).Active__c != pr.Active__c){
                setPropertyType.add(pr.Property_Type__c);
            }
        }
        if(setPropertyType != null && setPropertyType.size()> 0){
            for(Pricing__c pr : [select id,Type__c,Property_Type__c from Pricing__c where Active__c = true and Property_Type__c IN: setPropertyType]){
                if(pr.Type__c == 'Non Scheme'){
                    setPType.add(pr.Property_Type__c);
                }
            }
        }
        if(setPType != null && setPType.size()> 0){
            for(Pricing__c pr : priceList){
                if(setPType.contains(pr.Property_Type__c) && pr.Type__c == 'Non Scheme' && pr.Active__c){
                    pr.addError('Only one Non-Scheme can be Active at a time.');
                }
            }
        }
    }
    public static void onAfterUpdate(List<Pricing__c> priceList, map<id,Pricing__c> oldPricingMap) {
        Id schemeBPlanRTId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan').getRecordTypeId();  
        Id customiseRTId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        Id nonSchemeRTId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        Set<Id> stPrice = new Set<Id>();
        List<Payment_Plan__c> lstPaymentPlan = new List<Payment_Plan__c>();
        for(Pricing__c pr : priceList){
            if((pr.Base_Cost__c != null && pr.Base_Cost__c != oldPricingMap.get(pr.Id).Base_Cost__c) ||
            (pr.Floor_Rise_Cost__c != null && pr.Floor_Rise_Cost__c != oldPricingMap.get(pr.Id).Floor_Rise_Cost__c) ||
            (pr.PLC_Cost__c != null && pr.PLC_Cost__c != oldPricingMap.get(pr.Id).PLC_Cost__c) ||
            (pr.ITC_Basic_Cost__c != null && pr.ITC_Basic_Cost__c != oldPricingMap.get(pr.Id).ITC_Basic_Cost__c) ||
            (pr.ITC_Floor_Rise_Cost__c != null && pr.ITC_Floor_Rise_Cost__c != oldPricingMap.get(pr.Id).ITC_Floor_Rise_Cost__c) ||
            (pr.ITC_PLC_Cost__c != null && pr.ITC_PLC_Cost__c != oldPricingMap.get(pr.Id).ITC_PLC_Cost__c)){
                stPrice.add(pr.Id);
            }
        }
        for(Payment_Plan__c pp : [select id, Property__r.Booking__c, Active__c, RecordTypeId, Status__c from Payment_Plan__c where Pricing_Ref__c IN : stPrice]){
            if((pp.RecordTypeId == schemeBPlanRTId || pp.RecordTypeId == nonSchemeRTId || pp.RecordTypeId == customiseRTId)
            && String.isBlank(pp.Property__r.Booking__c)){
            pp.Active__c = false;
            pp.Status__c = 'Rejected';
            lstPaymentPlan.add(pp);}
        }
        if(!lstPaymentPlan.isEmpty()){
            update lstPaymentPlan;
        }
    }
}
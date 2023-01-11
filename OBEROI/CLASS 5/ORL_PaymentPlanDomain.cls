/*
*Author: Vivek S
*Date: 22/02/2019
*Description: Domain Layer methods for SOQL/DML operations
*/ 
//TODO: add method headers
public virtual class ORL_PaymentPlanDomain{

public static final string PAYPLAN = 'Payment_Plan__c';
public static final string PAYPLANLINEITEM = 'Payment_Plan_Line_Item__c';

public list<Payment_Plan__c> payLst = new list<Payment_Plan__c>();
public list<Payment_Plan_Line_Item__c> payLineLst = new list<Payment_Plan_Line_Item__c>();
public map<string,Payment_Plan__c> payMap = new map<string,Payment_Plan__c>();
public map<id,list<Payment_Plan_Line_Item__c>> payPlan_ItemsMap = new map<id,list<Payment_Plan_Line_Item__c>>();
public map<string,map<string,Payment_Plan_Line_Item__c>> lineItemsMap = new map<string,map<string,Payment_Plan_Line_Item__c>>();

//SOQL to retrieve Payment Plan Records
public virtual map<string,Payment_Plan__c> retrievePaymentPlanBySAPNumber(List<string> idSet){

    try{
       String qry = ORL_Util.buildQuery(PAYPLAN)+' Where Payment_Plan_Number__c IN: idSet'; 
       Logger.logDebug(qry);
       payLst = Database.Query(qry);
       Logger.logDebug(string.valueOf(payLst));
       
       if(payLst != NULL){
         for(Payment_Plan__c pObj: payLst){
           payMap.put(pObj.Payment_Plan_Number__c, pObj);
         }
       }
       
    }catch(Exception ex){
       Logger.logDebug('ORL_PaymentPlanDomain:'+ex.getMessage());
    }   
    Logger.logDebug('Returning Payment Plan Map from Domain:'+string.valueOf(payMap));
    return payMap;

}//retrievePaymentPlanBySAPNumber

//SOQL to retrieve Payment Plan lineitems Records
public virtual map<string,map<string,Payment_Plan_Line_Item__c>> retrievePaymentPlanItemsBySAPNumber(List<string> BPINumLst, list<string> BPNumLst){

    try{
       String qry = ORL_Util.buildQuery(PAYPLANLINEITEM)+' Where Payment_Plan_Number__c IN: BPNumLst AND Item_of_Payment_Plan__c IN: BPINumLst'; 
       Logger.logDebug(qry);
       payLineLst = Database.Query(qry);
       Logger.logDebug(string.valueOf(payLineLst));
       
       if(payLineLst != NULL){
         for(Payment_Plan_Line_Item__c pObj: payLineLst){
           if(!lineItemsMap.containsKey(pObj.Payment_Plan_Number__c)){
              lineItemsMap.put(pObj.Payment_Plan_Number__c,new map<string,Payment_Plan_Line_Item__c>());
           }
           lineItemsMap.get(pObj.Payment_Plan_Number__c).put(pObj.Item_of_Payment_Plan__c, pObj);
         }
       }
       
    }catch(Exception ex){
       Logger.logDebug('ORL_PaymentPlanDomain:'+ex.getMessage());
    }   
    
    Logger.logDebug('Returning Payment Plan Line items Map from Domain:'+string.valueOf(lineItemsMap));
    
    return lineItemsMap;

}//retrievePaymentPlanItemsBySAPNumber

///*************************************************Start: DML Operations*************************************//
//insert Payment Plan Records
public virtual void insertPaymentPlan(list<Payment_Plan__c> payLst){
    try{
        Database.insert(payLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_PaymentPlanDomain:'+ex.getMessage());
    }   
}

//insert Payment_Plan_Line_Item__c Records
public virtual void insertPaymentPlanItems(list<Payment_Plan_Line_Item__c> propLst){
    try{
        Database.insert(propLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_PaymentPlanDomain:'+ex.getMessage());
       throw ex;
    }   
}

//insert Payment Plan Records
public virtual void amendPaymentPlan(list<Payment_Plan__c> payLst){
    try{
       Database.update(payLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_PaymentPlanDomain:'+ex.getMessage());
    }   
}

//insert Payment_Plan_Line_Item__c Records
public virtual void amendPaymentPlanItems(list<Payment_Plan_Line_Item__c> propLst){
    try{
        Database.update(propLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_PaymentPlanDomain:'+ex.getMessage());
       throw ex;
    }   
}

//insert Payment_Plan_Line_Item__c Records
public virtual void deletePaymentPlanItems(list<Payment_Plan_Line_Item__c> propLst){
    try{
        Database.delete(propLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_PaymentPlanDomain:'+ex.getMessage());
       throw ex;
    }   
}

///*************************************************End: DML Operations*************************************//



}
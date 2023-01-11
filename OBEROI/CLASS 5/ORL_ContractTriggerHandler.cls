/*
*  Author: Vivek S
*  Description: Controller Class for the Contract Trigger
*  Change Log: Created-26.02.2019
*/
public class ORL_ContractTriggerHandler {

public static void onBeforeInsert(List<Contract> bookList) {    
   //Logic on Before Insert
}

public static void onBeforeUpdate(List<Contract> bookList, map<id,Contract> oldBookMap) {    
   
   Contract bookRec = bookList.get(0);
   
   if(bookRec.Move_to_SAP__c && !oldBookMap.get(bookRec.Id).Move_to_SAP__c 
      && String.isBlank(oldBookMap.get(bookRec.Id).ContractNumber__c)){
      logger.logDebug('ORL_ContractTriggerHandler, onBeforeUpdate: calling Customer create service');
       //ORL_SAP_IntegrationHelper.createLeasingCustomerInSAPFuture(bookRec.Id);
       bookRec.Move_to_SAP__c = false;
      logger.logDebug('ORL_ContractTriggerHandler, onBeforeUpdate: Trigger completed');
   }else if(bookRec.Move_to_SAP__c && !oldBookMap.get(bookRec.Id).Move_to_SAP__c){
      logger.logDebug('ORL_ContractTriggerHandler, onBeforeUpdate: calling Customer update service');
       //ORL_SAP_IntegrationHelper.updateLeasingCustomerInSAPFuture(bookRec.Id);
       bookRec.Move_to_SAP__c = false;
       logger.logDebug('ORL_ContractTriggerHandler, onBeforeUpdate: Trigger completed');
   }
   
}

public static void onAfterInsert(List<Contract> propList) {    
  //Logic on after insert
}

public static void onAfterUpdate(List<Contract> propList, map<id,Contract> oldBookMap) {    
   //Logic on after Update
}

}
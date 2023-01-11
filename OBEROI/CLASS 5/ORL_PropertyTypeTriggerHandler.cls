/*
*  Author: Vivek S
*  Description: Controller Class for the Property Type Trigger
*  Change Log: Created-15022019
*/
public class ORL_PropertyTypeTriggerHandler {

public static void onBeforeInsert(List<Property_Type__c> propTypeList) {    
   //Logic on Before Insert
}

public static void onBeforeUpdate(List<Property_Type__c> propTypeList, map<id,Property_Type__c> oldPropTypeMap) {    
   //Call methods from integration layer to push records to SAP
   list<string> invIds = new list<string>();
   for(Property_Type__c pObj: propTypeList){
     if(pObj.Move_to_SAP__c && !oldPropTypeMap.get(pObj.Id).Move_to_SAP__c){
       invIds.add(pObj.Id);
       pObj.Move_to_SAP__c = false;
     }
   }
   
   Logger.logDebug('Before calling Push request for update:'+invIds);
   if(!invIds.isEmpty()){
     ORL_SAP_IntegrationHelper.updateInventoryInSAPFuture(invIds);
   }
}

public static void onAfterInsert(List<Property_Type__c> propTypeList) {    
   //Call methods from integration layer to push records to SAP
   list<string> invIds = new list<string>();
   for(Property_Type__c pObj: propTypeList){
     if(pObj.Move_to_SAP__c){
       invIds.add(pObj.Id);
     }
   }
   Logger.logDebug('Before calling Push request for insert:'+invIds);
   if(!invIds.isEmpty()){
     ORL_SAP_IntegrationHelper.createInventoryInSAPFuture(invIds);
   }
   
}

public static void onAfterUpdate(List<Property_Type__c> propTypeList, map<id,Property_Type__c> oldPropTypeMap) {    
   //Logic on after Update
}

}
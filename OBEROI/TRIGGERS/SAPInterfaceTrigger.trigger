/*
*  Author: Nistha Anand
*  Description: Apex Trigger to invoke SalesOrder Integration service.
*  Created: 30/03/2019
*/

trigger SAPInterfaceTrigger on SAP_Interface_Log__c (after insert) {

    if(trigger.isAfter && Trigger.isInsert){
        List<SAP_Interface_Log__c> listObj = trigger.new;
        system.debug('List of interface obj'+listObj);

        system.debug('Inside After Insert Trigger');
        system.debug('CUSTOMER CREATE');
        ORL_SAPInterfaceTriggerHandler.createSalesOrder(trigger.new);
        
        //not required as it is part of Phase 2
        /*else if(listObj.get(0).Type__c == system.label.ORL_SAP_CustomerUpdate){
        system.debug('CUSTOMER UPDATE');
        ORL_SAPInterfaceTriggerHandler.updateSalesOrder(Trigger.new);
        }*/
        //System.enqueueJob( new AsyncBillingPlanGrouping(trigger.new)); 
        ORL_SAPInterfaceTriggerHandler.createBillingLineItems(trigger.new);
    }


}
/*
*  Author: Vivek S
*  Description: Schedular class for Inventory Pull Request
*  Change Log: Created: 15/02/2019
*/

global class ORL_SAP_ScheduledInventoryPull implements Schedulable {
   global void execute(SchedulableContext SC) {
     ORL_SAP_IntegrationHelper.getInventoryFromSAPFuture();
   }
}
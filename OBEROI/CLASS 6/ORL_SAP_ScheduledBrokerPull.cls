/*
*  Author: Aditya Bhasin
*  Description: Schedular class for Broker Pull Request
*  Change Log: Created: 04/04/2019
*/

global class ORL_SAP_ScheduledBrokerPull implements Schedulable {
   global void execute(SchedulableContext SC) {
     ORL_SAP_IntegrationHelper.getBrokerFromSAPFuture();
   }
}
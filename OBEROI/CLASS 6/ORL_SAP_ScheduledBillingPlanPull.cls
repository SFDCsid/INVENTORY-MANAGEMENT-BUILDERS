/*
*  Author: Vivek S
*  Description: Schedular class for BillingPlan Pull Request
*  Change Log: Created: 25/02/2019
*/

global class ORL_SAP_ScheduledBillingPlanPull implements Schedulable {
   global void execute(SchedulableContext SC) {
     ORL_SAP_IntegrationHelper.getBillingPlanFromSAPFuture();
   }
}
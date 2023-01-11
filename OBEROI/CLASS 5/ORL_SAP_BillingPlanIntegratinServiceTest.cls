/**
*  Author: IBM  
*  Description: Test Class for Integration service class for Billing Plan Service.
*  Date : 27/03/2019
*/
@IsTest
Public with sharing class ORL_SAP_BillingPlanIntegratinServiceTest{
    
    public static void createData()
    {
        Account accountRecord = new Account();
        accountRecord.Name = 'PYN estate';
        accountRecord.AccountNumber = '01235';
        insert accountRecord;
    }
    
    @IsTest    
    public static void testpullBrokerFromSAP(){
        createData();
        test.startTest();
        ORL_SAP_BillingPlanIntegrationService obj = new ORL_SAP_BillingPlanIntegrationService();
        Test.setMock(WebServiceMock.class, new CreateMockResponseClass());
        // Call the method that invokes a callout
        obj.pullBillingPlanFromSAP();
        test.stopTest();
    }
    
}
/*
static testMethod void billingPlanTestPullCall(){
ORL_SAP_BaseIntegrationService classRestExtend= new ORL_SAP_BaseIntegrationService ();
ORL_SAP_Interface_Parameters__mdt  serviceSettings = classRestExtend.retrieveServiceSettings(system.label.ORL_SAP_BillingPlanPullCall);
Logger.logDebug('serviceSettings'+serviceSettings);
ORL_SAP_BillingPlanPullInterface.zbilling_plan pullRequest = new ORL_SAP_BillingPlanPullInterface.zbilling_plan();

pullRequest.inputHttpHeaders_x = new Map<String,String>();
pullRequest.inputHttpHeaders_x.put('Authorization', classRestExtend.getAuthCode());
pullRequest.endpoint_x  = serviceSettings.EndPointURL__c;
Logger.logDebug('inputHttpHeaders_x'+pullRequest.inputHttpHeaders_x);
Logger.logDebug('endpoint_x'+pullRequest.endpoint_x);

ORL_SAP_BillingPlanPullInterface.ZSD_FM_BILLING_PLANResponse_element responseObj = new ORL_SAP_BillingPlanPullInterface.ZSD_FM_BILLING_PLANResponse_element();

ORL_SAP_BillingPlanPullInterface.TABLE_OF_ZSDST_BILLING_PLAN EX_BILLING_PLAN = new ORL_SAP_BillingPlanPullInterface.TABLE_OF_ZSDST_BILLING_PLAN();

ORL_SAP_BillingPlanPullInterface.TABLE_OF_BAPIRET2 RETURN_x = new ORL_SAP_BillingPlanPullInterface.TABLE_OF_BAPIRET2();

ORL_SAP_BillingPlanPullInterface.ZSD_LEASE_INPUT dtParams = new ORL_SAP_BillingPlanPullInterface.ZSD_LEASE_INPUT();
dtParams.FROM_DATE = '21.02.2019';
dtParams.FROM_TIME = '00:00:00';
dtParams.TO_DATE = '21.02.2019';
dtParams.TO_TIME = '23:00:00';


logger.logDebug('responseObj:'+responseObj);
logger.logDebug('dtParams:'+dtParams);

responseObj = pullRequest.ZSD_FM_BILLING_PLAN(EX_BILLING_PLAN,dtParams,RETURN_x);
logger.logDebug('responseObj after:'+responseObj.EX_BILLING_PLAN.item);
logger.logDebug('responseObj after:'+responseObj.RETURN_x.item);
}*/
/****************************************************************************************************
Class covered :
1. ORL_SAP_BaseIntegrationService - 7/6/2019 - 77%

****************************************************************************************************/

/******************************************************************************************************************
Version v1.1 - AKohakade - 10-5-2019 - Commenting setDateParams method call as getting error while deployment set "0Af0k00000U61sf" in UAT
******************************************************************************************************************/

@isTest(seeAlldata=false)
private class ORL_SAP_BaseIntegrationServiceTest {
    @isTest  
    static void ORL_SAP_BaseIntegrationServiceTestMethod_Success() {
        
        ORL_SAP_Interface_Parameters__mdt sapInterfaceParams = [SELECT DeveloperName,MasterLabel,EndPointURL__c,Active__c,Logging_Enabled__c,
                                                                Password__c,Username__c FROM ORL_SAP_Interface_Parameters__mdt
                                                                WHERE MasterLabel='BillingPlanPullCall'];
        
        
        ORL_SAP_BaseIntegrationService interfaceMtdClass = new ORL_SAP_BaseIntegrationService();
        interfaceMtdClass.serviceSettings = sapInterfaceParams;
        interfaceMtdClass.retrieveServiceSettings('BillingPlanPullCall');
        interfaceMtdClass.getAuthCode();
        interfaceMtdClass.isServiceActive();
        interfaceMtdClass.createInterfaceLogs();
        Id billingPlanObjectId = '01Ip0000000CJW7';
        interfaceMtdClass.gtObjectName(billingPlanObjectId);
        interfaceMtdClass.initiateParentLog('Payment_Plan__c');
        interfaceMtdClass.setDateParams('Account');
        ORL_SAP_BaseIntegrationService.LastSuccessPullDates lastSu = new ORL_SAP_BaseIntegrationService.LastSuccessPullDates();
        lastSu.setLastSuccessPullDates('frmDt','frmTime');
    }
    
    @isTest  
    static void ORL_SAP_BaseIntegrationServiceTestMethod_Failure() {
        ORL_SAP_BaseIntegrationService interfaceMtdClass = new ORL_SAP_BaseIntegrationService();
        interfaceMtdClass.retrieveServiceSettings('Test');
        interfaceMtdClass.getAuthCode();
        //interfaceMtdClass.setDateParams();v1.1
        
        
    }
}
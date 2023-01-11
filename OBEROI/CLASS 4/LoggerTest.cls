@isTest
private class LoggerTest {
    
    @testSetup static void setup() {
        List <ORL_ProcessSwitchSettings__c> logSettingsList = new List <ORL_ProcessSwitchSettings__c>();
        ORL_ProcessSwitchSettings__c logDebug = new ORL_ProcessSwitchSettings__c(DebugLogEnabled__c =true);
        logSettingsList.add(logDebug);
        insert logSettingsList;
    }
    
    @isTest
    static void logDebug() {
        List <ORL_ProcessSwitchSettings__c> logSettingsList = [SELECT DebugLogEnabled__c FROM ORL_ProcessSwitchSettings__c];
        string log = ' Dependent class is invalid and needs recompilationClass ORL_ContractTriggerHandler : Method does not exist or incorrect signature void createLeasingCustomerInSAPFuture(Id) from the type ORL_SAP_IntegrationHelper';
		Logger.logDebug(log); 
    }
    @isTest
    static void logException() {
        List <ORL_ProcessSwitchSettings__c> logSettingsList = [SELECT DebugLogEnabled__c FROM ORL_ProcessSwitchSettings__c];
        string log = ' Dependent class is invalid and needs recompilationClass ORL_ContractTriggerHandler : Method does not exist or incorrect signature void createLeasingCustomerInSAPFuture(Id) from the type ORL_SAP_IntegrationHelper';
		Logger.logException(log);
    }
}
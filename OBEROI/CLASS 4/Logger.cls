/*
*Author: Vivek S
*Date: 15/01/2019
*Description: Add logger methods here
*/

public class Logger{
    
    public static void logDebug(string log){
        
        ORL_ProcessSwitchSettings__c custSettings = ORL_ProcessSwitchSettings__c.getInstance();
        if(custSettings.DebugLogEnabled__c){
            system.debug('*********'+log);
        }
        
    }
    
    public static void logException(string log){
        
        ORL_ProcessSwitchSettings__c custSettings = ORL_ProcessSwitchSettings__c.getInstance();
        if(custSettings.DebugLogEnabled__c){
            system.debug('*********Exception :'+log);
        }
        
    }
    
}
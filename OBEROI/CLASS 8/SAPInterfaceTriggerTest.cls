@isTest
public class SAPInterfaceTriggerTest {
    
    @isTest
    public static void unitTets(){
        List<SAP_Interface_Log__c> listObj=new List<SAP_Interface_Log__c>();
        SAP_Interface_Log__c data =new SAP_Interface_Log__c(Status__c='normal');
        listObj.add(data);
        insert listObj;
    }
    
}
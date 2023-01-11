@isTest(SeeAllData=true)
public class ORL_ContractTriggerTest {
    static List<Contract> newcontractList;
    static List<Contract> contractList;
    
    
    @isTest
    public static void unitTest(){
        ORL_ProcessSwitchSettings__c setting = new ORL_ProcessSwitchSettings__c(SetupOwnerId=Userinfo.getUserId());
        setting.ContractTriggerSwitch__c=true;
        setting.Name = 'Demo Setting';
        insert setting;
        
        contractList = new List<Contract>();
        Contract contract = new Contract();
        contract.Move_to_SAP__c = true;
        contract.ContractNumber__c = '';
        contract.AccountId ='001p000000kv25CAAQ';
        contractList.add(contract);
        insert contractList[0];
        contractList[0].Move_to_SAP__c=false;
        update contractList[0];
        system.debug('contact list ---'+contractList[0]);
        
        newcontractList = new List<Contract>();
        Contract contract1 = new Contract();
        contract1.Move_to_SAP__c = true;
        contract1.ContractNumber__c = '' ;
        contract1.AccountId ='001p000000kv25CAAQ';
        newcontractList.add(contract1);
        insert newcontractList[0];
        newcontractList[0].Move_to_SAP__c = false;
        update newcontractList[0];
        
    }
    
}
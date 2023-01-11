@isTest
public class ORL_ContractTriggerHandlerTest {
    static List<Contract> newcontractList;
     static List<Contract> contractList;
   // static Map<Id, Contract> oldBookMap;
    static Map<Id, Contract> oldBookMap1;
    
    @TestSetup
    private static void createTestData(){
        contractList = new List<Contract>();
        Contract contract = new Contract();
        contract.Move_to_SAP__c = true;
        contract.ContractNumber__c = '';
        contract.AccountId ='001p000000kv25CAAQ';
        contractList.add(contract);
        insert contractList[0];
        system.debug('contact list ---'+contractList[0]);
        
        newcontractList = new List<Contract>();
        Contract contract1 = new Contract();
        contract1.Move_to_SAP__c = true;
        contract1.ContractNumber__c = '' ;
        contract1.AccountId ='001p000000kv25CAAQ';
        newcontractList.add(contract1);
        insert newcontractList[0];
        system.debug('oldBookMap123---'+newcontractList[0]);
        
        
        
       // Contract contract1 = [Select id, Move_to_SAP__c, ContractNumber__c, AccountId from Contract Limit 1];
        //system.debug('contract1---'+contract1);
       // oldBookMap = new Map<Id,Contract>();
        oldBookMap1 = new Map<Id,Contract>();
       
        oldBookMap1.put(contractList[0].Id,contractList[0]);
        
       //system.debug('check value'+ String.isBlank(newcontractList[0].).ContractNumber__c);
      //  system.debug('oldBookMap---'+oldBookMap.values());
      //  system.debug('oldBookMap---'+oldBookMap1.values());
       // contractList[0].Move_to_SAP__c = TRUE;https://oberoirealty--oberoidev.my.salesforce.com/s.gif
        
       // conList2.add(contractList[0]);
       // update conList2;
    }
        
    @isTest static void testContract() {
        createTestData();
        System.debug('MoveTo--'+contractList[0].Move_to_SAP__c);
        System.debug('OldMap--'+oldBookMap1.get(contractList[0].Id).Move_to_SAP__c);
        System.debug('ContractNumber__c--'+oldBookMap1.get(contractList[0].Id).ContractNumber__c);
        ORL_ContractTriggerHandler.onBeforeInsert(contractList);
        ORL_ContractTriggerHandler.onBeforeUpdate(contractList,oldBookMap1);
        ORL_ContractTriggerHandler.onAfterInsert(contractList);
        ORL_ContractTriggerHandler.onAfterUpdate(contractList, oldBookMap1);
    }    
}
@isTest
public class ORL_PropertyTypeTriggerHandlerTest {
    
    static List<Property_Type__c> propTypeList ;
    static Map<id, Property_Type__c> propMap;
    
    static testMethod void createTestData(){
        propTypeList =  TestDataFactory.createProjectType(1); 
        propMap = new Map<id, Property_Type__c>();
        insert propTypeList;
        propMap.put(propTypeList[0].id, propTypeList[0]);
        
        propTypeList[0].Move_to_SAP__c = true;
        update propTypeList[0];
 		test.startTest();
        ORL_PropertyTypeTriggerHandler.onBeforeInsert(propTypeList);
        ORL_PropertyTypeTriggerHandler.onAfterInsert(propTypeList);
        ORL_PropertyTypeTriggerHandler.onBeforeUpdate(propTypeList, propMap);
        ORL_PropertyTypeTriggerHandler.onAfterUpdate(propTypeList, propMap);
        test.stopTest();
    }
}
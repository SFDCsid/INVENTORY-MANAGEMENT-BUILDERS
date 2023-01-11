@isTest
public class ORL_PropertyTriggerTest {
    static list<Property_Type__c>  pTypeList;
    static testMethod void createTestData(){
        ORL_ProcessSwitchSettings__c swSetting = new ORL_ProcessSwitchSettings__c();      
        swSetting.PropertyTypeTriggerSwitch__c = true;
        test.startTest();
        insert swSetting;
        pTypeList = TestDataFactory.createProjectType(1);
        insert pTypeList;
        update pTypeList;
        test.stopTest();
    }
}
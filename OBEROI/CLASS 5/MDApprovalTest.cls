@isTest
public class MDApprovalTest {
    
    static List<MD_Approval__c> MDList;
    static List<Project__c> projList;
    static List<Property__c> propList;
    static List<Property_Type__c> propTypeList;     
    static testMethod void createTestData(){
        Integer saleableArea = 1600;
        Integer carpetArea = 1050;
        Integer balconyArea = 600;
        projList = TestDataFactory.createResProject(1);
        propTypeList =TestDataFactory.createProjectType(1);
        test.startTest();
        insert propTypeList;
        insert projList;
        Property__c sinlgeproperty = new Property__c(Property_Type__c=propTypeList[0].id,Material_No__c = '123456'+string.valueOf('1'),
                                                     Description__c='TestPropertyType',Control_Code__c='Test',Saleable_Area__c=saleableArea,
                                                     Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea);
        insert sinlgeproperty;
        MDList = TestDataFactory.createMDApproval(1);
        MDList[0].Property__c = sinlgeproperty.id;
        MDList[0].Project__c = projList[0].id;
        insert MDList; 
        test.stopTest();
    }
    
}
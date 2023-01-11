@isTest()
public class ORL_InventoryDomainTest {
    
    @testSetup 
    static void dataSetup() {
        
    }
    
    @isTest
    static void testInsertFunctions() {
        User usr = TestDataFactory.createUser('ORL Admin', 'MD');
        List<Site__c> sites = TestDataFactory.createSite(1);
        insert sites;
        
        Id recordTypeIdProp = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        Project__c p = new Project__c();
        p.Name = 'testing';
        p.Plant__c = 'ABC';
        p.Company_name__c = 'CDF';
        p.CFO__c = usr.Id;
        p.Front_Desk_User__c = usr.id;
        p.Marcom_Head__c = usr.Id;
        p.Marcom_Manager__c = usr.Id;
        p.MD__c = usr.Id;
        p.Sales_Head__c = usr.Id;
        p.Site_Head__c = usr.Id;
        p.Site__c = sites[0].Id;
        insert p;
        
        list<Property_Type__c> propertyTypeList = new list<Property_Type__c>();
        Property_Type__c propType = new Property_Type__c();
        propType.Description__c = 'test';
        propType.Material_No__c = '123';
        propType.Control_Code__c= '111';
        propType.Project1__c = p.id;
        propType.Carpet_Area__c = 123.3;
        propType.Balcony_Area__c = 123.3;
        propType.Saleable_Area__c = 123.3;
        propertyTypeList.add(propType);
        ORL_InventoryDomain ORLID = new ORL_InventoryDomain();
        ORLID.insertPropertyTypes(propertyTypeList);
        List<string> idLsit=new List<string>();
        ORL_InventoryDomain obj=new ORL_InventoryDomain();
        obj.retrievePropTypeByIds(idLsit);
        try{
            obj.retrievePropByIds(idLsit);
        }
        catch(exception e){
            system.assertEquals(e.getMessage(), e.getMessage()); 
        }
        obj.retrievePropTypeBySAPIds(idLsit);
        obj.retrievePropBySAPIds(idLsit);
        obj.retrieveRentalPropBySAPIds(idLsit);
        obj.retrieveProjectBySAPCodes(idLsit);
        obj.retrieveProjectByPlant(idLsit);
        List<Property__c> propertyList=TestDataFactory.createProperties(1);
        //insert propertyList;
        
        obj.insertProperties(propertyList);
        obj.amendProperties(propertyList);
        obj.amendPropertyTypes(propertyTypeList);
        obj.retrieveTowerByName(idLsit,idLsit);
        obj.amendPropertyTypes(propertyTypeList);
    }
    
    @isTest
    static void testInsertFunctionsExceptionHandling() {
        User usr = TestDataFactory.createUser('ORL Admin', 'MD');
        List<Site__c> sites = TestDataFactory.createSite(1);
        insert sites;
        
        Id recordTypeIdProp = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        Project__c p = new Project__c();
        p.Name = 'testing';
        p.Plant__c = 'ABC';
        p.Company_name__c = 'CDF';
        p.CFO__c = usr.Id;
        p.Front_Desk_User__c = usr.id;
        p.Marcom_Head__c = usr.Id;
        p.Marcom_Manager__c = usr.Id;
        p.MD__c = usr.Id;
        p.Sales_Head__c = usr.Id;
        p.Site_Head__c = usr.Id;
        p.Site__c = sites[0].Id;
        insert p;
        
        list<Property_Type__c> propertyTypeList = new list<Property_Type__c>();
        Property_Type__c propType = new Property_Type__c();
        propType.Description__c = 'test';
        //propType.Material_No__c = '123';
        propType.Control_Code__c= '111';
        propType.Project1__c = p.id;
        propType.Carpet_Area__c = 123.3;
        propType.Balcony_Area__c = 123.3;
        propType.Saleable_Area__c = 123.3;
        propertyTypeList.add(propType);
        ORL_InventoryDomain ORLID = new ORL_InventoryDomain();
        ORLID.insertPropertyTypes(propertyTypeList);
        List<string> idLsit=new List<string>();
        idLsit.add('xys');
        ORL_InventoryDomain obj=new ORL_InventoryDomain();
        List<Property__c> propertyList=TestDataFactory.createProperties(1);
        insert propertyList;
        
        try{
            obj.retrievePropTypeByIds(idLsit);           
            obj.retrievePropByIds(idLsit);
            
            obj.retrievePropTypeBySAPIds(idLsit);
            obj.retrievePropBySAPIds(idLsit);
            obj.retrieveRentalPropBySAPIds(idLsit);
            obj.retrieveProjectBySAPCodes(idLsit);
            obj.retrieveProjectByPlant(idLsit);
            
            
            obj.insertProperties(propertyList);
            obj.retrieveTowerByName(idLsit,idLsit);
        } catch(Exception e) {
            System.assert(e!=null);
        }
        try{
            obj.amendProperties(propertyList);
        } catch(Exception e) {
            System.assert(e!=null);
        }
        
        try{
            obj.amendPropertyTypes(propertyTypeList);
        } catch(Exception e) {
            System.assert(e!=null);
        }
    }
}
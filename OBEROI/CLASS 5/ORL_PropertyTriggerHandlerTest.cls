@isTest
public class ORL_PropertyTriggerHandlerTest {
    @isTest
    static void testPropertyCheck(){
        User usr = TestDataFactory.createUser('ORL Admin', 'MD');
        
        List<Site__c> sList = TestDataFactory.createSite(4);
        insert sList;
        
        List<Opportunity> oppList=TestDataFactory.createOpportunity(4);
        oppList[0].Name = 'Test Opp' + Math.random();
        oppList[0].closeDate = system.Today(); 
        oppList[0].StageName= 'New';
        oppList[0].Site__c =sList[0].id;
        
        oppList[1].Name = 'Test Opp' + Math.random();
        oppList[1].closeDate = system.Today(); 
        oppList[1].StageName= 'New';
        oppList[1].Site__c =sList[1].id;
        
        oppList[2].Name = 'Test Opp' + Math.random();
        oppList[2].closeDate = system.Today(); 
        oppList[2].StageName= 'New';
        oppList[2].Site__c =sList[2].id;
        
        oppList[3].Name = 'Test Opp' + Math.random();
        oppList[3].closeDate = system.Today(); 
        oppList[3].StageName= 'New';
        oppList[3].Site__c =sList[3].id;
        
        insert oppList;
        
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        
        List<Project__c> pList = TestDataFactory.createResProject(4);
        
        pList[0].Name = 'Enigma';
        pList[0].Plant__c ='767c';
        pList[0].site__c =sList[0].id;
        pList[0].Active__c=true;
        pList[0].Company_name__c='test'; 
        pList[0].recordtypeId= PrRecordTypeId;
        pList[0].Front_Desk_User__c = usr.id;
        pList[0].Marcom_Head__c =usr.Id; 
        pList[0].Sales_Head__c =usr.Id;
        pList[0].Site_Head__c=usr.Id; 
        pList[0].MD__c =usr.Id; 
        pList[0].Marcom_Manager__c = usr.Id; 
        /*v1.1 Start*/
        pList[0].CFO__c =usr.Id/*v1.1 Ends*/;
        
        
        pList[1].Name = 'Sky City';
        pList[1].Plant__c ='767c';
        pList[1].site__c =sList[1].id;
        pList[1].Active__c=true;
        pList[1].Company_name__c='test'; 
        pList[1].recordtypeId= PrRecordTypeId;
        pList[1].Front_Desk_User__c = usr.id;
        pList[1].Marcom_Head__c =usr.Id; 
        pList[1].Sales_Head__c =usr.Id;
        pList[1].Site_Head__c=usr.Id; 
        pList[1].MD__c =usr.Id; 
        pList[1].Marcom_Manager__c = usr.Id; 
        /*v1.1 Start*/
        pList[1].CFO__c =usr.Id/*v1.1 Ends*/;
        
        
        pList[2].Name = 'Prisma';
        pList[2].Plant__c ='767c';
        pList[2].site__c =sList[2].id;
        pList[2].Active__c=true;
        pList[2].Company_name__c='test'; 
        pList[2].recordtypeId= PrRecordTypeId;
        pList[2].Front_Desk_User__c = usr.id;
        pList[2].Marcom_Head__c =usr.Id; 
        pList[2].Sales_Head__c =usr.Id;
        pList[2].Site_Head__c=usr.Id; 
        pList[2].MD__c =usr.Id; 
        pList[2].Marcom_Manager__c = usr.Id; 
        /*v1.1 Start*/
        pList[2].CFO__c =usr.Id/*v1.1 Ends*/;
        
        pList[3].Name = 'Eternia';
        pList[3].Plant__c ='767c';
        pList[3].site__c =sList[3].id;
        pList[3].Active__c=true;
        pList[3].Company_name__c='test'; 
        pList[3].recordtypeId= PrRecordTypeId;
        pList[3].Front_Desk_User__c = usr.id;
        pList[3].Marcom_Head__c =usr.Id; 
        pList[3].Sales_Head__c =usr.Id;
        pList[3].Site_Head__c=usr.Id; 
        pList[3].MD__c =usr.Id; 
        pList[3].Marcom_Manager__c = usr.Id; 
        /*v1.1 Start*/
        pList[3].CFO__c =usr.Id/*v1.1 Ends*/;
        insert pList;
        
        List<Tower__c> towerList = TestDataFactory.createTowers(4);       
        towerList[0].Project_Name__c=pList[0].Id;
        towerList[1].Project_Name__c=pList[1].Id;
        towerList[2].Project_Name__c=pList[2].Id;
        towerList[3].Project_Name__c=pList[3].Id;
        insert towerList;
        
        
        List<Property_Type__c> projectTypeList = TestDataFactory.createProjectType(4);
        projectTypeList[0].Project1__c = pList[0].Id;
        projectTypeList[1].Project1__c = pList[1].Id;
        projectTypeList[2].Project1__c = pList[2].Id;
        projectTypeList[3].Project1__c = pList[3].Id;
        insert projectTypeList;
        
        
        
        
        //List<Property__c> propertyList=TestDataFactory.createProperties(4);
        List<Property__c> propertyList=new list<Property__c>();
        Property__c a = new property__c();
        a.Temporary_Block__c = true;
        a.Active__c = true;
        a.Block_Comments__c = 'Test';
        a.Blocked_By__c = usr.Id;
        a.Tower__c = towerList[0].Id;
        a.Property_Type__c = projectTypeList[0].Id;
        a.Material_No__c = '1234';
        a.Description__c = 'Test';
        a.Control_Code__c = 'Test';
        a.Saleable_Area__c = 1600;
        a.Carpet_Area__c = 1050;        
        a.Balcony_Area__c = 600;
        
        Property__c b = new property__c();
        b.Temporary_Block__c = false;
        b.Active__c = true;
        b.Block_Comments__c = 'Test';
        b.Blocked_By__c = usr.Id;
        b.Tower__c = towerList[0].Id;
        b.Property_Type__c = projectTypeList[0].Id;
        b.Material_No__c = '1234';
        b.Description__c = 'Test';
        b.Control_Code__c = 'Test';
        b.Saleable_Area__c = 1600;
        b.Carpet_Area__c = 1050;        
        b.Balcony_Area__c = 600;
        propertyList.add(a);
        propertyList.add(b);
        /*
        propertyList[1].Temporary_Block__c = true;
        propertyList[1].Active__c = true;
        propertyList[1].Block_Comments__c = 'Test';
        propertyList[1].Blocked_By__c = usr.Id;
        propertyList[1].Tower__c = towerList[1].Id;
        propertyList[1].Property_Type__c = projectTypeList[1].Id;
        
        propertyList[2].Temporary_Block__c = true;
        propertyList[2].Active__c = true;
        propertyList[2].Block_Comments__c = 'Test';
        propertyList[2].Blocked_By__c = usr.Id;
        propertyList[2].Tower__c = towerList[2].Id;
        propertyList[2].Property_Type__c = projectTypeList[2].Id;
        
        propertyList[3].Temporary_Block__c = false;
        propertyList[3].Active__c = true;
        propertyList[3].Block_Comments__c = 'Test';
        propertyList[3].Move_to_SAP__c = false;
        //propertyList[3].Blocked_By__c = usr.Id;
        propertyList[3].Tower__c = towerList[3].Id;
        propertyList[3].Property_Type__c = projectTypeList[3].Id;*/
        insert propertyList;   
        
        List<property__c> properties = [select Id, Temporary_Block__c,Blocked_By__c from property__c];
        Map<Id,Property__c> propertyMap = new Map<Id,property__C>();
        
        for(property__c prop :properties){
            if(prop.Temporary_Block__c){
                prop.Temporary_Block__c = false;
            } else {
                prop.Move_to_SAP__c = true;
                prop.Block_Comments__c = 'tes';
                prop.Temporary_Block__c = true;
            }
            propertyMap.put(prop.Id,prop);
        }
        update propertyMap.values();
        
        ORL_PropertyTriggerHandler.autoBlockGrande(propertyList, propertyMap);
        ORL_PropertyTriggerHandler.propertyCheck(propertyList, propertyMap);
        ORL_PropertyTriggerHandler.onAfterUpdate(propertyList, propertyMap);
    }
}
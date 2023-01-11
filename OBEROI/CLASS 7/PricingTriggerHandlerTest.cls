@isTest
private class PricingTriggerHandlerTest{
    
    static testmethod void onBeforeInsertTest1(){
        
        List<Project__c> projectList;
        List<Property_Type__c> propertyTypeList;           

        projectList = TestDataFactory.createResProject(1);
        insert projectList[0];
        propertyTypeList = TestDataFactory.createProjectType(1);
        insert propertyTypeList[0];
        
        Pricing__c pri = new Pricing__c ();
        pri.Property_Type__c = propertyTypeList[0].id;
        pri.Name = 'Scheme Pricing 1';
        pri.Type__c = 'Non Scheme';
        pri.Active__c = true;
        pri.Base_Cost__c = 20000.00;
        pri.PLC_Cost__c = 0.00;
        pri.Floor_Rise_Cost__c = 10000.00;
        pri.ITC_Basic_Cost__c = 100.00;
        pri.ITC_Floor_Rise_Cost__c = 100.00;
        pri.ITC_PLC_Cost__c = 100.00;
        
        insert pri;
        
        test.startTest();    
        
        pri = new Pricing__c ();
        pri.Property_Type__c = propertyTypeList[0].id;
        pri.Name = 'Scheme Pricing 2';
        pri.Type__c = 'Non Scheme';
        pri.Active__c = true;
        pri.Base_Cost__c = 20000.00;
        pri.PLC_Cost__c = 0.00;
        pri.Floor_Rise_Cost__c = 10000.00;
        pri.ITC_Basic_Cost__c = 100.00;
        pri.ITC_Floor_Rise_Cost__c = 100.00;
        pri.ITC_PLC_Cost__c = 100.00;

        try{
            insert pri;
        } catch (exception  e){
            }
                                      
        test.stopTest();       
    }   
    
    static testmethod void onBeforeInsertTest2(){
        
        List<Project__c> projectList;
        List<Property_Type__c> propertyTypeList;   
        
        test.startTest();
        projectList = TestDataFactory.createResProject(1);
        insert projectList[0];
        propertyTypeList = TestDataFactory.createProjectType(1);
        insert propertyTypeList[0];
        
        Pricing__c pri = new Pricing__c ();
        pri.Property_Type__c = propertyTypeList[0].id;
        pri.Name = 'Scheme Pricing 1';
        pri.Type__c = 'Non Scheme';
        pri.Active__c = false;
        pri.Base_Cost__c = 20000.00;
        pri.PLC_Cost__c = 0.00;
        pri.Floor_Rise_Cost__c = 10000.00;
        pri.ITC_Basic_Cost__c = 100.00;
        pri.ITC_Floor_Rise_Cost__c = 100.00;
        pri.ITC_PLC_Cost__c = 100.00;
            
        insert pri;
        
        pri.Active__c = true;
        update pri;
        
        pri = new Pricing__c ();
        pri.Property_Type__c = propertyTypeList[0].id;
        pri.Name = 'Scheme Pricing 1';
        pri.Type__c = 'Non Scheme';
        pri.Active__c = false;
        pri.Base_Cost__c = 20000.00;
        pri.PLC_Cost__c = 0.00;
        pri.Floor_Rise_Cost__c = 10000.00;
        pri.ITC_Basic_Cost__c = 100.00;
        pri.ITC_Floor_Rise_Cost__c = 100.00;
        pri.ITC_PLC_Cost__c = 100.00;
        
        try{
            insert pri;
        } catch (exception  e){
          }  
    } 
        
        
    }
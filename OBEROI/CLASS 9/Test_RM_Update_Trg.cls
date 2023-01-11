@isTest
Public Class Test_RM_Update_Trg{
    @isTest
    public static void RM_Update(){
    
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Id projectId = dataMap.get('PROJECT');
        Id proprtyId = dataMap.get('PROPERTY_TYPE');
        Id towerId = dataMap.get('TOWER');
        
        SAP_Credentials_Master__c SCM = New SAP_Credentials_Master__c();
        SCM.Name = 'RM Update';
        SCM.URL__c = 'http://110.173.186.22:8003/zsfdcapi/update_rm_details?sap-client=100';
        SCM.User_ID__c = 'Stetig';
        SCM.Password__c = 'Stetig@2022';
        Insert SCM;
        
        /*User u = new User();
        u.FirstName = 'Upendra';
        u.LastName = 'Shukla';
        u.Alias = 'pthak';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LocaleSidKey = 'English (India)';
        u.ProfileId = '00e0o0000029lbL';
        u.LanguageLocaleKey = 'English';
        u.Email = 'upendra.shukla@stetig.in';
        u.MobilePhone = '1234567890';
        insert u;
        
        User u1 = new User();
        u.FirstName = 'priti';
        u.LastName = 'Thakur';
        u.Alias = 'pthak';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LocaleSidKey = 'English (India)';
        u.ProfileId = '00e0o0000029lbL';
        u.LanguageLocaleKey = 'English';
        u.Email = 'priti.thakur@oberoirealty.com.dev';
        u.MobilePhone = '7738140678';
        insert u1;*/
        
        Property__c prop = new Property__c();
        prop.Project_Name__c = projectId;
        prop.Property_Type__c = proprtyId;
        prop.Tower__c = towerId;
        prop.Related_Jodi_Property__c = prop.Id;
        prop.Is_Jodi_Flat__c = false;
        prop.Market_Value__c = 250000;
        prop.Floor_No__c = 6.00;
        prop.Sales_Organization__c = '1131';
        prop.Status__c = 'Availalbe';
        prop.ITC_Benefit_Applicable__c = true;
        //prop.RecordTypeId = 'Residential';
        prop.House_Unit_No__c = '0601';
        prop.Carpet_Area_UOM__c = 'Square Feet (Carpet Area)';
        prop.Property_Name__c = 'PR# 04-2021-0456';
        prop.Saleable_Area__c = 800;
        prop.Material_No__c = 'OEY-A-0601';
        prop.Control_Code__c = 'Controlcode';
        prop.Original_RM_Name__c = Userinfo.getUserId();
        
        insert prop;
        
        Property__c prop1 = new Property__c();
        prop1.Project_Name__c = projectId;
        prop1.Property_Type__c = proprtyId;
        prop1.Tower__c = towerId;
        prop1.Is_Jodi_Flat__c = false;
        prop1.Market_Value__c = 250000;
        prop1.Floor_No__c = 6.00;
        prop1.Sales_Organization__c = '1131';
        prop1.Status__c = 'Availalbe';
        prop1.ITC_Benefit_Applicable__c = true;
        //prop.RecordTypeId = 'Residential';
        prop1.House_Unit_No__c = '0601';
        prop1.Carpet_Area_UOM__c = 'Square Feet (Carpet Area)';
        prop1.Property_Name__c = 'PR# 04-2021-0490';
        prop1.Saleable_Area__c = 800;
        prop1.Material_No__c = 'OEY-A-0601';
        prop1.Control_Code__c = 'Controlcode';
        //prop1.Original_RM_Name__c = UserInfo.getUserId();
        
        insert prop1;
        
       Test.startTest();
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User usr = new User(Alias = 'standts', Email='standardtestsm@testorg.com' ,
                        EmailEncodingKey='UTF-8', LastName='standardtestsm', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='standardtestsm@testorg.com');
            insert usr ;
            checkRecursion.isFirstRun();
            checkRecursion.resetFirstRun();
            checkRecursion.resetFirstRunTask();
            checkRecursion.isFirstRunTask();
            checkRecursion.isFirstRunA();
            checkRecursion.resetFirstRunA();
            System.runAs(usr)
            {
                prop1.Original_RM_Name__c = usr.id;
                update prop1;
            }
        Test.stopTest();  
        
        
 
    }
}
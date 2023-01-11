@isTest
Public Class Test_SAPToSFDC_API{
    Public static User dummyUser =createUser('ORL Admin', 'CFO_Director');
    Public static User FrontDesk =createUser('Front Desk','' );
    public static User createUser(String profileName, String roleName){
        Integer randomNumber = Integer.valueof((Math.random() * 100));
        UserRole role;
        
        if(!String.isBlank(roleName)){
            role = [SELECT Id FROM UserRole WHERE DeveloperName =: roleName LIMIT 1];
            if(role == null){
                role = new UserRole(DeveloperName = roleName, Name = roleName);
                INSERT role;
            }
        }
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name =: profileName].Id,
            LastName = 'last',
            Email = 'Oberoi'+randomNumber+'@test.com',
            Username = 'Oberoi'+randomNumber+'@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        
        if(role != null)
            u.UserRoleId = role.Id;
        
        Profile pro = [SELECT Id FROM Profile WHERE Name=:'System Administrator'];
        User admin = [SELECT id, NAme FROM USer where profileId =: pro.ID AND isActive=: true LIMIT 1];
        system.runAs(admin){
            INSERT u;
            //CFO =createUser('ORL Admin', 'CFO_Director'); 
        }  
        return u;
    }
    
    @isTest
    Public static void REST_CarParksOAuth() {
        list<Project__c> Plist = new List<Project__c>();
        Plist = TestDataFactory.createResProject(1);
        insert Plist;
        REST_CarParksOAuth.CarParks(Null,null,null,0);
        REST_CarParksOAuth.CarParks('OEY-CP-SINGLE','123','ELYSIAN TOWER A CARPARK - TANDEM - 1 NO.',5) ;   
        REST_CarParksOAuth.CarParks('OEY-CP-SINGLE',plist[0].Plant__c,'ELYSIAN TOWER A CARPARK - TANDEM - 1 NO.',5);
        REST_CarParksOAuth.CarParks('OEY-CP-SINGLE',plist[0].Plant__c,'ELYSIAN TOWER A CARPARK - TANDEM - 1 NO.',-5);
    }
    
    @isTest
    Public static void REST_UnitOAuth() {
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        Integer saleableArea = 1600;
        Integer carpetArea = 1050;
        Integer balconyArea = 600;
        
        Site__c st = new Site__c( Name = 'Test site' + Math.random());
        insert st;
        
        Project__c pj = new Project__c( 
        Name = 'Test Proj' + Math.random(), Plant__c ='767c' ,site__c =st.id,
        Active__c=true,Company_name__c='test', recordtypeId= PrRecordTypeId,
        Front_Desk_User__c = FrontDesk.id,Marcom_Head__c =dummyUser.Id, 
        Sales_Head__c =dummyUser.Id,Site_Head__c=dummyUser.Id, MD__c =dummyUser.Id, 
        Marcom_Manager__c = dummyUser.Id,CFO__c =dummyUser.Id);
        insert pj;
        
        Tower__c sinlgeTower = new Tower__c(Project_Name__c=pj.Id,tower_name__c='A');
        insert sinlgeTower;
        
        Property_Type__c PropertyType = new Property_Type__c(
        Material_No__c = '1239996'+string.valueOf(1),Description__c='TestPropertyType',Control_Code__c='Test',
        Saleable_Area__c=saleableArea,Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea,Project1__c= pj.Id);
        Insert PropertyType;
        
        Property__c sinlgeproperty = new Property__c(Property_Type__c=PropertyType.id,Material_No__c = '99999'+string.valueOf(5),
        Description__c='TestPropertyType',Control_Code__c='Test',Saleable_Area__c=saleableArea,
        Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea);
        insert sinlgeproperty;
        
        REST_UnitOAuth.UnitUpdate('',pj.Plant__c,'resc',PropertyType.Material_No__c,'1000','1100',sinlgeTower.tower_name__c,'1967','01 - 19','','','','','','','Available');
        REST_UnitOAuth.UnitUpdate('19982',pj.Plant__c,'resc',PropertyType.Material_No__c,'1000','1100',sinlgeTower.tower_name__c,'1967','OI- 19','','2','3','4','5','6','SOLD');
        REST_UnitOAuth.UnitUpdate(sinlgeproperty.Material_No__c,pj.Plant__c,'resc',PropertyType.Material_No__c,'1000','1100',sinlgeTower.tower_name__c,'1967','OI- 19','','1','2','3','4','5','AVAILABLE');
        REST_UnitOAuth.UnitUpdate('19982',pj.Plant__c,'resc',PropertyType.Material_No__c,'1000','1100',sinlgeTower.tower_name__c,'1967','OI- 19','','2','3','4','5','6','AVAILABLE');
        REST_UnitOAuth.UnitUpdate(sinlgeproperty.Material_No__c,pj.Plant__c,'resc',PropertyType.Material_No__c,'1000','1100',sinlgeTower.tower_name__c,'1967','OI- 19','','1','2','3','4','5','SOLD');
     }
    
    @isTest
    Public static void REST_SapPricing_BulkOAuth(){
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        Integer saleableArea = 1600;
        Integer carpetArea = 1050;
        Integer balconyArea = 600;
        
        Site__c st = new Site__c( Name = 'Test site' + Math.random());
        insert st;
        
        Project__c pj = new Project__c( 
        Name = 'Test Proj' + Math.random(), Plant__c ='767c' ,site__c =st.id,
        Active__c=true,Company_name__c='test', recordtypeId= PrRecordTypeId,
        Front_Desk_User__c = FrontDesk.id,Marcom_Head__c =dummyUser.Id, 
        Sales_Head__c =dummyUser.Id,Site_Head__c=dummyUser.Id, MD__c =dummyUser.Id, 
        Marcom_Manager__c = dummyUser.Id,CFO__c =dummyUser.Id);
        insert pj;
        
        Tower__c sinlgeTower = new Tower__c(Project_Name__c=pj.Id,tower_name__c='A');
        insert sinlgeTower;
        
        Property_Type__c PropertyType = new Property_Type__c(
        Material_No__c = '1239996'+string.valueOf(1),Description__c='TestPropertyType',Control_Code__c='Test',
        Saleable_Area__c=saleableArea,Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea,Project1__c= pj.Id);
        Insert PropertyType;
        
        Property__c sinlgeproperty = new Property__c(Property_Type__c=PropertyType.id,Material_No__c = '99999'+string.valueOf(5),
        Description__c='TestPropertyType',Control_Code__c='Test',Saleable_Area__c=saleableArea,
        Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea);
        insert sinlgeproperty;
        
        SAP_Pricing__c Obj=new SAP_Pricing__c();
        Obj.Property__c = sinlgeproperty.id;
        Obj.Sequence_Number__c = 4;
        Obj.Condition_Type__c = 'rrrr';
        Obj.Condition_Description__c = 'rrrr';
        Obj.Rate__c = 240;
        Obj.Value__c = 22240;
        Obj.Charge_Based_On__c = 'Rate';
        insert Obj;
    
        list<REST_SapPricing_BulkOAuth.PricingWrapper> PriceWrap = new list<REST_SapPricing_BulkOAuth.PricingWrapper>();
        REST_SapPricing_BulkOAuth.PricingWrapper PW = new REST_SapPricing_BulkOAuth.PricingWrapper();
        pw.Material_code = sinlgeproperty.Material_No__c;
        pw.SR_NO = '1';
        pw.CONDITION_TYPE = 'qqqq';
        pw.Condition_description = 'qqqq';
        pw.RATE = 111;
        pw.Value = 11111;
        pw.Charge_Based_On = 'Rate';
        //Insert pw;
        
        REST_SapPricing_BulkOAuth.PricingWrapper PW1 = new REST_SapPricing_BulkOAuth.PricingWrapper();
        pw1.Material_code = '';
        pw1.SR_NO = '2';
        pw1.CONDITION_TYPE = 'wwww';
        pw1.Condition_description = 'wwww';
        pw1.RATE = 222;
        pw1.Value = 22222;
        pw1.Charge_Based_On = 'Rate';
        //Insert pw1;
        
        REST_SapPricing_BulkOAuth.PricingWrapper PW2 = new REST_SapPricing_BulkOAuth.PricingWrapper();
        pw2.Material_code = sinlgeproperty.Material_No__c;
        pw2.SR_NO = '3';
        pw2.CONDITION_TYPE = 'eeee';
        pw2.Condition_description = 'eeee';
        pw2.RATE = 0;
        pw2.Value = 0;
        pw2.Charge_Based_On = 'Rate';
        //Insert pw2;
        
        REST_SapPricing_BulkOAuth.PricingWrapper PW3 = new REST_SapPricing_BulkOAuth.PricingWrapper();
        pw3.Material_code = sinlgeproperty.Material_No__c;
        pw3.SR_NO = '4';
        pw3.CONDITION_TYPE = 'rrrr';
        pw3.Condition_description = 'rrrr';
        pw3.RATE = 250;
        pw3.Value = 22250;
        pw3.Charge_Based_On = 'Rate';
        //Insert pw3;
           
        PriceWrap.add(pw);
        PriceWrap.add(pw1);
        PriceWrap.add(pw2);
        PriceWrap.add(pw3);
        
        REST_SapPricing_BulkOAuth.FlowSapPricing_Bulk(PriceWrap);
    
    }
    
    @isTest
    Public static void REST_BillingPlanOAuth(){
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        Integer saleableArea = 1600;
        Integer carpetArea = 1050;
        Integer balconyArea = 600;
        
        Site__c st = new Site__c( Name = 'Test site' + Math.random());
        insert st;
        
        Project__c pj = new Project__c( 
        Name = 'Test Proj' + Math.random(), Plant__c ='767c' ,site__c =st.id,
        Active__c=true,Company_name__c='test', recordtypeId= PrRecordTypeId,
        Front_Desk_User__c = FrontDesk.id,Marcom_Head__c =dummyUser.Id, 
        Sales_Head__c =dummyUser.Id,Site_Head__c=dummyUser.Id, MD__c =dummyUser.Id, 
        Marcom_Manager__c = dummyUser.Id,CFO__c =dummyUser.Id);
        insert pj;
        
        Tower__c sinlgeTower = new Tower__c(Project_Name__c=pj.Id,tower_name__c='A');
        insert sinlgeTower;
        
        Property_Type__c PropertyType = new Property_Type__c(
        Material_No__c = '1239996'+string.valueOf(1),Description__c='TestPropertyType',Control_Code__c='Test',
        Saleable_Area__c=saleableArea,Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea,Project1__c= pj.Id);
        Insert PropertyType;
        
        Property__c sinlgeproperty = new Property__c(Property_Type__c=PropertyType.id,Material_No__c = '99999'+string.valueOf(5),
        Description__c='TestPropertyType',Control_Code__c='Test',Saleable_Area__c=saleableArea,
        Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea);
        insert sinlgeproperty;
        
        Payment_Plan__c pp = new Payment_Plan__c();
        pp.Site__c = pj.Site__c; 
        pp.Project__c = pj.Id; 
        pp.Tower__c = sinlgeTower.Id;
        pp.Payment_Plan_Number__c = '1001996';
        pp.Billing_Plan_Name__c = 'Scheme';
        pp.Active__c = True;
        Insert pp;
        
        Payment_Plan_Line_Item__c PPLI = new Payment_Plan_Line_Item__c ();
        PPLI.Payment_Plan__c = pp.Id;
        PPLI.Order__c = 1;
        PPLI.Payment_Date__c = System.Today().AddDays(-100);
        PPLI.Date_Description__c = 'AG01';
        PPLI.Usage__c = '';
        PPLI.Description__c = 'Agreement Execution';
        PPLI.Percentage__c = 40;
        PPLI.Percentage_Of_Value_To_Be_Invoiced__c = string.valueof(PPLI.Percentage__c);
        PPLI.Value_to_be_Billed__c = 0;
        PPLI.Currency_Key__c = '';
        PPLI.Billing_Block_For_Payment_Plan__c = '02';
        PPLI.Rule_In_Payment_Plan__c = '1';
        PPLI.Terms_of_Payment_Key__c = 'AG01';
        PPLI.Date_Category__c = 'Y2';
        PPLI.Billing_Plan_Type__c= '';
        PPLI.Milestone_Number__c = '000000000000';
        PPLI.ID_For_Adopting_Billing__c = '';
        Insert PPLI;
         
        Payment_Plan_Line_Item__c PPLI2 = new Payment_Plan_Line_Item__c ();
        PPLI2.Payment_Plan__c = pp.Id;
        PPLI2.Order__c = 2;
        PPLI2.Payment_Date__c = System.Today().AddDays(-100);
        PPLI2.Date_Description__c = 'BD01';
        PPLI2.Usage__c = '';
        PPLI2.Description__c = 'Agreement Execution';
        PPLI2.Percentage__c = 40;
        PPLI2.Percentage_Of_Value_To_Be_Invoiced__c = string.valueof(PPLI.Percentage__c);
        PPLI2.Value_to_be_Billed__c = 0;
        PPLI2.Currency_Key__c = '';
        PPLI2.Billing_Block_For_Payment_Plan__c = '02';
        PPLI2.Rule_In_Payment_Plan__c = '1';
        PPLI2.Terms_of_Payment_Key__c = 'BD01';
        PPLI2.Date_Category__c = 'Y2';
        PPLI2.Billing_Plan_Type__c= '';
        PPLI2.Milestone_Number__c = '000000000000';
        PPLI2.ID_For_Adopting_Billing__c = '';
        Insert PPLI2;
        
        List<REST_BillingPlanOAuth.PayPlanItems> PPLIlist = new List<REST_BillingPlanOAuth.PayPlanItems>();
        
        REST_BillingPlanOAuth.PayPlanItems PPIlist = New REST_BillingPlanOAuth.PayPlanItems();
        PPIlist.Sr_No = 1; 
        PPIlist.Billing_date = System.Today().AddDays(-91);
        PPIlist.date_description = 'AG01';
        PPIlist.usage_milestone = '';
        PPIlist.description = 'XYZ';
        PPIlist.percentage = 30;
        PPIlist.billing_value = 0;
        PPIlist.currencType = '' ;
        PPIlist.block = '02';
        PPIlist.milestone_assing = '';
        PPIlist.billing_rule = '1';
        PPIlist.ZTERM = 'AG01';
        PPIlist.date_category = 'YA';
        PPIlist.billing_type = '';
        PPIlist.milestone_number = '000000000000';
        PPIlist.ID_for_billing = '';
        PPLIlist.add(PPIlist);
        
        REST_BillingPlanOAuth.PayPlanItems PPIlist2 = New REST_BillingPlanOAuth.PayPlanItems();
        PPIlist2.Sr_No = 1; 
        PPIlist2.Billing_date = System.Today().AddDays(-91);
        PPIlist2.date_description = 'INBW';
        PPIlist2.usage_milestone = '';
        PPIlist2.description = 'XYZ';
        PPIlist2.percentage = 10;
        PPIlist2.billing_value = 0;
        PPIlist2.currencType = '' ;
        PPIlist2.block = '02';
        PPIlist2.milestone_assing = '';
        PPIlist2.billing_rule = '1';
        PPIlist2.ZTERM = 'INBW';
        PPIlist2.date_category = 'YA';
        PPIlist2.billing_type = '';
        PPIlist2.milestone_number = '000000000000';
        PPIlist2.ID_for_billing = '';
        PPLIlist.add(PPIlist2);
        
        REST_BillingPlanOAuth.Billing_Plan BP = New REST_BillingPlanOAuth.Billing_Plan();
        BP.Billing_Plan_Number = '1001997';
        BP.Project_ID = pj.Plant__c;
        BP.Tower = sinlgeTower.tower_name__c;
        BP.Billing_Plan_Type = 'Scheme';
        BP.Scheme_Id = 'YA';
        BP.Scheme_Name = 'Scheme';
        BP.IsDefault = 'X';
        BP.PayPlanItemsList = PPLIlist;
        
        REST_BillingPlanOAuth.Billing_Plan BP1 = New REST_BillingPlanOAuth.Billing_Plan();
        BP1.Billing_Plan_Number = '1001997';
        BP1.Project_ID = pj.Plant__c;
        BP1.Tower = sinlgeTower.tower_name__c;
        BP1.Billing_Plan_Type = 'Scheme';
        BP1.Scheme_Id = 'YA';
        BP1.Scheme_Name = 'Scheme';
        BP1.IsDefault = '';
        BP1.PayPlanItemsList = PPLIlist;
        
        REST_BillingPlanOAuth.Billing_Plan BP2 = New REST_BillingPlanOAuth.Billing_Plan();
        BP2.Billing_Plan_Number = '1001996';
        BP2.Project_ID = pj.Plant__c;
        BP2.Tower = sinlgeTower.tower_name__c;
        BP2.Billing_Plan_Type = 'Scheme';
        BP2.Scheme_Id = 'YA';
        BP2.Scheme_Name = 'Scheme';
        BP2.IsDefault = 'X';
        BP2.PayPlanItemsList = PPLIlist;
        
        REST_BillingPlanOAuth.Billing_Plan BP3 = New REST_BillingPlanOAuth.Billing_Plan();
        BP3.Billing_Plan_Number = '1001996';
        BP3.Project_ID = pj.Plant__c;
        BP3.Tower = sinlgeTower.tower_name__c;
        BP3.Billing_Plan_Type = 'Scheme';
        BP3.Scheme_Id = 'YA';
        BP3.Scheme_Name = 'Scheme';
        BP3.IsDefault = '';
        BP3.PayPlanItemsList = PPLIlist;
        
        REST_BillingPlanOAuth.FlowBillingPlanOAuth(BP);
        REST_BillingPlanOAuth.FlowBillingPlanOAuth(BP1);
        REST_BillingPlanOAuth.FlowBillingPlanOAuth(BP2);
        REST_BillingPlanOAuth.FlowBillingPlanOAuth(BP3);
        REST_BillingPlanOAuth.dummy();
    }
    
}
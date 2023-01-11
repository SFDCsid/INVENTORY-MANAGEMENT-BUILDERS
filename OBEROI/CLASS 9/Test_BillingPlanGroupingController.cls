@isTest
Public Class Test_BillingPlanGroupingController{
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
    Public static void createlineitems(){
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
        
        Payment_Plan__c pp2 = new Payment_Plan__c();
        pp2.Site__c = pj.Site__c; 
        pp2.Project__c = pj.Id; 
        pp2.Tower__c = sinlgeTower.Id;
        pp2.Payment_Plan_Number__c = '1001996';
        pp2.Billing_Plan_Name__c = 'Scheme';
        pp2.Active__c = True;
        Insert pp2;    
        
        Payment_Term__c ptm = new Payment_Term__c(
        Billing_Plan__c = pp.id,Tower__c = sinlgeTower.Id,
        Detailed_Description__c='AB',
        Name = 'IN00',Due_Days__c = 90,
        Milestone_Indicator__c = 0,
        Order__c = 5
        );
        insert ptm;
        Payment_Term__c ptm1 = new Payment_Term__c(
        Billing_Plan__c = pp.id,
        Tower__c = sinlgeTower.Id,
        Detailed_Description__c='AAA',
        Name = 'PL01',Due_Days__c = 90,
        Milestone_Indicator__c = 0,
        Order__c = 4
        );
        insert ptm1;
        Payment_Term__c ptm2 = new Payment_Term__c(
        Billing_Plan__c = pp.id,
        Tower__c = sinlgeTower.Id,
        Detailed_Description__c='BBB',
        Name = 'AG01',Due_Days__c = 90,
        Milestone_Indicator__c = 0,
        Order__c = 3);
        insert ptm2;
        Payment_Term__c ptm3 = new Payment_Term__c(
        Billing_Plan__c = pp.id,Tower__c = sinlgeTower.Id,
        Detailed_Description__c='AB1',
        Name = 'IN01',Due_Days__c = 90,
        Milestone_Indicator__c = 0,
        Order__c = 5
        );
        insert ptm3;
        
        List<Payment_Plan_Line_Item__c> lstOfPaymentPlanLineItem = new List<Payment_Plan_Line_Item__c>();
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='PL01',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='IN33',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='PL01',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='IN33',Percentage_Of_Value_To_Be_Invoiced__c='10'));
        INSERT lstOfPaymentPlanLineItem;
        
        
        List<Billing_Plan_Line_Item__c> lstOfBillingPlanLineItem = new List<Billing_Plan_Line_Item__c>();
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=pp.Id, Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='PL01'));
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=pp.Id, Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='IN33'));
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=pp.Id, Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='PL01'));
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Percentage_Of_Value_To_Be_Invoiced__c='20',Payment_Plan__c=pp.Id, Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='IN33'));
        INSERT lstOfBillingPlanLineItem;
        
       
        
        Payment_Term__c ptm4 = new Payment_Term__c(
        Billing_Plan__c = pp2.id,Tower__c = sinlgeTower.Id,
        Detailed_Description__c='AB',
        Name = 'INBW',Due_Days__c = 90,
        Milestone_Indicator__c = 0,
        Order__c = 5
        );
        insert ptm4;
        Payment_Term__c ptm5 = new Payment_Term__c(
        Billing_Plan__c = pp2.id,
        Tower__c = sinlgeTower.Id,
        Detailed_Description__c='AAA',
        Name = 'INST',Due_Days__c = 90,
        Milestone_Indicator__c = 0,
        Order__c = 4
        );
        insert ptm5;
        Payment_Term__c ptm6 = new Payment_Term__c(
        Billing_Plan__c = pp2.id,
        Tower__c = sinlgeTower.Id,
        Detailed_Description__c='BBB',
        Name = 'AG01',Due_Days__c = 90,
        Milestone_Indicator__c = 0,
        Order__c = 3);
        insert ptm6;
        Payment_Term__c ptm7 = new Payment_Term__c(
        Billing_Plan__c = pp2.id,Tower__c = sinlgeTower.Id,
        Detailed_Description__c='AB',
        Name = 'INEL',
        Due_Days__c = 90,
        Milestone_Indicator__c = 0,
        Order__c = 5
        );
        insert ptm7;
        Payment_Term__c ptm8 = new Payment_Term__c(
        Billing_Plan__c = pp2.id,Tower__c = sinlgeTower.Id,
        Detailed_Description__c='AB',
        Name = 'INPS',
        Due_Days__c = 90,
        Milestone_Indicator__c = 0,
        Order__c = 5
        );
        insert ptm8;
        Payment_Term__c ptm9 = new Payment_Term__c(
        Billing_Plan__c = pp2.id,Tower__c = sinlgeTower.Id,
        Detailed_Description__c='AB',
        Name = 'INPT',
        Due_Days__c = 90,
        Milestone_Indicator__c = 0,
        Order__c = 5
        );
        insert ptm9;
        
        List<Payment_Plan_Line_Item__c> lstOfPaymentPlanLineItem2 = new List<Payment_Plan_Line_Item__c>();
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='PL01',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='PL01',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='AG01',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='INBW',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='INEL',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='INPS',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='INPT',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='INST',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='INBW',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='INEL',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='INPS',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='INPT',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem2.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=pp2.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='INST',Percentage_Of_Value_To_Be_Invoiced__c='10'));
        INSERT lstOfPaymentPlanLineItem2;
        
        
        List<Billing_Plan_Line_Item__c> lstOfBillingPlanLineItem2 = new List<Billing_Plan_Line_Item__c>();
            lstOfBillingPlanLineItem2.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=pp2.Id, Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='PL01'));
            lstOfBillingPlanLineItem2.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=pp2.Id, Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='IN33'));
            lstOfBillingPlanLineItem2.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=pp2.Id, Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='PL01'));
            lstOfBillingPlanLineItem2.add(new Billing_Plan_Line_Item__c(Percentage_Of_Value_To_Be_Invoiced__c='20',Payment_Plan__c=pp2.Id, Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='IN33'));
        INSERT lstOfBillingPlanLineItem2;
        
        BillingPlanLineItemGroupingController.createBillingLineItemsFuture(pp.Id);
        BillingPlanLineItemGroupingController.createBillingLineItemsFuture(pp2.Id);
        
        Payment_Plan__c pp3 = new Payment_Plan__c();
        pp3.Site__c = pj.Site__c; 
        pp3.Project__c = pj.Id; 
        pp3.Tower__c = sinlgeTower.Id;
        pp3.Payment_Plan_Number__c = '101996';
        pp3.Billing_Plan_Name__c = 'Scheme';
        pp3.Active__c = True;
        Insert pp3;
        
        ComputeBillingPlanLineItems.Consolidate(pp.Id);
        ComputeBillingPlanLineItems.Consolidate(pp3.Id);
    }    
}
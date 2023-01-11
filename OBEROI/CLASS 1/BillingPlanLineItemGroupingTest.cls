@isTest(seeAllData=false)
public class BillingPlanLineItemGroupingTest {
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
    
    
    Public static testMethod void BillingPlanLineItemGroupingControllerTest_Test1() {
        //createTestData();
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        Integer saleableArea = 1600;
        Integer carpetArea = 1050;
        Integer balconyArea = 600;
        Test.startTest();  
        List<Site__c> lstOfSites = TestDataFactory.createSite(1);
        INSERT lstOfSites;
        
        Project__c lstOfProject = new Project__c( 
        Name = 'Test Proj' + Math.random(), Plant__c ='767c' ,site__c =lstOfSites[0].id,
        Active__c=true,Company_name__c='test', recordtypeId= PrRecordTypeId,
        Front_Desk_User__c = FrontDesk.id,Marcom_Head__c =dummyUser.Id, 
        Sales_Head__c =dummyUser.Id,Site_Head__c=dummyUser.Id, MD__c =dummyUser.Id, 
        Marcom_Manager__c = dummyUser.Id,CFO__c =dummyUser.Id);
        insert lstOfProject;
        
        List<Tower__c>lstOfTower = TestDataFactory.createTowers(1);
        lstOfTower[0].Project_Name__c = lstOfProject.Id;
        INSERT lstOfTower;
        
        
        List<Opportunity> lstOfOpp = TestDataFactory.createOpportunity(1);
        lstOfOpp[0].Partner_s_Firm_Name__c = 'Partner_s_Firm_Name__c';
        lstOfOpp[0].Partner_s_Name__c = 'Partner_s_Name__c';
        lstOfOpp[0].Partner_Mobile__c = '8723546789';
        lstOfOpp[0].Partner_Email__c = 'partner@test.com';
        lstOfOpp[0].PCID__c = 'PCID';
        lstOfOpp[0].Site__c = lstOfSites[0].Id;
        
        INSERT lstOfOpp;            
        
        List<Property_Type__c> lstOfProjtype = TestDataFactory.createProjectType(1);
        lstOfProjtype[0].Project1__c = lstOfProject.Id;
        INSERT lstOfProjtype;
        
        List<Property__c> lstOfProperty = TestDataFactory.createProperties(1);
        lstOfProperty[0].Property_Type__c = lstOfProjtype[0].Id;
        lstOfProperty[0].Temporary_Block__c = true;
        lstOfProperty[0].Block_Comments__c = 'Block property';
        lstOfProperty[0].Blocked_By__c = UserInfo.getUserId() ;
        lstOfProperty[0].Active__c = true;
        lstOfProperty[0].Tower__c = lstOfTower[0].Id;
        
        INSERT lstOfProperty;
        
        List<Payment_Term__c> lstPaymentTerm = new List<Payment_Term__c>();
        //List<Property__c> PropertyList = new List<Property__c>();
        Payment_Term__c ptm = new Payment_Term__c(Tower__c = lstOfTower[0].Id,Detailed_Description__c='AB',Name = 'IN00',Due_Days__c = 90,Milestone_Indicator__c = 0,Order__c = 5);
        Payment_Term__c ptm1 = new Payment_Term__c(Tower__c = lstOfTower[0].Id,Detailed_Description__c='AAA',Name = 'PL01',Due_Days__c = 90,Milestone_Indicator__c = 0,Order__c = 4);
        Payment_Term__c ptm2 = new Payment_Term__c(Tower__c = lstOfTower[0].Id,Detailed_Description__c='BBB',Name = 'AG01',Due_Days__c = 90,Milestone_Indicator__c = 0,Order__c = 3);
        
        lstPaymentTerm.add(ptm);
        lstPaymentTerm.add(ptm1);
        lstPaymentTerm.add(ptm2);
        
        INSERT lstPaymentTerm;
        
        List<Payment_Plan__c> lstOfBillingPlan = TestDataFactory.createBillingPlan(1);
        lstOfBillingPlan[0].Site__c = lstOfOpp[0].Site__c;
        lstOfBillingPlan[0].Project__c = lstOfProject.Id;
        lstOfBillingPlan[0].Tower__c = lstOfTower[0].Id;
        //lstOfBillingPlan[0].Property__c = lstOfProperty[0].Id;    
        INSERT lstOfBillingPlan;
        
        List<Payment_Plan_Line_Item__c> lstOfPaymentPlanLineItem = new List<Payment_Plan_Line_Item__c>();
        for(Payment_Plan__c plan: lstOfBillingPlan){
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=plan.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='PL01',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=plan.Id,Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='IN33',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=plan.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='PL01',Percentage_Of_Value_To_Be_Invoiced__c='10'));
            lstOfPaymentPlanLineItem.add(new Payment_Plan_Line_Item__c(Payment_Plan__c=plan.Id,Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='IN33',Percentage_Of_Value_To_Be_Invoiced__c='10'));
        }
        INSERT lstOfPaymentPlanLineItem;
        
        
        List<Billing_Plan_Line_Item__c> lstOfBillingPlanLineItem = new List<Billing_Plan_Line_Item__c>();
        for(Payment_Plan__c plan: lstOfBillingPlan){
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=plan.Id, Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='PL01'));
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=plan.Id, Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='IN33'));
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=plan.Id, Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='PL01'));
            lstOfBillingPlanLineItem.add(new Billing_Plan_Line_Item__c(Percentage_Of_Value_To_Be_Invoiced__c='20',Payment_Plan__c=plan.Id, Milestone_Number__c='000000000001',Terms_of_Payment_Key__c ='IN33'));
        }
        INSERT lstOfBillingPlanLineItem;
        Payment_Plan__c billingPlanIds = [SELECT id FROM Payment_Plan__c limit 1];
        system.debug('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+lstOfBillingPlan[0].Id);
        BillingPlanLineItemGroupingController.createBillingLineItemsFuture(lstOfBillingPlan[0].Id);
        
        //
        Id customRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        List<Payment_Plan__c> lstCustomBillingPlan = TestDataFactory.createBillingPlan(1);
        lstCustomBillingPlan[0].Site__c = lstOfOpp[0].Site__c;
        lstCustomBillingPlan[0].Project__c = lstOfProject.Id;
        lstCustomBillingPlan[0].Tower__c = lstOfTower[0].Id;
        lstCustomBillingPlan[0].Property__c = lstOfProperty[0].Id;
        lstCustomBillingPlan[0].Opportunity__c = lstOfOpp[0].Id;
        lstCustomBillingPlan[0].RecordTypeId = customRecordTypeId;
        lstCustomBillingPlan[0].Status__c = 'Approved';
        //lstCustomBillingPlan[0].Property__r.Booking__c = '';
        INSERT lstCustomBillingPlan;
        
        //lstCustomBillingPlan[0].RecordTypeId = customRecordTypeId;
        //update lstCustomBillingPlan;
         
        
        
        List<Billing_Plan_Line_Item__c> lstBPLI = new List<Billing_Plan_Line_Item__c>();
        for(Payment_Plan__c plan: lstCustomBillingPlan){
            lstBPLI.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=plan.Id, Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='PL01'));
            lstBPLI.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=plan.Id, Milestone_Number__c='000000000000',Terms_of_Payment_Key__c ='IN01'));
            lstBPLI.add(new Billing_Plan_Line_Item__c(Payment_Plan__c=plan.Id, Milestone_Number__c='1',Terms_of_Payment_Key__c ='PL01'));
            lstBPLI.add(new Billing_Plan_Line_Item__c(Percentage_Of_Value_To_Be_Invoiced__c='13',Payment_Plan__c=plan.Id, Milestone_Number__c='2',Terms_of_Payment_Key__c ='IN02'));
        }
        INSERT lstBPLI;
        
        map<String,String> mapBPlineItem = new map<String,String>();
         mapBPlineItem.put('IN','15');
        BillingPlanLineItemSlabController.stopBillingLineItems(mapBPlineItem,lstOfTower[0].Id);
        //
        Test.stopTest();
    }
    
}
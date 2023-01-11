/**
* @author:      
* @Company:     IBM
* @date:        12/03/2019
* @description: This class is to create records of Diferrent Entities which can be used across all the TestClasses
*
* History
* <Date>      <Authors Name>      <Brief Description of Change>
12/03/2019     Vaidehi Heda 
16/5/2019      Amit Kohakade       Added v1.1 section     
* ----------------------------------------------------*/

public abstract class TestDataFactory {
    
    Public static id campAdvertisementId = Schema.getGlobalDescribe().get('Campaign').getDescribe().getRecordTypeInfosByDeveloperName().get('Advertisement').getRecordTypeId();
    Public static id campChannelId = Schema.getGlobalDescribe().get('Campaign').getDescribe().getRecordTypeInfosByDeveloperName().get('Marketing_Channel').getRecordTypeId();
    Public static id campsingleprojId = Schema.getGlobalDescribe().get('Campaign').getDescribe().getRecordTypeInfosByDeveloperName().get('Marketing_Campaign_Single_Project').getRecordTypeId();
    Public static id campmultiProjId = Schema.getGlobalDescribe().get('Campaign').getDescribe().getRecordTypeInfosByDeveloperName().get('Marketing_Campaign_Multi_Project').getRecordTypeId();
    Public static id campsitePlanId = Schema.getGlobalDescribe().get('Campaign').getDescribe().getRecordTypeInfosByDeveloperName().get('Marketing_Plan_Site_Specific').getRecordTypeId();
    Public static id campHOPlanId = Schema.getGlobalDescribe().get('Campaign').getDescribe().getRecordTypeInfosByDeveloperName().get('Marketing_Plan_HO_Common').getRecordTypeId();
    Public static User dummyUser =createUser('ORL Admin', 'CFO_Director');
    Public static User FrontDesk =createUser('Front Desk','' );
    
    //RecordType    
    Public static id recordTypeId(string obj,string recName){
        id recTypeId;
        if(obj!= null && recName != null){
            recTypeId= Schema.getGlobalDescribe().get(obj).getDescribe().getRecordTypeInfosByName().get(recName).getRecordTypeId();
        }
        return recTypeId;
    }
    
    
    
    //Account creation
    public static List<Account> createAccounts( Integer numberOfAccounts) {
        List<Account> accounts = new List<Account>();
        for ( Integer i = 0 ; i < numberOfAccounts ; i++ ) {
            
            Account account = new Account( firstname = 'Test Account' + Math.random(), lastname = 'Account',
                                          PersonEmail = 'noreplay@email.com',PersonMailingStreet = '5353 W.Test Rd',
                                          PersonMailingCity = 'Testdale', PersonMailingState = 'CA', PersonMailingPostalCode = '94803');
            accounts.add( account);            
        }
        return accounts;        
    }
    
    
    //Contact creation
    public static List<Contact> createContacts( Integer numberOfContacts) {
        List<Contact> conList = new List<Contact>();
        for ( Integer i = 0 ; i < numberOfContacts ; i++ ) {            
            Contact cont = new Contact( Lastname = 'Test Cont' + Math.random(), Firstname = 'Contact',
                                       Email = 'noreplay@email.com');
            conList.add(cont);            
        }
        return conList;        
    }
    
    //Opportunity creation
    public static List<Opportunity> createOpportunity(Integer numberOfOppty) {
        List<Opportunity> oppList = new List<Opportunity>();
        for ( Integer i = 0 ; i < numberOfOppty ; i++ ) {            
            Opportunity oppt = new Opportunity( Name = 'Test Opp' + Math.random(),closeDate = system.Today(), StageName= 'New');
            oppList.add(oppt);            
        }
        return oppList;        
    }
    
    
    //Campaign creation
    public static List<Campaign> createCampaign( Integer numberOfCamp) {
        List<Campaign> campList = new List<Campaign>();
        for ( Integer i = 0 ; i < numberOfCamp ; i++ ) {            
            Campaign camp = new Campaign( Name = 'Test Camp' + Math.random(),StartDate =system.Today(),endDate =system.Today()+20, Total_Advrt_Utilization_Budget_Till_Date__c =0, IsActive= true, Marketing_Plan_Cost__c = 100);
            campList.add(camp);            
        }
        return campList;        
    }
    
    
    //Residential Lead creation
    public static List<Lead> createResLead( Integer numberOfLeads) {
        Id ldRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        List<Lead> Leads = new List<Lead>();
        for ( Integer i = 0 ; i < numberOfLeads ; i++ ) {            
            Lead ld = new Lead( lastname = 'Test Lead' + Math.random(), Status ='Open',LeadSource ='Web',Data_sheet_Submitted__c=false,firstname = 'ld',recordtypeId = ldRecordTypeId,
                               Email = 'noreplay' + i +'@email.com',Lead_Stage__c = 'Open', mobilePhone= '4345656699' + i);
            Leads.add(ld);
        }
        return Leads;        
    }
    
    //Luxury Lead creation
    public static List<Lead> createLuxLead( Integer numberOfLeads) {
        Id ldRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
        List<Lead> Leads = new List<Lead>();
        for ( Integer i = 0 ; i < numberOfLeads ; i++ ) {            
            Lead ld = new Lead( lastname = 'Test Lead' + Math.random(), LeadSource ='Web',firstname = 'ld',recordtypeId = ldRecordTypeId,
                               Email = 'noreplay@email.com',mobilePhone= '4345656699');
            Leads.add(ld);
        }
        return Leads;        
    }
    
    
    //Rsidential Project Creation
    public static List<Project__c> createResProject( Integer numberOfProjects) {
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        List<Site__c> sList = createSite(1);
        insert sList;
        List<Project__c> pList = new List<Project__c>();
        for ( Integer i = 0 ; i < numberOfProjects ; i++ ) {            
            Project__c pj = new Project__c( Name = 'Test Proj' + Math.random(), Plant__c ='767c' ,site__c =sList[0].id,
                                           Active__c=true,Company_name__c='test', recordtypeId= PrRecordTypeId,Front_Desk_User__c = FrontDesk.id,Marcom_Head__c =dummyUser.Id, Sales_Head__c =dummyUser.Id,Site_Head__c=dummyUser.Id, MD__c =dummyUser.Id, Marcom_Manager__c = dummyUser.Id, /*v1.1 Start*/CFO__c =dummyUser.Id/*v1.1 Ends*/);
            pList.add(pj);
        }
        //insert pList;
        System.debug('createresproject>>>>>>>>>>>>'+pList[0].Id);
        return pList;        
    }
    
    //Luxary Project creation
    public static List<Project__c> createLuxProject( Integer numberOfProjects) {
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
        List<Project__c> pList = new List<Project__c>();
        for ( Integer i = 0 ; i < numberOfProjects ; i++ ) {            
            Project__c pj = new Project__c( Name = 'Test Proj' + Math.random(), Plant__c ='767c' ,
                                           Active__c=true,Company_name__c='test', recordtypeId= PrRecordTypeId);
            pList.add(pj);
        }
        return pList;        
    }
    
    //Site creation
    public static List<Site__c> createSite( Integer numberOfsites) {
        //Id PrRecordTypeId = Schema.SObjectType.Site__c.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
        List<Site__c> sList = new List<Site__c>();
        for ( Integer i = 0 ; i < numberOfsites ; i++ ) {            
            Site__c st = new Site__c( Name = 'Test site' + Math.random());
            sList.add(st);
        }
        System.debug('createsite>>>>>>>>>>>>'+sList[0].Id);
        return sList;     
        
    }
    
    //ProjectType creation
    public static List<Property_Type__c> createProjectType(Integer numberOfProjectTypes) {
        integer projectCount = 1;
        List<Project__c> projectList = createResProject(projectCount);
        insert projectList;
        system.debug('project...,,,,,,list>>>'+ projectList[0].id);
        List<Property_Type__c> projectTypeList = new List<Property_Type__c>();
        Integer saleableArea = 1600;
        Integer carpetArea = 1050;
        Integer balconyArea = 600;
        for(Integer i=0; i<numberOfProjectTypes; i++){            
            Property_Type__c singlePropertyType = new Property_Type__c(
                Material_No__c = '123456'+string.valueOf(i),Description__c='TestPropertyType',Control_Code__c='Test',Saleable_Area__c=saleableArea,
                Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea,Project1__c=projectList[0].Id);
            projectTypeList.add(singlePropertyType);
        }
        system.debug('new proptype created@@@@@@@@@@@@@@@@@@@' + projectTypeList);
        return projectTypeList;
    }
    
    //Property creation
    public static List<Property__c> createProperties(Integer numberOfProperties) {
        integer projectTypeCount = 1;
        Integer saleableArea = 1600;
        Integer carpetArea = 1050;
        Integer balconyArea = 600;
        List<Property_Type__c> projectTypeList = createProjectType(projectTypeCount);
        //insert projectTypeList;
        system.debug(',,,,,,,,,,,,,,,,,>>>>>>>'+projectTypeList[0].Id);
        
        List<Property__c> PropertyList = new List<Property__c>();
        for(Integer i=0; i<numberOfProperties; i++){            
            Property__c sinlgeproperty = new Property__c(Property_Type__c=projectTypeList[0].id,Material_No__c = '123456'+string.valueOf(i),
                                                         Description__c='TestPropertyType',Control_Code__c='Test',Saleable_Area__c=saleableArea,
                                                         Carpet_Area__c=carpetArea,Balcony_Area__c=balconyArea);
            PropertyList.add(sinlgeproperty); 
        }     
        system.debug('new prop....list created@@@@@@@@@@@@@@@@@@@' + PropertyList);
        return PropertyList;
        
    }
    //Tower creation
    public static List<Tower__c> createTowers(Integer numberOfTowers) {
        integer projectCount = 1;
        List<Project__c> projectList = createResProject(projectCount);
        insert projectList;
        List<Tower__c> towerList = new List<Tower__c>();
        for(Integer i=0; i<numberOfTowers; i++){
            Tower__c sinlgeTower = new Tower__c(Project_Name__c=projectList[0].Id);
            towerList.add(sinlgeTower);
            System.debug('towerlist>>>>>>>>>>>>'+projectList[0].Id);
        }
        System.debug('towerlist>>>>>>>>>>>>'+projectList[0].Id);
        return towerList;
        

    }
    //BillingPlan creation
    public static List<Payment_Plan__c> createBillingPlan(Integer numberOfBillingPlan) {
        Id recordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();           
        system.debug('recordtype ---'+recordTypeId );
        integer projectCount = 1;
        
        List<Project__c> projectList = createResProject(projectCount);
        List<Property__c> propertyList = createProperties(projectCount);
        
        List<Payment_Plan__c> paymentPlanList = new List<Payment_Plan__c>();
        for(Integer i=0; i<numberOfBillingPlan; i++){
            Payment_Plan__c sinlgePaymentPlan = new Payment_Plan__c(recordTypeId= recordTypeId ,
                                                                    Property__c=propertyList[0].Id,Project__c=projectList[0].id);
            paymentPlanList.add(sinlgePaymentPlan);
        }
        system.debug('paymentPlanList---->'+paymentPlanList);
        return paymentPlanList;
    }
    
    //BillingPlanLineItem creation
    public static List<Billing_Plan_Line_Item__c> createBillingPlanLineItem(List<Payment_Plan__c> paymentPlanList) {   
        system.debug('paymentPlanList---->'+paymentPlanList.size());
        List<Billing_Plan_Line_Item__c> billingPlanLineItemList = new List<Billing_Plan_Line_Item__c>();
        for(Integer i=0; i<paymentPlanList.size(); i++){
            Billing_Plan_Line_Item__c sinlgeBillingPlanLineItem = new Billing_Plan_Line_Item__c(
                    Payment_Plan__c = paymentPlanList[i].Id);
            billingPlanLineItemList.add(sinlgeBillingPlanLineItem);
        }
        system.debug('billingPlanLineItemList-------->'+billingPlanLineItemList);
        return billingPlanLineItemList;
    }
    //Booking creation
    public static List<Booking__c> createBookings(Integer numberOfBookings) {
        integer propertyCount = 1;
        List<Project__c> projectList = createResProject(propertyCount);
        List<Property__c> propertyList = createProperties(propertyCount);

        //List<Payment_Plan__c> billingPlanList = createBillingPlan(propertyCount);
        List<Booking__c> bookingList = new List<Booking__c>();
        //User newUser = createUser();
        for(Integer i=0; i<numberOfBookings; i++){
            Booking__c sinlgeBooking = new Booking__c(Property__c=propertyList[0].id,Project__c=projectList[0].id,Search_Term__c='Test'+i);
            
            bookingList.add(sinlgeBooking);
        }
        return bookingList;
    }
    
    //v1.1 Start 
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
    
    public static List<Account> createAccount(List<Map<String,String>> lstToInsert){
        List<Account> lstOfAccountToInsert = new List<Account>();
        for(Map<String,String> recordInMap: lstToInsert){
            Account accountRecord = new Account();
            accountRecord.Name = recordInMap.get('Name');
            accountRecord.AccountNumber = recordInMap.get('AccountNumber');
            lstOfAccountToInsert.add(accountRecord);
        }
        
        INSERT lstOfAccountToInsert;
        return lstOfAccountToInsert;
    }
    
    public static List<Contact> createContact(List<Map<String,String>> lstToInsert){
        List<Contact> lstOfContactToInsert = new List<Contact>();
        for(Map<String,String> recordInMap: lstToInsert){               
            Contact contactObj = new Contact();
            contactObj.firstName = recordInMap.get('firstName');
            contactObj.lastname = recordInMap.get('lastname');
            contactObj.AccountId = recordInMap.get('Account');
            contactObj.PAN__c = recordInMap.get('PAN');
        }
        
        INSERT lstOfContactToInsert;        
        return lstOfContactToInsert;
    }
    
    //v1.1 Ends
    
    
    //Virtual No creation
    public static List<Virtual_Number__c> createVNo(Integer numberOfvNos) {
        
        List<Virtual_Number__c> vNoList = new List<Virtual_Number__c>();
        for(Integer i=0; i<numberOfvNos; i++){
            Virtual_Number__c no = new Virtual_Number__c(Name = String.valueOf(Integer.valueof(Math.random())));
            vNoList.add(no);
        }
        return vNoList;
    }
    
    
    
    //MD Approval creation
    public static List<MD_Approval__c> createMDApproval(Integer numberOfvNos) {
        List<Project__c> projList;
        List<MD_Approval__c> vNoList = new List<MD_Approval__c>();
        List<Property__c> propList;
        for(Integer i=0; i<numberOfvNos; i++){
            projList = createResProject(1);            
            propList = createProperties(1);           
            MD_Approval__c no = new MD_Approval__c(Project__c = projList[0].id,Property__c=propList[0].id, Department__c = 'CRM' );
            vNoList.add(no);
        }
        return vNoList;
    }
    
    public static Project_Quota__c createProjectQuota(String projectId, String month, Integer year, Decimal target) {
        return new Project_Quota__c(
            Project__c = projectId,
            Year__c = year,
            Month__c = month,
            Target__c = target
        );
    }
    
    public static User_Quota__c createUserQuota(String projectQuotaId, String projectId, String month, Integer year, Decimal target) {
        return new User_Quota__c(
            Project_Quota__c = projectQuotaId,
            Project__c = projectId,
            Year__c = year,
            Month__c = month,
            Target__c = target
        );
    }
}
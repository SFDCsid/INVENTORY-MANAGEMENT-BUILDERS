/**
* @author:      
* @Company:     STETIG
* @date:        28/12/2020
* @description: This class is to create records of Diferrent Entities which can be used across all the TestClasses
*
* History
* <Date>      <Authors Name>      <Brief Description of Change>
28/12/2020     Vikas Gavhane     
* ----------------------------------------------------*/

public abstract class TestDataFactory_Stetig {
    Public static User FrontDesk =createUser('Front Desk','' );
    Public static User dummyUser =createUser('ORL Admin', 'CFO_Director');
    
    //Opportunity creation
    public static List<Opportunity> createOpportunity(Integer numberOfOppty) {
        List<Opportunity> oppList = new List<Opportunity>();
        for ( Integer i = 0 ; i < numberOfOppty ; i++ ) {            
            Opportunity oppt = new Opportunity( Name = 'Test Opp' + Math.random(),closeDate = system.Today(), StageName= 'New');
            oppList.add(oppt);            
        }
        return oppList;        
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
    
    //Rsidential Project Creation
    public static List<Project__c> createResProject( Integer numberOfProjects) {
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        List<Site__c> sList = createSite(1);
        insert sList;
        List<Project__c> pList = new List<Project__c>();
        for ( Integer i = 0 ; i < numberOfProjects ; i++ ) {            
            Project__c pj = new Project__c( Name = 'Test Proj' + Math.random(), Plant__c ='767c' ,site__c =sList[0].id,Available_for_Datasheet__c=true, 
                                           Active__c=true,Company_name__c='test', recordtypeId= PrRecordTypeId,Front_Desk_User__c = FrontDesk.id,Marcom_Head__c =dummyUser.Id, Sales_Head__c =dummyUser.Id,Site_Head__c=dummyUser.Id, MD__c =dummyUser.Id, Marcom_Manager__c = dummyUser.Id, /*v1.1 Start*/CFO__c =dummyUser.Id/*v1.1 Ends*/);
            pList.add(pj);
        }
        //insert pList;
        System.debug('createresproject>>>>>>>>>>>>'+pList[0].Id);
        return pList;        
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

}
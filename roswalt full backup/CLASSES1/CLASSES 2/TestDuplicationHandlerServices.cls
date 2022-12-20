@isTest
public class TestDuplicationHandlerServices {
    @isTest
    public static Project__c createProject() {
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
        return p;
    }
    
    @isTest
    public static void leadMobileDuplicate() {
        List<Lead> leadList = new List<Lead>();
        Project__c p = createProject();
        
        Team__c tm = new Team__c();
        tm.Name = 'test2';
        tm.Project__c = p.id;
        tm.Team_Type__c = 'Presales Team';
        insert tm;
        
        Team_Members__c tmc = new Team_Members__c();
        tmc.Team__c = tm.id;
        tmc.Availability__c = true;
        tmc.Sequence_Number__c = 1;
        tmc.User__c = Userinfo.getUserId();
        insert tmc;
        
        Lead l1 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Open', MobilePhone = '1122334455', Project__c = p.Id , Apply_Round_Robin__c = true);
        insert l1;
        Lead l11 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Open', MobilePhone = '1122334455', Project__c = p.Id , Apply_Round_Robin__c = true);
        insert l11;
        
        Lead l2 = new Lead(FirstName = 'Test', LastName = 'Lead 2', Status = 'Open', MobilePhone = '1122334455', Project__c = p.Id , Apply_Round_Robin__c = true);
        leadList.add(l2);
        
        Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
    }
    
    @isTest
    public static void leadEmailDuplicate() {
        List<Lead> leadList = new List<Lead>();
        Project__c p = createProject();
        
        Team__c tm = new Team__c();
        tm.Name = 'test2';
        tm.Project__c = p.id;
        tm.Team_Type__c = 'Presales Team';
        insert tm;
        
        Team_Members__c tmc = new Team_Members__c();
        tmc.Team__c = tm.id;
        tmc.Availability__c = true;
        tmc.Sequence_Number__c = 1;
        tmc.User__c = Userinfo.getUserId();
        insert tmc;
        
        Lead l1 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Open', MobilePhone = '1122334455', Email = 'lead@test.in', Project__c = p.Id , Apply_Round_Robin__c = true);
        insert l1;
        Lead l2 = new Lead(FirstName = 'Test', LastName = 'Lead 2', Status = 'Open', MobilePhone = '1122334456', Email = 'lead@test.in', Project__c = p.Id , Apply_Round_Robin__c = true);
        leadList.add(l2);
        
        Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
    }
    
    @isTest
    public static void leadPhoneDuplicate() {
        List<Lead> leadList = new List<Lead>();
        Project__c p = createProject();
        
        Team__c tm = new Team__c();
        tm.Name = 'test2';
        tm.Project__c = p.id;
        tm.Team_Type__c = 'Presales Team';
        insert tm;
        
        Team_Members__c tmc = new Team_Members__c();
        tmc.Team__c = tm.id;
        tmc.Availability__c = true;
        tmc.Sequence_Number__c = 1;
        tmc.User__c = Userinfo.getUserId();
        insert tmc;
        
        Lead l1 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Open', MobilePhone = '1122334455', Email = 'lead@test.in', Phone = '6677889900', Project__c = p.Id , Apply_Round_Robin__c = true);
        insert l1;
        Lead l2 = new Lead(FirstName = 'Test', LastName = 'Lead 2', Status = 'Open', MobilePhone = '1122334456', Email = 'lead1@test.in', Phone = '6677889900', Project__c = p.Id , Apply_Round_Robin__c = true);
        leadList.add(l2);
        
        Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
    }
    
    @isTest
    public static void leadAlternateEmailDuplicate() {
        List<Lead> leadList = new List<Lead>();
        Project__c p = createProject();
        
        Team__c tm = new Team__c();
        tm.Name = 'test2';
        tm.Project__c = p.id;
        tm.Team_Type__c = 'Presales Team';
        insert tm;
        
        Team_Members__c tmc = new Team_Members__c();
        tmc.Team__c = tm.id;
        tmc.Availability__c = true;
        tmc.Sequence_Number__c = 1;
        tmc.User__c = Userinfo.getUserId();
        insert tmc;
        
        Lead l1 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Open', MobilePhone = '1122334455', Email = 'lead1@test.in', Alternate_Email_Id__c = 'lead@test.in', Project__c = p.Id , Apply_Round_Robin__c = true);
        insert l1;
        l1.Apply_Round_Robin__c = true;
        update l1;
        Lead l11 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Open', MobilePhone = '1122334454', Email = 'lead12@test.in', Alternate_Email_Id__c = 'lead22@test.in', Project__c = p.Id , Apply_Round_Robin__c = true);
        insert l11;
        l11.MobilePhone = '1122334455';
        update l11;
        Lead l2 = new Lead(FirstName = 'Test', LastName = 'Lead 2', Status = 'Open', MobilePhone = '1122334456', Email = 'lead2@test.in', Alternate_Email_Id__c = 'lead@test.in', Project__c = p.Id , Apply_Round_Robin__c = true);
        leadList.add(l2);
        LeadRoundRobinHandler lrr = new LeadRoundRobinHandler();
        Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
    }
    
    @isTest
    public static void accountMobileDuplicate() {
        List<Account> accList = new List<Account>();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455' , RecordTypeId = devRecordTypeId);
        insert a1;
        Account a11 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334454' ,RecordTypeId = devRecordTypeId);
        insert a11;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334455' , RecordTypeId = devRecordTypeId);
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
    
    @isTest
    public static void accountEmailDuplicate() {
        List<Account> accList = new List<Account>();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455', PersonEmail = 'lead@test.in' , RecordTypeId = devRecordTypeId);
        insert a1;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334456', PersonEmail = 'leads@test.in' , RecordTypeId = devRecordTypeId);
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
    
    @isTest
    public static void accountPhoneDuplicate() {
        List<Account> accList = new List<Account>();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455', PersonEmail = 'lead@test.in', Phone = '6677889900' , RecordTypeId = devRecordTypeId);
        insert a1;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334456', PersonEmail = 'lead1@test.in', Phone = '6677889990' , RecordTypeId = devRecordTypeId);
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
    
    @isTest
    public static void accountAlternateEmailDuplicate() {
        List<Account> accList = new List<Account>();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455', PersonEmail = 'lead1@test.in', Alternate_Email__c = 'lead@test.in' , RecordTypeId = devRecordTypeId);
        insert a1;
        a1.Phone = '6677889900';
        update a1;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334456', PersonEmail = 'lead2@test.in', Alternate_Email__c = 'lead@test.in' , RecordTypeId = devRecordTypeId);
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
}
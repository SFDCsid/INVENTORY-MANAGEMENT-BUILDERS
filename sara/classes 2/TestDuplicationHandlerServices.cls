@isTest
public class TestDuplicationHandlerServices {
	@isTest
    public static Project__c createProject() {
    	Project__c p = new Project__c();
        p.Name = 'Test Project';
        p.Cluster__c = 'Cluster A';
        insert p;
        return p;
    }
    
    @isTest
    public static void leadMobileDuplicate() {
        List<Lead> leadList = new List<Lead>();
        Project__c p = createProject();
        
        Lead l1 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Incoming', MobilePhone = '1122334455', Project__c = p.Id);
        insert l1;
        Lead l11 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Incoming', MobilePhone = '1122334455', Project__c = p.Id);
        List<Lead> leadNewList = new List<Lead>();
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
        leadNewList.Add(l11);
        Database.insert(leadNewList, dml);
        //insert l11;
        Lead l2 = new Lead(FirstName = 'Test', LastName = 'Lead 2', Status = 'Incoming', MobilePhone = '1122334455', Project__c = p.Id);
        leadList.add(l2);
        
        Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
    }
    
    @isTest
    public static void leadEmailDuplicate() {
        List<Lead> leadList = new List<Lead>();
        Project__c p = createProject();
        
        Lead l1 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Incoming', MobilePhone = '1122334455', Email = 'lead@test.in', Project__c = p.Id);
        insert l1;
        Lead l2 = new Lead(FirstName = 'Test', LastName = 'Lead 2', Status = 'Incoming', MobilePhone = '1122334456', Email = 'lead@test.in', Project__c = p.Id);
        leadList.add(l2);
        
        Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
    }
    
    @isTest
    public static void leadPhoneDuplicate() {
        List<Lead> leadList = new List<Lead>();
        Project__c p = createProject();
        
        Lead l1 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Incoming', MobilePhone = '1122334455', Email = 'lead@test.in', Phone = '6677889900', Project__c = p.Id);
        insert l1;
        Lead l2 = new Lead(FirstName = 'Test', LastName = 'Lead 2', Status = 'Incoming', MobilePhone = '1122334456', Email = 'lead1@test.in', Phone = '6677889900', Project__c = p.Id);
        leadList.add(l2);
        
        Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
    }
    
    @isTest
    public static void leadAlternateEmailDuplicate() {
        List<Lead> leadList = new List<Lead>();
        Project__c p = createProject();
        
        Lead l1 = new Lead(FirstName = 'Test', LastName = 'Lead 1', Status = 'Incoming', MobilePhone = '1122334455', Email = 'lead1@test.in', Alternate_Email__c = 'lead@test.in', Project__c = p.Id);
        insert l1;
        Lead l2 = new Lead(FirstName = 'Test', LastName = 'Lead 2', Status = 'Incoming', MobilePhone = '1122334456', Email = 'lead2@test.in', Alternate_Email__c = 'lead@test.in', Project__c = p.Id);
        leadList.add(l2);
        
        Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Lead, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheck(leadList);
    }
    
    @isTest
    public static void accountMobileDuplicate() {
        List<Account> accList = new List<Account>();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455');
        insert a1;
        Account a11 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455');
        insert a11;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334455');
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
    
    @isTest
    public static void accountEmailDuplicate() {
        List<Account> accList = new List<Account>();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455', PersonEmail = 'lead@test.in');
        insert a1;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334456', PersonEmail = 'lead@test.in');
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
    
    @isTest
    public static void accountPhoneDuplicate() {
        List<Account> accList = new List<Account>();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455', PersonEmail = 'lead@test.in', Phone = '6677889900');
        insert a1;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334456', PersonEmail = 'lead1@test.in', Phone = '6677889900');
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
    
    @isTest
    public static void accountAlternateEmailDuplicate() {
        List<Account> accList = new List<Account>();
        
        Account a1 = new Account(FirstName = 'Test', LastName = 'Lead 1', PersonMobilePhone = '1122334455', PersonEmail = 'lead1@test.in', Alternate_Email__c = 'lead@test.in');
        insert a1;
        a1.Phone = '6677889900';
        update a1;
        Account a2 = new Account(FirstName = 'Test', LastName = 'Lead 2', PersonMobilePhone = '1122334456', PersonEmail = 'lead2@test.in', Alternate_Email__c = 'lead@test.in');
        accList.add(a2);
        
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accList);
    }
}
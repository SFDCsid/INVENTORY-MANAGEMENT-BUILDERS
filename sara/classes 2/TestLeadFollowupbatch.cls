@isTest
public class TestLeadFollowupbatch {

@isTest
public static void TestLeadFollowupBatch1()
    {
        Test.StartTest();
        Lead l = new Lead();
        l.LastName = 'Test 1';
        l.Company = 'ABC';
        l.MobilePhone = '9001202121';
        l.Phone = '9001202122';
        l.Alternate_Email__c = 'test44@gmail.com';
        l.Presale_Next_Follow_up_Date__c =system.now().addMinutes(60); 
        l.Email = 'test22@gmail.com';
        insert l;
        
        LeadFollowUpBatch b = new LeadFollowUpBatch(); 
        database.executebatch(b,2000);
        
        Lead l1 = new Lead();
        l1.LastName = 'Test 2';
        l1.MobilePhone = '9001202121';
        l1.Company = 'ABC';
        l1.Phone = '9001202123';
        l1.Alternate_Email__c = 'test@gmail.com';
        l1.Email = 'test2@gmail.com';
        l1.Presale_Next_Follow_up_Date__c =system.now().addMinutes(60);
        List<Lead> leadNewList = new List<Lead>();
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
        leadNewList.Add(l1);
        Database.insert(leadNewList, dml);
        //insert l1;
        
        
        
        
        Test.StopTest();
        
    }
}
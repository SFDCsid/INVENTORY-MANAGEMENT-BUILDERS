@isTest(SeeAllData=false)
public class UtilityTest {
    
    @isTest
    static void testGetPageParam(){
		test.startTest();
        apexpages.currentpage().getparameters().put('id' , 'test');
        String result = Utility.getPageParam('id');
        system.assert(result!=null);
        test.stopTest();
    }
    
    @isTest
    static void testChangeToWords(){
		test.startTest();     
        String result = Utility.changeToWords('13426556.89',true);
        system.assert(result!=null);
        test.stopTest();
    }
    
    @isTest
    static void testQueryFieldsFromFieldSet(){
		test.startTest();     
        FieldSetWrapper result = Utility.queryFieldsFromFieldSet(null,'id','Opportunity');
        test.stopTest();
    }
    
    @isTest
    static void testGetLocalDateTime(){
		test.startTest();     
        DateTime result = Utility.getLocalDateTime(Datetime.now());
        system.assert(result!=null);
        test.stopTest();
    }

    @isTest
    static void testGetId(){
        Account acc = new Account(Name='Test');
        insert acc;
        List<Account> objects = [select Id from Account];     
		test.startTest();     
        Set<Id> result = Utility.getId(objects,'Id');
        system.assert(result!=null);
        test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testGroupBy(){
		List<SObject> objects = [select Id,status__c from booking__c limit 10];
		test.startTest();     
        Map<String, List<sObject>> result = Utility.GroupBy(objects,'status__c');
        system.assert(result!=null);
        test.stopTest();        
    }
}
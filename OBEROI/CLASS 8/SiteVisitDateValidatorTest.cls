@isTest
public class SiteVisitDateValidatorTest{

    @isTest
    public static void negativeUseCase1(){
        list<lead> leadList = TestDataFactory.createResLead(200);
        for(Lead l : leadList){
            l.Date_of_Site_Visit__c = Datetime.newInstanceGmt(2019,4,29,2,30,0);
        }
        Test.startTest();
        Database.SaveResult[] result = database.insert(leadList, false);
        Test.stopTest();
        assertVals(false, result, Label.Invalid_Site_Visit_DateTime);
    }
    
    @isTest
    public static void negativeUseCase2(){
        list<lead> leadList = TestDataFactory.createResLead(200);
        for(Lead l : leadList){
            l.Date_of_Site_Visit__c = Datetime.newInstanceGmt(2019,4,29,12,40,0);
        }
        Test.startTest();
        Database.SaveResult[] result = database.insert(leadList, false);
        Test.stopTest();
        assertVals(false, result, Label.Invalid_Site_Visit_DateTime);
    }
    
    @isTest
    public static void positiveUseCase1(){
        list<lead> leadList = TestDataFactory.createResLead(30);
        for(Lead l : leadList){
            l.Date_of_Site_Visit__c = Datetime.newInstanceGmt(2019,4,29,3,30,0);
        }
        Test.startTest();
        Database.SaveResult[] result = database.insert(leadList);
        Test.stopTest();
        assertVals(true, result, null);
    }
    
    @isTest
    public static void positiveUseCase2(){
        list<lead> leadList = TestDataFactory.createResLead(30);
        for(Lead l : leadList){
            l.Date_of_Site_Visit__c = Datetime.newInstanceGmt(2019,4,29,12,30,0);
        }
        Test.startTest();
        Database.SaveResult[] result = database.insert(leadList, false);
        Test.stopTest();
        assertVals(true, result, null);
    }
    
    @isTest
    public static void positiveUseCase3(){
        list<lead> leadList = TestDataFactory.createResLead(30);
        for(Lead l : leadList){
            l.Date_of_Site_Visit__c = Datetime.newInstanceGmt(2019,4,29,11,30,0);
        }
        Test.startTest();
        Database.SaveResult[] result = database.insert(leadList, false);
        Test.stopTest();
        assertVals(true, result, null);
    }
    
    static void assertVals(boolean isSuccess, Database.SaveResult[] result, String errorMsg){
        String message;
        for(Database.SaveResult res : result){
           
            System.assertEquals(res.isSuccess(),isSuccess);
            if(!isSuccess){
               message = '';
               for(Database.Error err : res.getErrors()) {
                   message += err.getMessage();
               }
               System.assert(message.contains(errorMsg));
            }
        }
    }
}
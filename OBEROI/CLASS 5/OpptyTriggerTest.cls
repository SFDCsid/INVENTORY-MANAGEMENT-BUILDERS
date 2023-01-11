@isTest
public class OpptyTriggerTest {
    
    @isTest
    public static void unitTest(){
        List<Opportunity> opList=TestDataFactory.createOpportunity(1);
        insert opList;
        update opList;
        delete opList[0];
        
    }

}
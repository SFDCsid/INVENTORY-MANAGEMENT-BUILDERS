@isTest
public class AsyncBillingPlanGroupingTest {
    
    @isTest static void TestList(){
	List<string> demo = new list<string>();
		demo.add('abc');
    	demo.add('element');
    
    	AsyncBillingPlanGrouping apc = new AsyncBillingPlanGrouping(demo);
          Test.startTest();
            System.enqueueJob(apc);
          Test.stopTest();
    }
}
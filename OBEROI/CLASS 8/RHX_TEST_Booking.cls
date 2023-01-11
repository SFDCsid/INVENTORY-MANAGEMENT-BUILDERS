@isTest(SeeAllData=true)
public class RHX_TEST_Booking {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Booking__c LIMIT 1];
        ((Booking__c) sourceList[0]).Status__c = 'Approved';
            update sourceList;
        System.debug('list ' + sourceList);
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Booking__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}
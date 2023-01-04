//-------------------------------------------//
//  Project: Raunak Developers
//  Created By: Exceller Consultancy
//  Created Date: 21-11-2022
//-------------------------------------------//
@isTest
public class TestScreenPopPageController {
    @isTest
    public static void leadAccountPagePop() {
        Lead_c__c l = new Lead_c__c(First_Name__c = 'Test', Last_Name__c = 'Lead', Mobile__c = '1234567890');
        insert l;
        
        Account a = new Account(FirstName = 'Test', LastName = 'Account', PersonMobilePhone = '1234567891');
        insert a;
        Opportunity_c__c op = new Opportunity_c__c (First_Name__c = 'Test Opp', Account_Name__c=a.Id);
        insert op;
        
        Test.startTest();
        	PageReference pRef = Page.ScreenPopPage;
            Test.setCurrentPage(pRef);
            Apexpages.currentPage().getParameters().put('did', '1234');
            Apexpages.currentPage().getParameters().put('phone', '1234567890');
            ScreenPopPageController sc = new ScreenPopPageController();
            sc.screenPop();
        
        	Apexpages.currentPage().getParameters().put('did', '1234');
            Apexpages.currentPage().getParameters().put('phone', '01234567891');
            ScreenPopPageController sc1 = new ScreenPopPageController();
            sc1.screenPop();
        Test.stopTest();
    }
}
@isTest
public with sharing class TestScreenPopPageController {
    @isTest
    public static void leadAccountPagePop() {
        Lead l = new Lead(FirstName = 'Test', LastName = 'Lead', MobilePhone = '1234567890');
        insert l;
        
        Account a = new Account(FirstName = 'Test', LastName = 'Account', PersonMobilePhone = '1234567891');
        insert a;
        Opportunity op = new Opportunity(Name = 'Test Opp', StageName = 'Assigned', AccountId=a.Id, CloseDate=system.today().addDays(30));
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
@isTest
public class TestEx_InventoryPage {
    @isTest
    public static void testInventoryPage() {
        Project__c pro = new Project__c();
        pro.Name = 'Test Project';
        insert pro;
       
        Tower__c twr = new Tower__c();
        twr.Name = 'TowerA';
        twr.Project__c = pro.Id;
        insert twr;
        
        Unit__c un = new Unit__c();
        //un.Name = '1BHK501';
       	un.Purpose__c = 'Sale';
        un.Approval_Status__c = 'Approved';
        un.Custodian_Type__c = 'Retail';
        un.For_Sale__c = 'Yes';
        un.Unit_Status__c = 'Vacant';
        un.Configuration__c = '1 BHK';
        un.Inventory_Type__c = 'Residential';
        un.Floor__c = 5;
        un.Project__c = pro.Id;
        un.Tower__c = twr.Id;
        insert un;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        acc.LastName = 'acc1';
        acc.Phone = '99854857584';
        acc.PersonMobilePhone = '9958455544';
        acc.Alternate_Email__c = 'acc1@gmail.com';
        acc.PersonEmail = 'acc11@gmail.com';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test op';
        opp.AccountId = acc.Id;
        opp.StageName = 'Booking Confirmed';
        opp.CloseDate = system.today().addDays(1);
        opp.Project__c = pro.Id;
        opp.Sales_Next_Follow_up_Date__c = system.now();
        
        insert opp;
        
        Test.startTest();
        	PageReference pRef = Page.Ex_InventoryPage;
            ApexPages.currentPage().getParameters().put('opId',opp.Id);
        
        	Ex_InventoryPageController inpage=new Ex_InventoryPageController();
        	inpage.selectPro=pro.Id;
        	inpage.selectTower=twr.Id;
        
            List<SelectOption> prolst=inpage.getProjectList;
            List<SelectOption> twrlst= inpage.getTowerList;
            List<Decimal> unlst = inpage.getUnit;
            
     	Test.stopTest();
    }
}
@isTest
public class testBooking
{
    @isTest
    public static void testBooking1()
    {
       
        Id rctId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account a = new Account ();
        a.LastName = 'acc 2';
        a.Phone = '9822341223';
        a.PersonMobilePhone = '9922341223';
        a.Alternate_Email__c = 'acc12@gmail.com';
        a.PersonEmail = 'acc32@gmail.com';
        a.recordTypeId = rctId;
        //a.Project_Name_For_Sharing__c = 'test';
        insert a;
        
        project__c pr = new project__c();
        pr.Name = 'Test project';
        insert pr;
        
        
        Tower__c tw = new Tower__c();
        tw.Name = 'Test Tower';
        tw.Project__c = pr.id;
        insert tw;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test op';
        opp.AccountId = a.Id;
        opp.StageName = 'Assigned';
        opp.CloseDate = system.today().addDays(1);
        opp.Project__c = pr.Id;
        opp.Sales_Next_Follow_up_Date__c = system.now();
        opp.Master_Source__c = 'Recommended by Friends/Relatives';
        opp.Lead_Source__c = 'Employees';
        opp.Employee_Referrer_Name__c = 'Test';
        insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test op';
        opp1.AccountId = a.Id;
        opp1.StageName = 'Assigned';
        opp1.CloseDate = system.today().addDays(1);
        opp1.Project__c = pr.Id;
        opp1.Sales_Next_Follow_up_Date__c = system.now();
        opp1.Master_Source__c = 'Other';
        opp1.Lead_Source__c = 'Other';
        opp1.Other_Source_Details__c = 'Test';
        insert opp1;
        
        Unit__c u = new Unit__c();
        u.Floor__c = 1;
        u.Flat_No__c = 101;
        u.View__c = 'Garden';
        u.Project__c = pr.Id;
        u.tower__c = tw.Id;
        u.Purpose__c = 'Sale';
        u.Approval_Status__c = 'Approved';
        u.Custodian_Type__c = 'Retail';
        u.For_Sale__c = 'Yes';
        u.Unit_Status__c = 'Vacant';
        u.Configuration__c = '1 BHK';
        u.Inventory_Type__c = 'Residential';
        u.Saleable_Area__c = 1000;
        u.Stamp_Duty__c = '5';
        u.GST__c = '5';
        u.Registration_Amount__c = 200;
        //u.Project_Name_For_Sharing__c = 'Test';
        insert u;
        
         
            Booking__c b = new Booking__c();
            b.Booking_Date__c = system.today();
            b.Tower__c = tw.id;
            b.Project__c = pr.Id;
            b.Opportunity__c = opp.id;
            b.Unit__c = u.id;
            b.Rate__c = 100;
            b.Agreement_Value__c = 100;
            insert b;
        
           Receipt__c rc = new Receipt__c();
           rc.Amount__c = 100;
           rc.Bank_Name__c = 'Central Bank of India';
           rc.Branch_Name__c = 'kalyan';
           rc.Booking__c = b.id;
           rc.Payment_Method__c = 'Cheque';
           rc.Source_of_Fund__c = 'Bank/Financial Institution (FI) Funded';
           rc.Preferred_Bank_FI__c = 'Test Bank';
           rc.Reference_Number__c = '100';
           insert rc;
            
          
        Test.startTest();
            PageReference pRef = Page.Ex_InventoryPage;
            ApexPages.currentPage().getParameters().put('oppId', opp.id);
           
          
           
            PageReference pRef1 = Page.Ex_BookingPage;
            ApexPages.currentPage().getParameters().put('oppId', opp.Id);
            ApexPages.currentPage().getParameters().put('uId', u.Id);
            ApexPages.currentPage().getParameters().put('rowIndex','1');
            ApexPages.currentPage().getParameters().put('rowIndex1','2');
            
            Ex_BookingPageController eb = new Ex_BookingPageController();
            eb.validateInput();
            eb.error = true;
            eb.addApp();
            eb.addRows();
            eb.errorMsg = 'test';
            eb.rmvApp();
            eb.rmvRows();
            eb.rowNum = 10;
            eb.rowNum1 = 20;
            eb.save();
        
          
         
           
            List<Applicant__c> ap = [Select Id, Name, Mobile_Number__c from Applicant__c ORDER BY CreatedDate DESC LIMIT 1];
        	if(!ap.isEmpty())
            {
               ap[0].Mobile_Number__c = '4477889922';
               
            	update ap[0];
            }
        
           
        
         Test.stopTest();
       

        
    }
}
//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 02-11-2022
//-------------------------------------------//
@isTest
public class TestEx_QuotationGeneration {
    @isTest
    public static void testQuotation() {
        Project__c pro = new Project__c();
        pro.Name = 'Test Project';
        insert pro;
        
        Sector__c sr = new Sector__c();
        sr.Name = 'Test Sector';
        sr.Project__c = pro.Id;
        insert sr;
        
        Tower__c twr = new Tower__c();
        twr.Name = 'TowerA';
        twr.Project__c = pro.Id;
        twr.Sector__c = sr.Id;
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
        un.Saleable_Area__c = 1000;
        un.RERA_Carpet_Area_Sq_Ft__c = 800;
        insert un;
        
        Pricing_List__c pl = new Pricing_List__c();
        pl.Unit__c = un.id;
        pl.Charge_Type__c = 'PSF';
        pl.Calculation_Area_Type__c = 'Saleable Area';
        pl.Charge_Rate__c = 1000;
        pl.GST__c = 5;
        pl.Charge_Bucket__c = 'Agreement Value';
        pl.Charge_Name__c = 'Basic Charge';
        insert pl;
        
        Pricing_List__c pl1 = new Pricing_List__c();
        pl1.Unit__c = un.id;
        pl1.Charge_Type__c = 'PSF';
        pl1.Calculation_Area_Type__c = 'Saleable Area';
        pl1.Charge_Rate__c = 84;
        pl1.GST__c = 18;
        pl1.Charge_Bucket__c = 'Other Charges';
        pl1.Charge_Name__c = 'MSEB Charge';
        insert pl1;
        
        Pricing_List__c pl2 = new Pricing_List__c();
        pl2.Unit__c = un.id;
        pl2.Charge_Type__c = 'Lumpsum';
        pl2.Charge_Amount__c = 50000;
        pl2.GST__c = 18;
        pl2.Charge_Bucket__c = 'Other Charges';
        pl2.Charge_Name__c = 'Development Charge';
        insert pl2;
        
        Pricing_List__c pl3 = new Pricing_List__c();
        pl3.Unit__c = un.id;
        pl3.Charge_Type__c = 'Percentage';
        //pl3.Calculation_Area_Type__c = 'Saleable Area';
        pl3.Charge_Percentage__c = 5;
        pl3.GST__c = 0;
        pl3.Charge_Bucket__c = 'Statutory Charges';
        pl3.Charge_Name__c = 'Stamp Duty';
        insert pl3;
        
        Pricing_List__c pl4 = new Pricing_List__c();
        pl4.Unit__c = un.id;
        pl4.Charge_Type__c = 'Lumpsum';
        //pl4.Calculation_Area_Type__c = 'Saleable Area';
        pl4.Charge_Amount__c = 1000;
        pl4.GST__c = 0;
        pl4.Charge_Bucket__c = 'Statutory Charges';
        pl4.Charge_Name__c = 'Registration';
        insert pl4;
        
        Construction_Stage__c cs1 = new Construction_Stage__c();
        cs1.Name = 'Slab 1';
        cs1.Stage_Description__c = 'Slab 1';
        cs1.Tower__c = twr.id;
        cs1.Milestone_Status__c = 'Completed';
        cs1.Actual_Completion_Date__c = system.today() - 10;
        cs1.Expected_Completion_Date__c = system.today();
        cs1.Sequence_Number__c = 1;
        insert cs1;
        
        Construction_Stage__c cs2 = new Construction_Stage__c();
        cs2.Name = 'Slab 2';
        cs2.Stage_Description__c = 'Slab 2';
        cs2.Tower__c = twr.id;
        cs2.Milestone_Status__c = 'Ongoing';
        cs2.Expected_Completion_Date__c = system.today().addDays(30);
        cs2.Sequence_Number__c = 2;
        insert cs2;
        
        Construction_Stage__c cs3 = new Construction_Stage__c();
        cs3.Name = 'Slab 3';
        cs3.Stage_Description__c = 'Slab 3';
        cs3.Tower__c = twr.id;
        cs3.Milestone_Status__c = 'Not Started';
        cs3.Expected_Completion_Date__c = system.today().addDays(60);
        cs3.Sequence_Number__c = 3;
        insert cs3;
        
        Payment_Scheme__c ps = new Payment_Scheme__c();
        ps.Name = 'Test Payment Plan';
        ps.Scheme_Code__c = '002';
        ps.Validity_Date__c = system.today().addDays(120);
        ps.Active__c = true;
        ps.Tower__c = twr.id;
        insert ps;
        
        Payment_Scheme_Milestone__c psm1 = new Payment_Scheme_Milestone__c();
        psm1.Payment_Scheme__c = ps.Id;
        psm1.Milestone_Name__c = 'Booking Amount';
        psm1.Sequence_No__c = 1;
        psm1.Milestone_Type__c = 'Date Linked';
        psm1.No_of_Days__c = 0;
        psm1.Token_Amount__c = 50000;
        psm1.Charge_Bucket_1__c = 'Agreement Value';
        psm1.Charge_Bucket_1_Type__c = 'Amount';
        psm1.Charge_Bucket_1_Amount__c = 50000;
        psm1.Charge_Bucket_2__c = 'Other Charges';
        psm1.Charge_Bucket_2_Type__c = 'Percentage';
        psm1.Charge_Bucket_2_Percentage__c = 0;
        psm1.Charge_Bucket_3__c = 'Statutory Charges';
        psm1.Charge_Bucket_3_Type__c = 'Percentage';
        psm1.Charge_Bucket_3_Percentage__c = 0;
        insert psm1;
        
		Payment_Scheme_Milestone__c psm2 = new Payment_Scheme_Milestone__c();
        psm2.Payment_Scheme__c = ps.Id;
        psm2.Milestone_Name__c = '30 Days After Booking';
        psm2.Sequence_No__c = 2;
        psm2.Milestone_Type__c = 'Date Linked';
        psm2.No_of_Days__c = 30;
        psm2.Deduct_Token__c = true;
        psm2.Charge_Bucket_1__c = 'Agreement Value';
        psm2.Charge_Bucket_1_Type__c = 'Percentage';
        psm2.Charge_Bucket_1_Amount__c = 10;
        psm2.Charge_Bucket_2__c = 'Other Charges';
        psm2.Charge_Bucket_2_Type__c = 'Percentage';
        psm2.Charge_Bucket_2_Percentage__c = 0;
        psm2.Charge_Bucket_3__c = 'Statutory Charges';
        psm2.Charge_Bucket_3_Type__c = 'Percentage';
        psm2.Charge_Bucket_3_Percentage__c = 0;
        insert psm2;
        
        Payment_Scheme_Milestone__c psm3 = new Payment_Scheme_Milestone__c();
        psm3.Payment_Scheme__c = ps.Id;
        psm3.Milestone_Name__c = 'On Completion Slab 1';
        psm3.Sequence_No__c = 3;
        psm3.Milestone_Type__c = 'Construction Linked';
        psm3.Construction_Stage__c = cs1.Id;
        psm3.No_of_Days__c = 0;
        psm3.Charge_Bucket_1__c = 'Agreement Value';
        psm3.Charge_Bucket_1_Type__c = 'Percentage';
        psm3.Charge_Bucket_1_Amount__c = 30;
        psm3.Charge_Bucket_2__c = 'Other Charges';
        psm3.Charge_Bucket_2_Type__c = 'Percentage';
        psm3.Charge_Bucket_2_Percentage__c = 0;
        psm3.Charge_Bucket_3__c = 'Statutory Charges';
        psm3.Charge_Bucket_3_Type__c = 'Percentage';
        psm3.Charge_Bucket_3_Percentage__c = 0;
        insert psm3;
        
        Payment_Scheme_Milestone__c psm4 = new Payment_Scheme_Milestone__c();
        psm4.Payment_Scheme__c = ps.Id;
        psm4.Milestone_Name__c = 'On Completion Slab 2';
        psm4.Sequence_No__c = 4;
        psm4.Milestone_Type__c = 'Construction Linked';
        psm4.Construction_Stage__c = cs2.Id;
        psm4.No_of_Days__c = 0;
        psm4.Charge_Bucket_1__c = 'Agreement Value';
        psm4.Charge_Bucket_1_Type__c = 'Percentage';
        psm4.Charge_Bucket_1_Amount__c = 30;
        psm4.Charge_Bucket_2__c = 'Other Charges';
        psm4.Charge_Bucket_2_Type__c = 'Percentage';
        psm4.Charge_Bucket_2_Percentage__c = 0;
        psm4.Charge_Bucket_3__c = 'Statutory Charges';
        psm4.Charge_Bucket_3_Type__c = 'Percentage';
        psm4.Charge_Bucket_3_Percentage__c = 0;
        insert psm4;
        
        Payment_Scheme_Milestone__c psm5 = new Payment_Scheme_Milestone__c();
        psm5.Payment_Scheme__c = ps.Id;
        psm5.Milestone_Name__c = 'On Completion Slab 3';
        psm5.Sequence_No__c = 5;
        psm5.Milestone_Type__c = 'Construction Linked';
        psm5.Construction_Stage__c = cs3.Id;
        psm5.No_of_Days__c = 0;
        psm5.Charge_Bucket_1__c = 'Agreement Value';
        psm5.Charge_Bucket_1_Type__c = 'Percentage';
        psm5.Charge_Bucket_1_Amount__c = 30;
        psm5.Charge_Bucket_2__c = 'Other Charges';
        psm5.Charge_Bucket_2_Type__c = 'Percentage';
        psm5.Charge_Bucket_2_Percentage__c = 0;
        psm5.Charge_Bucket_3__c = 'Statutory Charges';
        psm5.Charge_Bucket_3_Type__c = 'Percentage';
        psm5.Charge_Bucket_3_Percentage__c = 0;
        insert psm5;
        
        Discount__c d1 = new Discount__c();
        d1.Project__c = pro.Id;
        d1.Tower__c = twr.Id;
        d1.Grouping__c = 'Group 1';
        d1.Category__c = 'Approved';
        d1.Discount_Category__c = 'Discount';
        d1.Discount_Reason__c = 'Test PSF Discount 1';
        d1.Discount_Type__c = 'PSF';
        d1.PSF_Amount__c = 100;
        d1.Start_Date__c = system.today() - 10;
        insert d1;
        
        Discount__c d2 = new Discount__c();
        d2.Project__c = pro.Id;
        d2.Tower__c = twr.Id;
        d2.Grouping__c = 'Group 2';
        d2.Category__c = 'Approved';
        d2.Discount_Category__c = 'Discount';
        d2.Discount_Reason__c = 'Test Discount 2';
        d2.Discount_Type__c = 'Lumpsum';
        d2.Amount__c = 10000;
        d2.Start_Date__c = system.today() - 10;
        insert d2;
        
        Discount__c d3 = new Discount__c();
        d3.Project__c = pro.Id;
        d3.Tower__c = twr.Id;
        d3.Grouping__c = 'Group 3';
        d3.Category__c = 'Approved';
        d3.Discount_Category__c = 'Discount';
        d3.Discount_Reason__c = 'Test Discount 3';
        d3.Discount_Type__c = 'Percentage';
        d3.Percentage_of_AV__c = 1;
        d3.Start_Date__c = system.today() - 10;
        insert d3;
        
        Car_Park__c cp1 = new Car_Park__c();
        cp1.Project__c = pro.Id;
        cp1.Tower__c = twr.id;
        cp1.Type__c = 'Open Parking';
        cp1.Amount__c = 50000;
        cp1.Status__c = 'Available';
        insert cp1;
        
        Car_Park__c cp2 = new Car_Park__c();
        cp2.Project__c = pro.Id;
        cp2.Tower__c = twr.id;
        cp2.Type__c = 'Open Parking';
        cp2.Amount__c = 50000;
        cp2.Status__c = 'Available';
        insert cp2;
        
        Car_Park__c cp3 = new Car_Park__c();
        cp3.Project__c = pro.Id;
        cp3.Tower__c = twr.id;
        cp3.Type__c = 'Podium Parking';
        cp3.Amount__c = 50000;
        cp3.Status__c = 'Available';
        insert cp3;
        
        Car_Park__c cp4 = new Car_Park__c();
        cp4.Project__c = pro.Id;
        cp4.Tower__c = twr.id;
        cp4.Type__c = 'Podium Parking';
        cp4.Amount__c = 50000;
        cp4.Status__c = 'Available';
        insert cp4;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        acc.LastName = 'acc1';
        acc.Phone = '99854857584';
        acc.PersonMobilePhone = '9958455544';
        acc.Alternate_Email__c = 'acc1@gmail.com';
        acc.PersonEmail = 'acc11@gmail.com';
        insert acc;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Name = 'Test op';
        opp.AccountId__c = acc.Id;
        opp.StageName__c = 'Assigned';
        opp.CloseDate__c = system.today().addDays(1);
        opp.Project__c = pro.Id;
        opp.Sales_Next_Follow_up_Date__c = system.now();
        insert opp;
        
        Test.startTest();
        	PageReference pRef = Page.Ex_InventoryPage;
            ApexPages.currentPage().getParameters().put('oppId', opp.id);
            ApexPages.currentPage().getParameters().put('uId', un.id);
            
            Ex_QuotationGenerationController eq = new Ex_QuotationGenerationController();
        	eq.selectedScheme = ps.Id;
        	eq.schemeSelect();
        	
        	eq.carParkList[0].carParkRequiredCount = 1;
        	eq.addCarPark();
        
        	eq.discountList[0].Applied__c = true;
        	eq.discountList[1].Applied__c = true;
        	eq.discountList[2].Applied__c = true;
        	eq.applyDiscount();
        	eq.save();
        
        	Quotation__c q = [Select Id, Name from Quotation__c ORDER BY CreatedDate DESC LIMIT 1];
        	PageReference pRef1 = Page.Ex_PreviewCostSheet;
            ApexPages.currentPage().getParameters().put('qId', q.Id);
            Ex_PreviewCostSheetController qc = new Ex_PreviewCostSheetController();
        
        	eq.resetQuote();
        Test.stopTest();
    }
}
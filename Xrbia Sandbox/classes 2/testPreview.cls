@isTest
public class testPreview
{
    @isTest
    public static void testPreview1()
    {
        Test.StartTest();
        Id rctId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account a = new Account ();
        a.LastName = 'acc 2';
        a.Phone = '9822341223';
        a.PersonMobilePhone = '9922341223';
        a.Alternate_Email__c = 'acc12@gmail.com';
        a.PersonEmail = 'acc32@gmail.com';
        a.recordTypeId = rctId;
        insert a;
        
        project__c pr = createProject();
        tower__c tw = createTower();

        Opportunity__c opp = new Opportunity__c();
        opp.Name = 'Test op';
        opp.AccountId__c = a.Id;
        opp.StageName__c = 'Assigned';
        opp.CloseDate__c = system.today().addDays(1);
        opp.Project__c = pr.Id;
        opp.Sales_Next_Follow_up_Date__c = system.now();
        insert opp;
        
        Unit__c u = new Unit__c();
        //u.Name = 'Test Unit';
        u.Floor__c = 1;
        u.Flat_No__c = 101;
        u.View__c = 'Garden';
        u.Project__c = pr.Id;
        u.tower__c = tw.Id;
        u.For_Sale__c = 'yes';
        u.Unit_Status__c = 'Vacant';
        u.Saleable_Area__c = 1000;
        u.Total_Carpet_Area_Sq_Ft__c = 1300;
        
        insert u;
        
        Pricing_List__c pl = new Pricing_List__c();
        pl.Unit__c = u.id;
        pl.Charge_Name__c = 'Basic Charge';
        pl.Charge_Type__c = 'PSF';
        pl.Calculation_Area_Type__c = 'Carpet Area';
        pl.Charge_Rate__c = 1000;
        pl.GST__c = 5;
        pl.Charge_Bucket__c = 'Agreement Value';
        //pl.Charge_Description__c = 'basic charge 12';
       // pl.Editable_at_cost_sheet__c = true;
        //pl.Project_Name_For_Sharing__c = 'test';
        insert pl;
        
        Pricing_List__c pl1 = new Pricing_List__c();
        pl1.Unit__c = u.id;
        pl1.Charge_Name__c = 'Basic Charge';
        pl1.Charge_Type__c = 'PSF';
        pl1.Calculation_Area_Type__c = 'Saleable Area';
        pl1.Charge_Rate__c = 1000;
        pl1.GST__c = 5;
        pl1.Charge_Bucket__c = 'Agreement Value';
        //pl1.Charge_Description__c = 'basic charge 12'; 
        //pl1.Editable_at_cost_sheet__c = true;
        //pl1.Project_Name_For_Sharing__c = 'test';
        insert pl1;
        
        Construction_Stage__c cs = new Construction_Stage__c();
        cs.Stage_Description__c = 'Slab 3';
        cs.Tower__c = tw.id;
        cs.Expected_Completion_Date__c = system.today();
        //cs.Project_Name_For_Sharing__c = 'test';
        insert cs;
        
        Payment_Scheme__c ps = new Payment_Scheme__c();
        ps.Name = 'Payment Plan 2';
        ps.Scheme_Code__c = '002';
        ps.Validity_Date__c = system.today();
        ps.Active__c = true;
        ps.Tower__c = tw.id;
        //ps.Project_Name_For_Sharing__c = 'test';
        insert ps;
        
        Payment_Scheme_Milestone__c psm = new Payment_Scheme_Milestone__c();
        psm.Milestone_Name__c = 'Booking Amount';
        psm.Sequence_No__c = 1;
        psm.Milestone_Type__c = 'Date Linked';
        psm.Payment_Scheme__c = ps.Id;
        psm.No_of_Days__c = 0;
        psm.Charge_Bucket_1_Type__c = 'Percentage';
        psm.Charge_Bucket_1_Percentage__c = 10;
        psm.Charge_Bucket_1__c = 'Agreement Value';
        //psm.Project_Name_For_Sharing__c = 'test';
        insert psm;
        
        Payment_Scheme_Milestone__c psm1 = new Payment_Scheme_Milestone__c();
        psm1.Milestone_Name__c = 'OC Payment';
        psm1.Sequence_No__c = 2;
        psm1.Milestone_Type__c = 'Construction Linked';
        psm1.Payment_Scheme__c = ps.Id;
        psm1.No_of_Days__c = 0;
        psm1.Construction_Stage__c = cs.id;
        psm1.Charge_Bucket_1_Type__c = 'Percentage';
        psm1.Charge_Bucket_1_Percentage__c = 90;
        psm1.Charge_Bucket_1__c = 'Agreement Value';
        psm1.Charge_Bucket_2_Type__c = 'Percentage';
        psm1.Charge_Bucket_2_Percentage__c = 100;
        psm1.Charge_Bucket_2__c = 'Other Charges';
        //psm1.Project_Name_For_Sharing__c = 'test';
        insert psm1;
        
       
        Discount__c d = new Discount__c();
        d.Project__c = pr.id;
        //d.Reason__c = 'EOI Offer 1 BHK Ultima';
        d.Start_Date__c = system.today();
        d.End_Date__c = system.today().addDays(1);
        d.Discount_Type__c = 'Lumpsum';
        d.Amount__c = 10000;
       // d.Project_Name_For_Sharing__c = 'test';
        insert d;
        
        Car_Park__c cp = new Car_Park__c();
        cp.Type__c = 'Podium Parking';
        cp.Status__c = 'Available';
        cp.Amount__c = 500000.00;
        
        cp.Project__c = pr.Id;
        cp.tower__c = tw.id;
        //cp.Project_Name_For_Sharing__c = 'test';
        insert cp;
        Quotation__c q = new Quotation__c();
        q.Unit__c = u.id;
        q.Opportunity__c = opp.id;
        q.Quotation_Status__c = 'Approved';
        
        q.Charge_Bucket_1__c = 'Agreement Value';
        q.Charge_Bucket_1_Amount__c = 1700000;
        q.Charge_Bucket_1_Total_Tax__c = 7000;
        q.Charge_Bucket_1_CGST__c = 3500;
        q.Charge_Bucket_1_SGST__c = 3500;
        
        q.Charge_Bucket_2__c = 'Other Charges';
        q.Charge_Bucket_2_Amount__c = 20000;
        q.Charge_Bucket_2_Total_Tax__c = 500;
        q.Charge_Bucket_2_CGST__c = 250;
        q.Charge_Bucket_2_SGST__c = 250;
        
        q.Charge_Bucket_3__c = 'Statutory Charges';
        q.Charge_Bucket_3_Amount__c = 3000;
        q.Charge_Bucket_3_Total_Tax__c = 0;
        q.Charge_Bucket_3_CGST__c = 0;
        q.Charge_Bucket_3_SGST__c = 0;
        
       	//q.Level_1__c = UserInfo.getUserId();
        //q.Level_2__c = UserInfo.getUserId();
        //q.Level_3__c = UserInfo.getUserId();
        //q.Total_Discount_Applied__c  = 100000;
        
        insert q;
        
        
        Payment_Milestone__c  pm = new Payment_Milestone__c ();
        pm.Construction_Stage_Description__c = 'Booking Amount';
        pm.Milestone_Type__c = 'Date Linked';
        pm.Due_Date__c = System.today().addDays(-1);
        pm.Quotation__c = q.Id;
        pm.No_of_Days__c = 0;
        pm.Sequence_No__c = 1;
        pm.Demand_Raised_Date__c = System.today();
        pm.Is_Raised__c = false;
        pm.Charge_Bucket_1_Percentage__c = 10;
        pm.Charge_Bucket_1_Amount__c = 564200.00;
        pm.Charge_Bucket_1__c = 'Agreement Value';
        pm.Charge_Bucket_1_CGST__c = 14105.00;
        pm.Charge_Bucket_1_SGST__c = 14105.00;
        pm.Charge_Bucket_1_Total_Tax__c = 28210.00;

        insert pm;
        
        Discount_Applied__c da = new Discount_Applied__c();
        da.Category__c	 = 'Approved';
        da.Discount_Category__c = 'Cashback';
        da.Discount_Reason__c = 'Holi offer teat';
        da.Discount_Type__c = 'Lumpsum';
        da.Amount__c = 50000;
        da.Quotation__c = q.id;
        da.Total__c = 50000;
        insert da;
        
        Discount_Applied__c da1 = new Discount_Applied__c();
        da1.Category__c	 = 'Approved';
        da1.Discount_Category__c = 'Credit Note';
        da1.Discount_Reason__c = 'Diwali offer teat';
        da1.Discount_Type__c = 'Lumpsum';
        da1.Total__c = 50000;
        da1.Quotation__c = q.id;
        insert da1;
        
        Charge_Detail__c cd12 = new Charge_Detail__c();
        cd12.Unit__c = u.id;
        cd12.Name = 'Basic';
        cd12.Charge_Type__c = 'PSF';
        cd12.Charge_Rate__c = 1000;
        
        cd12.Charge_Bucket__c = 'Agreement Value';
        cd12.Quotation__c = q.id;
        insert cd12;
        
        Charge_Detail__c cd13 = new Charge_Detail__c();
        cd13.Unit__c = u.id;
        cd13.Name = 'Basic';
        cd13.Charge_Type__c = 'PSF';
        cd13.Charge_Rate__c = 1000;
        cd13.Charge_Bucket__c = 'Agreement Value';
        cd13.Quotation__c = q.id;
        insert cd13;
        
        Charge_Detail__c cd14 = new Charge_Detail__c();
        cd14.Unit__c = u.id;
        cd14.Name = 'Basic';
        cd14.Charge_Type__c = 'PSF';
        cd14.Charge_Rate__c = 1000;
        cd14.Charge_Bucket__c = 'Agreement Value';
        cd14.Quotation__c = q.id;
        insert cd14;
        
        ApexPages.currentPage().getParameters().put('qId', q.id);
        
        Ex_PreviewCostSheetController eq = new Ex_PreviewCostSheetController();
        
        Test.StopTest();
        
    }
    
    public static project__c createProject()
    {
        Project__c pr = new Project__c();
        pr.Name = 'test project';
        //pr.Level_1__c = UserInfo.getUserId();
        //pr.Level_2__c = UserInfo.getUserId();
        //pr.Level_3__c = UserInfo.getUserId();
        //pr.Discount_Threshold__c = 10000;
        //pr.Project_Name_For_Sharing__c = 'test';
        insert pr;
        return pr;
    }
    
    public static Tower__c createTower()
    {
        Tower__c tw = new Tower__c();
        tw.Name = 'test Tower';
        tw.Project__c = createProject().Id;
        //tw.Project_Name_For_Sharing__c = 'Test';
        insert tw;
        return tw;
    }
}
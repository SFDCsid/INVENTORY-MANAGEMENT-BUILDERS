@isTest
public class Test_salesreport1data {
    @isTest
    public static void testsales1(){
         
        Test.startTest();
        
        Project__c p = new Project__c();
        p.Name = 'All';
        insert p;
        
        Project__c p1 = new Project__c();
        p1.Name = 'test project1';
        insert p1;
        
        Project__c p2 = new Project__c();
        p1.Name = 'test project2';
        insert p2;
        
        Project__c p3 = new Project__c();
        p3.Name = 'test project3';
        insert p3;
        
        Project__c p4 = new Project__c();
        p4.Name = 'test project4';
        insert p4;
        
        Project__c p5 = new Project__c();
        p5.Name = 'test project5';
        insert p5;
        
        
        Project__c p6 = new Project__c();
        p6.Name = 'test project6';
        insert p6;
        
        Tower__c t = new Tower__c();
        t.Name = 'Test Tower A';
        t.Project__c = p1.id;
        insert t;
        
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
        
        Opportunity__c opp = new Opportunity__c();
        opp.OwnerId = UserInfo.getUserId();
        opp.Name = 'Test op';
        opp.AccountId__c = a.Id;
        opp.StageName__c = 'Unqualified';
        //opp.CloseDate__c = system.today().addDays(1);
        opp.Project__c = p.Id;
       // opp.Sales_Next_Follow_up_Date__c = system.now();
        insert opp;
        
        Opportunity__c opp1 = new Opportunity__c();
        opp1.OwnerId = UserInfo.getUserId();
        opp1.Name = 'Test op22';
        opp1.AccountId__c = a.Id;
        opp1.StageName__c = 'Under Conversion';
        opp1.Project__c = p1.Id;
        insert opp1;
        
        Opportunity__c opp2 = new Opportunity__c();
        opp2.OwnerId = UserInfo.getUserId();
        opp2.Name = 'Test op2';
        opp2.AccountId__c = a.Id;
        opp2.StageName__c = 'Booking Confirmed';
        opp2.Amount__c = 5000;
        //opp.CloseDate__c = system.today().addDays(1);
        opp2.Project__c = p2.Id;
       // opp.Sales_Next_Follow_up_Date__c = system.now();
        insert opp2;
        
        Opportunity__c opp3 = new Opportunity__c();
        opp3.OwnerId = UserInfo.getUserId();
        opp3.Name = 'Test op2';
        opp3.AccountId__c = a.Id;
        opp3.StageName__c = 'Booking Confirmed';
        opp3.Amount__c = 3000;
        //opp.CloseDate__c = system.today().addDays(1);
        opp3.Project__c = p3.Id;
       // opp.Sales_Next_Follow_up_Date__c = system.now();
        insert opp3;
        
        Opportunity__c opp4 = new Opportunity__c();
        opp4.OwnerId = UserInfo.getUserId();
        opp4.Name = 'Test op2';
        opp4.AccountId__c = a.Id;
        opp4.StageName__c = 'Booking Cancelled';
        opp4.Amount__c = 3000;
        //opp.CloseDate__c = system.today().addDays(1);
        opp4.Project__c = p4.Id;
       // opp.Sales_Next_Follow_up_Date__c = system.now();
        insert opp4;
        
        Unit__c u = new Unit__c();
        //u.Name = 'Test Unit';
        u.Floor__c = 1;
        u.Flat_No__c = 101;
        u.View__c = 'Garden';
        u.Project__c = p1.Id;
        u.tower__c = t.Id;
        u.For_Sale__c = 'Yes';
        u.Unit_Status__c = 'Vacant';
        u.Saleable_Area__c = 1000;
        u.Total_Carpet_Area_Sq_Ft__c = 1300;
        //u.Project_Name_For_Sharing__c = 'Test';
         
        insert u;
        
        Pricing_List__c pl1 = new Pricing_List__c();
        pl1.Unit__c = u.id;
        pl1.Charge_Name__c = 'Basic Charge';
        pl1.Charge_Type__c = 'PSF';
        pl1.Calculation_Area_Type__c = 'Saleable Area';
        pl1.Charge_Rate__c = 1000;
        pl1.GST__c = 5;
        pl1.Charge_Bucket__c = 'Agreement Value';
        insert pl1;
        
        Construction_Stage__c cs = new Construction_Stage__c();
        cs.Stage_Description__c = 'Slab 3';
        cs.Tower__c = t.id;
        cs.Expected_Completion_Date__c = system.today();
        
        Payment_Scheme__c ps = new Payment_Scheme__c();
        ps.Name = 'Payment Plan 2';
        ps.Scheme_Code__c = '002';
        ps.Validity_Date__c = system.today();
        ps.Active__c = true;
        ps.Tower__c = t.id;        
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
        insert psm;

         Discount__c d = new Discount__c();
    	 d.Project__c = p1.id;
        d.Start_Date__c = system.today();
        d.End_Date__c = system.today().addDays(1);
        d.Discount_Type__c = 'Lumpsum';
        d.Amount__c = 10000;
        
        insert d;
         Quotation__c q = new Quotation__c();
        q.Unit__c = u.id;
        q.Opportunity__c = opp.id;
        q.Charge_Bucket_1__c = 'Agreement Value';
        q.Charge_Bucket_1_Amount__c = 1700000;
        q.Charge_Bucket_1_Total_Tax__c = 7000;
        q.Charge_Bucket_1_CGST__c = 3500;
        q.Charge_Bucket_1_SGST__c = 3500;
        q.Quotation_Status__c = 'Approved';
        
        q.Charge_Bucket_2__c = 'Other Charges';
        q.Charge_Bucket_2_Amount__c = 20000;
        q.Charge_Bucket_2_Total_Tax__c = 500;
        q.Charge_Bucket_2_CGST__c = 250;
        q.Charge_Bucket_2_SGST__c = 250;
        
        q.Charge_Bucket_3__c = 'Statutory Charges';
        q.Charge_Bucket_3_Amount__c = 30000;
        q.Charge_Bucket_3_Total_Tax__c = 0;
        q.Charge_Bucket_3_CGST__c = 0;
        q.Charge_Bucket_3_SGST__c = 0;
        
        insert q;
        
        Car_Park_Required__c cpr = new Car_Park_Required__c();
        cpr.Car_Park_Type__c = 'Podium Parking';
        cpr.Car_Park_Amount__c = 500000.00;
        cpr.Quotation__c = q.id;
        
        insert cpr;
        
        
        Booking__c b = new Booking__c();
        b.Booking_Date__c = system.today();
        b.Mode_Of_Funding__c = 'Self Funding';
        b.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN';
        b.Tower__c = t.id;
        b.Project__c = p1.Id;
        b.Quotation__c = q.id;
        b.Unit__c = u.id;
        insert b;
        
        Opportunity__c opp5 = new Opportunity__c();
        opp5.OwnerId = UserInfo.getUserId();
        opp5.Name = 'Test op2';
        opp5.AccountId__c = a.Id;
        opp5.StageName__c = 'Booking in-process';
        opp5.Amount__c = 3000;
        opp5.Project__c = p5.Id;
        opp5.Booking__c = b.id;
        insert opp5;
        
       

        Booking__c b3 = new Booking__c();
        b3.Booking_Date__c = system.today();
        b3.Mode_Of_Funding__c = 'Self Funding';
        b3.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN';
        b3.Tower__c = t.id;
        b3.Project__c = p5.Id;
        b3.Quotation__c = q.id;
       // b3.Opportunity__c = opp6.id;
        b3.Unit__c = u.id;
        insert b3;
        
        Opportunity__c opp6 = new Opportunity__c();
        opp6.OwnerId = UserInfo.getUserId();
        opp6.Name = 'Test op2';
        opp6.AccountId__c = a.Id;
        opp6.StageName__c = 'Booking in-process';
        opp6.Amount__c = 3000;
        opp6.Project__c = p6.Id;
        opp6.Booking__c = b3.id;
        insert opp6;

        
        Booking__c b1 = new Booking__c();
        b1.Booking_Date__c = system.today();
        b1.Mode_Of_Funding__c = 'Self Funding';
        b1.PAYMENT_OPTIONS__c ='SELF FUNDING – CLP';
        b1.Tower__c = t.id;
        b1.Project__c = p1.Id;
        b1.Quotation__c = q.id;
        b1.Opportunity__c = opp6.id;
        b1.Unit__c = u.id;
        insert b1;
        
        Booking__c b4 = new Booking__c();
        b4.Booking_Date__c = system.today();
        b4.Booking_Date__c = system.today();
        b4.Mode_Of_Funding__c = 'Self Funding';
        b4.PAYMENT_OPTIONS__c ='SELF FUNDING – CLP';
        b4.Tower__c = t.id;
        b4.Project__c = p1.Id;
        b4.Quotation__c = q.id;
        b4.Opportunity__c = opp5.id;
        b4.Unit__c = u.id;
        insert b4;
        
        SalesReport1Data sv = new SalesReport1Data();
        SalesReport1Data.getProject();
        SalesReport1Data.reportDataWrapperClass rr = new SalesReport1Data.reportDataWrapperClass();
        
         decimal l ;
        decimal e ;
        decimal f ;
        decimal g  = 10;
        decimal h ;
        decimal i ;
        decimal j ;
        decimal z ;
        
        l = rr.bankBookings;
        e = rr.BookingOpportunity;
        f = rr.selfFundingBooking;
        g = rr.totalAgrValue;
        h = rr.totalCancel;
        i = rr.totalNetBooking;
        j = rr.totalOpportunities;
        z = rr.UnqualifiedOpportunities;
        
        SalesReport1Data.Wrapper('All', system.today().addDays(+0), system.today().addDays(+0));
        SalesReport1Data.Wrapper(p.id, system.today().addDays(+0), system.today().addDays(+0));
        SalesReport1Data.Wrapper('test project1', system.today().addDays(+0), system.today().addDays(+0));
        
                
        Test.stopTest();
    }
   

}
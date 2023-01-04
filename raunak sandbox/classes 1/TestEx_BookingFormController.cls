@isTest
public class TestEx_BookingFormController
{
    @isTest
    public static void TestEx_BookingFormController1()
    {
        Test.StartTest();
        Id rctId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account a = new Account ();
        a.LastName = 'acc 2';
        a.Phone = '9822341223';
        a.PersonMobilePhone = '9922341223';
        a.Alternate_Email_Id__c = 'acc12@gmail.com';
        a.PersonEmail = 'acc32@gmail.com';
        a.recordTypeId = rctId;
        //a.Project_Name_For_Sharing__c = 'test';
        insert a;
        
        project__c pr = createProject();
        //pr.Booking_Approver__c = userinfo.getUserId();
        //pr.Registration_Approver_1__c = userinfo.getUserId();
        //pr.Registration_Approver_2__c = userinfo.getUserId();
        //update pr;
        
        tower__c tw = createTower();
        
        Opportunity_c__c opp = new Opportunity_c__c();
        opp.Last_Name__c = 'Test Opp';
        opp.Account_Name__c = a.id;
        opp.Opportunity_Stage__c = 'In Follow-up';
        //opp.CloseDate__c = system.today().addDays(1);
        opp.Project__c = pr.Id;
        opp.Next_Follow_up_Date__c = system.now();
        
        
        Unit__c u = new Unit__c();
        //u.Name = 'Test Unit';
        u.Floor__c = 1;
        //u.Flat_No__c = 101;
        u.View__c = 'Garden';
        u.Project__c = pr.Id;
        u.tower__c = tw.Id;
        u.For_Sale__c = 'Yes';
        u.Unit_Status__c = 'Vacant';
        u.Saleable_Area__c = 1000;
        u.Total_Carpet_Area_Sq_Ft__c = 1300;
        //u.Project_Name_For_Sharing__c = 'Test';
        
        insert u;
        
        Pricing_List__c pl = new Pricing_List__c();
        pl.Unit__c = u.id;
        pl.Charge_Name__c = 'Basic Charge';
        pl.Charge_Type__c = 'PSF';
        pl.Calculation_Area_Type__c = 'Carpet Area';
        pl.Charge_Rate__c = 1000;
        pl.GST__c = 5;
        pl.Charge_Bucket__c = 'Agreement Value';
        //pl.Charge_Description__c = 'Agreement Value 12*24';
        //pl.Editable_at_cost_sheet__c = true;
        //pl.Project_Name_For_Sharing__c = 'Test';
        insert pl; 
        
        Pricing_List__c pl1 = new Pricing_List__c();
        pl1.Unit__c = u.id;
        pl1.Charge_Name__c = 'Basic Charge';
        pl1.Charge_Type__c = 'PSF';
        pl1.Calculation_Area_Type__c = 'Saleable Area';
        pl1.Charge_Rate__c = 1000;
        pl1.GST__c = 5;
        pl1.Charge_Bucket__c = 'Agreement Value';
        //pl1.Charge_Description__c = 'Agreement Value 12*24';
        //pl1.Editable_at_cost_sheet__c = true;
        //pl1.Project_Name_For_Sharing__c = 'Test';
        insert pl1;
        
        Construction_Stage__c cs = new Construction_Stage__c();
        cs.Stage_Description__c = 'Slab 3';
        cs.Tower__c = tw.id;
        cs.Expected_Completion_Date__c = system.today();
        //cs.Project_Name_For_Sharing__c = pr.id;
        
        insert cs;
        
        Payment_Scheme__c ps = new Payment_Scheme__c();
        ps.Name = 'Payment Plan 2';
        ps.Scheme_Code__c = '002';
        ps.Validity_Date__c = system.today();
        ps.Active__c = true;
        ps.Tower__c = tw.id;
        // ps.Project_Name_For_Sharing__c  = 'Test';
        
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
        
        // psm.Project_Name_For_Sharing__c = 'Test';
        
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
        //psm1.Project_Name_For_Sharing__c = 'test ghk1';
        psm1.Charge_Bucket_2_Type__c = 'Percentage';
        psm1.Charge_Bucket_2_Percentage__c = 100;
        psm1.Charge_Bucket_2__c = 'Other Charges';
        //psm1.Project_Name_For_Sharing__c = 'Test';
        
        insert psm1;
        
        Discount__c d = new Discount__c();
        d.Project__c = pr.id;
        //d.Discount_Reason__c = 'EOI Offer 1 BHK Ultima';
        d.Start_Date__c = system.today();
        d.End_Date__c = system.today().addDays(1);
        d.Discount_Type__c = 'Lumpsum';
        //d.Project_Name_For_Sharing__c = pr.id;
        d.Amount__c = 10000;
        
        insert d;
        
        
        /*
Business_Account__c ba = new Business_Account__c ();
ba.Account_Number__c = '123456789';
ba.Account_Name__c = 'Axis Bank Ltd';
ba.Bank_Name__c = 'Axis Bank Ltd';
ba.PAN_Number__c = 'DEAMP7888f';
ba.IFSC_Code__c = 'UNIMI00078';
//ba.Project_Name_For_Sharing__c = 'Test';
insert ba;*/
        
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
        
        
        Payment_Milestone__c pm = new Payment_Milestone__c ();
        pm.Quotation__c = q.id;
        pm.Charge_Bucket_1__c = 'Agreement Value';
        pm.Charge_Bucket_1_Amount__c = 1700000;
        pm.Charge_Bucket_1_CGST__c =  3500;
        pm.Charge_Bucket_1_SGST__c =  3500;
        pm.Charge_Bucket_1_Total_Tax__c =  7000;
        pm.Charge_Bucket_1_Percentage__c = 10.0;
        
        
        pm.Charge_Bucket_2__c = 'Other Charges';
        pm.Charge_Bucket_2_Amount__c = 20000;
        pm.Charge_Bucket_2_Total_Tax__c = 500;
        pm.Charge_Bucket_2_CGST__c = 250;
        pm.Charge_Bucket_2_SGST__c = 250;
        pm.Charge_Bucket_2_Percentage__c = 20.0;
        
        pm.Charge_Bucket_3__c = 'Statutory Charges';
        pm.Charge_Bucket_3_Amount__c = 30000;
        pm.Charge_Bucket_3_Total_Tax__c = 0;
        pm.Charge_Bucket_3_CGST__c = 0;
        pm.Charge_Bucket_3_SGST__c = 0;
        pm.Charge_Bucket_3_Percentage__c = 30.0;
        
        insert pm;
        
        
        
        
        
        
        
        Car_Park_Required__c cpr = new Car_Park_Required__c();
        cpr.Car_Park_Type__c = 'Podium Parking';
        cpr.Car_Park_Amount__c = 500000.00;
        cpr.Quotation__c = q.id;
        
        insert cpr;
        
        Booking__c b = new Booking__c();
        b.Booking_Date__c = system.today();
        b.Mode_Of_Funding__c = 'Self Funding';
        b.Tower__c = tw.id;
        //b.Booking_Approver__c = userInfo.getUserId();
        //b.Master_Source__c = opp.Master_Source__c;
        b.Project__c = pr.Id;
        b.Quotation__c = q.id;
        b.Opportunity__c = opp.id;
        b.Unit__c = u.id;
        b.tower__c = tw.id;
        //b.Primary_Mobile_Number__c = '9898671234';
        insert b;
        
        
        Charge_Detail__c cd = new Charge_Detail__c ();
        cd.Quotation__c = q.id;
        cd.Charge_Bucket__c = 'Test';
        cd.Charge_CGST__c = 100;
        cd.Charge_Rate__c = 155;
        cd.Charge_SGST__c = 145;
        cd.Charge_Total_Tax__c = 10;
        cd.Charge_Amount__c = 100;
        
        insert cd;
        
        Car_Park__c cp = new Car_Park__c();
        cp.Type__c = 'Podium Parking';
        cp.Status__c = 'Available';
        cp.Amount__c = 500000.00;
        //cp.RR_Amount__c = 400000;
        //cp.Project_Name_For_Sharing__c = 'Test';
        cp.Project__c = pr.Id;
        cp.tower__c = tw.id;
        insert cp;
        
        Car_Park__c cp1 = new Car_Park__c();
        cp1.Type__c = 'Podium Parking';
        cp1.Status__c = 'Available';
        cp1.Amount__c = 500000.00;
        //cp1.RR_Amount__c = 400000;
        //cp1.Project_Name_For_Sharing__c = 'Test';
        cp1.Project__c = pr.Id;
        cp1.tower__c = tw.id;
        insert cp1;
        
        Car_Park__c cp2 = new Car_Park__c();
        cp.Type__c = 'Podium Parking';
        cp2.Status__c = 'Available';
        cp2.Amount__c = 500000.00;
        //cp2.RR_Amount__c = 400000;
        //cp1.Project_Name_For_Sharing__c = 'Test';
        cp2.Project__c = pr.Id;
        //cp2.Booking__c = b.Id;
        cp2.tower__c = tw.id;
        insert cp2;
        
        q.Booking__c = b.id;
        update q;
        
        ApexPages.currentPage().getParameters().put('bid', b.id);
            ApexPages.currentPage().getParameters().put('qId', q.id);
        ApexPages.currentPage().getParameters().put('rowIndex1','1');
        ApexPages.currentPage().getParameters().put('rowIndex','1');
        Ex_BookingFormController bc = new Ex_BookingFormController();
        
        
        
        system.debug('booking id: '+ b.id);
        
        Applicant__c  ap = new Applicant__c();
        ap.Name = 'rj';
        ap.Booking__c = b.id;
        ap.Email__c = 'sk123@gmail.com';
        ap.Country__c = 'India';
        ap.PAN_Number__c = 'FDLPK1234S';
        ap.Applicant_Number__c = 'Primary Applicant';
        
        insert ap ;
        
        /*Loan_Cases__c lc = new Loan_Cases__c();
lc.Loan_Case_Stage__c = 'Documents Submitted';
lc.CIBIL_Score__c = 389;
lc.Booking_Date__c = system.today();
lc.Booking__c = b.id;
lc.Mobile__c = b.Primary_Mobile_Number__c;
insert lc;

Registration__c  rn = new   Registration__c(); //rj added
rn.Project__c = b.Project__c;
rn.Booking__c = b.Id;
rn.Registration_Stage__c  ='Registration Done';
rn.Booking__c  = b.id;
rn.Registration_Approver_1__c =  UserInfo.getUserId();  // pr.Registration_Approver_1__c;
rn.Registration_date__c = system.today();

insert rn;*/
        
        
        Receipt__c r1 = new Receipt__c();
        r1.Amount__c  = 10000;
        r1.Booking__c= b.Id;
        r1.Payment_Mode__c = 'Cheque';
        r1.Favouring__c = '';
        r1.Receipt_Type__c = 'Flat Cost';
        r1.Payment_Type__c = 'OCR'; 
        r1.Transaction_Status__c = 'Successful';
        r1.Amount__c  = 10000;
        
        insert r1;
        
        /* masterRecordController.returnApplicantDetails(bc.b.id);
masterRecordController.returnBookingDetails(bc.b.id);
masterRecordController.returnOpportunityDetails(bc.b.id);
masterRecordController.returnQuotationDetails(bc.b.id);
masterRecordController.returnReceiptDetails(bc.b.id);
masterRecordController.returnUnitDetails(bc.b.id);
masterRecordController.returnBLDetails(q.Id); */
        Test.StopTest();
    }
    
    public static project__c createProject()
    {
        Project__c pr = new Project__c();
        pr.Name = 'test project';
        //pr.Project_Name_For_Sharing__c = 'gtest jk';
        insert pr;
        return pr;
    }
    
    public static Tower__c createTower()
    {
        Tower__c tw = new Tower__c();
        tw.Name = 'test Tower';
        //tw.Project_Name_For_Sharing__c = 'test prg56';
        
        tw.Project__c = createProject().Id;
        /*Business_Account__c ba = new Business_Account__c ();
//Tower__c tw = createTower();
//Project__c pr = createProject();
//ba.tower__c = tw.id;
//ba.project__c = pr.id;
ba.Account_Number__c = '123456789';
ba.Account_Name__c = 'Axis Bank Ltd';
ba.Bank_Name__c = 'Axis Bank Ltd';
ba.PAN_Number__c = 'DEAMP7888f';
ba.IFSC_Code__c = 'UNIMI00078';

// ba.Project_Name_For_Sharing__c = 'test yprooj';
//ba.Booking_Approver__c = UserInfo.getUserId();

insert ba;*/
        /*
tw.Business_Account__c = ba.Id;
tw.Registration_Manager__c =UserInfo.getUserId();
system.debug(tw.Registration_Manager__c);
tw.Loan_Manager__c  = UserInfo.getUserId();
tw.Welcome_Call_Manager__c= UserInfo.getUserId();
tw.CRM_Manager__c = UserInfo.getUserId();

insert tw;*/
        return tw;
    }
}
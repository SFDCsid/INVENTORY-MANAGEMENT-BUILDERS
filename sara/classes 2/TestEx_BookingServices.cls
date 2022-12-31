@isTest
public class TestEx_BookingServices {
    @isTest
    public static void testBookingController() {
        Project__c pro = new Project__c();
        pro.Name = 'Test Project';
        pro.Address__c = 'Mumbai';
        insert pro;
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        User u = new User(
            Username = uniqueName + '@test' + orgId + '.org',
            Email = uniqueName + '@test' + orgId + '.org',
            LastName = 'LastName',
            FirstName = 'FirstName',
            Alias = uniqueName.substring(18, 23),
            ProfileId = UserInfo.getProfileId(),
            EmailEncodingKey='UTF-8',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Los_Angeles',
            Country = 'US',
            Title = 'Territory Manager'
        );
        insert u;
        
        Team__c t = new Team__c();
        t.Name = 'Project Sales Team';
        //t.Project__c = pro.Id;
        t.Team_Type__c = 'Cancellation Team';
        insert t;
        
        Team_Members__c tm = new Team_Members__c();
        tm.Team__c = t.Id;
        tm.Availability__c = true;
        tm.User__c = u.Id;
        insert tm;
        
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
        un.Name = '1BHK501';
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
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test op';
        opp.AccountId = acc.Id;
        opp.StageName = 'Qualification';
        opp.CloseDate = system.today().addDays(1);
        opp.Project__c = pro.Id;
        opp.Master_Source__c = 'Other';
        opp.Lead_Source__c = 'Other';
        opp.Other_Source_Details__c = 'Test Source';
        insert opp;
        
        Test.startTest();
            PageReference pRef = Page.Ex_InventoryPage;
            ApexPages.currentPage().getParameters().put('oppId', opp.id);
            ApexPages.currentPage().getParameters().put('uId', un.id);
            
            Ex_QuotationGeneration eq = new Ex_QuotationGeneration();
            eq.selectedScheme = ps.Id;
            eq.schemeSelect();
            eq.carParkList[0].carParkRequiredCount = 1;
            eq.addCarPark();
            eq.save();
        
            Quotation__c q = [Select Id from Quotation__c ORDER BY CreatedDate DESC LIMIT 1];
            system.debug('q: '+q);
        
            PageReference pRef1 = Page.Ex_BookingPage;
            ApexPages.currentPage().getParameters().put('qId', q.Id);
            
            Ex_BookingPageController eb = new Ex_BookingPageController();
            eb.validateInput();
            eb.addApplicant();
            ApexPages.currentPage().getParameters().put('rowIndex', '2');
            eb.removeApplicant();
            eb.applicantWrapperList[0].ap.Applicant_Title__c = 'Mr';
            eb.applicantWrapperList[0].ap.Name = 'Test Customer';
            eb.applicantWrapperList[0].ap.Applicant_Number__c = 'Primary Applicant';
            eb.applicantWrapperList[0].ap.Country__c = 'India';
            eb.applicantWrapperList[0].ap.State__c = 'Maharashtra';
            eb.applicantWrapperList[0].ap.City__c = 'Pune';
            eb.applicantWrapperList[0].ap.Pin_Code__c = '411015';
            eb.applicantWrapperList[0].ap.Aadhar_Number__c = '121212121212';
            eb.applicantWrapperList[0].ap.PAN_Number__c = 'ASDFR1456V';
            eb.applicantWrapperList[0].ap.Mobile_Number__c = '2233558899';
            eb.applicantWrapperList[0].applicantDOB = system.today() - 99999;
            eb.save();
        
            Applicant__c ap = [Select Id, Name, Mobile_Number__c from Applicant__c ORDER BY CreatedDate DESC LIMIT 1];
            ap.Mobile_Number__c = '4477889922';
            update ap;
            
            Booking__c b = [Select Id, Name, Booking_Cancellation_Approval_Required__c, Booking_Stages__c, Quotation__c from Booking__c ORDER BY CreatedDate DESC LIMIT 1];
            PageReference pRef2 = Page.PreviewBookingPage;
            ApexPages.currentPage().getParameters().put('bid', b.Id);
            ApexPages.currentPage().getParameters().put('qid', b.Quotation__c);
            PreviewBooking pb = new PreviewBooking();
            
            b.Booking_Cancellation_Approval_Required__c = true;
            update b;
            b.Booking_Stages__c = 'Booking Cancelled';
            update b;
        Test.stopTest();
    }
}
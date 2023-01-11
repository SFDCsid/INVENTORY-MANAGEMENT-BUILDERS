@isTest
public class BookingTriggerHandlerTest {
    /*
    //static List<Property__c> propertyOne= new List<Property__c>(); 
    static List<Project__c> projList;
    static List<Project__c> projectList ;
    static List<Property__c> propertyList;
    static List<Property_Type__c> propTypeList;
    static List<Booking__c> BookingList;
    
    
    
    @isTest
    
    public static void testUnit(){
        list<Booking__c> bookings = new List<Booking__c>();
        
        Integer numberOfBookings = 2;
        Integer numberOfTowers = 1;
        Test.startTest();
        
        List<Tower__c> towerList = TestDataFactory.createTowers(numberOfTowers);
        insert towerList;
        List<Site__c> sList = TestDataFactory.createSite(1);
        insert sList;
        Date todaysDate = Date.today();
        List<Opportunity> opps = TestDataFactory.createOpportunity(1);
        opps[0].Site__c = sList[0].Id;
        insert opps;
        List<Property__c> properties = TestDataFactory.createProperties(2);
        List<Property__c> propertyList = new List<Property__c>();
        Property_Type__c propertyType = new Property_Type__c();
        propertyType.Material_No__c = '138210jwhwek';
        propertyType.Description__c = 'test Description';
        propertyType.Control_Code__c = 'testcode';
        propertyType.Saleable_Area__c = 1600;
        propertyType.Carpet_Area__c = 1050;
        propertyType.Balcony_Area__c = 600;
        
        List<Project__c> projectList = TestDataFactory.createResProject(1);
        projectList[0].Active__c = true;
        projectList[0].Site__c = sList[0].Id;
        insert projectList;
        propertyType.Project1__c = projectList.get(0).Id;
        insert propertyType;
        Id userId = UserInfo.getUserId();
        for(Property__c prop : properties){
            prop.Property_Type__c = propertyType.Id;
            prop.Temporary_Block__c = true;
            prop.Blocked_By__c = userId;
            prop.Block_Comments__c = 'test Block comments';
            propertyList.add(prop);
        }
        insert propertyList;
        propertyList[0].Related_Jodi_Property__c = propertyList[1].Id;
        update propertyList;
        list<Payment_Plan__c> billingPlanList= TestDataFactory.createBillingPlan(1);
        billingPlanList[0].Status__c = 'Approved';
        billingPlanList[0].Active__c= true;
        billingPlanList[0].Opportunity__c = opps[0].Id; 
        billingPlanList[0].Total_Sales_Amount_Time_of_Booking__c = 50.0;
        insert billingPlanList;
        List<Billing_Plan_Line_Item__c> billingPlanItemList = TestDataFactory.createBillingPlanLineItem(billingPlanList);
        billingPlanItemList[0].Payment_Plan_Line_Item_Name__c = 'To be paid on or before <Date>';
        billingPlanItemList[0].Payment_Date__c = todaysDate.addDays(-1);
        insert billingPlanItemList;
        Billing_Plan_Sub_Line_Item__c billingPlanSubItem = new Billing_Plan_Sub_Line_Item__c();
        billingPlanSubItem.Billing_Plan_Line_Item__c = billingPlanItemList[0].Id;
        insert billingPlanSubItem;
        // update propertyList;
        list<Booking__c> bookingList=TestDataFactory.createBookings(1);
        
        for(Booking__c booking: bookingList){
            booking.Opportunity__c = opps[0].Id;
            booking.Property__c = properties[0].Id;
            booking.Project__c = projectList[0].Id;
            booking.Site__c = opps[0].Site__c;
            booking.Status__c = 'Booked';
            booking.Billing_Plan__c = billingPlanList[0].Id;
            Date bookingDate = todaysDate.addDays(-2);
            booking.Booking_Date__c = bookingDate;
            Id bookingRecordTypeId = Schema.SObjectType.Booking__c.getRecordTypeInfosByName().get('Booking Locked').getRecordTypeId();
            booking.RecordTypeId = bookingRecordTypeId;
            bookings.add(booking);
            insert bookings;
            bookings[0].Status__c ='Cancelled';
            update bookings;
            Test.stopTest();
        }
        
    }
    
    @isTest
    public static void setParkingDetailsForBookedTest(){
        projList = new List<Project__c>(TestDataFactory.createResProject(1));
        projlist[0].X_of_Single_Parking__c = 1;
        projlist[0].X_of_Single_Parking_Remaining__c = 1;
            projlist[0].X_of_Tandem_Parking_Remaining__c = 1;
            projlist[0].X_of_Triple_Parking_Remaining__c = 1;
            projlist[0].X_of_Tandem_Parking__c = 1;
            projlist[0].X_of_Triple_Parking__c =1;
        Insert projList;
        System.debug('projList-------> '+projList);
        Set<id> projSet = new Set<id>();
        system.debug('projList[0].id--------->'+projList[0].id);
        projSet.add(projList[0].id);
        system.debug('projSet--------->'+projSet);
        //BookingTriggerHandler.setParkingDetailsForBooked(projSet);
        //	BookingTriggerHandler.setParkingDetailsForcancelled(projSet);
        //List<Booking__c> bookingList= new List<Booking__c>(TestDataFactory.createBookings(1));
        //insert bookingList;
        Map<String,List<Id>> a = new Map<String,List<Id>>();
       a = BookingTriggerHandler.setParkingDetailsForBooked(projSet);
        
        
    }*/
    
     @testSetUp
    static void createTestData(){
        List<Site__c> lstOfSites = TestDataFactory.createSite(1);
        INSERT lstOfSites;
        Id customerRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        List<Account> accounts = new List<Account>();       
        Account personAcc = new Account(lastname='Person Account',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Individual',Residential_Status__pc='Resident Citizen');
        accounts.add(personAcc);
        
        Account personAcc2 = new Account(lastname='Person Account2',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Individual');
        accounts.add(personAcc2);
        
        insert accounts;
        
        Id KYCRecordId = Schema.SObjectType.KYC_Details__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        KYC_Details__c kycDetails = new KYC_Details__c( Person_Account__c = personAcc.Id,
                                                           Board_Resolution__c=true, 
                                                           Cert_of_Incorporation__c=true, 
                                                           Company_PAN__c=true,
                                                           HUF_PAN__c=true, 
                                                           Latest_ITR_optional__c=true, 
                                                           List_of_Designated_Partners__c=true, 
                                                           List_of_Directors__c=true, 
                                                           List_of_HUF_Members__c=true, 
                                                           List_of_Partners__c=true, 
                                                           List_of_Trustees__c=true, 
                                                           LLP_Agreement__c=true, 
                                                           LLP_PAN__c=true, 
                                                           M_O_A_A_O_A__c=true, 
                                                           NRI_Declaration__c=true, 
                                                           OCI_PIO_Card__c=true, 
                                                           PAN_Card__c=false, 
                                                           Passport_Election_ID__c=false, 
                                                           Proprietorship_PAN__c=true,
                                                           Registered_Partnership_Deed__c=true, 
                                                           Registered_Trust_Deed__c=true, 
                                                           Resolution__c=true,
                                                           recordtypeid = KYCRecordId,
                                                           Bank_Confirmation_Letter__c=true);
            insert kycDetails;
        
        KYC_Details__c kycDetails2 = new KYC_Details__c( Person_Account__c = personAcc2.Id,
                                                           Board_Resolution__c=true, 
                                                           Cert_of_Incorporation__c=true, 
                                                           Company_PAN__c=true,
                                                           HUF_PAN__c=true, 
                                                           Latest_ITR_optional__c=true, 
                                                           List_of_Designated_Partners__c=true, 
                                                           List_of_Directors__c=true, 
                                                           List_of_HUF_Members__c=true, 
                                                           List_of_Partners__c=true, 
                                                           List_of_Trustees__c=true, 
                                                           LLP_Agreement__c=true, 
                                                           LLP_PAN__c=true, 
                                                           M_O_A_A_O_A__c=true, 
                                                           NRI_Declaration__c=true, 
                                                           OCI_PIO_Card__c=true, 
                                                           PAN_Card__c=false, 
                                                           Passport_Election_ID__c=false, 
                                                           Proprietorship_PAN__c=true,
                                                           Registered_Partnership_Deed__c=true, 
                                                           Registered_Trust_Deed__c=true, 
                                                           Resolution__c=true,
                                                           recordtypeid = KYCRecordId,
                                                           Bank_Confirmation_Letter__c=true);
            insert kycDetails2;
        
        List<Project__c> lstOfProject = TestDataFactory.createResProject(1);
        lstOfProject[0].Site__c = lstOfSites[0].Id;
        lstOfProject[0].X_of_Single_Parking__c = 5;
            lstOfProject[0].X_of_Single_Parking_Remaining__c = 5;
            lstOfProject[0].X_of_Tandem_Parking_Remaining__c = 5;
            lstOfProject[0].X_of_Triple_Parking_Remaining__c = 5;
            lstOfProject[0].X_of_Tandem_Parking__c = 5;
            lstOfProject[0].X_of_Triple_Parking__c = 5;
        INSERT lstOfProject;
        
        List<Tower__c>lstOfTower = TestDataFactory.createTowers(1);
        lstOfTower[0].Project_Name__c = lstOfProject[0].Id;
        lstOfTower[0].X_of_Single_Parking__c = 1;
            lstOfTower[0].X_of_Tandem_Parking__c = 1;
            lstOfTower[0].X_of_Triple_Parking__c = 1;
        INSERT lstOfTower;
        
        
        List<Opportunity> lstOfOpp = TestDataFactory.createOpportunity(1);
        lstOfOpp[0].Partner_s_Firm_Name__c = 'Partner_s_Firm_Name__c';
        lstOfOpp[0].Partner_s_Name__c = 'Partner_s_Name__c';
        lstOfOpp[0].Partner_Mobile__c = '8723546789';
        lstOfOpp[0].Partner_Email__c = 'partner@test.com';
        lstOfOpp[0].PCID__c = 'PCID';
        lstOfOpp[0].Site__c = lstOfSites[0].Id;
        
        INSERT lstOfOpp;            
        
        List<Property_Type__c> lstOfProjtype = TestDataFactory.createProjectType(1);
        lstOfProjtype[0].Project1__c = lstOfProject[0].Id;
        INSERT lstOfProjtype;
        
        List<Property__c> lstOfProperty = TestDataFactory.createProperties(1);
        lstOfProperty[0].Property_Type__c = lstOfProjtype[0].Id;
        lstOfProperty[0].Temporary_Block__c = true;
        lstOfProperty[0].Block_Comments__c = 'Block property';
        lstOfProperty[0].Blocked_By__c = UserInfo.getUserId() ;
        lstOfProperty[0].Active__c = true;
        lstOfProperty[0].Tower__c = lstOfTower[0].Id;
        
        INSERT lstOfProperty;
        
        Id paymentPlanRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        List<Payment_Plan__c> paymentPlans = TestDataFactory.createBillingPlan(1);
        paymentPlans[0].recordTypeID = paymentPlanRecordTypeId;
        paymentPlans[0].Opportunity__c = lstOfOpp[0].Id;
        paymentPlans[0].Payment_Plan_Type__c = 'Non Scheme';   
        paymentPlans[0].active__c = true;
        paymentPlans[0].Property__c = lstOfProperty[0].Id;
        paymentPlans[0].project__C = lstOfProject[0].Id;
        paymentPlans[0].Tower__c = lstOfTower[0].Id;
        paymentPlans[0].site__c =lstOfSites[0].id;
        paymentPlans[0].status__c = 'Approved';
        insert paymentPlans;
        
        List<Booking__c> bookLst = TestDataFactory.createBookings(1);
        bookLst[0].Property__c = lstOfProperty[0].Id;   
        bookLst[0].Opportunity__c = lstOfOpp[0].Id;
        bookLst[0].Tower__c = lstOfTower[0].Id;
        bookLst[0].Project__c = lstOfProject[0].Id;
        bookLst[0].Site__c = lstOfSites[0].Id;
        bookLst[0].primary_applicants__C = personAcc.id;
        bookLst[0].Billing_Plan__c = paymentPlans[0].id;
        bookLst[0].Billing_Street__c = 'street';
        bookLst[0].Billing_Post_Code__c = '400606';
        bookLst[0].Billing_Location__c = 'Pune';
            bookLst[0].Billing_City__c='Pune';
            bookLst[0].Billing_Country__c = 'India';
            bookLst[0].Billing_Region__c = 'Bihar';
        bookLst[0].mobile__C = '7757014224';
            bookLst[0].email__C = 'swapnilmr2@gmail.com';
            bookLst[0].PAN_Number__c = 'BAPD7hhj';
        bookLst[0].TDS_Paid_By__c = 'Self';
        bookLst[0].Loan_Required__c = 'Yes';
        bookLst[0].X_of_Single_Parking__c= 2;
        bookLst[0].X_of_Tandem_Parking__c = 2;
        bookLst[0].X_of_Triple_Parking__c=2;
        INSERT bookLst;
       //Co_Owner__c coOwner = new Co_Owner__c(Booking__c=bookLst[0].Id,Person_Account__c=personAcc.Id);
       //Co_Owner__c coOwner2 = new Co_Owner__c(Booking__c=bookLst[0].Id,Person_Account__c=personAcc2.Id);
        //insert coOwner;
        //insert coOwner2;
        
        SAP_Interface_Log__c obj = new SAP_Interface_Log__c();
        obj.Status__c = 'Success';
        obj.Type__c = 'CustomerCreateCall';
        obj.SAP_Message__c = 'Pull Operation created';
        obj.Related_Object__c = 'Payment_Plan__c';
        obj.Description__c='Pull Request for Payment Plan';
        obj.Booking__c=bookLst[0].Id;
        
        List<SAP_Interface_Log__c> arrList = new List<SAP_Interface_Log__c>();
        arrList.add(obj);
        INSERT arrList;
        
        List<Payment_Plan__c> lstOfBillingPlan = TestDataFactory.createBillingPlan(1);
        INSERT lstOfBillingPlan;
    }
   
    
    static testMethod void ORL_SAPInterfaceTriggerHandler_Test2() {
         Test.startTest();        
                List<SAP_Interface_Log__c> arrList = [SELECT id,Booking__r.Id, Type__c, Status__c, Booking__c, SAP_Message__c, IsParent__c, Description__c, Related_Object__c , Payment_Plan__c FROM SAP_Interface_Log__c];
        ORL_SAPInterfaceTriggerHandler.createSalesOrder(arrList);
        map<id,booking__c> oldmapBooking = new map<id,booking__C>([select id,Status__c,Property__c,Tower__c,X_of_Single_Parking__c,X_of_Tandem_Parking__c,X_of_Triple_Parking__c from booking__c limit 1]);
        List<Booking__c> bookLst = [SELECT id,Sales_Document_SAP__c,Booking_Number_SAP__c,primary_applicants__C FROM Booking__c];
        for(Booking__c booking:bookLst){
            booking.Sales_Document_SAP__c = '1234';
            booking.Booking_Number_SAP__c = '1234';
            booking.Move_to_SAP__c = true;
            Id customerRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Account personAcc100 = new Account(lastname='Person Account',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Individual',Residential_Status__pc='Resident Citizen');
           insert personAcc100;
            Id KYCRecordId = Schema.SObjectType.KYC_Details__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            KYC_Details__c kycDetails = new KYC_Details__c( Person_Account__c = personAcc100.id,
                                                           Board_Resolution__c=true, 
                                                           Cert_of_Incorporation__c=true, 
                                                           Company_PAN__c=true,
                                                           HUF_PAN__c=true, 
                                                           Latest_ITR_optional__c=true, 
                                                           List_of_Designated_Partners__c=true, 
                                                           List_of_Directors__c=true, 
                                                           List_of_HUF_Members__c=true, 
                                                           List_of_Partners__c=true, 
                                                           List_of_Trustees__c=true, 
                                                           LLP_Agreement__c=true, 
                                                           LLP_PAN__c=true, 
                                                           M_O_A_A_O_A__c=true, 
                                                           NRI_Declaration__c=true, 
                                                           OCI_PIO_Card__c=true, 
                                                           PAN_Card__c=false, 
                                                           Passport_Election_ID__c=false, 
                                                           Proprietorship_PAN__c=true,
                                                           Registered_Partnership_Deed__c=true, 
                                                           Registered_Trust_Deed__c=true, 
                                                           Resolution__c=true,
                                                           recordtypeid = KYCRecordId,
                                                           Bank_Confirmation_Letter__c=true);
            insert kycDetails;
            Payment__c p = new Payment__c();
            p.Amount__c = 10000;
            p.Booking__c = booking.id;
            booking.status__c = 'Booked';
            booking.Billing_Street__c = 'street';
        booking.Billing_Post_Code__c = '400606';
        booking.Billing_Location__c = 'Pune';
            booking.Billing_City__c='Pune';
            booking.Billing_Country__c = 'India';
            booking.Billing_Region__c = 'Bihar';
            booking.mobile__C = '7757014224';
            booking.email__C = 'swapnilmr2@gmail.com';
            booking.PAN_Number__c = 'BAPD7hhj';
            booking.TDS_Paid_By__c = 'Self';
            booking.X_of_Single_Parking__c= 1;
            booking.X_of_Tandem_Parking__c = 1;
            booking.X_of_Triple_Parking__c=1;
        booking.Loan_Required__c = 'Yes';
            insert p;
            booking.primary_applicants__C = personAcc100.id;
        }
        UPDATE bookLst;
        set<id> projectid = new set<id>();
        
        for (Project__c p: [select id from project__c limit 1]){
            projectid.add(p.Id);
        }
        
        Map<Object,AggregateResult> a = new Map<Object,AggregateResult>();
        Map<String,List<Id>> b = new Map<String,List<Id>>();
        a = BookingTriggerHandler.setParkingDetailsUtils(projectid);
        
        map<id,booking__c> mapBooking = new map<id,booking__C>([select id,Property__c,Status__c,Tower__c,X_of_Single_Parking__c,X_of_Tandem_Parking__c,X_of_Triple_Parking__c from booking__c limit 1]);
        /*for (booking__c d:bookLst)
        BookingTriggerHandler.beforeInsert(d);*/
        BookingTriggerHandler.afterInsert(mapBooking);
        BookingTriggerHandler.afterUpdate(oldmapBooking,mapBooking);
        b = BookingTriggerHandler.setParkingDetailsForBooked(projectid);
        b  = BookingTriggerHandler.setParkingDetailsForcancelled(projectid);
        Test.stopTest();
    }
    
    
    
}
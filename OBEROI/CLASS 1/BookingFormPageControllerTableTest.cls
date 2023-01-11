@isTest
public class BookingFormPageControllerTableTest {
    
    @testSetup 
    static void testDataSetup(){
        Id customerRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        User usr = TestDataFactory.createUser('System Administrator', 'MD');
        
        List<Site__c> sList = TestDataFactory.createSite(1);
        insert sList;
        
        List<Account> accounts = new List<Account>();       
        Account personAcc = new Account(lastname='Person Account',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Individual',Residential_Status__pc='Resident Citizen');
        accounts.add(personAcc);
        
        
        Account personAcc2 = new Account(lastname='Person Account2',RecordTypeId=customerRecordId,Customer_Classification__pc = 'NRI');
        accounts.add(personAcc2);
        
        Account personAcc3 = new Account(lastname='Person Account3',RecordTypeId=customerRecordId,Customer_Classification__pc = 'HUF');
        accounts.add(personAcc3);
        
        Account personAcc4 = new Account(lastname='Person Account3',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Company');
        accounts.add(personAcc4);
        
        Account personAcc5 = new Account(lastname='Person Account3',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Partnership');
        accounts.add(personAcc5);
        
        Account personAcc6 = new Account(lastname='Person Account3',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Proprietorship');
        accounts.add(personAcc6);
        
        Account personAcc7 = new Account(lastname='Person Account3',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Trust');
        accounts.add(personAcc7);
        
        Account personAcc8 = new Account(lastname='Person Account3',RecordTypeId=customerRecordId,Customer_Classification__pc = 'LLP');
        accounts.add(personAcc8);
        
        Account personAcc9 = new Account(lastname='Person Account9',RecordTypeId=customerRecordId,Customer_Classification__pc = 'LLP');
        accounts.add(personAcc9);
        
        Account personAcc10 = new Account(lastname='Person Account10',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Trust');
        accounts.add(personAcc10);
        
        Account personAcc11 = new Account(lastname='Person Account11',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Proprietorship');
        accounts.add(personAcc11);
        
        Account personAcc12 = new Account(lastname='Person Account12',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Partnership');
        accounts.add(personAcc12);
        
        Account personAcc13 = new Account(lastname='Person Account12',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Individual');
        accounts.add(personAcc13);
        
        Account personAcc14 = new Account(lastname='Person Account12',RecordTypeId=customerRecordId,Customer_Classification__pc = 'NRI');
        accounts.add(personAcc14);
        
        Account personAcc15 = new Account(lastname='Person Account12',RecordTypeId=customerRecordId,Customer_Classification__pc = 'HUF');
        accounts.add(personAcc15);
        
        Account personAcc16 = new Account(lastname='Person Account12',RecordTypeId=customerRecordId,Customer_Classification__pc = 'Company');
        accounts.add(personAcc16);
        insert accounts;
        
        List<Opportunity> oppList=TestDataFactory.createOpportunity(1);
        oppList[0].Name = 'Test Opp' + Math.random();
        oppList[0].closeDate = system.Today(); 
        oppList[0].StageName= 'New';
        oppList[0].Site__c =sList[0].id;
        oppList[0].accountId = personAcc.Id;
        insert oppList;
        
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        
        List<Project__c> pList = TestDataFactory.createResProject(1);
        
        pList[0].Name = 'Enigma';
        pList[0].Plant__c ='767c';
        pList[0].site__c =sList[0].id;
        pList[0].Active__c=true;
        pList[0].Company_name__c='test'; 
        pList[0].recordtypeId= PrRecordTypeId;
        pList[0].Front_Desk_User__c = usr.id;
        pList[0].Marcom_Head__c =usr.Id; 
        pList[0].Sales_Head__c =usr.Id;
        pList[0].Site_Head__c=usr.Id; 
        pList[0].MD__c =usr.Id; 
        pList[0].Marcom_Manager__c = usr.Id; 
        pList[0].CFO__c =usr.Id;
        insert pList;
        
        List<Tower__c> towerList = TestDataFactory.createTowers(4);       
        towerList[0].Project_Name__c=pList[0].Id;
        insert towerList;
        
        List<Property_Type__c> projectTypeList = TestDataFactory.createProjectType(1);
        projectTypeList[0].Project1__c = pList[0].Id;
        insert projectTypeList;
        
        List<Property__c> propertyList=TestDataFactory.createProperties(1);
        propertyList[0].Temporary_Block__c = true;
        propertyList[0].Active__c = true;
        propertyList[0].Block_Comments__c = 'Test';
        propertyList[0].Blocked_By__c = usr.Id;
        propertyList[0].Tower__c = towerList[0].Id;
        propertyList[0].Property_Type__c = projectTypeList[0].Id;
        propertyList[0].Balcony_Terrace_Area_in_Sq_ft__c = 120;
        propertyList[0].RERA_Carpet_Area_In_Sq_ft__c = 100;
        propertyList[0].Single_Parking__c = 1;
        propertyList[0].Tandem_Parking__c = 1;
        propertyList[0].Triple_Parking__c = 1;
        
        insert propertyList;
        
        Other_Charges__c otherCharges = new Other_Charges__c(name='Municipal',
                                                             Description__c='Testing',
                                                             Discount_Amount__c = 100,
                                                             Property_Type__c=projectTypeList[0].Id);
        insert otherCharges;
        
        Id CustomBillingRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        
        List<Payment_Plan__c> billingPlanList = TestDataFactory.createBillingPlan(5);
        billingPlanList[0].recordtypeId = CustomBillingRecordTypeId;
        billingPlanList[0].Total_Sales_Amount_Time_of_Booking__c = 1124253;       
        insert billingPlanList;
        
        
        System.runAs(usr){
            
            Id BookingRecordTypeId = Schema.SObjectType.Booking__c.getRecordTypeInfosByName().get('Booking Locked').getRecordTypeId();
            
            
            List<Booking__c> bookings = TestDataFactory.createBookings(9);
            
            bookings[0].recordtypeId = BookingRecordTypeId;
            bookings[0].Property__c=propertyList[0].id;
            bookings[0].Project__c=pList[0].id;
            bookings[0].Search_Term__c='Test'; 
            bookings[0].site__c = sList[0].id; 
            bookings[0].opportunity__c = oppList[0].Id;
            bookings[0].Tower__c = towerList[0].Id;
            bookings[0].Billing_Plan__c = billingPlanList[0].Id;
            bookings[0].Booking_Date__c = system.today();
            bookings[0].Status__c = 'Booked';
            bookings[0].primary_applicants__C = personAcc.id;
            
            bookings[1].recordtypeId = BookingRecordTypeId;
            bookings[1].Property__c=propertyList[0].id;
            bookings[1].Project__c=pList[0].id;
            bookings[1].Search_Term__c='Test2'; 
            bookings[1].site__c = sList[0].id; 
            bookings[1].opportunity__c = oppList[0].Id;
            bookings[1].Tower__c = towerList[0].Id;
            bookings[1].Billing_Plan__c = billingPlanList[0].Id;
            bookings[1].Booking_Date__c = system.today();
            bookings[1].Status__c = 'Booked';
            bookings[1].primary_applicants__C = personAcc9.id;
            
            bookings[2].recordtypeId = BookingRecordTypeId;
            bookings[2].Property__c=propertyList[0].id;
            bookings[2].Project__c=pList[0].id;
            bookings[2].Search_Term__c='Test3'; 
            bookings[2].site__c = sList[0].id; 
            bookings[2].opportunity__c = oppList[0].Id;
            bookings[2].Tower__c = towerList[0].Id;
            bookings[2].Billing_Plan__c = billingPlanList[0].Id;
            bookings[2].Booking_Date__c = system.today();
            bookings[2].Status__c = 'Booked';
            bookings[2].primary_applicants__C = personAcc10.id;
            
            bookings[3].recordtypeId = BookingRecordTypeId;
            bookings[3].Property__c=propertyList[0].id;
            bookings[3].Project__c=pList[0].id;
            bookings[3].Search_Term__c='Test4'; 
            bookings[3].site__c = sList[0].id; 
            bookings[3].opportunity__c = oppList[0].Id;
            bookings[3].Tower__c = towerList[0].Id;
            bookings[3].Billing_Plan__c = billingPlanList[0].Id;
            bookings[3].Booking_Date__c = system.today();
            bookings[3].Status__c = 'Booked';
            bookings[3].primary_applicants__C = personAcc11.id;
            
            bookings[4].recordtypeId = BookingRecordTypeId;
            bookings[4].Property__c=propertyList[0].id;
            bookings[4].Project__c=pList[0].id;
            bookings[4].Search_Term__c='Test5'; 
            bookings[4].site__c = sList[0].id; 
            bookings[4].opportunity__c = oppList[0].Id;
            bookings[4].Tower__c = towerList[0].Id;
            bookings[4].Billing_Plan__c = billingPlanList[0].Id;
            bookings[4].Booking_Date__c = system.today();
            bookings[4].Status__c = 'Booked';
            bookings[4].primary_applicants__C = personAcc12.id;
            
            bookings[5].recordtypeId = BookingRecordTypeId;
            bookings[5].Property__c=propertyList[0].id;
            bookings[5].Project__c=pList[0].id;
            bookings[5].Search_Term__c='Test6'; 
            bookings[5].site__c = sList[0].id; 
            bookings[5].opportunity__c = oppList[0].Id;
            bookings[5].Tower__c = towerList[0].Id;
            bookings[5].Billing_Plan__c = billingPlanList[0].Id;
            bookings[5].Booking_Date__c = system.today();
            bookings[5].Status__c = 'Booked';
            bookings[5].primary_applicants__C = personAcc13.id;
            
            bookings[6].recordtypeId = BookingRecordTypeId;
            bookings[6].Property__c=propertyList[0].id;
            bookings[6].Project__c=pList[0].id;
            bookings[6].Search_Term__c='Test7'; 
            bookings[6].site__c = sList[0].id; 
            bookings[6].opportunity__c = oppList[0].Id;
            bookings[6].Tower__c = towerList[0].Id;
            bookings[6].Billing_Plan__c = billingPlanList[0].Id;
            bookings[6].Booking_Date__c = system.today();
            bookings[6].Status__c = 'Booked';
            bookings[6].primary_applicants__C = personAcc14.id;
            
            bookings[8].recordtypeId = BookingRecordTypeId;
            bookings[8].Property__c=propertyList[0].id;
            bookings[8].Project__c=pList[0].id;
            bookings[8].Search_Term__c='Test8'; 
            bookings[8].site__c = sList[0].id; 
            bookings[8].opportunity__c = oppList[0].Id;
            bookings[8].Tower__c = towerList[0].Id;
            bookings[8].Billing_Plan__c = billingPlanList[0].Id;
            bookings[8].Booking_Date__c = system.today();
            bookings[8].Status__c = 'Booked';
            bookings[8].primary_applicants__C = personAcc15.id;
            
            bookings[7].recordtypeId = BookingRecordTypeId;
            bookings[7].Property__c=propertyList[0].id;
            bookings[7].Project__c=pList[0].id;
            bookings[7].Search_Term__c='Test9'; 
            bookings[7].site__c = sList[0].id; 
            bookings[7].opportunity__c = oppList[0].Id;
            bookings[7].Tower__c = towerList[0].Id;
            bookings[7].Billing_Plan__c = billingPlanList[0].Id;
            bookings[7].Booking_Date__c = system.today();
            bookings[7].Status__c = 'Booked';
            bookings[7].primary_applicants__C = personAcc16.id;
            insert Bookings;
            
            Co_Owner__c coOwner = new Co_Owner__c(Booking__c=Bookings[0].Id,Person_Account__c=personAcc.Id);
            Co_Owner__c coOwner2 = new Co_Owner__c(Booking__c=Bookings[0].Id,Person_Account__c=personAcc2.Id);
            Co_Owner__c coOwner3 = new Co_Owner__c(Booking__c=Bookings[0].Id,Person_Account__c=personAcc3.Id);
            Co_Owner__c coOwner4 = new Co_Owner__c(Booking__c=Bookings[0].Id,Person_Account__c=personAcc4.Id);
            Co_Owner__c coOwner5 = new Co_Owner__c(Booking__c=Bookings[0].Id,Person_Account__c=personAcc5.Id);
            Co_Owner__c coOwner6 = new Co_Owner__c(Booking__c=Bookings[0].Id,Person_Account__c=personAcc6.Id);
            Co_Owner__c coOwner7 = new Co_Owner__c(Booking__c=Bookings[0].Id,Person_Account__c=personAcc7.Id);
            Co_Owner__c coOwner8 = new Co_Owner__c(Booking__c=Bookings[0].Id,Person_Account__c=personAcc8.Id);
            Co_Owner__c coOwner9 = new Co_Owner__c(Booking__c=Bookings[1].Id,Person_Account__c=personAcc2.Id);
            
            insert coOwner;
            insert coOwner2;
            insert coOwner3;
            insert coOwner4;
            insert coOwner5;
            insert coOwner6;
            insert coOwner7;
            insert coOwner8;
            Id KYCRecordId = Schema.SObjectType.KYC_Details__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Id KYCRecordIdNRI = Schema.SObjectType.KYC_Details__c.getRecordTypeInfosByName().get('NRI').getRecordTypeId();
            Id KYCRecordIdHUF = Schema.SObjectType.KYC_Details__c.getRecordTypeInfosByName().get('HUF').getRecordTypeId();
            Id KYCRecordIdCompany = Schema.SObjectType.KYC_Details__c.getRecordTypeInfosByName().get('Company').getRecordTypeId();
            Id KYCRecordIdPartnership = Schema.SObjectType.KYC_Details__c.getRecordTypeInfosByName().get('Partnership').getRecordTypeId();
            Id KYCRecordIdProprietorship = Schema.SObjectType.KYC_Details__c.getRecordTypeInfosByName().get('Proprietorship').getRecordTypeId();
            Id KYCRecordIdTrust = Schema.SObjectType.KYC_Details__c.getRecordTypeInfosByName().get('Trust').getRecordTypeId();
            Id KYCRecordIdLLP = Schema.SObjectType.KYC_Details__c.getRecordTypeInfosByName().get('LLP').getRecordTypeId();
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
            
            KYC_Details__c kycDetailsNRI = new KYC_Details__c( Person_Account__c = personAcc2.Id,
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
                                                           NRI_Declaration__c=false, 
                                                           OCI_PIO_Card__c=false, 
                                                           PAN_Card__c=false, 
                                                           Passport_Election_ID__c=false, 
                                                           Proprietorship_PAN__c=true,
                                                           Registered_Partnership_Deed__c=true, 
                                                           Registered_Trust_Deed__c=true, 
                                                           Resolution__c=true,
                                                           recordtypeid = KYCRecordIdNRI,
                                                           Bank_Confirmation_Letter__c=true);
            insert kycDetailsNRI;
            
            KYC_Details__c kycDetailsHUF = new KYC_Details__c( Person_Account__c = personAcc3.Id,
                                                           Board_Resolution__c=true, 
                                                           Cert_of_Incorporation__c=true, 
                                                           Company_PAN__c=true,
                                                           HUF_PAN__c=false, 
                                                           Latest_ITR_optional__c=true, 
                                                           List_of_Designated_Partners__c=true, 
                                                           List_of_Directors__c=true, 
                                                           List_of_HUF_Members__c=false, 
                                                           List_of_Partners__c=true, 
                                                           List_of_Trustees__c=true, 
                                                           LLP_Agreement__c=true, 
                                                           LLP_PAN__c=true, 
                                                           M_O_A_A_O_A__c=true, 
                                                           NRI_Declaration__c=false, 
                                                           OCI_PIO_Card__c=false, 
                                                           PAN_Card__c=false, 
                                                           Passport_Election_ID__c=false, 
                                                           Proprietorship_PAN__c=true,
                                                           Registered_Partnership_Deed__c=true, 
                                                           Registered_Trust_Deed__c=true, 
                                                           Resolution__c=true,
                                                           recordtypeid = KYCRecordIdHUF,
                                                           Bank_Confirmation_Letter__c=false);
            insert kycDetailsHUF;
            KYC_Details__c kycDetailsCompany = new KYC_Details__c( Person_Account__c = personAcc4.Id,
                                                           Board_Resolution__c=false, 
                                                           Cert_of_Incorporation__c=true, 
                                                           Company_PAN__c=false,
                                                           HUF_PAN__c=false, 
                                                           Latest_ITR_optional__c=true, 
                                                           List_of_Designated_Partners__c=true, 
                                                           List_of_Directors__c=false, 
                                                           List_of_HUF_Members__c=false, 
                                                           List_of_Partners__c=true, 
                                                           List_of_Trustees__c=true, 
                                                           LLP_Agreement__c=true, 
                                                           LLP_PAN__c=true, 
                                                           M_O_A_A_O_A__c=false, 
                                                           NRI_Declaration__c=false, 
                                                           OCI_PIO_Card__c=false, 
                                                           PAN_Card__c=false, 
                                                           Passport_Election_ID__c=false, 
                                                           Proprietorship_PAN__c=true,
                                                           Registered_Partnership_Deed__c=true, 
                                                           Registered_Trust_Deed__c=true, 
                                                           Resolution__c=true,
                                                           recordtypeid = KYCRecordIdCompany,
                                                           Bank_Confirmation_Letter__c=false);
            insert kycDetailsCompany;
            KYC_Details__c kycDetailsPartnership = new KYC_Details__c( Person_Account__c = personAcc5.Id,
                                                           Board_Resolution__c=true, 
                                                           Cert_of_Incorporation__c=true, 
                                                           Company_PAN__c=true,
                                                           HUF_PAN__c=false, 
                                                           Latest_ITR_optional__c=true, 
                                                           List_of_Designated_Partners__c=true, 
                                                           List_of_Directors__c=true, 
                                                           List_of_HUF_Members__c=false, 
                                                           List_of_Partners__c=false, 
                                                           List_of_Trustees__c=true, 
                                                           LLP_Agreement__c=true, 
                                                           LLP_PAN__c=true, 
                                                           M_O_A_A_O_A__c=true, 
                                                           NRI_Declaration__c=false, 
                                                           OCI_PIO_Card__c=false, 
                                                           PAN_Card__c=false, 
                                                           Passport_Election_ID__c=false, 
                                                           Proprietorship_PAN__c=true,
                                                           Registered_Partnership_Deed__c=false, 
                                                           Registered_Trust_Deed__c=true, 
                                                           Resolution__c=false,
                                                           recordtypeid = KYCRecordIdPartnership,
                                                           Bank_Confirmation_Letter__c=false);
            insert kycDetailsPartnership;
            KYC_Details__c kycDetailsProprietorship = new KYC_Details__c( Person_Account__c = personAcc6.Id,
                                                           Board_Resolution__c=true, 
                                                           Cert_of_Incorporation__c=true, 
                                                           Company_PAN__c=true,
                                                           HUF_PAN__c=false, 
                                                           Latest_ITR_optional__c=false, 
                                                           List_of_Designated_Partners__c=true, 
                                                           List_of_Directors__c=true, 
                                                           List_of_HUF_Members__c=false, 
                                                           List_of_Partners__c=true, 
                                                           List_of_Trustees__c=true, 
                                                           LLP_Agreement__c=true, 
                                                           LLP_PAN__c=true, 
                                                           M_O_A_A_O_A__c=true, 
                                                           NRI_Declaration__c=false, 
                                                           OCI_PIO_Card__c=false, 
                                                           PAN_Card__c=false, 
                                                           Passport_Election_ID__c=false, 
                                                           Proprietorship_PAN__c=false,
                                                           Registered_Partnership_Deed__c=true, 
                                                           Registered_Trust_Deed__c=true, 
                                                           Resolution__c=true,
                                                           recordtypeid = KYCRecordIdProprietorship,
                                                           Bank_Confirmation_Letter__c=false);
            insert kycDetailsProprietorship;
            KYC_Details__c kycDetailsTrust = new KYC_Details__c( Person_Account__c = personAcc7.Id,
                                                           Board_Resolution__c=true, 
                                                           Cert_of_Incorporation__c=true, 
                                                           Company_PAN__c=true,
                                                           HUF_PAN__c=false, 
                                                           Latest_ITR_optional__c=true, 
                                                           List_of_Designated_Partners__c=true, 
                                                           List_of_Directors__c=true, 
                                                           List_of_HUF_Members__c=false, 
                                                           List_of_Partners__c=true, 
                                                           List_of_Trustees__c=false, 
                                                           LLP_Agreement__c=true, 
                                                           LLP_PAN__c=true, 
                                                           M_O_A_A_O_A__c=true, 
                                                           NRI_Declaration__c=false, 
                                                           OCI_PIO_Card__c=false, 
                                                           PAN_Card__c=false, 
                                                           Passport_Election_ID__c=false, 
                                                           Proprietorship_PAN__c=true,
                                                           Registered_Partnership_Deed__c=true, 
                                                           Registered_Trust_Deed__c=false, 
                                                           Resolution__c=false,
                                                           recordtypeid = KYCRecordIdTrust,
                                                           Bank_Confirmation_Letter__c=false);
            insert kycDetailsTrust;
            KYC_Details__c kycDetailsLLP = new KYC_Details__c( Person_Account__c = personAcc8.Id,
                                                           Board_Resolution__c=true, 
                                                           Cert_of_Incorporation__c=false, 
                                                           Company_PAN__c=true,
                                                           HUF_PAN__c=false, 
                                                           Latest_ITR_optional__c=true, 
                                                           List_of_Designated_Partners__c=false, 
                                                           List_of_Directors__c=true, 
                                                           List_of_HUF_Members__c=false, 
                                                           List_of_Partners__c=true, 
                                                           List_of_Trustees__c=true, 
                                                           LLP_Agreement__c=false, 
                                                           LLP_PAN__c=false, 
                                                           M_O_A_A_O_A__c=true, 
                                                           NRI_Declaration__c=false, 
                                                           OCI_PIO_Card__c=false, 
                                                           PAN_Card__c=false, 
                                                           Passport_Election_ID__c=false, 
                                                           Proprietorship_PAN__c=true,
                                                           Registered_Partnership_Deed__c=true, 
                                                           Registered_Trust_Deed__c=true, 
                                                           Resolution__c=false,
                                                           recordtypeid = KYCRecordIdLLP,
                                                           Bank_Confirmation_Letter__c=false);
            insert kycDetailsLLP;
            
            KYC_Details__c kycDetails1 = new KYC_Details__c( Person_Account__c = personAcc2.Id,
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
                                                           recordtypeid = KYCRecordIdNRI,
                                                           Bank_Confirmation_Letter__c=true);
            insert kycDetails1;
        }
    }
    
    @isTest
    static void testBookingFormPageControllerTableMethod1(){
        Test.startTest();
        
        List<Booking__c> bookings1 = [select Id from Booking__c  where Search_Term__c = 'Test' ];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);    
        Blob pdfBlob = Blob.valueOf('Hello Abc, Testing here');
        
        Attachment attach = new Attachment(parentId = bookings1[0].id, Name = 'BookingForm.pdf', body = pdfBlob); 
        insert attach; 
        
        Apexpages.StandardController sc1 = new Apexpages.StandardController(bookings1[0]);
        BookingFormPageControllerTable bookingFormPageControllerTab = new BookingFormPageControllerTable(sc1);
        
        PageReference pageRef = bookingFormPageControllerTab.attachPDF();
        BookingFormPageControllerTable.kycwrapper kycWrapper = new BookingFormPageControllerTable.kycwrapper('Test','Pending Doc');
        
        
    }
    
     @isTest
    static void testBookingFormPageControllerTableMethod2(){
        Test.startTest();
    //new code
        List<Booking__c> bookings1 = [select Id from Booking__c where Search_Term__c = 'Test2' ];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);    
        Blob pdfBlob1 = Blob.valueOf('Hello Abc, Testing here12');
        
        Attachment attach1 = new Attachment(parentId = bookings1[0].id, Name = 'BookingForm.pdf', body = pdfBlob1); 
        insert attach1; 
        
        Apexpages.StandardController sc11 = new Apexpages.StandardController(bookings1[0]);
        BookingFormPageControllerTable bookingFormPageControllerTab1 = new BookingFormPageControllerTable(sc11);
        
        PageReference pageRef1 = bookingFormPageControllerTab1.attachPDF();
        BookingFormPageControllerTable.kycwrapper kycWrapper1 = new BookingFormPageControllerTable.kycwrapper('Test','Pending Doc');
        
    }
    
    @isTest
    static void testBookingFormPageControllerTableMethod5(){
        Test.startTest();
    //new code
        List<Booking__c> bookings1 = [select Id from Booking__c where Search_Term__c = 'Test5' ];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);    
        Blob pdfBlob1 = Blob.valueOf('Hello Abc, Testing here12');
        
        Attachment attach1 = new Attachment(parentId = bookings1[0].id, Name = 'BookingForm.pdf', body = pdfBlob1); 
        insert attach1; 
        
        Apexpages.StandardController sc11 = new Apexpages.StandardController(bookings1[0]);
        BookingFormPageControllerTable bookingFormPageControllerTab1 = new BookingFormPageControllerTable(sc11);
        
        PageReference pageRef1 = bookingFormPageControllerTab1.attachPDF();
        BookingFormPageControllerTable.kycwrapper kycWrapper1 = new BookingFormPageControllerTable.kycwrapper('Test','Pending Doc');
        
    }
    @isTest
    static void testBookingFormPageControllerTableMethod3(){
        Test.startTest();
    //new code
        List<Booking__c> bookings1 = [select Id from Booking__c where Search_Term__c = 'Test3' ];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);    
        Blob pdfBlob1 = Blob.valueOf('Hello Abc, Testing here12');
        
        Attachment attach1 = new Attachment(parentId = bookings1[0].id, Name = 'BookingForm.pdf', body = pdfBlob1); 
        insert attach1; 
        
        Apexpages.StandardController sc11 = new Apexpages.StandardController(bookings1[0]);
        BookingFormPageControllerTable bookingFormPageControllerTab1 = new BookingFormPageControllerTable(sc11);
        
        PageReference pageRef1 = bookingFormPageControllerTab1.attachPDF();
        BookingFormPageControllerTable.kycwrapper kycWrapper1 = new BookingFormPageControllerTable.kycwrapper('Test','Pending Doc');
        
    }
    
    @isTest
    static void testBookingFormPageControllerTableMethod4(){
        Test.startTest();
    //new code
        List<Booking__c> bookings1 = [select Id from Booking__c where Search_Term__c = 'Test4' ];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);    
        Blob pdfBlob1 = Blob.valueOf('Hello Abc, Testing here12');
        
        Attachment attach1 = new Attachment(parentId = bookings1[0].id, Name = 'BookingForm.pdf', body = pdfBlob1); 
        insert attach1; 
        
        Apexpages.StandardController sc11 = new Apexpages.StandardController(bookings1[0]);
        BookingFormPageControllerTable bookingFormPageControllerTab1 = new BookingFormPageControllerTable(sc11);
        
        PageReference pageRef1 = bookingFormPageControllerTab1.attachPDF();
        BookingFormPageControllerTable.kycwrapper kycWrapper1 = new BookingFormPageControllerTable.kycwrapper('Test','Pending Doc');
        
    }
    
    @isTest
    static void testBookingFormPageControllerTableMethod8(){
        Test.startTest();
    //new code
        List<Booking__c> bookings1 = [select Id from Booking__c where Search_Term__c = 'Test8' ];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);    
        Blob pdfBlob1 = Blob.valueOf('Hello Abc, Testing here12');
        
        Attachment attach1 = new Attachment(parentId = bookings1[0].id, Name = 'BookingForm.pdf', body = pdfBlob1); 
        insert attach1; 
        
        Apexpages.StandardController sc11 = new Apexpages.StandardController(bookings1[0]);
        BookingFormPageControllerTable bookingFormPageControllerTab1 = new BookingFormPageControllerTable(sc11);
        
        PageReference pageRef1 = bookingFormPageControllerTab1.attachPDF();
        BookingFormPageControllerTable.kycwrapper kycWrapper1 = new BookingFormPageControllerTable.kycwrapper('Test','Pending Doc');
        
    }
    
    @isTest
    static void testBookingFormPageControllerTableMethod6(){
        Test.startTest();
    //new code
        List<Booking__c> bookings1 = [select Id from Booking__c where Search_Term__c = 'Test6' ];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);    
        Blob pdfBlob1 = Blob.valueOf('Hello Abc, Testing here12');
        
        Attachment attach1 = new Attachment(parentId = bookings1[0].id, Name = 'BookingForm.pdf', body = pdfBlob1); 
        insert attach1; 
        
        Apexpages.StandardController sc11 = new Apexpages.StandardController(bookings1[0]);
        BookingFormPageControllerTable bookingFormPageControllerTab1 = new BookingFormPageControllerTable(sc11);
        
        PageReference pageRef1 = bookingFormPageControllerTab1.attachPDF();
        BookingFormPageControllerTable.kycwrapper kycWrapper1 = new BookingFormPageControllerTable.kycwrapper('Test','Pending Doc');
        
    }
    
    @isTest
    static void testBookingFormPageControllerTableMethod7(){
        Test.startTest();
    //new code
        List<Booking__c> bookings1 = [select Id from Booking__c where Search_Term__c = 'Test7' ];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);    
        Blob pdfBlob1 = Blob.valueOf('Hello Abc, Testing here12');
        
        Attachment attach1 = new Attachment(parentId = bookings1[0].id, Name = 'BookingForm.pdf', body = pdfBlob1); 
        insert attach1; 
        
        Apexpages.StandardController sc11 = new Apexpages.StandardController(bookings1[0]);
        BookingFormPageControllerTable bookingFormPageControllerTab1 = new BookingFormPageControllerTable(sc11);
        
        PageReference pageRef1 = bookingFormPageControllerTab1.attachPDF();
        BookingFormPageControllerTable.kycwrapper kycWrapper1 = new BookingFormPageControllerTable.kycwrapper('Test','Pending Doc');
        
    }
    
    @isTest
    static void testBookingFormPageControllerTableMethod9(){
        Test.startTest();
    //new code
        List<Booking__c> bookings1 = [select Id from Booking__c where Search_Term__c = 'Test9' ];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);    
        Blob pdfBlob1 = Blob.valueOf('Hello Abc, Testing here12');
        
        Attachment attach1 = new Attachment(parentId = bookings1[0].id, Name = 'BookingForm.pdf', body = pdfBlob1); 
        insert attach1; 
        
        Apexpages.StandardController sc11 = new Apexpages.StandardController(bookings1[0]);
        BookingFormPageControllerTable bookingFormPageControllerTab1 = new BookingFormPageControllerTable(sc11);
        
        PageReference pageRef1 = bookingFormPageControllerTab1.attachPDF();
        BookingFormPageControllerTable.kycwrapper kycWrapper1 = new BookingFormPageControllerTable.kycwrapper('Test','Pending Doc');
        
    }
    
    
    
}
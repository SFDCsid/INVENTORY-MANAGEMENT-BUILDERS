@isTest
public class BookingFormHandlerTest{
    @testSetup 
    static void testDataSetup(){
        User usr = TestDataFactory.createUser('ORL Admin', 'MD');
        
        List<Site__c> sList = TestDataFactory.createSite(1);
        insert sList;
        Account acc = new Account(name='Test Account');
        insert acc;
        
        List<Opportunity> oppList=TestDataFactory.createOpportunity(1);
        oppList[0].Name = 'Test Opp' + Math.random();
        oppList[0].closeDate = system.Today(); 
        oppList[0].StageName= 'New';
        oppList[0].Site__c =sList[0].id;
        oppList[0].accountId = acc.Id;
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
        List<Other_Charges__c> oChargesList = new List<Other_Charges__c>();
        
        Other_Charges__c otherCharges = new Other_Charges__c(name='Municipal',
                                                             Description__c='Testing',
                                                             Discount_Amount__c = 100,
                                                             Property_Type__c=projectTypeList[0].Id);
        oChargesList.add(otherCharges);                                               
        
        Other_Charges__c otherCharges1 = new Other_Charges__c(name='Corpus',
                                                              Description__c='Testing',
                                                              Discount_Amount__c = 100,
                                                              Property_Type__c=projectTypeList[0].Id);
        oChargesList.add(otherCharges1);
        
        Other_Charges__c otherCharges2 = new Other_Charges__c(name='Share',
                                                              Description__c='Testing',
                                                              Discount_Amount__c = 100,
                                                              Property_Type__c=projectTypeList[0].Id);
        oChargesList.add(otherCharges2);
        
        Other_Charges__c otherCharges3 = new Other_Charges__c(name='Development',
                                                              Description__c='Testing',
                                                              Discount_Amount__c = 100,
                                                              Property_Type__c=projectTypeList[0].Id);
        oChargesList.add(otherCharges3);
        
         Other_Charges__c otherCharges6 = new Other_Charges__c(name='Legal',
                                                              Description__c='Testing',
                                                              Discount_Amount__c = 100,
                                                              Property_Type__c=projectTypeList[0].Id);
        oChargesList.add(otherCharges6);
        
         Other_Charges__c otherCharges4 = new Other_Charges__c(name='Society',
                                                              Description__c='Testing',
                                                              Discount_Amount__c = 100,
                                                              Property_Type__c=projectTypeList[0].Id);
        oChargesList.add(otherCharges4);
        
         Other_Charges__c otherCharges5 = new Other_Charges__c(name='Club',
                                                              Description__c='Testing',
                                                              Discount_Amount__c = 100,
                                                              Property_Type__c=projectTypeList[0].Id);
        oChargesList.add(otherCharges5);
        
        insert oChargesList;
        
        Id CustomBillingRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        
        List<Payment_Plan__c> billingPlanList = TestDataFactory.createBillingPlan(1);
        billingPlanList[0].recordtypeId = CustomBillingRecordTypeId;
        billingPlanList[0].Total_Sales_Amount_Time_of_Booking__c = 1124253;       
        insert billingPlanList;
        
        System.runAs(usr){
            
            Id BookingRecordTypeId = Schema.SObjectType.Booking__c.getRecordTypeInfosByName().get('Booking Locked').getRecordTypeId();
            
            
            List<Booking__c> bookings = TestDataFactory.createBookings(1);
            
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
            
            insert Bookings;
        }
        
    }
    
    @isTest
    static void testBookingFormControllerMethod1(){
        Test.startTest();
        List<Booking__c> bookings1 = [select Id from Booking__c];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);      
        ApexPages.CurrentPage().getparameters().put('type', 'TDSSelfDeclaration');
        ApexPages.CurrentPage().getparameters().put('SAPSync', '0');
        
        Apexpages.StandardController sc1 = new Apexpages.StandardController(bookings1[0]);
        BookingFormHandler bookingFormHandler = new BookingFormHandler(sc1);
        
        PageReference pageRef = BookingFormHandler.savePDF();
        Test.stopTest();
    }
    
    @isTest
    static void testNumberToEnglish(){
        Test.startTest();
        String result = BookingFormHandler.numberToEnglish(115672);
        system.assert(result.contains('Thousand'));
        Test.stopTest();
    }
    @isTest
    static void testBookingFormControllerMethod2(){
        Test.startTest();
        List<Booking__c> bookings1 = [select Id from Booking__c];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);      
        ApexPages.CurrentPage().getparameters().put('type', 'AuthLetterCompany');
        ApexPages.CurrentPage().getparameters().put('SAPSync', '0');
        
        Apexpages.StandardController sc1 = new Apexpages.StandardController(bookings1[0]);
        BookingFormHandler bookingFormHandler = new BookingFormHandler(sc1); 
        PageReference pageRef = BookingFormHandler.savePDF();
        Test.stopTest();
    }
    
    @isTest
    static void testBookingFormControllerMethod3(){
        Test.startTest();
        List<Booking__c> bookings1 = [select Id from Booking__c];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);      
        ApexPages.CurrentPage().getparameters().put('type', 'AuthLetterSelf');
        ApexPages.CurrentPage().getparameters().put('SAPSync', '0');
        
        Apexpages.StandardController sc1 = new Apexpages.StandardController(bookings1[0]);
        BookingFormHandler bookingFormHandler = new BookingFormHandler(sc1); 
        PageReference pageRef = BookingFormHandler.savePDF();
        Test.stopTest();
    }
    
    @isTest
    static void testBookingFormControllerMethod4(){
        Test.startTest();
        
        List<Booking__c> bookings1 = [select Id from Booking__c];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);      
        ApexPages.CurrentPage().getparameters().put('type', 'AuthToCompany');
        ApexPages.CurrentPage().getparameters().put('SAPSync', '0');
        
        Apexpages.StandardController sc1 = new Apexpages.StandardController(bookings1[0]);
        BookingFormHandler bookingFormHandler = new BookingFormHandler(sc1); 
        PageReference pageRef = BookingFormHandler.savePDF();
        Test.stopTest();
    }
    
    @isTest
    static void testBookingFormControllerMethod5(){
        Test.startTest();
        
        List<Booking__c> bookings1 = [select Id from Booking__c];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);      
        ApexPages.CurrentPage().getparameters().put('type', 'Booking');
        ApexPages.CurrentPage().getparameters().put('SAPSync', '0');
        
        Apexpages.StandardController sc1 = new Apexpages.StandardController(bookings1[0]);
        BookingFormHandler bookingFormHandler = new BookingFormHandler(sc1); 
        PageReference pageRef = BookingFormHandler.savePDF();
        Test.stopTest();
    }
    
    @isTest
    static void testBookingFormControllerMethod6(){
        Test.startTest();
        
        List<Booking__c> bookings1 = [select Id from Booking__c];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);      
        ApexPages.CurrentPage().getparameters().put('type', 'Acceptance');
        ApexPages.CurrentPage().getparameters().put('SAPSync', '0');
        
        Apexpages.StandardController sc1 = new Apexpages.StandardController(bookings1[0]);
        BookingFormHandler bookingFormHandler = new BookingFormHandler(sc1); 
        PageReference pageRef = BookingFormHandler.savePDF();
        Test.stopTest();
    }
    
    @isTest
    static void testBookingFormControllerMethod7(){
        Test.startTest();
        
        List<Booking__c> bookings1 = [select Id from Booking__c];
        ApexPages.CurrentPage().getparameters().put('id', bookings1[0].id);      
        ApexPages.CurrentPage().getparameters().put('type', 'NRIDeclaration');
        ApexPages.CurrentPage().getparameters().put('SAPSync', '0');
        
        Apexpages.StandardController sc1 = new Apexpages.StandardController(bookings1[0]);
        BookingFormHandler bookingFormHandler = new BookingFormHandler(sc1); 
        PageReference pageRef = BookingFormHandler.savePDF();
        Test.stopTest();
    }
}
/**
* @author:      Ravi Kumar K
* @Company:     IBM
* @date:        13/03/2019
* @description: This class is Test class for BookingTriggerHelper
*
* History
* <Date>      <Authors Name>      <Brief Description of Change>
12/03/2019     Ravi Kumar K       Created New
* ----------------------------------------------------*/
@isTest
private class BookingTriggerHelperTest {
    static List<Booking__c> BookingList;
    
    @testSetup 
    static void testData() {
        UserRole newRole = new UserRole(DeveloperName = 'TestDeveloperName',Name = 'AdminDeveloperName');
        insert newRole;
        User newUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Rep'].Id,
            LastName = 'last',
            Email = 'puser000@test.com',
            Username = 'puser000@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = newRole.Id
        );
        insert newUser;
        Integer numberOfBookings = 2;
        Integer numberOfTowers = 1;
        Test.startTest();
        System.runAs(newUser){
            List<Tower__c> towerList = TestDataFactory.createTowers(numberOfTowers);
            insert towerList;
            List<Site__c> sList = TestDataFactory.createSite(1);
                insert sList;
            	system.debug('sList---->'+sList);
                Date todaysDate = Date.today();
                List<Opportunity> opps = TestDataFactory.createOpportunity(1);
            	system.debug('sList[0].Id'+sList[0].Id);
                opps[0].Site__c = sList[0].Id;
            	system.debug('opps[0].Site__c'+opps[0].Site__c);
                insert opps;
            	system.debug('opps--->'+opps);
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
            	billingPlanList[0].Site__c = sList[0].Id;
            	billingPlanList[0].Project__c = projectList[0].Id;
            	billingPlanList[0].Property__c = properties[0].Id;
                billingPlanList[0].Tower__c = towerList[0].Id;
                insert billingPlanList;
                List<Billing_Plan_Line_Item__c> billingPlanItemList = TestDataFactory.createBillingPlanLineItem(billingPlanList);
                billingPlanItemList[0].Payment_Plan_Line_Item_Name__c = 'To be paid on or before <Date>';
                billingPlanItemList[0].Payment_Date__c = todaysDate.addDays(-1);
                insert billingPlanItemList;
                Billing_Plan_Sub_Line_Item__c billingPlanSubItem = new Billing_Plan_Sub_Line_Item__c();
                billingPlanSubItem.Billing_Plan_Line_Item__c = billingPlanItemList[0].Id;
                insert billingPlanSubItem;
                // update propertyList;
                list<Booking__c> bookingList=TestDataFactory.createBookings(2);
            	list<Booking__c> bookings = new List<Booking__c>();
            	Set<Id> ProjectIdSetBooked = new Set<Id>();
            	for(Booking__c booking: bookingList){
                    booking.Opportunity__c = opps[0].Id;
                    booking.Property__c = properties[0].Id;
                    booking.Project__c = projectList[0].Id;
                    system.debug('opps[0].Site__c--->'+opps[0].Site__c);
                    booking.Site__c = opps[0].Site__c;
                    system.debug('booking.Site__c--->'+booking.Site__c);
                    booking.Status__c = 'Booked';
                    booking.Billing_Plan__c = billingPlanList[0].Id;
                    Date bookingDate = todaysDate.addDays(-2);
                    booking.Booking_Date__c = bookingDate;
                    booking.Sales_Rep__c = newUser.id;
                    Id bookingRecordTypeId = Schema.SObjectType.Booking__c.getRecordTypeInfosByName().get('Booking Locked').getRecordTypeId();
                    booking.RecordTypeId = bookingRecordTypeId;                    
                    bookings.add(booking);
                    
            	}
                
                insert bookings;
            	List<Project_Quota__c> projectQuotaList = new List<Project_Quota__c>();
            	Project_Quota__c projectQuota = new Project_Quota__c();
            	projectQuota.Project__c = projectList[0].Id;
            	projectQuota.Target__c = 100;
            	projectQuota.Year__c = 2020;
            	projectQuota.Month__c = 'January';
                
            	projectQuotaList.add(projectQuota);
            	Insert projectQuotaList;
            
            	List<User_Quota__c> userQuotaList = new List<User_Quota__c>();
            	User_Quota__c userQuota = new User_Quota__c();
            	userQuota.Project_Quota__c = projectQuotaList[0].id;
            	userQuota.Month__c = 'January';
            	userQuota.Project__c = projectList[0].id;
            	userQuota.Target__c = 50;
            	userQuota.Year__c = 2020;
            	userQuota.Achievement__c = 100;
            	userQuota.User__c = newUser.id;
            	userQuota.Unique_Id__c = projectList[0].id + '' + 'January' + '' + 2020 + '' + newUser.id;
            	system.debug('userQuota.Unique_Id__c---->'+userQuota.Unique_Id__c);
            	userQuotaList.add(userQuota);
            	
            	Insert userQuotaList;
            	system.debug('userQuotaList---->'+userQuotaList);
            	//ProjectIdSetBooked.add(bookings[0].Project__c);
            	//system.debug('ProjectIdSetBooked------>'+ProjectIdSetBooked);
            	
            	//bookings[0].Status__c='Cancelled';
            	//Update bookings;
            	//ProjectIdSetBooked.add(bookings[0].Project__c);
            /*BookingList = TestDataFactory.createBookings(numberOfBookings);
            insert bookingList;*/
        }
        Test.stopTest();
        
    }
    @isTest  
    static void setParking() {
        List<Tower__c> towerList = [SELECT X_of_Single_Parking__c,X_of_Single_Parking_Remaining__c,X_of_Tandem_Parking_Remaining__c,X_of_Triple_Parking_Remaining__c,X_of_Tandem_Parking__c,X_of_Triple_Parking__c FROM Tower__c];
        List<User> testUser = [SELECT Id FROM User];
        Integer parkingNumbers = 10;
        Integer bookedParkingNumbers = 5;
        List<Tower__c> insertTowerList = new List<Tower__c>();
        For(Tower__c singleTower:towerList){
            singleTower.X_of_Single_Parking__c = parkingNumbers;
            singleTower.X_of_Tandem_Parking__c = parkingNumbers;
            singleTower.X_of_Triple_Parking__c = parkingNumbers;
            insertTowerList.add(singleTower);
        }
        upsert insertTowerList;
        
        List<Booking__c> BookingList = [SELECT Property__c,Project__c,Search_Term__c,Sales_Head__c,Site_Head__c,CRM_Lead__c,
                                        X_of_Single_Parking__c,X_of_Tandem_Parking__c,X_of_Triple_Parking__c,
                                        Tower__c FROM Booking__c];
        List<Booking__c> insertBookingList = new List<Booking__c>();
        For(Booking__c singleBooking:BookingList){
            singleBooking.X_of_Single_Parking__c = bookedParkingNumbers;
            singleBooking.X_of_Tandem_Parking__c = bookedParkingNumbers;
            singleBooking.X_of_Triple_Parking__c = bookedParkingNumbers;
            singleBooking.Tower__c = insertTowerList[0].Id;
            singleBooking.Sales_Head__c= testUser[0].Id;
            singleBooking.Site_Head__c= testUser[0].Id;
            singleBooking.CRM_Lead__c= testUser[0].Id;
            singleBooking.RM__c= testUser[0].Id;
            insertBookingList.add(singleBooking);
        }
        //upsert insertBookingList;
        System.debug('insertBookingList__'+insertBookingList.size());
    }
    static testMethod void callTrigHandMethod1(){
        List<Tower__c> towerList = [SELECT X_of_Single_Parking__c,X_of_Single_Parking_Remaining__c,X_of_Tandem_Parking_Remaining__c,X_of_Triple_Parking_Remaining__c,X_of_Tandem_Parking__c,X_of_Triple_Parking__c FROM Tower__c];
        List<User> testUser = [SELECT Id FROM User];
        Integer parkingNumbers = 10;
        Integer bookedParkingNumbers = 5;
        List<Tower__c> insertTowerList = new List<Tower__c>();
        For(Tower__c singleTower:towerList){
            singleTower.X_of_Single_Parking__c = parkingNumbers;
            singleTower.X_of_Tandem_Parking__c = parkingNumbers;
            singleTower.X_of_Triple_Parking__c = parkingNumbers;
            insertTowerList.add(singleTower);
        }
        upsert insertTowerList;
        
        Map<id,Booking__c> oldCallMap = new Map<id,Booking__c>();
        List<Booking__c> BookingList = [SELECT Property__c,Project__c,Status__c,Search_Term__c,Sales_Head__c,Site_Head__c,CRM_Lead__c,
                                        X_of_Single_Parking__c,X_of_Tandem_Parking__c,X_of_Triple_Parking__c,
                                        Tower__c FROM Booking__c];
        if(!bookinglist.isEmpty()){
            oldCallMap.put(BookingList[0].id, BookingList[0]);
            BookingTriggerHelper.setParking(BookingList,oldCallMap,'Insert');
        }
    }
     static testMethod void callTrigHandMethodUpdate(){
        List<Tower__c> towerList = [SELECT X_of_Single_Parking__c,X_of_Single_Parking_Remaining__c,X_of_Tandem_Parking_Remaining__c,X_of_Triple_Parking_Remaining__c,X_of_Tandem_Parking__c,X_of_Triple_Parking__c FROM Tower__c];
        List<User> testUser = [SELECT Id FROM User];
        Integer parkingNumbers = 10;
        Integer bookedParkingNumbers = 5;
        List<Tower__c> insertTowerList = new List<Tower__c>();
        For(Tower__c singleTower:towerList){
            singleTower.X_of_Single_Parking__c = parkingNumbers;
            singleTower.X_of_Tandem_Parking__c = parkingNumbers;
            singleTower.X_of_Triple_Parking__c = parkingNumbers;
            insertTowerList.add(singleTower);
        }
        upsert insertTowerList;
        
        Map<id,Booking__c> oldCallMap = new Map<id,Booking__c>();
        List<Booking__c> BookingList = [SELECT Property__c,Project__c,Status__c,Search_Term__c,Sales_Head__c,Site_Head__c,CRM_Lead__c,
                                        X_of_Single_Parking__c,X_of_Tandem_Parking__c,X_of_Triple_Parking__c,
                                        Tower__c FROM Booking__c];
         BookingList[0].Status__c = 'Cancelled';
         BookingList[1].Status__c = 'Cancelled';
        if(!bookinglist.isEmpty()){
            oldCallMap.put(BookingList[0].id, BookingList[1]);
            oldCallMap.put(BookingList[1].id, BookingList[0]);
            BookingTriggerHelper.setParking(BookingList,oldCallMap,'Update');
        }
    }
}
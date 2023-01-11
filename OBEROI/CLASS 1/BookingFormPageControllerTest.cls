@isTest
        public class BookingFormPageControllerTest {
            
            @testSetup static void testData(){
                List<Site__c> sList = TestDataFactory.createSite(1);
                insert sList;
                Date todaysDate = Date.today();
                List<Opportunity> opps = TestDataFactory.createOpportunity(1);
                opps[0].Site__c = sList[0].Id;
                insert opps;
                
                List<Property__c> properties = TestDataFactory.createProperties(1);
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
                bookingList[0].Opportunity__c = opps[0].Id;
                bookingList[0].Property__c = properties[0].Id;
                bookingList[0].Project__c = projectList[0].Id;
                bookingList[0].site__c = projectList[0].site__c;
                bookingList[0].Billing_Plan__c = billingPlanList[0].Id;
                Date bookingDate = todaysDate.addDays(-2);
                bookingList[0].Booking_Date__c = bookingDate;
                Id bookingRecordTypeId = Schema.SObjectType.Booking__c.getRecordTypeInfosByName().get('Booking Locked').getRecordTypeId();
                bookingList[0].RecordTypeId = bookingRecordTypeId;
                insert bookingList;
            }     
            static testmethod void SendEmailCustomerDetailPdf1()
            {
                /* Account accountRecord = new Account();
        accountRecord.Name = 'PYN estate';
        accountRecord.AccountNumber = '01235';
        insert accountRecord;
        
        Contact contactObj = new Contact();
        contactObj.firstName = 'test1';
        contactObj.lastname = 'Test';
        contactObj.Account = accountRecord;
        contactObj.PAN__c = '4657676767';
        insert contactObj;
        
        Opportunity opportunityObj = new Opportunity();
        opportunityObj.Name = 'Test Opportunity';
        opportunityObj.Account = accountRecord;
        opportunityObj.StageName = 'Open';  
        opportunityObj.Booking_Amount__c = 1223333;
        opportunityObj.Approval_Status__c = 'Submitted';
        opportunityObj.closeDate = system.today();
        insert opportunityObj;
        
        Integer numberOfBillingPlan = 1;
        list<Payment_Plan__c> billingPlanList= TestDataFactory.createBillingPlan(numberOfBillingPlan);
        billingPlanList[0].Status__c = 'Approved';
        billingPlanList[0].Active__c= true;
        billingPlanList[0].Opportunity__c = opportunityObj.Id; 
        // insert billingPlanList;
        
        
        /*Booking__c bookingNewObj = new Booking__c();
        
        bookingNewObj.Search_Term__c = 'test search';
        bookingNewObj.Opportunity__c = opportunityObj.id;
        bookingNewObj.Primary_Applicant__c  = contactObj.id;
        bookingNewObj.Billing_Plan__c  = billingPlanList[0].id;
        bookingNewObj.Property__c = billingPlanList[0].property__c;
        bookingNewObj.Project__c = billingPlanList[0].project__c;*/
                //insert bookingNewObj;
                Booking__c booking = [Select Id from Booking__c limit 1];
                ApexPages.CurrentPage().getparameters().put('id', booking.id);      
                
                Apexpages.StandardController sc = new Apexpages.StandardController(booking);
                BookingFormPageController ext = new BookingFormPageController(sc); 
            }
            public static testMethod void testAttachPDF(){
                Booking__c booking = [Select Id from Booking__c limit 1];
                PageReference bookingFormPage = Page.BookingFormPage;
                Test.setCurrentPage(bookingFormPage);
                ApexPages.CurrentPage().getparameters().put('id', booking.id);
                Apexpages.StandardController sc = new Apexpages.StandardController(booking);
                BookingFormPageController ext = new BookingFormPageController(sc); 
                ext.attachPDF();
            }
        }
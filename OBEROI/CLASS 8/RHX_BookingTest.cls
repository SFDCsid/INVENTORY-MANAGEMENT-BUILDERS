@isTest
public class RHX_BookingTest {
    
    @isTest
    static void testBookingTest(){
        User usr = TestDataFactory.createUser('ORL Admin', 'MD');
        
        List<Site__c> sList = TestDataFactory.createSite(4);
        insert sList;
        
        List<Opportunity> oppList=TestDataFactory.createOpportunity(4);
        oppList[0].Name = 'Test Opp' + Math.random();
        oppList[0].closeDate = system.Today(); 
        oppList[0].StageName= 'New';
        oppList[0].Site__c =sList[0].id;
        
        oppList[1].Name = 'Test Opp' + Math.random();
        oppList[1].closeDate = system.Today(); 
        oppList[1].StageName= 'New';
        oppList[1].Site__c =sList[1].id;
        
        oppList[2].Name = 'Test Opp' + Math.random();
        oppList[2].closeDate = system.Today(); 
        oppList[2].StageName= 'New';
        oppList[2].Site__c =sList[2].id;
        
        oppList[3].Name = 'Test Opp' + Math.random();
        oppList[3].closeDate = system.Today(); 
        oppList[3].StageName= 'New';
        oppList[3].Site__c =sList[3].id;
        
        insert oppList;
        
        // List<Project__c> projects = TestDataFactory.createResProject(1);
        // insert projects;
        
        Id PrRecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        
        
        List<Project__c> pList = TestDataFactory.createResProject(4);
        
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
        /*v1.1 Start*/
        pList[0].CFO__c =usr.Id/*v1.1 Ends*/;
        
        
        pList[1].Name = 'Sky City';
        pList[1].Plant__c ='767c';
        pList[1].site__c =sList[1].id;
        pList[1].Active__c=true;
        pList[1].Company_name__c='test'; 
        pList[1].recordtypeId= PrRecordTypeId;
        pList[1].Front_Desk_User__c = usr.id;
        pList[1].Marcom_Head__c =usr.Id; 
        pList[1].Sales_Head__c =usr.Id;
        pList[1].Site_Head__c=usr.Id; 
        pList[1].MD__c =usr.Id; 
        pList[1].Marcom_Manager__c = usr.Id; 
        /*v1.1 Start*/
        pList[1].CFO__c =usr.Id/*v1.1 Ends*/;
        
        
        pList[2].Name = 'Prisma';
        pList[2].Plant__c ='767c';
        pList[2].site__c =sList[2].id;
        pList[2].Active__c=true;
        pList[2].Company_name__c='test'; 
        pList[2].recordtypeId= PrRecordTypeId;
        pList[2].Front_Desk_User__c = usr.id;
        pList[2].Marcom_Head__c =usr.Id; 
        pList[2].Sales_Head__c =usr.Id;
        pList[2].Site_Head__c=usr.Id; 
        pList[2].MD__c =usr.Id; 
        pList[2].Marcom_Manager__c = usr.Id; 
        /*v1.1 Start*/
        pList[2].CFO__c =usr.Id/*v1.1 Ends*/;
        
        pList[3].Name = 'Eternia';
        pList[3].Plant__c ='767c';
        pList[3].site__c =sList[3].id;
        pList[3].Active__c=true;
        pList[3].Company_name__c='test'; 
        pList[3].recordtypeId= PrRecordTypeId;
        pList[3].Front_Desk_User__c = usr.id;
        pList[3].Marcom_Head__c =usr.Id; 
        pList[3].Sales_Head__c =usr.Id;
        pList[3].Site_Head__c=usr.Id; 
        pList[3].MD__c =usr.Id; 
        pList[3].Marcom_Manager__c = usr.Id; 
        /*v1.1 Start*/
        pList[3].CFO__c =usr.Id/*v1.1 Ends*/;
        insert pList;
        
        List<Tower__c> towerList = TestDataFactory.createTowers(4);       
        towerList[0].Project_Name__c=pList[0].Id;
        towerList[1].Project_Name__c=pList[1].Id;
        towerList[2].Project_Name__c=pList[2].Id;
        towerList[3].Project_Name__c=pList[3].Id;
        insert towerList;
        
        
        List<Property_Type__c> projectTypeList = TestDataFactory.createProjectType(4);
        projectTypeList[0].Project1__c = pList[0].Id;
        projectTypeList[1].Project1__c = pList[1].Id;
        projectTypeList[2].Project1__c = pList[2].Id;
        projectTypeList[3].Project1__c = pList[3].Id;
        insert projectTypeList;
        
        
        List<Property__c> propertyList=TestDataFactory.createProperties(4);
        propertyList[0].Temporary_Block__c = true;
        propertyList[0].Active__c = true;
        propertyList[0].Block_Comments__c = 'Test';
        propertyList[0].Blocked_By__c = usr.Id;
        propertyList[0].Tower__c = towerList[0].Id;
        propertyList[0].Property_Type__c = projectTypeList[0].Id;
        
        propertyList[1].Temporary_Block__c = true;
        propertyList[1].Active__c = true;
        propertyList[1].Block_Comments__c = 'Test';
        propertyList[1].Blocked_By__c = usr.Id;
        propertyList[1].Tower__c = towerList[1].Id;
        propertyList[1].Property_Type__c = projectTypeList[1].Id;
        
        propertyList[2].Temporary_Block__c = true;
        propertyList[2].Active__c = true;
        propertyList[2].Block_Comments__c = 'Test';
        propertyList[2].Blocked_By__c = usr.Id;
        propertyList[2].Tower__c = towerList[2].Id;
        propertyList[2].Property_Type__c = projectTypeList[2].Id;
        
        propertyList[3].Temporary_Block__c = true;
        propertyList[3].Active__c = true;
        propertyList[3].Block_Comments__c = 'Test';
        propertyList[3].Blocked_By__c = usr.Id;
        propertyList[3].Tower__c = towerList[3].Id;
        propertyList[3].Property_Type__c = projectTypeList[3].Id;
        insert propertyList;
        
        Id CustomBillingRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        
        List<Payment_Plan__c> billingPlanList = TestDataFactory.createBillingPlan(4);
        billingPlanList[0].recordtypeId = CustomBillingRecordTypeId;
        /*billingPlanList[0].opportunity__c = oppList[0].Id;
billingPlanList[0].Property__c=propertyList[0].id;
billingPlanList[0].Active__c = True;
billingPlanList[0].Status__c = 'Approved';
billingPlanList[0].site__c = sList[0].id;   */
        
        
        billingPlanList[1].recordtypeId = CustomBillingRecordTypeId;
        /* billingPlanList[1].opportunity__c = oppList[1].Id;
billingPlanList[1].Property__c=propertyList[1].id;
billingPlanList[1].Active__c = True;
billingPlanList[1].Status__c = 'Approved';
billingPlanList[1].site__c = sList[1].id; */
        
        billingPlanList[2].recordtypeId = CustomBillingRecordTypeId;
        /*billingPlanList[2].opportunity__c = oppList[2].Id;
billingPlanList[2].Property__c=propertyList[2].id;
billingPlanList[2].Active__c = True;
billingPlanList[2].Status__c = 'Approved';
billingPlanList[2].site__c = sList[2].id;*/ 
        
        billingPlanList[3].recordtypeId = CustomBillingRecordTypeId;
        /*billingPlanList[3].opportunity__c = oppList[3].Id;
billingPlanList[3].Property__c=propertyList[3].id;
billingPlanList[3].Active__c = True;
billingPlanList[3].Status__c = 'Approved';
billingPlanList[3].site__c = sList[3].id; */
        
        insert billingPlanList;
        
        System.runAs(usr){
            /*List<Booking__c> bookings = TestDataFactory.createBookings    (1);
bookings[0].site__c = sList[0].id;
bookings[0].opportunity__c = oppList[0].Id;
bookings[0].Property__c=propertyList[0].id;
bookings[0].Project__c=plist[0].id;
insert bookings;*/
            
            Id BookingRecordTypeId = Schema.SObjectType.Booking__c.getRecordTypeInfosByName().get('Booking Locked').getRecordTypeId();
            
            
            List<Booking__c> bookings = TestDataFactory.createBookings(7);
            
            bookings[0].recordtypeId = BookingRecordTypeId;
            bookings[0].Property__c=propertyList[0].id;
            bookings[0].Project__c=pList[0].id;
            bookings[0].Search_Term__c='Test'; 
            bookings[0].site__c = sList[0].id; 
            bookings[0].opportunity__c = oppList[0].Id;
            bookings[0].Tower__c = towerList[0].Id;
            bookings[0].Billing_Plan__c = billingPlanList[0].Id;
            
            bookings[1].recordtypeId = BookingRecordTypeId; 
            bookings[1].Property__c=propertyList[1].id;
            bookings[1].Project__c=pList[1].id;
            bookings[1].Search_Term__c='Test'; 
            bookings[1].site__c = sList[1].id; 
            bookings[1].opportunity__c = oppList[1].Id;
            bookings[1].Tower__c = towerList[1].Id;
            bookings[1].Billing_Plan__c = billingPlanList[1].Id;
            
            bookings[2].recordtypeId = BookingRecordTypeId;
            bookings[2].Property__c=propertyList[2].id;
            bookings[2].Project__c=pList[2].id;
            bookings[2].Search_Term__c='Test'; 
            bookings[2].site__c = sList[2].id; 
            bookings[2].opportunity__c = oppList[2].Id;
            bookings[2].Tower__c = towerList[2].Id;
            bookings[2].Billing_Plan__c = billingPlanList[2].Id;
            
            bookings[3].recordtypeId = BookingRecordTypeId;
            bookings[3].Property__c=propertyList[3].id;
            bookings[3].Project__c=pList[3].id;
            bookings[3].Search_Term__c='Test'; 
            bookings[3].site__c = sList[3].id; 
            bookings[3].opportunity__c = oppList[3].Id;
            bookings[3].Tower__c = towerList[3].Id;
            bookings[3].Billing_Plan__c = billingPlanList[3].Id;
            
            
            bookings[4].Property__c=propertyList[3].id;
            bookings[4].Project__c=pList[3].id;
            bookings[4].Search_Term__c='Test'; 
            bookings[4].site__c = sList[3].id; 
            bookings[4].opportunity__c = oppList[3].Id;
            bookings[4].Tower__c = towerList[3].Id;
            
            bookings[5].Property__c=propertyList[1].id;
            bookings[5].Project__c=pList[1].id;
            bookings[5].Search_Term__c='Test'; 
            bookings[5].site__c = sList[1].id; 
            bookings[5].opportunity__c = oppList[1].Id;
            bookings[5].Tower__c = towerList[1].Id;
            
            bookings[6].Property__c=propertyList[0].id;
            bookings[6].Project__c=pList[0].id;
            bookings[6].Search_Term__c='Test'; 
            bookings[6].site__c = sList[0].id; 
            bookings[6].opportunity__c = oppList[0].Id;
            bookings[6].Tower__c = towerList[0].Id;
            
            insert Bookings;
        }
    }
}
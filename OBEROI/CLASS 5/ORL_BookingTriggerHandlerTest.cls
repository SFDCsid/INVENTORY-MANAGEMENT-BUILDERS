@isTest
public class ORL_BookingTriggerHandlerTest {
   
 
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
        INSERT lstOfProject;
        
        List<Tower__c>lstOfTower = TestDataFactory.createTowers(1);
        lstOfTower[0].Project_Name__c = lstOfProject[0].Id;
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
   
    static testMethod void ORL_SAPInterfaceTriggerHandler_Test1() {
        //createTestData();
        Test.startTest();        
        
        List<SAP_Interface_Log__c> arrList = [SELECT id,Booking__r.Id, Type__c, Status__c, Booking__c, SAP_Message__c, IsParent__c, Description__c, Related_Object__c , Payment_Plan__c FROM SAP_Interface_Log__c];
        ORL_SAPInterfaceTriggerHandler.createSalesOrder(arrList);
        
        List<Booking__c> bookLst = [SELECT id,Sales_Document_SAP__c,Booking_Number_SAP__c FROM Booking__c];
        for(Booking__c booking:bookLst){
            booking.Sales_Document_SAP__c = '1234';
            booking.Booking_Number_SAP__c = '1234';
        }
        UPDATE bookLst;
        
        for(SAP_Interface_Log__c sap:arrList){
            sap.SAP_Message__c = 'Changes have been made';
            sap.Booking__c = bookLst[0].Id; 
            sap.Status__c = 'Success';
            sap.Type__c = 'CustomerUpdateCall';
        }
        
        UPDATE arrList;
        arrList = [SELECT id,Booking__r.Id, Type__c, Status__c, Booking__c, SAP_Message__c, IsParent__c, Description__c, Related_Object__c , Payment_Plan__c, Booking__r.Booking_Number_SAP__c, Booking__r.Sales_Document_SAP__c FROM SAP_Interface_Log__c];
        
        ORL_SAPInterfaceTriggerHandler.updateSalesOrder(arrList);
        
        List<Payment_Plan__c> lstOfBillingPlan = [SELECT id FROM Payment_Plan__c];      
        for(SAP_Interface_Log__c sap:arrList){
            sap.Type__c = 'BillingPlanPullCall';
            sap.Status__c = 'Success';
            sap.SAP_Message__c = 'Pull Operation Completed';
            sap.Description__c = 'Pull Request for Payment Plan';
            sap.Related_Object__c = 'Payment_Plan__c';
            sap.Payment_Plan__c = lstOfBillingPlan[0].Id;
        }
        UPDATE arrList;
        
        arrList = [SELECT id,Booking__r.Id, Type__c, Status__c, Booking__c, SAP_Message__c, IsParent__c, Description__c, Related_Object__c , Payment_Plan__c FROM SAP_Interface_Log__c];
        
        ORL_SAPInterfaceTriggerHandler.createBillingLineItems(arrList);
        
        
        Test.stopTest();
    }
    
    static testMethod void ORL_SAPInterfaceTriggerHandler_Test2() {
         Test.startTest();        
                List<SAP_Interface_Log__c> arrList = [SELECT id,Booking__r.Id, Type__c, Status__c, Booking__c, SAP_Message__c, IsParent__c, Description__c, Related_Object__c , Payment_Plan__c FROM SAP_Interface_Log__c];
        ORL_SAPInterfaceTriggerHandler.createSalesOrder(arrList);
        
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
        booking.Loan_Required__c = 'Yes';
            insert p;
            booking.primary_applicants__C = personAcc100.id;
        }
        UPDATE bookLst;
       
        Test.stopTest();
    }
    
    
    
}
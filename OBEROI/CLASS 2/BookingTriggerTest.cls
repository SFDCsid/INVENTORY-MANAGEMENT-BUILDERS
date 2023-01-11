@isTest
public class BookingTriggerTest {
    @isTest
    public static void method1(){
        Account a=new Account();
        a.LastName='test';
        a.Broker_Code__c='200';
        insert a;
        
        Opportunity oppt = new Opportunity( Name = 'Test Opp' + Math.random(),closeDate = system.Today(), StageName= 'New');
        //oppt.Enquiry_Type__c='Partner';
        insert oppt;
        
        Booking__c b=new Booking__c();
        b.Booking_Date__c=System.today();
        b.Opportunity__c=oppt.id;
        //b.Vendor_Code__c=2;
        b.ROFR_Charges_Amount__c=200;
        b.Offer_Price__c=200;
        b.Amount_Payable_to_Bank__c=200;
        b.Loan_Amount__c=200;
        b.Amount_paid_excl_GST__c = 200;
        b.TDS_amount__c = 200;
        b.balance_payable__c = 200;
        insert b;
    }
    @isTest
    public static void method2(){
        Account ac = new Account(Name = 'Test shubham',Company__c = 'Stetig');
        insert ac;
        Id cpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        
        Account cp = new Account();
        cp.RecordTypeId = cpRecordTypeId;
        CP.Name = 'TEst Cp';
        CP.MAHA_RERA_Registration__c = '1q2w3e4r5t6y7u8';
        CP.Name_1__c = 'TEst Cp';
        CP.PAN_1__c = 'TEstC1234p';
        CP.Email_1__c = 'Email@1.c';
        CP.Mobile_1__c = '9897867564';
        CP.Street__c = 'HN1';
        CP.City__c = 'Pune';
        CP.Street_2__c = 'ST1';
        CP.Region_List__c = 'Maharashtra';
        CP.Street_3__c = 'ST2';
        CP.Country_List__c = 'India';
        CP.Street_4__c = 'ST3';
        CP.Postal_code__c = '414002';
        CP.Locality__c = 'Lo';
        cp.Broker_Code__c = '12345678';
        insert cp;
        
        Opportunity oppt = new Opportunity( Name = 'Test Opp' + Math.random(),closeDate = system.Today(), StageName= 'New');
        oppt.Enquiry_Type__c='Partner';
        oppt.Broker_Account__c=cp.id;
        oppt.AccountId=ac.id;
        insert oppt;
        
        Booking__c b=new Booking__c();
        b.Booking_Date__c=System.today();
        b.Opportunity__c=oppt.id;
        //b.Vendor_Code__c=2;
        b.ROFR_Charges_Amount__c=200;
        b.Offer_Price__c=200;
        b.Amount_Payable_to_Bank__c=200;
        b.Loan_Amount__c=200;
        insert b;
    }
 }
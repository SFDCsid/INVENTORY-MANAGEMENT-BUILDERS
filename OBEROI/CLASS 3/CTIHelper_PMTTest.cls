/****************************************************************************************************
Class covered :
1. CTIHelper_PMT - 7/6/2019 - 84%

****************************************************************************************************/

@isTest(seeAllData=false)
public class CTIHelper_PMTTest {
    static String virtualNumberCalled, callerPhoneCountryCode, callerPhoneNumber;
    static List<Virtual_Number__c> vList;
    @TestSetup
    private static void createTestData() {
        //create site
        Site__c s = new site__c();
        s.name = 'Site12344';
        s.active__C = true;
        insert s;
        
        //create user
        InsertFutureUser.insertUser();
        //user u = [select id from user][0];
        //
        user u = TestDataFactory.createUser('System Administrator', 'MD');
        //create project
        project__c p = new project__c();
        p.name = 'Test Project';
        p.Plant__c = 'Test';
        p.Company_name__c = 'test comp';
        p.Site__c = s.id;
        p.Site_Head__c = u.id;
        p.Front_Desk_User__c = u.id;
        p.MD__c = u.id;
        p.CFO__c = u.id;
        p.Marcom_Head__c = u.id;
        p.Marcom_Manager__c = u.id;
        p.Sales_Head__c = u.id;
        insert p;
        
        campaign c = new campaign();
        c.name = 'Test campaign';
        c.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Advertisement').getRecordTypeId();
        c.StartDate = system.today();
        c.EndDate = system.today()+5;
        c.Project__c = p.id;
        c.Advertisement_Cost__c =300;
        insert c;
       
        vList=new List<Virtual_Number__c>();
        Virtual_Number__c virtualObj=new Virtual_Number__c();
        virtualObj.Name='02268630701';
        virtualObj.Advertisement__c = c.id;
        vList.add(virtualObj);
        
        Virtual_Number__c virtualObj2=new Virtual_Number__c();
        virtualObj2.Name='02268630702';
        
        vList.add(virtualObj2);
        insert vList;
        
        Virtual_Number__c virtualObj1 = [select id,Site_On_Advertisement__c from Virtual_Number__c where id = :virtualObj.id ];
         system.assertEquals('Site12344', virtualObj1.Site_On_Advertisement__c); 
        
        lead l = new lead();
        l.LastName = 'Test';
        l.Site__c = s.id;
        l.Lead_Stage__c = 'Open';
        l.MobilePhone = '9834677833';
        l.Country_Code__c = '+91';
        l.email = 'Test@gmail.com';
        l.Budget__c = '1.5 cr - 2.5 cr';
        l.Status = 'Open';
        //l.Project__c = p.id;
        insert l;
        
        
        
        
        
        
    }
    @istest
    public static void positivetest(){
        CTIHelper_PMT.doPost('02268630701','+91','9834677833');
        
    }
    @istest
    public static void Invalidtest(){
        CTIHelper_PMT.doPost('02268630702','+91','9834677833');
        
    }
    @istest
    public static void Countrycodetest(){
        CTIHelper_PMT.doPost('02268630702','91','9834677833');
        
    }
    
    @istest
    public static void Negativetest(){
        CTIHelper_PMT.doPost('02268630702','91','98346778334');
        
    }
    
}
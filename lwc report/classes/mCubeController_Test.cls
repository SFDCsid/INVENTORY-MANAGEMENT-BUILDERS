@istest 
public class mCubeController_Test {
    @istest
    public static void route(){
         
        Project__c pr = new Project__c();
        pr.name = 'Test';
        insert pr;
        Campaign c = new Campaign();
        c.Project__c = pr.id; 
        c.Name = 'test';
        c.Is_CTI_Campaign__c = true;
        c.IsActive = true;
        insert c;
 
        Lead lead = new Lead();
        lead.lastname = 'Test Lead';
        lead.Company = 'TestCompany';
        lead.Phone = '67878';
        lead.mobilePhone = '2343';
        lead.Email = 'standarduser@testorgfil.com';
        lead.Project__c= [select Project__c from campaign limit 1  ].Project__c;
        insert lead;
        MCUBE_Object_Api__c  m  = new MCUBE_Object_Api__c ();
        m.name = 'lead';
        m.Field_to_Compare_Mobile_Incoming_Number__c = 'Phone ';
        m.field__c = 'FirstName';
        m.field1__c = 'LastName';
        m.field2__c = 'company';
        m.Value__c = 'company';
        m.value1__c = 'company';
        m.value2__c = 'company';
        insert m;
        mCubeController.clickToCall(lead .id);
        mCubeController.clickToCallNumber(string.valueof( lead.id),'2343' );
        mCubeController.readNumbers(string.valueof( lead.id) );
        
    }
 
    @istest
    public static void inboundCalltest(){
         
        Project__c pr = new Project__c();
        pr.name = 'Test';
        insert pr;
        Campaign c = new Campaign();
        c.Project__c = pr.id; 
        c.Name = 'test';
        c.Is_CTI_Campaign__c = true;
        c.IsActive = true;
        insert c;
        
        Lead lead = new Lead();
        lead.lastname = 'Test Lead';
        lead.Company = 'TestCompany';
        lead.Phone = '67878';
        lead.mobilePhone = '2343'; 
        lead.Project__c = pr.id;
        lead.Email = 'standarduser@testorgfil.com';
        insert lead;
        MCUBE_Object_Api__c  m  = new MCUBE_Object_Api__c ();
        m.name = 'lead';
        m.Field_to_Compare_Mobile_Incoming_Number__c = 'mobilePhone ';
        m.field__c = 'FirstName';
        m.field1__c = 'LastName';
        m.field2__c = 'company';
        m.Value__c = 'company';
        m.value1__c = 'company';
        m.value2__c = 'company';
        insert m;
         Profile p = [SELECT Id FROM Profile  limit 1];

        User u = new User(Alias = 'standt12', Email='standarduser@testorgfil.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.123',MobilePhone = '111');
        u.massdialerIds__c = ','+lead.id;
        insert  u;

		account acc=new account();
        acc.FirstName='test';
        acc.LastName='account';
        acc.PersonMobilePhone='23434';
        insert acc;
        
        
        string data = '{\"dialstatus\":\"CONNECTING\",\"endtime\":\"'+system.now()+'\",\"starttime\":\"'+system.now()+'\",\"empnumber\":\"111\",\"callfrom\":\"23434\"}' ;        
        PageReference pageRef = Page.calland;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('data',data);
        mCubeController.inboundCall();
        
        data = '{\"dialstatus\":\"ANSWER\",\"endtime\":\"'+system.now()+'\",\"starttime\":\"'+system.now()+'\",\"empnumber\":\"111\",\"callfrom\":\"1111111\"}' ;        
        ApexPages.currentPage().getParameters().put('data',data);
        mCubeController.inboundCall();
        
        data = '{\"status\":\"ORIGINATE\",\"endtime\":\"'+system.now()+'\",\"starttime\":\"'+system.now()+'\",\"executive\":\"111\",\"customer\":\"1111111\",\"refid\":\"'+lead.id+'\"}' ;        
        ApexPages.currentPage().getParameters().put('data',data);
        mCubeController.inboundCall();
        
        data = '{\"dialstatus\":\"CALL COMPLETE\",\"endtime\":\"'+system.now()+'\",\"starttime\":\"'+system.now()+'\",\"executive\":\"111\",\"customer\":\"1111111\",\"refid\":\"'+lead.id+'\"}' ;        
        ApexPages.currentPage().getParameters().put('data',data);
        mCubeController.inboundCall();
       
		string data1 = '{\"dialstatus\":\"CONNECTING\",\"endtime\":\"'+system.now()+'\",\"starttime\":\"'+system.now()+'\",\"empnumber\":\"111\",\"callfrom\":\"123456\"}' ;        
        PageReference pageRef1 = Page.calland;
        Test.setCurrentPage(pageRef1);
        ApexPages.currentPage().getParameters().put('data',data1);
        mCubeController.inboundCall();
        
    }
    
  }
@isTest
public class Test_Rest_EOIDetailsSend{
    
    @isTest
    public static void scenario1(){
        Site__c s = new Site__c();
        s.Name = 'test';
        s.Active__c = true;
        insert s;
        
        Site__c s1 = new Site__c();
        s1.Name = 'test';
        s1.Active__c = true;
        insert s1;
        
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'test2';
        u.Email = 'test@test.com';
        u.Username = 'test@tstt.com';
        u.MobilePhone = '1234567890';
        u.CommunityNickname = 'testshvbsihv';
        Profile p = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator'];
        u.ProfileId = p.id;
        u.LastName = 'test';
        u.Alias = 'tst';
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.IsActive = True;
        insert u;
        
        Project__c pr = new Project__c();
        pr.Active__c = true;
        pr.Name = 'test';
        pr.Site__c = s.Id;
        pr.CFO__c = u.Id;
        pr.Front_Desk_User__c = u.Id;
        pr.Marcom_Head__c = u.Id;
        pr.Marcom_Manager__c = u.Id;
        pr.MD__c = u.Id;
        pr.Sales_Head__c = u.Id;
        pr.Site_Head__c = u.Id;
        pr.Plant__c = '4788';
        pr.Company_name__c = '4788';
        pr.Amount__c = 1000000;
        insert pr;
        
        EOI__c enq = new EOI__c();
        enq.Applicant_Name_1__c = 'Test';
        enq.Project__c = pr.Id;
        enq.Mobile_No_1__c = '1234567890';
        enq.Email__c = 'test@stetig.in';
        enq.IsPaid__c  = true;
        //enq.UniqueEOInumber__c = 'UP-EOI-001442';
        insert enq;
        
        enq = [select id,name,Applicant_Name_1__c,UniqueEOInumber__c,Email__c,Mobile_No_1__c from EOI__c where Id =: enq.Id];
        
        Rest_EOIDetailsSend.EOIDetails('P-'+ enq.Name);
        
        Rest_EOIDetailsSend.EOIDetails('UP-EOI-001442');
        
        Rest_EOIDetailsSend.EOIDetails('');
            
        }
        
        
      }
//-------------------------------------------//
//  Project: Raunakgroup Developers
//  Created By: Exceller Consultancy
//  Created Date: 26-11-2022
//-------------------------------------------//
@isTest
public class TestDigitalLeadHandlerServices {
    @isTest 
    public static void createfbLead()
    {
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
       
        Account a = new Account ();
        a.FirstName = 'Test';
        a.LastName = 'acc 2';
        a.Phone = '9822341223';
        a.PersonMobilePhone = '9922341223';
        a.Alternate_Email_Id__c = 'acc12@gmail.com';
        a.PersonEmail = 'acc32@gmail.com';
        insert a;
    
        Opportunity_c__c op = new Opportunity_c__c();
        op.Last_Name__c = 'Test Opp'; 
        op.Account_Name__c = a.Id; 
        op.Opportunity_Stage__c = 'Booked';
        op.CloseDate__c = system.today().addDays(30); 
        op.Project__c = p.id;
        insert op;
       
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true;
        c2.Project__c = p.id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.SRD_Code__c = '123';
        c2.Campaign_Type__c =  'TV Plan';
        c2.Media__c = 'Print';
        c2.Status__c = 'Approved';
        insert c2;
        c2.SRD_Code__c = c2.Id;
        update c2;
       
        Digital_Lead__c dl = new Digital_Lead__c();
        dl.Lead_Id__c = '1234';
        dl.Full_Name__c = 'Test fb';
        dl.Form_Id__c = c2.id;
        dl.Mobile__c = '4455667722';
        dl.Email__c = 'test@fb.com';
        dl.Platform__c = 'Facebook';
        insert dl;
        dl.Executed__c = false;
        update dl;
        
        Digital_Lead__c dl1 = new Digital_Lead__c();
        dl1.Lead_Id__c = '12345';
        dl1.Full_Name__c = 'Test fb';
        dl1.Form_Id__c = c2.id;
        dl1.Mobile__c = '4455667722';
        dl1.Email__c = 'test@fb.com';
        dl1.Platform__c = 'Facebook';
        insert dl1;
        
        Digital_Lead__c dl2 = new Digital_Lead__c();
        dl2.Lead_Id__c = '123456';
        dl2.Full_Name__c = 'Test';
        dl2.Form_Id__c = c2.id;
        dl2.Mobile__c = '4455667723';
        dl2.Email__c = 'test@fb1.com';
        dl2.Platform__c = 'Facebook';
        insert dl2;   
    }   
    
     @isTest 
    public static void createfbLead2()
    {
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
      
        Account a = new Account ();
        a.FirstName = 'Test';
        a.LastName = 'acc 2';
        a.Phone = '9822341223';
        a.PersonMobilePhone = '9922341223';
        a.Alternate_Email_Id__c = 'acc12@gmail.com';
        a.PersonEmail = 'acc32@gmail.com';
        a.OwnerId = Userinfo.getUserid();
       insert a;
      
        Account a1 = new Account ();
        a1.FirstName = 'Test';
        a1.LastName = 'acc 2';
        a1.PersonMobilePhone = '9922341223';
        a1.PersonEmail = 'acc32@gmail.com';
        insert a1;
        a1.Phone = '9822341223';
        a1.Alternate_Email_Id__c = 'acc12@gmail.com';
        update a1;
       
        Account a2 = new Account ();
        a2.LastName = 'acc 2';
        a2.PersonMobilePhone = '9001202124';
        a2.Alternate_Email_Id__c = 'acc@gmail.com';
        insert a2;
        a2.Phone = '9822341224';
        a2.PersonEmail = 'acc2@gmail.com';
        update a2;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true;
        c2.Project__c = p.id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.SRD_Code__c = '123';
        c2.Campaign_Type__c =  'TV Plan';
        c2.Media__c = 'Print';
        c2.Status__c = 'Approved';
        c2.Master_Source__c = 'Digital';
        c2.Lead_Source__c = 'Affiliate';
        c2.Lead_Sub_Source__c = 'Mindicator';
        c2.Lead_Sub_Source_Details__c = 'Mindicator Exit';
        insert c2;
        c2.SRD_Code__c = c2.Id;
        update c2;

        Lead_c__c Ld = new Lead_c__c();
        Ld.Last_Name__c  =  'TestLead';
        Ld.Alternate_Mobile_No__c = 'TestLead1@gmail.com';
        Ld.Alternate_Mobile_No__c = '7700112233';
        Ld.Mobile__c = '7700336655';
        Ld.Email__c = 'Testld@gmail.com';
        Ld.Project_Name__c = p.id;
        Ld.Campaign_Custom__c = c2.id;
        insert Ld; 
        
        Opportunity_c__c op = new Opportunity_c__c();
        op.Last_Name__c = 'Test Opp'; 
        op.Account_Name__c = a.Id; 
        op.Opportunity_Stage__c = 'Created';
        op.CloseDate__c = system.today().addDays(30); 
        op.Project__c = p.id;
        op.Campaign_Custom__c = c2.id;
        op.Master_Source__c = 'Digital';
        op.Opportunity_Source__c = 'Affiliate';
        op.Opportunity_Sub_Source__c =  'Mindicator';
        op.Opportunity_Sub_Source_Details__c = 'Mindicator Exit';
        insert op;
     
        Digital_Lead__c dl = new Digital_Lead__c();
        dl.Lead_Id__c = '1234';
        dl.Full_Name__c = 'Test fb';
        dl.Form_Id__c = c2.id;
        dl.Mobile__c = '9822341223';
        dl.Email__c = 'test@fb.com';
        dl.Platform__c = 'Facebook';
        insert dl;
        dl.Executed__c = false;
        update dl;
        
        Digital_Lead__c dl1 = new Digital_Lead__c();
        dl1.Lead_Id__c = '12345';
        dl1.Full_Name__c = 'Test fb';
        dl1.Form_Id__c = c2.id;
        dl1.Mobile__c = '4455667722';
        dl1.Email__c = 'test@fb.com';
        dl1.Platform__c = 'Facebook';
        dl1.Lead_c__c = Ld.id;
        insert dl1;
        
        Digital_Lead__c dl2 = new Digital_Lead__c();
        dl2.Lead_Id__c = '12345';
        dl2.Full_Name__c = 'Test fb';
        dl2.Form_Id__c = c2.id;
        dl2.Mobile__c = '4455667722';
        dl2.Email__c = 'test@fb.com';
        dl2.Platform__c = 'Facebook';
        dl2.Lead_c__c = Ld.id;
        insert dl2;   
       
    } 
    
     @isTest 
    public static void oppcheck()
    {
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        insert p;
      
        Account a = new Account ();
        a.FirstName = 'Test';
        a.LastName = 'acc 2';
        a.Phone = '9822341223';
        a.PersonMobilePhone = '9922341223';
        a.Alternate_Email_Id__c = 'acc12@gmail.com';
        a.PersonEmail = 'acc32@gmail.com';
        a.OwnerId = Userinfo.getUserid();
        insert a;
      
        Account a1 = new Account ();
        a1.FirstName = 'Test';
        a1.LastName = 'acc 2';
        a1.PersonMobilePhone = '9922341223';
        a1.PersonEmail = 'acc32@gmail.com';
        insert a1;
        a1.Phone = '9822341223';
        a1.Alternate_Email_Id__c = 'acc12@gmail.com';
        update a1;
       
        Account a2 = new Account ();
        a2.LastName = 'acc 2';
        a2.PersonMobilePhone = '9001202124';
        a2.Alternate_Email_Id__c = 'acc@gmail.com';
        insert a2;
        a2.Phone = '9822341224';
        a2.PersonEmail = 'acc2@gmail.com';
        update a2;
        
        Campaign__c c2 = new Campaign__c();
        c2.Name = 'Test Project';
        c2.Active__c = true;
        c2.Project__c = p.id;
        c2.Start_Date__c = system.today();
        c2.End_Date__c = system.today().addDays(1);
        c2.Performance_Measure_On__c = 'Daily';
        c2.SRD_Code__c = '123';
        c2.Campaign_Type__c =  'TV Plan';
        c2.Media__c = 'Print';
        c2.Status__c = 'Approved';
        c2.Master_Source__c = 'Digital';
        c2.Lead_Source__c = 'Affiliate';
        c2.Lead_Sub_Source__c = 'Mindicator';
        c2.Lead_Sub_Source_Details__c = 'Mindicator Exit';
        insert c2;
        c2.SRD_Code__c = c2.Id;
        update c2;

        Lead_c__c Ld = new Lead_c__c();
        Ld.Last_Name__c  =  'TestLead';
        Ld.Alternate_Mobile_No__c = 'TestLead1@gmail.com';
        Ld.Alternate_Mobile_No__c = '7700112233';
        Ld.Mobile__c = '7700336655';
        Ld.Email__c = 'Testld@gmail.com';
        Ld.Project_Name__c = p.id;
        Ld.Campaign_Custom__c = c2.id;
        insert Ld;  
      
        Digital_Lead__c dl = new Digital_Lead__c();
        dl.Lead_Id__c = '1234';
        dl.Full_Name__c = 'Test fb';
        dl.Form_Id__c = c2.id;
        dl.Mobile__c = '9822341223';
        dl.Email__c = 'test@fb.com';
        dl.Platform__c = 'Facebook';
        insert dl;
        dl.Executed__c = false;
        update dl;
        
        Digital_Lead__c dl1 = new Digital_Lead__c();
        dl1.Lead_Id__c = '12345';
        dl1.Full_Name__c = 'Test fb';
        dl1.Form_Id__c = c2.id;
        dl1.Mobile__c = '4455667722';
        dl1.Email__c = 'test@fb.com';
        dl1.Platform__c = 'Facebook';
        dl1.Lead_c__c = Ld.id;
        insert dl1;
        
        Digital_Lead__c dl2 = new Digital_Lead__c();
        dl2.Lead_Id__c = '12345';
        dl2.Full_Name__c = 'Test fb';
        dl2.Form_Id__c = c2.id;
        dl2.Mobile__c = '4455667722';
        dl2.Email__c = 'test@fb.com';
        dl2.Platform__c = 'Facebook';
        dl2.Lead_c__c = Ld.id;
        insert dl2;   
       
    }   
}
@isTest
Public Class Test_CP_Create_Update{
    Public static User dummyUser =createUser('ORL Admin', 'CFO_Director');
    Public static User FrontDesk =createUser('Front Desk','' );
    public static User createUser(String profileName, String roleName){
        Integer randomNumber = Integer.valueof((Math.random() * 100));
        UserRole role;
        
        if(!String.isBlank(roleName)){
            role = [SELECT Id FROM UserRole WHERE DeveloperName =: roleName LIMIT 1];
            if(role == null){
                role = new UserRole(DeveloperName = roleName, Name = roleName);
                INSERT role;
            }
        }
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name =: profileName].Id,
            LastName = 'last',
            Email = 'Oberoi'+randomNumber+'@test.com',
            Username = 'Oberoi'+randomNumber+'@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        
        if(role != null)
            u.UserRoleId = role.Id;
        
        Profile pro = [SELECT Id FROM Profile WHERE Name=:'System Administrator'];
        User admin = [SELECT id, NAme FROM USer where profileId =: pro.ID AND isActive=: true LIMIT 1];
        system.runAs(admin){
            INSERT u;
            //CFO =createUser('ORL Admin', 'CFO_Director'); 
        }  
        return u;
    }
    @isTest
    Public static void CP_Create_Update(){
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
        
        Account cp2 = new Account();
        cp2.RecordTypeId = cpRecordTypeId;
        CP2.Name = 'TEst Cp';
        CP2.MAHA_RERA_Registration__c = '1q2w3e4r5t6y7u8';
        CP2.Name_1__c = 'TEst Cp';
        CP2.PAN_1__c = 'TEstC1234p';
        CP2.Email_1__c = 'Email@1.c';
        CP2.Mobile_1__c = '9897867564';
        CP2.Street__c = 'HN1';
        CP2.City__c = 'Pune';
        CP2.Street_2__c = 'ST1';
        CP2.Region_List__c = 'Maharashtra';
        CP2.Street_3__c = 'ST2';
        CP2.Country_List__c = 'India';
        CP2.Street_4__c = 'ST3';
        CP2.Postal_code__c = '414002';
        CP2.Locality__c = 'Lo';
        //cp2.Broker_Code__c = '12345678';
        insert cp2;
        
        Account cp3 = new Account();
        cp3.RecordTypeId = cpRecordTypeId;
        CP3.Name = 'TEst Cp';
        //cp2.Broker_Code__c = '12345678';
        insert cp3;
        
        SAP_Credentials_Master__c SCM = New SAP_Credentials_Master__c();
        SCM.Name = 'CP Creation';
        SCM.URL__c = 'http://110.173.186.14:8003/zsfdcapi/broker_create?sap-client=100';
        SCM.User_ID__c = 'Stetig';
        SCM.Password__c = 'Stetig#2021';
        Insert SCM;
        
        SAP_Credentials_Master__c SCM2 = New SAP_Credentials_Master__c();
        SCM2.Name = 'CP Update';
        SCM2.URL__c = 'http://110.173.186.14:8003/zsfdcapi/broker_change?sap-client=100';
        SCM2.User_ID__c = 'Stetig';
        SCM2.Password__c = 'Stetig#2021';
        Insert SCM2;
        
        Site__c st = new Site__c( Name = 'Test site' + Math.random());
        insert st;

        Project__c prj = new Project__c(
        Name = 'Elysian Tower A',Plant__c ='767c',
        CFO__c = UserInfo.getUserId(),Company_name__c='test',
        Front_Desk_User__c = UserInfo.getUserId(),site__c =st.id,
        Marcom_Head__c = UserInfo.getUserId(),
        Marcom_Manager__c = UserInfo.getUserId(),
        Sales_Head__c =UserInfo.getUserId(),Site_Head__c=UserInfo.getUserId(), MD__c =UserInfo.getUserId());
        insert prj;
        
        Project__c prj2 = new Project__c(
        Name = 'Elysian Tower A',Plant__c ='767c',
        CFO__c = UserInfo.getUserId(),Company_name__c='test',
        Front_Desk_User__c = UserInfo.getUserId(),site__c =st.id,
        Marcom_Head__c = UserInfo.getUserId(),
        Marcom_Manager__c = UserInfo.getUserId(),
        Sales_Head__c =UserInfo.getUserId(),Site_Head__c=UserInfo.getUserId(), MD__c =UserInfo.getUserId());
        insert prj2;
        
        Channel_Partner_Project__c CPProj = new Channel_Partner_Project__c ();
        CPProj.Account__c = cp.id;
        CPProj.Project__c = prj.id ;
        //CPProj.Extended__c = True ;       
        insert CPProj; 
        
        Channel_Partner_Project__c CPProj2 = new Channel_Partner_Project__c ();
        CPProj2.Account__c = cp2.id;
        CPProj2.Project__c = prj2.id ;
        CPProj2.Extended__c = True ;       
        insert CPProj2; 
        
        Test.StartTest();
        PageReference pageRef = Page.CP_Create_Update;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id',String.valueOf(cp.Id));
        pageRef.getParameters().put('action','Update');
        CP_Create_Update ccp = new CP_Create_Update();
        ccp.process();
        ccp.BackToAccount();
        
        PageReference pageRef2 = Page.CP_Create_Update;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('Id',String.valueOf(cp.Id));
        pageRef2.getParameters().put('action','Create');
        CP_Create_Update ccp2 = new CP_Create_Update();
        ccp2.process();
        ccp2.BackToAccount();
        
        PageReference pageRef3 = Page.CP_Create_Update;
        Test.setCurrentPage(pageRef3);
        pageRef3.getParameters().put('Id',String.valueOf(cp2.Id));
        pageRef3.getParameters().put('action','Update');
        CP_Create_Update ccp3 = new CP_Create_Update();
        ccp3.process();
        ccp3.BackToAccount();
        
        PageReference pageRef4 = Page.CP_Create_Update;
        Test.setCurrentPage(pageRef4);
        pageRef4.getParameters().put('Id',String.valueOf(cp2.Id));
        pageRef4.getParameters().put('action','Create');
        CP_Create_Update ccp4 = new CP_Create_Update();
        ccp4.process();
        ccp4.BackToAccount();
        
        PageReference pageRef5 = Page.CP_Create_Update;
        Test.setCurrentPage(pageRef5);
        pageRef5.getParameters().put('Id',String.valueOf(cp3.Id));
        pageRef5.getParameters().put('action','Create');
        CP_Create_Update ccp5 = new CP_Create_Update();
        ccp5.process();
        ccp5.BackToAccount();
        
        PageReference pageRef6 = Page.CP_Create_Update;
        Test.setCurrentPage(pageRef6);
        pageRef6.getParameters().put('Id',String.valueOf(cp3.Id));
        pageRef6.getParameters().put('action','Update');
        CP_Create_Update ccp6 = new CP_Create_Update();
        ccp6.process();
        ccp6.BackToAccount();
        ccp6.Dummy();

        test.StopTest();
    }
}
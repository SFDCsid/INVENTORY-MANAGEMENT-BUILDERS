@isTest
Public Class Test_EOIUnblockCheckTrg{
    Public static User dummyUser =createUser('System Administrator', 'CFO_Director');
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
    public static void EOIUnblockCheck(){
        Account ac = new Account(Name = 'Test Bhagyashri',Company__c = 'Stetig');
        insert ac;
        
        Opportunity o = new Opportunity();
        o.Name = 'Capt Spiderman Test';
        o.Enquiry_Type__c = 'Partner';
        o.AccountId = ac.Id;
        o.Partner_s_Office_Address__c = 'Partner Address';
        o.Nationality__c = 'Indian';
        o.OwnerId = UserInfo.getUserId();
        o.Referred_Project__c = 'Elysian';
        o.Referred_By__c = 'Vikas Sir';
        o.Referred_Tower__c = 'A';
        o.Referred_Flat__c = '36';
        o.Referred_EMP_code__c = '12345';
        o.StageName = 'New';
        o.CloseDate = System.today();
        insert o;
        
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
        
        Tower__c tw = new Tower__c(Tower_Name__c = 'A',Project_Name__c=prj.Id);
        insert tw;
        
        Property_Type__c PropertyType = new Property_Type__c(
        Material_No__c = '1239996'+string.valueOf(1),Project1__c= prj.Id,Description__c='TestPropertyType');
        Insert PropertyType;
        
        Property__c prop1 = new Property__c(
        Property_Type__c=PropertyType.id,Status__c = 'EOI Blocked',EOI_Blocked_By__c = UserInfo.getUserId(), Material_No__c = '99999'+string.valueOf(5));
        insert prop1;
        
        prop1.Status__c = 'Available';
        Update prop1;
        
    }
}
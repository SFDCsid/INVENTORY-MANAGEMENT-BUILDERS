@isTest
public class Test_SO_Change {
    
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
        }  
        return u;
    }
    @isTest
    Public static void SO_Change_Controller(){
               
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Test12',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Test Komal',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id,OwnerId = UserInfo.getUserId());
        insert opp;
        
        BillingPlanLineItemGroupingController.createBillingLineItemsFuture(dataMap.get('BILLING_PLAN'));
        Id unitId = dataMap.get('PROPERTY');
        Id projectId = dataMap.get('PROJECT');
        Id proprtyId = dataMap.get('PROPERTY_TYPE');
        Id towerId = dataMap.get('TOWER');
        Id planId = dataMap.get('BILLING_PLAN');
        
        PageReference pageRef = Page.Quotation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('unitId', unitId);
        pageRef.getParameters().put('oppId', opp.Id);
        
        Property__c property = Quotation.getProperty(unitId);
        Opportunity op = Quotation.getOpportunity(opp.Id);
        
        List<QuotationManagmentServices.AdditionalChargesWrapper> additionalCharges = Quotation.getAdditionChargsList(proprtyId);
        string othercharges_serialize = JSON.serialize(additionalCharges);
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, false, 0);
        
        string sap_serialize = JSON.serialize(SAPChrges);

        List<QuotationManagmentServices.PlanDetailsWrapper> planDetails = Quotation.getPlanDetail(sap_serialize,planId,unitId);
        string planDetails_serialize = JSON.serialize(planDetails);
        
        string discountList_serialize = '[]'; // = JSON.serialize(discountList);
        string carParKList = '[]'; //= '["TANDEM",1,100000]'; 
        string fieldSet = '[{"label":"unitId","value":"' + unitId +'"},{"label":"editschedule","value":false},{"label":"oppId","value":"' + opp.id +'"},{"label":"additionalComments","value":""},{"label":"selectedPlan","value":"' + planId + '"},{"label":"changeInSource","value":false},{"label":"revisedBookingSource","value":null},{"label":"referredBy","value":null},{"label":"referProject","value":null},{"label":"referTower","value":null},{"label":"referFlat","value":null},{"label":"referEmpCode","value":null}]';
        string qId = Quotation.saveQuotation(sap_serialize, othercharges_serialize, discountList_serialize, planDetails_serialize, carParKList, fieldSet);
        
        string st1 = QuotationManagmentServices.INFormat(10);
        
        NOC_Bank_Mapping__c bm = New NOC_Bank_Mapping__c();
        bm.bank_code__c = '01';   
        bm.Name = 'Punjab National Bank';
        insert bm; 
        
        Flat_Status_Mapping__c fm = New Flat_Status_Mapping__c();
        fm.Flat_Status_Code__c = '1';
        fm.name = 'Unfurnished';
        insert fm; 
                     
        Booking__c b = new Booking__C();
        b.Site_Support__c = UserInfo.getUserId();
        b.Project__c = projectId;
        b.Opportunity__c = opp.id;
        b.Sales_Document_SAP__c = '0671900376';
        b.Provisional_NOC_Bank_Name__c = 'Punjab National Bank';
        b.Market_Value__c = 27790134;
        b.Stampduty_Charges__c = 1800000;
        b.NOC_Date__c = system.today();
        b.MNOC_date__c = system.today();
        b.Allotment_Date__c = system.today();
        b.Agreement_Date__c = system.today();
        b.Registration_Date__c = system.today();
        b.Registration_Serial_Number__c = '1234ASDWE12@12';
        b.Loan_Amount__c = 10000;
        b.LOAN_ROI__c = '100';
        b.Loan_Tenure__c = '5M';
        b.Parallel_Funding__c = true;
        b.LL_NOC_DATE__c = system.today();
        b.LL_Noc_Period__c = '10M';
        b.Per_Month_Rent__c = 1800;
        b.Security_Deposit__c = 4000;
        b.Flat_Status__c = 'Unfurnished';
        b.Possession_Date__c = system.today();
        b.Possession_Done__c = true;
        b.Scheme_Change_Date__c = system.today();
        
        b.Booking_Date__c = system.today();
        //b.Acceptance_Form_Template__c = 'Acceptance_Form';
        b.Status__c = 'Booking In Process';
        b.Future_Correspondence_Contact_Email__c = 'Email@gmail.com';
        if(qId!=null){
           if(qId.contains(',')){
               qId = qId.substring(0, qId.lastIndexOf(','));
           }
           b.Quotation__c = qId;  
        }
        b.Default_Address_of__c = '1st Applicant';
        b.Tower__c = towerId;
        b.Property__c = unitId;
        b.Customer_Code__c = '0033500184';
        b.Token_Amount_Clearence__c = false;
        b.Registration_Process_Email__c = false;
        b.RM_User__c = UserInfo.getUserId();
        b.Central_Support__c = UserInfo.getUserId();
        b.AR_Support__c = UserInfo.getUserId();        
        insert b;   
                
        SAP_Credentials_Master__c SCM = New SAP_Credentials_Master__c();
        SCM.Name = 'Sales Order Creation';
        SCM.URL__c = 'http://110.173.186.14:8003/zsfdcapi/broker_ext?sap-client=100';
        SCM.User_ID__c = 'Stetig';
        SCM.Password__c = 'Stetig@1';
        Insert SCM;
        
        Rest_PUT_SAP_Sales_Order_Updation r = new Rest_PUT_SAP_Sales_Order_Updation();
        system.assertEquals(r.SO_NUMBER,NULL);
        System.assertEquals(r.DOC_TYPE,NULL);
        System.assertEquals(r.VKORG, Null);
        System.assertEquals(r.VTWEG , Null);
        System.assertEquals(r.SPRAT, Null);
        System.assertEquals(r.CUST_REF_NO, Null);
        System.assertEquals(r.CUST_REF_DATE, Null);
        System.assertEquals(r.PROJECT_ID, Null);
        System.assertEquals(r.TOWER, Null);
        System.assertEquals(r.KUNNR, Null);  
        System.assertEquals(r.LIFNR, Null);
        System.assertEquals(r.BROKER_PERCENT, Null);
        System.assertEquals(r.ORDER_REASON, Null);
        system.assertEquals(r.NOC_BANK_NAME,NULL);
        system.assertEquals(r.MARKET_VALUE,NULL);
        system.assertEquals(r.STAMP_DUTY,NULL);
        system.assertEquals(r.NOC_DATE,NULL);
        system.assertEquals(r.MNOC_DATE,NULL);
        system.assertEquals(r.ALLOTMENT_DATE,NULL);
        system.assertEquals(r.AGREEMENT_DATE,NULL);      
        system.assertEquals(r.REG_DATE,NULL);
        System.assertEquals(r.SFDC_ID, Null);
        System.assertEquals(r.NET_VALUE, Null);
        System.assertEquals(r.TAX, Null);
        System.assertEquals(r.SALE_VALUE, Null);
        System.assertEquals(r.POSNR, Null);
        System.assertEquals(r.MATNR, Null);
        System.assertEquals(r.ZMENG, Null);
        System.assertEquals(r.ZIEME, Null);
        System.assertEquals(r.KWMENG, Null);
        System.assertEquals(r.MLSTN, Null);
        System.assertEquals(r.ZTERM, Null);
        system.assertEquals(r.REG_SR_NO,NULL);  
        system.assertEquals(r.LOAN_AMOUNT,NULL);
        system.assertEquals(r.LOAN_ROI,NULL);
        system.assertEquals(r.LOAN_TENURE,NULL);  
        system.assertEquals(r.PARALLEL_FUNDING,NULL);
        system.assertEquals(r.LL_NOC_DATE,NULL);        
        system.assertEquals(r.LL_NOC_PERIOD,NULL);
        system.assertEquals(r.PER_MONTH_RENT,NULL);
        system.assertEquals(r.SECURITY_DEPOSIT,NULL);  
        system.assertEquals(r.FLAT_STATUS,NULL);
        system.assertEquals(r.POSS_DATE,NULL);  
        system.assertEquals(r.POSS_DONE,NULL);
        system.assertEquals(r.SCHEME_CHANGE_DATE,NULL);  
        system.assertEquals(r.ITEM_NUMBER ,NULL);  
        system.assertEquals(r.COND_TYPE ,NULL);  
        system.assertEquals(r.COND_RATE ,NULL);  
        system.assertEquals(r.FPLNR ,NULL);  
        system.assertEquals(r.FPLTR ,NULL);  
        
        Test.StartTest();
        PageReference pageRef2 = Page.SO_Change_Vf;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('Id',b.Id);
        SO_Change_Controller SO = new SO_Change_Controller();
        SO.SOChange();
        SO.BackToBooking();
        Test.StopTest();                
    }
    
    @isTest
    Public static void SO_Change_Controller2(){
               
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Account ac = new Account(firstName = 'Test12',lastName='test', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
                     personEmail = 'handsome@stetig.in', personMobilePhone = '1111122222');
        insert ac;
        
        Opportunity opp = new Opportunity(Name = 'Test Komal',StageName = 'New',CloseDate = System.today().AddDays(15),
                                         AccountId = ac.id,OwnerId = UserInfo.getUserId());
        insert opp;
        
        BillingPlanLineItemGroupingController.createBillingLineItemsFuture(dataMap.get('BILLING_PLAN'));
        Id unitId = dataMap.get('PROPERTY');
        Id projectId = dataMap.get('PROJECT');
        Id proprtyId = dataMap.get('PROPERTY_TYPE');
        Id towerId = dataMap.get('TOWER');
        Id planId = dataMap.get('BILLING_PLAN');
        
        PageReference pageRef = Page.Quotation;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('unitId', unitId);
        pageRef.getParameters().put('oppId', opp.Id);
        
        Property__c property = Quotation.getProperty(unitId);
        Opportunity op = Quotation.getOpportunity(opp.Id);
        
        List<QuotationManagmentServices.AdditionalChargesWrapper> additionalCharges = Quotation.getAdditionChargsList(proprtyId);
        string othercharges_serialize = JSON.serialize(additionalCharges);
        
        List<QuotationManagmentServices.SAPPricingWrapper> SAPChrges = Quotation.getSAPPricingList(unitId, false, 0);
        
        string sap_serialize = JSON.serialize(SAPChrges);

        List<QuotationManagmentServices.PlanDetailsWrapper> planDetails = Quotation.getPlanDetail(sap_serialize,planId,unitId);
        string planDetails_serialize = JSON.serialize(planDetails);
        
        string discountList_serialize = '[]'; // = JSON.serialize(discountList);
        string carParKList = '[]'; //= '["TANDEM",1,100000]'; 
        string fieldSet = '[{"label":"unitId","value":"' + unitId +'"},{"label":"editschedule","value":false},{"label":"oppId","value":"' + opp.id +'"},{"label":"additionalComments","value":""},{"label":"selectedPlan","value":"' + planId + '"},{"label":"changeInSource","value":false},{"label":"revisedBookingSource","value":null},{"label":"referredBy","value":null},{"label":"referProject","value":null},{"label":"referTower","value":null},{"label":"referFlat","value":null},{"label":"referEmpCode","value":null}]';
        string qId = Quotation.saveQuotation(sap_serialize, othercharges_serialize, discountList_serialize, planDetails_serialize, carParKList, fieldSet);
        
        string st1 = QuotationManagmentServices.INFormat(10);
        
        NOC_Bank_Mapping__c bm = New NOC_Bank_Mapping__c();
        bm.bank_code__c = '01';   
        bm.Name = 'Punjab National Bank';
        insert bm; 
        
        Flat_Status_Mapping__c fm = New Flat_Status_Mapping__c();
        fm.Flat_Status_Code__c = '1';
        fm.name = 'Unfurnished';
        insert fm; 
                     
        Booking__c b = new Booking__C();
        b.Site_Support__c = UserInfo.getUserId();
        b.Project__c = projectId;
        b.Opportunity__c = opp.id;
        b.Sales_Document_SAP__c = '0671900376';
            
        b.Booking_Date__c = system.today();
        b.Status__c = 'Booking In Process';
        b.Future_Correspondence_Contact_Email__c = 'Email@gmail.com';
        if(qId!=null){
           if(qId.contains(',')){
               qId = qId.substring(0, qId.lastIndexOf(','));
           }
           b.Quotation__c = qId;  
        }
        b.Default_Address_of__c = '1st Applicant';
        b.Tower__c = towerId;
        b.Property__c = unitId;
        b.Customer_Code__c = '0033500184';
        b.Token_Amount_Clearence__c = false;
        b.Registration_Process_Email__c = false;
        b.RM_User__c = UserInfo.getUserId();
        b.Central_Support__c = UserInfo.getUserId();
        b.AR_Support__c = UserInfo.getUserId();
        insert b;   
              
        SAP_Credentials_Master__c SCM = New SAP_Credentials_Master__c();
        SCM.Name = 'Sales Order Creation';
        SCM.URL__c = 'http://110.173.186.14:8003/zsfdcapi/broker_ext?sap-client=100';
        SCM.User_ID__c = 'Stetig';
        SCM.Password__c = 'Stetig@1';
        Insert SCM;
        
        Rest_PUT_SAP_Sales_Order_Updation r = new Rest_PUT_SAP_Sales_Order_Updation();
        system.assertEquals(r.SO_NUMBER,NULL);
        System.assertEquals(r.DOC_TYPE,NULL);
        System.assertEquals(r.VKORG, Null);
        System.assertEquals(r.VTWEG , Null);
        System.assertEquals(r.SPRAT, Null);
        System.assertEquals(r.CUST_REF_NO, Null);
        System.assertEquals(r.CUST_REF_DATE, Null);
        System.assertEquals(r.PROJECT_ID, Null);
        System.assertEquals(r.TOWER, Null);
        System.assertEquals(r.KUNNR, Null);  
        System.assertEquals(r.LIFNR, Null);
        System.assertEquals(r.BROKER_PERCENT, Null);
        System.assertEquals(r.ORDER_REASON, Null);
        system.assertEquals(r.NOC_BANK_NAME,NULL);
        system.assertEquals(r.MARKET_VALUE,NULL);
        system.assertEquals(r.STAMP_DUTY,NULL);
        system.assertEquals(r.NOC_DATE,NULL);
        system.assertEquals(r.MNOC_DATE,NULL);
        system.assertEquals(r.ALLOTMENT_DATE,NULL);
        system.assertEquals(r.AGREEMENT_DATE,NULL);      
        system.assertEquals(r.REG_DATE,NULL);
        System.assertEquals(r.SFDC_ID, Null);
        System.assertEquals(r.NET_VALUE, Null);
        System.assertEquals(r.TAX, Null);
        System.assertEquals(r.SALE_VALUE, Null);
        System.assertEquals(r.POSNR, Null);
        System.assertEquals(r.MATNR, Null);
        System.assertEquals(r.ZMENG, Null);
        System.assertEquals(r.ZIEME, Null);
        System.assertEquals(r.KWMENG, Null);
        System.assertEquals(r.MLSTN, Null);
        System.assertEquals(r.ZTERM, Null);
        system.assertEquals(r.REG_SR_NO,NULL);  
        system.assertEquals(r.LOAN_AMOUNT,NULL);
        system.assertEquals(r.LOAN_ROI,NULL);
        system.assertEquals(r.LOAN_TENURE,NULL);  
        system.assertEquals(r.PARALLEL_FUNDING,NULL);
        system.assertEquals(r.LL_NOC_DATE,NULL);        
        system.assertEquals(r.LL_NOC_PERIOD,NULL);
        system.assertEquals(r.PER_MONTH_RENT,NULL);
        system.assertEquals(r.SECURITY_DEPOSIT,NULL);  
        system.assertEquals(r.FLAT_STATUS,NULL);
        system.assertEquals(r.POSS_DATE,NULL);  
        system.assertEquals(r.POSS_DONE,NULL);
        system.assertEquals(r.SCHEME_CHANGE_DATE,NULL);  
        system.assertEquals(r.ITEM_NUMBER ,NULL);  
        system.assertEquals(r.COND_TYPE ,NULL);  
        system.assertEquals(r.COND_RATE ,NULL);  
        system.assertEquals(r.FPLNR ,NULL);  
        system.assertEquals(r.FPLTR ,NULL);  
        
        Test.StartTest();
        PageReference pageRef2 = Page.SO_Change_Vf;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('Id',b.Id);
        SO_Change_Controller SO = new SO_Change_Controller();
        SO.SOChange();
        SO.BackToBooking();
        Test.StopTest();                
    }
    
   
}
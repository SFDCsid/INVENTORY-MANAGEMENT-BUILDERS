@isTest
private  Class TestDBUtilityV2  {

  @isTest
        private static void SMSTest() {
        
        DBUtilityV2.ObjectList();
        List<String>  objList = new List<String>();
        /*Vendor__c vend = new Vendor__c();
        vend.Name = 'testsms';
        vend.Vendor_URL__c = 'https://enterprise.smsgupshup.com/GatewayAPI/rest';
        vend.Vendor_Status__c = true;
        vend.Param_1_Name__c = 'msg';
        vend.Param_1_Status__c = true;
        vend.Param_3_Name__c = 'userid';
        vend.Param_3_Status__c = true;
        vend.Param_3_Value__c = '2000164600';
        vend.Param_5_Name__c = 'send_to';
        vend.Param_5_Status__c = true;
        vend.Param_7_Name__c = 'msg_type';
        vend.Param_7_Status__c  = true;
        vend.Param_7_Value__c = 'text';
        vend.Param_2_Name__c = 'v';
        vend.Param_2_Status__c = true;
        vend.Param_2_Value__c = '1.1';
        vend.Param_4_Name__c = 'password';
        vend.Param_4_Status__c = true;
        vend.Param_4_Value__c = 'abc123';
        vend.Param_6_Status__c = true;
        vend.Param_6_Value__c = 'ndnd';
        vend.Param_8_Name__c = 'method';
        vend.Param_8_Status__c = true;
        vend.Param_8_Value__c = 'sendMessage';
        insert vend;*/
        objList.add('Account');
        objList.add('Project__c');
        DbUtilityV2.saveTemplate('Lead', 
                            'Hello {!Lead.Salutation} . {!Lead.Name}. Thank you for your interest in {!Lead.Project__r.Name}. The site address is  You can see the site head {!Lead.Project__r.Site_Head__r.Name}, when you get there :)',
                            'Say Hello to Lead');
         Lead l = createLeadTemplateF('SMS Test Lead', 'smstest@gmail.com','9009900901','1110001111', true);
     //   l.OpportunityProject__c = p.Id;
        DbUtilityV2.getFields(objList);
        Test.startTest();
        PageReference pRef = Page.PreviewSMSPage;
        Test.setCurrentPage(pRef);
        ApexPages.currentPage().getParameters().put('Id',l.Id);
        ApexPages.currentPage().getParameters().put('mob',l.mobilePhone);
        DBUtilityV2 db = new DBUtilityV2();
        List<SMS_Template__c> ls = db.getTempl;
        db.templateid = ls[0].Id;
        db.preview();
        db.send();
        Test.stopTest();
    }
    
       public static Lead createLeadTemplateF(String lastName, String email, String mobile, String altMobile, Boolean isMaster) {
            Lead l = new Lead(lastName= lastName, Email= email , mobilePhone= mobile, phone= altMobile, Lead_Stage__c = 'Open');
            insert l;
            return l;  
    }

               
         
 }
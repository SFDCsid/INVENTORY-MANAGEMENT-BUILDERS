global class registerPageController {
    public EOI__c e{get;set;}
    public List<Pincode__c> pincodeL{get;set;} 
    Public String OTPNumber {get;set;}
    Public String otp {get;set;}
    Public Boolean showOTPField {get;set;}
    Public Boolean showSendButton {get;set;}
    Public Boolean showResendOTP {get;set;}
    Public Integer seconds {get;set;}
    Public String Buttonname {get;set;}
    Public Boolean showSubmitButton {get;set;}
    Public Boolean startTimer {get;set;}
    Public String OTPtext {get;set;}
    Public String Error {get;set;}
    Public Boolean showPayButton {get;set;}
    Public String merchantTxnNo {get;set;}
    Public Decimal amount {get;set;}
    Public String customerEmailId {get;set;}
    Public String customerMobileNo {get;set;}
    Public Boolean savebutton {get;set;}
    Public Boolean showSkipButton {get;set;}
    Public String phone {get;set;}
    Public String custCat {get;set;}
    Public String resStat {get;set;}
    Public String occup {get;set;}
    Public String cpsa1 {get;set;}
    Public String aoc1 {get;set;}
    Public String hdwcy1 {get;set;}
    Public String hdyhau1 {get;set;}
    Public String budget1 {get;set;}
    Public String ca1 {get;set;}
    Public String req {get;set;}
    Public String sob1 {get;set;}
    Public String projs {get;set;}
    Public String appn {get;set;}
    Public String city {get;set;}
    Public String pincode {get;set;}
    Public String custMob {get;set;}
    Public String contpername {get;set;}
    Public String contperde {get;set;}
    Public String contpermob {get;set;}
    Public String email {get;set;}
    Public String street {get;set;}
    Public Boolean sb {get;set;}
    Public Boolean validate1 {get;set;}
    Public Boolean tc {get;set;}
    Public String phone2 {get;set;}
    Public String telres {get;set;}
    Public String teloff {get;set;}
    Public String contpertel {get;set;}
    Public String parttel {get;set;}
    Public String partmob {get;set;}
    Public Boolean ap2 {get;set;}
    Public Boolean ap3 {get;set;}
    Public Boolean ap4 {get;set;}
    Public Boolean ap5 {get;set;}
    Public String mid {get;set;}
    Public String key {get;set;}
    Public EOI__c eo {get;set;}
    Public String txnDate {get;set;}
    public String pincode1 {get;set;}
    public String SelectedPincodeid {get;set;}
    public String locality {get;set;}
    public String city1 {get;set;}
    public String state {get;set;}
    public String country {get;set;}
    
    public List<SelectOption> getdynamiclist() {
        List<Project__c> proList = [SELECT Id,Name FROM Project__c Where IsAvailableforEOI__c =: true];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Please select project','Please select project'));
        for(Project__c pro:proList){
            
            options.add(new SelectOption(pro.id,pro.Name));    
            
        }
        return options;
    }     
    public List<SelectOption> getResidenceStatuslist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Indian','Indian'));
        options.add(new SelectOption('NRI','NRI'));
        return options;
    }
    public List<SelectOption> getOccupationlist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Business','Business'));
        options.add(new SelectOption('Service','Service'));
        options.add(new SelectOption('Professional','Professional'));
        options.add(new SelectOption('Others','Others'));
        return options;
    }
    public List<SelectOption> getContactPersonlist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }
    public List<SelectOption> getCustomerCategorylist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('End User','End User'));
        options.add(new SelectOption('Investor','Investor'));
        options.add(new SelectOption('Second Home','Second Home'));
        return options;
    }
    public List<SelectOption> getHowdowecontactyoulist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Residence No.','Residence No.'));
        options.add(new SelectOption('Mobile','Mobile'));
        options.add(new SelectOption('Email','Email'));
        options.add(new SelectOption('Office No.','Office No.'));
        return options;
    }
    public List<SelectOption> getAddressofcorrespondencelist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Residence Address','Residence Address'));
        options.add(new SelectOption('Office Address','Office Address'));
        return options;
    }
    public List<SelectOption> getHowdidyouhearaboutuslist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Hoardings','Hoardings'));
        options.add(new SelectOption('Friends & Relatives','Friends & Relatives'));
        options.add(new SelectOption('Property Consultant','Property Consultant'));
        options.add(new SelectOption('Print Media','Print Media'));
        options.add(new SelectOption('Digital','Digital'));
        return options;
    }
    public List<SelectOption> getBudgetlist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1.5 cr - 2.5 cr','1.5 cr - 2.5 cr'));
        options.add(new SelectOption('2.5 cr - 3.5 cr','2.5 cr - 3.5 cr'));
        options.add(new SelectOption('3.5 cr - 4.5 cr','3.5 cr - 4.5 cr'));
        options.add(new SelectOption('4.5 cr - 6 cr','4.5 cr - 6 cr'));
        options.add(new SelectOption('6 cr - 8 cr','6 cr - 8 cr'));
        options.add(new SelectOption('8 cr & Above','8 cr & Above'));
        return options;
    }
    public List<SelectOption> getRequirementslist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('2 BHK','2 BHK'));
        options.add(new SelectOption('2.5 BHK','2.5 BHK'));
        options.add(new SelectOption('3 BHK','3 BHK'));
        options.add(new SelectOption('4 BHK','4 BHK'));
        options.add(new SelectOption('5 BHK','5 BHK'));
        options.add(new SelectOption('Duplex','Duplex'));
        options.add(new SelectOption('Penthouse','Penthouse'));
        return options;
    }
    public List<SelectOption> getCarpetArealist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Below 800','Below 800'));
        options.add(new SelectOption('801–1200','801–1200'));
        options.add(new SelectOption('1201–1600','1201–1600'));
        options.add(new SelectOption('1601-2200','1601-2200'));
        options.add(new SelectOption('2201 & Above','2201 & Above'));
        return options;
    }
    public List<SelectOption> getSourceofEOIlist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Direct','Direct'));
        options.add(new SelectOption('Partner','Partner'));
        options.add(new SelectOption('Existing Customer','Existing Customer'));
        options.add(new SelectOption('Customer Referral','Customer Referral'));
        options.add(new SelectOption('Employee Referral','Employee Referral'));
        options.add(new SelectOption('Employee','Employee'));
        return options;
    }
    
    public registerPageController(ApexPages.StandardController controller) {
        //  this.e = (EOI__c)controller.getRecord(); 
        e = new EOI__c();
        pincodeL = new List<Pincode__c>();
        SelectedPincodeid='';
        locality = '';
        city1 = '';
        state = '';
        country = '';
        showResendOTP = false;
        showSendButton = true;
        showsubmitButton = false;
        startTimer = false;
        OTPNumber = '';
        seconds = 60;
        Buttonname = 'Send OTP';
        showOTPField = false;
        validate1 = true;
        ap2 = false;
        ap3 = false;
        ap3 = false;
        ap5 = false;
    }
    
    public void add2(){
        system.debug('inside add2');
        system.debug('ap2:::'+ap2);
        ap2 = true;
    }
    public void add3(){
        ap3 = true; 
    }
    public void add4(){
        ap4 = true; 
    }
    public void add5(){
        ap5 = true; 
    }
    public void rem2(){
        ap2 = false;
        e.Salutation_2__c = '';
        e.Applicant_Name_2__c = '';
    }
    public void rem3(){
        ap3 = false; 
        e.Salutation_3__c = '';
        e.Applicant_Name_3__c = '';
    }
    public void rem4(){
        ap4 = false; 
        e.Salutation_4__c = '';
        e.Applicant_Name_4__c = '';
    }
    public void rem5(){
        ap5 = false;
        e.Salutation_5__c = '';
        e.Applicant_Name_5__c = '';
    }
    
    
    public void sendOTP(){
        system.debug('nat'+e.Nationality__c);
        system.debug('resStat'+resStat);
        if(e.Email__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide customer email')); 
        }
        else if(projs == 'Please select project'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select project'));
        }
        else if(e.Country_Code_Mobile_1__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select country code for customer mobile 1'));  
        }
        else if(phone == null || phone == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide customer mobile1'));
        }
        else if(phone != null || phone != ''){
            if((phone.length() == 0 || !phone.isNumeric()) && e.Country_Code_Mobile_1__c != '+91'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct customer mobile 1'));
            }
            else if((phone.length() != 10 || !phone.isNumeric()) && e.Country_Code_Mobile_1__c == '+91'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide 10 digit customer mobile 1'));
            }
            else if(phone2 != '' && (phone2.length() == 0 || !phone2.isNumeric()) && e.Country_Code_Mobile_2__c != '+91' && e.Country_Code_Mobile_2__c != null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct customer mobile 2'));
            }
            else if(phone2 != '' && (phone2.length() != 10 || !phone2.isNumeric()) && e.Country_Code_Mobile_2__c == '+91' && e.Country_Code_Mobile_2__c != null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide 10 digit customer mobile 2'));
            }
            else{
                e.Mobile_No_2__c = phone2;
                system.debug('phone'+phone);
                project__c p = [select Id,Name from Project__c where Id =: projs];
                
                showSendButton = false;
                showOTPField = true;
                startTimer = true;
                Integer rand = Math.round(Math.random()*10000);
                OTPNumber = '';
                OTPNumber = generateRandomString(4);
                System.debug('OTPNumber==>'+OTPNumber);
                //String statMess = 'Welcome to the Customer Experience Centre of Oberoi Realty. '+OTPNumber+' is the OTP for completing the EOI registration. The OTP is valid for 5 minutes.';
                String statMess = 'Thank you for expressing your interest in the upcoming project '+p.Name+' by Oberoi Realty. '+OTPNumber+' is the OTP for completing the EOI registration. The OTP is valid for 1 minute.';
                String mbNoStr = e.Country_Code_Mobile_1__c + phone;
                mbNoStr = mbNoStr.removeStart('+');
                System.debug(mbNoStr);
                String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
                EnquirySMSCtrl.sendSMS(smsURL);
                
                List<OrgWideEmailAddress> orgw = [SELECT Id,Address FROM OrgWideEmailAddress where Address = 'bhagyashri.gandhare@stetig.in' ];
                List<String> toAddress = new List<String>();
                toAddress.add(e.Email__c);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();              
                email.setSubject('EOI OTP');
                email.setOrgWideEmailAddressId(orgw[0].id);
                //email.setReplyTo('nishant.garg@stetig.in');
                //email.setSenderDisplayName('Test FROm');
                String body = 'Dear '+e.Salutation_1__c+' '+e.Applicant_Name_1__c+',<br>'+'<br>'+'Greetings from Oberoi Realty!'+'<br>'+'<br>'+'Thank you for expressing your interest in the upcoming project '+p.Name+' by Oberoi Realty. '+OTPNumber+' is the OTP for completing the EOI registration. The OTP is valid for 5 minutes.'+'<br>'+'<br>'+'Warm regards,'+'<br>'+'Oberoi Realty';                                                                       
                system.debug('body:::'+body);
                email.setToAddresses(toAddress);
                email.setHtmlBody(body);
                Messaging.sendEmail(new Messaging.Singleemailmessage[] {email});
                OTPtext = 's until you can Resend OTP';
            }
        }
    }
    
    public void ResendOTP(){
        system.debug('phone'+phone);
        if(phone == null || phone == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide customer mobile'));
        }
        else if(phone != null || phone != ''){                                              
            if((phone.length() == 0 || !phone.isNumeric()) && e.Country_Code_Mobile_1__c != '+91'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct customer mobile'));
            }
            else if((phone.length() != 10 || !phone.isNumeric()) && e.Country_Code_Mobile_1__c == '+91'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide 10 digit customer mobile'));
            }
            else{
                project__c p = [select Id,Name from Project__c where Id =: projs];
                showSendButton = false;
                showOTPField = true;
                startTimer = true;
                OTPNumber = '';
                OTPNumber = generateRandomString(4);
                validate1 = false;
                System.debug('OTPNumber==>'+OTPNumber);
                //String statMess = 'Welcome to the Customer Experience Centre of Oberoi Realty. '+OTPNumber+' is the OTP for completing the EOI registration. The OTP is valid for 5 minutes.';
                String statMess = 'Thank you for expressing your interest in the upcoming project '+p.Name+' by Oberoi Realty. '+OTPNumber+' is the OTP for completing the EOI registration. The OTP is valid for 1 minute.';
                String mbNoStr = e.Country_Code_Mobile_1__c + phone;
                mbNoStr = mbNoStr.removeStart('+');
                System.debug(mbNoStr);
                String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
                EnquirySMSCtrl.sendSMS(smsURL);
                
                List<OrgWideEmailAddress> orgw = [SELECT Id,Address FROM OrgWideEmailAddress where Address = 'bhagyashri.gandhare@stetig.in' ];
                List<String> toAddress = new List<String>();
                toAddress.add(e.Email__c);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();              
                email.setSubject('EOI OTP');
                email.setOrgWideEmailAddressId(orgw[0].id);
                //email.setReplyTo('nishant.garg@stetig.in');
                //email.setSenderDisplayName('Test FROm');
                String body = 'Dear '+e.Salutation_1__c+' '+e.Applicant_Name_1__c+',<br>'+'<br>'+'Greetings from Oberoi Realty!'+'<br>'+'<br>'+'Thank you for expressing your interest in the upcoming project '+p.Name+' by Oberoi Realty. '+OTPNumber+' is the OTP for completing the EOI registration. The OTP is valid for 5 minutes.'+'<br>'+'<br>'+'Warm regards,'+'<br>'+'Oberoi Realty';                                                                       
                system.debug('body:::'+body);
                email.setToAddresses(toAddress);
                email.setHtmlBody(body);
                Messaging.sendEmail(new Messaging.Singleemailmessage[] {email});
            }
        }
    }
    
    public static String generateRandomString(Integer len) {
        final String chars = '0123456789';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
    public void validateOTP(){
        if(otp != ''){
            if(otp == OTPNumber){
                validate1 = false;
                System.debug('OTP Validated Succesfully!!!');
                showOTPField = false;
                showResendOTP = false;
                savebutton = true;
            }else{
                System.debug('Please enter correct OTP!!!');
                OTPtext = 'Please Enter Correct OTP!!!';
                otp = null;
            }
        }else{
            System.debug('Please Enter OTP!!!');
            OTPtext = 'Please Enter OTP!!!';
            otp = null;
        }
    }
    
    public void callMethod(){
        if(seconds > 5){
            seconds = seconds - 5;
        }else{
            startTimer = false;
            seconds = NULL;
            showResendOTP = true;
            OTPtext = '';
            Buttonname = 'Re-send OTP';       
        }
    } 
    
    /*public pageReference pincoderoll(){
        if(e.Pincode_Obj__c != null) {
             pincodeL = [select id, name,City__c,Country__c,Locality__c,State__c from Pincode__c where id=:e.Pincode_Obj__c];
            e.Locality__c = pincodeL[0].Locality__c;
            e.Pincode1__c = pincodeL[0].name;
            e.City__c = pincodeL[0].City__c;
            e.State__c = pincodeL[0].State__c;
            e.Country__c = pincodeL[0].Country__c;
        }
                    //e.Pincode_Obj__c = pincodeL[0].id;
        return null;
    }*/
    
    @RemoteAction
    global static List<string> getpincodeDetails(String pincode1) {
        system.debug('pincode: '+pincode1);
        //Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        List<Pincode__c> pList = new List<Pincode__c>();
        List<string> pName = new List<string>();
        string QueryString =  'Select id, Name,City__c,Country__c,Locality__c,State__c  From Pincode__c Where Name like \''+pincode1+'%\'';
        pList = Database.query(QueryString);
        system.debug('pList:: '+pList);
        if(!pList.isEmpty()) {
            for(Pincode__c p : pList) {
                
                //pName.add(p.Name+ ' ,'+ p.Locality__c+ ' ,'+p.City__c+ ' ,'+p.State__c+ ' ,'+p.Country__c); 
                pName.add('{"id":"'+p.id+'","name":"'+p.Name+'","locality":"'+p.Locality__c+'","city":"'+p.City__c+'","state":"'+p.State__c+'","country":"'+p.Country__c+'"}');
            }
        }Else{
            //cName.add('No CP Found');
        }
        return pName;
    }
    
    public pageReference save (){
        if(e.Nationality__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Nationality'));
        }
        else if(e.Nationality__c == 'India' && resStat == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select resident status'));
        }
        else if(pincode1 == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct pincode'));
        }
        else if(pincode1!= null && (!pincode1.isNumeric() || pincode1.length() != 6) && e.Nationality__c == 'India'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct pincode'));
        }
        else if(e.Street_1__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide Building/Society Name'));
        }
        else if(city1 == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide city'));
        }
        else if(state == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide state'));
        }
        else if(country == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide country'));
        }
        else if(occup == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select occupation'));
        }
        else if(e.Company_Pincode__c != null && (!e.Company_Pincode__c.isNumeric() || e.Company_Pincode__c.length() != 6) && e.Nationality__c == 'India'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct company pincode'));
        }
        /*else if(e.Company_Pincode__c != null && !e.Company_Pincode__c.isNumeric()){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct company pincode'));
}*/
        else if(telres != '' && (telres.length() == 0 || !telres.isNumeric()) && e.Country_Code_Residense__c != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct residence telephone'));
        }
        /*else if(telres != null && (telres.length() != 10 || !telres.isNumeric()) && e.Country_Code_Residense__c == '+91' && e.Country_Code_Residense__c != null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide 10 digit residence telephone'));
}*/
        else if(teloff != '' && (teloff.length() == 0 || !teloff.isNumeric()) && e.Country_Code_Office__c != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct office telephone'));
        }
        /*else if(teloff != null && (teloff.length() != 10 || !teloff.isNumeric()) && e.Country_Code_Office__c == '+91' && e.Country_Code_Office__c != null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide 10 digit office telephone'));
}*/
        else if(cpsa1 == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select contact person(same as applicant-1)'));
        }
        else if(e.Contact_Person_Name__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide contact person name'));
        }
        else if(e.Contact_Person_Relation_Designation__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide contact person designation'));
        }
        else if(contpertel != '' && (contpertel.length() == 0 || !contpertel.isNumeric()) && e.Country_Code_Contact_Person_Telephone__c != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct contact person telephone'));
        }
        /*else if(contpertel != null && (contpertel.length() != 10 || !contpertel.isNumeric()) && e.Country_Code_Contact_Person_Telephone__c == '+91' && e.Country_Code_Contact_Person_Telephone__c != null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide 10 digit contact person telephone'));
}*/
        else if(e.Country_Code_Contact_Person_Mobile__c == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide contact person mobile country code'));
        }
        else if(contpermob == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide contact person mobile'));
        }
        else if(contpermob != null){ 
            if((contpermob.length() == 0 || !contpermob.isNumeric()) && e.Country_Code_Contact_Person_Mobile__c != '+91' && e.Country_Code_Contact_Person_Mobile__c != null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct contact person mobile'));
            }
            else if((contpermob.length() != 10 || !contpermob.isNumeric()) && e.Country_Code_Contact_Person_Mobile__c == '+91' && e.Country_Code_Contact_Person_Mobile__c != null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide 10 digit contact person mobile'));
            }
            else if(custCat == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select customer category'));
            }
            /*else if(hdwcy1 == null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select how do we contact you'));
}
else if(aoc1 == null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select address of correspondence'));
}*/
            else if(hdyhau1 == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select how did you hear about us'));   
            }
            else if(budget1 == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select budget'));   
            }
            else if(req == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select requirements'));   
            }
            else if(ca1 == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select carpet area'));   
            }
            else if(sob1 == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select source of booking'));   
            }
            else if(e.RERA_Registration_No__c != null && e.RERA_Registration_No__c.length() != 12){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct RERA Registration No '));
            }
            else if(parttel != null && (parttel.length() == 0 || !parttel.isNumeric()) && e.Country_Code_Property_Consultant_Mobile__c != '+91' && e.Country_Code_Property_Consultant_Mobile__c != null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct property consultants mobile'));
            }
            else if(parttel != null && (parttel.length() != 10 || !parttel.isNumeric()) && e.Country_Code_Property_Consultant_Mobile__c == '+91' && e.Country_Code_Property_Consultant_Mobile__c != null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide 10 digit property consultants mobile'));
            }
            else if(partmob != null && (partmob.length() == 0 || !partmob.isNumeric()) && e.Country_Code_Property_Consult_Telephone__c != null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide correct property consultants office telephone'));
            }
            else if(tc == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please agree terms and conditions'));   
            }
            else if(locality.length()> 40){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Locality Lenght is above 40'));   
            }
            /*else if(partmob != null && (partmob.length() != 10 || !partmob.isNumeric()) && e.Country_Code_Property_Consult_Telephone__c == '+91' && e.Country_Code_Property_Consult_Telephone__c != null){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide 10 digit property consultants office telephone'));
}*/
            else{
                if(e.Nationality__c == 'India'){
                    e.Resident_Status__c = resStat;
                }
                e.Contact_Person_Same_as_applicant_1__c = cpsa1;
                e.Contact_Person_Telephone__c = contpertel;
                e.Contact_Person_Mobile__c = contpermob;
                e.Property_Consultant_s_Telephone_Mobile__c = parttel;
                e.Property_Consultant_s_Telephone_Office__c = partmob;
                e.Customer_Category__c = custCat;
                e.Telephone_No_Residence__c = telres;
                e.Telephone_No_Office__c = teloff;
                e.Occupation__c = occup;
                e.Locality__c = locality;
                e.Pincode1__c = pincode1;
                e.City__c = city;
                e.State__c = state;
                e.Country__c = country;
                //e.Address_of_correspondence__c = aoc1;
                e.How_do_we_contact_you__c = hdwcy1;
                e.How_did_you_hear_about_us__c = hdyhau1;
                e.Budget__c = budget1;
                e.Requirements__c = req;
                e.Carpet_Area__c = ca1;
                e.Source_of_EOI__c = sob1;
                e.Mobile_No_1__c = phone;
                Site mySite = [select Id from Site where Name = 'rpEOI'];
                SiteDetail mySiteDetail = [select SecureURL from SiteDetail where DurableId = :mySite.Id];
                System.debug(mySiteDetail.SecureURL);
                String headerdata= ApexPages.currentPage().getParameters().get('utm_source'); 
                System.debug('EOI Source:::'+headerdata);      
                String headerdata1= ApexPages.currentPage().getParameters().get('utm_medium');
                String headerdata2= ApexPages.currentPage().getParameters().get('utm_term');
                String urlvalue=Apexpages.currentPage().getUrl(); 
                String url;
                if(headerdata != null){       
                    url=mySiteDetail.SecureURL+'?utm_source='+ headerdata+'&utm_medium='+headerdata1+'&utm_term='+headerdata2;
                }else{
                    url=mySiteDetail.SecureURL;
                }
                System.debug('EOI current URL:::'+url);
                e.EOI_URL__c = url;
                //System.debug('EOI current URL:::'+Site.getCurrentSiteUrl());
                savebutton = false;
                project__c p = [select id from Project__c where id =: projs]; 
                e.Project__c = p.Id;
                try {
                    insert(e); 
                }
                catch(Exception ex){
                    ApexPages.addMessages(ex);
                    return null;         
                } 
                eo = [Select Id,Opportunity__c,Name,Project__r.Name,Is_Channel_Partner_EOI__c,Country_Code_Mobile_1__c,Mobile_No_1__c,
                      UniqueEOInumber__c,Project__r.Payment_Options__c From EOI__c Where Id=: e.Id];
                
                if(eo != null){
                    if(eo.Project__r.Payment_Options__c != null && eo.Project__r.Payment_Options__c == 'Payment Required'){
                        showPayButton = true;
                    }
                    else if(eo.Project__r.Payment_Options__c != null && eo.Project__r.Payment_Options__c == 'Optional Payment'){
                        showSkipButton = true;
                    }
                    else if(eo.Project__r.Payment_Options__c != null && eo.Project__r.Payment_Options__c == 'Payment not Required'){
                        PageReference pg = new PageReference('/apex/EOI_ThankYou');
                        pg.getParameters().put('eoId',eo.Id);
                        String statMess = 'Thank you for your interest in '+eo.Project__r.Name+' by Oberoi Realty. Your Unique code is '+eo.UniqueEOInumber__c+'. Kindly quote this code on the date of booking for a seamless experience.';
                        system.debug('statMess'+statMess);
                        String mbNoStr = eo.Country_Code_Mobile_1__c + eo.Mobile_No_1__c;
                        mbNoStr = mbNoStr.removeStart('+');
                        System.debug(mbNoStr);
                        String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
                        system.debug('smsURL'+smsURL);
                        EnquirySMSCtrl.sendSMS(smsURL);
                        return pg;
                    }
                }
            }
        }
        return null;
    }
    
    public void pay(){
        eo = [Select Id,Opportunity__r.UniqueEOINumber__c,Name,Email__c,Project__r.Payphi_Merchant_Id__c,
              Mobile_No_1__c,Project__r.Payphi_API_Key__c,Project_Payment_Amount__c From EOI__c Where Id=: e.Id];
        if(eo != null){
            List<Opportunity> opList = [Select Id,UniqueEOINumber__c From Opportunity Where Id=:eo.Opportunity__c];
            merchantTxnNo = eo.Id;
            amount = eo.Project_Payment_Amount__c;
            customerEmailId = eo.Email__c;
            customerMobileNo = eo.Mobile_No_1__c;
            mid = eo.Project__r.Payphi_Merchant_Id__c;
            key = eo.Project__r.Payphi_API_Key__c;
            system.debug('UniqueEOINumber'+eo.Opportunity__r.UniqueEOINumber__c);
            if(opList != null && opList.size()>0){
                for(Opportunity op: opList){
                    op.UniqueEOINumber__c = 'P-'+eo.Name;
                }
                update opList;
            }
            String dt = string.valueOf(system.now());
            system.debug('dt'+dt);
            String d = dt.replaceAll(':', '');
            String d1 = d.replaceAll('-', '');
            String d2 = d1.replaceAll(' ', '');
            txnDate = d2;
            system.debug('txnDate'+txnDate);
        }
        showSkipButton = false;
        system.debug('merchantTxnNo+++'+merchantTxnNo);
        system.debug('amount'+amount);
        system.debug('customerEmailId'+customerEmailId);
        system.debug('customerMobileNo'+customerMobileNo);
        system.debug('mid'+mid);
        system.debug('key'+key);
    }
    
    public pageReference thank(){
        EOI__c eo = [Select Id,Opportunity__c,Name,Project__r.Name,Is_Channel_Partner_EOI__c,Country_Code_Mobile_1__c,Mobile_No_1__c,
                     UniqueEOInumber__c,Project__r.Payment_Options__c From EOI__c Where Id=: e.Id];
        system.debug('insiseThankYou');
        showPayButton = false;
        PageReference pg1 = new PageReference('/apex/EOI_ThankYou');
        List<Opportunity> optyList = new List<Opportunity>();
        if(eo != null){
            pg1.getParameters().put('eoId',eo.Id);
            optyList = [Select Id,Name,EOI_Project__c,AccountId,Channel_Partner_Name__c,UniqueEOInumber__c,
                        Partner_s_Firm_Name__c From Opportunity Where Id=: eo.Opportunity__c];
            String statMess = 'Thank you for your interest in '+eo.Project__r.Name+' by Oberoi Realty. Your Unique code is '+eo.UniqueEOInumber__c+'. Kindly quote this code on the date of booking for a seamless experience.';
            system.debug('statMess'+statMess);
            String mbNoStr = eo.Country_Code_Mobile_1__c + eo.Mobile_No_1__c;
            mbNoStr = mbNoStr.removeStart('+');
            System.debug(mbNoStr);
            String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
            system.debug('smsURL'+smsURL);
            EnquirySMSCtrl.sendSMS(smsURL);
        }
        EmailTemplate templateId = [Select id,Name,Body from EmailTemplate where name = 'RP EOI registration'];                
        List<OrgWideEmailAddress> orgw = [SELECT Id,Address FROM OrgWideEmailAddress where Address = 'bhagyashri.gandhare@stetig.in' ];
        Messaging.Email[] messages = new Messaging.Email[0];
        
        if(optyList != NULL && optyList.size()>0){
            for(Opportunity op:optyList){   
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                PageReference pref = new PageReference('/apex/EOIpdf');
                pref.getParameters().put('eoId',eo.Id); 
                
                Blob bb;
                if(!Test.isRunningTest()){
                    bb = pref.getContentAsPDF();   
                    System.debug('bb==>'+bb);
                } else {
                    bb = Blob.valueOf('Test123');
                }      
                
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();                                
                attach.setBody(bb);
                attach.setFileName('EOI.pdf'); 
                fileAttachments.add(attach);
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                List<Contact> conList = [SELECT Id,Name FROM Contact WHERE AccountId=:op.AccountId];
                list<string> lststringtoaddress = new list<string>();
                list<string> lststringccaddress = new list<string>();
                list<string> lststringbccaddress = new list<string>();
                
                email.setwhatid(op.Id);
                email.setOrgWideEmailAddressId(orgw[0].id);
                email.setTemplateId(templateId.id);
                email.setTargetObjectId(conList[0].id);
                email.setSaveAsActivity(false);
                
                //lststringbccaddress.add('amit.kshirsagar@stetig.in');
                //lststringbccaddress.add('chandan.kokul@oberoirealty.com');
                email.setToAddresses(lststringtoaddress);   
                email.setCcAddresses(lststringccaddress);
                email.setBccAddresses(lststringbccaddress);
                email.setFileAttachments(fileAttachments); 
                messages.add(email);
                Messaging.sendEmail(messages);
            }
        }
        return pg1;
    }
}
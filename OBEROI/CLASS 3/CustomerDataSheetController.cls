public class CustomerDataSheetController{

    public Lead leadobj {get; set;}
    public Contact conobj {get; set;}
    public String strstreet3;
    
    //public Repository_Data__c rdobj {get; set;}
    public Contact conobj2 {get; set;}
    public Contact conobj3 {get; set;}
    public Account accobj {get; set;}
    //Public Elite_club__c elite {get; set;}
    public String customerType {get; set;}
    public String Walkinsource {get; set;}
    public String subcustomerType {get; set;}
    public String enquirySubCategory;
    List <Contact> clistgther = New List <Contact> ();
    //public List<PropStrength__Request__c> enqlist{get; set;}
    //public PropStrength__Request__c req {get; set;}
    public List<SelectOption> optnlst {get; set;}
    public List<SelectOption> prtTypelst{get; set;}
    public List<SelectOption> arelist{get; set;}
    public List<String> sctPrtylst {get; set;}
    public String slctRequment {get; set;}
    public string loc{get; set;}
    public List<Project__c> sctprjlst {get; set;}
    public List<String> carperareasel {get; set;}
    public String EliteName {get; set;}
    public String EliteProject {get; set;}
    public String EliteTower {get; set;}
    public String EliteFlat {get; set;}
    public String carAreaSelect {get; set;}
    public List<String> whatLooking {get; set;}
    public String whtlkng {get; set;}
    public String prmVal {get; set;}
    public String ConobjName{get; set;}
    public List<Contact> conlst {get; set;}
    public List<Account> acclist = New List<Account>();
    public List<Account> acclistupdate = New List<Account>();
    public List<Contact> clist = New List<Contact>();
    public String sctPrty {get; set;}
    public String eliteId {get; set;}
    public String slctProj {get; set;}
    public String bdgt {get; set;}
    public String GetFirstName {get; set;}
    public String GetSal {get; set;}
    public String GetLastName {get; set;}
    public String GetMiddleName {get; set;}
    public String EmailCon {get; set;}
    public String Lastname{get; set;}
    public String Lastname2{get; set;}
    public String mbno {get; set;}
    Public String CorAdress{get; set;}
    public String carpetArea {get; set;}
    public String hear {get; set;}
    public String otherIndustry {get;set;}
    
    public String possesionTime {get; set;}
    public String occupation {get; set;}
    public String industry {get; set;}
    public String sameApplicant {get; set;}
    public List<String> contactYoulist {get; set;}
    public String contactVal {get; set;}
    private String soql {get;set;}
    public String residentStatus {get; set;}
    public String howSoon {get; set;}
    public String purposeOfBuying {get; set;}
    public String brokercontact {get; set;} 
    public String accobjPCIc {get; set;}
    public String accobjName {get; set;}
    public String ProjectId {get; set;}
    public String ProjectName {get; set;}
    public String contactNoRes{get;set;}
    public String propConsultantEmail{get;set;}
    public List<Wrapper> lstwrp {get; set;}
    public String tempConMiddleName;
    Public String AccountSql = '';
    public String mbnoflg {get;set;}
    public String mbnoOtherflg {get;set;}
    public String resCntrCOde {get;set;}
    public String officeCntrCOde {get;set;}
    public String  prtConsCntrCOde {get;set;}
    public String pcEmail {get; set;}
    public String pcOffice {get; set;}
    public String officeAdd {get; set;}
    public Boolean mndtTrue{get; set;}
    public Boolean checkMbNumber {get;set;}
    public String mbOneCntryCode {get; set;}
    public String mbTwoCntryCode {get; set;}
    public String otpCharString {get; set;}
    public Boolean displayOTPPanel {get; set;}
    public String generatedOTP;
    public Boolean allowEnquiry;
    public String newPagePartialUrl;
    public Set<Id> conId;
    public String initialProject;
    public Set<Id> esquireExquisiteSet;
    public Set<Id> eterniaEnigmaSet;
    
    public CustomerDataSheetController(){

         leadobj = new Lead();
          tempConMiddleName = '';
       //elite = new Elite_club__c();
       lstwrp = new List<Wrapper>();
        conlst = new List<Contact>();
        conobj2 = new Contact();
         conobj = new Contact();
         loc = '';
        sctprjlst = New List<Project__c>();
        conobj3 = new Contact();
        accobj = new Account();
        //rdobj = new Repository_Data__c();
        //enqlist = new List<PropStrength__Request__c>();
        sctPrtylst = new List<String>();
        whatLooking  = new List<String>();
        carperareasel = New List<String>();
        contactyoulist = New list<String>();
        prtTypelst= new List<SelectOption>();
        otpCharString = '';
        generatedOTP = '';
        displayOTPPanel = false;
        strstreet3 = '';
        arelist = new List<SelectOption>(); 
        //soql ='select Id, Property_name__r.Name from Elite_club__c WHERE Elite_Membership_ID__c != null';
        String broker = 'Broker';
        AccountSql = 'select Id, Name From Account WHERE RecordType.Name  = \'' +broker+ '\' ' ;
        arelist.add(new selectOption('Below 800','Below 800'));
        arelist.add(new selectOption('801 – 1200','801 – 1200'));
        arelist.add(new selectOption('1201 – 1600','1201 – 1600'));
        arelist.add(new selectOption('1601 – 2200','1601 – 2200'));
        arelist.add(new selectOption('2201 & Above','2201 and Above'));
        prtTypelst.add(new selectOption('2BHK','2BHK'));
        prtTypelst.add(new selectOption('2.5 BHK','2.5 BHK'));
        prtTypelst.add(new selectOption('3BHK','3BHK'));
        prtTypelst.add(new selectOption('4BHK','4BHK'));
        prtTypelst.add(new selectOption('Duplex','Duplex'));
        prtTypelst.add(new selectOption('Penthouse','Penthouse'));
        GetLastName = ApexPages.currentPage().getParameters().get('LN');
        GetFirstName = ApexPages.currentPage().getParameters().get('FN');
        GetSal = ApexPages.currentPage().getParameters().get('SL');
        GetMiddleName = ApexPages.currentPage().getParameters().get('MN');
        Emailcon = ApexPages.currentPage().getParameters().get('EM');
        mbno = ApexPages.currentPage().getParameters().get('PH');
        mbnoflg = ApexPages.currentPage().getParameters().get('PHCode');
        if(mbnoflg!=null)
        mbnoflg ='+'+mbnoflg.trim();
        //mbnoflg = ApexPages.currentPage().getParameters().get('PHCode');
        mbnoOtherflg = ApexPages.currentPage().getParameters().get('otmocode');
        ProjectId = ApexPages.currentPage().getParameters().get('PJ');
        enquirySubCategory = ApexPages.currentPage().getParameters().get('subCat');
        String otMo = ApexPages.currentPage().getParameters().get('otMo');
        if(mbnoOtherflg!=null){
            mbnoOtherflg = mbnoOtherflg.trim();
            mbnoOtherflg  = '+'+mbnoOtherflg;
        }
        //if(otMo != null && otMo != '' && otMo != 'null')
          //  conobj.Mobile_number_2__c = otMo;
        
        if(ProjectId != null && ProjectId != ''){
        sctprjlst = [Select Id, Name From Project__c Where id =:ProjectId];
        ProjectName = sctprjlst[0].Name; 
        }
        //req = new PropStrength__Request__c();
        optnlst = new List<SelectOption>();
        
        Set<string> proname = new Set<string>();
        proname.add('Dummy Project');
        proname.add('HO COMMON');
        proname.add('MULUND');
        proname.add('OGC');
        proname.add('THREE SIXTY WEST');
        proname.add('PRIVIERA');
        proname.add('Fixed CLI');
        /*
        esquireExquisiteSet = new Set<Id>();
        eterniaEnigmaSet = new Set<Id>();
        List<PropStrength__Projects__c> lstprj = [select id,name, PropStrength__Project_Code__c from PropStrength__Projects__c where PropStrength__Active__c=True and Name NOT IN: proname];
        for(PropStrength__Projects__c obj:lstprj){
            optnlst.add(new SelectOption(obj.id,obj.Name));
            
            if(obj.PropStrength__Project_Code__c == 'ESQUIRE14' || obj.PropStrength__Project_Code__c == 'ExQUISITE16'){
                esquireExquisiteSet.add(obj.Id);
            }
            else if(obj.PropStrength__Project_Code__c == 'ETERNIA15' || obj.PropStrength__Project_Code__c == 'ENIGMA10'){
                eterniaEnigmaSet.add(obj.Id);
            }
        }
        System.debug('esquireExquisiteSet: ' + esquireExquisiteSet);
        System.debug('eterniaEnigmaSet: ' + eterniaEnigmaSet);*/
        lstwrp.add(new Wrapper(conobj,lstwrp.size()));
        conlst.add(conobj);
        
        //added logic might removed by TS 13-02-2017
       // conobj
    }
    
/****************************************************************************************************************************/
    public PageReference saveDetails(){

        
        System.debug('++mbnoflg+++'+mbnoflg);
        System.debug('++mbnoflg+mbnoOtherflg++'+mbnoOtherflg);
        System.debug('--customerType--'+customerType);
        initialProject = slctProj;
        String FullNameLast='';
        conId = New Set<Id>();
        //List<PropStrength__Request__c> enqList = New List <PropStrength__Request__c>();
        //List<PropStrength__Request__c> newenqList = New List <PropStrength__Request__c>();
        //List<PropStrength__Request__c> insertenqList = New List <PropStrength__Request__c>();
        //PropStrength__Request__c req = new PropStrength__Request__c();
        mbno = mbno.trim();
        if(mbno=='' ){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter mobile number'));               
        }else if(mbno.length() != 10){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Mobile Number Must Be 10 Digits')); 
        }if(mbno=='' || LastName2 == ''){//LastName == '' || || conobj.Email == ''
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Fill All Required Fields (*)'));
        }
        if(subcustomerType==null || subcustomerType ==''){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select Sub Category'));
            return null;
        }
        if(mbno.length()!=10){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Mobile Number Must Be 10 Digits'));
        }   
        /*
        if((mbno.length()==10 && mbno != '') && LastName2 != ''){
            List<Contact> conlst = [select id,name,MobilePhone from Contact where MobilePhone =: mbno];
            String GLN;
            String GFN;
            String GEM;
            String GMM;
            String SAL;
            GLN =  conObj.LastName;
            GFN =  conObj.FirstName;
            GEM =  (conObj.Email != null ? conObj.Email:'');
            SAL = conObj.Salutation;
            List <String> LastNameList = New List<String>();  
            LastNameList.add(Lastname+' ');
            LastNameList.add(Lastname2);
            for(String lname : LastNameList){
            FullNameLast += lname;
            } 
            system.debug('---FullNameLast---'+FullNameLast);
            if(conlst.size()>0){
                for(Contact c : conlst){
                    conId.add(c.Id);
                } 
            }

            Set<Id> pairedProjectSet = new Set<Id>();
            if(eterniaEnigmaSet.contains(slctProj)){
                pairedProjectSet = eterniaEnigmaSet;
            }
            else if(esquireExquisiteSet.contains(slctProj)){
                pairedProjectSet = esquireExquisiteSet;
            }
            System.debug('conId: ' +conId);
            enqList = [Select Id,OwnerID,PropStrength__Request_Source__c,Name, Data_sheet_Submitted__c,PropStrength__Project__c, PropStrength__Request_Status__c, PropStrength__Primary_Contact__c, PropStrength__Project__r.Id From PropStrength__Request__c WHERE PropStrength__Primary_Contact__c In : conId AND (PropStrength__Project__c =:slctProj OR PropStrength__Project__c IN :pairedProjectSet) and (PropStrength__Request_Status__c !='Closed' AND PropStrength__Request_Status__c !='Booked')];
             System.debug('enqList: ' +enqList);
            if(enqList.size() > 0 && enqList[0].PropStrength__Request_Status__c.containsIgnoreCase('LOST') && enqList[0].Data_sheet_Submitted__c != null && enqList[0].Data_sheet_Submitted__c.containsIgnoreCase('Yes')){
                System.debug('================= Duplicate Enquiury 1 ===============');
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your details already exists with us. Kindly connect with the executive at the Reception Desk for further assistance'));    
                return null;
            }
                
            System.debug('+++enqList++++'+enqList+'+++enqListsize+++'+enqList.size());
            System.debug('+++customerType++++'+customerType);
            if(customerType == 'Property Consultant' && (subcustomerType == 'Enq. for New Contact' ||subcustomerType == 'View Show Flat' )){
                if(enqList.size()==0 || enqList==null){   
                    newPagePartialUrl = '/apex/Customer_Data_Sheet?LN='+Lastname+'&FN='+GFN+'&EM='+GEM+'&PH='+mbno+'&PHCode='+mbnoflg+'&otmocode='+mbnoOtherflg+'&PJ='+slctProj+'&SL='+SAL+'&MN='+Lastname2+'&subCat='+subcustomerType+'&otMo='+conobj.Mobile_number_2__c;
                    redirectToPage();
                }else{
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your details already exists with us. Kindly connect with the executive at the Reception Desk for further assistance'));    
                }        
            }if(customerType == 'Existing Customer'){
                if(enqList.size()==0 || enqList==null){
                    newPagePartialUrl = '/apex/Customer_Data_Sheet?LN='+Lastname+'&FN='+GFN+'&EM='+GEM+'&PH='+mbno+'&PHCode='+mbnoflg+'&otmocode='+mbnoOtherflg+'&PJ='+slctProj+'&SL='+SAL+'&MN='+Lastname2+'&subCat='+subcustomerType+'&otMo='+conobj.Mobile_number_2__c;
                    redirectToPage();
                }else{
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your details already exists with us. Kindly connect with the executive at the Reception Desk for further assistance'));
                       return null;
                }
            }if(enqList.size()>0 && customerType == 'New Customer'){
                System.debug('++mbnoflg+11++'+mbnoflg);
                System.debug('++mbnoflg+mbnoOtherflg+12+'+mbnoOtherflg);
                if(enqList.size()>0){
                    if(enqList[0].PropStrength__Request_Source__c=='Virtual No.' || enqList[0].PropStrength__Request_Source__c=='Web' || enqList[0].PropStrength__Request_Source__c=='Websites' || enqList[0].PropStrength__Request_Source__c=='Board line/PRI lines'){
                        newPagePartialUrl = '/apex/Customer_Data_Sheet?LN='+Lastname+'&FN='+GFN+'&EM='+GEM+'&PH='+mbno+'&PHCode='+mbnoflg+'&otmocode='+mbnoOtherflg+'&PJ='+slctProj+'&SL='+SAL+'&MN='+Lastname2+'&subCat='+subcustomerType+'&otMo='+conobj.Mobile_number_2__c;
                        redirectToPage();
                    }
                    else{
                        
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your details already exists with us. Kindly connect with the executive at the Reception Desk for further assistance'));
                        return null;
                    }
                }
                    
                
                
            }if(customerType == 'New Customer' && enqList.size()==0){
                 System.debug('++mbnoflg+1++'+mbnoflg);
                 System.debug('++mbnoflg+mbnoOtherflg+1+'+mbnoOtherflg);
                
                newPagePartialUrl = '/apex/Customer_Data_Sheet?LN='+Lastname+'&FN='+GFN+'&EM='+GEM+'&PH='+mbno+'&PHCode='+mbnoflg+'&otmocode='+mbnoOtherflg+'&PJ='+slctProj+'&SL='+SAL+'&MN='+Lastname2+'&subCat='+subcustomerType+'&otMo='+conobj.Mobile_number_2__c;
                redirectToPage();
            }
            if(enqList.size()>0 && (subcustomerType == 'Enquiry for New Flat' || subcustomerType == 'View Show Flat' ) && customerType == 'Existing Customer'){
               
                 
                   system.debug('request.PropStrength__Request_Source__c----'+enqList);
                   if(enqList.size()>0){
                       for(PropStrength__Request__c request : enqList){
                           if(request.PropStrength__Project__c == slctProj){ //&& request.PropStrength__Request_Source__c == 'Kisok/data-sheet' && (request.PropStrength__Request_Status__c == 'Closed' || request.PropStrength__Request_Status__c == 'Converted to Offer'|| request.PropStrength__Request_Status__c == 'Lost'
                                
                                newPagePartialUrl = '/apex/Customer_Data_Sheet?LN='+Lastname+'&FN='+GFN+'&EM='+GEM+'&PH='+mbno+'&PHCode='+mbnoflg+'&otmocode='+mbnoOtherflg+'&PJ='+slctProj+'&SL='+SAL+'&MN='+Lastname2+'&subCat='+subcustomerType;
                                redirectToPage();
                           }if(request.PropStrength__Project__c == slctProj && request.PropStrength__Request_Source__c == 'Kisok/data-sheet' && request.PropStrength__Request_Status__c == 'Open-Followup'){
                               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your Previous Enquiry Is Still Open.'));     
                           }if(request.PropStrength__Request_Source__c != 'Kisok/data-sheet' && request.Data_sheet_Submitted__c == 'NO'){
                                
                                newPagePartialUrl = '/apex/Customer_Data_Sheet?LN='+Lastname+'&FN='+GFN+'&EM='+GEM+'&PH='+mbno+'&PHCode='+mbnoflg+'&otmocode='+mbnoOtherflg+'&PJ='+slctProj+'&SL='+SAL+'&MN='+Lastname2+'&subCat='+subcustomerType+'&otMo='+conobj.Mobile_number_2__c;
                                redirectToPage();
                           }
                }       
                }else{
                    
                    newPagePartialUrl = '/apex/Customer_Data_Sheet?LN='+Lastname+'&FN='+GFN+'&EM='+GEM+'&PH='+mbno+'&PHCode='+mbnoflg+'&otmocode='+mbnoOtherflg+'&PJ='+slctProj+'&SL='+SAL+'&MN='+Lastname2+'&subCat='+subcustomerType+'&otMo='+conobj.Mobile_number_2__c;
                    redirectToPage();        
                }  
            }
        }*/
        redirectToPage();
        return null;
    }
    
    //public void reset OTP after 10 minutes
    public void resetOTP() {
      generatedOTP = '';
      redirectToPage();
    }

    public PageReference redirectToPage(){
        if(String.isBlank(generatedOTP)){
            generateOTP();
            displayOTPPanel = true;
        }
        else if(String.isNotBlank(generatedOTP) && !generatedOTP.equals(otpCharString)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Entered OTP is incorrect.'));
        }
        else if(String.isBlank(newPagePartialUrl)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Next Page is unavailable. Please contact admin.'));
        }/*
        else{
            System.debug('Before: initialProject: ' +initialProject+ '   :slctProj: ' +slctProj);
            System.debug('newPagePartialUrl: ' +newPagePartialUrl);
            newPagePartialUrl = newPagePartialUrl.replace(initialProject, slctProj);
            System.debug('newPagePartialUrl: ' +newPagePartialUrl);
            initialProject = slctProj;
            System.debug('After: initialProject: ' +initialProject+ '   :slctProj: ' +slctProj);

            Set<Id> pairedProjectSet = new Set<Id>();
            if(eterniaEnigmaSet.contains(slctProj)){
                pairedProjectSet = eterniaEnigmaSet;
            }
            else if(esquireExquisiteSet.contains(slctProj)){
                pairedProjectSet = esquireExquisiteSet;
            }
            System.debug('pairedProjectSet: ' + pairedProjectSet);
            List<PropStrength__Request__c> tempEnqList = [Select Id,OwnerID,PropStrength__Request_Source__c,Name, Data_sheet_Submitted__c,PropStrength__Project__c, PropStrength__Request_Status__c, PropStrength__Primary_Contact__c, PropStrength__Project__r.Id From PropStrength__Request__c WHERE PropStrength__Primary_Contact__c In : conId AND (PropStrength__Project__c =:slctProj OR PropStrength__Project__c IN :pairedProjectSet) and (PropStrength__Request_Status__c !='Closed' AND PropStrength__Request_Status__c !='Booked')];
            System.debug('tempEnqList : ' +tempEnqList);
            if(tempEnqList.size() > 0 && tempEnqList[0].PropStrength__Request_Status__c.containsIgnoreCase('LOST') && tempEnqList[0].Data_sheet_Submitted__c != null && tempEnqList[0].Data_sheet_Submitted__c.containsIgnoreCase('Yes')){
                System.debug('==================== Duplicate Enquiry 2 =======================');
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your details already exists with us. Kindly connect with the executive at the Reception Desk for further assistance'));    
                return null;
            }
            else if(!tempEnqList.isEmpty() && (customerType == 'Existing Customer' || (customerType == 'Property Consultant' && (subcustomerType == 'Enq. for New Contact' ||subcustomerType == 'View Show Flat' )))) {
                System.debug('==================== Duplicate Enquiry 3 =======================');
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your details already exists with us. Kindly connect with the executive at the Reception Desk for further assistance'));    
                return null;
            }
            else if(!tempEnqList.isEmpty() && (customerType == 'New Customer' && tempEnqList[0].PropStrength__Request_Source__c != 'Virtual No.' && tempEnqList[0].PropStrength__Request_Source__c != 'Web' && tempEnqList[0].PropStrength__Request_Source__c != 'Websites' && tempEnqList[0].PropStrength__Request_Source__c != 'Board line/PRI lines')) {
                System.debug('==================== Duplicate Enquiry 4 =======================');
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your details already exists with us. Kindly connect with the executive at the Reception Desk for further assistance'));    
                return null;
            }

            PageReference newPage = new PageReference(newPagePartialUrl);
            newPage.setRedirect(true);
            return newPage;
        }*/
        System.debug('displayOTPPanel: ' +displayOTPPanel);
        return null;
    }

    
    //Method For generate OTP
    public void generateOTP() {
        generatedOTP = '';
        generatedOTP = generateRandomString(4);
        System.debug('====> OTP ====> ' + generatedOTP);
        String statMess = 'Welcome to the Customer Experience Centre of Oberoi Realty. '+generatedOTP+' is the OTP for completing your registration. The OTP is valid for 5 minutes. ';
        String mbNoStr = mbnoflg + mbno;
        mbNoStr = mbNoStr.removeStart('+');
        System.debug(mbNoStr);
        try{
            String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
            EnquirySMSCtrl.sendSMS(smsURL);
            CIF_Default_Email__c deEmail =  CIF_Default_Email__c.getOrgDefaults();
            System.debug('deEmail: ' +deEmail);
            if(deEmail.Email_Address__c != null && deEmail.Email_Address__c == conobj.Email)
              sendOTPMail(conobj.Email, statMess);
              
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Your OTP is sent at entered mobile number.'));        
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Your session is out. Please try again.'));
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

    public void sendOTPMail(String toAddress, String statMess){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { toAddress };
        message.subject = 'OTP';
        message.plainTextBody = statMess;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        }
        else{
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }

    public Class Wrapper{
        public Contact conObj {get; set;}
        public Integer count {get; set;}
        
        public Wrapper(Contact conObj,Integer count){
            this.conObj = new Contact();
            this.count = count;
        }
    }
 }
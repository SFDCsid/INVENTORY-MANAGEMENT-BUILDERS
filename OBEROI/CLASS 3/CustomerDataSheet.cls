global without sharing class CustomerDataSheet{
    Map<id, Project__c> projMap = new Map<id, Project__c>();
    public Boolean updateOppty = false;
    public string opportunityName;
    public string opportunityNo;
    public static string convertoppty;
    public static string LeadId;
    public string opptyId;
    public string opportunityId;
    public string primcontactId;
    public id signId;
    public String siteName {get; set;}
    
    
    public string fileData { get; set; }
    public boolean signsaved { get; set; }
    
    public string cp_fileData { get; set; }
    public boolean cp_signsaved { get; set; }
    
    public boolean hasDuplicate{get;set;}
    
    public String ResCode {get; set;}
    public String OfficeCode {get; set;}
    public String  prtConsCntrCOde {get;set;}
    public static string siteId; 
    public List<Wrapper> lstwrp {get; set;}   
    public Lead leadobj {get; set;}
    public static String contID;
    public String customerType {get; set;}
    public String ErrorDetail {get; set;}
    public String Walkinsource {get; set;}
    public String subcustomerType {get; set;}
    public String enquirySubCategory;
    List <Contact> clistgther = New List <Contact> ();
    public List<Lead> LeadList{get; set;}
    public List<Opportunity> Opportunity_List{get; set;}
    public Boolean Opportunity_List_null{get; set;}
    public String proceed_id{get; set;}
    public Lead req {get; set;}
    public List<SelectOption> siteList {get; set;}
    public List<SelectOption> optnlst {get; set;}
    public List<SelectOption> prtTypelst{get; set;}
    public List<SelectOption> arelist{get; set;}
    public List<String> sctPrtylst {get; set;}
    public String slctRequment {get; set;}
    public string loc{get; set;}
    public List<Project__c> sctprjlst {get; set;}
    public List<String> carperareasel {get; set;}   
    public String carAreaSelect {get; set;}
    public List<String> whatLooking {get; set;}
    public String whtlkng {get; set;}
    public String prmVal {get; set;}
    public String ConobjName{get; set;}
    public string opptyName;
    public List<Lead> ldLst {get; set;}
    public List<Account> acclist = New List<Account>();
    public List<Account> acclistupdate = New List<Account>();
    public List<Contact> clist = New List<Contact>();    
    public String slctProj {get; set;}
    public String bdgt {get; set;}
    public String GetFirstName {get; set;}
    public String GetSal {get; set;}
    public String GetLastName {get; set;}
    public String GetMiddleName {get; set;}
    public String EmailCon {get; set;}
    public String Lastname{get; set;}
    
    public String mbno {get; set;}
    public String other_mbno {get; set;}
    public String lead_email {get; set;}
    
    Public String CorAdress{get; set;}
    public String carpetArea {get; set;}
    public String hear {get; set;}
    public String heard {get; set;}    
    public String reachUs {get; set;} 
    public String cResidence {get; set;} 
    public Contact conObj {get; set;}    
    public String possesionTime {get; set;}
    public String occupation {get; set;}
    public String industry {get; set;}
    public String sameApplicant {get; set;}
    public List<String> contactYoulist {get; set;}
    public String contactVal {get; set;}
    public String residentStatus {get; set;}
    public String howSoon {get; set;}
    public String purposeOfBuying {get; set;}
    public String LocationRating{get; set;}
    public String brokercontact {get; set;} 
    public String accobjPCIc {get; set;}
    public String accobjName {get; set;}
    public String ProjectId {get; set;}
    public String ProjectName {get; set;}    
    public String mbnoflg {get;set;}
    public String mbnoOtherflg {get;set;}   
    public Boolean mndtTrue{get; set;}
    public Boolean hasError{get; set;}
    public Boolean checkMbNumber {get;set;}
    public String mbOneCntryCode {get; set;}
    public String otMo {get; set;}
    public String mbTwoCntryCode {get; set;}
    public String otpCharString {get; set;}
    public Boolean displayOTPPanel {get; set;}
    public String generatedOTP;
    public String newPagePartialUrl;   
    public String initialProject;
    //List<Lead> LeadList = New List <Lead>();
    List<Lead> ULeadList = New List <Lead>();
    public static String GLN;
    public static String GFN;
    public static String GEM;
    public static String GMM;
    public static String GMN;
    public static String GOC;
    public static String GIDS;
    public static String SAL;
    public list<Account> baccounts { get; set; }
    public String name { get; set; }
    public String selectedAccId{get;set;}
    public String cpname {get;set;}
    public String ChannelPartnerName {get;set;}
    public Boolean chbox { get; set; }
    public Boolean file1ren { get; set; }
    public Boolean file2ren { get; set; }
    
    public String cat;
    public static set<string>PAccId;
    
    public CustomerDataSheet(ApexPages.StandardController controller) {
        leadobj=(Lead) controller.getRecord(); 
        LeadList = New List <Lead>();
        // leadobj = new Lead();
        //system.debug('******'+leadobj);        
        lstwrp = new List<Wrapper>();
        lstwrp.add(new Wrapper(conobj,lstwrp.size()));
        sctprjlst = New List<Project__c>();
        sctPrtylst = new List<String>();
        //  whatLooking  = new List<String>();
        carperareasel = New List<String>();
        contactyoulist = New list<String>();
        prtTypelst= new List<SelectOption>();
        otpCharString = '';
        generatedOTP = '';
        signsaved=false;
        cp_signsaved=false;
        Opportunity_List_null=true;
        displayOTPPanel = false;        
        arelist = new List<SelectOption>();        
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
        if(mbnoflg!=null) mbnoflg ='+'+mbnoflg.trim();
        //mbnoflg = ApexPages.currentPage().getParameters().get('PHCode');
        mbnoOtherflg = ApexPages.currentPage().getParameters().get('otmocode');
        ProjectId = ApexPages.currentPage().getParameters().get('PJ');
        enquirySubCategory = ApexPages.currentPage().getParameters().get('subCat');
        cat = ApexPages.currentPage().getParameters().get('customerType');
        otMo = ApexPages.currentPage().getParameters().get('otMo');        
        if(mbnoOtherflg!=null){
            mbnoOtherflg = mbnoOtherflg.trim();
            mbnoOtherflg  = '+'+mbnoOtherflg;
        }
        //if(otMo != null && otMo != '' && otMo != 'null')
        //  conobj.Mobile_number_2__c = otMo;
        optnlst = new List<SelectOption>();               
        for(Project__c obj: [select id,Sales_Head__c,Cooling_Period_Days__c,name,site__c, Front_Desk_User__c from Project__c WHERE Recordtype.Name =:'Residential' AND Active__c = true AND Available_for_Datasheet__c = true]){
            optnlst.add(new SelectOption(obj.id,obj.Name));
            projMap.put(obj.Id, obj);
        }
        if(ProjectId != null && ProjectId != ''){
            ProjectName = projMap.get(ProjectId).Name;
            siteId = projMap.get(ProjectId).Site__c;   
        }
    }
    
    //Method to insert Lead record and to convert it based on condition 
    public PageReference doSave(){
        ErrorDetail='';
        Opportunity opp;
        system.debug('ChannelPartnerName: '+ChannelPartnerName);
        Savepoint sp = Database.SetSavePoint();
        mndtTrue = false;
        List<Account> conlstFinal = new List<Account>();
        Integer count=0;
        String mltslct = '';
        String FullNameLast='';
        String whatLook = '';
        //  String contactyoumul = '';
        String carpetaar = ''; 
        sctPrtylst = new List<String>(); 
        List<String> carpetArelst = new List<String>();
        List<String> heardUslst = new List<String>();
        LeadObj.Salutation = GetSal != null?GetSal:'';
        LeadObj.LastName = GetLastName != null?GetLastName:'';
        LeadObj.FirstName = (GetFirstName != null || GetFirstName != '')?GetFirstName:'';
        LeadObj.Email = Emailcon;
        LeadObj.MiddleName = GetMiddleName != null? GetMiddleName :'';
        LeadObj.mobilePhone = mbno;
        
        //new cp not selected
        
        
        
        
        system.debug(sameApplicant+'sameApplicant');
        //Insert Co-Applicant as a person Account
        for(Wrapper con : lstwrp){
            system.debug('lstwrp'+lstwrp);
            Account obj = new Account();
            if(con.actObj.FirstName!='' && con.actObj.FirstName !=null){
                count=count+1;
                obj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
                obj.salutation = con.actObj.salutation != null?con.actObj.salutation:'';
                obj.FirstName =  con.actObj.FirstName != null?con.actObj.FirstName:'';
                obj.LastName = con.actObj.LastName !=null?con.actObj.LastName:'';
                obj.MiddleName = con.actObj.MiddleName !=null?con.actObj.MiddleName:'';
                obj.Occupation__c = con.actObj.Occupation__c;
                obj.Industry = con.actObj.Industry__c;
                conlstFinal.add(obj);
                System.debug('conlstFinal: ' +conlstFinal);
            }
        }  
        if(conlstFinal.size()>0 && conlstFinal != null){
            try{ 
                Decimal i = conlstFinal.size()+1;
                integer j = 0;
                For(j=1;j<=i;j++){
                    For(Account a :conlstFinal){
                        if(j==1){
                            a.Contact_category__pc = 'Second Applicant';
                        }
                        if(j==2){
                            a.Contact_category__pc = 'Third Applicant';
                        }
                        if(j==3){
                            a.Contact_category__pc = 'Fourth Applicant';
                        }
                        if(j==4){
                            a.Contact_category__pc = 'Fifth Applicant';
                        }
                        J++;
                    }
                }
                insert conlstFinal;
            }
            catch(DMLException e){
                ApexPages.addMessages(e);system.debug('errror here'+e.getMessage());  mndtTrue = false; Database.rollback(sp); return null;
            }
        }
        if(carpetArea!=null && carpetArea!=''){
            if(carpetArea.contains(',')){
                carpetArelst=carpetArea.split(','); 
            }
            else{
                carpetArelst.add(carpetArea);
            }
        }
        
        if(heard!=null && heard!=''){
            if(heard.contains(',')){
                heardUslst=heard.split(','); 
            }
            else{
                heardUslst.add(heard);
            }
        }
        
        
        String crp='';   
        for(String str:carpetArelst){
            if(crp==''){
                crp=str;
            }else{
                crp=crp+';'+str;
            }
        }
        
        String hrds='';   
        for(String strHr:heardUslst){
            if(hrds==''){
                hrds=strHr;
            }else{
                hrds=hrds+';'+strHr;
            }
        }
        
        List<String> psgnlst = new List<String>();
        if(possesionTime!=null && possesionTime!=''){
            if(possesionTime.contains(',')){
                psgnlst=possesionTime.split(','); 
            }
            else{
                psgnlst.add(possesionTime);
            }
        }
        
        String psg='';   
        for(String str:psgnlst){
            if(psg==''){
                psg=str;
            }else{
                psg=psg+';'+str;
            }
        }
        if(slctRequment!=null && slctRequment !=''){
            if(slctRequment.contains(',')){
                sctPrtylst =slctRequment.split(','); 
            }
            else{
                sctPrtylst.add(slctRequment);
            }
        }system.debug(sctPrtylst+'sctPrtylst Vai');
        
        for(String str : carperareasel){
            if(carpetaar==''){
                carpetaar=str;
            }else{
                carpetaar=carpetaar+';'+str;
            }
        }
        carpetaar = carpetArea;
        mltslct = '';
        System.debug('+++sctPrtylst++'+sctPrtylst);
        for(String str : sctPrtylst){
            if(mltslct==''){
                mltslct=str;
            }else{
                mltslct=mltslct+';'+str;
            }
        }
        System.debug('+++mltslct+mltslct+'+mltslct);
        
        
        //Checking for all the required fields on page 2
        system.debug(bdgt+'bdgt'+slctRequment+'slctRequment'+carpetArea+'carpetArea'+hear+'hear'+howSoon+'howSoon'+purposeOfBuying+'purposeOfBuying'+LocationRating +'LocationRating'+possesionTime+'possesionTime'+Walkinsource+'Walkinsource'+LeadObj.PostalCode+'LeadObj.PostalCode'+LeadObj.street+'LeadObj.street'+LeadObj.City+'LeadObj.City');        
        if( bdgt != null && bdgt != '' && slctRequment!='' && slctRequment!=null && carpetArea!=null && carpetArea != null && hear!=null && hear!='' && howSoon!=null && howSoon !='' && purposeOfBuying!=null && purposeOfBuying!=''&& LocationRating !=null && LocationRating !=''  && possesionTime!=null && possesionTime!='' && LeadObj.Company_Custom__c!='' && Walkinsource!=null && Walkinsource !='' && LeadObj.Company_Custom__c!=null && LeadObj.Country_Picklist__c!=null && LeadObj.Locality__c != null && LeadObj.City__c != null){
            mndtTrue =true;
            system.debug(Walkinsource+' '+leadObj.Partner_s_Firm_Name__c+leadObj.Partner_s_Name__c);
            if(Walkinsource =='Partner' && (string.isBlank(ChannelPartnerName))&& ((leadObj.Partner_s_Firm_Name__c == '' || leadObj.Partner_s_Firm_Name__c== null) || (leadObj.Partner_s_Name__c== '' || leadObj.Partner_s_Name__c == null) || (leadObj.Partner_Mobile__c =='' || leadObj.Partner_Mobile__c == null) || (leadObj.Partner_Email__c =='' || leadObj.Partner_Email__c == null))){ 
                mndtTrue = false; 
            }
            if(sameApplicant=='No'){
                system.debug(leadObj.Contact_Person_Name__c +leadObj.Contact_Person_Mobile_1__c+ leadObj.Contact_Person_Relation_Designation__c + leadObj.Contact_Person_Email__c);
                if(leadObj.Contact_Person_Name__c=='' || leadObj.Contact_Person_Name__c==null || leadObj.Contact_Person_Relation_Designation__c=='' || leadObj.Contact_Person_Relation_Designation__c==null || leadObj.Contact_Person_Email__c=='' || leadObj.Contact_Person_Email__c==null || leadObj.Contact_Person_Mobile_1__c=='' || leadObj.Contact_Person_Mobile_1__c==null){
                    mndtTrue = false;
                }
            }
            /*  if(!(Pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', leadobj.Partner_Email__c))){
ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Valid Email Address'));
}*/
            
            //system.debug(contactyoumul+'contactyoumul');
            if(mndtTrue==True){
                if(sameApplicant != null && sameApplicant != ''){
                    LeadObj.Contact_Person_is_Same_as_Applicant__c = sameApplicant; 
                }if(EmailCon != null && EmailCon!= ''){
                    LeadObj.Email= EmailCon;
                }if(LeadObj.Nationality__c != null && LeadObj.Nationality__c!= ''){
                    LeadObj.Nationality__c= LeadObj.Nationality__c;
                }if(LeadObj.Designation__c!= null && LeadObj.Designation__c!= ''){
                    LeadObj.Designation__c= LeadObj.Designation__c;
                }/*if(LeadObj.Company_Address__c!= null && LeadObj.Company_Address__c!= ''){
LeadObj.Company_Address__c= LeadObj.Company_Address__c;
}if(contactyoumul != Null && contactyoumul != ''){
LeadObj.Preferred_Mode_of_Communication__c = contactyoumul;    
}if(occupation != Null && occupation != ''){
LeadObj.Occupation__c = occupation;
}*/
                if(LeadObj.Occupation_in_case_of_other__c!= Null && LeadObj.Occupation_in_case_of_other__c!= ''){
                    LeadObj.Occupation_in_case_of_other__c= LeadObj.Occupation_in_case_of_other__c;
                }if(CorAdress != Null && CorAdress != ''){
                    LeadObj.Address_for_Correspondence__c = CorAdress;
                }if(industry != Null && industry != ''){
                    LeadObj.Industry = industry;
                }if(residentStatus != Null && residentStatus != ''){
                    LeadObj.Resident_Status__c = residentStatus;
                }if(crp != Null && crp != ''){
                    LeadObj.Carpet_Area__c = crp;
                }if(hear != Null && hear != ''){
                    LeadObj.How_did_you_hear_about_us__c = hear;
                }if(hrds != Null && hrds != ''){
                    LeadObj.Other_Sources_Where_You_Heard_About_Us__c = hrds;
                }if(reachUs != Null && reachUs != ''){
                    LeadObj.How_Did_You_Reach_Out_To_Us__c = reachUs;
                }if(cResidence != Null && cResidence != ''){
                    LeadObj.Current_Ownership_of_Residence__c = cResidence;
                }if(howSoon != Null && howSoon != ''){
                    LeadObj.How_Soon_Do_You_Want_To_Buy__c = howSoon;
                }if(whatLook != Null && whatLook != ''){
                    LeadObj.Decision_Making_Factors__c = whatLook ;
                }
                system.debug('@@@###:'+Walkinsource);
                if(Walkinsource != Null && Walkinsource != ''){
                    LeadObj.Enquiry_Type__c = Walkinsource ;
                    if(Walkinsource !='Partner'){
                        LeadObj.Enquiry_Type__c = Walkinsource ;
                        LeadObj.Partner_s_Firm_Name__c = '';
                        LeadObj.Partner_s_Name__c = '';
                        LeadObj.Partner_s_PAN_Number__c = '';
                        LeadObj.Partner_s_RERA_Number__c = '';
                        LeadObj.Partner_Mobile__c = '';
                        LeadObj.PC_Mobile_Country_Code__c ='';
                        LeadObj.Partner_s_Office_Address__c ='';
                        LeadObj.Partner_Email__c ='';
                        LeadObj.PCID__c ='';    
                    }
                    else if(Walkinsource =='Partner' && chbox==false){
                        LeadObj.Enquiry_Type__c = Walkinsource ;
                        LeadObj.Partner_s_Firm_Name__c = '';
                        LeadObj.Partner_s_Name__c = '';
                        LeadObj.Partner_s_PAN_Number__c = '';
                        LeadObj.Partner_s_RERA_Number__c = '';
                        LeadObj.Partner_Mobile__c = '';
                        LeadObj.PC_Mobile_Country_Code__c ='';
                        LeadObj.Partner_s_Office_Address__c ='';
                        LeadObj.Partner_Email__c ='';
                        LeadObj.PCID__c ='';  
                    }
                    
                }
                LeadObj.Country_Code_for_Other_Mobile_Number__c = mbnoOtherflg;
                LeadObj.Country_Code__c = mbnoflg;                
                LeadObj.Category__c = cat;
                LeadObj.Country_Code_for_Office_Number__c = OfficeCode;
                LeadObj.Lead_Stage__c ='Converted to Opportunity';
                LeadObj.Country_Code_for_Phone__c =ResCode;
                LeadObj.Country = LeadObj.Country_Picklist__c;
                LeadObj.Status ='Converted to Opportunity';
                LeadObj.Data_Sheet_Submitted__c = true;
                leadObj.Data_Sheet_Submitted_Date__c = Date.today();
                //LeadObj.LeadSource = 'Kisok/data-sheet';
                LeadObj.Lead_Submitted_from_Kiosk__c =true;
                LeadObj.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
                // LeadObj.Project__c = ProjectId;
                LeadObj.Sub_Category__c= enquirySubCategory;
                LeadObj.Other_Mobile_Number__c = otMo;
                LeadObj.Site__c = projMap.get(ProjectId).Site__c;
                LeadObj.IS_Walkin__c = true;
                
                Date Expiry_Date;
                if(projMap.get(ProjectId).Cooling_Period_Days__c != null){
                    Decimal days=projMap.get(ProjectId).Cooling_Period_Days__c;
                    Date  newDate = System.Today();
                    Expiry_Date=newDate.addDays(Integer.valueOf(days));
                    LeadObj.Cooling_Period_Expiry_Date__c=Expiry_Date;
                }
                
                
                //added as per requirement
                LeadObj.mobilephone = mbno;
                try{
                    String flag= ApexPages.currentPage().getParameters().get('convertoppty');
                    if(Test.isRunningTest()){
                        flag = 'true';
                    }
                    system.debug(flag+'convertoppty*&*&');
                    if(flag == 'false'){
                        LeadObj.LeadSource = 'Kisok/data-sheet'; 
                        LeadObj.Project__c = ProjectId;
                        if(psg  != Null && psg != ''){
                            LeadObj.Possession_Timeliness__c = psg;
                        }if(purposeOfBuying != Null && purposeOfBuying != ''){
                            LeadObj.Purpose_of_Buying__c = purposeOfBuying;
                        }if(LocationRating != Null && LocationRating != ''){
                            LeadObj.Location_Rating__c = LocationRating ;
                        }
                        if(bdgt != null && bdgt != ''){
                            LeadObj.Budget__c = bdgt;                
                        }
                        LeadObj.Date_of_Enquiry__c =System.today();
                        LeadObj.Requirement__c =mltslct;
                        insert LeadObj;
                        
                        
                        system.debug(LeadObj+'^^^^');
                    }else if(flag== 'true'){
                        string ldsource =  ApexPages.currentPage().getParameters().get('lSource');
                        String ldI= ApexPages.currentPage().getParameters().get('LeadId');
                        //Added By Vaidehi on 27/06/2019
                        //Change to 17/02/2022
                        LeadObj.Status = 'Converted to Opportunity';
                        LeadObj.Lead_Stage__c = 'Converted to Opportunity';
                        system.debug(ldI+'LeadId))))))');
                        if(ldI != null) LeadObj.Id=ldI;
                        system.debug(ldsource+'ldsource');
                        if(ldsource == '' || ldsource == null)
                            LeadObj.LeadSource = 'Kisok/data-sheet';
                        update LeadObj;
                    }
                    system.debug('LeadObj.Lead_Stage__c&&'+LeadObj.Lead_Stage__c+LeadObj.Status);
                    system.debug('test^^^^^**'+'psg'+purposeOfBuying+bdgt+psg+LeadObj);
                    opptyId = getleadConvertprocess(LeadObj.ID, mbno,EmailCon );
                    opp = new Opportunity();
                    opp.id=opptyId;
                    if(psg  != Null && psg != ''){
                        opp.Possession_Timeliness__c = psg;
                    }if(purposeOfBuying != Null && purposeOfBuying != ''){
                        opp.Purpose_of_Buying__c = purposeOfBuying;
                    }if(LocationRating != Null && LocationRating != ''){
                        opp.Location_Rating__c = LocationRating ;
                    }if(bdgt != null && bdgt != ''){
                        opp.Budget__c = bdgt;                
                    }
                    opp.Email__c = EmailCon;
                    opp.Requirement__c =mltslct;
                    opp.Date_of_Enquiry__c =System.today();
                    //opp.LeadSource = 'Kisok/data-sheet';
                    opp.Project__c = ProjectId;
                    
                    if(Expiry_Date !=null)
                        opp.CloseDate=Expiry_Date;
                    
                    opp.StageName = 'New';
                    opp.Opportunity_Status__c ='Assigned to Front Desk'; 
                    opp.Name = LeadObj.Salutation + ' ' + LeadObj.FirstName + ' ' + LeadObj.MiddleName + ' ' + LeadObj.LastName;
                    opp.Name = opp.Name.normalizeSpace();
                    //opp.Change_In_Booking_Source__c ='.';
                    string dummy;
                    opp.Primary_Contact__c = contId != null?contID: dummy;
                    if(string.isNotBlank(ChannelPartnerName) && chbox==false){
                        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
                        List<Account> cList = new List<Account>();
                        string QueryString =  'Select id, Name  From Account Where RecordTypeId =: accRecordTypeId And Name = \''+ChannelPartnerName+'\'';
                        cList = Database.query(QueryString);
                        system.debug('cList:: '+clist);
                        if(!cList.isEmpty()){
                            opp.Broker_Account__c = cList[0].id;
                        }
                        
                    }
                    String Sb_link='https://oberoirealty--oberoidev.my.salesforce.com';
                    system.debug(contID+'contId');
                    if( chbox==true || opp.Broker_Account__c != null){
                        if(cp_signsaved ){
                            Attachment a=  new Attachment(
                                ContentType='image/jpeg',
                                Body=EncodingUtil.base64Decode(cp_fileData),
                                Name='CP_Signature',
                                ParentId = opp.id
                            );
                            insert a;
                            String img='<img src="'+Sb_link+ '/servlet/servlet.FileDownload?file=' + a.id+'"/>';
                            opp.CP_Signature__c=   img;
                        }
                        else{
                            LeadObj.id=null;
                            Database.rollback(sp);
                            hasError = false;
                            ErrorDetail='Please Save CP Signature';
                            system.debug('Error**');
                            return null; 
                        } 
                    } 
                    
                    
                    if(signsaved){
                        
                        Attachment a=  new Attachment(
                            ContentType='image/jpeg',
                            Body=EncodingUtil.base64Decode(fileData),
                            Name='Signature',
                            ParentId = opp.id
                        );
                        insert a;
                        String img='<img src="'+Sb_link+ '/servlet/servlet.FileDownload?file=' + a.id+'"/>';
                        opp.Signature__c=   img;
                    }
                    else{
                        LeadObj.id=null;
                        Database.rollback(sp);
                        hasError = false;
                        ErrorDetail='Please Save Signature';
                        system.debug('Error**');
                        return null; 
                    }
                    
                    
                    
                    update opp;
                    System.debug('opp ---------------------'+opp.OwnerId);
                    Boolean create_sv_result=insertSiteVisit(opp.id,opp.Project__c,opp.Broker_Account__c,Walkinsource,
                                                             opp.OwnerId,'New Visit');
                    if(!create_sv_result){
                        return null;
                    }
                    
                    /*if(signsaved){
String Sb_link='https://oberoirealty--oberoidev.my.salesforce.com';
Attachment a=  new Attachment(
ContentType='image/jpeg',
Body=EncodingUtil.base64Decode(fileData),
Name='Signature',
ParentId = opp.id
);
insert a;
opportunity l = [select id , Signature__c from opportunity where id= :opp.id];
String img='<img src="'+Sb_link+ '/servlet/servlet.FileDownload?file=' + a.id+'"/>';

l.Signature__c=   img;
update l;
}
else{
LeadObj.id=null;
Database.rollback(sp);
hasError = false;
ErrorDetail='Please Save Sign';

system.debug('Error**');
return null; 
}*/
                    
                    if(!Test.isRunningTest()){
                        thankyouSMS( LeadObj.Salutation+' '+LeadObj.FirstName + ' ' + LeadObj.MiddleName + ' ' +LeadObj.LastName,projMap.get(ProjectId).Sales_Head__c,projMap.get(ProjectId).Name ,'New Visit');
                        
                    }
                    
                    createCoOwner(conlstFinal,opptyId,LeadObj.Name); 
                    system.debug('&&&&&'+opp.Id); 
                    //Method to attach the data sheet to Opportunity
                    // DataSheetPDF.insertAttachment(opp.Id);                
                    PageReference newPageagn = new PageReference('/Customer_data_sheet');
                    newPageagn.setRedirect(true); 
                    hasError = true;                   
                    return null;
                }catch(exception ex){
                    
                    
                    LeadObj.id=null;
                    system.debug('@@@@@2');
                    Database.rollback(sp);
                    system.debug(ex.getMessage()+'****getError'+ex.getLineNumber());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'There are some errors. Please try again.'));
                    hasError = false;
                    ErrorDetail=ex.getMessage() + ex.getLineNumber();
                    
                    system.debug('Error**');
                    return null; 
                }
            }
        }else{
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'All Fields are Mandatory (*)'));
            system.debug('@@@@@3');
            Database.rollback(sp);
            system.debug('Error%%%%');
            mndtTrue = false; 
            return null; 
        }        
        return null;
    }
    public Boolean insertSiteVisit(id opptid,id projid,id broker,String Source_of_Walk_in,id ownerid,String visitType){
        Site_Visit__c svt=new Site_Visit__c();
        svt.Opportunity__c=opptid;
        svt.Project_of_Interest__c=projid;
        if(String.isNotBlank(ownerid))
            svt.OwnerId=ownerid;
        
        svt.Walk_in_Source__c= Source_of_Walk_in ;
        if(visitType=='New Visit'){
            if(String.isNotBlank(broker))
                svt.Channel_Partner__c=broker;
            svt.RecordTypeId= Schema.SObjectType.Site_Visit__c.getRecordTypeInfosByName().get('New Visit').getRecordTypeId();
        }
        if(visitType=='Re-Visit'){
            svt.RecordTypeId= Schema.SObjectType.Site_Visit__c.getRecordTypeInfosByName().get('Re-Visit').getRecordTypeId();
        }
        try{
            insert svt;
            return true;
        }catch(Exception ex){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'There are some errors. Please try again.'));
            hasError = false;
            ErrorDetail=ex.getMessage() + ex.getLineNumber();
            
            return false; 
        }
    }
    
    
    //Method will be called from 1st page of Data sheet for validation and number verification
    public PageReference saveDetails(){
        hasDuplicate=false;
        LeadList = New List<Lead>();
        Opportunity_List = new List<Opportunity>();
        Opportunity_List_null=true;
        Savepoint sp = Database.SetSavePoint();
        initialProject = slctProj;      
        Lead req = new Lead();
        
        //leadObj.Other_Mobile_Number__c = other_mbno;
        //leadobj.Email=lead_email;
        
        system.debug('mbno'+leadobj.FirstName);
        if(mbno=='' || leadobj.LastName == '' || leadobj.Email == '' ){//LastName == '' || || conobj.Email == ''
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Fill All Required Fields (*)'));
        }else if(leadobj.FirstName == null || leadobj.LastName == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Fill All Required Fields (*)'));               
        }else if(mbno=='' ){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter mobile number'));               
        }else if(mbno.length() != 10 || (!Pattern.matches('[0-9]{10}', mbno)) ){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid mobile no.')); 
        }else if(leadObj.Other_Mobile_Number__c!= '' && leadObj.Other_Mobile_Number__c.length() != 10  ){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Number Must Be 10 Digits')); 
        }else if(leadObj.Other_Mobile_Number__c!= '' && (!Pattern.matches('[0-9]{10}', leadObj.Other_Mobile_Number__c))){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid other  mobile no.')); 
        }else if(customerType != 'Others' && (subcustomerType==null || subcustomerType =='')){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select Sub Category'));
            return null;
        }else if(leadobj.Email == null ){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Email Address'));               
        }else if(!(Pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', leadobj.Email)) ){            
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Valid Email Address'));               
        }      
        else if((mbno.length()==10 && mbno != '') && leadobj.LastName != ''){
            
            system.debug('Done');
            GFN=leadobj.FirstName!= null?leadobj.FirstName:'';
            GMN =leadobj.MiddleName!= null?leadobj.MiddleName:'';
            GLN =leadobj.LastName!= null?leadobj.LastName:'';
            GEM = leadobj.Email!= null?leadobj.Email:'';
            GOC = leadobj.Occupation__c!= null?leadobj.Occupation__c:'';
            GIDS = leadobj.Industry!= null?leadobj.Industry:'';
            system.debug(leadobj.Salutation+'Sal');
            SAL = leadobj.Salutation != null?leadobj.Salutation:'';
            otMo = leadobj.Other_Mobile_Number__c != null?leadobj.Other_Mobile_Number__c:'';
            cat =customerType;
            List<Opportunity>oppList = new List<Opportunity>();
            string OppNAme;
            string opptyId;
            string pcontId;
            string lSource;
            
            //Checking for the duplicate Lead
            if(LeadObj.Other_Mobile_Number__c != '' ){
                LeadList = [Select Id,convertedOpportunity.Opportunity_Number__c,email,Lead_Number__c,IsConverted,convertedOpportunityId,convertedOpportunity.stageNAme,OwnerID,convertedContactId,convertedAccountId,convertedOpportunity.NAme,    LeadSource,Name, Data_sheet_Submitted__c,Project__c, Status,Mobile_No__c 
                            From Lead 
                            WHERE  (Site__c =:projMap.get(slctProj).Site__c ) 
                            AND (Lead_Stage__c !='Closed' AND Lead_Stage__c != 'Booked') 
                            AND ( Mobile_No__c =: otMo OR Mobile_No__c =: mbno OR Email=:leadObj.Email OR Other_Mobile__c=: otMo OR Other_Mobile__c =: mbno OR Phone__c =:mbno OR Phone__c=: otMo )];
            }else{
                LeadList = [Select Id,email,convertedOpportunity.Opportunity_Number__c,Lead_Number__c,IsConverted,convertedOpportunityId,convertedOpportunity.stageNAme,convertedContactId,convertedAccountId,convertedOpportunity.Name,OwnerID,LeadSource,Name, Data_sheet_Submitted__c,Project__c, Status,Mobile_No__c 
                            From Lead 
                            WHERE  (Site__c =:projMap.get(slctProj).Site__c ) 
                            AND (Lead_Stage__c !='Closed' AND Lead_Stage__c != 'Booked') 
                            AND (  Mobile_No__c =: mbno OR Email=:leadObj.Email OR  Other_Mobile_Number__c =: mbno OR Phone__c =:mbno  )                            
                            AND convertedOpportunity.stageNAme != 'Booked']; }            
            
            // identify opportunity for list in multiple records
            set<id> opidlist=new set<id>();
            for(Lead lList:LeadList){
                if(lList.IsConverted)
                    opidlist.add(lList.ConvertedOpportunityId); 
            }
            if(opidlist.size()>0){
                Opportunity_List = [select id,name,Opportunity_Number__c,StageName,Mobile__c,Email__c,Project__c
                                    from opportunity where id IN :opidlist]; 
                Opportunity_List_null=false;
            }
            // end
            
            try{  
                if(LeadList.size()>1){
                    hasDuplicate=true;
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'multiple record found'));
                    return null;
                }
                else if(LeadList.size()>0){ 
                    hasDuplicate=false;
                    for(Lead request : LeadList){
                        if(request.convertedOpportunityId != null &&  request.status =='Converted to Opportunity'){
                            updateOppty = true; 
                            opportunityName = request.convertedOpportunity.Name;
                            opportunityNo = request.convertedOpportunity.Opportunity_Number__c;
                            opportunityId= request.convertedOpportunityId;
                            primcontactId = request.convertedContactId;
                            
                            
                        }else if (request.convertedOpportunityId == null && request.status !='Closed'){
                            convertoppty = 'true';
                            LeadId= request.Id;
                            lSource = request.LeadSource; 
                        }                    
                    }
                    if(updateOppty){
                        newPagePartialUrl = '#';
                        redirectToPage();
                    }
                    system.debug(convertoppty+LeadId+'@#@#@#@');
                    if(convertoppty == 'true'){
                        ApexPages.currentPage().getParameters().put('LeadId', LeadId);
                        ApexPages.currentPage().getParameters().put('convertoppty', convertoppty);
                        newPagePartialUrl = '/apex/Customer_Data_Sheet?LN='+GLN+'&FN='+GFN+'&EM='+GEM+'&PH='+mbno+'&PHCode='+mbnoflg+'&otmocode='+mbnoOtherflg+'&PJ='+slctProj+'&SL='+Sal+'&MN='+GMN+'&OC='+GOC+'&IDS='+GIDS+'&subCat='+subcustomerType+'&otMo='+otMo+'&convertoppty='+convertoppty+'&LeadId='+LeadId+'&lSource='+lSource+'&customerType='+customerType;
                        redirectToPage();
                    } 
                }else if(LeadList.size()==0 || LeadList==null){
                    hasDuplicate=false;
                    convertoppty = 'false';
                    newPagePartialUrl = '/apex/Customer_Data_Sheet?LN='+GLN+'&FN='+GFN+'&EM='+GEM+'&PH='+mbno+'&PHCode='+mbnoflg+'&otmocode='+mbnoOtherflg+'&PJ='+slctProj+'&SL='+Sal+'&MN='+GMN+'&OC='+GOC+'&IDS='+GIDS+'&subCat='+subcustomerType+'&otMo='+otMo+'&convertoppty='+convertoppty+'&customerType='+customerType;
                    redirectToPage();
                }else{
                    hasDuplicate=false;
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your details already exists with us. Kindly connect with the executive at the Reception Desk for further assistance'));
                    return null;
                }
            }catch(exception ex){
                Database.rollback(sp);
                system.debug(ex.getMessage()+'****getError');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'There are some errors. Please try again.'));
                return null; 
            }
            
        }
        //redirectToPage();
        return null;
    }
    
    //Method to reset OTP 
    public void resetOTP() {
        generatedOTP = '';
        redirectToPage();
    }
    
    public PageReference redirectToPage(){
        system.debug(generatedOTP+'generatedOTP');
        if(String.isBlank(generatedOTP)){
            generateOTP();
            displayOTPPanel = true;
        }
        else if(String.isNotBlank(generatedOTP) && !generatedOTP.equals(otpCharString)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Entered OTP is incorrect.'));
        }
        else if(String.isBlank(newPagePartialUrl)){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Next Page is unavailable. Please contact admin.'));
                                                  }
        else{         
            newPagePartialUrl = newPagePartialUrl.replace(initialProject, slctProj);           
            initialProject = slctProj; 
            PageReference newPage = new PageReference(newPagePartialUrl);
            newPage.setRedirect(true);
            if(updateOppty){
                Boolean succ= updateOppty();
                system.debug(succ+'succ');
                if(succ) {
                    displayOTPPanel = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your Details already exists with us and We have assigned Opportunity to our front desk team. Opportunity No. '+opportunityNo));}
            }else{
                return newPage;
            }           
        }       
        System.debug('displayOTPPanel: ' +displayOTPPanel);
        return null;
    }
    
    public Boolean updateOppty(){
        Boolean Successs = false;
        Boolean isRevisit=false;
        Boolean create_sv_result=false;
        
        if(updateOppty){
            try {
                list <Site_Visit__c> site_visit_list = [select id ,ownerid
                                                        from Site_Visit__c
                                                        where opportunity__c =: opportunityId
                                                       ];
                
                list <Opportunity> oppList1 = [select id,Sales_Head__c,Broker_Account__c, ownerid,StageName, Project__c, Opportunity_Status__c, Name,Source_of_Walk_in_Booking__c
                                               from Opportunity
                                               where Id =: opportunityId
                                               Limit 1];
                
                if(!oppList1.isEmpty()){
                    if(oppList1[0].StageName != 'Lost'){
                        
                        Opportunity oppt = new Opportunity();
                        oppt.id= opportunityId;
                        oppt.StageName='New';
                        oppt.Project__c =slctProj;
                        oppt.site__c = projMap.get(slctProj).site__c;
                        oppt.Primary_Contact__c = primcontactId;
                        oppt.Opportunity_Status__c = 'Assigned to Front Desk';
                        oppt.Change_In_Booking_Source__c ='.';
                        
                        //update oppt; 
                        opptyName = oppt.Name;
                        
                        
                        if(site_visit_list.size()>0){
                            isRevisit=true;
                            create_sv_result=insertSiteVisit(oppList1[0].id,oppList1[0].Project__c,oppList1[0].Broker_Account__c,
                                                             '',oppList1[0].ownerid,'Re-Visit');
                        }else if(site_visit_list.size()==0){
                            isRevisit=false;
                            create_sv_result=insertSiteVisit(oppList1[0].id,oppList1[0].Project__c,oppList1[0].Broker_Account__c,
                                                             oppList1[0].Source_of_Walk_in_Booking__c,oppList1[0].ownerid,'New Visit');
                        }
                        
                    }else{
                        //This will create task for Opportunity if it is in lost stage; without updating any field
                        Task t = new task();
                        t.RecordTypeId= Schema.SObjectType.Task.getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId();
                        t.WhatId = oppList1[0].id;                        
                        t.Subject = 'Assigned to Frontdesk';
                        t.priority= 'Normal';
                        t.ActivityDate = system.Today();
                        t.Completion_by_Date__c = system.Now()+1;
                        t.OwnerId =  projMap.get(slctProj).Front_Desk_User__c;
                        t.status = 'In Progress';
                        t.Opportunity_Stage__c ='New';
                        t.Opportunity_Status__c ='Assigned to Front Desk';
                        insert t;
                        
                        if(site_visit_list.size()>0){
                            isRevisit=true;
                            create_sv_result=insertSiteVisit(oppList1[0].id,oppList1[0].Project__c,oppList1[0].Broker_Account__c,
                                                             '',oppList1[0].ownerid,'Re-Visit');
                            
                        }else if(site_visit_list.size()==0){
                            isRevisit=false;
                            create_sv_result=insertSiteVisit(oppList1[0].id,oppList1[0].Project__c,oppList1[0].Broker_Account__c,
                                                             oppList1[0].Source_of_Walk_in_Booking__c,oppList1[0].ownerid,'New Visit');
                            
                        }
                    }
                    if(create_sv_result == false)
                        Successs = false;
                    else if(create_sv_result == true){
                        Successs = true;
                        if( isRevisit==true){
                            if(!Test.isRunningTest()){
                                thankyouSMS(  LeadObj.Salutation+' '+LeadObj.FirstName + ' ' + LeadObj.MiddleName + ' ' +LeadObj.LastName, oppList1[0].Sales_Head__c , projMap.get(slctProj).Name,'Re visit');
                            }
                        }
                        else if( isRevisit==false){
                            if(!Test.isRunningTest()){
                                thankyouSMS(  LeadObj.Salutation+' '+LeadObj.FirstName + ' ' + LeadObj.MiddleName + ' ' +LeadObj.LastName, oppList1[0].Sales_Head__c , projMap.get(slctProj).Name,'New Visit');
                            }
                        }
                    }
                    
                }                
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'There are some errors. Please try again.'+e.getMessage() + e.getLineNumber()));
            } 
            
        }
        return Successs;
    }
    
    
    //Method For generate OTP
    public void generateOTP() {
        generatedOTP = '';
        generatedOTP = generateRandomString(4);
        System.debug('====> OTP ====> ' + generatedOTP);
        String statMess = 'Welcome to the Customer Experience Centre of Oberoi Realty. '+generatedOTP+' is the OTP for completing your registration. The OTP is valid for 5 minutes. ';
        String mbNoStr = mbnoflg + mbNo;
        mbNoStr = mbNoStr.removeStart('+');
        System.debug(mbNoStr);
        try{
            String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
            EnquirySMSCtrl.sendSMS(smsURL);
            //displayOTPPanel = true;
            CIF_Default_Email__c deEmail =  CIF_Default_Email__c.getOrgDefaults();            
            if(deEmail.Email_Address__c != null && GEM != null )  sendOTPMail(GEM, statMess);            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Your OTP is sent to entered mobile number.'));        
        }catch(exception ex){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Your session is out. Please try again.'));
                             system.debug(ex.getMessage()+'****getError'); }
    }
    public void thankyouSMS( String name, id SalesHeadid , String projid,String visitType) {
        System.debug('SMS PARAMETERS :' );
        System.debug('SMS SalesHeadid : '+SalesHeadid );
        System.debug('SMS projid :' +projid);
        System.debug('SMS visitType :'+visitType );
        
        
        //sales head details
        System.debug('salesheadid----------'+SalesHeadid);
        System.debug('projid----------'+projid);
        User u=[select id,MobilePhone,name from user where id=:SalesHeadid];
        String statMess='';
        
        if(visitType.equals('New Visit')){
            statMess ='Dear ' +name+', Thank you for visiting Oberoi Realty at '+projid+'. For further assistance, you can reach me at '+u.MobilePhone+'.Thanks, '+ u.Name ; 
        }
        else if(visitType.equals('Re visit')){
            statMess = 'Dear '+name+', Thank you for visiting Oberoi Realty again at '+projid+'. For further assistance, you can reach me at '+u.MobilePhone+'. Thanks, '+u.Name+'';
        }
        System.debug('sms --- '+ statMess);
        String mbNoStr = mbnoflg + mbNo;
        mbNoStr = mbNoStr.removeStart('+');
        System.debug(mbNoStr);
        try{
            String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
            System.debug('sms --- 1 : '+smsURL);
            EnquirySMSCtrl.sendSMS(smsURL);
            
        }catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Your session is out. Please try again.'));
            system.debug(ex.getMessage()+'****getError'); }
    }
    
    //Method to create random string for OTP
    public static String generateRandomString(Integer len) {
        final String chars = '0123456789';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
    //SMS and Email will be triggered from this method
    public void sendOTPMail(String toAddress, String statMess){
        OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress limit 1];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { toAddress };
            message.subject = 'OTP';
        message.setOrgWideEmailAddressId(owa.id);//Changes added on 29/07 regarding case 00001075 from Prod
        message.plainTextBody = 'Hi '+ GFN+ '\n'+'\n' +statMess +'\n'+'\n' +'Thank You,'+'\n'+'System Admin';
        //message.setSenderDisplayName('ORL CRM');
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        }
        else{System.debug('The email failed to send: ' + results[0].errors[0].message); }
    }
    
    
    //Logic to Add a row
    public void doAdd(){
        system.debug(lstwrp);
        Contact conobjwrap = new Contact();
        if(lstwrp.size()<=4){
            lstwrp.add(new Wrapper(conobjwrap,lstwrp.size()));
        }
    }
    
    
    // Logic to remove a row
    public void doRem(){
        System.debug('++++'+prmVal);
        if(prmVal != null && prmVal != '') {
            Integer tempParam = Integer.valueOf(prmVal);
            lstwrp.remove(tempParam);
        }
        for(Integer i=0; i<lstwrp.size(); i++){
            lstwrp[i].count= i;
        }         
    }
    
    
    public Class Wrapper{
        public Contact actObj {get; set;}
        public Integer count {get; set;}        
        public Wrapper(Contact actObj,Integer count){
            this.actObj = new Contact();
            this.count = count;
        }
    }
    
    //MEthod to convert created Lead    
    public static String getleadConvertprocess(String leadId, string mob, string email){ 
        string custId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        //Checking for duplicate Account
        list<Account> acList = [SELECT id, Name, PersonMobilePhone, PersonEmail FROM Account where (Mobile_No__c =: mob OR PersonEmail =:email) AND RecordtypeId =: custId LIMIT 1] ;         
        List<Database.LeadConvert> lstLeadconvert = new List<Database.LeadConvert>();
        LeadStatus Leads= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        //String num = '0'+leadId;
        system.debug(Leads+leadId+'Leads*(*(*');
        // Lead currentlead = [select id,Lead_Number__c from lead where Id =: leadId limit 1];
        // system.debug(currentlead+'currentlead');
        if(leadId != null){
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(leadId);
            lc.ConvertedStatus = Leads.MasterLabel;
            if(acList.size() > 0){
                //Merging Account
                system.debug(acList[0]+'AccountData****');
                lc.setAccountId(acList[0].Id);}            
            Id oppId;
            Database.LeadConvertResult lcr = Database.convertLead(lc);       
            if(lcr.isSuccess()){
                system.debug('*****');
                oppId = lcr.getOpportunityId();
                contId = lcr.getContactId();
            }
            system.debug(oppId+'opptyId');
            return oppId;
        }else { return null;} 
    }
    
    //Method to create Co onwer
    public static void createCoOwner(list <Account>PAccountList ,String oppId, string coName){
        List<Co_Owner__c> coOwnerList = new List<Co_Owner__c>();
        for(Account acc : PAccountList){
            Co_Owner__c obj = new Co_Owner__c();
            obj.Person_Account__c = acc.Id;
            obj.Opportunity__c = oppId;
            coOwnerList.add(obj);
            system.debug('test'+coOwnerList);
            //  }
            //  
        } 
        if(coOwnerList.size()>0 && coOwnerList != null){
            try{ insert coOwnerList;}
            catch(DMLException e){ ApexPages.addMessages(e);system.debug(e.getMessage()+'***Erooklcxlk');}
        }
        // return null;
    }
    
    public void sendOTPMail_Dummy1(String toAddress, String statMess){
        if(Test.isRunningTest()){
            OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress limit 1];
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { toAddress };
                message.subject = 'OTP';
            message.setOrgWideEmailAddressId(owa.id);//Changes added on 29/07 regarding case 00001075 from Prod
            message.plainTextBody = 'Hi '+ '\n'+'\n' +statMess +'\n'+'\n' +'Thank You,'+'\n'+'System Admin';
            //message.setSenderDisplayName('ORL CRM');
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            }
            else{System.debug('The email failed to send: ' + results[0].errors[0].message); }
        }
    }
    
    public void sendOTPMail_Dummy2(String toAddress, String statMess){
        if(Test.isRunningTest()){
            OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress limit 1];
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { toAddress };
                message.subject = 'OTP';
            message.setOrgWideEmailAddressId(owa.id);//Changes added on 29/07 regarding case 00001075 from Prod
            message.plainTextBody = 'Hi '+ '\n'+'\n' +statMess +'\n'+'\n' +'Thank You,'+'\n'+'System Admin';
            //message.setSenderDisplayName('ORL CRM');
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            }
            else{System.debug('The email failed to send: ' + results[0].errors[0].message); }
        }
    }
    
    public pageReference searchAccounts(){
        
        string query ='';
        
        if(name !=''){
            
            query = 'Select Name  From Account Where Name like \''+name+'%\' LIMIT 5';
            baccounts = database.query(query);
        }
        else{
            
            query = 'Select Name From Account LIMIT 5';
            baccounts = database.query(query);
        }
        
        return null;
    }
    public PageReference chboxaction() {
        if(chbox==true){
            
            file1ren=true;
            file2ren=false;
            
        }
        else{
            file1ren=false;
            file2ren=true;
        }
        return null;
    }
    
    @RemoteAction
    global static List<string> getCPAccounts(String cpname) {
        system.debug('cpname: '+cpname);
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
        List<Account> cList = new List<Account>();
        List<string> cName = new List<string>();
        string QueryString =  'Select id, Name  From Account Where RecordTypeId =: accRecordTypeId And Name like \''+cpname+'%\' LIMIT 5';
        cList = Database.query(QueryString);
        system.debug('cList:: '+clist);
        if(!clist.isEmpty()) {
            for(Account c : cList) {
                cName.add(c.Name);
            }
        }Else{
            //cName.add('No CP Found');
        }
        return cname;
    }
    public pageReference saveImage() {
        
        signsaved=true;
        return null;
    }
    public pageReference clearImage() {
        fileData=null;
        signsaved=false;
        return null;
    }
    
    public pageReference cp_saveImage() {
        
        cp_signsaved=true;
        return null;
    }
    public pageReference cp_clearImage() {
        cp_fileData=null;
        cp_signsaved=false;
        return null;
    }
    
    
    
    
}
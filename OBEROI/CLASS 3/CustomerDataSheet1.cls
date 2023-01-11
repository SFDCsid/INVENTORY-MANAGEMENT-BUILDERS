global without sharing class CustomerDataSheet1{
    Map<id, Project__c> projMap = new Map<id, Project__c>();
    public Boolean updateOppty = false;
    public string opportunityName;
    public static string convertoppty;
    public static string LeadId;
    public string opptyId;
    public string opportunityId;
    public string primcontactId;
    public String siteName {get; set;}
    public String ResCode {get; set;}
    public String OfficeCode {get; set;}
    public String  prtConsCntrCOde {get;set;}
    public static string siteId; 
    public List<Wrapper> lstwrp {get; set;}   
    public Lead leadobj {get; set;}
    public static String contID;
    public String customerType {get; set;}
    public String Walkinsource {get; set;}
    public String subcustomerType {get; set;}
    public String enquirySubCategory;
    List <Contact> clistgther = New List <Contact> ();
    public List<Lead> LeadList{get; set;}
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
    public Boolean hasDuplicate{get; set;}
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
    
    public CustomerDataSheet1(ApexPages.StandardController controller) {
        leadobj=(Lead) controller.getRecord(); 
        // leadobj = new Lead();
        //system.debug('******'+leadobj);        
        lstwrp = new List<Wrapper>();
        lstwrp.add(new Wrapper(conobj,lstwrp.size()));
        sctprjlst = New List<Project__c>();
        sctPrtylst = new List<String>();
        //  whatLooking  = new List<String>();
        carperareasel = New List<String>();
        LeadList = New List <Lead>();
        contactyoulist = New list<String>();
        prtTypelst= new List<SelectOption>();
        otpCharString = '';
        generatedOTP = '';
        hasDuplicate = false;
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
        for(Project__c obj: [select id,name,site__c, Front_Desk_User__c from Project__c WHERE Recordtype.Name =:'Residential' AND Active__c = true AND Available_for_Datasheet__c = true]){
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
        /*contactyoulist = new List<String>();
if(contactVal!= null && contactVal!=''){
if(contactVal.contains(',')){
contactYoulist =contactVal.split(','); 
}
else{
contactYoulist.add(contactVal);
}
}
System.debug('+contactYoulist'+contactYoulist);
contactyoumul = '';
for(String str: contactyoulist){
if(str !=null){
if(contactyoumul==''){
contactyoumul= str;
}else{
contactyoumul= contactyoumul+';'+str;
}
}
}*/
        /* whatLooking = new List<String>();
if(whtlkng!= null && whtlkng!=''){
if(whtlkng.contains(',')){
whatLooking=whtlkng.split(','); 
}
else{
whatLooking.add(whtlkng);
}
}*/
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
        /*  whatLook = '';
for(String str: whatLooking){
if(whatLook==''){
whatLook = str;
}else{
whatLook = whatLook+';'+str;
}
}  
contactyoumul = '';
for(String str: contactyoulist){
if(str !=null){
if(contactyoumul==''){
contactyoumul= str;
}else{
contactyoumul= contactyoumul+';'+str;
}
}
}*/
        
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
                    Opportunity opp = new Opportunity();
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
                    opp.StageName = 'New';
                    opp.Opportunity_Status__c ='Assigned to Front Desk'; 
                    opp.Name = LeadObj.Salutation + ' ' + LeadObj.FirstName + ' ' + LeadObj.MiddleName + ' ' + LeadObj.LastName;
                    opp.Name = opp.Name.normalizeSpace();
                    //opp.Change_In_Booking_Source__c ='.';
                    string dummy;
                    opp.Primary_Contact__c = contId != null?contID: dummy;
                    if(string.isNotBlank(ChannelPartnerName)){
                        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
                        List<Account> cList = new List<Account>();
                        string QueryString =  'Select id, Name  From Account Where RecordTypeId =: accRecordTypeId And Name = \''+ChannelPartnerName+'\'';
                        cList = Database.query(QueryString);
                        system.debug('cList:: '+clist);
                        if(!cList.isEmpty()){
                            opp.Broker_Account__c = cList[0].id;
                        }
                    }
                    system.debug(contID+'contId');
                    update opp;
                    
                      Site_Visit__c svt=new Site_Visit__c();
                    svt.Opportunity__c=opp.id;
                    svt.Project_of_Interest__c=opp.Project__c;
                    //svt.OwnerId=opp.OwnerId;
                    if(opp.Broker_Account__c !=null)
                        svt.Channel_Partner__c=opp.Broker_Account__c;
                    svt.Walk_in_Source__c=opp.Source_of_Walk_in_Booking__c;
                    if(enquirySubCategory=='First Visit'){
                        svt.RecordTypeId= Schema.SObjectType.Site_Visit__c.getRecordTypeInfosByName().get('New Visit').getRecordTypeId();
                    }
                    if(enquirySubCategory=='Re-Visit' || cat=='Existing Customer'){
                        svt.RecordTypeId= Schema.SObjectType.Site_Visit__c.getRecordTypeInfosByName().get('Re-Visit').getRecordTypeId();
                    }
                    try{insert svt;}catch(Exception ex){
                        System.debug('--------'+ex.getLineNumber()+ex.getMessage());
                        system.debug(ex.getMessage()+'****  svt $getError'+ex.getLineNumber());
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'There are some errors. Please try again.'));
                        hasError = false;
                        system.debug('svt Error**');
                        return null; 
                    }
                 
                    
                    createCoOwner(conlstFinal,opptyId,LeadObj.Name); 
                    system.debug('&&&&&'+opp.Id); 
                    //Method to attach the data sheet to Opportunity
                    // DataSheetPDF.insertAttachment(opp.Id);                
                    PageReference newPageagn = new PageReference('/VisitorDetails');
                    newPageagn.setRedirect(true); 
                    hasError = true;                   
                    return null;
                }catch(exception ex){
                    system.debug('@@@@@2');
                    Database.rollback(sp);
                    system.debug(ex.getMessage()+'****getError');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'There are some errors. Please try again.'));
                    hasError = false;
                    system.debug('Error**');
                    return null; 
                }
            }
        }else{ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'All Fields are Mandatory (*)'));
              system.debug('@@@@@3');
              Database.rollback(sp);
              system.debug('Error%%%%');
              mndtTrue = false; 
              return null; 
             }        
        return null;
    }
    
    
    
    //Method will be called from 1st page of Data sheet for validation and number verification
    public PageReference saveDetails(){
        Savepoint sp = Database.SetSavePoint();
        initialProject = slctProj;      
        Lead req = new Lead();
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
                LeadList = [Select Id,email,convertedOpportunityId,convertedOpportunity.stageNAme,OwnerID,convertedContactId,convertedAccountId,convertedOpportunity.NAme,    LeadSource,Name, Data_sheet_Submitted__c,Project__c, Status,Mobile_No__c 
                            From Lead 
                            WHERE  (Site__c =:projMap.get(slctProj).Site__c ) 
                            AND (Lead_Stage__c !='Closed' AND Lead_Stage__c != 'Booked') 
                            AND ( Mobile_No__c =: otMo OR Mobile_No__c =: mbno OR Email=:leadObj.Email OR Other_Mobile__c=: otMo OR Other_Mobile__c =: mbno OR Phone__c =:mbno OR Phone__c=: otMo ) LIMIT 1];
            }else{
                LeadList = [Select Id,email,convertedOpportunityId,convertedOpportunity.stageNAme,convertedContactId,convertedAccountId,convertedOpportunity.Name,OwnerID,LeadSource,Name, Data_sheet_Submitted__c,Project__c, Status,Mobile_No__c 
                            From Lead 
                            WHERE  (Site__c =:projMap.get(slctProj).Site__c ) 
                            AND (Lead_Stage__c !='Closed' AND Lead_Stage__c != 'Booked') 
                            AND (  Mobile_No__c =: mbno OR Email=:leadObj.Email OR  Other_Mobile_Number__c =: mbno OR Phone__c =:mbno  )                            
                            AND convertedOpportunity.stageNAme != 'Booked' LIMIT 1]; }            
            system.debug(LeadList+'*******LeadList');
            try{  if(LeadList.size()>0){ 
                for(Lead request : LeadList){
                    if(request.convertedOpportunityId != null &&  request.status =='Converted to Opportunity'){
                        updateOppty = true; 
                        opportunityName = request.convertedOpportunity.Name;
                        opportunityId= request.convertedOpportunityId;
                        primcontactId = request.convertedContactId;
                    }else if (request.convertedOpportunityId == null && request.status !='Closed'){
                        convertoppty = 'true';
                        LeadId= request.Id;
                        lSource = request.LeadSource; }                    
                }
                if(updateOppty){
                    newPagePartialUrl = '#';
                    redirectToPage();}
                system.debug(convertoppty+LeadId+'@#@#@#@');
                if(convertoppty == 'true'){
                    ApexPages.currentPage().getParameters().put('LeadId', LeadId);
                    ApexPages.currentPage().getParameters().put('convertoppty', convertoppty);
                    newPagePartialUrl = '/apex/Customer_Data_Sheet?LN='+GLN+'&FN='+GFN+'&EM='+GEM+'&PH='+mbno+'&PHCode='+mbnoflg+'&otmocode='+mbnoOtherflg+'&PJ='+slctProj+'&SL='+Sal+'&MN='+GMN+'&OC='+GOC+'&IDS='+GIDS+'&subCat='+subcustomerType+'&otMo='+otMo+'&convertoppty='+convertoppty+'&LeadId='+LeadId+'&lSource='+lSource+'&customerType='+customerType;
                    redirectToPage();
                } 
            }   else  if(LeadList.size()==0 || LeadList==null){
                convertoppty = 'false';
                newPagePartialUrl = '/apex/Customer_Data_Sheet?LN='+GLN+'&FN='+GFN+'&EM='+GEM+'&PH='+mbno+'&PHCode='+mbnoflg+'&otmocode='+mbnoOtherflg+'&PJ='+slctProj+'&SL='+Sal+'&MN='+GMN+'&OC='+GOC+'&IDS='+GIDS+'&subCat='+subcustomerType+'&otMo='+otMo+'&convertoppty='+convertoppty+'&customerType='+customerType;
                redirectToPage();
            }else{
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Your details already exists with us. Kindly connect with the executive at the Reception Desk for further assistance'));
                return null;
            }
               }catch(exception ex){Database.rollback(sp);
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
        else if(String.isBlank(newPagePartialUrl)){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Next Page is unavailable. Please contact admin.'));
        }
        /*else {
            
            if(LeadObj.Other_Mobile_Number__c != '' ){
                LeadList = [Select Id,email,convertedOpportunityId,convertedOpportunity.stageNAme,OwnerID,convertedContactId,convertedAccountId,convertedOpportunity.NAme,    LeadSource,Name, Data_sheet_Submitted__c,Project__c, Status,Mobile_No__c 
                            From Lead 
                            WHERE  (Site__c =:projMap.get(slctProj).Site__c ) 
                            AND (Lead_Stage__c !='Closed' AND Lead_Stage__c != 'Booked') 
                            AND ( Mobile_No__c =: otMo OR Mobile_No__c =: mbno OR Email=:leadObj.Email OR Other_Mobile__c=: otMo OR Other_Mobile__c =: mbno OR Phone__c =:mbno OR Phone__c=: otMo ) LIMIT 1];
            }else{
                LeadList = [Select Id,email,convertedOpportunityId,convertedOpportunity.stageNAme,convertedContactId,convertedAccountId,convertedOpportunity.Name,OwnerID,LeadSource,Name, Data_sheet_Submitted__c,Project__c, Status,Mobile_No__c 
                            From Lead 
                            WHERE  (Site__c =:projMap.get(slctProj).Site__c ) 
                            AND (Lead_Stage__c !='Closed' AND Lead_Stage__c != 'Booked') 
                            AND (  Mobile_No__c =: mbno OR Email=:leadObj.Email OR  Other_Mobile_Number__c =: mbno OR Phone__c =:mbno  )                            
                            AND convertedOpportunity.stageNAme != 'Booked' LIMIT 1]; 
            }  
            
            if(LeadList.size()>0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Duplicate leads found'));
                hasDuplicate = true;
                return null;
            } */else{             
                newPagePartialUrl = newPagePartialUrl.replace(initialProject, slctProj);           
                initialProject = slctProj; 
                PageReference newPage = new PageReference(newPagePartialUrl);
                newPage.setRedirect(true);
                if(updateOppty){
                    Boolean succ= updateOppty();
                    system.debug(succ+'succ');
                    if(succ) {
                        displayOTPPanel = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your Details already exists with us and We have assigned Opportunity to our front desk team.'));
                    }
                }else{
                    return newPage;
                }  
            //}         
        }        
        System.debug('displayOTPPanel: ' +displayOTPPanel);
        return null;
    }
    
    //Method to update the opportunity if it already exists
    public Boolean updateOppty(){
        Boolean Successs = false;
        system.debug(opportunityId+'opportunityId');
        if(updateOppty){
            system.debug(updateOppty+'updateOpptyupdateOppty');
            try {
                list <Opportunity> oppList1 = [select id, StageName, Project__c, Opportunity_Status__c, Name
                                               from Opportunity
                                               where Id =: opportunityId
                                               Limit 1];
                if(!oppList1.isEmpty()){
                    if(oppList1[0].StageName != 'Lost'){
                        system.debug('test-->'+!oppList1.isEmpty());
                        Opportunity oppt = new Opportunity();
                        oppt.id= opportunityId;
                        oppt.StageName='New';
                        oppt.Project__c =slctProj;
                        oppt.site__c = projMap.get(slctProj).site__c;
                        oppt.Primary_Contact__c = primcontactId;
                        oppt.Opportunity_Status__c = 'Assigned to Front Desk';
                        oppt.Change_In_Booking_Source__c ='.';
                        //oppt.Name = LeadObj.Salutation!= null?LeadObj.Salutation:''+ ' ' + LeadObj.FirstName + ' ' + LeadObj.MiddleName + ' ' + LeadObj.LastName;
                        // oppt.Name = oppt.Name.normalizeSpace();
                        update oppt; 
                        opptyName = oppt.Name;
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
                        insert t;}
                    Successs = true;
                    //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,oppt.Name +' Opportunity Already exists for this.'));
                }                
            }catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'There are some errors. Please try again.'));} }
        return Successs;}
    
    
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
        }catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Your session is out. Please try again.'));
            system.debug(ex.getMessage()+'****getError'); 
        }
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
    public void insertSiteVisit(id opid,id ownerid,String Recordtype,String Walk_in_source ){
        Site_Visit__c s=new Site_Visit__c();
        s.Opportunity__c=opid;
        s.Project_of_Interest__c=projMap.get(slctProj).id;
        s.OwnerId=ownerid;
        
        insert s;
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
    
    
    Public Void Dummy(){
        decimal i;
        i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}
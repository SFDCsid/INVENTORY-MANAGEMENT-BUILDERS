public class specialCondition {
    public Integer searchText {get;set;}
    public string BookingId{get;set;}
    public list<Booking__c> lstBooking{get;set;}
    public list<Project__c> lstProj{get;set;}
    public String htmltext {get; set;}
    public String itc {get; set;}
    List<SelectOption> pickListValuesList {get;set;}
    public String Gettag{get;set;}
    public boolean status{get;set;}   
    public List<SelectOption> docTypeLst {get;set;} 
    public List<SelectOption> objectLst {get;set;}
    public List<SelectOption> fieldLst {get;set;}
    public String selectedObject {get;set;}
    public String selectedField {get;set;}
    public String mergeField {get;set;}
    public String selectedDocType {get;set;}
    public List<Booking__c> bookingRecord {get;set;}
    public List<Quotation__c> quoteRecord {get;set;}
    public List<Property__c> propertyRecord {get;set;}
    public List<Account> accountRecord {get;set;}
    public List<Project__c> projectRecord {get;set;}
    public List<Tower__c> towerRecord {get;set;}
    public List<Opportunity> oppList{get;set;}
    public List < SelectOption > gettags{
        get{
            pickListValuesList = new List<SelectOption>();
            pickListValuesList.add(new SelectOption('', 'Select Tag'));
            pickListValuesList.add(new SelectOption('Other Special Condition', 'Other Special Condition'));
            pickListValuesList.add(new SelectOption('ITC BENEFIT', 'ITC BENEFIT'));
            pickListValuesList.add(new SelectOption('UPFRONT PAYMENT', 'UPFRONT PAYMENT'));
            pickListValuesList.add(new SelectOption('Bank Subvention Scheme', 'Bank Subvention Scheme'));
            return pickListValuesList;
        }    
        set;
    }
    public specialCondition(){
        BookingId = ApexPages.currentPage().getParameters().get('id');   
        status = false;
        htmltext = '';
        itc = '';
        //searchText = 0;
        //createHTMLText();
        
        objectLst           = new List<SelectOption>();
        docTypeLst          = new List<SelectOption>();
        fieldLst            = new List<SelectOption>();
        //projectTypeLst      = new List<SelectOption>();
        
        selectedObject      = 'Account';
        
        mergeField          = '';
        //showErrorMessage    = false;
        objectLst.add(new SelectOption('','----- Select Object -----'));
        //prepareProjectList();
        prepareObjectList();
        prepareDocTypeList();
        prepareFieldList();
    }
    public Pagereference createHTMLText(){
        system.debug('htmltext::::'+htmltext);
        lstBooking = [select id,name,Booking_Special_Conditions__c,Project__r.ITC_BENEFIT__c from Booking__c where id=: BookingId];
        //itc = lstBooking[0].Project__r.ITC_BENEFIT__c;
        //htmltext = '<ol> ';
        for(integer i=0;i<searchText;i++){
            htmltext += '\n <li><p align="justify"> \t Enter Point no. '+i+' \t </p></li> ';
            system.debug('htmltext::::'+htmltext);
        }
        //htmltext += ' \n </ol>';
        system.debug('htmltext::::'+htmltext);
        return null;
    }
    public static List<Project__c> getProjectDetails(string pId){
        List<Project__C> pList = new List<Project__C>();
        DescribeSObjectResult describeResult = Project__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + pId + '\''; 
        pList = Database.query( query );
        return pList;
    }
    public static List<Booking__c> getBookingDetails(string bId){
        List<Booking__c> bList = new List<Booking__c>();
        DescribeSObjectResult describeResult = Booking__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + bId + '\''; 
        bList = Database.query( query );
        return bList;
    }
    public static List<Property__c> getPropertyDetails(string pId){
        List<Property__c> pList = new List<Property__c>();
        DescribeSObjectResult describeResult = Property__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) + ', Project_Name__r.Promoter_s_Email_Address__c,'+
                       ' Project_Name__r.Other_Company_Phone__c,Project_Name__r.Other_Company_Fax__c,' + 
                       ' Project_Name__r.Promoter_s_PAN__c,Booking__r.Booking_Date__c' +   
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + pId + '\''; 
        pList = Database.query( query );
        return pList;
    }
    public static List<Opportunity> getOpportunityDetails(string oId){
        List<Opportunity> oList = new List<Opportunity>();
        DescribeSObjectResult describeResult = Opportunity.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + oId + '\''; 
        oList = Database.query( query );
        return oList;
    }
    public static List<Account> getAccountDetails(string aId){
        List<Account> aList = new List<Account>();
        DescribeSObjectResult describeResult = Account.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + aId + '\''; 
        aList = Database.query( query );
        return aList;
    }
    public static List<Applicant__C> getApplicantDetails(string oId){
        List<Applicant__C> aList = new List<Applicant__C>();
        DescribeSObjectResult describeResult = Applicant__C.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where Booking__C =' + '\'' + oId + '\'' +
                       ' and Applicant_Number__c = \'Primary Applicant\''; 
        aList = Database.query( query );
        return aList;
    }
    public static List<Tower__C> getTowerDetails(string tId){
        List<Tower__C> tList = new List<Tower__C>();
        DescribeSObjectResult describeResult = Tower__C.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + tId + '\''; 
        tList = Database.query( query );
        return tList;
    }
    public static List<Quotation__C> getQuotationDetails(string qId){
        List<Quotation__C> qList = new List<Quotation__C>();
        DescribeSObjectResult describeResult = Quotation__C.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + qId + '\''; 
        qList = Database.query( query );
        return qList;
    }
    public pagereference Save() {
        if(BookingId != null)
        {
                  lstBooking = [select id,name,Booking_Special_Conditions__c,Project__c from Booking__c where id=: BookingId];
                  lstProj = [select id,name,ITC_BENEFIT__c,UPFRONT_PAYMENT__c,Bank_Subvention_Scheme__c from Project__c where id=: lstBooking[0].Project__c];
                  if(lstBooking.size()>0){
                      //bookingRecord = DocumentGenerationServices.getBookingDetails(BookingId);
                      //ViewDocument vd = new ViewDocument();
                      //String replacetext = findAndReplaceMergeFields(htmltext,BookingId);
                      //system.debug('replacetext:::::::::::'+replacetext);
                      if(Gettag == 'Other Special Condition'){
                          lstBooking[0].Booking_Special_Conditions__c = htmltext;
                          update lstBooking;
                          status = true;
                      }
                      
                  }
                  if(lstProj.size()>0){
                      if(Gettag == 'ITC BENEFIT'){
                          lstProj[0].ITC_BENEFIT__c = htmltext;
                      }
                      if(Gettag == 'UPFRONT PAYMENT'){
                          lstProj[0].UPFRONT_PAYMENT__c = htmltext;
                      }
                      if(Gettag == 'Bank Subvention Scheme'){
                          lstProj[0].Bank_Subvention_Scheme__c = htmltext;
                      }
                      update lstProj;
                  }
                  Gettag = 'Select Tag';
                  searchText = null;
                  htmltext = null;
                  PageReference pdf1 = new PageReference('/apex/Special_Condition_Page?id='+BookingId);
             return pdf1;
         }
         
       return null;  
    }
    
    public void prepareDocTypeList(){
        docTypeLst.add(new SelectOption('','----- Select Document -----'));
        docTypeLst.add(new SelectOption('ITC Benifit','ITC Benifit'));
        
        
    }
    public void prepareObjectList(){
        //Added by Ashik
        objectLst.clear();
        objectLst.add(new SelectOption('A','----- Select Object -----'));
        objectLst.add(new SelectOption('Account','Account'));
        objectLst.add(new SelectOption('Opportunity','Opportunity'));
        objectLst.add(new SelectOption('Booking__c','Booking'));
        //objectLst.add(new SelectOption('Applicant__c','Applicants'));
        objectLst.add(new SelectOption('Project__c','Project'));
        //objectLst.add(new SelectOption('Tower__c','Tower'));
        objectLst.add(new SelectOption('Property__c','Property'));
        objectLst.add(new SelectOption('Quotation__c','Quotation'));
    }
     public void prepareFieldList(){
        system.debug('prepareFieldList Got called::: '+selectedObject );
        DocumentUpload du = new DocumentUpload();
        fieldLst = du.getAllFields(selectedObject);
    }
    public void preparemergefield(){
        mergeField = '{!'+selectedObject+'.'+selectedField+'}';
    }
    public pagereference Back() {
      // return new pagereference('/home/home.jsp');
        pageReference P = new pageReference('/'+ BookingId);
        return P;
    }
    
    public string findAndReplaceMergeFields(String fieldValue,Id bookid){
        /*bookingRecord = DocumentGenerationServices.getBookingDetails(bookid);
        quoteRecord = DocumentGenerationServices.getQuotationDetails(bookingRecord[0].Quotation__C);
        propertyRecord = DocumentGenerationServices.getPropertyDetails(bookingRecord[0].Property__c);
        oppList = DocumentGenerationServices.getOpportunityDetails(bookingRecord[0].Opportunity__c);
        accountRecord = DocumentGenerationServices.getAccountDetails(oppList[0].accountId);
        projectRecord = DocumentGenerationServices.getProjectDetails(bookingRecord[0].Project__c);
        //towerRecord = DocumentGenerationServices.getTowerDetails(propertyRecord[0].Tower__c);*/
        
        String replacementString            = fieldValue;
        pattern p                           = pattern.compile('\\{!(.*?)\\}');
        Matcher m                           = p.matcher(fieldValue);
        
        System.debug('m:' + m);
        
        while(m.find()) {
            System.debug('inside while loop:');
            List<String> objectAndfield     = new List<String>();
            String mergeFieldWithoutQuote   = m.group().substring( 2, m.group().length() - 1);
            System.debug('mergeFieldWithoutQuote:' + mergeFieldWithoutQuote);
            objectAndfield                  = mergeFieldWithoutQuote.split('\\.');
            String replacableString         = replaceMergeField(objectAndfield[0],objectAndfield[1],bookid);
            System.debug('replaceable string:' + replacableString);
            replacableString.removeStart('\'');
            replacableString.removeEnd('\'');
            replacementString               = replacementString.replace(m.group(),replacableString);
            
        }
        return replacementString;
        
    }
    
    public string replaceMergeField(String objName, String fieldname,Id bookid){
        bookingRecord = getBookingDetails(bookid);//DocumentGenerationServices.getBookingDetails(bookid);
        
       if(objName == 'Account' && fieldname != null){
           oppList = getOpportunityDetails(bookingRecord[0].Opportunity__c);//DocumentGenerationServices.getOpportunityDetails(bookingRecord[0].Opportunity__c);
            accountRecord = getAccountDetails(oppList[0].accountId);//DocumentGenerationServices.getAccountDetails(oppList[0].accountId);
            if(accountRecord.size()>0)
                if(accountRecord[0].get(fieldname) != null)
                return String.valueOf(accountRecord[0].get(fieldname));
            else
                return '';
            else 
                return '';
        }
        else if(objName == 'Booking__c' && fieldname != null){
            if(bookingRecord.size()>0){
                if(bookingRecord[0].get(fieldname) != null && fieldName == 'Booking_Date__c'){
                    string stDate = DocumentGenerationServices.customDateFormat((Date)bookingRecord[0].get(fieldname));
                    return stDate;
                }
                 /*if(bookingRecord[0].get(fieldname) != null && fieldName == 'Possession_Schedule_Date__c'){
                    string stDate = DocumentGenerationServices.customDateFormat((Date)bookingRecord[0].get(fieldname));
                    return stDate;
                }*/
                else if(bookingRecord[0].get(fieldname) != null){
                    return String.valueOf(bookingRecord[0].get(fieldname));
                }else{    
                    return ''; }
            }    
            else{
                return '';
            }    
        }
        else if(objName == 'Project__c' && fieldname != null){
            projectRecord = getProjectDetails(bookingRecord[0].Project__c);//DocumentGenerationServices.getProjectDetails(bookingRecord[0].Project__c);
            if(ProjectRecord.size()>0){
                if(ProjectRecord[0].get(fieldname) != null){
                    return String.valueOf(ProjectRecord[0].get(fieldname));
                }else{
                    return '';
                }
            }
            else{
                return '';}
        }
        /*else if(objName == 'Tower__c' && fieldname != null){
            if(towerRecord.size()>0)
                if(towerRecord[0].get(fieldname) != null)
                return String.valueOf(towerRecord[0].get(fieldname));
            else
                return '';
            else
                return '';
        }*/
        else if(objName == 'Property__c' && fieldname != null){
            propertyRecord = getPropertyDetails(bookingRecord[0].Property__c);//DocumentGenerationServices.getPropertyDetails(bookingRecord[0].Property__c);
            if(propertyRecord.size()>0)
                if(propertyRecord[0].get(fieldname) != null)
                return String.valueOf(propertyRecord[0].get(fieldname));
            else
                return '';
            else
                return '';
        }
        else if(objName == 'Opportunity' && fieldname != null){
            oppList = getOpportunityDetails(bookingRecord[0].Opportunity__c);//DocumentGenerationServices.getOpportunityDetails(bookingRecord[0].Opportunity__c);
            if(oppList.size()>0)
                if(oppList[0].get(fieldname) != null)
                return String.valueOf(oppList[0].get(fieldname));
            else
                return '';
            else
                return '';
        }
        /*else if(objName == 'Applicant__c' && fieldname != null){
            if(primaryApplicant.size()>0)
                if(primaryApplicant[0].get(fieldname) != null)
                return String.valueOf(primaryApplicant[0].get(fieldname));
            else
                return '';
            else
                return '';
        }*/
        else if(objName == 'Quotation__C' && fieldname != null){
            quoteRecord = getQuotationDetails(bookingRecord[0].Quotation__C);//DocumentGenerationServices.getQuotationDetails(bookingRecord[0].Quotation__C);
            if(quoteRecord.size()>0){
                if(quoteRecord[0].get(fieldname) != null && fieldName == 'Upfront_Payment_Due_Date__c'){
                    string stDate = DocumentGenerationServices.customDateFormat((Date)quoteRecord[0].get(fieldname));
                    return stDate;
                }
                else if(quoteRecord[0].get(fieldname) != null){
                    return String.valueOf(quoteRecord[0].get(fieldname));
                }
                else{    
                    return ''; }
            }
            else
                return '';
            
        }
        else{
            return '';
        }
     }
}
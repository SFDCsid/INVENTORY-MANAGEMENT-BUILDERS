public with sharing class DocumentUpload {

    public Document_Template__c         doc                    {get;set;}
    public String                       currentDocId           {get;set;}
    public String                       successmsg             {get;set;}
    public Integer                      currentIndex           {get;set;}
    public List<String>                 strings                {get;set;}
    public List<String>                 stringsList            {get;set;}
    public string                       rowToRemove            {get;set;}
    
    public List<SelectOption>           docTypeLst             {get;set;}
    public List<SelectOption>           projectTypeLst         {get;set;}
    public List<SelectOption>           objectLst              {get;set;}
    public List<SelectOption>           fieldLst               {get;set;}
    
    public String                       selectedDocType        {get;set;}
    public String                       selectedProjectType    {get;set;}
    public String                       selectedObject         {get;set;}
    public String                       selectedField          {get;set;}
    public String                       mergeField             {get;set;}
    public String                       projectName            {get;set;}
   // public String                       clusterName            {get;set;}
    public boolean                      showErrorMessage       {get;set;}
    
    public DocumentUpload(ApexPages.StandardController controller){
        strings = new List<String>{'Clause_0__c','Clause_1__c','Clause_2__c','Clause_3__c','Clause_4__c','Clause_5__c','Clause_6__c','Clause_7__c','Clause_8__c','Clause_9__c','Clause_10__c'};
        stringsList = new List<String>();
        stringsList.addAll(strings);
        stringsList.add('Project__c');
        stringsList.add('Document_Type__c');
        stringsList.add('Name');
        stringsList.add('Template_Label__c');
        stringsList.add('Document_Number_Series__c');
        stringsList.add('Disable_Page_No__c');
        if(ApexPages.currentPage().getParameters().get('id') !=null){
            controller.addFields(stringsList);
            doc = (Document_Template__c)controller.getRecord();selectedDocType = doc.Document_Type__c; selectedProjectType = doc.Project__c;
           // string selectedClusterType = doc.cluster__c;
           // system.debug('selectedClusterType :: '+selectedClusterType );
            if(string.isNotBlank(selectedProjectType)){
                List<Project__C> clusterList = [select id,name from Project__C where id=: selectedProjectType];
                if(!clusterList.isEmpty()){ projectName = clusterList[0].name;                }
            }
        }
        else{
            doc = new Document_Template__c();
            doc = (Document_Template__c)controller.getRecord();
            //string selectedClusterType = doc.cluster__c;
            selectedProjectType = doc.Project__c;
           // system.debug('selectedClusterType :: '+selectedClusterType );
            if(string.isNotBlank(selectedProjectType)){
                List<Project__C> clusterList = [select id,name from Project__C where id=: selectedProjectType];
                if(!clusterList.isEmpty()){
                    projectName = clusterList[0].name;
                }
            }
            selectedDocType     = doc.Document_Type__c;
        }
        
        currentIndex        = 0;
        
        currentDocId        = '';
        
        objectLst           = new List<SelectOption>();
        docTypeLst          = new List<SelectOption>();
        fieldLst            = new List<SelectOption>();
        projectTypeLst      = new List<SelectOption>();
        
        selectedObject      = 'Account';
        
        mergeField          = '';
        showErrorMessage    = false;
        objectLst.add(new SelectOption('','----- Select Object -----'));
        prepareProjectList();
        prepareObjectList();
        prepareDocTypeList();
        prepareFieldList();
        
    }

    public Boolean hasError { get { return ApexPages.hasMessages(); } }
    
    public void prepareProjectList(){
        List<Project__c> allProjectrec = [SELECT Id,Name From Project__c];
        for(Project__c preojectRec : allProjectrec){
            projectTypeLst.add(new SelectOption(preojectRec.Id,preojectRec.name));
        }
    }
  /*  public void seeProjectList(){

        List<Document_Template__c> existingDocrecs = [SELECT Id,Name,Document_Type__c,Project__c From Document_Template__c Where Document_Type__c=:selectedDocType And Project__c=:selectedProjectType];
        
        if(!existingDocrecs.isEmpty()){

            ApexPages.Message myMsg;
            if(selectedDocType == 'Sale Deed'){
               
                showErrorMessage = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'One Sale Deed Document for selected Project Alredy Exist. Please choose other project.<br/>'));
            }
            else if(selectedDocType == 'Possession Document'){
                
                showErrorMessage = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'One Possession Document for selected Project Alredy Exist. Please choose other project.<br/>'));
            }
            }else{
                showErrorMessage = false;
            }
        
    } */
    public void prepareObjectList(){
        //Added by Ashik
        objectLst.clear();
        objectLst.add(new SelectOption('A','----- Select Object -----'));
        objectLst.add(new SelectOption('Account','Account'));
        objectLst.add(new SelectOption('Opportunity','Opportunity'));
        objectLst.add(new SelectOption('Booking__c','Booking'));
        objectLst.add(new SelectOption('Applicant__c','Applicants'));
        objectLst.add(new SelectOption('Project__c','Project'));
        objectLst.add(new SelectOption('Tower__c','Tower'));
        objectLst.add(new SelectOption('Property__c','Property'));
        objectLst.add(new SelectOption('Quotation__c','Quotation'));
        objectLst.add(new SelectOption('OtherApplicantDetails','OtherApplicantDetails'));
        objectLst.add(new SelectOption('AllApplicantDetails','AllApplicantDetails'));
        objectLst.add(new SelectOption('Schedule-Typical(Multi Tower Project)','Schedule-Typical(Multi Tower Project)'));
        objectLst.add(new SelectOption('Schedule-Typical (Tower as Seprate Project)','Schedule-Typical (Tower as Seprate Project)'));
        objectLst.add(new SelectOption('Schedule-Duplex','Schedule-Duplex'));
        objectLst.add(new SelectOption('Schedule-Penthouse','Schedule-Penthouse'));
        objectLst.add(new SelectOption('Schedule-Bare Shell','Schedule-Bare Shell'));
        objectLst.add(new SelectOption('SeventhTable1','SeventhTable1'));
        objectLst.add(new SelectOption('Morgage NOC','Morgage NOC'));
        objectLst.add(new SelectOption('Contact Details Update','Contact Details Update'));
        objectLst.add(new SelectOption('Possesion','Possesion'));
        objectLst.add(new SelectOption('PageBreak','PageBreak'));
        objectLst.add(new SelectOption('Justify','Justify'));
        objectLst.add(new SelectOption('lineBreak','lineBreak'));
        objectLst.add(new SelectOption('ol','ol'));
        objectLst.add(new SelectOption('olDecimal','olDecimal'));
        objectLst.add(new SelectOption('p','p'));
        objectLst.add(new SelectOption('ReferenceNo','ReferenceNo'));
        objectLst.add(new SelectOption('FloorNo','FloorNo'));
        objectLst.add(new SelectOption('Table','Table'));
        objectLst.add(new SelectOption('QRCode','QRCode'));
        objectLst.add(new SelectOption('Addresses','Addresses'));
        objectLst.add(new SelectOption('TPA Signature','TPA Signature'));
        objectLst.add(new SelectOption('Annexure','Annexure'));
        objectLst.add(new SelectOption('CustomFields','CustomFields'));
        /*objectLst.add(new SelectOption('Legal_Entity__c','Legal Entity'));
        objectLst.add(new SelectOption('UnitCost','UnitCost'));
        objectLst.add(new SelectOption('PaymentReceived','PaymentReceived'));
        objectLst.add(new SelectOption('PaymentPlanDetails','PaymentPlanDetails'));
        objectLst.add(new SelectOption('RMSignatureTable','RMSignatureTable'));
        objectLst.add(new SelectOption('PrimaryApplicantDetails','PrimaryApplicantDetails'));
        objectLst.add(new SelectOption('OtherApplicantDetails','OtherApplicantDetails'));
        objectLst.add(new SelectOption('ParkingDetails','ParkingDetails'));
        objectLst.add(new SelectOption('Miscellaneous','Miscellaneous'));*/
    }
    public void prepareDocTypeList(){
        docTypeLst.add(new SelectOption('','----- Select Document -----'));
        for(Schema.PicklistEntry pe : Document_Template__c.getSobjectType().getDescribe().fields.getMap().get('Document_Type__c').getDescribe().getPickListValues()) {
            docTypeLst.add(new SelectOption(pe.getValue(),pe.getValue()));
        }
        
        
    }
    public void prepareFieldList(){
        system.debug('prepareFieldList Got called::: '+selectedObject );
        
    try{
        
        if(selectedObject != 'UnitCost' 
           && selectedObject != 'PrimaryApplicantDetails' 
           && selectedObject != 'OtherApplicantDetails' 
           && selectedObject != 'AllApplicantDetails'
           && selectedObject != 'PaymentReceived'
           && selectedObject != 'PaymentPlanDetails'
           && selectedObject != 'ParkingDetails'
           && selectedObject != 'RMSignatureTable'
           && selectedObject != 'Miscellaneous'
           && selectedObject != 'Schedule-Typical(Multi Tower Project)'
           && selectedObject != 'Schedule-Typical (Tower as Seprate Project)'
           && selectedObject != 'Schedule-Duplex'
           && selectedObject != 'Schedule-Penthouse'
           && selectedObject != 'Schedule-Bare Shell'
           && selectedObject != 'Annexure'
           && selectedObject != 'SeventhTable1'
           && selectedObject != 'Morgage NOC'
           && selectedObject != 'Contact Details Update'
           && selectedObject != 'Possesion'
           && selectedObject != 'PageBreak'
           && selectedObject != 'Justify'
           && selectedObject != 'lineBreak'
           && selectedObject != 'ol'
           && selectedObject != 'olDecimal'
           && selectedObject != 'p'
           && selectedObject != 'ReferenceNo'
           && selectedObject != 'FloorNo'
           && selectedObject != 'Table'
           && selectedObject != 'QRCode'
           && selectedObject != 'Addresses'
           && selectedObject != 'TPA Signature'
           && selectedObject != 'CustomFields' 
        ){
               fieldLst = getAllFields(selectedObject);
        }else if (selectedObject == 'OtherApplicantDetails'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('Second Applicant Salutation','Second Applicant Salutation'));
                fieldLst.add(new SelectOption('Second Applicant Name','Second Applicant Name'));
                fieldLst.add(new SelectOption('Second Applicant Address','Second Applicant Address'));
                fieldLst.add(new SelectOption('Second Applicant PAN','Second Applicant PAN'));
                fieldLst.add(new SelectOption('Second Applicant Email','Second Applicant Email'));
                fieldLst.add(new SelectOption('Second Applicant Index','Second Applicant Index'));
                
                fieldLst.add(new SelectOption('Third Applicant Salutation','Third Applicant Salutation'));
                fieldLst.add(new SelectOption('Third Applicant Name','Third Applicant Name'));
                fieldLst.add(new SelectOption('Third Applicant Address','Third Applicant Address'));
                fieldLst.add(new SelectOption('Third Applicant PAN','Third Applicant PAN'));
                fieldLst.add(new SelectOption('Third Applicant Email','Third Applicant Email'));
                fieldLst.add(new SelectOption('Third Applicant Index','Third Applicant Index'));
                
                fieldLst.add(new SelectOption('Fourth Applicant Salutation','Fourth Applicant Salutation'));
                fieldLst.add(new SelectOption('Fourth Applicant Name','Fourth Applicant Name'));
                fieldLst.add(new SelectOption('Fourth Applicant Address','Fourth Applicant Address'));
                fieldLst.add(new SelectOption('Fourth Applicant PAN','Fourth Applicant PAN'));
                fieldLst.add(new SelectOption('Fourth Applicant Email','Fourth Applicant Email'));
                fieldLst.add(new SelectOption('Fourth Applicant Index','Fourth Applicant Index'));
                
                fieldLst.add(new SelectOption('Fifth Applicant Salutation','Fifth Applicant Salutation'));
                fieldLst.add(new SelectOption('Fifth Applicant Name','Fifth Applicant Name'));
                fieldLst.add(new SelectOption('Fifth Applicant Address','Fifth Applicant Address'));
                fieldLst.add(new SelectOption('Fifth Applicant PAN','Fifth Applicant PAN'));
                fieldLst.add(new SelectOption('Fifth Applicant Email','Fifth Applicant Email'));
                fieldLst.add(new SelectOption('Fifth Applicant Index','Fifth Applicant Index'));
                 
        }else if (selectedObject == 'AllApplicantDetails'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('All Applicant Names','All Applicant Names'));
                fieldLst.add(new SelectOption('All Applicant Names with Index','All Applicant Names with Index'));
                fieldLst.add(new SelectOption('All Applicant Names with Index AFS','All Applicant Names with Index AFS'));
                fieldLst.add(new SelectOption('All Applicant Names Inline','All Applicant Names Inline'));
                fieldLst.add(new SelectOption('All Applicant Names with Index and Linebreak','All Applicant Names with Index and Linebreak'));
                fieldLst.add(new SelectOption('All Applicant Signatures','All Applicant Signatures'));
                fieldLst.add(new SelectOption('All Applicant Allotment Signature','All Applicant Allotment Signature'));
                fieldLst.add(new SelectOption('All Applicant Allotment Signature2','All Applicant Allotment Signature2'));
                fieldLst.add(new SelectOption('All Applicant Names with Allottees','All Applicant Names with Allottees'));
            	fieldLst.add(new SelectOption('All Applicant Names with Linebreak and Allottees','All Applicant Names with Linebreak and Allottees'));
                fieldLst.add(new SelectOption('All Applicant Names For Car Park','All Applicant Names For Car Park'));
            fieldLst.add(new SelectOption('All Applicant Car Park Letter Signature','All Applicant Car Park Letter Signature'));
            fieldLst.add(new SelectOption('All Applicant Names Possession Letter','All Applicant Names Possession Letter'));
            fieldLst.add(new SelectOption('All Applicant Names Possession Undertaking Letter','All Applicant Names Possession Undertaking Letter'));
            fieldLst.add(new SelectOption('All Applicant PANCards','All Applicant PANCards'));
        }else if (selectedObject == 'Schedule-Typical(Multi Tower Project)'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('First Schedule','First Schedule'));
                fieldLst.add(new SelectOption('Second Schedule','Second Schedule'));
                fieldLst.add(new SelectOption('Third Schedule','Third Schedule'));
                fieldLst.add(new SelectOption('Fourth Schedule','Fourth Schedule'));
                fieldLst.add(new SelectOption('Fifth Schedule','Fifth Schedule'));
                fieldLst.add(new SelectOption('Eleventh Schedule','Eleventh Schedule'));
        }else if (selectedObject == 'Schedule-Typical (Tower as Seprate Project)'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('First Schedule','First Schedule'));
                fieldLst.add(new SelectOption('Second Schedule','Second Schedule'));
                fieldLst.add(new SelectOption('Third Schedule','Third Schedule'));
                fieldLst.add(new SelectOption('Fourth Schedule','Fourth Schedule'));
                fieldLst.add(new SelectOption('Fifth Schedule','Fifth Schedule'));
                fieldLst.add(new SelectOption('Eleventh Schedule','Eleventh Schedule'));
        }else if (selectedObject == 'Schedule-Duplex'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('First Schedule','First Schedule'));
                fieldLst.add(new SelectOption('Second Schedule','Second Schedule'));
                fieldLst.add(new SelectOption('Third Schedule','Third Schedule'));
                fieldLst.add(new SelectOption('Fourth Schedule','Fourth Schedule'));
                fieldLst.add(new SelectOption('Fifth Schedule','Fifth Schedule'));
                fieldLst.add(new SelectOption('Eleventh Schedule','Eleventh Schedule'));
        }else if (selectedObject == 'Schedule-Penthouse'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('First Schedule','First Schedule'));
                fieldLst.add(new SelectOption('Second Schedule','Second Schedule'));
                fieldLst.add(new SelectOption('Third Schedule','Third Schedule'));
                fieldLst.add(new SelectOption('Fourth Schedule','Fourth Schedule'));
                fieldLst.add(new SelectOption('Fifth Schedule','Fifth Schedule'));
                fieldLst.add(new SelectOption('Eleventh Schedule','Eleventh Schedule'));
        }else if (selectedObject == 'Schedule-Bare Shell'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('First Schedule','First Schedule'));
                fieldLst.add(new SelectOption('Second Schedule','Second Schedule'));
                fieldLst.add(new SelectOption('Third Schedule','Third Schedule'));
                fieldLst.add(new SelectOption('Fourth Schedule','Fourth Schedule'));
                fieldLst.add(new SelectOption('Fifth Schedule','Fifth Schedule'));
                fieldLst.add(new SelectOption('Eleventh Schedule','Eleventh Schedule'));
        }else if (selectedObject == 'Annexure'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('Annexure A','Annexure A'));fieldLst.add(new SelectOption('Annexure B','Annexure B'));
        }else if (selectedObject == 'SeventhTable1'){
            fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('SeventhTable','SeventhTable'));
        }else if (selectedObject == 'Morgage NOC'){
            fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('MorgageNOC1','MorgageNOC1'));
        }else if (selectedObject == 'Contact Details Update'){
            fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('Single Tower','Single Tower'));
                fieldLst.add(new SelectOption('Multi Tower','Multi Tower'));
        }else if (selectedObject == 'Possesion'){
            fieldLst.clear();
                fieldLst.add(new SelectOption('','----- Select Field -----'));
                fieldLst.add(new SelectOption('KeyHandoverChecklist','KeyHandoverChecklist'));
        }else if(selectedObject == 'PageBreak'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));
                    fieldLst.add(new SelectOption('sPageBreak','sPageBreak'));
        }else if (selectedObject == 'Justify'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));
                    fieldLst.add(new SelectOption('sJustify','sJustify'));
                    fieldLst.add(new SelectOption('eJustify','eJustify'));
        }else if(selectedObject == 'lineBreak'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));
                    fieldLst.add(new SelectOption('lineBreak','lineBreak'));
        }else if(selectedObject == 'ol'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));
                    fieldLst.add(new SelectOption('sOL','sOL'));
                    fieldLst.add(new SelectOption('eOL','eOL'));
                    fieldLst.add(new SelectOption('sLIa','sLIa'));
                    fieldLst.add(new SelectOption('eLIa','eLIa'));
                    fieldLst.add(new SelectOption('sLIUA','sLIUA'));
                    fieldLst.add(new SelectOption('eLIUA','eLIUA'));
                    fieldLst.add(new SelectOption('sLIr','sLIr'));
                    fieldLst.add(new SelectOption('eLIr','eLIr'));
                    fieldLst.add(new SelectOption('sLId','sLId'));
                    fieldLst.add(new SelectOption('eLId','eLId'));
         }else if(selectedObject == 'olDecimal'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));
                    fieldLst.add(new SelectOption('sOLDecimal','sOLDecimal'));
                    fieldLst.add(new SelectOption('eOLDecimal','eOLDecimal'));
                    fieldLst.add(new SelectOption('sDecimalList','sDecimalList'));
                    fieldLst.add(new SelectOption('eDecimalList','eDecimalList'));
         }else if(selectedObject == 'p'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));
                    fieldLst.add(new SelectOption('pStart','pStart'));
                    fieldLst.add(new SelectOption('pEnd','pEnd'));
         }else if(selectedObject == 'ReferenceNo'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));
                    fieldLst.add(new SelectOption('refno','refno'));
         }else if(selectedObject == 'FloorNo'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));
                    fieldLst.add(new SelectOption('FloorNo','FloorNo'));
         }else if(selectedObject == 'Table'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));
                    fieldLst.add(new SelectOption('TableStart','TableStart'));
                    fieldLst.add(new SelectOption('TableEnd','TableEnd'));
                    fieldLst.add(new SelectOption('TRowStart','TRowStart'));
                    fieldLst.add(new SelectOption('TRowEnd','TRowEnd'));
                    fieldLst.add(new SelectOption('TCellStart','TCellStart'));
                    fieldLst.add(new SelectOption('TCellStart2','TCellStart2'));
                    fieldLst.add(new SelectOption('TCellEnd','TCellEnd'));
                    fieldLst.add(new SelectOption('THeaderStart','THeaderStart'));
                    fieldLst.add(new SelectOption('THeaderEnd','THeaderEnd'));
         }else if(selectedObject == 'QRCode'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));fieldLst.add(new SelectOption('QRCodeField','QRCodeField'));
         }
        else if(selectedObject == 'Addresses'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));
                    fieldLst.add(new SelectOption('Bank NOC Address','Bank NOC Address'));
                    fieldLst.add(new SelectOption('Provisional Bank NOC Address','Provisional Bank NOC Address'));
                    fieldLst.add(new SelectOption('Primary Applicant Mailing Address','Primary Applicant Mailing Address'));
                    fieldLst.add(new SelectOption('Primary Applicant Billing Address','Primary Applicant Billing Address'));
        }else if(selectedObject == 'TPA Signature'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));fieldLst.add(new SelectOption('TPASign','TPASign'));       
        }
        else if(selectedObject == 'CustomFields'){
                    fieldLst.clear();
                    fieldLst.add(new SelectOption('','----- Select Field -----'));
                    fieldLst.add(new SelectOption('Sales Price Due Till Date','Sales Price Due Till Date'));   
                    fieldLst.add(new SelectOption('Sale Price Due Till Date Percentage','Sale Price Due Till Date Percentage'));   
                    fieldLst.add(new SelectOption('Sale Price Received Till Date','Sale Price Received Till Date'));   
                    fieldLst.add(new SelectOption('Sale Price Received Till Date Percentage','Sale Price Received Till Date Percentage'));   
        }
        /*else if(selectedObject == 'UnitCost'){

            fieldLst.clear();
            //Holds the total apartment cost (without gst)
            fieldLst.add(new SelectOption('Balance Sale Consideration in words','Balance Sale Consideration in words'));
            fieldLst.add(new SelectOption('Total Sale Consideration Value in words','Total Sale Consideration Value in words'));
            fieldLst.add(new SelectOption('Balance Sale Consideration in Rs','Balance Sale Consideration in Rs'));
            fieldLst.add(new SelectOption('Total Sale Consideration Value in Rs','Total Sale Consideration Value in Rs'));
            
            
            //Holds the total apartment cost (with gst)
            fieldLst.add(new SelectOption('Total Sale Consideration Value in words (With GST)','Total Sale Consideration Value in words (With GST)'));
            fieldLst.add(new SelectOption('Balance Sale Consideration in words (With GST)','Balance Sale Consideration in words (With GST)'));
            fieldLst.add(new SelectOption('Total Sale Consideration Value in Rs (With GST)','Total Sale Consideration Value in Rs (With GST)'));
            fieldLst.add(new SelectOption('Balance Sale Consideration in Rs (With GST)','Balance Sale Consideration in Rs (With GST)'));
            
            //Holds the total agreement value cost 
            fieldLst.add(new SelectOption('Total Agreement Value in words','Total Agreement Value in words'));
            fieldLst.add(new SelectOption('Total Agreement Value in Rs','Total Agreement Value in Rs'));
            fieldLst.add(new SelectOption('Total Agreement Value Recd in words','Total Agreement Value Recd in words'));
            fieldLst.add(new SelectOption('Total Agreement Value Recd in Rs','Total Agreement Value Recd in Rs'));
            
            // Legal Charges
            fieldLst.add(new SelectOption('Legal Charges in Rs','Legal Charges in Rs'));
            fieldLst.add(new SelectOption('Legal Charges in words','Legal Charges in words'));
            
        }else if (selectedObject == 'PrimaryApplicantDetails'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('Primary Applicant Name','Primary Applicant Name'));
                fieldLst.add(new SelectOption('Primary Applicant Address','Primary Applicant Address'));
                fieldLst.add(new SelectOption('Primary Applicant PAN','Primary Applicant PAN'));
                fieldLst.add(new SelectOption('Primary Applicant Email','Primary Applicant Email'));
        }else if (selectedObject == 'OtherApplicantDetails'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('Other Applicant Names','Other Applicant Name'));
                fieldLst.add(new SelectOption('Other Applicant Address','Other Applicant Address'));
                fieldLst.add(new SelectOption('Other Applicant PAN','Other Applicant PAN'));
                fieldLst.add(new SelectOption('Other Applicant Email','Other Applicant Email'));
        }
        else if (selectedObject == 'ParkingDetails'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('Parking Allotted','Parking Allotted'));
                fieldLst.add(new SelectOption('Parking Charges in Rs','Parking Charges in Rs'));
        }
        else if (selectedObject == 'PaymentReceived'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('Receipt Details Table','Receipt Details Table'));
        }
        else if (selectedObject == 'PaymentPlanDetails'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('Flat Cost Milestones in words','Flat Cost Milestones in words'));
                fieldLst.add(new SelectOption('Possession Milestones in words','Possession Milestones in words'));
        }else if (selectedObject == 'Miscellaneous'){
                fieldLst.clear();
                fieldLst.add(new SelectOption('Day of Booking','Day of Booking'));
                fieldLst.add(new SelectOption('Month of Booking','Month of Booking'));
                fieldLst.add(new SelectOption('Year of Booking','Year of Booking'));
        }
        else{
            mergeField = '{!'+selectedObject+'.'+'Table'+'}';
            fieldLst = null;
        }*/

        }catch(Exception e){
            system.debug(e.getMessage()+':::'+e.getLineNumber());
        }
        
    }
    
    public void preparemergefield(){
        mergeField = '{!'+selectedObject+'.'+selectedField+'}';
    }
    
    public DocumentUpload() {

        doc = new Document_Template__c(Clause_0__c='',Clause_1__c='');
        
        successmsg = '';
    }
    
    public PageReference save(){
        try{

            doc.Document_Type__c=selectedDocType;
            if(selectedProjectType != null)
            doc.Project__c =  selectedProjectType;
            upsert doc;
            currentDocId=doc.Id;
            successmsg  = 'Document uploaded';
        }
        catch(Exception e){
            successmsg  = e.getMessage();
            return null;
        }
        PageReference pr = new PageReference('/' + String.valueOf(doc.Id).substring(0,3));
        pr.setRedirect(true);
        return pr;
        
        
    }
    public void saveAndPriview(){
        try{

            doc.Document_Type__c=selectedDocType;
            
            upsert doc;
            currentDocId=doc.Id;
            successmsg  = 'Document uploaded';
        }
        catch(Exception e){
            successmsg  = e.getMessage();
        }
        
        
    }
    
    public void  removeRow(){
        try{
            String rowApiName = Apexpages.currentPage().getParameters().get('rowtodelete');
            
            doc.put(rowApiName,'');
            update doc;
        }
        catch(Exception e){
          //  ErrorLogUtility.addErrorLog(e);
        }

    }
    
    public void addRow(){

        successmsg='aj';
        currentIndex++;
        
        String tempFieldName='Clause_'+String.valueOf(currentIndex)+'__c';
        strings.add(tempFieldName);
    }

    public List<SelectOption> getAllFields(String obj){

        System.debug('@@'+obj);
        List<SelectOption> fieldSelectOptions = new List<SelectOption>();
        Map<String,String> options = new Map<String,String>();
        
        
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(obj).getDescribe().fields.getMap();
        
        fieldSelectOptions.add(new SelectOption('','----- Select Field -----')); 
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
            schema.describefieldresult dfield = sfield.getDescribe();
            
            if(dfield.isUpdateable() || dfield.isCustom()){
                fieldSelectOptions.add(new SelectOption(dfield.getname(),dfield.getLabel()));
                options.put(dfield.getLabel(),dfield.getname());
            }
            
        }
        
        
        return fieldSelectOptions;
    }

    
}
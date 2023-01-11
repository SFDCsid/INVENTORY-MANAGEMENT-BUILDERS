Public Class DocumentCheckListController{

    public string bookingId {get;set;}
    Public List<Booking__c> bList {get;set;}
    Public Map<string,List<Integer>> docMap {get;set;}
    Public Document_Checklist_Header__c docHeader {get;set;}
    Public Document_Checklist_Header__c docHeader2 {get;set;}
    Public List<Document_Checklist_Header__c> docHeaderListl1 {get;set;}
    Public List<Document_Checklist_Header__c> docHeaderListl2 {get;set;}
    Public Applicant_Document_Checklist__c applicantDocumentl1 {get;set;}
    Public List<String> headerList {get;set;}
    Public Map<string,string> descriptionMap {get;set;}
    Public Map<string,string> applicantDocMap {get;set;}
    Public Applicant__c applicant1 {get;set;}
    Public Applicant__c applicant2 {get;set;}
    Public Applicant__c applicant3 {get;set;}
    Public Applicant__c applicant4 {get;set;}
    Public Applicant__c applicant5 {get;set;}
    Public Applicant_Document_Checklist__c applicantDocument1 {get;set;}
    Public Applicant_Document_Checklist__c applicantDocument2 {get;set;}
    Public Applicant_Document_Checklist__c applicantDocument3 {get;set;}
    Public Applicant_Document_Checklist__c applicantDocument4 {get;set;}
    Public Applicant_Document_Checklist__c applicantDocument5 {get;set;}
    Public Applicant_Document_Checklist__c applicantDocument1L1 {get;set;}
    Public Applicant_Document_Checklist__c applicantDocument2L1 {get;set;}
    Public Applicant_Document_Checklist__c applicantDocument3L1 {get;set;}
    Public Applicant_Document_Checklist__c applicantDocument4L1 {get;set;}
    Public Applicant_Document_Checklist__c applicantDocument5L1 {get;set;}
    Public List<Applicant_Document_Checklist__c> App1HeaderListl1 {get;set;}
    Public List<Applicant_Document_Checklist__c> APP2HeaderListl1 {get;set;}
    Public List<Applicant_Document_Checklist__c> App3HeaderListl1 {get;set;}
    Public List<Applicant_Document_Checklist__c> App4HeaderListl1 {get;set;}
    Public List<Applicant_Document_Checklist__c> App5HeaderListl1 {get;set;}
    Public List<Applicant_Document_Checklist__c> App1HeaderListl2 {get;set;}
    Public List<Applicant_Document_Checklist__c> APP2HeaderListl2 {get;set;}
    Public List<Applicant_Document_Checklist__c> App3HeaderListl2 {get;set;}
    Public List<Applicant_Document_Checklist__c> App4HeaderListl2 {get;set;}
    Public List<Applicant_Document_Checklist__c> App5HeaderListl2 {get;set;}
    Public List<Integer> seqList {get;set;}
    public List<Applicant__C> applicantList {get;set;}
    Public Map<Integer, string> documentDetailsMap {get;set;} 
    Public Map<string, string> applicantDetailsMap{get;set;}
    Public String level {get;set;}
    Public Map<Integer, WrapperClass> WP {get;set;}
    Public Map<Integer, WrapperClass> WPAPP {get;set;}
    Public boolean isAccepted {get;set;}
    Public boolean isRejected {get;set;}
    Public boolean isMailSend{get;set;}
    
    public String error {get;set;}
    
    Public DocumentCheckListController(){
        bList = new List<Booking__c>(); 
        docMap = new Map<string,List<Integer>>();
        //docHeader = new Document_Checklist_Header__c();
        docHeaderListl1 =new List<Document_Checklist_Header__c>();
        docHeaderListl2 =new List<Document_Checklist_Header__c>();
        headerList = new List<string>();
        descriptionMap = new Map<string,string>();
        applicantDocMap = new Map<string,string>();
        applicant1 = new Applicant__c();
        applicant2 = new Applicant__c();
        applicant3 = new Applicant__c();
        applicant4 = new Applicant__c();
        applicant5 = new Applicant__c(); 
        //applicantDocument1 = new Applicant_Document_Checklist__c();
        //applicantDocument2 = new Applicant_Document_Checklist__c();
        //applicantDocument3 = new Applicant_Document_Checklist__c();
        //applicantDocument4 = new Applicant_Document_Checklist__c();
        //applicantDocument5 = new Applicant_Document_Checklist__c();
        App1HeaderListl1 =new List<Applicant_Document_Checklist__c>();
        App2HeaderListl1 =new List<Applicant_Document_Checklist__c>();
        App3HeaderListl1 =new List<Applicant_Document_Checklist__c>();
        App4HeaderListl1 =new List<Applicant_Document_Checklist__c>();
        App5HeaderListl1 =new List<Applicant_Document_Checklist__c>();
        App1HeaderListl2 =new List<Applicant_Document_Checklist__c>();
        App2HeaderListl2 =new List<Applicant_Document_Checklist__c>();
        App3HeaderListl2 =new List<Applicant_Document_Checklist__c>();
        App4HeaderListl2 =new List<Applicant_Document_Checklist__c>();
        App5HeaderListl2 =new List<Applicant_Document_Checklist__c>();
        seqList = new Integer[]{1,2,3,4,5,6,7,8,9,10,11,12,13};
        applicantList = new List<Applicant__C>();
        isAccepted = false;
        isRejected = false;
        isMailSend = false;
        
        if(ApexPages.currentPage().getParameters().containsKey('Id') != null)
            bookingId =  ApexPages.currentPage().getParameters().get('Id');
        
        DescribeSObjectResult describeResult = Booking__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) + ',Opportunity__r.OwnerId,Opportunity__r.Owner.Email,Property__r.Material_No__c,Opportunity__r.owner.Name,Property__r.Status__C,Property__r.House_Unit_No__c,' +
                     'Property__r.Floor_No__c,Property__r.Property_Type_Name__c,Project__r.Name,Quotation__r.Total_Agreement_Value_Modified__c,Opportunity__r.Broker_Account__r.Name,Property__r.Sales_Head__r.Email,Site_Support__r.Email,Opportunity__r.Partner_s_Firm_Name__c' +
                     ' FROM ' + describeResult.getName() + ' where id=' + '\'' + bookingId + '\''; 
        bList = Database.query( query );   
       
        if(string.isNotBlank(bList[0].Doc_Verification_Status__c) && bList[0].Doc_Verification_Status__c == 'Level 1 Accepted'){
            level = 'Level2';
        }else{
            level = 'Level1';
        } 
        
        id docRecordTypeIdL1 = Schema.SObjectType.Document_Checklist_Header__c.getRecordTypeInfosByName().get('Level1').getRecordTypeId();
        id docRecordTypeIdL2 = Schema.SObjectType.Document_Checklist_Header__c.getRecordTypeInfosByName().get('Level2').getRecordTypeId();    
    
        DescribeSObjectResult Result1 = Document_Checklist_Header__c.getSObjectType().getDescribe();
        List<String> docfieldNames = new List<String>( Result1.fields.getMap().keySet() );
        String Docquery1 = ' SELECT ' + String.join( DocfieldNames, ',' ) + 
                          ' FROM ' + Result1.getName() + ' where booking__c=' + '\'' + bookingId + '\'AND RecordTypeId='+ '\'' + docRecordTypeIdL1 + '\''+' order by createdDate DESC';
        docHeaderListl1 = Database.query( Docquery1 );
        String Docquery2 = ' SELECT ' + String.join( DocfieldNames, ',' ) + 
                          ' FROM ' + Result1.getName() + ' where booking__c=' + '\'' + bookingId + '\'AND RecordTypeId='+ '\'' + docRecordTypeIdL2 + '\''+ ' order by createdDate DESC';
        docHeaderListl2 = Database.query( Docquery2 );
        
        System.debug('docHeaderListl1:::::'+docHeaderListl1.size());
        System.debug('docHeaderListl2:::::'+docHeaderListl2.size());  
                     
        id AppRecordTypeIdL1 = Schema.SObjectType.Applicant_Document_Checklist__c.getRecordTypeInfosByName().get('Level1').getRecordTypeId();
        id AppRecordTypeIdL2 = Schema.SObjectType.Applicant_Document_Checklist__c.getRecordTypeInfosByName().get('Level2').getRecordTypeId();
        DescribeSObjectResult Result2 = Applicant_Document_Checklist__c.getSObjectType().getDescribe();
        List<String> AppfieldNames = new List<String>( Result2.fields.getMap().keySet());
        
        String APPName1 = 'Applicant 1';
        String APPName2 = 'Applicant 2';
        String APPName3 = 'Applicant 3';
        String APPName4 = 'Applicant 4';
        String APPName5 = 'Applicant 5';
        
                
        if(level == 'Level1'){
            if(docHeaderListl1.size()>0){
                docHeader = docHeaderListl1[0];
                
                String App1query2 = ' SELECT ' + String.join( AppfieldNames, ',' ) + 
                          ' FROM ' + Result2.getName() + ' where Document_Checklist_Header__c=' + '\'' + docHeaderListl1[0].id + '\'AND Name =' + '\'' + APPName1 + '\'AND RecordTypeId='+ '\'' + AppRecordTypeIdL1 + '\''+' order by createdDate DESC';
                App1HeaderListl1 = Database.query(App1query2);
                String App2query2 = ' SELECT ' + String.join( AppfieldNames, ',' ) + 
                          ' FROM ' + Result2.getName() + ' where Document_Checklist_Header__c=' + '\'' + docHeaderListl1[0].id + '\'AND Name =' + '\'' + APPName2 + '\'AND RecordTypeId='+ '\'' + AppRecordTypeIdL1 + '\''+' order by createdDate DESC';
                App2HeaderListl1 = Database.query(App2query2);
                String App3query2 = ' SELECT ' + String.join( AppfieldNames, ',' ) + 
                          ' FROM ' + Result2.getName() + ' where Document_Checklist_Header__c=' + '\'' + docHeaderListl1[0].id + '\'AND Name =' + '\'' + APPName3 + '\'AND RecordTypeId='+ '\'' + AppRecordTypeIdL1 + '\''+' order by createdDate DESC';
                App3HeaderListl1 = Database.query(App3query2);
                String App4query2 = ' SELECT ' + String.join( AppfieldNames, ',' ) + 
                          ' FROM ' + Result2.getName() + ' where Document_Checklist_Header__c=' + '\'' + docHeaderListl1[0].id + '\'AND Name =' + '\'' + APPName4 + '\'AND RecordTypeId='+ '\'' + AppRecordTypeIdL1 + '\''+' order by createdDate DESC';
                App4HeaderListl1 = Database.query(App4query2);
                String App5query2 = ' SELECT ' + String.join( AppfieldNames, ',' ) + 
                          ' FROM ' + Result2.getName() + ' where Document_Checklist_Header__c=' + '\'' + docHeaderListl1[0].id + '\'AND Name =' + '\'' + APPName5 + '\'AND RecordTypeId='+ '\'' + AppRecordTypeIdL1 + '\''+' order by createdDate DESC';
                App5HeaderListl1 = Database.query(App5query2);
                
                System.debug('App1HeaderListl1:::::'+App1HeaderListl1.size());
                System.debug('App2HeaderListl1:::::'+App2HeaderListl1.size()); 
                System.debug('App3HeaderListl1:::::'+App3HeaderListl1.size());
                System.debug('App4HeaderListl1:::::'+App4HeaderListl1.size()); 
                System.debug('App5HeaderListl1:::::'+App5HeaderListl1.size());
            }Else{
                docHeader = new Document_Checklist_Header__c();
            }
        }else if(level == 'Level2'){
            if(docHeaderListl2.size()>0){
                docHeader = docHeaderListl2[0];
                
                String App1query = ' SELECT ' + String.join( AppfieldNames, ',' ) + 
                          ' FROM ' + Result2.getName() + ' where Document_Checklist_Header__c=' + '\'' + docHeaderListl2[0].id + '\'AND Name =' + '\'' + APPName1 + '\'AND RecordTypeId='+ '\'' + AppRecordTypeIdL2 + '\''+' order by createdDate DESC';
                App1HeaderListl2 = Database.query(App1query);
                String App2query = ' SELECT ' + String.join( AppfieldNames, ',' ) +
                          ' FROM ' + Result2.getName() + ' where Document_Checklist_Header__c=' + '\'' + docHeaderListl2[0].id + '\'AND Name =' + '\'' + APPName2 + '\'AND RecordTypeId='+ '\'' + AppRecordTypeIdL2 + '\''+' order by createdDate DESC';
                App2HeaderListl2 = Database.query(App2query);
                String App3query = ' SELECT ' + String.join( AppfieldNames, ',' ) + 
                          ' FROM ' + Result2.getName() + ' where Document_Checklist_Header__c=' + '\'' + docHeaderListl2[0].id + '\'AND Name =' + '\'' + APPName3 + '\'AND RecordTypeId='+ '\'' + AppRecordTypeIdL2 + '\''+' order by createdDate DESC';
                App3HeaderListl2 = Database.query(App3query);
                String App4query = ' SELECT ' + String.join( AppfieldNames, ',' ) + 
                          ' FROM ' + Result2.getName() + ' where Document_Checklist_Header__c=' + '\'' + docHeaderListl2[0].id + '\'AND Name =' + '\'' + APPName4 + '\'AND RecordTypeId='+ '\'' + AppRecordTypeIdL2 + '\''+' order by createdDate DESC';
                App4HeaderListl2 = Database.query(App4query);
                String App5query = ' SELECT ' + String.join( AppfieldNames, ',' ) + 
                          ' FROM ' + Result2.getName() + ' where Document_Checklist_Header__c=' + '\'' + docHeaderListl2[0].id + '\'AND Name =' + '\'' + APPName5 + '\'AND RecordTypeId='+ '\'' + AppRecordTypeIdL2 + '\''+' order by createdDate DESC';
                App5HeaderListl2 = Database.query(App5query);
                
                System.debug('App1HeaderListl2:::::'+App1HeaderListl2.size());
                System.debug('App2HeaderListl2:::::'+App2HeaderListl2.size()); 
                System.debug('App3HeaderListl2:::::'+App3HeaderListl2.size());
                System.debug('App4HeaderListl2:::::'+App4HeaderListl2.size()); 
                System.debug('App5HeaderListl2:::::'+App5HeaderListl2.size());
            }Else{
                docHeader = new Document_Checklist_Header__c();
            }
        }Else{
            docHeader = new Document_Checklist_Header__c();
        }
        if(level == 'Level1'){
            If(App1HeaderListl1.size()>0){
                applicantDocument1 = App1HeaderListl1[0];
            }Else{
                applicantDocument1 = new Applicant_Document_Checklist__c();
            }
               
            If(App2HeaderListl1.size()>0){
                applicantDocument2 = App2HeaderListl1[0];
            }Else{
                applicantDocument2 = new Applicant_Document_Checklist__c();
            }
               
            If(App3HeaderListl1.size()>0){
                applicantDocument3 = App3HeaderListl1[0];
            }Else{
                applicantDocument3 = new Applicant_Document_Checklist__c();
            }
               
            If(App4HeaderListl1.size()>0){
                applicantDocument4 = App4HeaderListl1[0];
            }Else{
                applicantDocument4 = new Applicant_Document_Checklist__c();
            }
               
            If(App5HeaderListl1.size()>0){
                applicantDocument5 = App5HeaderListl1[0];
            }Else{
                applicantDocument5 = new Applicant_Document_Checklist__c();
            }
        }else{
            If(App1HeaderListl2.size()>0){
                applicantDocument1 = App1HeaderListl2[0];
                applicantDocument1L1 = new Applicant_Document_Checklist__c();
            }Else{
                applicantDocument1 = new Applicant_Document_Checklist__c();
                applicantDocument1L1 = new Applicant_Document_Checklist__c();
            }
               
            If(App2HeaderListl2.size()>0){
                applicantDocument2 = App2HeaderListl2[0];
                applicantDocument2L1 = new Applicant_Document_Checklist__c();
            }Else{
                applicantDocument2 = new Applicant_Document_Checklist__c();
                applicantDocument2L1 = new Applicant_Document_Checklist__c();
            }
               
            If(App3HeaderListl2.size()>0){
                applicantDocument3 = App3HeaderListl2[0];
                applicantDocument3L1 = new Applicant_Document_Checklist__c();
            }Else{
                applicantDocument3 = new Applicant_Document_Checklist__c();
                applicantDocument3L1 = new Applicant_Document_Checklist__c();
            }
               
            If(App4HeaderListl2.size()>0){
                applicantDocument4 = App4HeaderListl2[0];
                applicantDocument4L1 = new Applicant_Document_Checklist__c();
            }Else{
                applicantDocument4 = new Applicant_Document_Checklist__c();
                applicantDocument4L1 = new Applicant_Document_Checklist__c();
            }
               
            If(App5HeaderListl2.size()>0){
                applicantDocument5 = App5HeaderListl2[0];
                applicantDocument5L1 = new Applicant_Document_Checklist__c();
            }Else{
                applicantDocument5 = new Applicant_Document_Checklist__c();
                applicantDocument5L1 = new Applicant_Document_Checklist__c();
            }            
        } 
        
        if(!bList.isEmpty()){
            if(bList[0].Status__c == 'UnProcessed'){
                 error = 'Yes';
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Booking is not proceed yet.'));
            }else if(bList[0].Status__c == 'Cancelled'){
                error = 'Yes';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Booking is Cancelled.'));
            }else if(bList[0].Doc_Verification_Status__c == 'Level 2 Accepted'){
                error = 'Yes';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Booking is already Proceed.'));
            }else if(bList[0].Property__r.Status__C != 'BIP - Sales' && bList[0].Property__r.Status__C != 'CRM Returned To Sales'){
                error = 'Yes';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please ensure that the unit status is "BIP - Sales" or "CRM Returned To Sales"'));
            }else{
                //system.debug('value ::: '+docHeader.Line_Item_Name1__c);
                headerList.add('Client Signatures');headerList.add('Overwriting');headerList.add('Document Verification');headerList.add('Factual Details');
                docMap.put('Client Signatures',new Integer[]{1,2});
                docMap.put('Overwriting',new Integer[]{3,4,5});
                docMap.put('Document Verification',new Integer[]{6,7,8,9,10,11,12,13});
                docMap.put('Factual Details',new Integer[]{14,15,16,17,18,19,20,21,22});
                
                String type='Document_Checklist_Header__c';
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema = schemaMap.get(type);
                Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                for(string st : fieldMap.keyset()){
                    string value = (String)fieldMap.get(st).getDescribe().getDefaultValueFormula();
                    if(string.isNotBlank(value))
                        value = value.removeEnd('\'').removeStart('\'');
                    system.debug(st+':::' +value);
                    descriptionMap.put(st,value); 
                }
                
                DescribeSObjectResult describeResult2 = Applicant__C.getSObjectType().getDescribe();  
                List<String> fieldNames2 = new List<String>( describeResult2.fields.getMap().keySet() );
                String query2 = ' SELECT ' + String.join( fieldNames2, ',' ) +
                             ' FROM ' + describeResult2.getName() + ' where Booking__c =' + '\'' + bookingId + '\'' +
                             ' order by createdDate ASC'; 
                applicantList = Database.query( query2 ); 
                if(applicantList != null && !applicantList.isEmpty()){
                    if(applicantList.size() > 0) applicant1 = applicantList[0];
                    if(applicantList.size() > 1) applicant2 = applicantList[1];
                    if(applicantList.size() > 2) applicant3 = applicantList[2];
                    if(applicantList.size() > 3) applicant4 = applicantList[3];
                    if(applicantList.size() > 4) applicant5 = applicantList[4];
                    getApplicantDetailsMap();
                }
                
                String type2='Applicant_Document_Checklist__c';
                Map<String, Schema.SObjectType> schemaMap2 = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema2 = schemaMap2.get(type2);
                Map<String, Schema.SObjectField> fieldMap2 = leadSchema2.getDescribe().fields.getMap();
                for(string st : fieldMap2.keyset()){
                    string value = (String)fieldMap2.get(st).getDescribe().getDefaultValueFormula();
                    if(string.isNotBlank(value))
                        value = value.removeEnd('\'').removeStart('\'');
                    applicantDocMap.put(st,value); 
                }
                getDocumentDetailsMap();
                
                getWPMap();
                getWPAPPMap();
            }
        
        }else{
            error = 'Yes';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'Some internal error encountered while processing your request. Please Contact your Administrator.'));
        }
    } 
    
    public void accept(){
        system.debug('Inside accept Method:: '+Level);
        Integer valid = 0;
        isAccepted = false;
        for(Integer i : WP.keySet()){
            boolean isChecked = false;
            if(level == 'Level1')
                isChecked = (boolean)docHeader.get('Level_1_Verified'+ i +'__c');
            else
                isChecked = (boolean)docHeader.get('Level_2_Verified'+ i +'__c');    
            string remarks = (string)docHeader.get('Remarks'+ i +'__c');
            system.debug('i is:::'+i + ' ::: wp.get(i):: '+wp.get(i) + ' :: ischecked::'+isChecked);
            if(WP.get(i).required == 'Mandatory' && !isChecked){
                if(level == 'Level1'){
                    if(string.isBlank(remarks)){
                        WrapperClass w = WP.get(i);
                        w.isError = true;
                        valid = 1;
                        Wp.put(i,w);
                    }
                }else{
                    valid = 1;
                }    
            }else if(WP.get(i).required == 'Mandatory' && isChecked){
                if(level == 'Level1'){
                    WrapperClass w = WP.get(i);
                    w.isError = false;
                    Wp.put(i,w);
                }
            }
        }
        for(Integer i=0;i<applicantList.size();i++){
            Applicant_Document_Checklist__c applicantDocument = new Applicant_Document_Checklist__c();
            if(i==0)
                applicantDocument = applicantDocument1; 
            else if(i==1)   
                applicantDocument = applicantDocument2;
            else if(i==2)   
                applicantDocument = applicantDocument3;
            else if(i==3)   
                applicantDocument = applicantDocument4;
            else if(i==4)   
                applicantDocument = applicantDocument5;      
                    
            for(Integer j : WPAPP.keySet()){
                boolean isChecked;
                if(level == 'Level1')
                    isChecked = (boolean)applicantDocument.get('Level_1_Verified'+ j +'__c');
                else
                    isChecked = (boolean)applicantDocument.get('Level_2_Verified'+ j +'__c');    
                string remarks = (string)applicantDocument.get('Remarks'+ j +'__c');
                if(WPAPP.get(j).required == 'Mandatory' && !isChecked){
                    if(level == 'Level1'){
                        if(string.isBlank(remarks)){
                            WrapperClass w = WPAPP.get(j);
                            w.isError = true;
                            WPAPP.put(j,w);
                            valid = 1;
                        }
                    }else{
                        valid = 1;
                    }
                }else if(WPAPP.get(j).required == 'Mandatory' && isChecked){ 
                    if(level == 'Level1'){
                        WrapperClass w = WPAPP.get(j);
                        w.isError = false;
                        WPAPP.put(j,w);
                    }
                }
            }
        }
        if(valid == 1){
            if(level == 'Level1')
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Mandatory document not verify then Rejection Remarks is Mandatory'));
            else
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please verify all documents to accept'));    
        }else{
            //docHeader.Booking__C = bList[0].id;
            Id devRecordTypeId;
            Id applicantRecordTypeId;
            if(level == 'Level1'){
                devRecordTypeId = Schema.SObjectType.Document_Checklist_Header__c.getRecordTypeInfosByName().get('Level1').getRecordTypeId();
                applicantRecordTypeId= Schema.SObjectType.Applicant_Document_Checklist__c.getRecordTypeInfosByName().get('Level1').getRecordTypeId();
                bList[0].Doc_Verification_Status__c = 'Level 1 Accepted';
                update bList;
                 
            }    
            else if(level == 'Level2'){
                devRecordTypeId = Schema.SObjectType.Document_Checklist_Header__c.getRecordTypeInfosByName().get('Level2').getRecordTypeId();
                applicantRecordTypeId= Schema.SObjectType.Applicant_Document_Checklist__c.getRecordTypeInfosByName().get('Level2').getRecordTypeId();  
                Property__C pr = new Property__C();
                pr.id = bList[0].Property__C;
                pr.Status__c = 'Sold';
                update pr;
                
                bList[0].Doc_Verification_Status__c = 'Level 2 Accepted';
                bList[0].Status__c = 'Booked';
                update bList;
                
                Opportunity op = new opportunity();
                op.id = bList[0].Opportunity__c;
                op.stageName = 'Booked';
                update op;
            }      
            docHeader.RecordTypeId = devRecordTypeId;     
            docHeader.Status__c = 'Accepted';
            
            for(Integer k : documentDetailsMap.keyset()){
                docHeader.put('Value' + k + '__c',documentDetailsMap.get(k));
            }
            
            if(docHeaderListl2.size()>0){
                Update docHeader;
            }Else{
                docHeader.Booking__C = bList[0].id;
                insert docHeader;
            }
               
            if(applicantList.size() > 0){
                for(Integer k : seqList){
                    applicantDocument1.put('Value' + k + '__c', applicantDetailsMap.get('Primary Applicant' + k));
                }
                applicantDocument1.name = 'Applicant 1';
                applicantDocument1.Document_Checklist_Header__c = docHeader.id;
                applicantDocument1.RecordTypeId = applicantRecordTypeId;
                
                if(level == 'level1'){
                    if(App1HeaderListl1.size()>0){
                        Update applicantDocument1;
                    }Else{
                        insert applicantDocument1;
                    }
                }Else{
                    if(App1HeaderListl2.size()>0){
                        Update applicantDocument1;
                    }Else{
                        insert applicantDocument1;
                    }
                }
                   
            }
            if(applicantList.size() > 1){
                for(Integer k : seqList){
                    applicantDocument1.put('Value' + k + '__c', applicantDetailsMap.get('Second Applicant' + k));
                }
                applicantDocument2.name = 'Applicant 2';
                applicantDocument2.Document_Checklist_Header__c = docHeader.id;
                applicantDocument2.RecordTypeId = applicantRecordTypeId;
                
                if(level == 'level1'){
                    if(App2HeaderListl1.size()>0){
                        Update applicantDocument2;
                    }Else{
                        insert applicantDocument2;
                    }
                }Else{
                    if(App2HeaderListl2.size()>0){
                        Update applicantDocument2;
                    }Else{
                        insert applicantDocument2;
                    }
                }
                
            }
            if(applicantList.size() > 2){
                for(Integer k : seqList){
                    applicantDocument1.put('Value' + k + '__c', applicantDetailsMap.get('Third Applicant' + k));
                }
                applicantDocument3.name = 'Applicant 3';
                applicantDocument3.Document_Checklist_Header__c = docHeader.id;
                applicantDocument3.RecordTypeId = applicantRecordTypeId;
                
                if(level == 'level1'){
                    if(App3HeaderListl1.size()>0){
                        Update applicantDocument3;
                    }Else{
                        insert applicantDocument3;
                    }
                }Else{
                    if(App3HeaderListl2.size()>0){
                        Update applicantDocument3;
                    }Else{
                        insert applicantDocument3;
                    }
                }

            }
            if(applicantList.size() > 3){
                for(Integer k : seqList){
                    applicantDocument1.put('Value' + k + '__c', applicantDetailsMap.get('Fourth Applicant' + k));
                }
                applicantDocument4.name = 'Applicant 4';
                applicantDocument4.Document_Checklist_Header__c = docHeader.id;
                applicantDocument4.RecordTypeId = applicantRecordTypeId;
                
                if(level == 'level1'){
                    if(App4HeaderListl1.size()>0){
                        Update applicantDocument4;
                    }Else{
                        insert applicantDocument4;
                    }
                }Else{
                    if(App4HeaderListl2.size()>0){
                        Update applicantDocument4;
                    }Else{
                        insert applicantDocument4;
                    }
                }
                
            }
            if(applicantList.size() > 4){
                for(Integer k : seqList){
                    applicantDocument1.put('Value' + k + '__c', applicantDetailsMap.get('Fifth Applicant' + k));
                }
                applicantDocument5.name = 'Applicant 5';
                applicantDocument5.Document_Checklist_Header__c = docHeader.id;
                applicantDocument5.RecordTypeId = applicantRecordTypeId;
                
                if(level == 'level1'){
                    if(App5HeaderListl1.size()>0){
                        Update applicantDocument5;
                    }Else{
                        insert applicantDocument5;
                    }
                }Else{
                    if(App5HeaderListl2.size()>0){
                        Update applicantDocument5;
                    }Else{
                        insert applicantDocument5;
                    }
                }

            }
            
            isAccepted = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm, 'Document Checklist verified successfully.'));
        }
        
    }
    public void reject(){
        system.debug('Inside reject Method:: ');
        docHeader2 = new Document_Checklist_Header__c();
        if(level == 'Level2'){
            Integer valid = 0;
            isRejected = false;
            for(Integer i : WP.keySet()){
                
                boolean isChecked = (boolean)docHeader.get('Level_2_Verified'+ i +'__c');
                docHeader2.put('Level_1_Verified'+ i +'__c', isChecked);
                
                string remarks = (string)docHeader.get('Remarks'+ i +'__c');
                docHeader2.put('Remarks'+ i +'__c', remarks);
                
                if(WP.get(i).required == 'Mandatory' && !isChecked){
                    if(string.isBlank(remarks)){
                        WrapperClass w = WP.get(i);
                        w.isError = true;
                        Wp.put(i,w);
                        valid = 1;
                    }
                }else if(WP.get(i).required == 'Mandatory' && isChecked){
                    WrapperClass w = WP.get(i);
                    w.isError = false;
                    Wp.put(i,w);
                }
            }
            for(Integer i=0;i<applicantList.size();i++){
                Applicant_Document_Checklist__c applicantDocument = new Applicant_Document_Checklist__c();
                Applicant_Document_Checklist__c applicantDocumentl1 = new Applicant_Document_Checklist__c();
                applicantDocumentl1 = new Applicant_Document_Checklist__c();
                if(i==0){
                    applicantDocument = applicantDocument1;
                    applicantDocumentl1 = applicantDocument1L1; 
                }else if(i==1){   
                    applicantDocument = applicantDocument2;
                    applicantDocumentl1 = applicantDocument2L1;
                }else if(i==2){   
                    applicantDocument = applicantDocument3;
                    applicantDocumentl1 = applicantDocument3L1;
                }else if(i==3){   
                    applicantDocument = applicantDocument4;
                    applicantDocumentl1 = applicantDocument4L1;
                }else if(i==4){   
                    applicantDocument = applicantDocument5;
                    applicantDocumentl1 = applicantDocument5L1;
                }
                for(Integer j : WPAPP.keySet()){
                    boolean isChecked = (boolean)applicantDocument.get('Level_2_Verified'+ j +'__c');
                    applicantDocumentl1.put('Level_1_Verified'+ j +'__c', isChecked);
                    
                    string remarks = (string)applicantDocument.get('Remarks'+ j +'__c');
                    applicantDocumentl1.put('Remarks'+ j +'__c', remarks);
                    
                    if(WPAPP.get(j).required == 'Mandatory' && !isChecked){
                        if(string.isBlank(remarks)){
                            WrapperClass w = WPAPP.get(j);
                            w.isError = true;
                            WPAPP.put(j,w);
                            valid = 1;
                        }
                    }else if(WPAPP.get(j).required == 'Mandatory' && isChecked){ 
                        WrapperClass w = WPAPP.get(j);
                        w.isError = false;
                        WPAPP.put(j,w);
                    }
                }
            }
            if(valid == 1){
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Mandatory document not verify then Rejection Remarks is Mandatory'));
            }else{
                //docHeader.Booking__C = bList[0].id;
                Id devRecordTypeId = Schema.SObjectType.Document_Checklist_Header__c.getRecordTypeInfosByName().get('Level2').getRecordTypeId();
                docHeader.RecordTypeId = devRecordTypeId;  
                docHeader.Status__c = 'Rejected';   
                for(Integer k : documentDetailsMap.keyset()){
                    docHeader.put('Value' + k + '__c',documentDetailsMap.get(k));
                }
                if(docHeaderListl2.size()>0){
                    Update docHeader;
                    Id devRecordTypeIdl1 = Schema.SObjectType.Document_Checklist_Header__c.getRecordTypeInfosByName().get('Level1').getRecordTypeId();
                    docHeader2.RecordTypeId = devRecordTypeIdl1;
                    docHeader2.Booking__C = bList[0].id;
                    Insert docHeader2;
                }Else{
                    docHeader.Booking__C = bList[0].id;
                    insert docHeader;
                    docHeader2.Booking__C = bList[0].id;
                    Id devRecordTypeIdl1 = Schema.SObjectType.Document_Checklist_Header__c.getRecordTypeInfosByName().get('Level1').getRecordTypeId();
                    docHeader2.RecordTypeId = devRecordTypeIdl1;
                    Insert docHeader2;
                } 
                
                Id applicantRecordTypeId= Schema.SObjectType.Applicant_Document_Checklist__c.getRecordTypeInfosByName().get('Level2').getRecordTypeId();
                Id applicantRecordTypeIdL1= Schema.SObjectType.Applicant_Document_Checklist__c.getRecordTypeInfosByName().get('Level1').getRecordTypeId();
                
                if(applicantList.size() > 0){
                    for(Integer k : seqList){
                        applicantDocument1.put('Value' + k + '__c', applicantDetailsMap.get('Primary Applicant' + k));
                        //applicantDocument1L1.put('Value' + k + '__c', applicantDetailsMap.get('Primary Applicant' + k));
                    }
                    applicantDocument1.name = 'Applicant 1';
                    applicantDocument1.Document_Checklist_Header__c = docHeader.id;
                    applicantDocument1.RecordTypeId = applicantRecordTypeId;
                    
                    applicantDocument1L1.name = 'Applicant 1';
                    applicantDocument1L1.Document_Checklist_Header__c = docHeader2.id;
                    applicantDocument1L1.RecordTypeId = applicantRecordTypeIdL1;
                    
                    if(level == 'level1'){
                        if(App1HeaderListl1.size()>0){
                            Update applicantDocument1;                            
                        }Else{
                            insert applicantDocument1;
                        }
                    }Else{
                        if(App1HeaderListl2.size()>0){
                            Update applicantDocument1;
                            insert applicantDocument1L1;
                        }Else{
                            insert applicantDocument1;
                            insert applicantDocument1L1;
                        }
                    }
    
                }
                if(applicantList.size() > 1){
                    for(Integer k : seqList){
                        applicantDocument1.put('Value' + k + '__c', applicantDetailsMap.get('Second Applicant' + k));
                        //applicantDocument2L1.put('Value' + k + '__c', applicantDetailsMap.get('Second Applicant' + k));
                    }
                    applicantDocument2.name = 'Applicant 2';
                    applicantDocument2.Document_Checklist_Header__c = docHeader.id;
                    applicantDocument2.RecordTypeId = applicantRecordTypeId;
                    
                    applicantDocument2L1.name = 'Applicant 2';
                    applicantDocument2L1.Document_Checklist_Header__c = docHeader2.id;
                    applicantDocument2L1.RecordTypeId = applicantRecordTypeIdL1;
                    if(level == 'level1'){
                        if(App2HeaderListl1.size()>0){
                            Update applicantDocument2;
                        }Else{
                            insert applicantDocument2;
                        }
                    }Else{
                        if(App2HeaderListl2.size()>0){
                            Update applicantDocument2;
                            insert applicantDocument2L1;
                        }Else{
                            insert applicantDocument2;
                            Insert applicantDocument2L1;
                        }
                    }
                }
                if(applicantList.size() > 2){
                    for(Integer k : seqList){
                        applicantDocument1.put('Value' + k + '__c', applicantDetailsMap.get('Third Applicant' + k));
                        //applicantDocument3L1.put('Value' + k + '__c', applicantDetailsMap.get('Third Applicant' + k));
                    }
                    applicantDocument3.name = 'Applicant 3';
                    applicantDocument3.Document_Checklist_Header__c = docHeader.id;
                    applicantDocument3.RecordTypeId = applicantRecordTypeId;
                    
                    applicantDocument3l1.name = 'Applicant 3';
                    applicantDocument3L1.Document_Checklist_Header__c = docHeader2.id;
                    applicantDocument3L1.RecordTypeId = applicantRecordTypeIdL1;
                    
                    if(level == 'level1'){
                        if(App3HeaderListl1.size()>0){
                            Update applicantDocument3;
                        }Else{
                            insert applicantDocument3;
                        }
                    }Else{
                        if(App3HeaderListl2.size()>0){
                            Update applicantDocument3;
                            insert applicantDocument3l1;
                        }Else{
                            insert applicantDocument3;
                            insert applicantDocument3l1;
                        }
                    }
                }
                if(applicantList.size() > 3){
                    for(Integer k : seqList){
                        applicantDocument1.put('Value' + k + '__c', applicantDetailsMap.get('Fourth Applicant' + k));
                        //applicantDocument4L1.put('Value' + k + '__c', applicantDetailsMap.get('Fourth Applicant' + k));
                    }
                    applicantDocument4.name = 'Applicant 4';
                    applicantDocument4.Document_Checklist_Header__c = docHeader.id;
                    applicantDocument4.RecordTypeId = applicantRecordTypeId;
                    
                    applicantDocument4L1.name = 'Applicant 4';
                    applicantDocument4L1.Document_Checklist_Header__c = docHeader2.id;
                    applicantDocument4L1.RecordTypeId = applicantRecordTypeIdL1;
                    
                    if(level == 'level1'){
                        if(App4HeaderListl1.size()>0){
                            Update applicantDocument4;
                        }Else{
                            insert applicantDocument4;
                        }
                    }Else{
                        if(App4HeaderListl2.size()>0){
                            Update applicantDocument4;
                            insert applicantDocument4L1;
                        }Else{
                            insert applicantDocument4;
                            insert applicantDocument4L1;
                        }
                    }
                }
                if(applicantList.size() > 4){
                    for(Integer k : seqList){
                        applicantDocument1.put('Value' + k + '__c', applicantDetailsMap.get('Fifth Applicant' + k));
                        //applicantDocument5L1.put('Value' + k + '__c', applicantDetailsMap.get('Fifth Applicant' + k));
                    }
                    applicantDocument5.name = 'Applicant 5';
                    applicantDocument5.Document_Checklist_Header__c = docHeader.id;
                    applicantDocument5.RecordTypeId = applicantRecordTypeId;
                    
                    applicantDocument5L1.name = 'Applicant 5';
                    applicantDocument5L1.Document_Checklist_Header__c = docHeader2.id;
                    applicantDocument5L1.RecordTypeId = applicantRecordTypeIdL1;
                    
                    if(level == 'level1'){
                        if(App5HeaderListl1.size()>0){
                            Update applicantDocument5;
                        }Else{
                            insert applicantDocument5;
                        }
                    }Else{
                        if(App5HeaderListl2.size()>0){
                            Update applicantDocument5;
                            insert applicantDocument5L1;
                        }Else{
                            insert applicantDocument5;
                            insert applicantDocument5L1;
                        }
                    }
                }
                
                bList[0].Doc_Verification_Status__c = 'Level 2 Rejected';
                update bList;
                
                Property__C pr = new Property__C();
                pr.id = bList[0].Property__C;
                pr.Status__c = 'CRM Returned To Sales';
                update pr;
                
                isRejected = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info, 'Document Checklist Rejected.'));
                SendMail();
            }
        }
        
    }
    public PageReference home(){
        PageReference pg = new PageReference('/'+bList[0].id);
        pg.setRedirect(true);
        return pg;
    }
    
    Public void SendMail(){
    Integer valid = 0;
      String Body = '';
      String HeaderName = '';
      String Remarks = '';
      List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        if(bList[0].Opportunity__r.Owner.Email != Null)
        sendTo.add(bList[0].Opportunity__r.Owner.Email);
        if(bList[0].Site_Support__r.Email != Null)
        sendTo.add(bList[0].Site_Support__r.Email);
        if(bList[0].Property__r.Sales_Head__r.Email != Null)
        sendTo.add(bList[0].Property__r.Sales_Head__r.Email);
        
        mail.setToAddresses(sendTo);
        mail.setSubject('Document Verification Rejected - Discrepancy');
         body = 'Dear ' + bList[0].Opportunity__r.Owner.Name + ',<br/><br/> ';
            body += 'Document Verification For the Level 2 is Rejected for Booking No : '+bList[0].Name+'<br/>';
            body += 'Please contact L2 Support team.<br/><br/>';
            body += '<table border="1" style="border-collapse: collapse"><caption  style="text-align:Left"><b>Document Discrepancy</b></caption><tr><th>Document Headers</th><th>CRM Remarks</th></tr>';
            
        for(Integer i : WP.keySet()){
            boolean isChecked = false;
            string remarks1 = (string)docHeader.get('Remarks'+ i +'__c');
            isChecked = (boolean)docHeader.get('Level_2_Verified'+ i +'__c');    
            system.debug('i is:::'+i + ' ::: wp.get(i):: '+wp.get(i) + ' :: ischecked::'+isChecked);
            if(WP.get(i).required == 'Mandatory' && !isChecked){
                HeaderName =  descriptionMap.get('line_item_name'+i+'__c');
                Remarks =  (String)docHeader.get('Remarks'+i+'__c');
                Body += '<tr><td>' + HeaderName + '</td><td>' + Remarks + '</td></tr>';
            }
        }
        
        
        for(Integer i=0;i<applicantList.size();i++){
            Applicant_Document_Checklist__c applicantDocument = new Applicant_Document_Checklist__c();
            String ApplicantNo = '';
            if(i==0){
                applicantDocument = applicantDocument1;
                ApplicantNo = 'Applicant No - 1'; 
            }
            else if(i==1){   
                applicantDocument = applicantDocument2;
                ApplicantNo = 'Applicant No - 2';
            }
            else if(i==2){   
                applicantDocument = applicantDocument3;
                ApplicantNo = 'Applicant No - 3';
            }
            else if(i==3){   
                applicantDocument = applicantDocument4;
                ApplicantNo = 'Applicant No - 4';
            }
            else if(i==4){   
                applicantDocument = applicantDocument5;
                ApplicantNo = 'Applicant No - 5';
            }      
                    
            Body += '<tr><td colspan="2">'+'<b>'+ApplicantNo+'</b>'+'</td></tr>';
            for(Integer j : WPAPP.keySet()){
                boolean isChecked;
                isChecked = (boolean)applicantDocument.get('Level_2_Verified'+ j +'__c');    
                string remarks1 = (string)docHeader.get('Remarks'+ j +'__c');
                if(WPAPP.get(j).required == 'Mandatory' && !isChecked){
                    HeaderName =  applicantDocMap.get('line_item_name'+j+'__c');
                    Remarks1 =  (String)applicantDocument.get('Remarks'+j+'__c');
                    Body += '<tr><td>' + HeaderName + '</td><td>' + Remarks1 + '</td></tr>';
                }
            }
        }
        body += '</table><br/>';
        body += 'Thanks.<br/>Support Team';
        if(valid == 1){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Mandatory document not verify then Remarks is Mandatory'));    
        }Else{
        mail.setHtmlBody(body);
        mails.add(mail);
        Messaging.sendEmail(mails);      
        isMailSend = True;
        }
    }
    
    Public void getDocumentDetailsMap(){
        documentDetailsMap = new map<Integer, string>();
        /*string propertyDetails = bList[0].Project__r.Name + '-' + bList[0].Tower_Name__c + '-' + bList[0].Property__r.House_Unit_No__c + '-' +
                                bList[0].Property__r.Floor_No__c + '-' + bList[0].Property__r.Property_Type_Name__c; 
        */
        string propertyDetails = bList[0].Property__r.Material_No__c + '-' + bList[0].Property__r.Property_Type_Name__c;
        string salePrice = QuotationManagmentServices.INFormatR(bList[0].Quotation__r.Total_Agreement_Value_Modified__c);                        
        string BrokerName  = '';
        If(bList[0].Booking_Through__c == 'Partner'){
            if(bList[0].Opportunity__r.Broker_Account__c != Null){
                BrokerName  = bList[0].Opportunity__r.Broker_Account__r.Name;
            }Else{
                BrokerName  = bList[0].Opportunity__r.Partner_s_Firm_Name__c;
            }
        }Else{
            BrokerName  = 'N/A';
        }            
        documentDetailsMap.put(1,'N/A');documentDetailsMap.put(2,'N/A');documentDetailsMap.put(3,'N/A');
        documentDetailsMap.put(4,'N/A');documentDetailsMap.put(5,'N/A');documentDetailsMap.put(6,'N/A');
        documentDetailsMap.put(7,'N/A');documentDetailsMap.put(8, 'N/A');documentDetailsMap.put(9, 'N/A');
        documentDetailsMap.put(10,'N/A');documentDetailsMap.put(11,'N/A');documentDetailsMap.put(12,'N/A');
        documentDetailsMap.put(13,'N/A');documentDetailsMap.put(14,BrokerName);documentDetailsMap.put(15, propertyDetails);
        documentDetailsMap.put(16, salePrice);documentDetailsMap.put(17, bList[0].Mode_of_Funding__c);documentDetailsMap.put(18,'N/A');
        documentDetailsMap.put(19,'N/A');documentDetailsMap.put(20,'N/A');documentDetailsMap.put(21,'N/A');
        documentDetailsMap.put(22,'N/A');
        
    }
    Public void getApplicantDetailsMap(){
        applicantDetailsMap = new map<string, string>();
        for(Applicant__C ap : applicantList){
            string key = ap.Applicant_Number__c;
            string applicantName = ap.Salutation__c + ' ' + ap.Name;
            string Permenentaddress = '';
            if(ap.House_No__c != null)
                Permenentaddress = ap.House_No__c;
            if(ap.Street_1__c != null)
                Permenentaddress += ', ' + ap.Street_1__c;
            if(ap.Street_2__c != null)
                Permenentaddress += ', ' + ap.Street_2__c;
            if(ap.Street_3__c != null)
                Permenentaddress += ', ' + ap.Street_3__c;
            if(ap.Locality__c != null)
                Permenentaddress += ', ' + ap.Locality__c;
            if(ap.City__c != null)
                Permenentaddress += ', ' + ap.City__c;
            if(ap.State__c != null)
                Permenentaddress += ', ' + ap.State__c;
            if(ap.Country__c != null)
                Permenentaddress += ', ' + ap.Country__c;                             
            string mailingAddress = '';
            if (ap.Mailing_Address_same_as_PermanentAddress__c == true) {
                mailingAddress  = 'Correspondance address same as permanent address';
            } else {
                if (ap.Mailing_Address__c != null) {
                    mailingAddress = ap.Mailing_Address__c.replace(',', ' ');
                }
                mailingAddress = ap.Mailing_Address__c + ' Pincode :' + ap.Mailing_Pincode__c + ' Country :' + ap.Mailing_Country__c;
            }
            
            string offceAddress = '';
            if(ap.Office_Address__c != null){
                offceAddress = ap.Office_Address__c;
            }
            string panNo = '';
            if(ap.PancardNo__c != null){
                panNo = ap.PancardNo__c;
            }
            string occupation = '';
            if(ap.Occupation__c != null)
                occupation = ap.Occupation__c;
            string designation = '';
            if(ap.Designation__c != null)
                designation = ap.Designation__c;    
            applicantDetailsMap.put(key + 1,applicantName);applicantDetailsMap.put(key + 2,Permenentaddress);
            applicantDetailsMap.put(key + 3,mailingAddress);applicantDetailsMap.put(key + 4,ap.Mobile_Number__c);
            applicantDetailsMap.put(key + 5,ap.Email_Address__c);applicantDetailsMap.put(key + 6,ap.Nationality__c);
            applicantDetailsMap.put(key + 7,ap.Subtype_Of_Applicant__c);applicantDetailsMap.put(key + 8,occupation);
            applicantDetailsMap.put(key + 9,offceAddress);applicantDetailsMap.put(key + 10,designation);
            applicantDetailsMap.put(key + 11,'N/A');applicantDetailsMap.put(key + 12,panNo);
            applicantDetailsMap.put(key + 13,'N/A'); 
        }
    }
    
    public void getWPMap(){
        WP = new Map<Integer, WrapperClass>();
        WP.put(1,new WrapperClass('Mandatory',false));WP.put(2,new WrapperClass('Mandatory',false));
        WP.put(3,new WrapperClass('Mandatory',false));WP.put(4,new WrapperClass('Mandatory',false));
        WP.put(5,new WrapperClass('Mandatory',false));WP.put(6,new WrapperClass('Mandatory',false));
        WP.put(7,new WrapperClass('Mandatory',false));WP.put(8,new WrapperClass('Mandatory',false));
        WP.put(9,new WrapperClass('Mandatory',false));WP.put(10,new WrapperClass('Mandatory',false));
        WP.put(11,new WrapperClass('Optional',false));WP.put(12,new WrapperClass('Mandatory',false));
        WP.put(13,new WrapperClass('Mandatory',false));WP.put(14,new WrapperClass('Mandatory',false));
        WP.put(15,new WrapperClass('Mandatory',false));WP.put(16,new WrapperClass('Mandatory',false));
        if(level == 'Level1')WP.put(17,new WrapperClass('Optional',false));else WP.put(17,new WrapperClass('Mandatory',false));
        if(level == 'Level1')WP.put(18,new WrapperClass('Optional',false));else WP.put(18,new WrapperClass('Mandatory',false));
        WP.put(19,new WrapperClass('Mandatory',false));WP.put(20,new WrapperClass('Mandatory',false));
        WP.put(21,new WrapperClass('Mandatory',false));WP.put(22,new WrapperClass('Mandatory',false));
    }
    public void getWPAPPMap(){
        WPAPP = new Map<Integer, WrapperClass>();
        WPAPP.put(1,new WrapperClass('Mandatory',false));WPAPP.put(2,new WrapperClass('Mandatory',false));
        WPAPP.put(3,new WrapperClass('Mandatory',false));WPAPP.put(4,new WrapperClass('Mandatory',false));
        WPAPP.put(5,new WrapperClass('Mandatory',false));WPAPP.put(6,new WrapperClass('Mandatory',false));
        if(level == 'Level1')WPAPP.put(7,new WrapperClass('Optional',false));else WPAPP.put(7,new WrapperClass('Mandatory',false));
        if(level == 'Level1')WPAPP.put(8,new WrapperClass('Optional',false));else WPAPP.put(8,new WrapperClass('Mandatory',false));
        WPAPP.put(9,new WrapperClass('Optional',false));WPAPP.put(10,new WrapperClass('Optional',false));
        WPAPP.put(11,new WrapperClass('Optional',false));WPAPP.put(12,new WrapperClass('Mandatory',false));
        WPAPP.put(13,new WrapperClass('Optional',false));
    }
    
    Public Class WrapperClass{
        public string required {get;set;}
        public boolean isError {get;set;}
        
        public WrapperClass(string required, boolean isError){
            this.required = required;
            this.isError = isError;
        }
    }
}
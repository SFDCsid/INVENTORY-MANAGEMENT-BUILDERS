public without sharing class CPFormController {

    public String formType{get;set;}
    public String msg{get;set;}
    public String msg1{get;set;}
    public String msg2{get;set;}
    public Id accId{get;set;}
    public String mobile_no{get;set;}
    public String reraId{get;set;}
    public String PfileName {get; set;}
    public String gfileName {get; set;}
    public String psfileName {get; set;}
    public String rfileName {get; set;}
    public List<Account> accList{get;set;}
   // public List<Account> accList1{get;set;}
    public List<Account> accListfetched{get;set;}
    public Boolean showMsg{get;set;}
    public Boolean showMsg1{get;set;}
    //public Boolean showMsg2{get;set;}
    public List<Task> tlist{get;set;}
    public Date meetingDate{get;set;}
    public String meetingDateStr{get;set;}
    public boolean isUploadChecked {get;set;}
    public boolean isNextChecked {get;set;}
    public boolean isUploadpan {get;set;}
    public boolean isUploadGst {get;set;}
    public boolean isUploadPassport {get;set;}
	public boolean isUploadRera {get;set;}
    public Integer pageIndex{get;set;}    
    public transient String p1base64; // for cp pan
    public transient String g1base64; //Gst
    public transient String r1base64; //rera
    public transient String ps1base64; //passport

	   
     //pan
    public void setp1base64(String p1base64)
    {
        this.p1base64 = p1base64;
    }
    public String getp1base64()
    {
        return p1base64;
    }
    
     //Gst
    public void setg1base64(String g1base64)
    {
        this.g1base64 = g1base64;
    }
    public String getg1base64()
    {
        return g1base64;
    }
     //Rera
    public void setr1base64(String r1base64)
    {
        this.r1base64 = r1base64;
    }
    public String getr1base64()
    {
        return r1base64;
    }
    
     //Passport
    public void setps1base64(String ps1base64)
    {
        this.ps1base64 = ps1base64;
    }
    public String getps1base64()
    {
        return ps1base64;
    }
    
    public CPFormController(){ 
        accId = null;
        msg = '';
		msg1 = '';
        showMsg = false;
                showMsg1 = false;

        formType='';
        mobile_no='';
        reraId='';
        meetingDate=null;
        meetingDateStr='';
        accList = new List<Account>();
        accListfetched = new List<Account>();
        isUploadpan = false;
        isUploadGst = false;
        isUploadPassport = false;
        isUploadRera = false;
        isUploadChecked = false;
        isNextChecked = false;
        RecordType rt = new RecordType();
		pageIndex = 0;
        formType = ApexPages.currentPage().getParameters().get('type');
        if(ApexPages.currentPage().getParameters().get('mobile')!='null' )
        mobile_no = ApexPages.currentPage().getParameters().get('mobile');
        reraId = ApexPages.currentPage().getParameters().get('reraId');
         System.debug('Record Type111111111:: '+String.isNotBlank(mobile_no));

        if(formType=='create'&& (String.isNotBlank(mobile_no) || String.isNotBlank(reraId)) ){
           System.debug('Record Type:: ');

           rt = [Select Id, DeveloperName, Name from RecordType where Name =: 'Channel Partner'];      
           System.debug('Record Type:: '+rt.Name);
             /*accList1 = [Select Id, Name from Account where RecordTypeId=:rt.id];
				System.debug('Record Type:: '+accList1[0].Id);*/
            Account acc = new Account();
            system.debug('mobile_no:::'+mobile_no);

            acc.Phone = mobile_no;
            acc.MahaRERA_Registration_No__c = reraId;
            acc.RecordTypeId = rt.id;
            accList.add(acc);
            
            
           
            
           
            
        }else{
            if(formType=='edit'){
                system.debug('edit');
                accId = ApexPages.currentPage().getParameters().get('accId');  
                if(accId!=null){
                accListfetched = [SELECT Id,Name,FirstName ,LastName,Firm_First_Name__c,Firm_Last_Name__c,isPersonAccount,Point_of_Contact_Name__c,Point_of_Contact_Mobile__c,CP_Stage__c,CP_Type__c,CP_Sub_stage__c,Is_Channel_Partner_Active__c ,Pan_No__c,Point_of_Contact__c,Point_of_Contact__r.Name ,RecordTypeId ,Email__c,Alternate_Mobile_No__c,PAN_Card__c,GST_Registration_Certificate__c,Passport__c,RERA_Certificate__c ,Alternate_Email__c,MahaRERA_Registration_No__c,TAN_No__c,Phone,Firm_Name__c,Location1__c,GST_No__c,CP_Firm_Type__c,Name_as_per_MahaRERA__c FROM Account WHERE Id=:accId];
                /*accListfetched[0].Meeting_Type__c = '';
                accListfetched[0].Meeting_Date__c=null;
                accListfetched[0].Call_Status__c='';
                accListfetched[0].Willingness_for_Opportunity__c='';*/
                //accListfetched[0].RecordTypeId =  
                accListfetched[0].Description='';
                accList.addAll(accListfetched);
                     
                }
            }
        }
        
    }
     public PageReference submit() {
             system.debug('pageIndex='+pageIndex);
         
         
         if(pageIndex == 0)
         {
         try{
              pageIndex = 1;
              system.debug('accList='+accList);
              system.debug('pageIndex='+pageIndex);
              tlist = new List<Task>();  
             
             for(Account ac:accList){
                 if(formType=='create'){
                  // ac.Is_Channel_Partner_Active__c=true;
                 }
             }
            
              upsert accList;
             isUploadChecked = true;
         if(formType=='create'){
            msg = 'Broker/ Channel Partner Created Successfully!'+' RecordID:'+accList[0].id ; 
         }else{
            msg = 'Broker/ Channel Partner Details Updated Successfully!'+' RecordID:'+accList[0].id;   
         }  
		
             showMsg = true;
         }catch(Exception e){
            msg = 'Exception Occured:'+e;
            showMsg = true;
         }
         }
         else
         {
            system.debug('else pageIndex='+pageIndex);
             upsert accList;
             IF(pageIndex==1)
           {
               system.debug('isUploadpan:::::::::'+isUploadpan);
                system.debug('accList[0].PAN_Card__c:::::::::'+accList[0].PAN_Card__c);
               /* if(accList[0].PAN_Card__c==true && isUploadpan!=TRUE)
          		 {
                      //msg2 = 'Please Upload Files'; 
                //showMsg2 = true;
                     system.debug('INSIDE:::::::::');
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'"PLEAE Y" field Cannot Be Left Blank');
                   ApexPages.addMessage(myMsg);
                  return  null; 
            }*/
                 msg1 = 'Details Saved Sucessfully'+' RecordID:'+accList[0].id; 
                showMsg1 = true;
               //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Showing Confirmation!'));
              
               
                 /*ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'"success"');
                   ApexPages.addMessage(myMsg);
                  return  null; */
               
           }
             
           
         }
         if(formType=='create' && isNextChecked == true){
             contact cc= new contact();
           	 cc.LastName = accList[0].Name;
           	 cc.Phone = accList[0].Phone;
           	 cc.Email = accList[0].Email__c;
             cc.AccountId = accList[0].Id;
             insert cc;
             accList[0].Point_of_Contact__c = cc.Id;
             update accList;
         system.debug('cc:::::::'+cc);
         }
        
        return null;
    } 
   /* public void upload() {
    
        ContentVersion cv = new ContentVersion();
        cv.versionData = file;
        cv.title = 'testing upload';
        cv.pathOnClient ='Docs.pdf';
        insert cv;
        
        Id cs = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
		ContentDocumentLink cdl = new ContentDocumentLink();
  			 cdl.ContentDocumentId = cs;
             system.debug('accList1[0].Id:::::::::'+accList1[0].Id);
             cdl.LinkedEntityId =  accList1[0].Id;  //'0019D00000RTjXkQAL'; 
  			 cdl.ShareType = 'I'; // Inferred Share
  			 cdl.Visibility = 'AllUsers';
			
			insert cdl;
       // return new PageReferenc
        
  }*/
  
     public void savePanFile()
    {
        DateTime dt = System.now();
        String dateTimeStr = dt.format('yyyy/MM/dd hh:mm:ss a');
        ContentVersion cv = new ContentVersion();
        cv.versionData = EncodingUtil.base64decode(this.p1base64);
        cv.title = 'PanCard: '+dateTimeStr;
        system.debug('cv::::::'+PfileName);
        cv.pathOnClient = PfileName;
        system.debug('cv:::::::::'+cv);
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        //system.debug('accList[0].Id:::::::::'+accList[0].Id);
        cdl.LinkedEntityId =  accList[0].Id; // <----- put your record id here, example: an account tid
        cdl.ShareType = 'I'; // Inferred Share
  	    cdl.Visibility = 'AllUsers';
        insert cdl;
        isUploadpan = true;
    }
   
    
     public void saveGSTFile()
    {
        DateTime dt = System.now();
        String dateTimeStr = dt.format('yyyy/MM/dd hh:mm:ss a');
        ContentVersion cv = new ContentVersion();
        cv.versionData = EncodingUtil.base64decode(this.g1base64);
        cv.title = 'GST Registration Certificate: '+dateTimeStr;
        cv.pathOnClient = gfileName;
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        //system.debug('accList[0].Id:::::::::'+accList[0].Id);
        cdl.LinkedEntityId =  accList[0].Id; // <----- put your record id here, example: an account tid
        cdl.ShareType = 'I'; // Inferred Share
  	    cdl.Visibility = 'AllUsers';
        insert cdl;
        
    }
     public void saveRERAFile()
    {
        DateTime dt = System.now();
        String dateTimeStr = dt.format('yyyy/MM/dd hh:mm:ss a');
        ContentVersion cv = new ContentVersion();
        cv.versionData = EncodingUtil.base64decode(this.r1base64);
        cv.title = 'RERA Certificate: '+dateTimeStr;
        cv.pathOnClient = rfileName;
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        //system.debug('accList[0].Id:::::::::'+accList[0].Id);
        cdl.LinkedEntityId =  accList[0].Id; // <----- put your record id here, example: an account tid
        cdl.ShareType = 'I'; // Inferred Share
  	    cdl.Visibility = 'AllUsers';
        insert cdl;
        
    }
    public void savePassportFile()
    {
        DateTime dt = System.now();
        String dateTimeStr = dt.format('yyyy/MM/dd hh:mm:ss a');
        
        ContentVersion cv = new ContentVersion();
        cv.versionData = EncodingUtil.base64decode(this.ps1base64);
        cv.title = 'Passport: '+dateTimeStr;
        cv.pathOnClient = psfileName;
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        //system.debug('accList[0].Id:::::::::'+accList[0].Id);
        cdl.LinkedEntityId =  accList[0].Id; // <----- put your record id here, example: an account tid
        cdl.ShareType = 'I'; // Inferred Share
  	    cdl.Visibility = 'AllUsers';
        insert cdl;
           
        
    }
    public PageReference Undo(){
       
        Pagereference objReference = new Pagereference('/apex/CPFORM?type='+formType+'&mobile='+mobile_no+'&accId='+accId);
        objReference.setRedirect(true);        
       return objReference;  
    }
    public PageReference previous(){
        showMsg = false;
        Pagereference objReference = new Pagereference('/apex/CPSearchPage');
        objReference.setRedirect(true);        
       return objReference;  
    }
    public PageReference Previous1(){
         showMsg = false;
		system.debug('pageIndex'+pageIndex);
        pageIndex = pageIndex-1;
        
        return null;
    }   
    
    public PageReference Next()
    {
        //pageIndex = 1;
        isNextChecked = true;
        for(Account ac:accList){
           if(ac.Name==''||ac.Name==null)
           {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'"CP Firm Name" field Cannot Be Left Blank');
                   ApexPages.addMessage(myMsg);
                  return  null; 
            }
            
            if(ac.Name_as_per_MahaRERA__c==''||ac.Name_as_per_MahaRERA__c==null){
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'"Name as per MahaRERA" field Cannot Be Left Blank');
                   ApexPages.addMessage(myMsg);
                  return  null;   
                 }
            if(ac.MahaRERA_Registration_No__c==''||ac.MahaRERA_Registration_No__c==null){
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'"CP Code/ RERA No" field Cannot Be Left Blank');
                   ApexPages.addMessage(myMsg);
                  return  null;   
                 }
            if(ac.Name_as_per_MahaRERA__c==''||ac.Name_as_per_MahaRERA__c==null){
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'"Name As Per Maharera" field Cannot Be Left Blank');
                   ApexPages.addMessage(myMsg);
                  return  null;   
                 }
            
              }
        msg1 = '';
        submit();
        isNextChecked = false;
        return null;
    }
    
}
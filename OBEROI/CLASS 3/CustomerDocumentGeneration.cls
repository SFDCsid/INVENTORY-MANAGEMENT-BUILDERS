public class CustomerDocumentGeneration {
    
    
    public String selectedDocument {
        get;
        set;
	}
    
    public id bookingid;
    public Boolean batchStatusBool {get;set;}
    public Boolean pollerBool {get;set;}
    public Boolean isError {get;set;}
    public List<Opportunity> customerList{get;set;}
    public List<Opportunity> customer{get;set;}
    List<SelectOption> pickListValuesList {get;set;}
    public Booking__c bk {get;set;}
    public string bDocName {get;set;}
    public Boolean show {get;set;}
    public String errorMsg1{get;set;}
    public string ProfileName {get;set;}
    
    public CustomerDocumentGeneration(){
         show = false;
        bookingid = apexpages.currentpage().getparameters().get('id');
        system.debug('BookingID'+bookingid);
        batchStatusBool = false;
        pollerBool = false;
        bk = [Select id,Name,Project__c,IsDocument_Generated__c,IsAcceptance_Form_Generated__c from Booking__c where id =: bookingid];
        
        errorMsg1 = '';
 	bDocName = '';
         ProfileName = '';
       Id profileId = UserInfo.getProfileId();
        List<Profile> profList = [SELECT Id, Name FROM Profile WHERE Id=:profileId];
        if(!profList.isEmpty()){
          ProfileName = profList[0].Name;  
        }
    }
    
    
    public List < SelectOption > getDocumentNames{
        get{
           // customerList = new List<DocumentGenerationServices.CustomerWrapper>();
            pickListValuesList = new List<SelectOption>();
            pickListValuesList.add(new SelectOption('', 'Select a Document'));
            Schema.DescribeFieldResult fieldResult = Project__c.Document_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
                for( Schema.PicklistEntry pickListVal : ple){
                    pickListValuesList.add(new SelectOption(pickListVal.getLabel(), pickListVal.getLabel()));
                    
            }
            return pickListValuesList;
        }    
        set;
    }
    
    public void documentchange(){
        CustomerListNew();
    }
    
    public void CustomerListNew(){
        //show = true;
	isError = false;
        
        bDocName = '';
        system.debug('inside getCustomerList method:: '+selectedDocument);
        //system.debug('inside getCustomerList methodVal:: '+Selectedval);
        
        if(string.isNotBlank(selectedDocument)){
            if(selectedDocument == 'NRI Declaration Form' && bk.IsDocument_Generated__c != true){
                show = true;
            }
            else if(selectedDocument == 'Acceptance Form' && bk.IsAcceptance_Form_Generated__c != true){
                show = true;
            }
            else{
                show = false;
                //errorMsg1 = 'Document is already generated for this booking.';
                //isError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning, selectedDocument + ' type Document is already generated for this booking.'));
            }
            boolean isTemplateAvailable = DocumentGenerationServices.checkDocumentTemplate(bk.Project__c, selectedDocument);
            if(isTemplateAvailable){
                
                customerList = new List<Opportunity>();
                customerList = [Select id, Name,Email__c,Booking__c,Booking__r.Project__r.id,Booking__r.Project__r.Project_Template_Label__c,Booking__r.NRI_Declaration_Template__c,Booking__r.Acceptance_Form_Template__c,Booking__r.Unitcode__c,Booking__r.Name from Opportunity where Booking__c =: bookingid];
                customer = new List<Opportunity>();
                system.debug('customerList:: '+customerList.size());
                if(customerList== null || customerList.isEmpty()){
			isError = true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'There is no customer to generate document.'));
		}else if(!customerList.isEmpty()){
                    
                        if(selectedDocument == 'NRI Declaration Form' && customerList[0].Booking__r.NRI_Declaration_Template__c != null ){
                            customer = customerList;
                        }    
                        else if(selectedDocument == 'Acceptance Form' && customerList[0].Booking__r.Acceptance_Form_Template__c != null){
                            customer = customerList;  
                        }
            else{
                isError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, selectedDocument + ' Please Select Document Type on Booking.'));
            }
                } 
            }else{
isError = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, selectedDocument + ' type Document template not available for the selected project.'));
            }      
        }else{
isError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'There is an Internal error.'));
        }       
    }
    
    public PageReference generateDocument(){
        Map<string,string> resultMap = new Map<string,string>();
        if(customer != null && !customer.isEmpty()){
            if(string.isNotBlank(selectedDocument)){
                resultMap = DocumentGenerationServices.generateDocumentMethod(selectedDocument, customer[0]);
            }
            if(selectedDocument == 'NRI Declaration Form'){
          	bk.IsDocument_Generated__c = true;
            bk.NRI_Declaration_Generated_Date__c = Date.today();
            update bk;
            }
            if(selectedDocument == 'Acceptance Form'){
                bk.IsAcceptance_Form_Generated__c = true;
                bk.Acceptance_Form_Generated_date__c = Date.today();
                update bk;
            }
            
            return new PageReference('/apex/DocumentGenerationSuccessPage?id='+bookingId);
        }
        return null;
    }
    
    

}
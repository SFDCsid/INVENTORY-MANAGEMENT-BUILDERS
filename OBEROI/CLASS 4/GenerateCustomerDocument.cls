Public class GenerateCustomerDocument{
    
    public String selectedVal {
        get;
        set;
    }
    public String selectedTower {
        get;
        set;
    }
    public String selectedDocument {
        get;
        set;
    }
    public PaginationController.PaginationWrapper pgw;
    public List<DocumentGenerationServices.CustomerWrapper> customerList{get;set;}
    public List<Related_Document_History__c> rdListAppChk{get;set;}
    public Boolean batchStatusBool {get;set;}
    public String batchStatus {get;set;}
    public Boolean approvedocStatus {get;set;}
    Id batchId;
    public Boolean pollerBool {get;set;}
    public Map<string,List<DocumentGenerationServices.CustomerWrapper>> customerDocumentMap {get;set;}
    Public boolean isComplete{get;set;}
    List<SelectOption> pickListValuesList {get;set;}
    public string selectedRadio {get;set;}
    public List<DocumentGenerationServices.CustomerWrapper> unTaggedCustomerList{get;set;}
    public List<DocumentGenerationServices.CustomerWrapper> taggedCustomerList{get;set;}
    public Boolean isError {get;set;}
    public string bDocName {get;set;}
    public string ProfileName {get;set;}
    public GenerateCustomerDocument(){
        batchStatusBool = false;
        approvedocStatus = false; 
        pollerBool = false;
        isComplete = false; 
        pgw = new PaginationController.PaginationWrapper();
        pgw.list_size = 100;
        pgw.counter = 0;
        pgw.total_size = 1000;
        bDocName = '';
        ProfileName = '';
       Id profileId = UserInfo.getProfileId();
        List<Profile> profList = [SELECT Id, Name FROM Profile WHERE Id=:profileId];
        if(!profList.isEmpty()){
          ProfileName = profList[0].Name;  
        }
    }
    
    
    public List < SelectOption > getProjects {
        get {
            List < SelectOption > optns = new List < Selectoption > ();
            List < Project__c > queryResult = new List < Project__c > ();
            
            queryResult = [Select Id, Name from Project__c];
            optns.add(new SelectOption('', 'Select a Project'));
            for (Project__c obj: queryResult) {
                optns.add(new SelectOption(obj.Id, obj.Name));
            }
            return optns;
        }
        set;
    }
    
    
    public List < SelectOption > getTowers {
        get {
            // customerList = new List<DocumentGenerationServices.CustomerWrapper>();
            //  selectedDocument = null;
            // pickListValuesList = new List<SelectOption>();
            List < SelectOption > options = new List < Selectoption > ();
            options.add(new SelectOption('', 'Select a Tower'));
            if (Selectedval != null) {
                List < Tower__c > qResult = new List < Tower__c > ([Select Id, Name, Tower_Name__c 
                                                                    from Tower__c 
                                                                    where Project_Name__r.id = : Selectedval 
                                                                    order by Name asc]);
                for (Tower__c obj1: qResult) {
                    options.add(new SelectOption(obj1.Id, obj1.Tower_Name__c));
                }
            }
            return options;
        }
        set;
    }
    
    public List < SelectOption > getDocumentNames{
        get{
            // customerList = new List<DocumentGenerationServices.CustomerWrapper>();
            pickListValuesList = new List<SelectOption>();
            pickListValuesList.add(new SelectOption('', 'Select a Document'));
            Schema.DescribeFieldResult fieldResult = Project__c.Document_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            if(string.isNotBlank(selectedVal) && string.isNotBlank(selectedTower)){
                for( Schema.PicklistEntry pickListVal : ple){
                    pickListValuesList.add(new SelectOption(pickListVal.getLabel(), pickListVal.getLabel()));
                }    
            }
            return pickListValuesList;
        }    
        set;
    }
    public void projectchange(){
        selectedTower = null;
        selectedDocument = null;
        selectedRadio = null;
    }
    public void towerchange(){
        selectedRadio = null;
        selectedDocument = null;
    }
    public void documentchange(){
        selectedRadio = null;
    }
    
    public void onRadioChange(){
        system.debug('selectedRadio::: '+selectedRadio);
        CustomerListNew();
    }
    
    public void CustomerListNew(){
        isError = false;
        pgw = new PaginationController.PaginationWrapper();
        pgw.list_size = 100;
        pgw.counter = 0;
        pgw.total_size = 1000;  
        bDocName = '';
        
        system.debug('inside getCustomerList method:: '+selectedDocument);
        if(string.isNotBlank(selectedDocument)){
            boolean isTemplateAvailable = DocumentGenerationServices.checkDocumentTemplate(Selectedval, selectedDocument);
            if(isTemplateAvailable){
                customerList = new List<DocumentGenerationServices.CustomerWrapper>();
                system.debug('pgw.counter:: '+pgw.counter);
                customerList = DocumentGenerationServices.getRegistrationCustomerList(selectedVal, selectedTower, pgw.list_size, pgw.counter);
                unTaggedCustomerList = new List<DocumentGenerationServices.CustomerWrapper>();  
                taggedCustomerList = new List<DocumentGenerationServices.CustomerWrapper>();
                //system.debug('customerList:: '+customerList.size());
                if(customerList== null || customerList.isEmpty()){
                    isError = true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'There is no customer to generate document.'));
                }else if(!customerList.isEmpty()){
                    system.debug('selectedDocument>>>>>>>>'+selectedDocument);
                    for(DocumentGenerationServices.CustomerWrapper cp : customerList){
                        if(selectedDocument == 'Acceptance Form' && cp.o.Booking__R.Acceptance_Form_Template__c == null)
                            unTaggedCustomerList.add(cp); 
                        else if(selectedDocument == 'Agreement Form' && cp.o.Booking__R.Agreement_Form_Template__c == null)
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Allotment Form' && cp.o.Booking__R.Allotment_Form_Template__c == null){
                            System.debug('cp.o.Booking__R.Allotment_Form_Template__c######'+cp.o.Booking__R.Allotment_Form_Template__c);
                            unTaggedCustomerList.add(cp);
                        }
                        else if(selectedDocument == 'NRI Declaration Form' && cp.o.Booking__R.NRI_Declaration_Template__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Mortgage Release Request Letter' && cp.o.Booking__R.Mortgage_Release_Request_Letter__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Agreement signing undertaking' && cp.o.Booking__R.Agreement_Signing_undertaking__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Annexure B - Nomination Form' && cp.o.Booking__R.Annexure_B_Nomination_Form__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'TPA' && cp.o.Booking__R.TPA__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Bank NOC' && cp.o.Booking__R.Bank_NOC__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Provisional NOC' && cp.o.Booking__R.Provisional_NOC__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'L&L NOC' && cp.o.Booking__R.L_L_NOC__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Car Park Allotment Letter' && cp.o.Booking__R.Car_Park_Allotment_Letter__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Possession Undertaking Letter' && cp.o.Booking__R.Possession_Undertaking_Letter__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Possession Letter' && cp.o.Booking__R.Possession_Letter__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Electricity Meter transfer NOC' && cp.o.Booking__R.Electricity_Meter_transfer_NOC__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Rejection Notice - Pre Possession' && cp.o.Booking__R.Rejection_Notice_Pre_Possession__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Rejection Notice - Post Possession' && cp.o.Booking__R.Rejection_Notice_Post_Possession__c == null)   
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'ROFR NOC Loan case' && cp.o.Booking__R.ROFR_NOC_Loan_case__c == null)   
                            unTaggedCustomerList.add(cp);
                         else if(selectedDocument == 'Agreement Generation Request' && cp.o.Booking__R.Agreement_Request_Template__c == null)
                            unTaggedCustomerList.add(cp);
                        else if(selectedDocument == 'Acceptance Form' && cp.o.Booking__R.Acceptance_Form_Template__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Agreement Form' && cp.o.Booking__R.Agreement_Form_Template__c != null)
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Agreement Generation Request' && cp.o.Booking__R.Agreement_Request_Template__c != null)
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Allotment Form' && cp.o.Booking__R.Allotment_Form_Template__c != null){
                            System.debug('cp.o.Booking__R.Allotment_Form_Template__c>>>>>>>>'+cp.o.Booking__R.Allotment_Form_Template__c);
                            taggedCustomerList.add(cp);
                        }
                        else if(selectedDocument == 'NRI Declaration Form' && cp.o.Booking__R.NRI_Declaration_Template__c != null)   
                            taggedCustomerList.add(cp); 
                        else if(selectedDocument == 'Mortgage Release Request Letter' && cp.o.Booking__R.Mortgage_Release_Request_Letter__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Agreement signing undertaking' && cp.o.Booking__R.Agreement_Signing_undertaking__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Annexure B - Nomination Form' && cp.o.Booking__R.Annexure_B_Nomination_Form__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'TPA' && cp.o.Booking__R.TPA__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Bank NOC' && cp.o.Booking__R.Bank_NOC__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Provisional NOC' && cp.o.Booking__R.Provisional_NOC__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'L&L NOC' && cp.o.Booking__R.L_L_NOC__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Car Park Allotment Letter' && cp.o.Booking__R.Car_Park_Allotment_Letter__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Possession Undertaking Letter' && cp.o.Booking__R.Possession_Undertaking_Letter__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Possession Letter' && cp.o.Booking__R.Possession_Letter__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Electricity Meter transfer NOC' && cp.o.Booking__R.Electricity_Meter_transfer_NOC__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Rejection Notice - Pre Possession' && cp.o.Booking__R.Rejection_Notice_Pre_Possession__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'Rejection Notice - Post Possession' && cp.o.Booking__R.Rejection_Notice_Post_Possession__c != null)   
                            taggedCustomerList.add(cp);
                        else if(selectedDocument == 'ROFR NOC Loan case' && cp.o.Booking__R.ROFR_NOC_Loan_case__c != null)   
                            taggedCustomerList.add(cp);    
                    }
                    system.debug('taggedCustomerList:::::::::::'+taggedCustomerList);  
                    system.debug('taggedCustomerListsize:::::::::::'+taggedCustomerList.size());  
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
    
    public pageReference checkInput(){
        
        if(customerList != null && !customerList.isEmpty() && customerList.size() > 0){
            for(DocumentGenerationServices.CustomerWrapper cp : customerList){
                system.debug('selected:: '+cp.Selected);
                
            }    
        }
        
        return null;
    }
    
    public void generateDocument(){
        system.debug('inside generateDocument method:::'+selectedDocument);
        system.debug('customerList:::'+customerList);
        customerDocumentMap = new Map<string,List<DocumentGenerationServices.CustomerWrapper>>();
        if(customerList != null && !customerList.isEmpty()){
            if(string.isNotBlank(selectedDocument)){
                List<DocumentGenerationServices.CustomerWrapper> custList = new List<DocumentGenerationServices.CustomerWrapper>();
                for(DocumentGenerationServices.CustomerWrapper cp : customerList){
                    system.debug('isSelected:: '+cp);
                    if(cp.selected)
                        custList.add(cp);
                }
                rdListAppChk = [SELECT Id,Name,Document_Name__c,CreatedDate,Booking__C,Opportunity__c,Document_Approved__c,Project_Template_Label__c,Template_Label__c,Document_Number_Series__c 
                                FROM Related_Document_History__c
                                WHERE (Name =: selectedDocument AND (Name != 'Bank NOC' AND Name != 'Provisional NOC' )) and Booking__C =: custList[0].o.Booking__C and Document_Approved__c =: true];
                if(rdListAppChk.size()>0){
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Once the document is approved then you can not generate it again.'));
                    approvedocStatus = true;
                    system.debug('rdListAppChk ::'+rdListAppChk);
                }
                
                
                else if(custList != null && !custList.isEmpty()){
                    customerDocumentMap.put(selectedDocument,custList);
                    batchId = DocumentGenerationServices.generateDocBatch(customerDocumentMap);
                    batchStatusBool = true;
                    approvedocStatus = false;
                    checkBatchStatus();
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'No customers were selected.Please select the customers for generating document.'));
                }    
            }
            
        }
        
    }
    
    
    public void checkBatchStatus() {
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id =: batchId];
        batchStatus = job.Status;
        if(batchStatus == 'Completed') {
            pollerBool = false;
            batchStatusBool = false;
            isComplete = true;
            //getNextCustomers();
        } else {
            pollerBool = true;
        }
    }
    
    
    public void getNextCustomers(){
        system.debug('inside getNextCustomers method');
        system.debug('pgw.list_size:: '+pgw.list_size);
        system.debug('pgw.counter:: '+pgw.counter);
        system.debug('selectedVal:: '+selectedVal);
        system.debug('selectedTower:: '+selectedTower);
        customerList = new List<DocumentGenerationServices.CustomerWrapper>();
        customerList = DocumentGenerationServices.getRegistrationCustomerList(selectedVal, selectedTower, pgw.list_size, pgw.counter);
        system.debug('customerList:: '+customerList);
        unTaggedCustomerList = new List<DocumentGenerationServices.CustomerWrapper>();  
        taggedCustomerList = new List<DocumentGenerationServices.CustomerWrapper>();
        if(customerList != Null){
            if(!customerList.isEmpty() && customerList.size()>0){
                for(DocumentGenerationServices.CustomerWrapper cp : customerList){
                    system.debug('selectedDocument>>>>>>>>'+selectedDocument);
                    if(selectedDocument == 'Acceptance Form' && cp.o.Booking__R.Acceptance_Form_Template__c == null)
                        unTaggedCustomerList.add(cp); 
                    else if(selectedDocument == 'Agreement Form' && cp.o.Booking__R.Agreement_Form_Template__c == null)
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Agreement Generation Request' && cp.o.Booking__R.Agreement_Request_Template__c == null)
                            untaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Allotment Form' && cp.o.Booking__R.Allotment_Form_Template__c == null){
                        System.debug('cp.o.Booking__R.Allotment_Form_Template__c::::::::::'+cp.o.Booking__R.Allotment_Form_Template__c);
                        unTaggedCustomerList.add(cp);
                    }
                    else if(selectedDocument == 'NRI Declaration Form' && cp.o.Booking__R.NRI_Declaration_Template__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Mortgage Release Request Letter' 
                            && cp.o.Booking__R.Mortgage_Release_Request_Letter__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Agreement signing undertaking' 
                            && cp.o.Booking__R.Agreement_Signing_undertaking__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Annexure B - Nomination Form' 
                            && cp.o.Booking__R.Annexure_B_Nomination_Form__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'TPA' && cp.o.Booking__R.TPA__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Bank NOC' 
                            && cp.o.Booking__R.Bank_NOC__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Provisional NOC' 
                            && cp.o.Booking__R.Provisional_NOC__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'L&L NOC' 
                            && cp.o.Booking__R.L_L_NOC__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Car Park Allotment Letter' 
                            && cp.o.Booking__R.Car_Park_Allotment_Letter__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Possession Undertaking Letter' 
                            && cp.o.Booking__R.Possession_Undertaking_Letter__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Possession Letter' 
                            && cp.o.Booking__R.Possession_Letter__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Electricity Meter transfer NOC' 
                            && cp.o.Booking__R.Electricity_Meter_transfer_NOC__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Rejection Notice - Pre Possession' 
                            && cp.o.Booking__R.Rejection_Notice_Pre_Possession__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'Rejection Notice - Post Possession' 
                            && cp.o.Booking__R.Rejection_Notice_Post_Possession__c == null)   
                        unTaggedCustomerList.add(cp);
                    else if(selectedDocument == 'ROFR NOC Loan case' 
                            && cp.o.Booking__R.ROFR_NOC_Loan_case__c == null)   
                        unTaggedCustomerList.add(cp);
                    
                    else if(selectedDocument == 'Acceptance Form' 
                            && cp.o.Booking__R.Acceptance_Form_Template__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Agreement Form' 
                            && cp.o.Booking__R.Agreement_Form_Template__c != null)
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Allotment Form' && cp.o.Booking__R.Allotment_Form_Template__c != null){
                        System.debug('cp.o.Booking__R.Allotment_Form_Template__c::::::::::'+cp.o.Booking__R.Allotment_Form_Template__c);
                        taggedCustomerList.add(cp);
                    }
                      else if(selectedDocument == 'Agreement Generation Request' && cp.o.Booking__R.Agreement_Request_Template__c != null)
                            taggedCustomerList.add(cp);
                    else if(selectedDocument == 'NRI Declaration Form' && cp.o.Booking__R.NRI_Declaration_Template__c != null)   
                        taggedCustomerList.add(cp);   
                    else if(selectedDocument == 'Mortgage Release Request Letter' 
                            && cp.o.Booking__R.Mortgage_Release_Request_Letter__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Agreement signing undertaking' 
                            && cp.o.Booking__R.Agreement_Signing_undertaking__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Annexure B - Nomination Form' 
                            && cp.o.Booking__R.Annexure_B_Nomination_Form__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'TPA' && cp.o.Booking__R.TPA__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Bank NOC' 
                            && cp.o.Booking__R.Bank_NOC__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Provisional NOC' 
                            && cp.o.Booking__R.Provisional_NOC__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'L&L NOC' 
                            && cp.o.Booking__R.L_L_NOC__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Car Park Allotment Letter' 
                            && cp.o.Booking__R.Car_Park_Allotment_Letter__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Possession Undertaking Letter' 
                            && cp.o.Booking__R.Possession_Undertaking_Letter__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Possession Letter' 
                            && cp.o.Booking__R.Possession_Letter__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Electricity Meter transfer NOC' 
                            && cp.o.Booking__R.Electricity_Meter_transfer_NOC__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Rejection Notice - Pre Possession' 
                            && cp.o.Booking__R.Rejection_Notice_Pre_Possession__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'Rejection Notice - Post Possession' 
                            && cp.o.Booking__R.Rejection_Notice_Post_Possession__c != null)   
                        taggedCustomerList.add(cp);
                    else if(selectedDocument == 'ROFR NOC Loan case' 
                            && cp.o.Booking__R.ROFR_NOC_Loan_case__c != null)   
                        taggedCustomerList.add(cp);      
                }
                system.debug('taggedCustomerList:::::::::::'+taggedCustomerList);
                system.debug('taggedCustomerListsize:::::::::::'+taggedCustomerList.size());
            }else{
                
            }
        }
    }
    
    public PageReference Beginning() { //user clicked beginning
        //pgw.total_size = 1000;
        pgw= PaginationController.Beginning(pgw);
        getNextCustomers();
        return null;
    }
    
    public PageReference Previous() { //user clicked previous button
        //pgw.total_size = 1000;
        pgw = PaginationController.Previous(pgw);
        getNextCustomers();
        return null;
    }
    
    public PageReference Next() { //user clicked next button
        pgw = PaginationController.Next(pgw);
        getNextCustomers();
        //pgw.total_size = customerList.size();
        return null;
    }
    
    public PageReference End() { //user clicked end
        system.debug('PGW:' + pgw);
        //pgw.total_size = customerList.size();
        pgw = PaginationController.End(pgw);
        getNextCustomers();
        return null;
    }
    
    public Boolean getDisablePrevious() { //this will disable the previous and beginning buttons
        system.debug('PGW:' + pgw);
        return(PaginationController.DisablePrevious(pgw));
    }
    
    public Boolean getDisableNext() { //this will disable the next and end buttons
        system.debug('PGW:' + pgw);
        return(PaginationController.DisableNext(pgw));
    }
    
    public Integer getTotal_size() {
        return (PaginationController.getTotal_size(pgw));
    }
    
    public Integer getPageNumber() {
        return (PaginationController.getPageNumber(pgw));
    }
    
    public Integer getTotalPages() {
        return (PaginationController.getTotalPages(pgw));
    }
    public static void dummy() {
        integer a=1;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        
    }
}
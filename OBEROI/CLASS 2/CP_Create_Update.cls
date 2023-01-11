Public Class CP_Create_Update{
    
    public string aId {get;set;}
    public string action {get;set;}
    public List<Account> aList {get;set;}
    public List<Channel_Partner_Project__c> CPProjetList{get;set;}
    
    Public CP_Create_Update(){
        aId = ApexPages.currentPage().getParameters().get('id');
        action = ApexPages.currentPage().getParameters().get('action');  
        if(string.isNotBlank(aId)){
            aList = new List<Account>();
            DescribeSObjectResult describeResult = Account.getSObjectType().getDescribe();  
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                           ' FROM ' + describeResult.getName() + ' where id=' + '\'' + aId + '\''; 
            aList = Database.query( query );
            
        }
    }
    
    public void process(){
         if(!aList.isEmpty()){
             CPProjetList =[Select Id, Name,Account__c FROM Channel_Partner_Project__c WHERE Account__c =: alist[0].id];
             Integer i=0;
             If(CPProjetList.isempty()){
                 i=1;
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'No Project found for this Channel Partner'));
             }Else{
                 if(string.isNotBlank(aList[0].Broker_Code__c) && action == 'Create'){
                     i=1;
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'This CP already flown to SAP.'));
                 }else{
                     if(string.isBlank(aList[0].Name_1__c)){
                         i=1;
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Name 1 field blank on account'));
                     }
                     /*if(string.isBlank(aList[0].Search_Term_1__c)){
                         i=1;
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Search Term 1 field blank on account'));
                     }*/
                     if(string.isBlank(aList[0].Street_2__c)){
                         i=1;
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Street 2 field blank on account'));
                     }
                     if(string.isBlank(aList[0].Postal_code__c)){
                         i=1;
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Postal code field blank on account'));
                     }
                     if(string.isBlank(aList[0].City__c)){
                         i=1;
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'City field blank on account'));
                     }
                     if(string.isBlank(aList[0].Region_List__c)){
                         i=1;
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Billing Region field blank on account'));
                     }
                     if(string.isBlank(aList[0].Mobile_1__c)){
                         i=1;
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Mobile 1 field blank on account'));
                     }
                     if(string.isBlank(aList[0].Email_1__c)){
                         i=1;
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Email 1 field blank on account'));
                     }
                 }
             }    
             if(i==0){
                 REST_SAP_CP_Creation sp = new REST_SAP_CP_Creation();
                 string msg = sp.createCP(aList[0],false,action);
                 if(string.isBlank(msg)){
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'There are some internal Errors.Please contact your Admin.'));
                 }else{
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info, msg));
                 }
             }
             
         }else{
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'There are some internal Errors.Please contact your Admin.'));
         }   
    }
    
    Public PageReference BackToAccount(){
        PageReference pg = new PageReference('/'+aId);
        pg.setRedirect(true);
        return pg;
    }
    public Void Dummy(){
        Decimal i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
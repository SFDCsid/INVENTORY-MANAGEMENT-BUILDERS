global class luxuryCustomerCont {
    public Lead l{get;set;}
    Public String sob1 {get;set;}
    Public boolean sucessmsg {get;set;}
    Public String req {get;set;}
    Public String projs {get;set;}
    Public String budget1 {get;set;}
    public string salutation{get;set;}
    public string yesno{get;set;}
    public Integer currentcarpet{get;set;}
    public Integer carpetArea{get;set;}
    public Date prefreDate{get;set;}
    public list<Project__c>prolist{get;set;}
    public List<SelectOption> getSourcelist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Direct','Direct'));
        options.add(new SelectOption('Channel Partner','Channel Partner'));
        options.add(new SelectOption('Reference','Reference'));
        return options;
    }
    public List<SelectOption> getdynamiclist() {
        ID rtid = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
        List<Project__c> proList = [SELECT Id,Name,RecordTypeId FROM Project__c Where RecordTypeId=:rtid];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Please select project','Please select project'));
        for(Project__c pro:proList){
            
            options.add(new SelectOption(pro.id,pro.Name));    
            
        }
        return options;
    }     
    public List<SelectOption> getBudgetlist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('60 - 70 Cr','60 - 70 Cr'));
        //options.add(new SelectOption('50 Cr - 60 Cr','50 Cr - 60 Cr'));
        options.add(new SelectOption('70 - 80 Cr','70 - 80 Cr'));
        options.add(new SelectOption('80 - 90 Cr','80 - 90 Cr'));
        options.add(new SelectOption('> 100 Cr','> 100 Cr'));
        return options;
    }
    
    public List<SelectOption> getSalutationlist() {
        List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('None','None'));
         options.add(new SelectOption('Mr.','Mr.'));
         options.add(new SelectOption('Ms.','Ms.'));
         options.add(new SelectOption('Mrs.','Mrs.'));
       
        return options;
    }
    
    public List<SelectOption> getyesnolist() {
        List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Yes','Yes'));
         options.add(new SelectOption('No','No'));
         return options;
    }
    public List<SelectOption> getRequirementslist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('4 BR','4 BR'));
        options.add(new SelectOption('5 BR','5 BR'));
        options.add(new SelectOption('Combination','Combination'));
        //options.add(new SelectOption('5 BR + 5 BR','5 BR + 5 BR'));
        //options.add(new SelectOption('Duplex','Duplex'));
        //options.add(new SelectOption('5 BR + 4 BR','5 BR + 4 BR'));
        //options.add(new SelectOption('Penthouse','Penthouse'));
        return options;
    }
    public luxuryCustomerCont(ApexPages.StandardController controller){
        //currentcarpet = 0;
        l = new Lead();
        
    }
    public PageReference save(){
        ID rtid = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
        List<Project__c> proList = [SELECT Id,Name,RecordTypeId FROM Project__c Where RecordTypeId=:rtid];
        if(salutation == Null || salutation == 'None'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Salutation'));
        }/*else if(currentcarpet <= 0 && currentcarpet == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Carpet area (sq. ft.) of your current residence?'));
        }*/else if(req == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Your preferred configuration'));
        }else if(budget1 == Null){    
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Price range for the above residence'));
        }else if(sob1 == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select How did you hear about us?'));
        }else if(yesno == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Do you know any existing Three Sixty West residents/customers? If Yes, please mention their names'));
        }
        else{
            System.debug('prefretime:::::'+prefreDate);
            System.debug('currentcarpet:::::'+currentcarpet);
            System.debug('carpetArea:::::'+carpetArea);
            l.Preferred_Date__c = prefreDate;
            //l.Luxury_Current_Carpet_Area__c = currentcarpet;
            //l.Desired_residence_size_in_sq_ft__c = carpetArea;
            l.Luxury_Source_of_Walkin_Booking__c = sob1;
            l.Luxury_Bug__c = budget1;
            l.Luxury_Requirement__c = req;
            l.Project__c = prolist[0].Id;
            l.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
            l.Status = 'Open';
            l.Lead_Stage__c = 'Open';
            l.Salutation = salutation;
            insert l;
            PageReference newPageagn = new PageReference('/apex/luxuryCustomerform2?msg=');
            newPageagn.setRedirect(true); 
            //hasError = true;                   
            return newPageagn;
            
        }
        return null; 
    }
    public pageReference NewDataSheetButton() {
        PageReference newPageagn = new PageReference('/apex/luxuryCustomerform');
        newPageagn.setRedirect(true); 
        
        return newPageagn;
    } 
}
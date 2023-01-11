global class luxuryCustomerCont1 {
    public Lead l{get;set;}
    Public String sob1 {get;set;}
    Public boolean sucessmsg {get;set;}
    Public String req {get;set;}
    Public String projs {get;set;}
    Public String budget1 {get;set;}
    public string comadd {get;set;}
    public string Salutation{get;set;}
    public string yesno{get;set;}
    public string Property{get;set;}
    public string restype{get;set;}
    public string Industry{get;set;}
    public string indusifother{get;set;}
    public string Hours{get;set;}
    public string Minutes{get;set;}
    public string AMPM{get;set;}
    public Integer currentcarpet{get;set;}
    public Integer carpetArea{get;set;}
    public Date prefreDate{get;set;}
    public string lastname{get;set;}
    public list<Project__c>prolist{get;set;}
    public List<SelectOption> getSourcelist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Direct','Direct'));
        options.add(new SelectOption('Channel Partner','Channel Partner'));
        options.add(new SelectOption('Reference','Reference'));
        return options;
    }
    /*public List<SelectOption> getdynamiclist() {
        ID rtid = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
        List<Project__c> proList = [SELECT Id,Name,RecordTypeId FROM Project__c Where RecordTypeId=:rtid];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Please select project','Please select project'));
        for(Project__c pro:proList){
            
            options.add(new SelectOption(pro.id,pro.Name));    
            
        }
        return options;
    }   */  
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
         options.add(new SelectOption('Salutation','Salutation'));
         options.add(new SelectOption('Mr.','Mr.'));
         options.add(new SelectOption('Ms.','Ms.'));
         options.add(new SelectOption('Mrs.','Mrs.'));
       
        return options;
    }
    
     public List<SelectOption> getPropertylist() {
        List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Type of Residence you own','Type of Residence you own'));
         options.add(new SelectOption('Bungalow','Bungalow'));
         options.add(new SelectOption('Apartment','Apartment'));
         return options;
    }
    
    public List<SelectOption> getIndustrylist() {
        List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('Industry/Sector','Industry/Sector'));
         options.add(new SelectOption('Automobiles','Automobiles'));
         options.add(new SelectOption('Banking and Financial Services','Banking and Financial Services'));
        options.add(new SelectOption('Gem & Jewellery','Gem & Jewellery'));
        options.add(new SelectOption('Healthcare','Healthcare'));
        options.add(new SelectOption('Manufacturing','Manufacturing'));
        options.add(new SelectOption('Real Estate','Real Estate'));
        options.add(new SelectOption('FMCG/FMCD','FMCG/FMCD'));
        options.add(new SelectOption('Pharma','Pharma'));
        options.add(new SelectOption('Textiles','Textiles'));
        options.add(new SelectOption('Media and Entertainment','Media and Entertainment'));
        options.add(new SelectOption('Mining and Extraction','Mining and Extraction'));
        options.add(new SelectOption('Other','Other'));
         return options;
    }
    
    public List<SelectOption> getHourslist() {
        List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','Hour'));
         options.add(new SelectOption('01','01'));
         options.add(new SelectOption('02','02'));
         options.add(new SelectOption('03','03'));
         options.add(new SelectOption('04','04'));
         options.add(new SelectOption('05','05'));
         options.add(new SelectOption('06','06'));
         options.add(new SelectOption('07','07'));
         options.add(new SelectOption('08','08'));
         options.add(new SelectOption('09','09'));
         options.add(new SelectOption('10','10'));
         options.add(new SelectOption('11','11'));
         options.add(new SelectOption('12','12'));
         options.add(new SelectOption('13','13'));
         options.add(new SelectOption('14','14'));
         options.add(new SelectOption('15','15'));
         options.add(new SelectOption('16','16'));
         options.add(new SelectOption('17','17'));
         options.add(new SelectOption('18','18'));
         options.add(new SelectOption('19','19'));
         options.add(new SelectOption('20','20'));
         options.add(new SelectOption('21','21'));
         options.add(new SelectOption('22','22'));
         options.add(new SelectOption('23','23'));
         options.add(new SelectOption('24','24'));
         
         return options;
    }
    
    public List<SelectOption> getMinuteslist() {
        List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','Minute'));
         options.add(new SelectOption('00','00'));
         options.add(new SelectOption('01','01'));
         options.add(new SelectOption('02','02'));
         options.add(new SelectOption('03','03'));
         options.add(new SelectOption('04','04'));
         options.add(new SelectOption('05','05'));
         options.add(new SelectOption('06','06'));
         options.add(new SelectOption('07','07'));
         options.add(new SelectOption('08','08'));
         options.add(new SelectOption('09','09'));
         options.add(new SelectOption('10','10'));
         options.add(new SelectOption('11','11'));
         options.add(new SelectOption('12','12'));
         options.add(new SelectOption('13','13'));
         options.add(new SelectOption('14','14'));
         options.add(new SelectOption('15','15'));
         options.add(new SelectOption('16','16'));
         options.add(new SelectOption('17','17'));
         options.add(new SelectOption('18','18'));
         options.add(new SelectOption('19','19'));
         options.add(new SelectOption('20','20'));
         options.add(new SelectOption('21','21'));
         options.add(new SelectOption('22','22'));
         options.add(new SelectOption('23','23'));
         options.add(new SelectOption('24','24'));
         options.add(new SelectOption('25','25'));
         options.add(new SelectOption('26','26'));
         options.add(new SelectOption('27','27'));
         options.add(new SelectOption('28','28'));
         options.add(new SelectOption('29','29'));
         options.add(new SelectOption('30','30'));
         options.add(new SelectOption('31','31'));
         options.add(new SelectOption('32','32'));
         options.add(new SelectOption('33','33'));
        options.add(new SelectOption('34','34'));
        options.add(new SelectOption('35','35'));
        options.add(new SelectOption('36','36'));
        options.add(new SelectOption('37','37'));
        options.add(new SelectOption('38','38'));
        options.add(new SelectOption('39','39'));
        options.add(new SelectOption('40','40'));
        options.add(new SelectOption('41','41'));
        options.add(new SelectOption('42','42'));
        options.add(new SelectOption('43','43'));
        options.add(new SelectOption('44','44'));
        options.add(new SelectOption('45','45'));
        options.add(new SelectOption('46','46'));
        options.add(new SelectOption('47','47'));
        options.add(new SelectOption('48','48'));
        options.add(new SelectOption('49','49'));
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('51','51'));
        options.add(new SelectOption('52','52'));
        options.add(new SelectOption('53','53'));
        options.add(new SelectOption('54','54'));
        options.add(new SelectOption('55','55'));
        options.add(new SelectOption('56','56'));
        options.add(new SelectOption('57','57'));
        options.add(new SelectOption('58','58'));
        options.add(new SelectOption('59','59'));
         
         return options;
    }
    
    public List<SelectOption> getAMPMlist() {
        List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','AM/PM'));
         options.add(new SelectOption('AM','AM'));
         options.add(new SelectOption('PM','PM'));
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
    
     public List<SelectOption> getResidencelist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Owned','Owned'));
        options.add(new SelectOption('Rented','Rented'));
        return options;
    }
    public luxuryCustomerCont1(){
        //currentcarpet = 0;
        l = new Lead();
        
    }
    public PageReference save(){
        ID rtid = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
        List<Project__c> proList = [SELECT Id,Name,Site__c,RecordTypeId FROM Project__c Where RecordTypeId=:rtid];
        if(Salutation =='Salutation'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Salutation'));
        }else if(l.FirstName == Null || l.FirstName == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please mention First Name'));
        }else if(lastname == Null || lastname == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please mention last name'));
        }else if(l.Residence_Location__c == Null || l.Residence_Location__c == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Current residential address'));
        }else if(Property == 'Type of Residence you own'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Type of Residence you own'));
        }else if(restype == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select type of residence'));
        }else if(l.Company_Custom__c == null || l.Company_Custom__c == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please mention Company Name'));
        }else if(Industry == 'Industry/Sector'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Industry'));
        }else if(Industry == 'Other' && (indusifother == null || indusifother == '')){  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please mention industry name as you have selected other'));
        }else if(l.Designation__c == null || l.Designation__c == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please mention designation'));
        }/*else if(l.Website == null || l.Website == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please mention company website'));
        }*/else if(comadd == null || comadd == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please mention company address'));
        }else if(req == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Your preferred configuration'));
        }else if(budget1 == Null){    
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Price range for the above residence'));
        }/*else if(l.Desired_residence_size_in_sq_ft__c == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter residence size in sq ft'));
        }*/else if(l.Preferred_Date__c == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Preferred Date of Visit'));
        }else if(l.Preferred_Date__c < system.today()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Backdated date not allowed'));
        }else if(sob1 == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select How did you hear about us?'));
        }else if(sob1 == 'Channel Partner' && (l.Luxury_Partner_s_Name__c == null || l.Luxury_Partner_s_Name__c == '')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please mention channel partner name'));
        }else if(sob1 == 'Reference' && (l.Luxury_Reference_Name__c == null || l.Luxury_Reference_Name__c == '')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please mention referrer name'));
        }else if(yesno == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Any acquaintance with existing Three Sixty West Residents?'));
        }else if(yesno == 'Yes' && (l.Acquaintance__c == null || l.Acquaintance__c == '')){  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please mention name'));
        }
        /*else if(currentcarpet <= 0 && currentcarpet == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Carpet area (sq. ft.) of your current residence?'));
        }else if(budget1 == Null){    
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Price range for the above residence'));
        }else if(sob1 == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select How did you hear about us?'));
        }else if(yesno == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Do you know any existing Three Sixty West residents/customers? If Yes, please mention their names'));
        }*/
        else{
        try{
            System.debug('prefretime:::::'+prefreDate);
            System.debug('currentcarpet:::::'+currentcarpet);
            System.debug('carpetArea:::::'+carpetArea);
            //l.Luxury_Current_Carpet_Area__c = currentcarpet;
            //l.Desired_residence_size_in_sq_ft__c = carpetArea;
            //String[] strTimeSplit = Hours + ':'+Minutes;
            l.Preferred_Time__c = Hours+':'+Minutes;//Time.newInstance( Integer.valueOf(Hours),Integer.valueOf(Minutes),0,0);
            l.Luxury_Source_of_Walkin_Booking__c = sob1;
            l.Luxury_Bug__c = budget1;
            l.Luxury_Requirement__c = req;
            l.Residence_Type__c  = restype;
            l.Industry_if_other__c = indusifother;
            l.Project__c = prolist[0].Id;
            l.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
            l.Status = 'Open';
            l.Lead_Stage__c = 'Open';
            l.Site__c = prolist[0].Site__c;
            l.Salutation = Salutation;
            l.Type_of_property_you_own__c = Property;
            l.Industry = Industry;
            l.Company_Address__c = comadd;
            //l.Hours__c =  Hours;
            //l.Minutes__c = Minutes;
            //l.AM_Or_PM__c = AMPM;
            l.Existing_Resi__c = yesno;
            l.LastName = lastname;
            insert l;
            PageReference newPageagn = new PageReference('/apex/luxuryCustomerform2?msg=');
            newPageagn.setRedirect(true); 
            //hasError = true;                   
            return newPageagn;
            }catch (DmlException e){
                System.debug('An error has occured. Please contact your administrator. : ' + e.getMessage());
            }
            }
           
        return null; 
    }
    public pageReference NewDataSheetButton() {
        PageReference newPageagn = new PageReference('/apex/luxuryCustomerform');
        newPageagn.setRedirect(true); 
        
        return newPageagn;
    } 
}
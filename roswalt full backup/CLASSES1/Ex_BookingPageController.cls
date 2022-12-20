//-------------------------------------------//
//  Project: Roswaltrealty Developers
//  Created By: Exceller Consultancy
//  Created Date: 29-11-2022
//-------------------------------------------//
public class Ex_BookingPageController {
    public Id oppId {get;set;}
    public Id uId {get;set;}
    public Unit__c u {get;set;}
    public Opportunity op {get;set;}
    public Booking__c b {get;set;}
    public Applicant__c ap {get;set;}
    public Receipt__c rec {get;set;}
    public List<Date> lstDate {get;set;}
    public Date varDOB {get;set;}
    public Integer rowNum { get; set; }
    public Integer rowNum1{ get; set; }
    public List<Applicant__c> lstAp {get;set;}
    public List<Unit__c> ulist{ get; set; }
    public List<Receipt__c> recList {get;set;}
    public List<Opportunity> Oplist {get;set;}
    public List<Booking__c>  bklist {get;set;}
    public Boolean error {get;set;}
    public Boolean valError {get;set;}
    public String errorMsg {get;set;}
    public Decimal Days{get;set;}
    public String Age{get;set;}
     public integer agee{get;set;}
   
    
    public Ex_BookingPageController() {
        u = null;
        op = null;
        ap = new Applicant__c ();
        rec = new Receipt__c();
        b = new Booking__c();
        lstAp = new List<Applicant__c>();
        Applicant__c ap = new Applicant__c();
        lstAp.add(ap);
        recList = new List<Receipt__c>();
        recList.add(rec);
        bklist = new List<Booking__c>();
        bklist.add(b);    
        lstDate = new List<Date> ();
        ulist = new List<Unit__c>();
        Oplist = new List<Opportunity>();
        error = false;
        valError = false;
        Days = 0;
        errorMsg = '';

        if(ApexPages.currentPage().getParameters().containsKey('uId')) {
            uId = (Id)ApexPages.currentPage().getParameters().get('uId'); 
        }
        system.debug('UnitId' +uId);
      
        if(ApexPages.currentPage().getParameters().containsKey('oppId')) {
            oppId = (Id)ApexPages.currentPage().getParameters().get('oppId'); 
        }
        system.debug('opporId:' +oppId);
        
        if(uId != null) {
            u = [Select Id, Name, Opportunity__c,Unit_Status__c,Project__r.Name,Tower__r.Name,Saleable_Area__c,
                 Stamp_Duty__c,GST__c,Registration_Amount__c,Configuration__c from Unit__c where Id =: uId];
            system.debug('u: '+u);
        }
        
        if(oppId != null) {
            system.debug('OppId1:'+oppId);
            Oplist = [Select Id,Name,Master_Source__c,Lead_Source__c,Lead_Sub_source__c,Lead_Sub_source_Details__c,
                      Other_Source_Details__c,Presales_Manager__c,Sales_Manager__c,Sourcing_Manager__c,
                      Opportunity_Id__c,Channel_Partner__c,Email__c,Mobile__c,Employee_Referrer_Name__c,Referrer_Name__c from Opportunity where Id =: oppId];
            system.debug('OppId:'+Oplist);
              
            if(!Oplist.isEmpty() && Oplist != null) {
                b.Master_Source__c = Oplist[0].Master_Source__c;
                b.Lead_Source__c = Oplist[0].Lead_Source__c;
                b.Lead_Sub_source__c = Oplist[0].Lead_Sub_source__c;
                b.Lead_Sub_source_Details__c = Oplist[0].Lead_Sub_source_Details__c;
                b.CIF_No__c = Oplist[0].Opportunity_Id__c;
                b.Presales_Manager__c = Oplist[0].Presales_Manager__c;
                b.Sales_Manager__c = Oplist[0].Sales_Manager__c;
              //  b.Closing_Manager__c = Oplist[0].Closing_Manager__c;
                b.Sourcing_Manager__c = Oplist[0].Sourcing_Manager__c;
                
                if(Oplist[0].Lead_Source__c == 'Other'){
                    b.Other_Source_Details__c = Oplist[0].Other_Source_Details__c;
                }
                if(Oplist[0].Lead_Source__c == 'Channel Partner'){
                    b.Channel_Partner__c = Oplist[0].Channel_Partner__c;
                }
                if(Oplist[0].Lead_Source__c == 'Employees'){
                    b.Employee_Referrer_Name__c = Oplist[0].Employee_Referrer_Name__c;
                }  
                if(Oplist[0].Lead_Source__c == 'Customers'){
                    b.Referrer_Name__c = Oplist[0].Referrer_Name__c;
                }
                
                if(Oplist[0].Name != '' && Oplist[0].Name != null){
                   ap.First_Name__c = Oplist[0].Name;
                }
                
                   if(Oplist[0].Email__c != '' && Oplist[0].Email__c != null){
                   ap.Email__c = Oplist[0].Email__c;
                }
                
                if(Oplist[0].Mobile__c != '' && Oplist[0].Mobile__c != null){
                   ap.Mobile_Number__c = Oplist[0].Mobile__c;
                }
                
                
              
            }
        }   
    }
    
    public void calculate() {
        if(u.Saleable_Area__c  != null) {
            b.Agreement_Value__c = b.Rate__c * u.Saleable_Area__c;
        }
        system.debug('Agmv:' + b.Agreement_Value__c);
        
        if(u.Stamp_Duty__c != null) {
            b.Stamp_Duty_Amount__c = (b.Agreement_Value__c /100)* Integer.valueOf(u.Stamp_Duty__c);  
        }
        if(u.GST__c != null) {
            b.GST_Amount__c = (b.Agreement_Value__c /100)* Integer.valueOf(u.GST__c);
        }
        if(u.Registration_Amount__c != null) {
            b.Total_Tax__c =   b.Stamp_Duty_Amount__c + b.GST_Amount__c + u.Registration_Amount__c;
        }
        if(b.Possession_Charges_GST__c != null && b.Possession_Charges__c != null) {
            b.Possession_Charges_GST_Amount__c = (b.Possession_Charges__c /100)* Integer.valueOf(b.Possession_Charges_GST__c);  
        }
        if(b.Possession_Charges__c != null){
            b.Other_Charges_Total__c = b.Possession_Charges__c + b.Possession_Charges_GST_Amount__c;
        }
        if(b.Other_Charges_Total__c != null){
            b.Grand_Total__c = b.Agreement_Value__c + b.Total_Tax__c + b.Other_Charges_Total__c;
        } 
    }
    
    public void addApp() {
        Applicant__c ap = new Applicant__c();
        lstAp.add(ap);
        lstDate.Add(varDOB);
    }
    
    public void rmvApp() {
        rowNum1 = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex1'));
        lstAp.remove(rowNum1 - 1);
    }
    
    public void addRows(){
        Receipt__c rec = new Receipt__c();
        recList.add(rec);
        system.debug('receiptlist :: '+recList);
        system.debug('receiptlist size::'+recList.size());
    }
    
    public void rmvRows(){
        rowNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        system.debug('row number:: ' + rowNum);
        system.debug('Row Delete :: '+ recList[rowNum]);
        recList.remove(rowNum);
    }
    
    public Pagereference save(){
        Id bId;
        if(!recList.isEmpty()) {
            Integer tcount = 0;
            for(Receipt__c rc : recList) {
                b.Amount__c = rc.Amount__c;
                b.Bank_Name__c = rc.Bank_Name__c;
                b.Receipt_Dated__c = rc.Dated__c;
                b.Reference_Number__c = rc.Reference_Number__c;
                b.Source_of_Fund__c = rc.Source_of_Fund__c;
                b.Preferred_Bank_FI__c = rc.Preferred_Bank_FI__c;
                b.Payment_Method__c = rc.Payment_Method__c;
                b.Branch_Name__c = rc.Branch_Name__c;
            }
        }
        
        if(!lstAp.isEmpty() && lstAp != null) {
            for(Applicant__c apl : lstAp) {
                if (apl.Applicant_Number__c == 'Primary Applicant') {
                    b.Primary_Applicant_Title__c = apl.Applicant_Title__c;
                    b.Primary_Applicant_Name__c = apl.First_Name__c +''+ apl.Last_Name__c;
                    b.Primary_Applicant_Mobile__c = apl.Mobile_Number__c;
                    b.Primary_Applicant_Email__c = apl.Email__c;
                }
            }
        }
        
        
        if(!error) {
            if(!lstAp.isEmpty()) {
                error = false;
                system.debug('DOB::' + varDOB);
                system.debug('DOB List::' + lstDate);
                lstDate.add(varDOB);
                b.Project__c = u.Project__c;
                b.Tower__c = u.tower__c;
                b.Unit__c = u.Id;
                b.Opportunity__c = oppId;
                system.debug('lstAp[0].Id:::::::::::::::::' + lstAp);
            }
            insert b;
        }
        
        if(!recList.isEmpty()) {
            for(Receipt__c rc : recList) {
                rc.Booking__c = b.id;
            }
            insert recList;  
        }
        
        u.Unit_Status__c = 'Booked';
        u.Booking__c = b.id;
        u.Opportunity__c = oppId;
        update u;
        
        Oplist[0].Opportunity_Stage__c = 'Booking Done';
        Oplist[0].Unit__c = u.id;
        Oplist[0].Booking__c = b.id;
        update Oplist;
        
        
        Integer i = 0;
        List<Applicant__c> insApp = new List<Applicant__c>();
        for(Applicant__c ap1: insApp) {
            ap1.Booking__c = b.Id;
         /*   if(lstAP.size() == lstDate.size())
                ap.DOB__c = lstDate[i];
            i++; */
            insApp.add(ap1);
            system.debug(insApp);
            if(ap1.DOB__c != Null) 
            {
                date dob = ap1.DOB__c;
        		Integer age = Integer.valueOf(dob.daysBetween(Date.Today()))/365;    
          		system.debug('Age::::' + age);
            }
                /*
               // Days = ap1.DOB__c.daysBetween(Date.Today()); 
                //Age = String.valueOf(Days/365);
                
               Integer days = ap1.DOB__c.daysBetween(Date.Today());
               agee = Integer.valueOf(days/365);
               //String Age = String.valueOf(Days.monthsBetween(dtOther) / 12) + ' Year(s) ' + String.valueOf(Math.mod(dtToday.monthsBetween(dtOther), 12)) + ' Month(s)';
                system.debug('Age'+Age);
                system.debug('Days'+Days); */
           
        }
        insert insApp;
    
        PageReference pg = new PageReference('/'+b.Id);
        pg.setRedirect(true);
        return pg;
    } 
    
    public PageReference validateInput() {
        valError = False;
        errorMsg = '';
        
        if(b.Booking_Date__c == null) {
            valError = True;
            errorMsg = 'Please fill Booking Date.'; 
        }
     /*  if(b.CIF_Number__c == null) {
            valError = True;
            errorMsg = 'Please fill CIF Number.'; 
        } */
        if(b.Category__c == null || b.Category__c == '') {
            valError = True;
            errorMsg = 'Please fill Category.'; 
        }
        if(b.Car_Park__c == null || b.Car_Park__c == '') {
            valError = True;
            errorMsg = 'Please fill Car Park.'; 
        }
        if(b.Rate__c == null) {
            valError = True;
            errorMsg = 'Please fill Rate.'; 
        }
        if(b.Possession_Charges__c == null) {
            valError = True;
            errorMsg = 'Please fill Possession Charges.'; 
        }
        if(b.Possession_Charges_GST__c == null || b.Possession_Charges_GST__c == '') {
            valError = True;
            errorMsg = 'Please fill Possession Charges GST.'; 
        }
        if(rec.Payment_Method__c == null || rec.Payment_Method__c == '') {
            valError = True;
            errorMsg = 'Please fill Payment Method.'; 
        }
        if(rec.Dated__c == null ) {
            valError = True;
            errorMsg = 'Please fill Date.'; 
        }
        if(rec.Amount__c == null) {
            valError = True;
            errorMsg = 'Please fill Amount.'; 
        }
        if(rec.Reference_Number__c == null || rec.Reference_Number__c == '') {
            valError = True;
            errorMsg = 'Please fill Reference Number.'; 
        }
        if(rec.Bank_Name__c == null || rec.Bank_Name__c == '' ) {
            valError = True;
            errorMsg = 'Please fill Bank Name.'; 
        }
        if(rec.Branch_Name__c == null || rec.Branch_Name__c == '') {
            valError = True;
            errorMsg = 'Please fill Branch Name.'; 
        }
        if(rec.Source_of_Fund__c == null || rec.Source_of_Fund__c == '' ) {
            valError = True;
            errorMsg = 'Please fill Source of fund.'; 
        }
        if(b.Special_Note__c == null || b.Special_Note__c == '' ) {
            valError = True;
            errorMsg = 'Please fill Special Note.'; 
        }
        if(b.Place__c == null || b.Place__c == '') {
            valError = True;
            errorMsg = 'Please fill Place.'; 
        }
        
        if(!lstAp.isEmpty() && lstAp != null) {
            for(Integer i = 1; i <= lstAp.size(); i++) {
                if(String.isBlank(lstAp[i-1].Residential_Status__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Residential Status.'; 
                } 
                if(String.isBlank(lstAp[i-1].Residential_Status__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Residential Status.'; 
                } 
                if(String.isBlank(lstAp[i-1].Email__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Email.'; 
                }
                if(String.isBlank(lstAp[i-1].Mobile_Number__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Mobile No.'; 
                }
                if(String.isBlank(lstAp[i-1].Marital_Status__c )) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Marital Status.'; 
                }
                if(String.isBlank(lstAp[i-1].Aadhar_Number__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Aadhar Number.'; 
                } else {
                    if(lstAp[i-1].Aadhar_Number__c.length() != 12) {
                        valError = True;
                        errorMsg = 'Please Provide Valid Aadhar Number of Applicant '+i+'.'; 
                    }
                }
                if(String.isBlank(lstAp[i-1].PAN_Number__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' PAN Number.'; 
                }
                if(lstAp[i-1].DOB__c == null) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Date of Birth.'; 
                }
                if(String.isBlank(lstAp[i-1].Relation_Last_Name__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Relation Last Name.'; 
                }
                if(String.isBlank(lstAp[i-1].Relation_First_Name__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Relation First Name.'; 
                }
                if(String.isBlank(lstAp[i-1].Relation__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Relation.'; 
                }
                if(String.isBlank(lstAp[i-1].Applicant_Number__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Number.'; 
                }
                if(String.isBlank(lstAp[i-1].First_Name__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' First Name.'; 
                }
                if(String.isBlank(lstAp[i-1].Last_Name__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Last Name.'; 
                }
                if(String.isBlank(lstAp[i-1].Applicant_Title__c)) {
                    valError = True;
                    errorMsg = 'Please fill Applicant '+i+' Salutation.'; 
                }
            }
        }
        return null;
    }
}
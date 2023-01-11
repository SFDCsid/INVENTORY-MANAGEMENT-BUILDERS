public with sharing class Demand_Reminder_Cont{
    public string BookingId {
        get;
        set{
            BookingId = value;
            if(BookingId != null)
                createBookingList();
        }
    }
    public Booking__c bookingObj{get;set;}
    public String applicant1{get;set;}
    public String applicant2{get;set;}
    public String applicant3{get;set;}
    public String applicant4{get;set;}
    public String applicant5{get;set;}
    public String multiTower{get;set;}    
    public String ApplicantAddress{get;set;}
    public Boolean add1{get;set;}
    public Boolean add2{get;set;}
    public Boolean add3{get;set;}
    public Boolean add4{get;set;}
    public Boolean add5{get;set;}
    public String fn{get;set;}
    
    public List<SAP_Demands_and_Debits__c> SDList{get;set;}
    public date soao{get;set;}  
    
    public void createBookingList(){
        bookingObj = [Select Id,Booking_Date__c,Property__r.RM_Name__c,Project__r.Is_Multi_Tower_Project__c,
                      RM_User__r.MobilePhone,RM_User__r.Email,Allotment_Date__c,Registration_Date__c, 
                      Acceptance_Form_Generated_date__c,Is_GST_applicable__c,Project__r.LetterHead_Image_Url__c,
                      Project__r.Subsidiary_Company_Address__c,Project__r.Name,Site__r.Name,Tower_Name__c,
                      Premises_no__c,Floor__r.Floor_Number__c,Agreement_Date__c,C_o_Name_Billing_Address__c,
                      Billing_Street__c,Billing_Str_Suppl2__c,Billing_Str_Suppl3__c,Billing_Location__c,
                      Billing_Post_Code__c,Billing_City__c,Billing_Country__c,Billing_Region__c,Property__c,
                      Project__r.CIN_No__c,Property__r.Floor_No__c from Booking__c  WHERE Id =: BookingId];
        
        If(bookingObj != null){
            List<Applicant__c> apList = [Select Id,Name,Applicant_Number__c,Salutation__c
                                         FROM Applicant__c WHERE Booking__c =: bookingObj.Id];
            if(apList != null && apList.size()>0){
                for(Applicant__c a: apList){
                    if(a.Applicant_Number__c == 'Primary Applicant'){
                        applicant1 = a.Salutation__c+' '+a.Name;
                    }
                    if(a.Applicant_Number__c == 'Second Applicant'){
                        applicant2 = a.Salutation__c+' '+a.Name;
                    }
                    if(a.Applicant_Number__c == 'Third Applicant'){
                        applicant3 = a.Salutation__c+' '+a.Name;
                    }
                    if(a.Applicant_Number__c == 'Fourth Applicant'){
                        applicant4 = a.Salutation__c+' '+a.Name;
                    }
                    if(a.Applicant_Number__c == 'Fifth Applicant'){
                        applicant5 = a.Salutation__c+' '+a.Name;
                    }
                }
            }
            
            SDList = [Select Id,Name,Due_Date__c,Billing_Stage__c,Invoice_Date__c from SAP_Demands_and_Debits__c
                      where Booking__c =: bookingObj.Id AND Total_Amount__c > 0 AND Is_canceled__c != true 
                      Order by CreatedDate DESC];
            
            if(bookingObj.C_o_Name_Billing_Address__c != null || bookingObj.Billing_Street__c != null){
                if(bookingObj.C_o_Name_Billing_Address__c != null){ 
                    bookingObj.C_o_Name_Billing_Address__c = bookingObj.C_o_Name_Billing_Address__c + ',';
                }
                if(bookingObj.Billing_Street__c != null){ 
                    bookingObj.Billing_Street__c = bookingObj.Billing_Street__c + ',';
                }
                add1 = true;
            }
            if(bookingObj.Billing_Str_Suppl2__c != null || bookingObj.Billing_Str_Suppl3__c != null){
                if(bookingObj.Billing_Str_Suppl2__c != null){ 
                    bookingObj.Billing_Str_Suppl2__c = bookingObj.Billing_Str_Suppl2__c + ',';
                }
                if(bookingObj.Billing_Str_Suppl3__c != null){ 
                    bookingObj.Billing_Str_Suppl3__c = bookingObj.Billing_Str_Suppl3__c + ',';
                }
                add2 = true;
            }
            if(bookingObj.Billing_Location__c != null || bookingObj.Billing_City__c != null){
                if(bookingObj.Billing_Location__c != null){ 
                    bookingObj.Billing_Location__c = bookingObj.Billing_Location__c + ',';
                }
                if(bookingObj.Billing_City__c != null){ 
                    bookingObj.Billing_City__c = bookingObj.Billing_City__c + ',';
                }
                add3 = true;
            }
            if(bookingObj.Billing_Post_Code__c != null || bookingObj.Billing_Region__c != null){
                if(bookingObj.Billing_Post_Code__c != null){ 
                    bookingObj.Billing_Post_Code__c = bookingObj.Billing_Post_Code__c + ',';
                }
                if(bookingObj.Billing_Region__c != null){ 
                    bookingObj.Billing_Region__c = bookingObj.Billing_Region__c + ',';
                }
                add4 = true;
            }
            if(bookingObj.Billing_Country__c != null){
                add5 = true;
            }
            
            soao = system.today();
        }
        
        if(bookingObj.Property__r.Floor_No__c != null){
            Integer flno = Integer.valueOf(bookingObj.Property__r.Floor_No__c);
            fn = getOrdinal(flno);
        }
    }
    
    public string getOrdinal(integer i){
        string num = string.valueof(i);
        string suffix = 'th';
        string ordinal = '';
        i = integer.valueof(num.right(2));
        if(10 < i && i < 14) {
            ordinal =  num + suffix;
        }else{
            string onesDigit = num.right(1);
            if(onesDigit == '1'){
                suffix = 'st';
            }else if(onesDigit == '2'){
                suffix = 'nd';
            }else if(onesDigit == '3'){
                suffix = 'rd';
            }
            ordinal = num+suffix;
        }
        return ordinal;
    }
}
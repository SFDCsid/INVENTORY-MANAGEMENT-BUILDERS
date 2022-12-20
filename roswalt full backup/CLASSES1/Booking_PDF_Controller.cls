public class Booking_PDF_Controller {
    Public String bId {get;set;}
    public List<Booking__c> blist {get;set;}
    public List<Applicant__c> applist {get;set;}
    public List<Applicant__c> primaryApp {get;set;}
    public List<Applicant__c> OtherApp {get;set;}
    public List<Receipt__c> rlist {get;set;}
    public String dayOfWeek {get;set;}
    public Booking_PDF_Controller(){
         bId = null;
         blist = new List<Booking__c>();
         applist = new List<Applicant__c>();
         primaryApp = new List<Applicant__c>();
         OtherApp = new List<Applicant__c>();
         rlist = new List<Receipt__c>();
         DateTime bookingDate;
         dayOfWeek ='';
         bId = ApexPages.currentPage().getParameters().get('bId');   
        
         blist = [SELECT Id,Name,Booking_Date__c,Unit__r.Name,Project__c,Project__r.Name,Tower__c,Unit__r.Configuration__c,Unit__r.Balcony_Area_Sq_Ft__c,Car_Park__c,Unit__c,Unit__r.Registration_Amount__c,
                  Opportunity__r.Sourcing_Manager__r.Name,Opportunity__r.Sales_Manager__r.Name,Opportunity__c,CIF_No__c,Unit__r.Stamp_Duty__c,
                  Unit__r.Total_Carpet_Area_Sq_Ft__c,Category__c,Master_Source__c,Lead_Source__c,Lead_Sub_source__c,Lead_Sub_source_Details__c,Channel_Partner__c,Other_Source_Details__c,
                  Referrer_Name__c,Employee_Referrer_Name__c,Rate__c,GST_Amount__c,Possession_Charges__c,Possession_Charges_GST_Amount__c,
                  Other_Charges_Total__c,Total_Tax__c,Agreement_Value__c,Possession_Charges_GST__c,Stamp_Duty_Amount__c,Grand_Total__c,
                  Payment_Method__c,Bank_Name__c,Receipt_Dated__c,Source_of_Fund__c,Amount__c,Branch_Name__c,Reference_Number__c,Preferred_Bank_FI__c,
                  Primary_Applicant_Title__c,Primary_Applicant_Name__c,Primary_Applicant_Email__c,Primary_Applicant_Mobile__c,Special_Note__c,Place__c
                  FROM Booking__c WHERE Id=:bId]; 
        
         applist = [SELECT Id,Name,Booking__c,Applicant_Title__c,Applicant_Number__c,First_Name__c,Last_Name__c,Mobile_Number__c,Email__c,
                   Relation__c,Relation_First_Name__c,Relation_Last_Name__c,DOB__c,Age__c,Marital_Status__c,Residential_Status__c,Wedding_Anniversary__c,
                   Name_of_Power_of_Attorney__c,Existing_Customer__c,Existing_Property_Name__c,Aadhar_Number__c,PAN_Number__c,Permanent_Street_Address__c,
                   Permanent_State__c,Aadhar_Card_Photo__c,Pan_Card_Photo__c,Permanent_Postal_Code__c,Permanent_City__c,Permanent_Country__c,Corresponding_Street_Address__c,
                   Corresponding_State__c,Corresponding_Postal_Code__c,Corresponding_City__c,Corresponding_Country__c,Name_of_Organization_Business__c,
                   Organization_City__c,Organization_State__c,Organization_Country__c,Organization_Postal_Code__c,Organization_Street_Address__c
                   FROM Applicant__c WHERE Booking__c=:blist[0].id];
        
        bookingDate = blist[0].Booking_Date__c;
        dayOfWeek = bookingDate.format('E');
        
        for(Applicant__c a:applist){
            if(a.Applicant_Number__c=='Primary Applicant'){
             primaryApp.add(a);   
            }else{
             OtherApp.add(a);    
            }
        }
        rlist = [SELECT Id,Name,Booking__c,Amount__c,Payment_Method__c,Bank_Name__c,Source_of_Fund__c,Preferred_Bank_FI__c,
                 Dated__c,Reference_Number__c,Branch_Name__c,Drawn_In_Favour_of__c,receipt_photo__c
                 FROM Receipt__c WHERE Booking__c=:blist[0].id];
    }
}
global class EOIPDFController {
    public String eoId {get;set;}
    public EOI__c eo {get;set;}
    
    global EOIPDFController(){
        eoId = apexpages.currentpage().getparameters().get('eoId');
        if(eoId != NULL && eoId != ''){
            eo = [Select Id,Name,Salutation_1__c,Salutation_2__c,Salutation_3__c,Salutation_4__c,
                  Salutation_5__c,Applicant_Name_1__c,Applicant_Name_2__c,Applicant_Name_3__c,Street_1__c,
                  Applicant_Name_4__c,Applicant_Name_5__c,Nationality__c,Resident_Status__c,House_No__c,
                  Street_2__c,Street_3__c,City__c,Pincode1__c,Occupation__c,Other_Occupation__c,
                  Company_Name__c,Designation__c,Company_Address__c,Company_City__c,Company_Pincode__c,
                  Country_Code_Residense__c,Telephone_No_Residence__c,Country_Code_Office__c,
                  Telephone_No_Office__c,Country_Code_Mobile_1__c,Mobile_No_1__c,Country_Code_Mobile_2__c,
                  Mobile_No_2__c,Email__c,Contact_Person_Same_as_applicant_1__c,Contact_Person_Name__c,
                  Contact_Person_Relation_Designation__c,Country_Code_Contact_Person_Telephone__c,UniqueEOInumber__c,
                  Contact_Person_Telephone__c,Country_Code_Contact_Person_Mobile__c,Contact_Person_Email__c,
                  Customer_Category__c,How_did_you_hear_about_us__c,Budget__c,Requirements__c,Carpet_Area__c,
                  Source_of_EOI__c,Property_Consultant_s_Firm_Name__c,Property_Consultant_s_Name__c,
                  RERA_Registration_No__c,Country_Code_Property_Consultant_Mobile__c,Property_Consultant_s_Telephone_Mobile__c,
                  Country_Code_Property_Consult_Telephone__c,Property_Consultant_s_Telephone_Office__c,
                  Property_Consultant_s_Email__c,Name_of_Existing_Customer_Referral__c,Project_Name_of_Existing_Customer__c,
                  Tower_Name_of_Existing_Customer__c,Flat_No_of_Existing_Customer__c,CreatedDate,Project__r.Name,
                  Contact_Person_Mobile__c From EOI__c Where Id =: eoId Limit 1];
            system.debug('eIdinsideif'+eo.Id);
        }
        system.debug('eIdoutsideif'+eoId);
    }
}
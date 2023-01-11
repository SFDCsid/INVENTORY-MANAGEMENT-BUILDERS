public class DataSheetPDF {
    
    public Opportunity oppObj{get;set;}
    public id signatureid {get;set;}
    public id CPsignatureid {get;set;}
    
    public DataSheetPDF(ApexPages.StandardController controller) {
        Id opId = apexpages.currentpage().getparameters().get('Id');
        String BaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        //system.debug('@@@@@@@@@@@@@@@'+opId);
        List<Opportunity> oppList = new List<Opportunity>();
        oppObj = [SELECT Id, IsDeleted,signature__c, AccountId, RecordTypeId, Name, Occupation_In_Case_Of_Other__c, Related_Lead__r.Phone,Requirement__c,
                  Country_Name_of_Other_Mobile__c, Country_Name_of_Mobile_Code__c, Country_Name_for_PC_Mobile__c,Purpose_of_Buying__c,
                  Locality__c, PCID__c, House_No__c, Related_Lead__c,Related_Lead__r.Company_Custom__c, How_Soon_Do_You_Want_To_Buy__c,
                  Partner_s_Firm_Name__c, Partner_s_Name__c, Partner_s_Office_Address__c, Partner_Email__c, Country_Code__c,Other_Sources_Where_You_Heard_About_Us__c,
                  Partner_Mobile__c, Partner_Mobile_Country_Code__c, Carpet_Area__c, Related_Lead__r.Office_No__c,
                  How_did_You_Hear_About_Us__c, Decision_Making_Factors__c, Possession_Timeliness__c, Country_Code_for_Other_Mobile_Number__c,
                  Nationality__c, Str_Suppl1__c, Resident_Status__c, Str_Suppl2__c, Str_Suppl3__c, City__c, Project__r.Name,
                  Post_Code1__c, Country_Picklist__c, Occupation__c, Designation__c, Company_Address__c, Office_No__c, 
                  Other_Mobile_Number__c, Preferred_Mode_of_Communication__c, Address_for_Correspondence__c, Email__c, 
                  Description__c, Description_Other_Comments__c, Category__c, Date_of_Site_Visit__c, Mobile__c, 
                  Other_Mobile__c, Data_Sheet_Submitted_Date__c,Enquiry_Type__c, Budget__c,Location_Rating__c,
                  Data_Sheet_Submitted__c, Site__c, Contact_Person_Email__c, Contact_Person_Mobile_2__c, Related_Lead__r.Industry,
                  Contact_Person_Name__c, Contact_Person_Relation_Designation__c, Contact_Person_Mobile_1__c, 
                  Broker_Account__c,Broker_Account__r.Name,Broker_Account__r.Name_1__c,Broker_Account__r.Mobile_1__c,Broker_Account__r.Full_CP_Address__c,
                  Opportunity_Number__c, Sub_Category__c, Contact_Person_is_Same_as_Applicant__c,Broker_Account__r.Email_1__c,
                  (SELECT id, NAme,Person_Account__c,Person_Account__r.Name, Opportunity__r.name FROM Co_Owner__r)  FROM Opportunity where id= :opId];
        
        list<Attachment> sign = [select id,name,body,ParentId 
                                 from Attachment 
                                 where ParentId=:opId and 
                                 (name='Signature' OR name='CP_Signature')
                                ];
        
        if(sign.size()>0){
            for(Attachment att: sign){
                if(att.name == 'Signature'){
                    signatureid=att.id;
                }else if(att.name == 'CP_Signature'){
                    CPsignatureid=att.id;
                }
            }
            
        }
        
    }
    
    
}
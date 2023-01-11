public with sharing class AcceptanceFormCont{
    Public Id oppId {get;set;}
    Public String docType {get;set;}
    Public String docName {get;set;}
    public string SuccessMsg {get; set;}
    Public List<Opportunity> oppList {get;set;}
    public AcceptanceFormCont(){
        oppId = Apexpages.currentPage().getParameters().get('oppId');
        docType = 'Acceptance Form';
        oppList = [select id,name,Property__c,Property__r.Tower__c,Project__c,StageName,Booking__c,
                   Booking__r.Booking_Date__c,booking__r.Acceptance_Form_Template__c,booking__r.Agreement_Form_Template__c,
                   booking__r.Allotment_Form_Template__c,Booking__r.NRI_Declaration_Template__c,
                   booking__r.Mortgage_Release_Request_Letter__c,booking__r.Agreement_Signing_undertaking__c,
                   booking__r.Annexure_B_Nomination_Form__c,booking__r.TPA__c,booking__r.Bank_NOC__c,
                   booking__r.Provisional_NOC__c,booking__r.L_L_NOC__c,booking__r.Car_Park_Allotment_Letter__c,
                   booking__r.Possession_Undertaking_Letter__c,booking__r.Possession_Letter__c,booking__r.Electricity_Meter_transfer_NOC__c,
                   booking__r.Rejection_Notice_Pre_Possession__c,booking__r.Rejection_Notice_Post_Possession__c,booking__r.ROFR_NOC_Loan_case__c,
                   Booking__r.Project__r.id,
                   Booking__r.Project__r.Project_Template_Label__c
                   from opportunity where Id =: oppId and Property__c != null and Booking__C != null and booking__r.Acceptance_Form_Template__c != null];
         docName = oppList[0].booking__r.Acceptance_Form_Template__c;          
    }
    public PageReference BackToPreview(){
        pageReference P = new pageReference('/apex/View_Document?oppId='+ oppId + '&docType='+docType + '&docName='+oppList[0].booking__r.Acceptance_Form_Template__c);
        return P;
    }
    public void generateDoc(){
        Map<string,string> resultMap = new Map<string,string>();
        try{
            if(docName != Null){
                resultMap = DocumentGenerationServices.generateDocumentMethod(docType,oppList[0]);
                SuccessMsg = 'Document Generated Successfully';
            }else{
                SuccessMsg = 'Template Name blank at booking level.';
            }
        }catch(Exception e){
            SuccessMsg = e.getMessage();
        }
        
    }
    public PageReference BackToBooking(){
        pageReference P = new pageReference('/'+ oppList[0].Booking__c);
        return P;
    }
}
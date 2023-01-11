public class QRCodePageController {

    public String rdId{get;set;}
    public List <Related_Document_History__c> rdList{get;set;}
    public List <Applicant__c> applist{get;set;}
    public QRCodePageController(){
        rdId = '';
        rdList = new List < Related_Document_History__c>();
        applist = new List <Applicant__c>();
           if(Apexpages.currentPage().getParameters().containsKey('id') && Apexpages.currentPage().getParameters().get('id') != null){
            rdId = Apexpages.currentPage().getParameters().get('id');
           system.debug('rdId::'+rdId);   
        }
          if(String.isNotBlank(rdId)){
             rdList = [Select Id, Name , Customer_Email_Id__c, Document_Generated_By__c, Document_Generated_Date_Time__c, 
                       Document_Name__c,Document_Approved__c, Document_Send_To_Customer_By__c, Opportunity__c,Opportunity__r.Name,
                       Project_Template_Label__c,Template_Label__c,Document_Number_Series__c,Ref_No_formula__c,QR_Code__c,Booking__c, 
                       Booking__r.Name,Booking__r.Status__c,Booking__r.Site__r.Name,Booking__r.Project__c,Booking__r.Project__r.Name,Booking__r.Tower__r.Name,
                       Booking__r.Property_Type_Name__c,Booking__r.Unitcode__c                       
                       from Related_Document_History__c where Id =:rdId];
             system.debug('rdList::'+rdList);
              
             if(!rdList.isEmpty()){
                 system.debug('Document Approved::'+rdList[0].Document_Approved__c);
                applist = [Select id, Name,Applicant_Number__c,Type_Of_Applicant__c,Mobile_Number__c,Email_Address__c,State__c,Nationality__c,Customer_Code__c
                           
                           from Applicant__c where Booking__c =:rdList[0].Booking__c And Applicant_Number__c='Primary Applicant'];
                 
                 
             }
        }
    }
}
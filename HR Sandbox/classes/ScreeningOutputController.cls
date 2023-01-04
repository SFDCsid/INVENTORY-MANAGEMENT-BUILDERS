public class ScreeningOutputController {
    
    @AuraEnabled
    public static screeningWrapper getScreeningInfo(Id recordId){
       screeningWrapper sw;
        List<Screening_Questionnaire__c> sList = new List<Screening_Questionnaire__c>();  
        sList = [SELECT Id,Name,Application_Detail__c,Status__c FROM Screening_Questionnaire__c WHERE Application_Detail__c=:recordId order by createddate DESC limit 1];
       if(!sList.isEmpty()){
        if(sList[0].Status__c=='Accepted'){
             sw = new screeningWrapper(FALSE,sList[0].id);
        }else{
             sw = new screeningWrapper(TRUE,sList[0].id);
        }        
       }else{
           return null;
       }
       
        return sw;
     }
    
    @AuraEnabled
    public static Boolean acceptScreeningInfo(Id recordId){

        List<Screening_Questionnaire__c> sList = new List<Screening_Questionnaire__c>();  
        Application_Details__c ap = new Application_Details__c();
        Interview__c interview = new Interview__c();
        sList = [SELECT Id,Name,Status__c,Application_Detail__c,Preferred_Interview_Date__c FROM Screening_Questionnaire__c WHERE id=:recordId];

        try{
            //accepting Screening
             sList[0].Status__c='Accepted';
            update sList;
            ap.Id=sList[0].Application_Detail__c;
            ap.Latest_Screening__c = sList[0].id;
            ap.Application_Status__c = 'Application Accepted';
            update ap;
            
            return true;
        } catch(Exception e){
           system.debug('Exception:: '+e);  
           return false;
        }
      
     }
    
    @AuraEnabled
    public static Boolean rejectScreeningInfo(Id recordId){

        List<Screening_Questionnaire__c> sList = new List<Screening_Questionnaire__c>();  
        Application_Details__c ap = new Application_Details__c();
        sList = [SELECT Id,Name,Status__c,Application_Detail__c FROM Screening_Questionnaire__c WHERE id=:recordId];
        try{
            sList[0].Status__c='Rejected';
            update sList;
            ap.Id=sList[0].Application_Detail__c;
            ap.Latest_Screening__c = sList[0].id;
            ap.Application_Status__c = 'Application Rejected';
            update ap;
            return TRUE;
        } catch(Exception e){
           system.debug('Exception Occured:'+e);  
           return FALSE;
        }
            
     }
    Public class screeningWrapper {
        @AuraEnabled
        public Boolean showBtn {get;set;}
        @AuraEnabled
        public String recordId {get;set;}
     
        public screeningWrapper(Boolean showBtn,String recordId){
            this.showBtn = showBtn;
            this.recordId = recordId;
         }
    }
}
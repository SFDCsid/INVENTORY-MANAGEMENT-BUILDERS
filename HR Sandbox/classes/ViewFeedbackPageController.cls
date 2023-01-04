public class ViewFeedbackPageController {
    
    public List <Interview__c> interviewRecord{get; set;}
   
    public List < Questionnaire_Response__c > existingResponseList{get;set;}
    
    public String rating{get; set;}
    
    public id sid{get;set;}
    
    
    public ViewFeedbackPageController(){
        interviewRecord=new List<Interview__c>();
        
        existingResponseList = new List<Questionnaire_Response__c>();        
        
        sid = ApexPages.currentPage().getParameters().get('id');
        system.debug('id=' + sid);
        
        if (sid != null) {
            interviewRecord = [select id, Name, Interview_Type__c,Feedback_given__c,Interview_Status__c,Interview_Feedback_Template__c from Interview__c where id =: sid];
         if (!interviewRecord.isEmpty()) {
             existingResponseList = [SELECT Id,Interview__c, Name, Question_Number__c,Answer_Yes_No__c, Question_Text__c, Type__c, Answer_Picklist__c,Comments__c FROM Questionnaire_Response__c WHERE Interview__c=:interviewRecord[0].id order by Question_Number__c ASC];
             if(!existingResponseList.isEmpty()){
                 
                 
                 
             }
            }
           }
        }

}
public class ScreeningController {
    public Screening_Questionnaire__c squestions{get;set;}
    public List<Application_Details__c> apList{get;set;} 
    public Id apId{get;set;}
    public String isSubmitted{get;set;}
    public transient String base64;
    public String fileName {get; set;}
    public String PreferredDate {get; set;}
    public String getBase64()
    {
        return base64;
    }
    public void setbase64(String base64)
    {
        this.base64 = base64;
    }
     
    public ScreeningController(){
        apId = null;
        PreferredDate = '';
        isSubmitted = 'NotSubmitted';
        squestions = new Screening_Questionnaire__c();
        apList = new List<Application_Details__c>();
        apId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('Application id: '+ apId);
        if(apId!=null){
            apList = [SELECT Id,Name,Screening_Submitted__c,Applicant_Salutation__c,Applicant_First_Name__c,Applicant_Middle_Name__c,
                      Applicant_Last_Name__c 
                      FROM Application_Details__c WHERE Id=:apId];
            System.debug('application list: '+ apList);
            if(!apList.isEmpty()){
              if(apList[0].Screening_Submitted__c){
                isSubmitted='AlreadySubmitted';
              }else{
                isSubmitted='ApplicationFound';  
              }
            squestions.Application_Detail__c=apList[0].id;
           }else{
            isSubmitted='ApplicationNotFound';
        }
        }else{
            isSubmitted='ApplicationNotFound';
        }
        
    }
    
    public void submit(){
        DateTime dt; 
        String dateTimeStr;
        PreferredDate = Apexpages.currentPage().getParameters().get('PreferredDate');
        
        system.debug('PreferredDate::'+PreferredDate);
        try{
            if(String.isNotBlank(PreferredDate)){
            PreferredDate = PreferredDate.replace('T', ' ');
            DateTime resultDateTime = DateTime.ValueOf(PreferredDate+':00'); 
            system.debug('resultDateTime::'+resultDateTime); 
            squestions.Preferred_Interview_Date__c = resultDateTime;    
            }   
          squestions.First_Name__c = squestions.First_Name__c.substring(0,1).toUpperCase() + squestions.First_Name__c.substring(1).toLowerCase();
          squestions.Middle_Name__c = squestions.Middle_Name__c.substring(0,1).toUpperCase() + squestions.Middle_Name__c.substring(1).toLowerCase();
          squestions.Last_Name__c = squestions.Last_Name__c.substring(0,1).toUpperCase() + squestions.Last_Name__c.substring(1).toLowerCase();
        
          squestions.Status__c='Pending Action';
          insert squestions;
        
          isSubmitted='Submitted';
          apList[0].Applicant_First_Name__c = squestions.First_Name__c.substring(0,1).toUpperCase() + squestions.First_Name__c.substring(1).toLowerCase();
          apList[0].Applicant_Middle_Name__c = squestions.Middle_Name__c.substring(0,1).toUpperCase() + squestions.Middle_Name__c.substring(1).toLowerCase();
          apList[0].Applicant_Last_Name__c = squestions.Last_Name__c.substring(0,1).toUpperCase() + squestions.Last_Name__c.substring(1).toLowerCase();
          // apList[0].Questionnaire_Submitted__c=TRUE;
          apList[0].Application_Status__c = 'Ongoing Screening';
          apList[0].Screening_Submitted__c=true;
          update apList; 
        } catch(Exception e){
          System.debug('Exception::'+e); 
          isSubmitted = 'NotSubmitted';
        }       
    }
 
  public void saveFile(){
       
        ContentVersion cv = new ContentVersion();
        cv.versionData = EncodingUtil.base64decode(this.base64);
        cv.title = 'Resume: '+System.now();
        cv.pathOnClient = fileName;
        insert cv;
      
      ContentDocumentLink cdl = new ContentDocumentLink();
      cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
      cdl.LinkedEntityId =apList[0].id; // <----- put your record id here, example: an account tid
      cdl.ShareType = 'V';
      insert cdl;
         
    }
}
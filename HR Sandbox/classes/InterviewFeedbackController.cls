public class InterviewFeedbackController {

    public List < Interview__c > interviewRecord {
        get;
        set;
    }
    public List < Interview_Feedback_Template__c > interviewTemplate {
        get;
        set;
    }
    public List < Interview_Feedback_Questions__c > squestions {
        get;
        set;
    }
    public string oppid {
        get;
        set;
    }
    public Id sid {
        get;
        set;
    }
    public Boolean isTrue {
        get;
        set;
    }
    public Boolean isSubmitted {
        get;
        set;
    }
    public Boolean isExpired {
        get;
        set;
    }
    public String rating {
        get;
        set;
    }
    public String qid {
        get;
        set;
    }
    public Integer pageIndex {
        get;
        set;
    }
    public Decimal MaxIndex {
        get;
        set;
    }
    public Decimal perPage {
        get;
        set;
    }
    public Map < Id, String > selectedMap {
        get;
        set;
    }
    public List < Interview_Feedback_Questions__c > qlist {
        get;
        set;
    }
    public List < Questionnaire_Response__c > qlistToUpdate {
        get;
        set;
    }    
    public List < Questionnaire_Response__c > responseList {
        get;
        set;
    }
    public Map < Integer, List < Interview_Feedback_Questions__c >> questionMap {
        get;
        set;
    }
    public Map < Integer, List < Questionnaire_Response__c >> questionUpdateMap {
        get;
        set;
    }
    public String operationType {
        get;
        set;
    }
   
    public Integer starQuestionsCount {
        get;
        set;
    }
    public Integer CountOfstarRatingsGiven{
        get;
        set;
    }
        
    public InterviewFeedbackController() {

        interviewRecord = new List < Interview__c > ();
        interviewTemplate = new List<Interview_Feedback_Template__c>();
        squestions = new List < Interview_Feedback_Questions__c > ();
        responseList = new List<Questionnaire_Response__c>();
        selectedMap = new Map < ID, String > ();
        questionMap = new Map < Integer, List < Interview_Feedback_Questions__c >> ();
        questionUpdateMap = new Map < Integer, List < Questionnaire_Response__c >> ();
        qlist = new List < Interview_Feedback_Questions__c > ();
        qlistToUpdate = new  List< Questionnaire_Response__c > ();
        pageIndex = 0;
        MaxIndex = 0;
        perPage = 12;
        rating = '0';isSubmitted = false;
        starQuestionsCount = 0;
        CountOfstarRatingsGiven = 0;
        qid = '';
        operationType = 'insert';
        sid = ApexPages.currentPage().getParameters().get('id');
        system.debug('id=' + sid);

        if (sid != null) {
            interviewRecord = [select id, Name, Interview_Type__c,Feedback_Perentage__c,Feedback_given__c,Interview_Status__c,Interview_Feedback_Template__c from Interview__c where id =: sid];
         if (!interviewRecord.isEmpty()) {
              if(interviewRecord[0].Feedback_given__c||interviewRecord[0].Interview_Status__c=='Completed'){
                 operationType = 'update';
             }
 
             interviewTemplate = [select id, Name, InterviewTypes__c  ,Active__c from Interview_Feedback_Template__c where InterviewTypes__c INCLUDES(:interviewRecord[0].Interview_Type__c) AND Active__c=:true];
             
            if (!interviewTemplate.isEmpty()&&operationType=='insert') {
                 system.debug('interviewTemplate=' + interviewTemplate);
                  
                     isTrue = true;
                    squestions = [select id, Name, Question_Number__c, Question_Text__c, Type__c, Answer_Picklist__c,Comments__c,Answer_Yes_No__c
                                   from Interview_Feedback_Questions__c where Interview_Feedback_Template__c=:interviewTemplate[0].id order by Question_Number__c ASC];
                    
                 if (squestions.isEmpty()) {
                      system.debug('Feedback Invalid');
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, 'Feedback Invalid. Please contact Administrator.'));
                 }else{
                    perPage = 5;
                    MaxIndex = Integer.valueOf(Math.ceil(squestions.size() / perPage));
                    System.debug('maxIndex=' + MaxIndex);
                    Integer count = 1;
                    Integer cId = 1;
                    Integer totalQ = 0;
                     
                    for (Integer i = 0; i <squestions.size(); i++) {
                        System.debug('i=='+i+'ans=='+squestions[i].Answer_Picklist__c);
                        if(squestions[i].Answer_Picklist__c==null){
                            squestions[i].Answer_Picklist__c='0';
                        }
                        qlist.add(squestions[i]);
                        if (count == perPage) {
                            List < Interview_Feedback_Questions__c > qs = new List < Interview_Feedback_Questions__c > ();
                            qs.addAll(qlist);
                            totalQ=totalQ+count;
                            questionMap.put(cId, qs);
                            cId++;
                            count = 0; 
                            qlist.clear();
                         }
                      
                        count++;
                    }
                    
                    system.debug('totalQ==>'+totalQ+'qsize->'+qlist.size());
                    if(totalQ<squestions.size()){
                        List < Interview_Feedback_Questions__c > qs = new List < Interview_Feedback_Questions__c > ();
                            qs.addAll(qlist);
                         questionMap.put(cId, qs);
                    }
            }
            }
        }
        }
       
    }

    public void setQuestionData() {
        Id passedParam1 = Apexpages.currentPage().getParameters().get('qId');
        String passedParam2 = Apexpages.currentPage().getParameters().get('qVal');
        System.debug('qid ----------------------> ' + passedParam1 + 'qVal=' + passedParam2);
        selectedMap.put(passedParam1, passedParam2);
        system.debug('selectedMap=' + selectedMap);
        for (Integer i = 0; i < squestions.size(); i++) {
            if (selectedMap.containsKey(squestions[i].id)) {
                squestions[i].Answer_Picklist__c = selectedMap.get(squestions[i].id);
             }
        }
    }
    
    public PageReference NextPage() {
        pageIndex = pageIndex + 1;
      //  save();
        return null;
    }
   
    public PageReference PreviousPage() {
        pageIndex = pageIndex - 1;
     //   save();
        return null;
    }
    public PageReference BackToRecord() {
      PageReference pg = new PageReference('/'+sid);
      pg.setRedirect(true); 
      return pg;
    }
    public void submit(){
       
        try{
        if(operationType=='insert'){
            for(Interview_Feedback_Questions__c q: squestions){
                Questionnaire_Response__c response = new Questionnaire_Response__c();
                if(q.Answer_Picklist__c!=null){
                response.Answer_Picklist__c = q.Answer_Picklist__c;
                }
                if(q.Type__c=='Star Rating'){
                    system.debug('q.Answer_Picklist__c='+q.Answer_Picklist__c);
                    starQuestionsCount = starQuestionsCount+1;  
                    if(q.Answer_Picklist__c!=null){
                    CountOfstarRatingsGiven = CountOfstarRatingsGiven + Integer.valueOf(q.Answer_Picklist__c);
                    }
                }
                if(q.Answer_Yes_No__c!=null){
                  response.Answer_Yes_No__c = q.Answer_Yes_No__c;  
                }
                response.Comments__c = q.Comments__c;
                response.Question_Number__c = q.Question_Number__c;    
                response.Question_Text__c = q.Question_Text__c;
                response.Type__c = q.Type__c;  
                response.interview__c = interviewRecord[0].id;
                 
                   //response.id = q.QuestionResponseId__c;   
                 responseList.add(response);
            }
        }
            
            if(!responseList.isEmpty()){
                if(operationType=='insert'){
                insert responseList; 
                 system.debug('CountOfstarRatingsGiven='+CountOfstarRatingsGiven);  
                 system.debug('starQuestionsCount='+starQuestionsCount);      
                 system.debug('starQuestionsCount*5='+starQuestionsCount*5);     
                 system.debug('Percentage='+CountOfstarRatingsGiven/ (starQuestionsCount*5)*100);      
                if(CountOfstarRatingsGiven>0){
                  interviewRecord[0].Feedback_Perentage__c =(CountOfstarRatingsGiven/ (starQuestionsCount*5))*100;
                }
                interviewRecord[0].Interview_Feedback_Template__c = interviewTemplate[0].id;
                interviewRecord[0].Feedback_given__c = true;
                interviewRecord[0].Interview_Status__c = 'Completed';
                update interviewRecord[0];     
                }else{
                  update responseList;
                interviewRecord[0].Interview_Feedback_Template__c = interviewTemplate[0].id;
                interviewRecord[0].Feedback_given__c = true;
                interviewRecord[0].Interview_Status__c = 'Completed';
                update interviewRecord[0];        
                }
                
              
            }
            isSubmitted = true;
            isTrue = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Thank you for your feedback!'));
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, 'Error While Feedback Submission: '+e));
        }
    }
    
}
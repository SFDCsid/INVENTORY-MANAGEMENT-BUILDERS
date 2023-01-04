@istest
public class TestApplicationDetails {

    @istest
    public static void applicationdetails(){
        Position__c p = new Position__c();
        p.name = 'Salesforce Developer';
        p.Position_Approval_Status__c = 'Approved';
        p.Interview_Rounds__c='2';
        p.Interview_Type_1__c='HR Interview';
        p.Interviewer1__c='Yogesh Swami';
        p.Active__c = true;
        insert p;
      
        Interviewer_Details__c ic = new Interviewer_Details__c();
        ic.Name = 'Yogesh Swami';
        ic.Email__c = 'yogesh.swami@excellerconsultancy.in';  
        insert ic;
        
        Candidate__c candidate = new Candidate__c();
        candidate.Name = 'Test';
        candidate.Mobile__c='9158747991';
        candidate.Email__c = 'yogesh.swami@excellerconsultancy.in';  
        insert candidate;
        
        Application_Details__c a = new Application_Details__c();
        a.Application_Source__c = 'Naukri';
        a.Application_Status__c = 'New Application';
        a.Candidate__c = candidate.id;
        a.Position__c = p.id;
        insert a;
        
        Screening_Questionnaire__c sc = new Screening_Questionnaire__c();
        sc.Application_Detail__c = a.id;
        sc.Current_CTC_LPA__c = 500000;
        sc.Expected_CTC_LPA__c = 800000;
        sc.Status__c ='Pending Action';
        sc.Years_of_Experience1__c = 3;
        insert sc;
        
        Pagereference pageRef = Page.ScreeningQuestionnaire;
         test.setCurrentPageReference(pageRef);
          pageRef.getParameters().put('Id',a.id);
        ScreeningController sCon = new ScreeningController();
        sCon.squestions.First_Name__c = 'TestFirstName';
        sCon.squestions.Middle_Name__c = 'TestMiddleName';
        sCon.squestions.Last_Name__c = 'TestLastName';   
        sCon.submit();
        sCon.fileName='TestFile';
        sCon.base64 = 'Test';
        sCon.setbase64('Test');
        String s = sCon.getBase64();
        sCon.saveFile();
 
        ScreeningOutputController.rejectScreeningInfo(sc.id);
        ScreeningOutputController.acceptScreeningInfo(sc.id);
      
        sc.Status__c = 'Accepted';
        update sc;

        a.Application_Status__c = 'Application Accepted';
        update a;
        
        ScreeningOutputController.getScreeningInfo(a.id);
        Interview__c i = new Interview__c();
        i.Application_Detail__c = a.id;
        i.Interview_Type__c = 'HR Interview';
        i.Interview_Min_Hours__c = '45';
        i.Scheduled_Date__c = system.now()+5;
        i.Interviewer_Name__c= 'Yogesh Swami';
        i.Interview_Status__c = 'Scheduled';
       // i.Interview_Rounds__c = '3';
        i.Current_Interview_Round__c = 1;
        insert i;
        
        i.Interview_Status__c = 'Re-Scheduled';
        i.Reason_for_Reschedule_Cancellation__c ='Test';
        i.Scheduled_Date__c = system.now()+7;
        update i;
        
        Interview_Feedback_Template__c it = new Interview_Feedback_Template__c();
        it.Name='HR Interview';
        it.InterviewTypes__c  ='HR Interview';
        it.Active__c=true;
        insert it;
        Interview_Feedback_Questions__c iq = new Interview_Feedback_Questions__c();
        iq.Question_Number__c=1;
        iq.Question_Text__c='Test Question';
        iq.Type__c='Star Rating';
        iq.Interview_Feedback_Template__c = it.id;
        insert iq;
           
        Pagereference pageRef2 = Page.InterviewFeedback;
          test.setCurrentPageReference(pageRef2);
          pageRef2.getParameters().put('Id',i.id);
        InterviewFeedbackController interviewCon = new InterviewFeedbackController();
         interviewCon.submit();
        Questionnaire_Response__c res = new Questionnaire_Response__c();
        res.Answer_Picklist__c='4';
        res.Comments__c='test';
        res.Type__c='Star Rating';
        res.Question_Number__c=1;
        res.Question_Text__c='Test';
        res.Interview__c=i.id;
        insert res;
           
        Pagereference pageRef3 = Page.InterviewFeedback;
          test.setCurrentPageReference(pageRef3);
          pageRef3.getParameters().put('Id',i.id);
        InterviewFeedbackController interviewCon2 = new InterviewFeedbackController();
        interviewCon2.submit();
        
          Pagereference pageRef4 = Page.InterviewFeedback;
          test.setCurrentPageReference(pageRef4);
          pageRef4.getParameters().put('Id',i.id);
        InterviewFeedbackController interviewCon3 = new InterviewFeedbackController();
         interviewCon3.setQuestionData();
         interviewCon3.NextPage();
        interviewCon3.PreviousPage();
         interviewCon3.submit();
        i.Interview_Status__c = 'Completed';
        i.Feedback_given__c = true;
        update i;
         Pagereference pageRef5 = Page.InterviewFeedback;
          test.setCurrentPageReference(pageRef5);
          pageRef5.getParameters().put('Id',i.id); 
        ViewFeedbackPageController vf = new ViewFeedbackPageController();
                
        Interview__c i2 = new Interview__c();
        i2.Application_Detail__c = a.id;
        i2.Interview_Type__c = '';
        i2.Interview_Min_Hours__c = '45';
        i2.Scheduled_Date__c = system.now()+8;
        i2.Interviewer_Name__c= 'Yogesh Swami';
        i2.Interview_Status__c = 'Scheduled';
      //  i2.Interview_Rounds__c = '3';
        i2.Current_Interview_Round__c = 2;
        insert i2;
        
        i2.Interview_Status__c = 'Completed';
        i2.Feedback_given__c = true;
        update i2;
        
        Interview__c i3 = new Interview__c();
        i3.Application_Detail__c = a.id;
        i3.Interview_Type__c = '';
        i3.Interview_Min_Hours__c = '45';
        i3.Scheduled_Date__c = system.now()+9;
        i3.Interviewer_Name__c= 'Yogesh Swami';
        i3.Interview_Status__c = 'Scheduled';
      //  i3.Interview_Rounds__c = '3';
        i3.Current_Interview_Round__c = 2;
        insert i3;
        
        Offer__c o = new Offer__c();
        o.Application__c = a.id;
        o.Package_Amount_LPA__c = 700000;
        o.Valid_For_No_Of_Days__c = 12;
        o.Offer_Status__c='Offer Made';
        insert o;
        
          Pagereference pageRefOffer = Page.View_Offer;
          test.setCurrentPageReference(pageRefOffer);
          pageRefOffer.getParameters().put('Id',o.id); 
          ViewOfferController ofCon = new ViewOfferController();
        
        o.Approval_Status__c = 'Approved';
        o.Offer_Approver__c = UserInfo.getUserId();
        o.Approval_Date__c = system.now();
        update o; 
        
          Pagereference pageRef7 = Page.Offer_Acceptance_Form;
          test.setCurrentPageReference(pageRef7);
          pageRef7.getParameters().put('Id',o.id); 
        OfferAcceptanceController offr = new OfferAcceptanceController();
        offr.terms = true;
        offr.Accepted();
        offr.Rejected();
        NumberTOWordConvertion nw = new NumberTOWordConvertion();
        String s1 = nw.getNumberTOWordConvertion(3057089);
        String s2 = nw.getNumberTOWordConvertion(32682400);
        String s3 = nw.getNumberTOWordConvertion(3400);
         Position__c p2 = new Position__c();
        p2.name = 'Salesforce Developer';
        p2.Position_Approval_Status__c = 'Approved';
        p2.Active__c = true;
        insert p2;
    }
}
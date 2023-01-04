@isTest
public class Test_InterviewTrg {    
    
    public static testMethod void TestInterviewTrg(){
       
        Test.startTest();
        Position__c position = new Position__c();
        position.Name='Salesforce Developer';
        position.Interview_Rounds__c='5';
        position.Interview_Type_1__c='HR Interview';
        position.Interviewer1__c='Yogesh Swami';
        position.Interview_Type_2__c='Technical Interview';
        position.Interviewer2__c='Yogesh Swami';
        position.Interview_Type_3__c='Technical Interview';
        position.Interviewer3__c='Yogesh Swami';
        position.Interview_Type_4__c='Technical Interview';
        position.Interviewer4__c='Yogesh Swami';
        position.Interview_Type_5__c='Technical Interview';
        position.Interviewer5__c='Yogesh Swami';
        position.Active__c = true;
        position.Position_Approval_Status__c='Approved';
        insert position; 
         
        Interviewer_Details__c ic = new Interviewer_Details__c();
        ic.Name = 'Yogesh Swami';
        ic.Email__c = 'yogesh.swami@excellerconsultancy.in';  
        insert ic;
        
        Candidate__c candidate=new Candidate__c();
        candidate.Name='Test';
        candidate.Candidate_Stage__c='Hired';
        candidate.Email__c='pravesh.prajapati@excellerconsultancy.com';
        insert candidate;
        
        Application_Details__c application=new Application_Details__c();
        application.Candidate__c=candidate.Id;
        application.Position__c=position.Id;
        application.Application_Status__c='Interview Scheduled';
        application.Application_Source__c='Naukri';
        insert application;
        
     //update application;        
        
        Interview__c interview=new Interview__c();
        interview.Application_Detail__c=application.Id;
        interview.Position__c=position.Id;
        interview.Interview_Status__c='Scheduled';
        interview.Scheduled_Date__c=datetime.newInstance(2022,06,27,3,15,0);
        interview.Interviewer_Name__c = 'Yogesh Swami';
        interview.Current_Interview_Round__c=1;
        insert interview;
        
        interview.Interview_Status__c='Re-Scheduled';
        interview.Scheduled_Date__c=datetime.newInstance(2022,06,28,3,45,0);
        update interview; 
        
        interview.Interview_Status__c='Completed';
        interview.Feedback_given__c=true;
        update interview;
        
        application.Latest_Interview__c=interview.Id;
        update application; 
        
        Interview__c newinterview=new Interview__c();
        newinterview.Application_Detail__c=application.Id;
        newinterview.Position__c=position.Id;
        newinterview.Interview_Status__c='Scheduled';
        newinterview.Scheduled_Date__c=datetime.newInstance(2022,06,29,3,15,0);
        newinterview.Current_Interview_Round__c=2;
         newinterview.Interviewer_Name__c = 'Yogesh Swami';
        insert newinterview;
        
       
        newinterview.Interview_Status__c='Completed';
        newinterview.Feedback_given__c=true;
        update newinterview; 
        
        application.Latest_Interview__c=newinterview.Id;
        update application; 
        
        Interview__c interview3=new Interview__c();
        interview3.Application_Detail__c=application.Id;
        interview3.Position__c=position.Id;
        interview3.Interview_Status__c='Scheduled';
        interview3.Scheduled_Date__c=datetime.newInstance(2022,07,11,3,15,0);
        interview3.Current_Interview_Round__c=3;
        interview3.Interviewer_Name__c = 'Yogesh Swami';
        insert interview3;
        
        interview3.Interview_Status__c='Completed';
        interview3.Feedback_given__c=true;
        update interview3;
        
        application.Latest_Interview__c=interview3.Id;
        update application; 
        
        Interview__c interview4=new Interview__c();
        interview4.Application_Detail__c=application.Id;
        interview4.Position__c=position.Id;
        interview4.Interview_Status__c='Scheduled';
        interview4.Scheduled_Date__c=datetime.newInstance(2022,07,12,3,15,0);
        interview4.Current_Interview_Round__c=4;
        interview4.Interviewer_Name__c = 'Yogesh Swami';
        insert interview4;
        
        interview4.Interview_Status__c='Completed';
        interview4.Feedback_given__c=true;
        update interview4;
        
        application.Latest_Interview__c=interview4.Id;
        update application;
        
        Interview__c interview5=new Interview__c();
        interview5.Application_Detail__c=application.Id;
        interview5.Position__c =position.Id;
        interview5.Interview_Status__c='Scheduled';
        interview5.Scheduled_Date__c=datetime.newInstance(2022,07,14,3,15,0);
        interview5.Current_Interview_Round__c=5;
        interview5.Interviewer_Name__c = 'Yogesh Swami';

        insert interview5;
        
        interview5.Interview_Status__c='Completed';
        interview5.Feedback_given__c=true;
        update interview5;
        
        application.Latest_Interview__c=interview5.Id;
        update application;
       
        test.stopTest();
            
        
    } 
    
   

}
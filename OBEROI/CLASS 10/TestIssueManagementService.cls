@isTest
public class TestIssueManagementService
{
  
    public static testMethod void validatePriority()
    {
        List<Issue__c> issnew  = new List<Issue__c>();
        List<Issue__c> issold  = new List<Issue__c>();
        
        Issue_UpdateServices__c ius = new Issue_UpdateServices__c();
        ius.Name = 'issueUpdateReceivers';
        ius.ccTo1__c = 'test@stetig.com';
        ius.ccTo2__c = 'test@stetig.com';
        ius.Primary_Receiver__c = 'test@stetig.com';
        ius.Primary_Receiver1__c = 'test@stetig.com';
        ius.Primary_Receiver2__c = 'test@stetig.com';
        ius.Primary_Receiver3__c = 'test@stetig.com';
        ius.replyTo__c = 'test@stetig.com';
        ius.sender__c = 'Hello This is test class';
        insert ius;
        //ius.Send_Updates__c = true;
        
        Issue__c i1 = new Issue__c();
        i1.Status__c = 'Open';
        i1.Priority__c = 'L1';
        i1.Type__c = 'Bug';
        i1.Raised_By__c = 'Ankita';
        i1.Department__c = 'Other';
        i1.Prioritized_Date__c = system.today();
        insert i1;
        issnew.add(i1);
    
        i1.Status__c = 'Analysis Done & Submitted';
        i1.Analysis_Submitted_Date_Time__c = system.today();
        
        i1.Priority__c = 'Not Prioritized';
        i1.Analysis_Description__c = 'Description of analysis';
        
        i1.Estimated_Effort_Person_Days__c = 11;
        i1.Type__c = 'Bug';
        i1.Stream__c = 'Support';
        i1.Department__c = 'Other';
        i1.Analysis_Description__c = 'Description';
      Update i1;        
        issold.add(i1);
        
        Issue__c i2 = new Issue__c();
        i2.Status__c = 'ReOpen';
        i2.Priority__c = 'L2';
        i2.Type__c = 'Bug';
        i2.Raised_By__c = 'Ankita';
        i2.Department__c = 'Other';
        i2.ReOpen_Date__c = system.today();
        i2.Prioritized_Date__c = system.today();
        insert i2;
        
        //i2.Status__c = 'Under Development';
        i2.Development_Start_Date__c = system.today();
        i2.Module__c = 'Test Module';
        i2.Subject__c = 'Test Subject';
        i2.Type__c = 'Others';
        i2.Stream__c = 'Support';
        i2.Department__c = 'Other';
        i2.Description__c = 'Test Desc';
        update i2;
        
        Issue__c i3 = new Issue__c();
        
        i3.Status__c = 'Closed';
        i3.Priority__c = 'L1';
        i3.Type__c = 'Bug';
        i3.Raised_By__c = 'Sameer';
        i3.Department__c = 'Other';
        i3.Closed_Date__c = system.today();
        i3.Prioritized_Date__c = system.today();
        i3.Actual_Effort_Person_Days__c = 2.0;
        insert i3;
        
        //i3.Status__c = 'UAT';
        i3.UAT_Start_Date__c = system.today();
        i3.Module__c = 'Test M';
        i3.Subject__c = 'Subject test';
        i3.Prioritized_Date__c = Date.newInstance(2016, 12, 9);
        
        i3.Stream__c = 'Support';
        i3.Department__c = 'Other';
        i3.Description__c = 'Test Description';
        update i3;
            
            
        Issue__c i4 = new Issue__c();
        
        i4.Status__c = 'Closed';
        i4.Priority__c = 'L2';
        i4.Type__c = 'Bug';
        i4.Raised_By__c = 'Sameer';
        i4.Department__c = 'Sales';
        i4.Closed_Date__c = system.today();
        i4.Prioritized_Date__c = system.today();
        i4.Actual_Effort_Person_Days__c = 3.0;
        insert i4;
        
        
        Issue__c i5 = new Issue__c();
        
        i5.Status__c = 'Closed';
        i5.Subject__c = 'New Test';
        i5.Module__c = 'New Test Module';
        i5.Description__c = 'Test Desc';
        i5.Stream__c  = 'Support';
        i5.Primary_Resource__c = 'Amit';
        i5.Last_Updated_By__c = 'Shailesh';
        i5.Last_Updated_Date_TIme__c = system.today();
        i5.Last_Updated_Description__c = 'Test Last Desc';
        i5.Priority__c = 'Not Prioritized';
        i5.Type__c = 'Bug';
        i5.Raised_By__c = 'Sameer';
        i5.Department__c = 'Other';
        i5.Closed_Date__c = system.today();
        i5.Prioritized_Date__c = system.today();
        i5.Closed_Date__c = system.today();
        i5.Actual_Effort_Person_Days__c = 4.0;
        insert i5;
        
        i5.Primary_Resource__c = 'Amit';
        update i5;
        
        Issue__c i6 = new Issue__c();
        
        i6.Status__c = 'Closed';
        i6.Priority__c = 'Not Prioritized';
        i6.Prioritized_Date__c = system.today();
        i6.Type__c = 'Others';
        i6.Raised_By__c = 'Sameer';
        i6.Department__c = 'Other';
        i6.Closed_Date__c = system.today();
        i6.Go_Ahead_for_development_received_Date__c = system.today();
        i6.Go_ahead_for_production_received_date__c = system.today();
        i6.UAT_Start_Date__c = system.today();
        i6.Development_Start_Date__c = system.today();
        i6.ReOpen_Date__c = system.today();
        i6.Analysis_Description__c = 'Analysis Desc';
        
        
        i6.Analysis_Submitted_Date_Time__c = system.today();
        i6.Estimated_Effort_Person_Days__c = 1;
        i6.Actual_Effort_Person_Days__c = 2;
        insert i6; 

        Issue__c i7 = new Issue__c();
        i7.Status__c = 'Closed';
        i7.Priority__c = 'L1';
        i7.Prioritized_Date__c = system.today();
        i7.Type__c = 'Others';
        i7.Raised_By__c = 'Sameer';
        i7.Department__c = 'Other';
        i7.Closed_Date__c = system.today();
        i7.Go_Ahead_for_development_received_Date__c = system.today();
        i7.Go_ahead_for_production_received_date__c = system.today();
        i7.UAT_Start_Date__c = system.today();
        i7.Development_Start_Date__c = system.today();
        i7.ReOpen_Date__c = system.today();
        i7.Actual_Effort_Person_Days__c = 1;
        insert i7;
      
        i7.Type__c = 'Bug';
        i7.Status__c = 'Analysis Done & Submitted';
        i7.Priority__c = 'Not Prioritized';
        i7.Department__c = 'Other';
        i7.Subject__c = 'Test Email';
    i7.Description__c = 'Test Desc';
        i7.Module__c = 'Test Module';
        i7.Stream__c = 'Support';
        i7.Primary_Resource__c = 'Amit';
        i7.Analysis_Description__c = 'Analysis Desc';
        
        i7.Analysis_Submitted_Date_Time__c = system.today();
        i7.Estimated_Effort_Person_Days__c = 1;
        i7.Last_Updated_By__c = 'Aditya';
        i7.Last_Updated_Date_TIme__c = system.today();
        i7.Last_Updated_Description__c  = 'Desc';
        update i7;
    
        //i7.Status__c = 'Analysis Done & Submitted';
        //update i7;
        //i7.Status__c = 'Under Development';
        //update i7;
        i7.Status__c = 'UAT';
        update i7;
        i7.Status__c = 'ReOpen';
        update i7;
        i7.Status__c = 'Go-ahead start of dev';
        update i7;
        i7.Status__c = 'Go-ahead migration to prod';
       update i7;

    i7.Status__c = 'Under Development';
        i7.Development_Start_Date__c =Date.newInstance(2016, 12, 3);
        update i7;
 /*       
        i7.Status__c = 'UAT';
        i7.UAT_Date__c = Date.newInstance(2016, 12, 8);
        update i7;

        i7.Status__c = 'ReOpen';
        i7.ReOpen_Date__c = Date.newInstance(2016, 12, 7);
        update i7;
        i7.Status__c = 'Go-ahead start of dev';
        i7.Go_Ahead_for_development_received_Date__c =Date.newInstance(2016, 12, 6);
        update i7;
        i7.Status__c = 'Go-ahead migration to prod';
        i7.Go_ahead_for_production_received_date__c = Date.newInstance(2016, 12, 5);
       update i7;
*/
    Issue__c i8 = new Issue__c();
        
      i8.Type__c = 'Bug';
        i8.Status__c = 'Analysis Done & Submitted';
        i8.Priority__c = 'Not Prioritized';
        i8.Department__c = 'Other';
        i8.Subject__c = 'Test Email';
    i8.Description__c = 'Test Desc';
        i8.Raised_By__c = 'Ankita';
        i8.Module__c = 'Test Module';
        i8.Stream__c = 'Support';
        i8.Primary_Resource__c = 'Amit';
        i8.Analysis_Description__c = 'Analysis Desc';
        
        
        i8.Analysis_Submitted_Date_Time__c = system.today();
        i8.Estimated_Effort_Person_Days__c = 1;
        i8.Last_Updated_By__c = 'Shailesh';
        i8.Last_Updated_Date_TIme__c = system.today();
        i8.Last_Updated_Description__c  = 'Desc';
        insert i8;
        
        Issue_Comment__c ic = new Issue_Comment__c();
        ic.Comment__c = 'test';
        insert ic;
    }
    }
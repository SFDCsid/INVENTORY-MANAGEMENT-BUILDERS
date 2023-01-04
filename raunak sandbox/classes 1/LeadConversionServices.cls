public class LeadConversionServices {
    public static void convertLead(List<Lead_c__c> leadList) {
        List<Account> accList = new List<Account>();
        List<Lead_c__c> leadListUpdate = new List<Lead_c__c>();
        if(!leadList.isEmpty()) {
            for(Lead_c__c l: leadList) {
                //try {
                
                    accList = checkDuplicates(leadList);
                    system.debug('accList: '+accList);
                    
                    Account a = new Account();
                Opportunity_c__c op = new Opportunity_c__c();
                 List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
                    if(accList.isEmpty()) {
                        system.debug('LeadList: '+leadList);
                        a.FirstName = l.First_Name__c;
                        a.LastName = l.Last_Name__c;
                        a.PersonMobilePhone = l.Mobile__c;
                        a.PersonEmail = l.Email__c;
                        a.Phone = l.Alternate_Mobile_No__c;
                        a.Alternate_Email_Id__c = l.Alternate_Email_Id__c;
                       // a.Is_serviced__c = l.Is_serviced__c;
                        a.Age_Group__c = l.Age_Group__c;
                        a.Ethinicity__c = l.Ethinicity__c;
                     //   a.Citizenship__c = l.Citizenship__c;
                        a.Gender__c = l.Gender__c;
                        a.Marital_Status__c=l.Martial_Status__c;
                      //  a.Company_Associated__c = l.Company_Associated__c;
                        a.Family_Size__c=l.Family_Size__c;  
                        a.Industry=l.Industry__c;  
                        a.Designation__c = l.Designation__c;
                        a.Occupation__c = l.Occupation__c;
                        a.Household_Income_Annual__c = l.Household_Income_Annual__c;
                        a.Highest_Education__c=l.Highest_Education__c;
                        a.Current_Residence_City__c=l.Current_Residence_City__c;
                        a.Current_Residence_Area_Locality__c=l.Current_Residence_Area_Locality__c;
                        a.Current_Residence_Configuration__c=l.Current_Residence_Configuration__c;
                        a.Current_Residence_Status__c=l.Current_Residence_Status__c;
                        a.recordTypeId = personAccountRecordType[0].Id;
                        insert a;

                        
                        if(!accList.isEmpty())
                            op.Account_Name__c = accList[0].Id;
                        else
                            op.Account_Name__c = a.Id;
                        if(l.First_Name__c != Null)
                            op.First_Name__c = l.First_Name__c;
                        else 
                            op.First_Name__c = '';
                        if(l.Last_Name__c!= Null)
                            op.Last_Name__c = l.Last_Name__c;
                        else
                            op.Last_Name__c='';
                        op.CloseDate__c = system.today().addDays(60);
                        op.Mobile__c = l.Mobile__c;
                        op.Alternate_Mobile_No__c=l.Alternate_Mobile_No__c;
                        op.Email__c=l.Email__c;
                        op.Alternate_Email_Id__c=l.Alternate_Email_Id__c;
                        
                        op.Project__c = l.Project_Name__c;
                        op.Opportunity_Stage__c = l.Lead_Stage__c;
                        op.Opportunity_Stage__c=l.Lead_Stage__c;
                        op.Opportunity_Sub_Stage__c=l.Lead_Sub_Stage__c;
                        op.Opportunity_Sub_Stage_Reason__c=l.Lead_Sub_Stage_Reason__c;
                        op.Campaign_Custom__c = l.Campaign_Custom__c;
                        
                        op.Master_Source__c = l.Master_Source_Category__c;
                        op.Opportunity_Source__c = l.Lead_Source__c;
                        op.Opportunity_Sub_Source__c = l.Lead_Sub_Source__c;
                        op.Opportunity_Sub_Source_Details__c=l.Sub_Source_Details__c;
                       // op.Channel_Partner__c = l.Channel_Partner__c;
                       op.Channel_Partner_Account__c=l.Channel_Partner_Account__c;
                        op.Referrer_Name__c = l.Referrer_Name__c;
                        op.Employee_Referrer_Name__c=l.Employee_Referrer_Name__c;
                        op.CP_Project__c = l.CP_Project__c;
                        op.Other_Source_Details__c = l.Other_Source_Details__c;
                        op.Budget__c = l.Budget__c;
                        op.Buying_Purpose__c = l.Buying_Purpose__c;
                        //   op.Possession_Timeline_Requirement__c = l.Possession_timeline_requirement__c;
                        //  op.Cluster__c = l.Cluster__c;
                        //   op.Region__c = l.Region__c;
                        op.Configuration_Required__c = l.Configuration_Required__c;
                        /*  op.Type_of_Property_Required__c = l.Type_of_Property_Required__c;
op.Project_Type_Required__c = l.Project_Type_Required__c;
op.Unit_Type_Requirement__c = l.Unit_Type_Requirement__c; */
                        op.Household_Income_Annual__c=l.Household_Income_Annual__c;
                        op.Purchase_Timeframe__c=l.Purchase_Timeframe__c;
                        op.Possession_Timeframe_Required__c=l.Possession_Timeframe_Required__c;
                        op.Current_Residence_Configuration__c=l.Current_Residence_Configuration__c;
                        op.Current_Residence_Status__c=l.Current_Residence_Status__c;
                        op.Presales_Last_Call_Date__c = l.Last_Call_Date__c;
                        op.Presales_Next_Follow_up_Date__c = l.Follow_up_Date__c;
                        op.Presales_Proposed_Visit_Date__c = l.Proposed_Visit_Date__c;
                        op.Presales_Call_Count__c= l.Presales_Call_Count__c;
                        /*    op.Presales_Call__c = l.Presales_Call__c;
op.Latest_Enquiry_Date__c = l.Latest_Enquiry_Date__c;
op.Last_Presale_Call_Stage__c = l.Last_Presale_Call_Stage__c;
op.Last_Presale_Call_Sub_Stage__c = l.Last_Presale_Call_Sub_Stage__c;
op.Last_Presale_Call_Sub_Stage_Reason__c = l.Last_Presale_Call_Sub_Stage_Reason__c; */
                        op.Presales_Last_Comment__c = l.Last_Comment__c;
                        op.Presales_Comment_History__c = l.Comment_History__c;
                        op.Lead_c__c = l.id;
                        insert op;
               
                    }
                     if(!accList.isEmpty()){
                     l.Account__c = accList[0].Id;
                         
                     }
                    else
                    {
                        l.Account__c = a.Id;
                    	l.Opportunity_c__c = op.Id;
                    }
                        
                l.Converted_By__c = UserInfo.getUserId();
                l.Converted_DateTime__c = system.now();
                l.isConverted__c = true;
                if(l.Lead_Stage__c == 'Visit Done')    
                    leadListUpdate.add(l);
                /*} catch(Exception ex) {
                    system.debug('Error: '+ex.getMessage());
                }*/
            }
             
           update leadListUpdate;
        }
    }
    
    public static List<Account> checkDuplicates(List<Lead_c__c> leadList) {
        List<Account> accList = new List<Account>();
        Set<String> mobileSet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        
        for(Lead_c__c l: leadList) {
            if(!String.isBlank(l.Mobile__c))
              mobileSet.add(l.Mobile__c);
            if(!String.isBlank(l.Alternate_Mobile_No__c))
                mobileSet.add(l.Alternate_Mobile_No__c);
            if(!String.isBlank(l.Email__c))
                emailSet.add(l.Email__c);
            if(!String.isBlank(l.Alternate_Email_Id__c))
                emailSet.add(l.Alternate_Email_Id__c);
        }
        
        if(!mobileSet.isEmpty()) {
            List<Account> duplicateAccountMList = [Select Id, FirstName, LastName from Account where (PersonMobilePhone IN: mobileSet 
                                                  OR Phone IN: mobileSet) AND IsPersonAccount = true];
            if(!duplicateAccountMList.isEmpty())
                accList.addAll(duplicateAccountMList);
        }
        
        if(!emailSet.isEmpty()) {
            List<Account> duplicateAccountEList = [Select Id, FirstName, LastName from Account where (PersonEmail IN: emailSet 
                                                  OR Alternate_Email_Id__c IN: emailSet) AND IsPersonAccount = true];
            if(!duplicateAccountEList.isEmpty())
                accList.addAll(duplicateAccountEList);
        }
        return accList;
    } 
}
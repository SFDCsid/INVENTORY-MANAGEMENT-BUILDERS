public with sharing class projectwrapperClass {
   
        @Auraenabled(cacheable=true)  
        public static List<Wrapper> wrapData() {
            
            List<Wrapper> wrap = new List<Wrapper>();
    
            for(Lead lea : [SELECT Id, IsDeleted, MasterRecordId, LastName, FirstName, Salutation, MiddleName, Suffix, Name, Title, Company, Street, City, State, PostalCode, Country, Latitude, Longitude, GeocodeAccuracy, Address, Phone, MobilePhone, Fax, Email, Website, PhotoUrl, Description, LeadSource, Status, Industry, Rating, AnnualRevenue, NumberOfEmployees, OwnerId, HasOptedOutOfEmail, IsConverted, ConvertedDate, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId, IsUnreadByOwner, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, DoNotCall, HasOptedOutOfFax, LastViewedDate, LastReferencedDate, LastTransferDate, Jigsaw, JigsawContactId, EmailBouncedReason, EmailBouncedDate, Company_Name__c, Alternate_Email__c, Other_Lead_Lost_Reason__c, Age_Group__c, Designation__c, Occupation__c, Highest_Education__c, Ethinicity__c, Location__c, Gender__c, Marital_Status__c, Family_Size__c, Current_Residence_Configuration__c, Current_Residence_Status__c, Household_Income_Annual__c, Apply_round_robin__c, Lead_Id__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Citizenship__c, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c, Budget__c, Buying_Purpose__c, Project_Type__c, Purchase_Timeframe__c, Possession_Timeline_Requirement__c, Configuration_Required__c, Cluster__c, Project__c, Other_Source_Details__c, Legacy_Record__c, Lead_Source__c, Campaign_Code__c, Campaign_Custom__c, URL__c, UTM_Source__c, UTM_Medium__c, Start_Date__c, Created_Date__c, Last_Presale_Call_Date__c, Presale_Next_Follow_up_Date__c, Presale_Date_of_Visit__c, Presales_Comment_History__c, Latest_Enquiry_Date__c, Last_Presale_Call_Stage__c, Last_Presale_Call_Sub_Stage__c, Last_Presale_Call_Sub_Stage_Reason__c, Last_Presale_Call_Comment__c, Presales_Call__c, Legacy_Presales_Comment_History__c, Lead_Created_From__c, Master_Source__c, Referrer_Name__c, Channel_Partner_Name__c, Anniversary_Date__c, DOB__c, Is_Active__c, Reference_Name__c, SNP_Counter__c, Parent_Campaign__c, New_Lead__c FROM Lead LIMIT 1]){          
                wrap.add(new Wrapper(lea,'Lead'));            
            }
            for(Site_Visit__c svisit : [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Salutation__c, Lead__c, First_Name__c, Reference_Name__c, Last_Name__c, Mobile__c, Address__c, Email__c, Pincode__c, Age_Group__c, Designation__c, Occupation__c, Highest_Education__c, Ethinicity__c, Industry__c, Gender__c, Marital_Status__c, Family_Size__c, Current_Residence_Configuration__c, Current_Residence_Status__c, Household_Income_Annual__c, Master_Source__c, Lead_Source__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Lead_Stage__c, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c, Budget__c, Buying_Purpose__c, Project__c, Project_Type__c, Purchase_Timeframe__c, Possession_Timeline_Requirement__c, Configuration_Required__c, Referrer_Name__c, Other_Source_Details__c, Opportunity__c, SV_Date_Time__c, SV_Count__c, Company_Name__c, Marriage_Aniversary__c, Birth_Date__c, Visit_For__c, Sales_Manager__c, Channel_Partner_Name__c, Account__c, Cluster__c, Sourcing_Manager__c, Is_Sales_Manager_Assigned__c, Is_customer_with_CP__c, Is_Pickup_Provided__c, Is_Customer_with_Family__c, Is_Drop_Provided__c, Is_Source_Conflict__c, Remarks__c, Next_Follow_up_Date__c, Proposed_Date_of_Revisit__c, Comments__c, SV_Start_Time__c, SV_End_Time__c, Office_Address__c, Office_City__c, Office_Country__c, Office_Locality__c, Office_Pincode__c, Office_State__c, Anniversary_Date__c, Location__c, Citizenship__c, Presales_Manager__c, StageName__c, Sub_Stage__c, Sub_Stage_Reason__c, Approver_1__c, Approver_1_Status__c, Approval_Status__c FROM Site_Visit__c LIMIT 1]){          
                wrap.add(new Wrapper(svisit,'Site_Visit__c'));            
            }
           
    
            return wrap;
           
        }
    
        public class Wrapper{
                    
            @Auraenabled
            public sObject ac{get;set;}
            public string objType{get;set;}
            
            public Wrapper(sObject obj, string objtype){
                ac=obj;
                objType= objtype;
            }
            
        }
    
         
        @Auraenabled(cacheable=true)  
        public static List<Lead> lisDat() {
            List<Lead> leaList = [SELECT Id, IsDeleted, MasterRecordId, LastName, FirstName, Salutation, MiddleName, Suffix, Name, Title, Company, Street, City, State, PostalCode, Country, Latitude, Longitude, GeocodeAccuracy, Address, Phone, MobilePhone, Fax, Email, Website, PhotoUrl, Description, LeadSource, Status, Industry, Rating, AnnualRevenue, NumberOfEmployees, OwnerId, HasOptedOutOfEmail, IsConverted, ConvertedDate, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId, IsUnreadByOwner, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, DoNotCall, HasOptedOutOfFax, LastViewedDate, LastReferencedDate, LastTransferDate, Jigsaw, JigsawContactId, EmailBouncedReason, EmailBouncedDate, Company_Name__c, Alternate_Email__c, Other_Lead_Lost_Reason__c, Age_Group__c, Designation__c, Occupation__c, Highest_Education__c, Ethinicity__c, Location__c, Gender__c, Marital_Status__c, Family_Size__c, Current_Residence_Configuration__c, Current_Residence_Status__c, Household_Income_Annual__c, Apply_round_robin__c, Lead_Id__c, Lead_Sub_Source__c, Lead_Sub_Source_Details__c, Citizenship__c, Lead_Sub_Stage__c, Lead_Sub_Stage_Reason__c, Budget__c, Buying_Purpose__c, Project_Type__c, Purchase_Timeframe__c, Possession_Timeline_Requirement__c, Configuration_Required__c, Cluster__c, Project__c, Other_Source_Details__c, Legacy_Record__c, Lead_Source__c, Campaign_Code__c, Campaign_Custom__c, URL__c, UTM_Source__c, UTM_Medium__c, Start_Date__c, Created_Date__c, Last_Presale_Call_Date__c, Presale_Next_Follow_up_Date__c, Presale_Date_of_Visit__c, Presales_Comment_History__c, Latest_Enquiry_Date__c, Last_Presale_Call_Stage__c, Last_Presale_Call_Sub_Stage__c, Last_Presale_Call_Sub_Stage_Reason__c, Last_Presale_Call_Comment__c, Presales_Call__c, Legacy_Presales_Comment_History__c, Lead_Created_From__c, Master_Source__c, Referrer_Name__c, Channel_Partner_Name__c, Anniversary_Date__c, DOB__c, Is_Active__c, Reference_Name__c, SNP_Counter__c, Parent_Campaign__c, New_Lead__c FROM Lead LIMIT 1];
            return leaList;
        }

        @Auraenabled(cacheable=true)  
        public static User lisUser(string Id) {
            List<User> userList = [SELECT Id , Name FROM User WHERE Id =: Id];
            return userList[0];
        }

        @Auraenabled(cacheable=true)  
        public static  list<string> lisprojects() {
            list<string> projectName = new list<string>();
            List<Project__c> projectList = [SELECT 	Name FROM Project__c];
            for(Project__c  pro : projectList){
                projectName.add(pro.Name);
            }
            return projectName;
        }








 


}
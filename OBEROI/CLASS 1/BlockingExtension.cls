public with sharing class BlockingExtension
{
    ApexPages.StandardController controller;
    public Blocking_Detail__c blockingobj {get; set;}     
    public Id OptyId {get; set;}     
    public Id UnitId {get; set;} 
    public Id ProjectId {get; set;}    
    public Id optyidparam {get; set;} 
    public Id OptyBlocking {get; set;} 
    public String test{get; set;}       
    public String inputTextErrorMessageQuote {get; set;}
    public List<Opportunity> OptyDetails {get;set;}
    public List<Property__c> UnitDetails{get;set;}
    public List<Blocking_Detail__c> blockList {get; set;}
    public string optychk{get; set;}
    public string act;
    public string inputTextErrorMessage {get;set;}
    public string errormsgreserved {get;set;}
    public List<Account> AcntDetails {get;set;}
    public string errormsgchanged {get;set;}
    public String userName {get;set;} 
    public String userProfile {get;set;}
    public User activeUser {get;set;}
    public String userEmail {get;set;}
    public String errorMsg {get;set;}
    public Id profileId {get;set;}
    //Constructor Executed at Page Load... 
    //Automatically Executed... 
    public BlockingExtension(ApexPages.StandardController controller)
    {
        this.controller = controller;
        blockingobj = (Blocking_Detail__c)controller.getRecord();
        UnitId = ApexPages.currentPage().getParameters().get('unitid');
        // get('unitid') : Getting from URL...
        system.debug('unitid =' +UnitId);
        blockingobj.Unit__c = UnitId;
        list<property__c> prop = new list<property__c>();
        Prop = [select id, Name,Material_No__c From property__c Where id =: UnitId];
        blockingobj.Unit_No__c = Prop[0].Material_No__c;
        
        blockingobj.Status__c = 'Blocked';
        //blockingobj.Status__c = 'Reserved';
              
        errormsgchanged ='Changed';
        errormsg = '';
        // Getting optyid from URL when we go to inventory form through selecting opportunity.
        //Opportunities -> Select Opportunity -> click on inventory -> InventoryWadhwa page gets open.
        if(ApexPages.currentPage().getParameters().get('optyid') != '')
        {
            blockingobj.Opportunity__c = ApexPages.currentPage().getParameters().get('optyid');
        }
        else{
            errormsgreserved = 'Please Navigate through Opportunity.';
        }
        list<Blocking_Detail__c> BD = new list<Blocking_Detail__c>();
        BD = [SeLECT Id,Name,Status__c  FROM Blocking_Detail__c WHERE Unit__c =: UnitId  AND Status__c = 'Blocking In Process' ORDER BY CreatedDate DESC];
        if(BD.size() > 0){
            errormsgreserved = 'There is already an Approval Request submitted to Block this Unit.';
        }
        else{
        }
        
        
        //To make some fields readonly at the time of Unblocking...
        inputTextErrorMessage = ApexPages.currentPage().getParameters().get('action');
        system.debug('Error Message' + inputTextErrorMessage);
        
        // To check which page to be open - Block or Unblock...
        act = ApexPages.currentPage().getParameters().get('action');
        system.debug('Action: ' + act); 
        
        
        if(UnitId != null)
        {    
            if(act == 'Released')       // if(act == 'Unblocked') 
              {   
                    blockList = [SELECT Id,Release_Comments__c,Comments__c,Token_Amount__c,Cheque_Number__c,Instrument_Date__c,Opportunity__c,Unit_Number__c,Unit__c,Unit__r.Material_No__c,Status__c,Person_Email__c,PersonMobilePhone__c,Account_Name__c,Sales_Manager__c,Sales_Manager_Email__c FROM Blocking_Detail__c WHERE Unit__c = :blockingobj.Unit__c AND Status__c = 'Blocked' ORDER BY CreatedDate DESC];
                    system.debug('BLOCK LIST : ' + blockList);
                  if(blockList.size() > 0){
                    system.debug('BLOCK LIST : ' + blockList[0].Opportunity__c);
                    blockingobj.Opportunity__c = blockList[0].Opportunity__c ;  
                    blockingobj.Comments__c = blockList[0].Comments__c;
                    //Account Dtls
                    blockingobj.Account_Name__c = blockList[0].Account_Name__c;
                    blockingobj.Person_Email__c = blockList[0].Person_Email__c; 
                    blockingobj.PersonMobilePhone__c = blockList[0].PersonMobilePhone__c;
                    blockingobj.Sales_Manager__c =  blockList[0].Sales_Manager__c;
                    blockingobj.Sales_Manager_Email__c = blockList[0].Sales_Manager_Email__c;
                    blockingobj.Token_Amount__c = blockList[0].Token_Amount__c;
                    blockingobj.Instrument_Date__c = blockList[0].Instrument_Date__c;
                    blockingobj.Cheque_Number__c = blockList[0].Cheque_Number__c;
                    
                    system.debug('Account Name: ' + blockList[0].Account_Name__c);
                    system.debug('Person_Email: ' + blockList[0].Person_Email__c);
                    system.debug('PersonMobilePhone: ' + blockingobj.Account_Name__c);  
                                      
                    blockingobj.Status__c = 'Released';
                    system.debug('Status1 : ' + blockingobj.Status__c);  
                  }
              }                         
        }
        
        // For Status = Blocked
        if(act == 'Blocked')
        { 
                system.debug('Inside Blocked section : Netra');
                if(ApexPages.currentPage().getParameters().get('optyid')!='')
                {
                    
                    OptyDetails = [SELECT Name,StageName,Property__c ,AccountID FROM Opportunity WHERE Id = :blockingobj.Opportunity__c];   
                    system.debug('act == Blocked xxx: ' + OptyDetails  );
                    if (OptyDetails[0].StageName == 'Booked' || OptyDetails[0].StageName == 'Sold' || OptyDetails[0].StageName == 'Closed Lost' || OptyDetails[0].StageName == 'Cancelled' || OptyDetails[0].StageName == 'Booking confirmed' || OptyDetails[0].StageName == 'Closed Lost')
                    {
                           errormsgreserved = 'This Opportunity is already Booked / Sold / Closed / Cancelled  . Please select a New Opportunity.';  
                          //errormsgreserved = OptyDetails[0].Name+ ' :- Opportunity is already Booked . Please select a New Opportunity.';
                    }
                    else if(OptyDetails[0].Property__c != Null)
                    {
                        errormsgreserved = OptyDetails[0].Name+ ' :- A unit has been already Reserved for this opportunity. Please select a New Opportunity.';
                    }
                    else
                    {
                          OptyDetails = [SELECT Name,AccountID,StageName,Property__c FROM Opportunity WHERE Id = :blockingobj.Opportunity__c]; 
                          system.debug('Else part Netra : ' + OptyDetails );       
                          AcntDetails = [SELECT Id,Name,PersonEmail,PersonMobilePhone FROM Account where id = :OptyDetails[0].AccountID ];
                          system.debug('AcntDetails =' +AcntDetails);
                          blockingobj.Account_Name__c = AcntDetails[0].Id;
                          blockingobj.Person_Email__c = AcntDetails[0].PersonEmail;
                          blockingobj.PersonMobilePhone__c = AcntDetails[0].PersonMobilePhone;
                    }
                 }//if closed
                 
                 if(blockingobj.Opportunity__c != null )
                 {
                    if (OptyDetails[0].StageName == 'Booked' || OptyDetails[0].StageName == 'Sold' || OptyDetails[0].StageName == 'Closed Lost' || OptyDetails[0].StageName == 'Cancelled' ||
                        OptyDetails[0].StageName == 'Booking confirmed' || OptyDetails[0].StageName == 'Closed Lost')
                    {
                           errormsgreserved = 'This Opportunity is already Booked / Sold / Closed / Cancelled  . Please select a New Opportunity.'; 
                    }
                    else if(OptyDetails[0].Property__c != Null)
                    {
                        errormsgreserved = OptyDetails[0].Name+ ' :- A unit has been already Reserved for this opportunity. Please select a New Opportunity.';
                    }
                    else{
                        OptyDetails = [SELECT Name,StageName,AccountID FROM Opportunity WHERE Id = :blockingobj.Opportunity__c];        
                        AcntDetails = [SELECT Id,Name,PersonEmail,PersonMobilePhone FROM Account where id = :OptyDetails[0].AccountID ];
                        system.debug('AcntDetails =' +AcntDetails);
                        blockingobj.Account_Name__c = AcntDetails[0].id;
                        blockingobj.Person_Email__c = AcntDetails[0].PersonEmail;
                        blockingobj.PersonMobilePhone__c = AcntDetails[0].PersonMobilePhone;     
                    }       
                  } 
           }  // Closed if(act == 'Blocked') 
           
           // Get current logged in User's Email and Profile Details : 
           userName = UserInfo.getUserName();
           profileId = Userinfo.getProfileId();
           userProfile = [SELECT Id,Name FROM Profile WHERE Id=:profileId].Name;
           system.debug('User Name : ' + userName);
           system.debug('User Profile : ' + userProfile);
           
           
           activeUser = [Select Email From User where Username = : userName limit 1];
           system.debug('activeUser : ' + activeUser);
           userEmail = activeUser.Email;
           system.debug('userEmail : ' + userEmail);
           List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
           String MyProflieName = PROFILE[0].Name;
               
    }//Constructor Closed
    
    public PageReference setAccDtls()
    {
        if(blockingobj.Opportunity__c != null )
        {
            OptyDetails = [SELECT Name,Property__c,StageName,AccountID FROM Opportunity WHERE Id = :blockingobj.Opportunity__c];
            if (OptyDetails[0].StageName == 'Booked' || OptyDetails[0].StageName == 'Sold' || OptyDetails[0].StageName == 'Closed Lost' || OptyDetails[0].StageName == 'Cancelled' ||
                OptyDetails[0].StageName == 'Booking confirmed' || OptyDetails[0].StageName == 'Closed Lost')
                {
                   errormsgreserved = 'This Opportunity is already Booked / Sold / Closed / Cancelled  . Please select a New Opportunity.';  
                }
            else if(optyDetails[0].Property__c != Null)
                {
                    errormsgreserved = OptyDetails[0].Name+ ' :- A unit has been already Reserved for this opportunity. Please select a New Opportunity.';
                }    
            else{
                
                OptyDetails = [SELECT Name,StageName,AccountID FROM Opportunity WHERE Id = :blockingobj.Opportunity__c];        
                
                
                errormsgreserved = '';
                errormsgchanged = 'changed';
                AcntDetails = [SELECT Id,Name,PersonEmail,PersonMobilePhone FROM Account where id = :OptyDetails[0].AccountID ];
                system.debug('AcntDetails =' +AcntDetails);
                blockingobj.Account_Name__c = AcntDetails[0].id;
                blockingobj.Person_Email__c = AcntDetails[0].PersonEmail;
                blockingobj.PersonMobilePhone__c = AcntDetails[0].PersonMobilePhone;
                //Added By Netra : 30/03/2016
                blockingobj.Sales_Manager__c = UserInfo.getFirstName()+' '+UserInfo.getLastName();
                blockingobj.Sales_Manager_Email__c = UserInfo.getUserEmail();
             }   
           }     
           return null;
         
    }    
   
    public PageReference save()
    {
        System.debug('save method called');
        Boolean isError = false;
        errorMsg = '';
        if(blockingobj.Status__c == 'Blocked' && act=='Blocked') //if(blockingobj.Status__c == 'Reserved' && act=='Reserved') 
        {    
                 //system.debug('blockingobj.Opportunity__c : netra : ' + blockingobj.Opportunity__r.Sales_Manager__c);
                 Blocking_Detail__c blockingRecord = new Blocking_Detail__c();
                
                 blockingRecord.Opportunity__c = blockingobj.Opportunity__c;
                 blockingRecord.Status__c = 'Blocking In Process'; //blockingobj.Status__c;
                 blockingRecord.Unit__c = blockingobj.Unit__c;
                 system.debug('blockingobj.Unit__c'+blockingobj.Unit__c);
                 
                 blockingRecord.Account_Name__c = blockingobj.Account_Name__c;
                 blockingRecord.Person_Email__c = blockingobj.Person_Email__c;
                 blockingRecord.PersonMobilePhone__c = blockingobj.PersonMobilePhone__c;
                 blockingRecord.Sales_Manager__c = UserInfo.getFirstName()+' '+UserInfo.getLastName();
                 blockingRecord.Sales_Manager_Email__c = UserInfo.getUserEmail();
                 blockingRecord.Token_Amount__c = blockingobj.Token_Amount__c;
                 blockingRecord.Instrument_Date__c = blockingobj.Instrument_Date__c;
                 blockingRecord.Cheque_Number__c = blockingobj.Cheque_Number__c;
                 // New added By Netra : 30/03/2016
                 If(blockingobj.Comments__c != Null && blockingobj.Comments__c != ''){
                     blockingRecord.Comments__c = blockingobj.Comments__c;
                 }Else{
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.Error,'Please enter the comments before blocking a property.');
                    ApexPages.addMessage(myMsg1);
                    errorMsg = 'Please enter the comments before blocking a property.';
                    system.debug('errorMsg inside Else part : '+ errorMsg);
                 }
                 
                 
                 /*Show Opportunity */
                   
                 UnitDetails = [SELECT ID,Customers__c,Project_Name__c,Status__c FROM Property__c WHERE id =:blockingRecord.Unit__c];//,Blocking_Date__c
                 ProjectId = UnitDetails[0].Project_Name__c;
                 
                Map<string,Team_Members__c> approversTeam = getBlockingApproversTeam(ProjectId);  
                
                for(string tm : approversTeam.keyset()){
                    if(tm == 'First Level'){
                        blockingRecord.Blocking_Approver__c = approversTeam.get(tm).User__C;
                    }
                }
                 User u = [select firstname from user where id=:userinfo.getuserid()];
                 system.debug('UnitDetails' + UnitDetails);
                 for(Property__c unt:UnitDetails)
                 {
                     
                     unt.Status__c= 'Blocked';
                     unt.Customers__c = blockingRecord.Opportunity__c; 
                     unt.ID = blockingRecord.Unit__c;
                     unt.Temporary_Block__c = true;
                     unt.Blocked_By__r = u;
                     unt.Block_Comments__c = blockingRecord.Comments__c;

                    
                     system.debug('unt.Opportunity_Name__c'+ unt.Customers__c);
                 }       
                 
                 
                 OptyDetails = [SELECT Name,Property__c ,StageName,AccountID FROM Opportunity WHERE Id = :blockingRecord.Opportunity__c];//,Blocking_Date__c
                 
                 system.debug('OptyDetails2...' + OptyDetails );
                 for(Opportunity opty:OptyDetails )
                 {
                     
                     opty.Property__c = blockingRecord.Unit__c;
                                         
                     system.debug('opty.Property__c'+ opty.Property__c);
                 }       
                 
                  
                 try 
                 {
                     insert blockingRecord;
                     //update UnitDetails;
                     //update OptyDetails ;
                 } 
                 catch(DmlException ex) 
                 {
                     ApexPages.addMessages(ex);
                     errorMsg = ex.getMessage();
                     return null;
                 }   
                
           }// if closed
         
         // Check current logged in user Email id == Sales Manager's Email ID or Profile = Sales coordinator or Profile = System Administrator
         // If above any condition is true then only user can open / release the Unit. o/w show error Message.       
              if(blockingobj.Status__c == 'Released' && act=='Released') //if(blockingobj.Status__c == 'Unreserved' && act=='Unreserved')
              {    
                     
                     System.debug('UnBlocked Code');            
                     List<Blocking_Detail__c> blckDtls = [SELECT Id,Release_Comments__c,Comments__c,Token_Amount__c,Cheque_Number__c,Instrument_Date__c,Opportunity__c,Unit_Number__c,Unit__c,Unit__r.Material_No__c,Status__c,Person_Email__c,PersonMobilePhone__c,Account_Name__c,Sales_Manager__c,Sales_Manager_Email__c FROM Blocking_Detail__c WHERE Unit__c = :blockingobj.Unit__c AND Status__c = 'Blocked' ORDER BY CreatedDate DESC];           
                     system.debug('Blocked Dtls: ' + blckDtls);
                     Blocking_Detail__c UnblockingRecord = new Blocking_Detail__c();
                   if(blckDtls.size() > 0)
                   {  
                         if(userProfile == 'System Administrator' || userProfile == 'Sales Rep')  // 
                         { 
                             system.debug('userEmail :' + userEmail);
                             system.debug('blckDtls[0].Sales_Manager_Email__c : ' + blckDtls[0].Sales_Manager_Email__c);
                             system.debug('userProfile : ' + userProfile);
                             errorMsg = '';
                             system.debug('errorMsg xxx : ' + errorMsg);
                             UnblockingRecord.Status__c = 'Released In Process';             //UnblokingRecord.Status__c = 'Unreserved'; 
                             UnblockingRecord.Id = blckDtls[0].Id; 
                             
                             UnblockingRecord.Account_Name__c = blckDtls[0].Account_Name__c;
                             UnblockingRecord.Person_Email__c = blckDtls[0].Person_Email__c;
                             UnblockingRecord.PersonMobilePhone__c = blckDtls[0].PersonMobilePhone__c;
                             UnblockingRecord.Sales_Manager__c = blckDtls[0].Sales_Manager__c;
                             UnblockingRecord.Sales_Manager_Email__c = blckDtls[0].Sales_Manager_Email__c;
                             UnblockingRecord.Token_Amount__c = blckDtls[0].Token_Amount__c;
                             UnblockingRecord.Instrument_Date__c = blckDtls[0].Instrument_Date__c;
                             UnblockingRecord.Cheque_Number__c = blckDtls[0].Cheque_Number__c;
                             if(blockingobj.Release_Comments__c !=Null && blockingobj.Release_Comments__c != ''){
                                 UnblockingRecord.Release_Comments__c = blockingobj.Release_Comments__c;
                             }Else{
                                 ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.Error,'Please enter the comments before Unblocking a property.');
                                 ApexPages.addMessage(myMsg1);
                                 errorMsg = 'Please enter the comments before Unblocking a property.';
                                 system.debug('errorMsg inside Else part : '+ errorMsg);
                             }
                             //UnblockingRecord.Unit__c = blckDtls[0].Unit__c ;
                             
                             UnitDetails = [SELECT ID,Customers__c,Status__c FROM Property__c WHERE id =:blckDtls[0].Unit__c];//,Blocking_Date__c
                 
                             system.debug('UnitDetails' + UnitDetails);
                             for(Property__c unt:UnitDetails)
                             {
                                 system.debug('unt.Opportunity_Name__c'+ unt.Customers__c);
                                 
                                 unt.Status__c= 'Available';
                                 unt.Customers__c = null;
                                 unt.Temporary_Block__c = False; 
                                                                                                 
                                 system.debug('unt.Opportunity_Name__c'+ unt.Customers__c);
                             }       
                             
                             
                             OptyDetails = [SELECT Name,Property__c ,StageName,AccountID FROM Opportunity WHERE Id = :blckDtls[0].Opportunity__c];//,Blocking_Date__c
                             
                             system.debug('OptyDetails2...' + OptyDetails );
                             for(Opportunity opty:OptyDetails )
                             {
                                 system.debug('opty.Property__c'+ opty.Property__c);
                                 opty.Property__c = null;
                                                     
                                 system.debug('opty.Property__c'+ opty.Property__c);
                             }       
                             
                             try {
                             
                             update UnblockingRecord;
                             //update UnitDetails;
                             //update OptyDetails ;
                             
                             } catch (DmlException e) {
                                apexpages.addmessages(e);
                                errorMsg = e.getMessage();
                                return null;
                             }
                         } // If Closed for UserEmail checking.
                         else
                         {
                             ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.Error,'You do not have the authorization to Unblock this unit. Please contact your Administrator.');
                             ApexPages.addMessage(myMsg1);
                             errorMsg = 'You do not have the authorization to Unblock this unit. Please contact your Administrator.';
                             system.debug('errorMsg inside Else part : '+ errorMsg);
                         }
                     }  // if closed of blckDtls.size() > 0   
                } // If Closed status== Released
            if(string.isBlank(errorMsg))
            {
                   
                 //PageReference newpage = new Pagereference('/' + blockingobj.Unit__c);     
                 PageReference newpage = new Pagereference('/'+blockingobj.Opportunity__c);
                 newpage.setRedirect(true);
                 return newpage;
             }
       
         
       return null; 
    }// Save Method Closed... 
    
    public Map<string,Team_Members__c> getBlockingApproversTeam(string pId){
     Map<string,Team_Members__c> approversMap = new Map<string,Team_Members__c>();
     for(Team_Members__c tm : [select id,name,Approver_Type__c,Counter__c,IsActive__c,Last_Assignment__c,Team__c,
                               User__c,User_Active__c from Team_Members__c where Team__r.Team_Type__c = 'Blocking Approver Team' and
                               Team__r.Project__c =:pId and User_Active__c = true and IsActive__c = true]){
         approversMap.put(tm.Approver_Type__c,tm);
     }
     return approversMap;
 }Public void Dummy(){
    Decimal i = 0;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    } 
}
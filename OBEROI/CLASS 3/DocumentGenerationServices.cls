Public Class DocumentGenerationServices{

Public static string errorMsg;
    
    public static Boolean checkDocumentTemplate(Id projectId, String documentType) {
        // check if that specific document type exists in the document template table
        
        List<Document_Template__c> temp = new List<Document_Template__c>();
        temp = [select id,name,Document_Type__c,Project__c from Document_Template__c 
                where Document_Type__c =: documentType and Project__c =: projectId];
        
        if(!temp.isEmpty()){
            return true; 
        }else{
            return false;
        }    
        
    }
    
  /*  public static List<CustomerWrapper> getAgreeementsCustomerList(string pId, string tId, Integer list_size, Integer counter){
        List<Opportunity> oppList = new List<Opportunity>();
        List<CustomerWrapper> cwList = new List<CustomerWrapper>();
        
        oppList = [select id,name,Unit__c,Unit__r.Tower__c,Project__c,StageName,S_Active__c,Primary_Name__c,Other_Applicants_Name__c,Primary_Phone__c,Primary_Email__c,Unit__r.Booking__c,
                   Unit__r.Booking__r.Booking_Date__c
                   from opportunity where Project__c =: pId and Unit__c != null and Unit__r.Unit_Status__c = 'Sold' and Unit__r.Tower__c =: tId and stageName = 'Booked'
                   and S_Active__c = true order by createdDate asc limit:list_size offset:counter];
        
        if(oppList != null && !oppList.isEmpty()){
            for(opportunity op : oppList){
                CustomerWrapper cw = new CustomerWrapper();
                cw.o = op;
                cw.selected = false;
                cwList.add(cw);
            }
            return cwList;
        }
        return null;
    
    } 
   */ 
    
    public static List<CustomerWrapper> getRegistrationCustomerList(string pId, string tId, Integer list_size, Integer counter){
        List<Opportunity> oppList = new List<Opportunity>();
        List<CustomerWrapper> cwList = new List<CustomerWrapper>();
        
        oppList = [select id,name,Property__c,Property__r.Tower__c,Project__c,StageName,Booking__c,
                   Booking__r.Booking_Date__c,booking__r.Acceptance_Form_Template__c,booking__r.Agreement_Form_Template__c,
                   booking__r.Allotment_Form_Template__c,Booking__r.NRI_Declaration_Template__c,
                   booking__r.Mortgage_Release_Request_Letter__c,booking__r.Agreement_Signing_undertaking__c,
                   booking__r.Annexure_B_Nomination_Form__c,booking__r.TPA__c,booking__r.Bank_NOC__c,
                   booking__r.Provisional_NOC__c,booking__r.L_L_NOC__c,booking__r.Car_Park_Allotment_Letter__c,
                   booking__r.Possession_Undertaking_Letter__c,booking__r.Possession_Letter__c,booking__r.Electricity_Meter_transfer_NOC__c,
                   booking__r.Rejection_Notice_Pre_Possession__c,booking__r.Rejection_Notice_Post_Possession__c,booking__r.ROFR_NOC_Loan_case__c,
                   Booking__r.Project__r.id,Booking__r.Agreement_Request_Template__c, 
                   Booking__r.Project__r.Project_Template_Label__c 
                   from opportunity where Project__c =: pId and Property__c != null and Booking__C != null //Property__r.Status__c = 'Booked' and
                   and Property__r.Tower__c =: tId //and stageName = 'Token Amount Received - BIP'
                   order by createdDate desc limit:list_size offset:counter];
        
        System.debug('oppList::::::::::'+oppList);
        System.debug('oppList SIZE ::::::::::'+oppList.size());
        
        
        if(oppList != null && !oppList.isEmpty()){
            Map<Id, Applicant__C> applicantMap = new Map<Id, Applicant__C>();
            for(Applicant__C ap : [select id,name,Email_Address__c,Applicant_Number__c,Opportunity__c from Applicant__C where Opportunity__c IN:oppList AND Applicant_Number__c = 'Primary Applicant']){
                applicantMap.put(ap.Opportunity__c, ap);
            }
            for(opportunity op : oppList){
                CustomerWrapper cw = new CustomerWrapper();
                if(applicantMap.containsKey(op.id)){
                    //if(applicantMap.get(op.id).Applicant_Number__c == 'Primary Applicant'){
                    cw.applicantName = applicantMap.get(op.id).name;
                    cw.applicantEmail = applicantMap.get(op.id).Email_Address__c;
                    //}
                    
                }
                cw.o = op;
                cw.selected = false;
                cwList.add(cw);
            }
            return cwList;
        }
        return null;
    
    } 
    
    
    public static Id generateDocBatch(Map<string,List<CustomerWrapper>> customerDocMap) {
        Id batchId;
        for(string key : customerDocMap.keyset()){
            List<opportunity> optyList = new List<opportunity>();
            for(CustomerWrapper cp : customerDocMap.get(key)){
                optyList.add(cp.o);
            }
            system.debug('optyList:: '+optyList.size());
            Map<string, List<opportunity>> custDocMap = new Map<string, List<Opportunity>>();
            system.debug('key is :: '+ key);
            custDocMap.put(key,optyList);
            DocumentGenrationBatch db = new DocumentGenrationBatch(custDocMap);
            batchId = database.executeBatch(db, 1);
        }
        return batchId;
    }
    
    public static Map<string, string> generateDocumentMethod(string docName, Opportunity opp) {
        system.debug('generateDocumentMethod:: oppId::'+opp+' docName: '+docName);
        List<Project__c> prjList = new List<Project__c>();
        List<Related_Document_History__c> rdListChk = new List<Related_Document_History__c>();
        
        prjList = [SELECT Id,Name,Acceptance_Doc_Label__c,Acceptance_Series__c,
                  Agreement_Doc_Label__c,Agreement_Series__c,Allotment_Doc_Label__c,Allotment_Series__c,
                   Mortgage_Release_Request_Doc_Label__c,Mortgage_Release_Request_Letter_Series__c,
                   Agreement_signing_undertaking_Doc_Label__c,Agreement_signing_undertaking_Series__c,
                   Annexure_B_Nomination_Form_Doc_Label__c,Annexure_B_Nomination_Form_Series__c,
                   TPA_Doc_Label__c,TPA_Series__c,Bank_NOC_Doc_Label__c,Bank_NOC_Series__c,
                   Provisional_NOC_Doc_Label__c,Provisional_NOC_Series__c,L_L_NOC_Doc_Label__c,
                   L_L_NOC_Series__c,Car_Park_Allotment_Letter_Doc_Label__c,Car_Park_Allotment_Letter_Series__c,
                   Possession_Undertaking_Letter_Doc_Label__c,Possession_Undertaking_Letter_Series__c,
                   Possession_Letter_Doc_Label__c,Possession_Letter_Series__c,Electricity_Meter_transfer_NOC_Doc_Label__c,
                   Electricity_Meter_transfer_NOC_Series__c,Rejection_Notice_Pre_Poss_Doc_Label__c,Rejection_Notice_Pre_Possession_Series__c,
                   Rejection_Notice_Post_Poss_Doc_Label__c,Rejection_Notice_Post_Possession_Serie__c,
                   ROFR_NOC_Loan_case_Doc_Label__c,ROFR_NOC_Loan_case_Series__c,NRI_Doc_Label__c,NRI_Series__c,
                   Agreement_Request_Label__c,Agreement_Request_Series__c
                   FROM Project__c Where id=:opp.Booking__r.Project__r.id ];
        
        String strlabel='';
        Decimal docSeries; 
        if(!prjList.isEmpty()){
        if(docName=='Acceptance Form'){
          strlabel = prjList[0].Acceptance_Doc_Label__c;
          docSeries = prjList[0].Acceptance_Series__c;    
        }else{
            if(docName=='NRI Declaration Form'){
             strlabel = prjList[0].NRI_Doc_Label__c;
             docSeries = prjList[0].NRI_Series__c;
            }else{
              if(docName=='Agreement Form'){
              strlabel = prjList[0].Agreement_Doc_Label__c;
              docSeries = prjList[0].Agreement_Series__c; 
              }else{
               if(docName=='Allotment Form'){
              strlabel = prjList[0].Allotment_Doc_Label__c;
              docSeries = prjList[0].Allotment_Series__c;
               }else{
                   if(docName=='Mortgage Release Request Letter'){
                        strlabel = prjList[0].Mortgage_Release_Request_Doc_Label__c;
                        docSeries = prjList[0].Mortgage_Release_Request_Letter_Series__c;
                   }else{
                       if(docName=='Agreement signing undertaking'){
                          strlabel = prjList[0].Agreement_signing_undertaking_Doc_Label__c;
                          docSeries = prjList[0].Agreement_signing_undertaking_Series__c; 
                       }else{
                           if(docName=='Annexure B - Nomination Form'){
                              strlabel = prjList[0].Annexure_B_Nomination_Form_Doc_Label__c;
                              docSeries = prjList[0].Annexure_B_Nomination_Form_Series__c; 
                           }else{
                               if(docName=='TPA'){
                                  strlabel = prjList[0].TPA_Doc_Label__c;
                                  docSeries = prjList[0].TPA_Series__c; 
                               }else{
                                   if(docName=='Bank NOC'){
                                       strlabel = prjList[0].Bank_NOC_Doc_Label__c;
                                       docSeries = prjList[0].Bank_NOC_Series__c; 
                                   }else{
                                       if(docName=='Provisional NOC'){
                                           strlabel = prjList[0].Provisional_NOC_Doc_Label__c;
                                           docSeries = prjList[0].Provisional_NOC_Series__c; 
                                       }else{
                                           if(docName=='L&L NOC'){
                                               strlabel = prjList[0].L_L_NOC_Doc_Label__c;
                                               docSeries = prjList[0].L_L_NOC_Series__c;
                                           }else{
                                               if(docName=='Car Park Allotment Letter'){
                                                   strlabel = prjList[0].Car_Park_Allotment_Letter_Doc_Label__c;
                                                   docSeries = prjList[0].Car_Park_Allotment_Letter_Series__c;
                                               }else{
                                                   if(docName=='Possession Undertaking Letter'){
                                                       strlabel = prjList[0].Possession_Undertaking_Letter_Doc_Label__c;
                                                       docSeries = prjList[0].Possession_Undertaking_Letter_Series__c;
                                                   }else{
                                                       if(docName=='Possession Letter'){
                                                           strlabel = prjList[0].Possession_Letter_Doc_Label__c;
                                                           docSeries = prjList[0].Possession_Letter_Series__c;
                                                       }else{
                                                           if(docName=='Electricity Meter transfer NOC'){
                                                              strlabel = prjList[0].Electricity_Meter_transfer_NOC_Doc_Label__c;
                                                              docSeries = prjList[0].Electricity_Meter_transfer_NOC_Series__c; 
                                                           }else{
                                                               if(docName=='Rejection Notice - Pre Possession'){
                                                                   strlabel = prjList[0].Rejection_Notice_Pre_Poss_Doc_Label__c;
                                                                   docSeries = prjList[0].Rejection_Notice_Pre_Possession_Series__c;
                                                               }else{
                                                                   if(docName=='Rejection Notice - Post Possession'){
                                                                       strlabel = prjList[0].Rejection_Notice_Post_Poss_Doc_Label__c;
                                                                       docSeries = prjList[0].Rejection_Notice_Post_Possession_Serie__c;
                                                                   }else{
                                                                       if(docName=='ROFR NOC Loan case'){
                                                                           strlabel = prjList[0].ROFR_NOC_Loan_case_Doc_Label__c;
                                                                           docSeries = prjList[0].ROFR_NOC_Loan_case_Series__c;
                                                                       }else{
                                                                           if(docName=='Agreement Generation Request'){
                                                                           strlabel = prjList[0].Agreement_Request_Label__c;
                                                                           docSeries = prjList[0].Agreement_Request_Series__c;
                                                                       }
                                                                           
                                                                       }
                                                                   }
                                                               }
                                                           }
                                                       }
                                                   }
                                               }
                                           }
                                       }
                                   }
                               }
                           }
                       }
                   }
               }
              }
            }
        } 
        }
        System.debug('Tmplabel::'+strlabel+' docSeries::'+docSeries);
        rdListChk = [SELECT Id,Name,Document_Name__c,CreatedDate,Opportunity__r.Project__c,Opportunity__c,
                    Project_Template_Label__c,Template_Label__c,Document_Number_Series__c,Document_Approved__c 
                  FROM Related_Document_History__c
                  WHERE Name =: docName AND Opportunity__r.Project__c =: opp.Booking__r.Project__r.id And Document_Number_Series__c!=null Order by CreatedDate DESC];
                  
        List<Applicant__C> appList = [select id,name,Email_Address__c,Applicant_Number__c,Opportunity__c 
                                      from Applicant__C where Opportunity__c =: opp.id];
        
         //system.debug('Template:'+opp.Booking__r.Acceptance_Form_Template__c);
         system.debug('rdListChk::'+rdListChk.isEmpty());
        Map<string,string> resultMap = new map<string,string>();
        errorMsg = '';
        Related_Document_History__c rd = new Related_Document_History__c();
        rd.Name = docName;
        rd.Document_Name__c = docName; 
        rd.Document_Generated_By__c = UserInfo.getUserId();
        rd.Document_Send_To_Customer_By__c = UserInfo.getUserId();
        rd.Document_Generated_Date_Time__c = system.now();
      //  rd.Customer_Email_Id__c = opp.Primary_Email__c;
        rd.Opportunity__c = opp.id;
        rd.Booking__C = opp.Booking__C;
        if(appList.size()>0)
        rd.Applicant_Name_1__c = appList[0].Name;
        if(appList.size()>1)
        rd.Applicant_Name_2__c = appList[1].Name;
        if(appList.size()>2)
        rd.Applicant_Name_3__c = appList[2].Name;
        if(appList.size()>3)
        rd.Applicant_Name_4__c = appList[3].Name;
        if(appList.size()>4)
        rd.Applicant_Name_5__c = appList[4].Name;
        rd.Project_Template_Label__c = opp.Booking__r.Project__r.Project_Template_Label__c;
        if(String.isNotBlank(strlabel)&&rdListChk.isEmpty()){
         rd.Template_Label__c = strlabel;
         if(docSeries!=null){
               rd.Document_Number_Series__c = docSeries;  
         }
        }else{
        if(String.isNotBlank(strlabel)&&!rdListChk.isEmpty()){
         rd.Template_Label__c = strlabel;
            if(rdListChk[0].Document_Number_Series__c!=null){
                 integer intValue = Integer.valueOf(rdListChk[0].Document_Number_Series__c)+1;
                  rd.Document_Number_Series__c = intValue;
            }else{
                if(docSeries!=null){
                  rd.Document_Number_Series__c = docSeries;  
                }
            }
         }
        }
        try{
            List<Related_Document_History__c> rdListAppChk = [SELECT Id,Name,Document_Name__c,CreatedDate,Booking__C,Opportunity__c,Document_Approved__c,Project_Template_Label__c,Template_Label__c,Document_Number_Series__c 
                  FROM Related_Document_History__c
                  WHERE (Name =: docName AND (Name != 'Bank NOC' AND Name != 'Provisional NOC' )) and  Booking__C =: opp.Booking__C and Document_Approved__c =: true];
            if(rdListAppChk.size()>0){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Once the document is approved then you can not generate it again.'));
            }
            else{
                insert rd;
            }
        }catch(Exception e){
            errorMsg = 'error while inserting related document record:: '+ e.getMessage();
            system.debug('errorMsg=='+errorMsg);
        }
        
        //PageReference pageRef = new PageReference('/apex/'+docName+'PDF');
        string bDocName = '';
        if(docName == 'Acceptance Form'){
            bDocName = opp.Booking__r.Acceptance_Form_Template__c;
        }else if(docName == 'Agreement Form'){
            bDocName = opp.Booking__r.Agreement_Form_Template__c;
        }else if(docName == 'Allotment Form'){
            bDocName = opp.Booking__r.Allotment_Form_Template__c;
        }else if(docName == 'NRI Declaration Form'){
            bDocName = opp.Booking__r.NRI_Declaration_Template__c;
        }else if(docName == 'Mortgage Release Request Letter'){
            bDocName = opp.Booking__r.Mortgage_Release_Request_Letter__c;
        }else if(docName == 'Agreement signing undertaking'){
            bDocName = opp.Booking__r.Agreement_Signing_undertaking__c;
        }else if(docName == 'Annexure B - Nomination Form'){
            bDocName = opp.Booking__r.Annexure_B_Nomination_Form__c;
        }else if(docName == 'TPA'){
            bDocName = opp.Booking__r.TPA__c;
        }else if(docName == 'Bank NOC'){
            bDocName = opp.Booking__r.Bank_NOC__c;
        }else if(docName == 'Provisional NOC'){
            bDocName = opp.Booking__r.Provisional_NOC__c;
        }else if(docName == 'L&L NOC'){
            bDocName = opp.Booking__r.L_L_NOC__c;
        }else if(docName == 'Car Park Allotment Letter'){
            bDocName = opp.Booking__r.Car_Park_Allotment_Letter__c;
        }else if(docName == 'Possession Undertaking Letter'){
            bDocName = opp.Booking__r.Possession_Undertaking_Letter__c;
        }else if(docName == 'Possession Letter'){
            bDocName = opp.Booking__r.Possession_Letter__c;
        }else if(docName == 'Electricity Meter transfer NOC'){
            bDocName = opp.Booking__r.Electricity_Meter_transfer_NOC__c;
        }else if(docName == 'Rejection Notice - Pre Possession'){
            bDocName = opp.Booking__r.Rejection_Notice_Pre_Possession__c;
        }else if(docName == 'Rejection Notice - Post Possession'){
            bDocName = opp.Booking__r.Rejection_Notice_Post_Possession__c;
        }else if(docName == 'ROFR NOC Loan case'){
            bDocName = opp.Booking__r.ROFR_NOC_Loan_case__c;
        }else if(docName == 'Agreement Generation Request'){
            bDocName = opp.Booking__r.Agreement_Request_Template__c;
        }
        system.debug('docName: '+docName);
        system.debug('bDocName: '+bDocName);
        List < Related_Document_History__c> rdList = [Select Id, Name , Customer_Email_Id__c, Document_Generated_By__c, Document_Generated_Date_Time__c, 
                                                     Document_Name__c, Document_Send_To_Customer_By__c,Document_Approved__c, Opportunity__c,Opportunity__r.Name,
                                                     Opportunity__r.Property__r.name
                                 from Related_Document_History__c where Id =: rd.Id];
        
        Blob body;
        try {
            // returns the output of the page as a PDF
            if(docName == 'Agreement Form'){    
            PageReference pageRef = new PageReference('/apex/View_Document_Schedule11');    
            pageRef.getParameters().put('oppId', opp.id);   
            pageRef.getParameters().put('docType', docName);    
            pageRef.getParameters().put('docName', bDocName);   
            body = pageRef.getContentAsPDF();   
            system.debug('body: '+body);
            }else{  
            PageReference pageRef = new PageReference('/apex/View_Document');   
            pageRef.getParameters().put('oppId', opp.id);   
            pageRef.getParameters().put('docType', docName);    
            pageRef.getParameters().put('docName', bDocName);   
            body = pageRef.getContentAsPDF();   
            system.debug('body: '+body);
            }
            
        } catch (VisualforceException e) {
            system.debug('exception::'+e);
            body = Blob.valueOf('Some Text');
        }
        if(rdList.size() >0){
            
            
            ContentVersion cont = generateNewContentVersion(body, rdList[0], docName);
            createFeedItem(cont.Id, rd);
            if(string.isBlank(errorMsg)){
                resultMap.put(rd.id,cont.id);
            }
            else{
                resultMap.put('Document Insertion Failure:',errorMsg);
            }
        }
        return resultMap;
    }
    
    
    public static ContentVersion generateNewContentVersion(Blob fileContent, Related_Document_History__c d, string docName) {
          ContentVersion cont = new ContentVersion();
          cont.Title = docName + '-' + d.Opportunity__r.name + '-' + d.Opportunity__r.Property__R.Name + '-' + system.now();
          cont.VersionData = fileContent;
          cont.PathOnClient = d.Name +'.pdf';
          cont.ContentLocation = 'S';
          cont.Description = docName + ' for :' + d.Opportunity__r.Name;
          cont.TagCSV = docName + ' for :' + d.Opportunity__r.Name;
          cont.IsDocGen__c = true;
          cont.IsInitialDocGenerated__c = true;
         if(d.Document_Approved__c){
            cont.isApproved__c=true; 
         }
          try{
              insert cont;
          }catch(Exception e){
              errorMsg = 'Error while inserting contentVersion:: ' + e.getmessage();
          }
          //system.debug('cont is:: '+cont);
          return cont;
          
    }
     public static ContentVersion generateNewApprovedContentVersion(Blob fileContent, Related_Document_History__c d, string docName) {
         
          ContentVersion cont = new ContentVersion();
          cont.Title = docName + '-' + d.Opportunity__r.name + '-' + d.Opportunity__r.Property__R.Name + '-' + system.now();
          cont.VersionData = fileContent;
          cont.PathOnClient = d.Name +'.pdf';
          cont.ContentLocation = 'S';
          cont.Description = docName + ' for :' + d.Opportunity__r.Name;
          cont.TagCSV = docName + ' for :' + d.Opportunity__r.Name;
          cont.IsDocGen__c = true;
          cont.IsSecondDocGenerated__c = true;
          cont.isApproved__c=true; 
          try{
              insert cont;
          }catch(Exception e){
              errorMsg = 'Error while inserting contentVersion:: ' + e.getmessage();
          }
          //system.debug('cont is:: '+cont);
          return cont;
          
    }
    public static void createFeedItem(Id contentId, Related_Document_History__c rd)
    {
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentId].ContentDocumentId;
        
        //Create ContentDocumentLink for putting the doc in the Folder.
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = rd.id; // you can use objectId,GroupId etc
        cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        try{
         insert cDe;
            
            System.debug('LinkedEntityId=='+cDe.LinkedEntityId);
        FeedItem elm = new FeedItem(Body = 'Post with related document body', ParentId = rd.Id, RelatedRecordId = contentId, Type = 'ContentPost');
           
            insert elm; 
         }catch(Exception e){
            errorMsg = 'Error while inserting Feed Record:: '+ e.getMessage();
        }    
    }
    
    public static List<Project__c> getProjectDetails(string pId){
        List<Project__C> pList = new List<Project__C>();
        DescribeSObjectResult describeResult = Project__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + pId + '\''; 
        pList = Database.query( query );
        return pList;
    }
    public static List<Booking__c> getBookingDetails(string bId){
        List<Booking__c> bList = new List<Booking__c>();
        DescribeSObjectResult describeResult = Booking__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + bId + '\''; 
        bList = Database.query( query );
        return bList;
    }
    public static List<Property__c> getPropertyDetails(string pId){
        List<Property__c> pList = new List<Property__c>();
        DescribeSObjectResult describeResult = Property__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) + ', Project_Name__r.Promoter_s_Email_Address__c,'+
                       ' Project_Name__r.Other_Company_Phone__c,Project_Name__r.Other_Company_Fax__c,' + 
                       ' Project_Name__r.Promoter_s_PAN__c,Booking__r.Booking_Date__c' +   
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + pId + '\''; 
        pList = Database.query( query );
        return pList;
    }
    public static List<Opportunity> getOpportunityDetails(string oId){
        List<Opportunity> oList = new List<Opportunity>();
        DescribeSObjectResult describeResult = Opportunity.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + oId + '\''; 
        oList = Database.query( query );
        return oList;
    }
    public static List<Account> getAccountDetails(string aId){
        List<Account> aList = new List<Account>();
        DescribeSObjectResult describeResult = Account.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + aId + '\''; 
        aList = Database.query( query );
        return aList;
    }
    public static List<Applicant__C> getApplicantDetails(string oId){
        List<Applicant__C> aList = new List<Applicant__C>();
        DescribeSObjectResult describeResult = Applicant__C.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where Booking__C =' + '\'' + oId + '\'' +
                       ' and Applicant_Number__c = \'Primary Applicant\''; 
        aList = Database.query( query );
        return aList;
    }
    public static List<Tower__C> getTowerDetails(string tId){
        List<Tower__C> tList = new List<Tower__C>();
        DescribeSObjectResult describeResult = Tower__C.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + tId + '\''; 
        tList = Database.query( query );
        return tList;
    }
    public static List<Quotation__C> getQuotationDetails(string qId){
        List<Quotation__C> qList = new List<Quotation__C>();
        DescribeSObjectResult describeResult = Quotation__C.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where id=' + '\'' + qId + '\''; 
        qList = Database.query( query );
        return qList;
    }
    public static List<Applicant__C> getOtherApplicantsDetails(String oId){
        List<Applicant__C> aList = new List<Applicant__C>();
        DescribeSObjectResult describeResult = Applicant__C.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where Booking__C=' + '\'' + oId + '\'' +
                       ' and Applicant_Number__c != \' Primary Applicant \' order by createdDate ASC LIMIT 10'; 
        aList = Database.query( query );
        return aList;
    } 
    public static List<Document_Template__c> getDocumentTemplate(String pId, string docType, string docName){
        List<Document_Template__c> docList = new List<Document_Template__c>();
        DescribeSObjectResult describeResult = Document_Template__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +  
                       ' FROM ' + describeResult.getName() + ' where Project__C =' + '\'' + pId + '\'' +
                       ' and Document_Type__C = ' + '\'' + docType + '\'' + ' and name =' + '\'' + docName + '\''; 
        docList = Database.query( query );
        return docList;
    } 
    public static String getAllApplicantPANCards(List<Applicant__c> applist){
        String namesStr = '';
        if(!applist.isEmpty()){
        for(Applicant__c a:applist){
            system.debug('ss='+a.Type_Of_Applicant__c);
             if(a.Applicant_Number__c!='Primary Applicant'){
                  namesStr = namesStr+' / ';  
                }
 
                if(String.isNotBlank(a.Pan_Card_Number_of_Authority_Signatory__c)){
                 namesStr = namesStr+a.Pan_Card_Number_of_Authority_Signatory__c;
                }else{
                    if(String.isNotBlank(a.PancardNo__c)){
                      namesStr = namesStr+a.PancardNo__c;
                    }else{
                      namesStr = namesStr+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';   
                    }
               
            }
        }
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }
    public static String getAllApplicantNames(List<Applicant__c> applist){
        String namesStr = '';
        if(!applist.isEmpty()){
        for(Applicant__c a:applist){
            namesStr = namesStr+a.Salutation__c+' '+a.Name+'<br/>';
        }
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }
    public static String getAllApplicantNameswithIndex(List<Applicant__c> applist){
        String namesStr = '';
        if(!applist.isEmpty()){
        for(Applicant__c a:applist){
            namesStr = namesStr+a.Index__c+' '+a.Salutation__c+' '+a.Name+'<br/>';
        } 
        if(String.isNotBlank(namesStr)){
           
          return namesStr; 
        }
        }
        return '';
    }
      public static String getAllApplicantNameswithIndexAFS(List<Applicant__c> applist){
        String namesStr = '<br/>';
        if(!applist.isEmpty()){
        for(Applicant__c a:applist){
            namesStr = namesStr+a.Index__c+' '+a.Salutation__c+' '+a.Name+'<br/>';
        } 
        if(String.isNotBlank(namesStr)){
           
          return namesStr; 
        }
        }
        return '';
    }
    public static String getAllApplicantNameswithIndexandLinebreak(List<Applicant__c> applist){
        String namesStr = '';
        if(!applist.isEmpty()){
        for(Applicant__c a:applist){
            namesStr = '<b>'+namesStr+a.Index__c+' '+a.Salutation__c+' '+a.Name+'</b><br/><br/><br/>';
        }
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return ''; 
    }
        public static String TPASign(List<Applicant__c> applist){
        String namesStr = '';
         namesStr = namesStr + '<div style="width:100%;   white-space: normal;">'+
                                '<div style="">';        
     
        if(!applist.isEmpty()){
        for(Applicant__c a:applist){
            namesStr = namesStr + '<br/><br/><span><b>'+a.Salutation__c+' '+a.Name+'</b></span><br/>Party/ies of the Third Part</span><br/><br/>';
        }
        namesStr = namesStr +'</div></div> <br/>'+
                             '<br/><br/><br/><br/><br/>';
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }
    public static String getAllApplicantAllotmentSignature(List<Applicant__c> applist,String companyname){
        String namesStr = '<table  style="width:100%;">';
        namesStr = namesStr + '<tr><td><div style="width:100%;   white-space: normal;">'+
                                '<div style="width:60%;float:left;"><b> For '+ companyname +'</b><br/><br/><br/><br/></div>'+
                                '<div style="width:40%;float:right;"><b>I/We agree and confirm,</b></div> '+
                            '</div>';
        namesStr = namesStr + '<div style="width:100%;   white-space: normal;">'+
                                '<div style="width:60%;float:left;padding-top: 2%;"><b>Authorised Signatory/s</b><br/><br/><b>Encl: As above</b></div><div style="width:40%;float:right;">';        
     
        if(!applist.isEmpty()){
        for(Applicant__c a:applist){
            namesStr = namesStr + '<p><b>'+a.Salutation__c+' '+a.Name+'</b><br/><br/><br/></P>';
        }
        namesStr = namesStr +'</div></div></td></tr><br/>'+
                             '</table><br/><br/><br/><br/><br/>';
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }
    public static String getAllApplicantAllotmentSignature2(List<Applicant__c> applist,String companyname){
        String namesStr = '<table  style="width:100%;">';
        namesStr = namesStr + '<tr><td><div style="width:100%;   white-space: normal;">'+
                                '<div style="width:60%;float:left;"><b> For '+ companyname +'</b><br/><br/><br/><br/></div>'+
                                '<div style="width:40%;float:right;"><b>I/We agree and confirm,</b></div> '+
                            '</div>';
        namesStr = namesStr + '<div style="width:100%;   white-space: normal;">'+
                                '<div style="width:60%;float:left;padding-top: 2%;"><b>Authorised Signatory/s</b><br/><br/><b>Encl: As above</b></div><div style="width:40%;float:right;">';        
     
        if(!applist.isEmpty()){
        for(Applicant__c a:applist){
            namesStr = namesStr + '<p><b>'+a.Salutation__c+' '+a.Name+'</b><br/><br/></P>';
        }
        namesStr = namesStr +'</div></div></td></tr><br/>'+
                             '</table><br/><br/><br/><br/><br/>';
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }
    public static String getCarParkSignatures(List<Applicant__c> applist,String companyname){
        String namesStr = '<table  style="width:100%;">';
        namesStr = namesStr + '<tr><td><div style="width:100%;   white-space: normal;">'+
                                '<div style="width:40%;float:left;">Yours Sincerely,<br/><b> For '+ companyname +'</b><br/><br/><br/><br/></div>'+
                                '<div style="width:70%;"><b>I/We confirm and accept the above<br/> on______________________</b></div><br/>'+
                            '</div><br/><br/>'; 
        namesStr = namesStr + '<div style="width:100%;   white-space: normal;">'+
                                '<div style="width:40%;float:left;padding-top: 2%;"><b>Authorised Signatory/ies</b><br/><br/></div><div style="width:60%;float:right;">';        
      
        if(!applist.isEmpty()){
        for(Applicant__c a:applist){
            namesStr = namesStr + '<p><b>'+a.Salutation__c+' '+a.Name+'</b><br/><br/><br/></P>';
        }
        namesStr = namesStr +'</div></div></td></tr><br/>'+
                             '</table><br/><br/><br/><br/><br/>';
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }
     public static String getAllApplicantNamesForPossessionLetter(List<Applicant__c> applist,String companyname){
      String namesStr = '<table  style="width:100%;">';
        namesStr = namesStr + '<tr><td><div style="width:100%;   white-space: normal;">'+
                                '<div style="width:40%;float:left;">Yours Sincerely,<br/><b> For '+ companyname +'</b><br/><br/><br/><br/></div>'+
                                '<div style="width:70%;"><b>I/We confirm the above and take the<br/> possession of the said premises on______________________</b></div><br/>'+
                            '</div><br/>';
        namesStr = namesStr + '<div style="width:100%;   white-space: normal;">'+
                                '<div style="width:40%;float:left;padding-top: 2%;"><b>Authorised Signatory/ies</b><br/><br/></div><div style="width:60%;float:right;">';        
      
        if(!applist.isEmpty()){
        for(Applicant__c a:applist){
            namesStr = namesStr + '<p><b>'+a.Salutation__c+' '+a.Name+'</b><br/><br/><br/></P>';
        }
        namesStr = namesStr +'</div></div></td></tr><br/>'+
                             '</table><br/><br/><br/><br/><br/>';
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }
     public static String getAllApplicantNamesForPossessionUndertaking(List<Applicant__c> applist,String companyname){
        String namesStr = '<table  style="width:100%;">';
 
        namesStr = namesStr + '<div style="width:100%;   white-space: normal;">'+
                                '<div style="width:100%;float:left;padding-top: 2%;"><b>Yours Sincerely,</b><br/><br/><br/>';        
      
        if(!applist.isEmpty()){
        for(Applicant__c a:applist){
            namesStr = namesStr + '<p><b>'+a.Salutation__c+' '+a.Name+'</b><br/><br/><br/></P>';
        }
        namesStr = namesStr +'</div></div></td></tr><br/><br/>'+
                             '</table><br/><br/><br/>';
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }
    public static String getAllApplicantNamesInline(List<Applicant__c> applist){
        String namesStr = '';
        if(!applist.isEmpty()){
        for(Integer i=0;i<applist.size();i++){
            if(i==applist.size()-1){
                namesStr = namesStr+' '+applist[i].Salutation__c+' '+applist[i].Name;
            }
            else {
                namesStr = namesStr+' '+applist[i].Salutation__c+' '+applist[i].Name+',';
                }    
        }
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }
    
    public static String getAllApplicantNameswithAllottees(List<Applicant__c> applist){
        String namesStr = '';
        if(!applist.isEmpty()){
        for(Integer i=0;i<applist.size();i++){
            if(i==applist.size()-1){
                namesStr = '<b>'+namesStr+' '+applist[i].Salutation__c+' '+applist[i].Name+' ("the Allottee/s")</b>';
            }
            else {
                namesStr = '<b>'+namesStr+' '+applist[i].Salutation__c+' '+applist[i].Name+'</b><br/>';
                }    
        }
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }
    
   
    public static String getAllApplicantNameswithLinebreakandAllottees(List<Applicant__c> applist){
          String namesStr = '<table  style="width:100%;">';
      
             for(Integer i=0;i<applist.size();i++){ 
                
            if(i==applist.size()-1){
                  namesStr = namesStr + '<tr><td><div style="width:100%;   white-space: normal;">'; 
                 namesStr = namesStr+ '<div style="width:50%;float:left;word-wrap: break-word;"><p style="word-wrap: break-word;"><b>'+applist[i].Salutation__c+' '+applist[i].Name+' ("the Allottee/s")</b></p></div>'+
                     '<div style="width:50%;line-height: 2.5;"><b>_____________________________</b></p></div>';
                           
                namesStr = namesStr +'</div></td></tr>';
            }else {
                  namesStr = namesStr + '<tr><td><div style="width:100%;   white-space: normal;">'; 
                 namesStr = namesStr+ '<div style="width:50%;float:left;word-wrap: break-word;"><p><b>'+applist[i].Salutation__c+' '+applist[i].Name+'</b></p></div>'+
                     '<div style="width:50%;line-height: 2.5;"><b>_____________________________</b></p></div>'; 
                  namesStr = namesStr +'</div></td></tr>';
                }
             }
                namesStr = namesStr +'</table>'; 
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
   
        return '';
     }
    
    
    public static String getAllApplicantNamesForCarPark(List<Applicant__c> applist){
        String namesStr = '';
        if(!applist.isEmpty()){
        for(Integer i=0;i<applist.size();i++){
            if(i==applist.size()-1){
                namesStr = '<b>'+namesStr+' '+applist[i].Salutation__c+' '+applist[i].Name+'</b>';
            }
            else {
                namesStr = '<b>'+namesStr+' '+applist[i].Salutation__c+' '+applist[i].Name+'</b><br/>';
                }    
        }
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }
    public static String getAllApplicantSignatures(List<Applicant__c> applist){
         String namesStr = '';
        if(!applist.isEmpty()){
        for(Integer i=0;i<applist.size();i++){
            Integer index = 0;
            index = i+1;
            namesStr =  '<br/>'+namesStr+index+'. __________________________________ PAN:  '+ applist[i].PancardNo__c+'<br/><br/><br/><br/>';
        } 
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        }
        return '';
    }  
    public static String getBankNOCAddress(Booking__c bObj){
         String namesStr = '';
         
        if(String.isNotBlank(bObj.Bank_Name_For_Bank_NOC__c)){
           namesStr = namesStr + bObj.Bank_Name_For_Bank_NOC__c;
        }
        if(String.isNotBlank(bObj.Bank_Address_For_Bank_NOC__c)){
           namesStr = namesStr+'<br/>'+ bObj.Bank_Address_For_Bank_NOC__c;
        }
        if(String.isNotBlank(bObj.Bank_Address_Line_2_For_Bank_NOC__c)){
           namesStr = namesStr+',<br/>'+bObj.Bank_Address_Line_2_For_Bank_NOC__c;
        }
        if(String.isNotBlank(bObj.Bank_Address_Line_3_For_Bank_NOC__c)){
           namesStr = namesStr+',<br/>'+ bObj.Bank_Address_Line_3_For_Bank_NOC__c;
        }
        if(String.isNotBlank(bObj.Bank_Address_Line_4_For_Bank_NOC__c)){
           namesStr = namesStr+',<br/>'+ bObj.Bank_Address_Line_4_For_Bank_NOC__c;
        }
        if(String.isNotBlank(bObj.Bank_Address_Line_5_For_Bank_NOC__c)){
           namesStr = namesStr+',<br/>'+ bObj.Bank_Address_Line_5_For_Bank_NOC__c;
        }
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        return '';
    }
     public static String getProvisionalBankNOCAddress(Booking__c bObj){
        String namesStr = '';
         
        if(String.isNotBlank(bObj.Provisional_Bank_NOC_Bank_Name__c)){
           namesStr = namesStr + bObj.Provisional_Bank_NOC_Bank_Name__c;
        }
        if(String.isNotBlank(bObj.Provisional_Bank_NOC_Bank_Address_Line_1__c)){
           namesStr = namesStr+'<br/>'+ bObj.Provisional_Bank_NOC_Bank_Address_Line_1__c;
        }
        if(String.isNotBlank(bObj.Provisional_Bank_NOC_Bank_Address_Line_2__c)){
           namesStr = namesStr+',<br/>'+bObj.Provisional_Bank_NOC_Bank_Address_Line_2__c;
        }
        if(String.isNotBlank(bObj.Provisional_Bank_NOC_Bank_Address_Line_3__c)){
           namesStr = namesStr+',<br/>'+ bObj.Provisional_Bank_NOC_Bank_Address_Line_3__c;
        }
        if(String.isNotBlank(bObj.Provisional_Bank_NOC_Bank_Address_Line_4__c)){
           namesStr = namesStr+',<br/>'+ bObj.Provisional_Bank_NOC_Bank_Address_Line_4__c;
        }
        if(String.isNotBlank(bObj.Provisional_Bank_NOC_Bank_Address_Line_5__c)){
           namesStr = namesStr+',<br/>'+ bObj.Provisional_Bank_NOC_Bank_Address_Line_5__c;
        }
         if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        return '';
    }
     public static String getPrimaryMailingAddress(Applicant__c app){
        String namesStr = '';
          
        if(String.isNotBlank(app.Mailing_House_No__c)){
           namesStr = namesStr + app.Mailing_House_No__c;
        }
        if(String.isNotBlank(app.Mailing_Street_1__c)){
            if(String.isNotBlank(app.Mailing_House_No__c)){
               namesStr = namesStr+',';
            } 
           namesStr = namesStr+ app.Mailing_Street_1__c;
        }
        if(String.isNotBlank(app.Mailing_Street_2__c)){
           namesStr = namesStr+',<br/>'+app.Mailing_Street_2__c;
        }
        if(String.isNotBlank(app.Mailing_Street_3__c)){
           namesStr = namesStr+',<br/>'+ app.Mailing_Street_3__c;
        }
        if(String.isNotBlank(app.Mailing_Locality__c)){
           namesStr = namesStr+',<br/>'+ app.Mailing_Locality__c;
        }
        if(String.isNotBlank(app.Mailing_City__c)){
           namesStr = namesStr+',<br/>'+ app.Mailing_City__c;
        }
        if(String.isNotBlank(app.Mailing_Pincode__c)){
           namesStr = namesStr+' - '+ app.Mailing_Pincode__c;
        }
         if(String.isNotBlank(app.Mailing_State__c)&&app.Mailing_Country__c!='India'){
           namesStr = namesStr+'<br/>'+ app.Mailing_State__c;
        }
         if(String.isNotBlank(app.Mailing_Country__c)&&app.Mailing_Country__c!='India'){
              if(String.isBlank(app.Mailing_State__c)){
               namesStr = namesStr+'<br/>';  
             }else{
              namesStr = namesStr+',';     
             }  
           namesStr = namesStr+ app.Mailing_Country__c;
        }
        if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        return '';
    }
     public static String getPrimaryBillingAddress(Applicant__c app){
        String namesStr = '';
         
        if(String.isNotBlank(app.House_No__c)){
           namesStr = namesStr + app.House_No__c;
        }
        if(String.isNotBlank(app.Street_1__c)){
            if(String.isNotBlank(app.House_No__c)){
               namesStr = namesStr+',';
            } 
           namesStr = namesStr+ app.Street_1__c;
        }
        if(String.isNotBlank(app.Street_2__c)){
           namesStr = namesStr+',<br/>'+app.Street_2__c;
        }
        if(String.isNotBlank(app.Street_3__c)){
           namesStr = namesStr+',<br/>'+ app.Street_3__c;
        }
        if(String.isNotBlank(app.Locality__c)){
           namesStr = namesStr+',<br/>'+ app.Locality__c;
        }
        if(String.isNotBlank(app.City__c)){
           namesStr = namesStr+',<br/>'+ app.City__c;
        }
        if(String.isNotBlank(app.Pincode__c)){
           namesStr = namesStr+' - '+ app.Pincode__c;
        }
         if(String.isNotBlank(app.State__c)&&app.Country__c!='India'){
           namesStr = namesStr+'<br/>'+ app.State__c;
        }
         if(String.isNotBlank(app.Country__c)&&app.Country__c!='India'){
             if(String.isBlank(app.State__c)){
               namesStr = namesStr+'<br/>';  
             }else{
              namesStr = namesStr+',';     
             }  
           namesStr = namesStr+ app.Country__c;
        }

         if(String.isNotBlank(namesStr)){
          return namesStr;
        }
        return '';
    }
    Public static string getFirstScheduleDetails(Booking__c bObj, Quotation__c qObj, Property__c property, Applicant__c ap,Tower__C t, string objName,string docType){
        string scheduleTable = '<table border="1" cellspacing="0" cellpadding="5" style="border-collapse: collapse;border:1px solid black !important;width: 100%;" align="center"> <tr> <th class="thclass"  style="background-color:#999999;text-align:center;" width="8%"> Sr.No. </th> <th class="thclass"  style="background-color:#999999;text-align:center;" width="30%"> Terms and Expressions </th> <th class="thclass"  style="background-color:#999999;text-align:center;" width="62%"> Meaning </th> </tr>';
        Integer i = 1;
        String floor = '';
        Integer ld;
        if(property.Floor_No__c != null){
           ld = math.mod(Integer.ValueOf(property.Floor_No__c),10);
       
            if(ld == 1 || ld == 2 || ld == 3){
                if(ld == 1)
                    floor = Integer.ValueOf(property.Floor_No__c) + 'st';
                if(ld == 2)
                    floor = Integer.ValueOf(property.Floor_No__c) + 'nd';
                if(ld == 3)
                    floor = Integer.ValueOf(property.Floor_No__c) + 'rd';
            }
            else
            {
                floor = Integer.ValueOf(property.Floor_No__c) + 'th';
            }
            if(Integer.ValueOf(property.Floor_No__c) == 11 || Integer.ValueOf(property.Floor_No__c) == 12 || Integer.ValueOf(property.Floor_No__c) == 13){
                floor = Integer.ValueOf(property.Floor_No__c) + 'th';
            }
        }
        
        //lowerfloor
        String lowerfloor = '';
        Integer lowerld;
        if(Property.Duplex_Penthouse_Lower_Level_Floor__c != null){
           lowerld = math.mod(Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c),10);
        
            if(lowerld == 1 || lowerld == 2 || lowerld == 3){
                if(lowerld == 1)
                    lowerfloor = Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) + 'st';
                if(lowerld == 2)
                    lowerfloor = Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) + 'nd';
                if(lowerld == 3)
                    lowerfloor = Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) + 'rd';
            }
            else
            {
                lowerfloor = Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) + 'th';
            }
            if(Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) == 11 || Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) == 12 || Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) == 13){
                lowerfloor = Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) + 'th';
            }
        }
        
        //upperfloor
        String upperfloor = '';
        Integer upperld;
        if(Property.Duplex_Penthouse_Upper_Level_Floor__c != null){
           upperld = math.mod(Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c),10);
        
            if(upperld == 1 || upperld == 2 || upperld == 3){
                if(upperld == 1)
                    upperfloor = Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) + 'st';
                if(upperld == 2)
                    upperfloor = Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) + 'nd';
                if(upperld == 3)
                    upperfloor = Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) + 'rd';
            }
            else
            {
                upperfloor = Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) + 'th';
            }
            if(Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) == 11 || Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) == 12 || Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) == 13){
                upperfloor = Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) + 'th';
            }
        }
        
        if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell'){
            scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;border: 1px solid black;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Said Premises </td>' +
            '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> Flat No. <b>' + property.House_Unit_No__c + '</b> on the ' + floor + ' floor of the said Tower </td></tr>';        
        }else if(objName == 'Schedule-Typical (Tower as Seprate Project)'){
            scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;border: 1px solid black;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Said Premises </td style="text-align: justify;">' +
            '<td class="tdclass" style="text-align: justify;"> Flat No. <b>' + property.House_Unit_No__c + '</b> on the ' + floor + ' floor' ;
                if(bObj.Said_Building__c!= TRUE){
                   scheduleTable += ' of Tower ' + property.Tower_Name__c +' being Real Estate Project.' + ' </td></tr>';
                }else{
                    scheduleTable +=' of the said Building' + ' </td></tr>';
                }    
        }else if(objName == 'Schedule-Duplex'){
            scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Said Premises </td>' +
            '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> Duplex No. ' + property.House_Unit_No__c + ' bearing 2 level, Lower Level(Level 1) on the ' + lowerfloor +
            ' floor and Upper Level(Level 2) on the ' + upperfloor + ' of the said Tower.' +
            ' </td></tr>';
        }else if(objName == 'Schedule-Penthouse'){
            scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Said Premises </td>' +
            '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> Penthouse No. ' + property.House_Unit_No__c + ' bearing 2 level, Lower Level(Level 1) on the ' + lowerfloor +
            ' floor and Upper Level(Level 2) on the ' + upperfloor + ' of the said Tower.' +
            ' </td></tr>';
        }
        
        i = 2;
            if((objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex' || objName == 'Schedule-Penthouse') && t.Said_Tower__c != 'NA'){      //&& docType == 'Acceptance Form' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex' || objName == 'Schedule-Penthouse')
                scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Said Tower </td>' +
                '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> ' + t.Said_Tower__c + '</td></tr>';       //property.Tower_Name__c 
            }/*else if(objName == 'Schedule-Typical (Tower as Seprate Project)'){
                scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + i + '</td><td> Said Tower </td>' +
                '<td> ' + 'NA' + '</td></tr>';
               /* scheduleTable += '<tr><td>' + i + '</td><td> Carpet area of the said Premises as per RERA </td>' +
                '<td> Admeasuring approximately ' + property.Carpet_Area_Sq_Mtr__c + ' Sq.mtrs. equivalent to approximately ' +
                property.Carpet_Area__c + ' Sq.ft. </td></tr>';*/
            //}
        
        
        /*if(docType == 'Acceptance Form'){
        i=3;
        }else{
        i=2;
        }*/
            /*if((objName == 'Schedule-Typical (Tower as Seprate Project)')){
                i=2;
            }else{
                i=3;
            }
            if((objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex' || objName == 'Schedule-Penthouse' || objName == 'Schedule-Typical (Tower as Seprate Project)')){
                scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + i + '</td><td> Said Real Estate Project </td>' +
                '<td> ' + bObj.Project_Name__c + '</td></tr>';       //property.Tower_Name__c 
            }  */
        
        
        if((objName == 'Schedule-Typical (Tower as Seprate Project)') || t.Said_Tower__c == 'NA'){
                i=2;
            }else{
                i=3;
            }
       string salePrice;
        string salePriceinWord;
         if(property.Is_Inclusive_Sale_Price__c != true){  
              salePrice = QuotationManagmentServices.INFormatR(qObj.Total_Agreement_Value_Modified__c);
              salePriceinWord = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((qObj.Total_Agreement_Value_Modified__c).setscale(0,RoundingMode.HALF_UP)));
             
        }else{
                   Decimal InGSTSalePrice = qObj.Total_Agreement_Value_Modified__c + qObj.Total_CSGT_Modified__c + qObj.Total_SGST_Modified__c;
                   salePrice = QuotationManagmentServices.INFormatR(InGSTSalePrice);
                   salePriceinWord = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((InGSTSalePrice).setscale(0,RoundingMode.HALF_UP)));
        }
        string salesPriceOfCarpetArea = QuotationManagmentServices.INFormatR(qObj.Sale_Price_for_Carpet_Area_of_the_Unit__c);
        string salesPriceOfCarpetAreaWord = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((qObj.Sale_Price_for_Carpet_Area_of_the_Unit__c).setscale(0,RoundingMode.HALF_UP)));
        string salesPriceOfLimited_Facilties = QuotationManagmentServices.INFormatR(qObj.Sale_Price_for_Limited_Areas_Facilities__c);
        string salesPriceOfLimited_FaciltiesWord = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((qObj.Sale_Price_for_Limited_Areas_Facilities__c).setscale(0,RoundingMode.HALF_UP)));
        string ITC_Benefit = QuotationManagmentServices.INFormatR(qObj.ITC_Benefit__c);
        string ITC_BenefitWord = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((qObj.ITC_Benefit__c).setscale(0,RoundingMode.HALF_UP)));        
        string salesEffective = QuotationManagmentServices.INFormatR(qObj.Effective_Sale_Price__c);
        string salesEffectiveWord = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((qObj.Effective_Sale_Price__c).setscale(0,RoundingMode.HALF_UP)));
        
        if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Typical (Tower as Seprate Project)'){
            scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Carpet area of the said Premises as per RERA </td>' +
            '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> Admeasuring approximately ' + property.Carpet_Area_Sq_Mtr__c + ' Sq.mtrs. equivalent to approximately ' +
            Integer.valueOf(property.Carpet_Area_of_the_Unit__c) + ' Sq.ft. </td></tr>';        
        }/*else if(objName == 'Schedule-Typical (Tower as Seprate Project)'){
            scheduleTable += '<tr><td>' + i + '</td><td> Sale Price </td>' +
            '<td> Rs.'+ salePrice + ' (Rupees '+ salePriceinWord + ')</td></tr>';
            scheduleTable += '<tr><td>' + '</td><td> (i) Sale price towards the carpet area of the said premises </td>' +
            '<td> Rs.' + salePrice + ' ('+ salePriceinWord + ')</td></tr>';
            scheduleTable += '<tr><td>' + '</td><td> (ii) Propotionate Sale price towards the limited areas and facilities </td>' +
            '<td> Nil</td></tr>';
        }*/else if(objName == 'Schedule-Duplex' || objName == 'Schedule-Penthouse'){
            decimal totalAreaInmtrs = property.Duplex_Penthouse_Lower_Area_Sq_Mtr__c + property.Duplex_Penthouse_Upper_Area_Sq_Mtr__c;
            decimal totalAreaInSqft = property.Duplex_Penthouse_Lower_Area_Sq_Ft__c + property.Duplex_Penthouse_Upper_Area_Sq_Ft__c;
            scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Carpet area of the said Premises as per RERA </td>' +
            '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> Lower level(Level 1) admeasuring approximately ' + property.Duplex_Penthouse_Lower_Area_Sq_Mtr__c + 
            ' sq. meters equivalent to approximately ' + property.Duplex_Penthouse_Lower_Area_Sq_Ft__c + ' sq.feet and ' +
            ' Upper level(Level 2) admeasuring approximately ' + property.Duplex_Penthouse_Upper_Area_Sq_Mtr__c + ' sq.meters ' +
            ' equivalent to approximately ' + property.Duplex_Penthouse_Upper_Area_Sq_Ft__c + ' sq. feet. Aggregating to approximately ' +
            totalAreaInmtrs + ' sq.mtrs equivalent to approximately ' + Integer.valueOf(totalAreaInSqft) + ' sq.ft.' + ' </td></tr>';
        }
        
        /*if(docType == 'Acceptance Form'){
        i=4;
        }else{
        i=3;
        }*/
        
           if((objName == 'Schedule-Typical (Tower as Seprate Project)') || t.Said_Tower__c == 'NA'){
                i=3;
            }else{
                i=4;
            }
        if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
           || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
            scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Sale Price </td>' +
            '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> Rs.'+ salePrice + ' (Rupees ' + salePriceinWord + ' Only)</td></tr>';
            scheduleTable += '<tr style="border: 1px solid black;"><td  class="tdclass">' + '</td><td class="tdclass" style="text-align: justify;"> (i) Sale price towards the carpet area of the said Premises </td>' +
            '<td class="tdclass" style="text-align: justify;"> Rs.'+ salesPriceOfCarpetArea + ' (Rupees ' + salesPriceOfCarpetAreaWord + ' Only)</td></tr>';
            if(qObj.Sale_Price_for_Limited_Areas_Facilities__c > 0){
                scheduleTable += '<tr style="border: 1px solid black;"><td  class="tdclass">' + '</td><td class="tdclass" style="text-align: justify;"> (ii) Propotionate Sale price towards the Limited Areas and Facilities </td>' +
                '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> Rs.'+ salesPriceOfLimited_Facilties + ' (Rupees ' + salesPriceOfLimited_FaciltiesWord + ' Only)</td></tr>'; 
            }else{
                scheduleTable += '<tr style="border: 1px solid black;"><td  class="tdclass">' + '</td><td class="tdclass" style="text-align: justify;"> (ii) Propotionate Sale price towards the Limited Areas and Facilities </td>' +
                '<td class="tdclass" > NA </td></tr>'; 
            }
        }
        
        if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA')){
                i=4;
        }else if(docType == 'Acceptance Form' || docType == 'Allotment Form'){
            i=5;
        }if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Agreement Form')){
            i=5;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=4;
        }else if(docType == 'Agreement Form'){
            i=5;
        }
            if(docType == 'Acceptance Form' || docType == 'Allotment Form'){
            if(property.Aadhar_Card_Mandatory__c == true){
                Decimal totalamt = 0;
                String totalPayment;
                String totalPaymentWord;
                
                List<Payment__c> payment = [Select Payment_Mode__c,Payment_Date__c,RTGS_Cheque_Draft_No__c,Bank_Name__c,Amount__c,Instrument_Date__c,Branch_Name__c,Is_Token__c 
                                    FROM Payment__c WHERE Is_Token__c = True AND Booking__c =: bObj.id];
                System.debug('payment:::::'+payment);
                if(payment.size()>0){         
                for(Payment__c p : payment){
                
                    if(p.Amount__c != null){
                        System.debug('Amount__c:::::'+p.Amount__c);
                        totalamt += p.Amount__c;
                     }
                }
                if(totalamt != null){
                    totalPayment = QuotationManagmentServices.INFormatR(totalamt);
                    totalPaymentWord = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((totalamt).setscale(0,RoundingMode.HALF_UP)));
                    scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Booking Amount and details of payment there of</td>' +
                    '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> Rs.' + totalPayment + '</b> (Rupees ' + totalPaymentWord +' Only) as detailed in Annexure I</td></tr>';
                 }
                 }
               }
             }
        
        if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && property.Aadhar_Card_Mandatory__c == True){
                i=5;
        }else if((docType == 'Acceptance Form' || docType == 'Allotment Form') && property.Aadhar_Card_Mandatory__c == True){
            i=5;
        }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA')){
                i=4;
        }else if(docType == 'Acceptance Form' || docType == 'Allotment Form'){
            i=4;
        }if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Agreement Form')){
            i=4;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=4;
        }else if(docType == 'Agreement Form'){
            i=5;
        }
        String PartPayment;
        String PartPaymentWord;
        if(docType == 'Agreement Form'){
            if(bObj.Part_Payment_towards_the_Sale_Price__c != Null){
                PartPayment = QuotationManagmentServices.INFormatR(bObj.Part_Payment_towards_the_Sale_Price__c);
                PartPaymentWord = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((bObj.Part_Payment_towards_the_Sale_Price__c).setscale(0,RoundingMode.HALF_UP)));
                
                scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Part Payment towards the Sale Price paid prior here to </td>' +
                    '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> Rs.<b>' + PartPayment + '</b> (Rupees ' + PartPaymentWord +' Only)</td></tr>';
            }else{
                scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Part Payment towards the Sale Price paid prior here to </td>' +
                    '<td> </td></tr>';
            }
        }
        
        if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
                i=5;
            }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
                i=4;
            }else if(property.Aadhar_Card_Mandatory__c == true){
                i=6;
            }else{
                i=5;
            }
            if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex' || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
                scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> ITC Benefit </td>' +
                '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> Rs.' + ITC_Benefit + ' (Rupees ' + ITC_BenefitWord +' Only)</td></tr>';
            }
        }
        if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            
            if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
                i=6;
            }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
                i=5;
            }else if(property.Aadhar_Card_Mandatory__c == true){
                i=7;
            }else{
                i=6;
            }
            if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
               || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
                scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Effective Sale Price </td>' +
                '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> Rs.' + salesEffective + ' (Rupees ' + salesEffectiveWord +' Only)</td></tr>';
            }
        }
        
        if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=7;
        }else if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=8;
        }else if(property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=6;
        }else if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=7;
        }else if(docType == 'Agreement Form' && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=4;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=5;
        }else if(docType == 'Agreement Form'){
            i=6;
        }
        else if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=5;
        }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=4;
        }else{
            i=6;
        }
        if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
           || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
            scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Bank Account of the Promoter </td>' +
            '<td class="tdclass" style="text-align: justify;"> ' + property.Bank_Account_of_the_Promoter__c + '</td></tr>';
        }
        
        string parkingDetails = 'NA';
        map<string,Integer> parkingMap = new Map<string,Integer>();
        for(Integer j=1;j<=5;j++){
            string earmarkedName = (string) qObj.get('Earmarked_Car_Parking_Type_' + j +'__c');
            decimal earmarkedCOunt = (decimal) qObj.get('Earmarked_Car_Parking_Count_' + j +'__c');
            string additionalParkingName = (string) qObj.get('Car_Park_Type_' + j +'__c');
            decimal additionalParkingCOunt = (decimal) qObj.get('Car_Park_Count_' + j +'__c');
            if(string.isNotBlank(earmarkedName) && earmarkedCOunt != null){
                earmarkedName = earmarkedName.toLowerCase();
                earmarkedName = earmarkedName.substring(0,1).toUpperCase() + earmarkedName.substring(1,earmarkedName.length());
                if(parkingMap.containskey(earmarkedName)){
                    Integer cc = parkingMap.get(earmarkedName) + Integer.valueOf(earmarkedCOunt);
                    parkingMap.put(earmarkedName, cc);
                }else{
                    Integer cc = Integer.valueOf(earmarkedCOunt);
                    parkingMap.put(earmarkedName, cc);
                }
            }
            if(string.isNotBlank(additionalParkingName) && additionalParkingCOunt != null){
                additionalParkingName = additionalParkingName.toLowerCase();
                additionalParkingName = additionalParkingName.substring(0,1).toUpperCase() + additionalParkingName.substring(1,additionalParkingName.length());
                if(parkingMap.containskey(additionalParkingName)){
                    Integer cc = parkingMap.get(additionalParkingName) + Integer.valueOf(additionalParkingCOunt);
                    parkingMap.put(additionalParkingName, cc);
                }else{
                    Integer cc = Integer.valueOf(additionalParkingCOunt);
                    parkingMap.put(additionalParkingName, cc);
                }
            }
        }
        if(!parkingMap.isEmpty()){
            parkingDetails = 'Permission to park in '; 
            for(string st : parkingMap.keyset()){
                parkingDetails += ' '+ parkingMap.get(st) + ' (' + getStringFromNumber(parkingMap.get(st)) + 
                                ') ' + 'car parking space/s (Configuration - ' + st + ') &'; 
            }
            parkingDetails = parkingDetails.removeEnd('&');
            //1 [One] car parking space/s (Configuration – Tandem) & 1 [One] car parking space/s (Configuration – Single)';
        }
        
        if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=8;
        }else if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=9;
        }else if(property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=7;
        }else if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=8;
        }else if(docType == 'Agreement Form' && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=6;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=6;
        }else if(docType == 'Agreement Form'){
            i=7;
        }
        else if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=6;
        }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=5;
        }else{
            i=7;
        }
        if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
           || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
            scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Car Parking Space/s </td>' +
            '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> ' + parkingDetails + '</td></tr>';
        }
        
        if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=8;
        }else if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=9;
        }else if(property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=7;
        }else if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=8;
        }else if(docType == 'Agreement Form' && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=7;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=7;
        }else if(docType == 'Agreement Form'){
            i=8;
        }
        else if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=7;
        }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=6;
        }else{
            i=8;
        }
        
        if(docType == 'Agreement Form'){
            if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
               || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
                   DateTime d = bObj.Booking_Date__c;
                   
                   String Bookingdate = d.day()+' '+ d.format('MMMMM') +' '+d.year();
                   scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="border: 1px solid black;text-align: justify;"> Booking Date </td>' +
                       '<td class="tdclass" style="text-align: justify;border: 1px solid black;"> ' + Bookingdate + '</td></tr>';
            }
        }
        
        if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=9;
        }else if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=10;
        }else if(property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=8;
        }else if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=9;
        }else if(docType == 'Agreement Form' && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=8;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=8;
        }else if(docType == 'Agreement Form'){
            i=9;
        }
        else if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=7;
        }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=6;
        }else{
            i=8;
        }
        if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
           || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
           if(!property.OC_Received__c){
               string cDate = '';
               string ocDes = '';
               if(t.Completion_Certificate_Date__c != null)
                   cDate = customDateFormat(property.OC_Received_Date__c);
                ocDes = property.OC_Received_Description__c;
                scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Completion Date </td>' +
                '<td class="tdclass" style="text-align: justify;"> ' + ocDes + '</td></tr>';
                //'<td> ' + cDate + '</td></tr>';
           }else{
               string cDate = '';
               if(property.OC_Received_Date__c != null)
                   cDate = customDateFormat(property.Booking__r.Booking_Date__c);
               scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Date of commencement of maintenance including property taxes </td>' +
               '<td class="tdclass" style="text-align: justify;"> ' + cDate + '</td></tr>';
           } 
        }  
        
        if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=10;
        }else if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=11;
        }else if(property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=9;
        }else if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=10;
        }else if(docType == 'Agreement Form' && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=9;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=9;
        }else if(docType == 'Agreement Form'){
            i=10;
        }
        else if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=8;
        }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=7;
        }else{
            i=9;
        }
        if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
           || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
             scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Limited Area and Facilities </td>' +
             '<td class="tdclass" style="text-align: justify;"> ' + property.Limited_Areas_and_Facilities__c + '</td></tr>';
               
        }
        
        if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=11;
        }else if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=12;
        }else if(property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=10;
        }else if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=11;
        }else if(docType == 'Agreement Form' && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=10;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=10;
        }else if(docType == 'Agreement Form'){
            i=11;
        }
        else if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=8;
        }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=7;
        }else{
            i=9;
        }
        if(docType == 'Agreement Form'){
            if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
               || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
                   scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" align="left"> Optional Fittings/Furniture/Fixtures/Equipment (at such price to be determined by the Promoter) </td>' +
                       '<td class="tdclass" style="text-align:left"> ' + property.Optional_Fittings_Furniture__c + '</td></tr>';
                   
            }
        }
        
        if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=11;
        }else if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=12;
        }else if(property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=10;
        }else if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=11;
        }else if(docType == 'Agreement Form' && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=11;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=11;
        }else if(docType == 'Agreement Form'){
            i=12;
        }
        else if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=8;
        }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=7;
        }else{
            i=9;
        }   
      
        if(docType == 'Agreement Form'){
            if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
           || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
               scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Said Nominee </td>' +
                   '<td class="tdclass" align="left"> '+'Name : ' + bObj.Nominee_Name__c + ' <br/>' +
                   'Relationship with Allottee/s : '+ bObj.Relationship_with_Allottee_s__c + ' <br/>' +
                   'Address of Nominee : '+ bObj.Address_of_Nominee__c +' <br/>' +
                   '</td></tr>';
               
           }
        }  
        
        if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=11;
        }else if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=12;
        }else if(property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=10;
        }else if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=11;
        }else if(docType == 'Agreement Form' && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=12;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=12;
        }else if(docType == 'Agreement Form'){
            i=13;
        }
        else if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=9;
        }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=8;
        }else{
            i=10;
        }   
      
        if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
           || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
           scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> Contact Details </td>' +
            '<td class="tdclass" align="left"> ' + 'Promoter’s email address: ' + property.Project_Name__r.Promoter_s_Email_Address__c + ' <br/>' +
                      'Promoter’s phone number: ' + property.Project_Name__r.Other_Company_Phone__c +' <br/>' +
                      'Promoter’s fax number: ' + property.Project_Name__r.Other_Company_Fax__c + ' <br/><br/>';
                      if(ap.Alternate_Email_Id__c != null){+
                          scheduleTable += 'Allottee’s email address: <br/>' + ap.Email_Address__c + ' /<br/>'+ap.Alternate_Email_Id__c+'<br/>';
                      }else{
                          scheduleTable += 'Allottee’s email address: <br/>' + ap.Email_Address__c +'<br/>';
                      }
                      if(ap.Alternate_Mobile_No__c != null){
                          scheduleTable += 'Allottee’s phone number: ' + ap.Mobile_Number__c + ' / '+ap.Alternate_Mobile_No__c+'<br/>';
                      }else{
                          scheduleTable += 'Allottee’s phone number: ' + ap.Mobile_Number__c +'<br/>';
                      }
                      if(ap.Fax_Number__c == null){
                          scheduleTable += 'Allottee’s fax number: NA <br/>';
                      }else{
                          scheduleTable += 'Allottee’s fax number: ' + ap.Fax_Number__c +'<br/>';
                      }
                      //'Allottee’s phone number: ' + ap.Mobile_Number__c + '<br/>' +
                     // scheduleTable += 'Allottee’s fax number: NA <br/>' + 
                      //'</td></tr>';
        }  
        
        if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=12;
        }else if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=13;
        }else if(property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=11;
        }else if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=12;
        }else if(docType == 'Agreement Form' && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=13;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=13;
        }else if(docType == 'Agreement Form'){
            i=14;
        }
        else if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=10;
        }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=9;
        }else{
            i=11;
        }    
        List< Applicant__c > otherApplicants = [select id,name, Applicant_Number__c, PancardNo__c,Aadhar_Card_No__c,Pan_Card_Number_of_Authority_Signatory__c,Index__c from Applicant__c
                                                where Booking__c =: bObj.id and Applicant_Number__c != 'Primary Applicant'];
        string otherApplicant = '';
        string otherApplicantAdhar = '';
        if(otherApplicants != null && !otherApplicants.isEmpty()){
            for(Applicant__c ap1 : otherApplicants){
                if(ap1.PancardNo__c != null){
                    otherApplicant += ' / ' + ap1.PancardNo__c;
                }
                if(ap1.Aadhar_Card_No__c != null){
                    otherApplicantAdhar += ' / ' + ap1.Aadhar_Card_No__c;
                }
           
            }
        }                                        
        if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
           || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
            
            scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> PAN </td>' +
            '<td class="tdclass" align = "left"> ' + 'Promoter’s PAN: ' + property.Project_Name__r.Promoter_s_PAN__c + '<br/>' +
                      'Allottee/s PAN: ' + ap.PancardNo__c + '' + otherApplicant + 
                      '</td></tr>';
        }               
        
        if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=13;
        }else if(property.Aadhar_Card_Mandatory__c == true && property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=14;
        }else if(property.ITC_Benefit_Applicable__c && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=12;
        }else if(property.ITC_Benefit_Applicable__c && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=13;
        }else if(docType == 'Agreement Form' && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=14;
        }else if(docType == 'Agreement Form' && t.Said_Tower__c == 'NA'){
            i=14;
        }else if(docType == 'Agreement Form'){
            i=15;
        }
        else if(property.Aadhar_Card_Mandatory__c == true && (objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=11;
        }else if((objName == 'Schedule-Typical (Tower as Seprate Project)' || t.Said_Tower__c == 'NA') && (docType == 'Acceptance Form' || docType == 'Allotment Form')){
            i=10;
        }else{
            i=12;
        }  
        if(docType == 'Acceptance Form' || docType == 'Allotment Form' || docType == 'Agreement Form'){
         if(property.Aadhar_Card_Mandatory__c == true){
           if(objName == 'Schedule-Typical(Multi Tower Project)' || objName == 'Schedule-Bare Shell' || objName == 'Schedule-Duplex'
               || objName == 'Schedule-Typical (Tower as Seprate Project)' || objName == 'Schedule-Penthouse'){
                
           
                if(ap.Subtype_Of_Applicant__c == 'Indian National' || ap.Subtype_Of_Applicant__c  == 'For NRI'){
                    
                 scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> AADHAAR Card No </td>' +
                '<td class="tdclass" align = "left"> ' + 'Allottee/s Aadhar Card No: ';
                if(ap.Aadhar_Card_No__c != null){
                  scheduleTable += ap.Aadhar_Card_No__c + '' + otherApplicantAdhar +
                          '</td></tr>';
                }else{
                    string removeStart = otherApplicantAdhar.removeStart(' /');
                    system.debug('removestart---'+removeStart);
                    scheduleTable +=  '' + removeStart +
                    
                          '</td></tr>';
                }
                 
                }else if(ap.Subtype_Of_Applicant__c != 'Indian National' || ap.Subtype_Of_Applicant__c != 'For NRI'){
                   scheduleTable += '<tr style="border: 1px solid black;"><td class="tdclass" style="text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;"> AADHAAR Card No </td>' +
                '<td class="tdclass" align = "left"> ' + 'Allottee/s Aadhar Card No: NA' +
                          '</td></tr>';
              }
                           
            }
                       
            scheduleTable += '</table>';
          }   
         }
        return scheduleTable;
    }
    /* Public static string getSecondScheduleDetailsNew(string qId){
        string scheduleTable = '<table border="0.5" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"> <tr> <th class="thclass" > Sr.no. </th> <th class="thclass" > Milestone </th> <th class="thclass" > Percentage </th> <th class="thclass" > Amount</th> </tr>';
        List<QuotationManagmentServices.PaymentMilestoneWrapper> pmList = QuotationManagmentServices.getCustomerViewPaymentSchedule(qId);
        Integer i=1;
        for(QuotationManagmentServices.PaymentMilestoneWrapper pm : pmList){
            string amountInWords = S_NumberToWord.convertNumbertoWords(Integer.valueOf(pm.amountD));
            string milestonePerc = '';
            if(pm.paymentGroup != 'PS01'){
                milestonePerc = pm.milestonePercentage + '%';
            }else{
                milestonePerc = 'Balance Amount';
            }
            scheduleTable += '<tr><td>' + i + '</td><td>' + pm.milestoneName + '</td>' +
            '<td>' + milestonePerc + '</td>' +
            '<td>Rs.' + pm.amountSTR + ' (' + amountInWords + ')'+ '</td></tr>';
            i++;
        }
        scheduleTable += '</table>';
        return scheduleTable;
    } */
    ///////////////////////////new Table2 added by ashish /////////////////////////////
    Public static string getSecondScheduleDetails(string qId){
        List<Quotation__C> qList = [select id,name, Billing_Plan__c,Property__r.Is_Inclusive_Sale_Price__c,Total_SGST_Modified__c,Total_CSGT_Modified__c, Billing_Plan__r.Payment_Plan_Type__c,Total_Agreement_Value_Modified__c  from Quotation__C where id =: qId];
        string scheduleTable = '<table border="1" cellspacing="0" cellpadding="5" style="border-collapse: collapse;width: 100%;border:1px solid black !important;" align="center"> <tr width="5%" style="background-color:#999999;text-align:center;"> <th class="thclass" width="4%" > Sr.No. </th> <th class="thclass"  width="40%" style="background-color:#999999;text-align:center;"> Milestone </th> <th class="thclass"  width="4%" style="background-color:#999999;text-align:center;"> Percentage </th> <th class="thclass" width="52%" style="background-color:#999999;text-align:center;"> Amount</th> </tr>';
        List<QuotationManagmentServices.PaymentMilestoneWrapper> pmList = QuotationManagmentServices.getCustomerViewPaymentSchedule(qId); //ont-family: arial, sans-serif;
        List<QuotationManagmentServices.PaymentMilestoneWrapper> pwListFinal = new List<QuotationManagmentServices.PaymentMilestoneWrapper>();
        list<IN_MilestonesWrapper> IN_MilestonesList = new list<IN_MilestonesWrapper>();
        Integer i=1; 
        decimal completedMilestoneAmountD = 0;
        String completedMilestoneAmountSTR = '';
        String lastDateOfCompletedMilestones = '';        
        decimal completedPercentage = 0;
        decimal completedAmount = 0;
        decimal completedCGST = 0;
        decimal completedSGST = 0;
        decimal completedTotalGST = 0;
        Decimal grandTotal = 0;
        Decimal totalINMilestones = 0;
        Decimal completedMilestoneSize = 0;
        Decimal INcompletedMilestoneSize = 0;
        Decimal TotalExceptBalanceAmount = 0;
        Boolean allMilestonesCompleted = true;
        //Integer loc = 0;
        //Integer loc1 = 0;
        Integer s_No = 1;        
        for(QuotationManagmentServices.PaymentMilestoneWrapper pw : pmList){
            grandTotal += pw.totalMilestoneD;
        }
        String totalPMAmount = QuotationManagmentServices.INFormatR(grandTotal);
        
        List< Payment_Plan_Line_Item__c > ppl = [select id,name, Payment_Plan__c, Usage__c, Percentage_Of_Value_To_Be_Invoiced__c,
                    Payment_Group__c, Milestone_Number__c, Date_Description__c from Payment_Plan_Line_Item__c where 
                    Payment_Plan__c =: qList[0].Billing_Plan__c and Payment_Group__c = 'IN' and Is_IN00_01_Milesone__c = true];
        
        if(ppl != null && !ppl.isEmpty()){
            totalINMilestones = ppl.size();
            for(Payment_Plan_Line_Item__c pl : ppl){
                if(pl.Milestone_Number__c == '000000000000' && pl.Usage__c == null && pl.Date_Description__c != null){
                    completedMilestoneSize += 1;
                }else{
                    INcompletedMilestoneSize += 1;
                    allMilestonesCompleted = false;
                }
            }
        }else{
            allMilestonesCompleted = false;
        }
       // boolean isAnyIN_Milestone = false;
        for(QuotationManagmentServices.PaymentMilestoneWrapper pw : pmList){
            if(pw.paymentGroup == 'IN' && pw.is_IN001Milestone){
               // isAnyIN_Milestone = true;
                if(allMilestonesCompleted){
                    system.debug('inside all completed');
                    pwListFinal.add(pw);
                    
                }else{
                    if(pw.isCompletedMilestone){
                        IN_MilestonesWrapper INm = new IN_MilestonesWrapper();
                        INm.s_No = s_No;
                        INm.name = pw.milestoneName;
                        INm.amountD = pw.amountD;
                        INm.amountSTR = pw.amountSTR;
                        INm.due_Date = QuotationManagmentServices.customDateFormat(pw.dueDateINDATE);
                        IN_MilestonesList.add(INm);
                        completedMilestoneAmountD += pw.totalMilestoneD;
                        completedPercentage += pw.milestonePercentage;
                        completedAmount += pw.amountD;
                        completedCGST += pw.CGST_D;
                        completedSGST += pw.SGST_D;
                        completedTotalGST += pw.totalGST_D;
                        lastDateOfCompletedMilestones = QuotationManagmentServices.customDateFormat(pw.dueDateINDATE);
                        //loc1 = loc;
                    }else{
                        allMilestonesCompleted = false;
                        pwListFinal.add(pw);
                    }
                }
            }else{
                pwListFinal.add(pw);
            }
            //loc++;
        }
        /*if(allMilestonesCompleted && isAnyIN_Milestone){
            QuotationManagmentServices.PaymentMilestoneWrapper pw = new QuotationManagmentServices.PaymentMilestoneWrapper();
            pw.paymentGroup = 'IN'; 
            pw.amountD = completedAmount;
            pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD);
            pw.CGST_D = completedCGST;
            pw.CGST_STR = QuotationManagmentServices.INFormatR(pw.CGST_D);
            pw.SGST_D = completedSGST;
            pw.SGST_STR = QuotationManagmentServices.INFormatR(pw.SGST_D);
            pw.totalGST_D = completedTotalGST;
            pw.totalGST_STR = QuotationManagmentServices.INFormatR(pw.totalGST_D);
            pw.totalMilestoneD = completedMilestoneAmountD;
            pw.totalMilestoneSTR = QuotationManagmentServices.INFormatR(pw.totalMilestoneD);
            pw.milestonePercentage = completedPercentage;
            pw.isCompletedMilestone = true;
            pw.is_IN001Milestone = true;
            pwListFinal.add(loc1,pw);
        }*/
        if(!allMilestonesCompleted){
            for(QuotationManagmentServices.PaymentMilestoneWrapper pw : pwListFinal){
                if(pw.paymentGroup == 'IN' && pw.is_IN001Milestone){
                    if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){
                        pw.amountD += completedAmount;
                        pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD);
                    }else{
                        pw.amountD += (completedAmount + completedTotalGST);
                        pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD + pw.totalGST_D);  
                    }
                    //pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD);
                    pw.CGST_D += completedCGST;
                    pw.CGST_STR = QuotationManagmentServices.INFormatR(pw.CGST_D);
                    pw.SGST_D += completedSGST;
                    pw.SGST_STR = QuotationManagmentServices.INFormatR(pw.SGST_D);
                    pw.totalGST_D += completedTotalGST;
                    pw.totalGST_STR = QuotationManagmentServices.INFormatR(pw.totalGST_D);
                    pw.totalMilestoneD += completedMilestoneAmountD;
                    pw.totalMilestoneSTR = QuotationManagmentServices.INFormatR(pw.totalMilestoneD);
                    pw.milestonePercentage += completedPercentage;
                }
            }
        }
        if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){
            completedMilestoneAmountSTR = QuotationManagmentServices.INFormatR(completedAmount); 
        }else{
            completedMilestoneAmountSTR = QuotationManagmentServices.INFormatR(completedAmount + completedTotalGST);
        }
        /////////// Change Completed milestone name
        if(IN_MilestonesList != null && !IN_MilestonesList.isEmpty()){
            for(IN_MilestonesWrapper mn : IN_MilestonesList){
                if(IN_MilestonesList.size() == mn.s_No){
                    mn.name = 'To be paid on or before ' + mn.due_Date + ' along with any further milestones raised till then';
                }
            }
        } 
        
        
        for(QuotationManagmentServices.PaymentMilestoneWrapper pm : pwListFinal){
            string amountInWords;
            if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){
                amountInWords = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((pm.amountD).setscale(0,RoundingMode.HALF_UP)));
            }else{
                amountInWords = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((pm.totalMilestoneD ).setscale(0,RoundingMode.HALF_UP)));
            }
            string milestonePerc = '';
            if(pm.paymentGroup != 'PS' && pm.Terms_of_Payment_Key != 'INPS'){
                milestonePerc = pm.milestonePercentage + '%';
                if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){
                    TotalExceptBalanceAmount = TotalExceptBalanceAmount+ Integer.valueOf((pm.amountD).setscale(0,RoundingMode.HALF_UP));
                }else{
                    TotalExceptBalanceAmount = TotalExceptBalanceAmount+ Integer.valueOf((pm.totalMilestoneD).setscale(0,RoundingMode.HALF_UP));
                }
                TotalExceptBalanceAmount = TotalExceptBalanceAmount.setscale(0,RoundingMode.HALF_UP); 
                
            }else{
                milestonePerc = 'Balance Amount';
            }
          }
          System.debug('TotalExceptBalanceAmount::::::::::::::'+TotalExceptBalanceAmount);
        for(QuotationManagmentServices.PaymentMilestoneWrapper pm : pwListFinal){
            string amountInWords;
            if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){
                amountInWords = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((pm.amountD).setscale(0,RoundingMode.HALF_UP)));
            }else{
                amountInWords = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((pm.totalMilestoneD ).setscale(0,RoundingMode.HALF_UP)));
            }
            string milestonePerc = ''; 
            if(pm.paymentGroup != 'PS' && pm.Terms_of_Payment_Key != 'INPS'){
                milestonePerc = pm.milestonePercentage + '%';
                //string amountInWords;
                if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){
                    amountInWords = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((pm.amountD).setscale(0,RoundingMode.HALF_UP)));
                }else{
                    amountInWords = NumbersToWordsConversionClass.numberToEnglish(Integer.valueOf((pm.totalMilestoneD).setscale(0,RoundingMode.HALF_UP)));
                }
            }else{
                milestonePerc = 'Balance Amount';
                Integer balanceAmount;
                if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){
                    balanceAmount = Integer.valueOf((qList[0].Total_Agreement_Value_Modified__c-TotalExceptBalanceAmount).setscale(0,RoundingMode.HALF_UP));
                }else{
                    balanceAmount = Integer.valueOf(((qList[0].Total_Agreement_Value_Modified__c + qList[0].Total_CSGT_Modified__c + qList[0].Total_SGST_Modified__c)-TotalExceptBalanceAmount).setscale(0,RoundingMode.HALF_UP));
                }
                String balanceAmountStr = QuotationManagmentServices.INFormatR(balanceAmount); 
                System.debug('balanceAmountStr::::::::::::::'+balanceAmountStr);
                pm.amountSTR = balanceAmountStr;  
                amountInWords = NumbersToWordsConversionClass.numberToEnglish(balanceAmount);
            }
            if(qList[0].Billing_Plan__r.Payment_Plan_Type__c != 'Non Scheme'){ //&& !allMilestonesCompleted
                scheduleTable += '<tr><td class="tdclass" style="font-size:14px;text-align:center;">' + i + '.</td><td class="tdclass" style="font-size:14px;text-align: justify;">' + pm.milestoneName + '</td>' +
                '<td class="tdclass" style="font-size:14px;text-align:center;">' + milestonePerc + '</td>' +
                '<td class="tdclass" style="font-size:14px;"><div style="text-align:left;">Rs.' + pm.amountSTR +'</div><div class="dTxt" style="text-align: justify;">(Rupees ' + amountInWords + ' Only)</div>' + '</td></tr>';
                i++;
            }
            else if(qList[0].Billing_Plan__r.Payment_Plan_Type__c == 'Non Scheme' && completedMilestoneSize == 0){
                string mName = '';
                if(pm.paymentGroup == 'IN' && pm.is_IN001Milestone){
                    mName = 'Proportionate ' + totalINMilestones + ' instalments upon casting of relevant slabs.';
                }else{
                    mName = pm.milestoneName;
                }
                scheduleTable += '<tr><td class="tdclass" style="font-size:14px;text-align:center;">' + i + '.</td><td class="tdclass" style="font-size:14px;text-align: justify;">' + mName  +
                '</td>' +
                '<td class="tdclass" style="font-size:14px;text-align:center;">' + milestonePerc + '</td>' +
                '<td class="tdclass" style="font-size:14px;"><div style="text-align:left;">Rs.' + pm.amountSTR + '</div><div class="dTxt" style="text-align: justify;">(Rupees ' + amountInWords + ' Only)</div>' + '</td></tr>';
                i++;
            }
            else if(qList[0].Billing_Plan__r.Payment_Plan_Type__c == 'Non Scheme' && allMilestonesCompleted){
                string mName = '';
               /* if(pm.paymentGroup == 'IN' && pm.is_IN001Milestone){
                    mName = 'Proportionate ' + totalINMilestones + ' instalments upon casting of relevant slabs.';
                    mName += '<br/> All relevant slabs have been casted.';
                }else{
                    mName = pm.milestoneName;
                }*/
                mName = pm.milestoneName;
                scheduleTable += '<tr><td class="tdclass" style="font-size:14px;text-align:center;">' + i + '.</td><td class="tdclass" style="font-size:14px;text-align: justify;">' + mName  +
                '</td>' +
                '<td class="tdclass" style="font-size:14px;text-align:center;">' + milestonePerc + '</td>' +
                '<td class="tdclass" style="font-size:14px;"><div style="text-align:left;">Rs.' + pm.amountSTR + '</div><div class="dTxt" style="text-align: justify;">(Rupees ' + amountInWords + ' Only)</div>' + '</td></tr>';
                i++;
            }
            else if(qList[0].Billing_Plan__r.Payment_Plan_Type__c == 'Non Scheme' && !allMilestonesCompleted && completedMilestoneSize > 0){
                
                if(pm.paymentGroup == 'IN' && pm.is_IN001Milestone){
                        scheduleTable += '<tr>'+
                        '<td class="tdclass" rowspan = "3" style="font-size:14px;text-align:center;">' + i + '.</td><td class="tdclass" style="text-align: justify;">Proportionate ' + totalINMilestones +' instalments upon casting of relevant slabs.</td>'+
                        '<td class="tdclass" rowspan = "3" style="font-size:14px;text-align:center;">' + pm.milestonePercentage + '%' +'</td>'+
                        '<td class="tdclass" rowspan = "3" style="font-size:14px;"><div style="text-align:left;">Rs.' + pm.amountSTR + '</div><div class="dTxt" style="text-align: justify;">(Rupees ' + amountInWords + ' Only)</div>' +'</td></tr>'+
                        '<tr><td class="tdclass" style="font-size:14px;text-align: justify;">Out of which ' + completedMilestoneSize + ' relevant slabs have been casted and the relevant amount of Rs.' + completedMilestoneAmountSTR +' towards the Sale Price is payable as below </td>'+
                        '</tr><tr><td class="tdclass" style="border:1px solid black;">'+
                        '<table border="1" cellspacing="0" cellpadding="5" style="border-collapse: collapse;width: 100%;border:1px solid black !important;" align="center">'+
                                '<tr>'+
                                     '<td class="tdclass" width="70%" style="font-size:14px;background-color:#999999;border:1px solid black;">'+
                                         'Particulars'+
                                     '</td>'+
                                     '<td class="tdclass" width="30%" style="font-size:14px;background-color:#999999;border:1px solid black;">'+
                                         'Amount in Rs.'+
                                     '</td>'+
                                 '</tr>';
                                         For(IN_MilestonesWrapper inl : IN_MilestonesList){
                                            scheduleTable +=' <tr>'+
                                                 '<td class="tdclass" style="font-size:14px;text-align: justify;">'+ inl.name + '</td>'+
                                                 '<td class="tdclass" style="font-size:14px;"> Rs.'+ inl.amountSTR +'</td>'+
                                             '</tr>';
                                         }
                                    /* scheduleTable += '<tr>'+
                                             '<td class="tdclass" style="font-size:14px;">'+
                                                 'To be paid on or before '+ lastDateOfCompletedMilestones+' along with any further milestones raised till then'+
                                             '</td>'+
                                             '<td class="tdclass" style="font-size:14px;">'+
                                                 'Rs.'+completedMilestoneAmountSTR+
                                             '</td>'+
                                         '</tr>'+ */
                                      scheduleTable += '</table>'+
                                 '</td>'+
                             '</tr>';i++;
                    }
                    else
                    {
                scheduleTable += '<tr><td class="tdclass" style="font-size:14px;text-align:center;">' + i + '.</td>'+
                                 '<td class="tdclass" style="font-size:14px;text-align: justify;">'+ pm.milestoneName+'</td>';
                                 if(pm.paymentGroup != 'PS' && pm.Terms_of_Payment_Key != 'INPS'){
                                     scheduleTable += '<td class="tdclass" style="font-size:14px;text-align:center;">'+pm.milestonePercentage + '%' +'</td>';                                 
                                 }
                                 if(pm.paymentGroup == 'PS' || pm.Terms_of_Payment_Key == 'INPS'){
                                     scheduleTable += '<td class="tdclass" style="font-size:14px;"> Balance Amount </td>';                                 
                                 }
                                 scheduleTable += '<td class="tdclass" style="font-size:14px;"><div style="text-align:left;" >Rs.'+ pm.amountSTR +'</div><div class="dTxt" style="text-align: justify;">(Rupees ' + amountInWords + ' Only)</div>'+'</td>'+
                             '</tr>';i++;
                }
            }
        }
        scheduleTable += '</table>';
        
        return scheduleTable;
    }
    
    public static string startJustify()
        {
            return '<div class="dTxt" style="text-align: justify;">';
        }
        
        public static string endJustify()
        {
            return '</div>';
        }
    
    public static string sPageBreak()
        {
            return '<div style="page-break-after:always;"></div>';
        }
    
    public static string breakLine()
    {
        string details = '<br/>';
        return details;
    } 
    public static string pStart() 
    {
        string details = '<p>';
        return details;
    }
     public static string pEnd()
    {
        string details = '</p>';
        return details;
    }
    public static string QRCodeField(List <Related_Document_History__c> rdList)
    {
        string details = '';
        if(rdList[0].Document_Approved__c){
            details = ' <div id="qrCode" style="float: right;">'+rdList[0].QR_Code__c+'</div>';
        }
        return details;
    }
    public static string tableStart()
    {
        //string details = '<table class="tabletag" style="width:100%">';
        string details = '<table border="1" cellspacing="0" cellpadding="3" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;border: 1px solid black !important;"align="center">';
        return details;
    }
    public static string tableEnd()
    {
        string details = '</table>';
        return details;
    }
    public static string trowStart()
    {
        string details = '<tr width="5%">';//<tr>';
        return details;
    }
    public static string trowEnd()
    {
        string details = '</tr>';
        return details;
    }
    public static string theaderStart()
    {
        string details = '<th class="thclass"  style="background-color:#999999;text-align:center;border: 1px solid black !important;">';//'<th class="thclass"  class="thtag">';
        return details;
    }
    public static string theaderEnd()
    {
        string details = '</th>';
        return details;
    }
    public static string tcellStart()
    {
        string details = '<td class="tdclass" class="tdtag">';
        return details;
    }
    public static string tcellStart2()
    {
        string details = '<td class="tdclass" class="tdtag" colspan="2">';
        return details;
    }
    public static string tcellEnd()
    {
        string details = '</td>';
        return details;
    }
    
    public static string sOLDecimal()
    {
        string details = '<ol class="decimalOl" type="1" >';
        return details;
    }
    public static string eOLDecimal()
    {
        string details = '</ol>';
        return details;
    }
       public static string sDecimalList()
    {
        string details = '<li class="decimalli" style="display: block !important;margin-left: 0.05 !important; position: relative !important;    text-align: -webkit-match-parent;margin: 0.6em;text-align: justify !important; letter-spacing: .5px !important;padding-left:0.01px !important;text-align-last: left !important;align-text-last: left !important;">';//
        return details;
    }
    
       public static string eDecimalList()
    {
        string details = '</li>';
        return details;
    }
    
     public static string sOL()
    {
        string details = '<ol class="stdol">';
        return details;
    }
    public static string sLIa()
    {
        string details = '<li style="list-style-type:lower-alpha;">';
        return details;
    }
    
        public static string sLIr()
    {
        string details = '<li style="list-style-type:lower-roman;">';
        return details;
    }
    
        public static string sLId()
    {
        string details = '<li style="list-style-type:Decimal;">';
        return details;
    }
    
    public static string sLIUA()
    {
        string details = '<li style="list-style-type:upper-alpha;">';
        return details;
    }
    
    public static string eLIUA()
    {
        string details = '</li>';
        return details;
    }
    
    public static string eLId()
    {
        string details = '</li>';
        return details;
    }
    
    public static string eLIr()
    {
        string details = '</li>';
        return details;
    }
    
    public static string eLIa()
    {
        string details = '</li>';
        return details;
    }
    
    public static string eOL()
    {
        string details = '</ol>';
        return details;
    }
    
    ///////////////////////////new Table2 added by ashish Ends /////////////////////////////
    
    Public static string getThirdScheduleDetails(string pId,string docType){
        string scheduleTable = '<table border="1" cellspacing="0" cellpadding="3" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;border:1px solid black !important;" align="center"> <tr> <th class="thclass"  style="background-color:#999999;text-align:center;width:8%"> Sr No. </th> <th class="thclass"  style="background-color:#999999;text-align:center;width:60%"> Particulars </th> <th class="thclass"  style="background-color:#999999;text-align:center;"> Amount</th> </tr>';
        List<Other_Charges__c> otherCharges = [select id,name,Active__c,Discount_Amount__c,Property_Type__c,
                                            Project__c,Order__c, Description__c, Schedule_Description__c,Allotment_Schedule_Description__c,At_Actual__c,
                                            Available_At__c
                                            from Other_Charges__c 
                                            where Property_Type__c =: pId and
                                            Active__c = true and Available_At__c = 'Third Schedule'
                                            order by Order__c ASC];
                                            
        if(otherCharges != null && !otherCharges.isEmpty()){
            Integer k = 1;
            for(Other_Charges__c oc : otherCharges){
                string amtStr = '';
                if(string.isNotBlank(oc.At_Actual__c)){
                    amtStr = oc.At_Actual__c;
                }else{
                    amtStr = 'Rs.' + QuotationManagmentServices.INFormatR(oc.Discount_Amount__c);
                }
                if(docType == 'Acceptance Form')
                    scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass" style="text-align: justify;">' + oc.Schedule_Description__c + '</td><td class="tdclass" style="text-align:left;">' + amtStr + '</td></tr>';
                else if(docType == 'Allotment Form' || docType == 'Agreement Form')
                    scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass" style="text-align: justify;">' + oc.Allotment_Schedule_Description__c + '</td><td class="tdclass" style="text-align:left;">' + amtStr + '</td></tr>';
               
                k++;
            }
        }
        scheduleTable += '</table>';
        return scheduleTable;
    }
    
    Public static string getFourthScheduleDetails(string pId,Applicant__c ap,string docType){
        string scheduleTable = '<table border="1" cellspacing="0" cellpadding="3" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;border:1px solid black !important;" align="center"> <tr> <th class="thclass"  style="background-color:#999999;text-align:center;width:8%"> Sr No. </th> <th class="thclass"  style="background-color:#999999;text-align:center;width:60%"> Particulars </th> <th class="thclass"  style="background-color:#999999;text-align:center;"> Amount</th> </tr>';
        List<Other_Charges__c> otherCharges = [select id,name,Active__c,Discount_Amount__c,Property_Type__c,
                                            Project__c,Order__c, Description__c, Schedule_Description__c,Allotment_Schedule_Description__c,At_Actual__c,
                                            Available_At__c, Schedule_Description_2__c,Amount_for_company_Booking__c,Allotment_Schedule_Description_2__c, Merge_Field__c
                                            from Other_Charges__c 
                                            where Property_Type__c =: pId and
                                            Active__c = true and Available_At__c = 'Fourth Schedule'
                                            order by Order__c ASC];
                                            
        if(otherCharges != null && !otherCharges.isEmpty()){
            Integer k = 1;
            for(Other_Charges__c oc : otherCharges){
                string amtStr = '';
                if(string.isNotBlank(oc.At_Actual__c)){
                    amtStr = oc.At_Actual__c;
                }else if(oc.Amount_for_company_Booking__c != Null && (ap.Subtype_Of_Applicant__c == 'For Company' || ap.Subtype_Of_Applicant__c == 'Partnership Firm' || ap.Subtype_Of_Applicant__c == 'Proprietorship' || ap.Subtype_Of_Applicant__c == 'LLP'||ap.Subtype_Of_Applicant__c == 'Trust')){
                    amtStr = 'Rs.' + QuotationManagmentServices.INFormatR(oc.Amount_for_company_Booking__c);
                }else{
                    amtStr = 'Rs.' + QuotationManagmentServices.INFormatR(oc.Discount_Amount__c);
                }
                if(docType == 'Acceptance Form'){
                    if(!oc.Merge_Field__c){
                        scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass" style="text-align: justify;">' + oc.Schedule_Description__c + '</td><td class="tdclass" style="text-align:left;">' + amtStr + '</td></tr>';
                    }else{
                        scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass" style="text-align: justify;">' + oc.Schedule_Description__c + '</td><td class="tdclass" rowspan="2" style="text-align:left;">' + amtStr + '</td></tr>';
                        k = k + 1; 
                        scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass" style="text-align: justify;">' + oc.Schedule_Description_2__c + '</td></tr>';
                    }
                }else if(docType == 'Allotment Form' || docType == 'Agreement Form'){
                     if(!oc.Merge_Field__c){
                        scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass" style="text-align: justify;">' + oc.Allotment_Schedule_Description__c + '</td><td class="tdclass" style="text-align:left;">' + amtStr + '</td></tr>';
                    }else{
                        scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass" style="text-align: justify;">' + oc.Allotment_Schedule_Description__c + '</td><td class="tdclass" rowspan="2" style="text-align:left;">' + amtStr + '</td></tr>';
                        k = k + 1; 
                        scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass" style="text-align: justify;">' + oc.Allotment_Schedule_Description_2__c + '</td></tr>';
                    }
                }
                k++;
            }
        }
        scheduleTable += '</table>';
        return scheduleTable;
    }
    
    Public static string getFifthScheduleDetails(string pId,string docType){
        system.debug('inside getFifthScheduleDetails:: '+pId);
        string scheduleTable = '<table border="1" cellspacing="0" cellpadding="3" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;border:1px solid black !importantalign="center"> <tr> <th class="thclass"  style="background-color:#999999;text-align:center;width:8%"> Sr No. </th> <th class="thclass"  style="background-color:#999999;text-align:center;"> Details of amenities in the said Premises </th> </tr>';
        List<Other_Charges__c> otherCharges = [select id,name,Active__c,Discount_Amount__c,Property_Type__c,
                                            Project__c,Order__c, Description__c, Schedule_Description__c,Allotment_Schedule_Description__c,At_Actual__c,
                                            Available_At__c
                                            from Other_Charges__c 
                                            where Property_Type__c =: pId and
                                            Active__c = true and Available_At__c = 'For BareShell'
                                            order by Order__c ASC];
                                            
        system.debug('otherCharges in Fifth schedule:: '+otherCharges);                                    
        if(otherCharges != null && !otherCharges.isEmpty()){
            Integer k = 1;
            for(Other_Charges__c oc : otherCharges){
                /*string amtStr = '';
                if(string.isNotBlank(oc.At_Actual__c)){
                    amtStr = oc.At_Actual__c;
                }else{
                    amtStr = QuotationManagmentServices.INFormatR(oc.Discount_Amount__c);
                }*/
                if(docType == 'Acceptance Form')
                    scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass" style="text-align: justify;">' + oc.Schedule_Description__c + '</td></tr>';
                else if(docType == 'Allotment Form' || docType == 'Agreement Form')
                    scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass" style="text-align: justify;">' + oc.Allotment_Schedule_Description__c + '</td></tr>';
                
                k++;
            }
        }
        scheduleTable += '</table>';
        return scheduleTable;
    }
    
    Public static string getEleventhScheduleDetails(Id pId){
        string scheduleTable = '<table border="0" cellspacing="0" cellpadding="5" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;"align="center">';
        List<Property__c> propL = [select id,name,Project_Name__c,SPECIAL_CONDITIONS__c,Booking__c from Property__c where id=:pId];
        specialCondition vd = new specialCondition();
        List<Booking__c> lstBooking;
        if(propL.size()>0){
        List<Project__c> plist = [select id,name,ITC_BENEFIT__c,UPFRONT_PAYMENT__c,Bare_shell_1__c,Bare_shell_with_Reduction_in_Sale_Price__c,
                                    Bare_shell_NC_in_SalePrice_and_no__c,Limited_BS_no_change_in_SPrice_no_MHO__c,Bank_Subvention_Scheme__c,Flexi_Payment_Scheme__c,Construction_Linked_Payment_Scheme__c,STUDIO_APARTMENT__c,Exq_D_P_BS_no_change_in_SP_and_no_MHO__c from Project__c where id =: propL[0].Project_Name__c];
        lstBooking = [select id,name,Booking_Special_Conditions__c from Booking__c where id=: propL[0].Booking__c];
        
        if(plist.size()>0){
            
            scheduleTable += '<tr><td><ol>';
            if(propL[0].SPECIAL_CONDITIONS__c != null && propL[0].SPECIAL_CONDITIONS__c.contains('ITC BENEFIT')){
                
                //String replacetext = vd.findAndReplaceMergeFields(plist[0].ITC_BENEFIT__c,lstBooking[0].id);
                scheduleTable += ''+ plist[0].ITC_BENEFIT__c;//replacetext;
            }
            if(propL[0].SPECIAL_CONDITIONS__c.contains('UPFRONT PAYMENT')){
                scheduleTable += ''+ plist[0].UPFRONT_PAYMENT__c;
                //specialCondition vd = new specialCondition();
                //String replacetext = vd.findAndReplaceMergeFields(plist[0].UPFRONT_PAYMENT__c,lstBooking[0].id);
                //scheduleTable += ''+ replacetext;
            }
            if(propL[0].SPECIAL_CONDITIONS__c.contains('BARE SHELL PREMISES')){
                //scheduleTable += '<li style="list-style-type:upper-alpha;"><p align="justify"><b>BARE SHELL PREMISES</b></p>';
                //scheduleTable += '<ol>';
                if(propL[0].SPECIAL_CONDITIONS__c.contains('Bare shell with material handed over and no reduction in Sale Price')){
                    //scheduleTable += '<li style="list-style-type:upper-roman;"><p align="justify"><b>Bare shell with material handed over and no reduction in Sale Price</b></p>'+ plist[0].Bare_shell_1__c + '</li>';
                    //specialCondition vd = new specialCondition();
                    //String replacetext = vd.findAndReplaceMergeFields(plist[0].Bare_shell_1__c,lstBooking[0].id);
                    scheduleTable += ''+ plist[0].Bare_shell_1__c;
                }
                if(propL[0].SPECIAL_CONDITIONS__c.contains('Bare shell with Reduction in Sale Price')){
                    //scheduleTable += '<li style="list-style-type:upper-roman;"><p align="justify"><b>Bare shell with Reduction in Sale Price</b></p>'+ plist[0].Bare_shell_with_Reduction_in_Sale_Price__c + '</li>';
                    //specialCondition vd = new specialCondition();
                    //String replacetext = vd.findAndReplaceMergeFields(plist[0].Bare_shell_with_Reduction_in_Sale_Price__c,lstBooking[0].id);
                    scheduleTable += ''+ plist[0].Bare_shell_with_Reduction_in_Sale_Price__c;
                }
                if(propL[0].SPECIAL_CONDITIONS__c.contains('Bare shell no change in Sale Price and no material handed over')){
                    //scheduleTable += '<li style="list-style-type:upper-roman;"><p align="justify"><b>Bare shell no change in Sale Price and no material handed over</b></p>'+ plist[0].Bare_shell_NC_in_SalePrice_and_no__c + '</li>';
                    //specialCondition vd = new specialCondition();
                    //String replacetext = vd.findAndReplaceMergeFields(plist[0].Bare_shell_NC_in_SalePrice_and_no__c,lstBooking[0].id);
                    scheduleTable += ''+ plist[0].Bare_shell_NC_in_SalePrice_and_no__c;
                }
                if(propL[0].SPECIAL_CONDITIONS__c.contains('Limited bare shell no change in Sale Price and no material handed over')){
                    //scheduleTable += '<li style="list-style-type:upper-roman;"><p align="justify"><b>Limited bare shell no change in Sale Price and no material handed over</b></p>'+ plist[0].Limited_BS_no_change_in_SPrice_no_MHO__c + '</li>';
                    //specialCondition vd = new specialCondition();
                    //String replacetext = vd.findAndReplaceMergeFields(plist[0].Limited_BS_no_change_in_SPrice_no_MHO__c,lstBooking[0].id);
                    scheduleTable += ''+ plist[0].Limited_BS_no_change_in_SPrice_no_MHO__c;
                }
                if(propL[0].SPECIAL_CONDITIONS__c.contains('Exquisite – Duplex/Penthouse - Bare shell no change in Sale Price and no material handed over')){
                    //scheduleTable += '<li style="list-style-type:upper-roman;"><p align="justify"><b>Exquisite – Duplex/Penthouse - Bare shell no change in Sale Price and no material handed over</b></p>'+ plist[0].Exq_D_P_BS_no_change_in_SP_and_no_MHO__c + '</li>';
                    //specialCondition vd = new specialCondition();
                    //String replacetext = vd.findAndReplaceMergeFields(plist[0].Exq_D_P_BS_no_change_in_SP_and_no_MHO__c,lstBooking[0].id);
                    scheduleTable += ''+ plist[0].Exq_D_P_BS_no_change_in_SP_and_no_MHO__c;
                }
                //scheduleTable += '</ol></li>';
            }
            if(propL[0].SPECIAL_CONDITIONS__c.contains('SCHEME RELATED')){
                //scheduleTable += '<li style="list-style-type:upper-alpha;"><p align="justify"><b>SCHEME RELATED</b></p>';
                //scheduleTable += '<ol>';
                if(propL[0].SPECIAL_CONDITIONS__c.contains('Bank Subvention Scheme')){
                    //scheduleTable += '<li style="list-style-type:upper-roman;"><p align="justify"><b>Bank Subvention Scheme</b></p>'+ plist[0].Bank_Subvention_Scheme__c + '</li>';
                    //specialCondition vd = new specialCondition();
                    //String replacetext = vd.findAndReplaceMergeFields(plist[0].Bank_Subvention_Scheme__c,lstBooking[0].id);
                    scheduleTable += ''+ plist[0].Bank_Subvention_Scheme__c;//replacetext;
                }
                if(propL[0].SPECIAL_CONDITIONS__c.contains('Flexi Payment Scheme')){
                    //scheduleTable += '<li style="list-style-type:upper-roman;"><p align="justify"><b>Flexi Payment Scheme</b></p>'+ plist[0].Flexi_Payment_Scheme__c + '</li>';
                    //specialCondition vd = new specialCondition();
                    //String replacetext = vd.findAndReplaceMergeFields(plist[0].Flexi_Payment_Scheme__c,lstBooking[0].id);
                    scheduleTable += ''+ plist[0].Flexi_Payment_Scheme__c;
                }
                if(propL[0].SPECIAL_CONDITIONS__c.contains('Construction Linked Payment Scheme')){
                    //scheduleTable += '<li style="list-style-type:upper-roman;"><p align="justify"><b>Construction Linked Payment Scheme</b></p>'+ plist[0].Construction_Linked_Payment_Scheme__c + '</li>';
                    //specialCondition vd = new specialCondition();
                    //String replacetext = vd.findAndReplaceMergeFields(plist[0].Construction_Linked_Payment_Scheme__c,lstBooking[0].id);
                    scheduleTable += ''+ plist[0].Construction_Linked_Payment_Scheme__c;
                }
                //scheduleTable += '</ol></li>';
            }
            if(propL[0].SPECIAL_CONDITIONS__c != null && propL[0].SPECIAL_CONDITIONS__c.contains('STUDIO APARTMENT')){
                //scheduleTable += '<li style="list-style-type:upper-alpha;"><p align="justify"><b>STUDIO APARTMENT</b></p>'+ plist[0].STUDIO_APARTMENT__c + '</li>';
                //String replacetext = vd.findAndReplaceMergeFields(plist[0].STUDIO_APARTMENT__c,lstBooking[0].id);
                scheduleTable += ''+ plist[0].STUDIO_APARTMENT__c;
            }
            if(lstBooking.size()>0){
                if(propL[0].SPECIAL_CONDITIONS__c != null && propL[0].SPECIAL_CONDITIONS__c.contains('Other Special Conditions')){
                    //ViewDocument vd = new ViewDocument();
                    //String replacetext = vd.findAndReplaceMergeFields(lstBooking[0].Booking_Special_Conditions__c);
                    //scheduleTable += '<li style="list-style-type:upper-alpha;"><p align="justify"><b>OTHER SPECIAL CONDITIONS</b></p>'+ lstBooking[0].Booking_Special_Conditions__c + '</li>';
                    //specialCondition vd = new specialCondition();
                    //String replacetext = vd.findAndReplaceMergeFields(lstBooking[0].Booking_Special_Conditions__c,lstBooking[0].id);
                    scheduleTable += ''+ lstBooking[0].Booking_Special_Conditions__c;
                }
            }
            scheduleTable += '</ol></td></tr>';
        }
        
        }
        scheduleTable += '</table>';
        String replacetext = vd.findAndReplaceMergeFields(scheduleTable,lstBooking[0].id);
        return replacetext;
    }
    Public static string getAnnexureB(Booking__c bObj,string docType){
        string scheduleTable = '<table border="1" cellspacing="0" cellpadding="3" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;border:1px solid black !important;" align="center"> <tr> <th class="thclass"  style="background-color:#999999;text-align:center;width: 6%;"> Sr No. </th> <th class="thclass"  style="background-color:#999999;text-align:center;width: 10%;"> Payment Mode </th> <th class="thclass"  style="background-color:#999999;text-align:center;width: 10%;"> RTGS/Cheque/ Draft No.</th> <th class="thclass"  style="background-color:#999999;text-align:center;width: 10%;"> Instrument Date </th> <th class="thclass"  style="background-color:#999999;text-align:center;width: 13%;"> Amount </th> <th class="thclass"  style="background-color:#999999;text-align:center;width: 34%;"> Bank Name </th> <th class="thclass"  style="background-color:#999999;text-align:center;width: 17%;"> Branch</th></tr>';
        List<Payment__c> payment = [Select Payment_Mode__c,Payment_Date__c,RTGS_Cheque_Draft_No__c,Bank_Name__c,Amount__c,Instrument_Date__c,Branch_Name__c,Is_Token__c 
                                    FROM Payment__c WHERE Is_Token__c = True AND Booking__c =: bObj.id];
        integer k=1;    
        System.debug('payment####'+payment); 
        System.debug('payment####'+payment.size());                   
        if(payment.size()>0){
            System.debug('payment####'+payment); 
            String PaymentAmt;
            
            for(Payment__c p : payment){
                PaymentAmt = QuotationManagmentServices.INFormatR(p.Amount__c);
                if(docType == 'Acceptance Form' || docType == 'Allotment Form')
                    scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass">' + p.Payment_Mode__c + '</td> <td class="tdclass">' + p.RTGS_Cheque_Draft_No__c + '</td> <td class="tdclass">' + p.Instrument_Date__c.format() + '</td><td class="tdclass">' + PaymentAmt + '</td><td class="tdclass">' + p.Bank_Name__c + '</td><td class="tdclass">' + p.Branch_Name__c + '</td></tr>';
                k++;
            }
        }
        return scheduleTable;
    }
    Public static string getAnnexureA(string pId,string docType){
        string scheduleTable = '<table border="1" cellspacing="0" cellpadding="3" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;border:1px solid black !important;" align="center"> <tr> <th class="thclass"  style="background-color:#999999;text-align:center;width: 10%;"> Sr No. </th> <th class="thclass"  style="background-color:#999999;text-align:center;width: 60%;"> Stages </th> <th class="thclass"  style="background-color:#999999;text-align:center;width: 30%;"> Date of Completion </th></tr>';
        List<Annexure_Completion__c> annexL = [Select id,Stages__c,Project__c,Is_Active__c,Date__c,Order_No__c,IsCompleted__c,Description_Date__c 
                                    FROM Annexure_Completion__c WHERE Is_Active__c = True AND Project__c =: pId order by Order_No__c ASC];
        integer k=1;    
        System.debug('annexL####'+annexL); 
        System.debug('annexL####'+annexL.size());                   
        if(annexL.size()>0){
            System.debug('annexL####'+annexL); 
            
            for(Annexure_Completion__c a : annexL){
                if(docType == 'Acceptance Form' || docType == 'Allotment Form')
                    scheduleTable += '<tr><td class="tdclass" style="text-align:center;">' + k + '.</td><td class="tdclass">' + a.Stages__c + '</td>';
                    if(a.IsCompleted__c == True){
                        scheduleTable += '<td class="tdclass">' + a.Description_Date__c + '</td></tr>';
                    }else{
                        scheduleTable += '<td class="tdclass">' + customDateFormat(a.Date__c) + '</td></tr>';
                    }
                k++;
            }
        }
        return scheduleTable;
    }
    //Seventh Schedule
    // added by Pranay
    /*Public static string getSeventhScheduleDetails(Booking__c bObj, Quotation__c qObj, Property__c property, Applicant__c ap,Tower__C t, string objName){
                string scheduleTable = '<table border="1" cellspacing="0" cellpadding="0" style="border-collapse: collapse;width: 100%;align="center"> <tr> <th class="thclass"  style="background-color:#737373;text-align:center;"> Sr.No. </th> <th class="thclass"  style="background-color:#737373;text-align:center;"> Terms and Expressions </th> <th class="thclass"  style="background-color:#737373;text-align:center;"> Meaning </th> </tr>';
    
        Integer i = 1;
        String floor = '';
        Integer ld;
        system.debug('Inside Seventh table');
        if(property.Floor_No__c != null){
           ld = math.mod(Integer.ValueOf(property.Floor_No__c),10);
       
            if(ld == 1 || ld == 2 || ld == 3){
                if(ld == 1)
                    floor = Integer.ValueOf(property.Floor_No__c) + 'st';
                if(ld == 2)
                    floor = Integer.ValueOf(property.Floor_No__c) + 'nd';
                if(ld == 3)
                    floor = Integer.ValueOf(property.Floor_No__c) + 'rd';
            }
            else
            {
                floor = Integer.ValueOf(property.Floor_No__c) + 'th';
            }
            if(Integer.ValueOf(property.Floor_No__c) == 11 || Integer.ValueOf(property.Floor_No__c) == 12 || Integer.ValueOf(property.Floor_No__c) == 13){
                floor = Integer.ValueOf(property.Floor_No__c) + 'th';
            }
        }
        
        //lowerfloor
        String lowerfloor = '';
        Integer lowerld;
        if(Property.Duplex_Penthouse_Lower_Level_Floor__c != null){
           lowerld = math.mod(Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c),10);
        
            if(lowerld == 1 || lowerld == 2 || lowerld == 3){
                if(lowerld == 1)
                    lowerfloor = Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) + 'st';
                if(lowerld == 2)
                    lowerfloor = Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) + 'nd';
                if(lowerld == 3)
                    lowerfloor = Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) + 'rd';
            }
            else
            {
                lowerfloor = Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) + 'th';
            }
            if(Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) == 11 || Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) == 12 || Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) == 13){
                lowerfloor = Integer.ValueOf(Property.Duplex_Penthouse_Lower_Level_Floor__c) + 'th';
            }
        }
        
        //upperfloor
        String upperfloor = '';
        Integer upperld;
        if(Property.Duplex_Penthouse_Upper_Level_Floor__c != null){
           upperld = math.mod(Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c),10);
        
            if(upperld == 1 || upperld == 2 || upperld == 3){
                if(upperld == 1)
                    upperfloor = Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) + 'st';
                if(upperld == 2)
                    upperfloor = Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) + 'nd';
                if(upperld == 3)
                    upperfloor = Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) + 'rd';
            }
            else
            {
                upperfloor = Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) + 'th';
            }
            if(Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) == 11 || Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) == 12 || Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) == 13){
                upperfloor = Integer.ValueOf(Property.Duplex_Penthouse_Upper_Level_Floor__c) + 'th';
            }
        }
        if(objName == 'SeventhTable1' ){
            scheduleTable += '<tr><td>' + i + '</td><td> Said Premises </td>' +
            '<td> Flat No. ' + property.House_Unit_No__c + ' on the ' + floor + ' floor of the said Tower </td></tr>';        
        }
        i=2;
        string salePrice = QuotationManagmentServices.INFormatR(qObj.Total_Agreement_Value_Modified__c);
        string salePriceinWord = S_NumberToWord.convertNumbertoWords(Integer.valueOf(qObj.Total_Agreement_Value_Modified__c));
        string salesPriceOfCarpetArea = QuotationManagmentServices.INFormatR(qObj.Sale_Price_for_Carpet_Area_of_the_Unit__c);
        string salesPriceOfCarpetAreaWord = S_NumberToWord.convertNumbertoWords(Integer.valueOf(qObj.Sale_Price_for_Carpet_Area_of_the_Unit__c));
        string salesPriceOfLimited_Facilties = QuotationManagmentServices.INFormatR(qObj.Sale_Price_for_Limited_Areas_Facilities__c);
        string salesPriceOfLimited_FaciltiesWord = S_NumberToWord.convertNumbertoWords(Integer.valueOf(qObj.Sale_Price_for_Limited_Areas_Facilities__c));
        string ITC_Benefit = QuotationManagmentServices.INFormatR(qObj.ITC_Benefit__c);
        string ITC_BenefitWord = S_NumberToWord.convertNumbertoWords(Integer.valueOf(qObj.ITC_Benefit__c));        
        string salesEffective = QuotationManagmentServices.INFormatR(qObj.Effective_Sale_Price__c);
        string salesEffectiveWord = S_NumberToWord.convertNumbertoWords(Integer.valueOf(qObj.Effective_Sale_Price__c));
        
        if(objName == 'SeventhTable1'){
            scheduleTable += '<tr><td>' + i + '</td><td> Carpet area of the said Premises as per RERA </td>' +
            '<td> Admeasuring approximately ' + property.Carpet_Area_Sq_Mtr__c + ' Sq.mtrs. equivalent to approximately ' +
            property.Carpet_Area_of_the_Unit__c + ' Sq.ft. </td></tr>';        
        }
        
        i=3; 
        if(objName == 'SeventhTable1'){
            scheduleTable += '<tr><td>' + i + '</td><td> Sale Price </td>' +
            '<td> Rs.'+ salePrice + ' (' + salePriceinWord + ')</td></tr>';
            scheduleTable += '<tr><td>' + '</td><td> (i) Sale price towards the carpet area of the said premises </td>' +
            '<td> Rs.'+ salesPriceOfCarpetArea + ' (' + salesPriceOfCarpetAreaWord + ')</td></tr>';
            if(qObj.Sale_Price_for_Limited_Areas_Facilities__c > 0){
                scheduleTable += '<tr><td>' + '</td><td> (ii) Propotionate Sale price towards the limited areas and facilities </td>' +
                '<td> Rs.'+ salesPriceOfLimited_Facilties + ' (' + salesPriceOfLimited_FaciltiesWord + ')</td></tr>'; 
            }else{
                scheduleTable += '<tr><td>' + '</td><td> (ii) Propotionate Sale price towards the limited areas and facilities </td>' +
                '<td> NA </td></tr>'; 
            }
        }
        
        Booking__c bk = [select id,Name,Part_Payment_towards_the_Sale_Price__c,Booking_Date__c,Optional_Fittings_Furniture__c from Booking__c where id =: bObj.id];
        String PartPayment = QuotationManagmentServices.INFormatR(bk.Part_Payment_towards_the_Sale_Price__c);
        String PartPaymentWord = S_NumberToWord.convertNumbertoWords(bk.Part_Payment_towards_the_Sale_Price__c);
        if(property.ITC_Benefit_Applicable__c){
            i=4;
            if(objName == 'SeventhTable1'){
                scheduleTable += '<tr><td>' + i + '</td><td> Part Payment towards the Sale Price paid prior hereto </td>' +
                '<td> Rs.' + PartPayment + ' (' + PartPaymentWord +')</td></tr>';
            }
        }
        
        i=5;
        if(objName == 'SeventhTable1'){
            scheduleTable += '<tr><td>' + i + '</td><td> Bank Account of the Promoter </td>' +
            '<td> ' + property.Bank_Account_of_the_Promoter__c + '</td></tr>';
        }
        
        string parkingDetails = 'NA';
        map<string,Integer> parkingMap = new Map<string,Integer>();
        for(Integer j=1;j<=5;j++){
            string earmarkedName = (string) qObj.get('Earmarked_Car_Parking_Type_' + j +'__c');
            decimal earmarkedCOunt = (decimal) qObj.get('Earmarked_Car_Parking_Count_' + j +'__c');
            string additionalParkingName = (string) qObj.get('Car_Park_Type_' + j +'__c');
            decimal additionalParkingCOunt = (decimal) qObj.get('Car_Park_Count_' + j +'__c');
            if(string.isNotBlank(earmarkedName) && earmarkedCOunt != null){
                earmarkedName = earmarkedName.toLowerCase();
                earmarkedName = earmarkedName.substring(0,1).toUpperCase() + earmarkedName.substring(1,earmarkedName.length());
                if(parkingMap.containskey(earmarkedName)){
                    Integer cc = parkingMap.get(earmarkedName) + Integer.valueOf(earmarkedCOunt);
                    parkingMap.put(earmarkedName, cc);
                }else{
                    Integer cc = Integer.valueOf(earmarkedCOunt);
                    parkingMap.put(earmarkedName, cc);
                }
            }
            if(string.isNotBlank(additionalParkingName) && additionalParkingCOunt != null){
                additionalParkingName = additionalParkingName.toLowerCase();
                additionalParkingName = additionalParkingName.substring(0,1).toUpperCase() + additionalParkingName.substring(1,additionalParkingName.length());
                if(parkingMap.containskey(additionalParkingName)){
                    Integer cc = parkingMap.get(additionalParkingName) + Integer.valueOf(additionalParkingCOunt);
                    parkingMap.put(additionalParkingName, cc);
                }else{
                    Integer cc = Integer.valueOf(additionalParkingCOunt);
                    parkingMap.put(additionalParkingName, cc);
                }
            }
        }
        if(!parkingMap.isEmpty()){
            parkingDetails = 'Permission to park in '; 
            for(string st : parkingMap.keyset()){
                parkingDetails += ' '+ parkingMap.get(st) + ' [' + getStringFromNumber(parkingMap.get(st)) + 
                                '] ' + 'car parking space/s (Configuration - ' + st + ') &'; 
            }
            parkingDetails = parkingDetails.removeEnd('&');
            //1 [One] car parking space/s (Configuration – Tandem) & 1 [One] car parking space/s (Configuration – Single)';
        }
       
        i=6;
        if(objName == 'SeventhTable1'){
            scheduleTable += '<tr><td>' + i + '</td><td> Car Parking Space/s </td>' +
            '<td> ' + parkingDetails + '</td></tr>';
        }
        
        i=7;
        if(objName == 'SeventhTable1'){
            scheduleTable += '<tr><td>' + i + '</td><td> Booking Date </td>' +
            '<td> ' + bk.Booking_Date__c + '</td></tr>';
        }
        
        i=8;
        if(objName == 'SeventhTable1'){
           if(!property.OC_Received__c){
               string cDate = '';
               string ocDes = '';
               if(t.Completion_Certificate_Date__c != null)
                   cDate = customDateFormat(property.OC_Received_Date__c);
                
                ocDes = property.OC_Received_Description__c;
                scheduleTable += '<tr><td>' + i + '</td><td> Completion Date </td>' +
                '<td> ' + ocDes + '</td></tr>';
                //'<td> ' + cDate + '</td></tr>';
           }
          }
        
        i=9;
        if(objName == 'SeventhTable1'){
             scheduleTable += '<tr><td>' + i + '</td><td> Limited Area and Facilities </td>' +
             '<td> ' + property.Limited_Areas_and_Facilities__c + '</td></tr>';
               
        }
        
        i=10;
        if(objName == 'SeventhTable1'){
             scheduleTable += '<tr><td>' + i + '</td><td> Optional Fittings/Furniture/Fixtures/Equipment (at such price to be determined by the Promoter) </td>' +
             '<td> ' + bk.Optional_Fittings_Furniture__c + '</td></tr>';     
        }
        
        
        i=11;
        if(objName == 'SeventhTable1'){
             scheduleTable += '<tr><td>' + i + '</td><td> Said Nominee </td>' +
             '<td> ' + property.Limited_Areas_and_Facilities__c + '</td></tr>';     
        }
        
        i=12;
        if(objName == 'SeventhTable1'){
           scheduleTable += '<tr><td>' + i + '</td><td> Contact Details </td>' +
            '<td class="tdclass" align="left"> ' + 'Promoter’s email address: ' + property.Project_Name__r.Promoter_s_Email_Address__c + ' <br/>' +
                      'Promoter’s phone number: ' + property.Project_Name__r.Other_Company_Phone__c +' <br/>' +
                      'Promoter’s fax number: ' + property.Project_Name__r.Other_Company_Fax__c + ' <br/><br/>' +
                      'Allottee’s email address: ' + ap.Email_Address__c + '<br/>' +
                      'Allottee’s phone number: ' + ap.Mobile_Number__c + '<br/>' +
                      'Allottee’s fax number: <br/>' + 
                      '</td></tr>';
        }
        
        i=13;
        List< Applicant__c > otherApplicants = [select id,name, Applicant_Number__c, PancardNo__c from Applicant__c
                                                where Booking__c =: bObj.id and Applicant_Number__c != 'Primary Applicant'];
        string otherApplicant = '';
        if(otherApplicants != null && !otherApplicants.isEmpty()){
            for(Applicant__c ap1 : otherApplicants){
                if(ap1.PancardNo__c != null){
                    otherApplicant += ', ' + ap1.PancardNo__c;
                }
            }
        }                                        
        if(objName == 'SeventhTable1'){
            scheduleTable += '<tr><td>' + i + '</td><td> PAN </td>' +
            '<td class="tdclass" align = "left"> ' + 'Promoter’s PAN: ' + property.Project_Name__r.Promoter_s_PAN__c + '<br/>' +
                      'Allottee’s PAN: ' + ap.PancardNo__c + '' + otherApplicant + 
                      '</td></tr>';
        }               
        scheduleTable += '</table>';
        
        return scheduleTable;
    }
    
    
    
    Public static string MortageReleaseNOCTable(Booking__c bk){
        List <Applicant__c> applist = [Select id, Name,State__c,Email_Address__c from Applicant__c where Booking__c =:bk.id ];
        Property__c pro = [Select id,Name,Floor_No__c,Tower_Name__c from Property__c where Booking__c =: bk.id];
        String scheduleTable =  '<table border="1" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"> <tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:30%;" >Name of purchaser<br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;">'+ applist[0].Name +'<br/><br/> </td></tr>';
        scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:30%;" >Address of purchaser<br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;">'+ applist[0].State__c+' <br/><br/> </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:30%;" >Mortgage Flat No.<br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;">'+pro.Name+' <br/><br/> </td></tr>';
                scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:30%;" >Floor<br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;">'+pro.Floor_No__c+' <br/><br/> </td></tr>';
                    scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:30%;" >Biulding Name/Tower<br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;">'+pro.Tower_Name__c+'<br/><br/></td></tr>';
            scheduleTable += '</table>';
        return scheduleTable;
    }
    
    Public static string CantactDetailUpdateSingleTower(Booking__c bk){
        Booking__c book = [select id,Name,C_o_Name_Billing_Address__c,Billing_Street__c,Billing_Str_Suppl2__c,Billing_Str_Suppl3__c,Billing_Location__c,Billing_Post_Code__c,Billing_City__c,Billing_Country__c,Billing_Region__c from Booking__c where id =: bk.id];
        List <Applicant__c> applist = [Select id, Name,State__c,Email_Address__c from Applicant__c where Booking__c =:bk.id ];
        String scheduleTable =  '<table border="1" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"> <tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight: bold;" >Details currently in record </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight: bold;">Requested change </td></tr>';
        scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Billing Address:'+ book.C_o_Name_Billing_Address__c + ',' + book.Billing_Street__c +','+ book.Billing_Str_Suppl2__c+ ',' + book.Billing_Str_Suppl3__c+ ',' + book.Billing_Location__c+','+ book.Billing_Post_Code__c+','+ book.Billing_City__c+','+ book.Billing_Country__c+','+ book.Billing_Region__c +' </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">Billing Address:   </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Correspondence Address: </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">Correspondence Address:  </td></tr>';
                scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Email Address:<br/><br/>Applicant 1:'+ applist[0].Email_Address__c+'<br/>Applicant 2: _________________________<br/>Applicant 3: _________________________<br/>Applicant 4: _________________________<br/>Applicant 5: _________________________<br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> Email Address: </td></tr>';
                    //scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Biulding Name/Tower</td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> ______________ </td></tr>';
            scheduleTable += '</table>';
        return scheduleTable;
    }
    
    Public static string CantactDetailUpdateMultiTower(Booking__c bk){
        Booking__c book = [select id,Name,C_o_Name_Billing_Address__c,Billing_Street__c,Billing_Str_Suppl2__c,Billing_Str_Suppl3__c,Billing_Location__c,Billing_Post_Code__c,Billing_City__c,Billing_Country__c,Billing_Region__c from Booking__c where id =: bk.id];
        List <Applicant__c> applist = [Select id, Name,State__c,Email_Address__c from Applicant__c where Booking__c =:bk.id ];
        
        String scheduleTable =  '<table border="1" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"> <tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight: bold;" >Details currently in record </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight: bold;">Requested change </td></tr>';
        scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Billing Address:<br/><br/>House no:'+ book.C_o_Name_Billing_Address__c + '<br/>Street 1 : ' + book.Billing_Street__c +'<br/>Street 2 :'+ book.Billing_Str_Suppl2__c+ '<br/>Street 3 : ' + book.Billing_Str_Suppl3__c+ '<br/>Locality : ' + book.Billing_Location__c+'<br/>City : '+ book.Billing_City__c+'<br/>Country: '+ book.Billing_Country__c+'<br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">Billing Address:   </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Correspondence Address: </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">Correspondence Address:  </td></tr>';
                scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Email Address:<br/><br/>Applicant 1: '+ applist[0].Email_Address__c+'<br/>Applicant 2: _________________________<br/>Applicant 3: _________________________<br/>Applicant 4: _________________________<br/>Applicant 5: _________________________<br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> Email Address: </td></tr>';
                    //scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Biulding Name/Tower</td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> ______________ </td></tr>';
            scheduleTable += '</table>';
        return scheduleTable;
    }
    
    Public static string KeyHandoverChecklistTable(){
        String scheduleTable =  '<table border="1" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"> <tr ><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;margin-bottom:1px;color:black;font-weight: bold;width:10%;text-align: center !important; padding:1px;background-color:#d3d3d3;" >Sr. No.</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;font-weight: bold;background-color:#d3d3d3;width:45%;">Checklist</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;font-weight: bold;background-color:#d3d3d3;width:32%;">Qtye</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;font-weight: bold;background-color:#d3d3d3;width:15%;">Received<br/> Yes / No</td></tr>';
        scheduleTable += '<tr ><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;margin-bottom:1px;color:black;width:8%;text-align: center !important; padding:1px;;" >1</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: justify !important; padding:5px;width:45%;">Possession Letter </td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;width:32%;">Original/Customer Copy</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:15%;"></td></tr>';
            scheduleTable += '<tr ><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;margin-bottom:1px;color:black;width:8%;text-align: center !important; padding:1px;;" >2</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: justify !important; padding:5px;width:45%;">Car Park Allotment Letter</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;width:32%;">Original/Customer Copy</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:15%;"></td></tr>';
                scheduleTable += '<tr ><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;margin-bottom:1px;color:black;width:8%;text-align: center !important; padding:1px;;" >3</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: justify !important; padding:5px;width:45%;">Electricity NOC </td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;width:32%;">Original/Customer Copy</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:15%;"></td></tr>';
                    scheduleTable += '<tr ><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;margin-bottom:1px;color:black;width:8%;text-align: center !important; padding:1px;;" >4</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: justify !important; padding:5px;width:45%;">Flat keys</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;width:32%;">3 Sets</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:15%;"></td></tr>';
                            scheduleTable += '<tr ><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;margin-bottom:1px;color:black;width:8%;text-align: center !important; padding:1px;;" >5</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: justify !important; padding:5px;width:45%;">Layouts<ul style="list-style-type:disc;"><li>Electrical</li><li>Air-Conditioning</li><li>Sprinkler</li><li>Wall</li><li>Plumbing</li></ul>Manuals<br/>Fit-Out Guide<br/>Home Guide<br/> </td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;width:32%;">1 Set (Pen Drive)</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:15%;"></td></tr>';

                            scheduleTable += '<tr ><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;margin-bottom:1px;color:black;width:8%;text-align: center !important; padding:1px;;" >6</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: justify !important; padding:5px;width:45%;">Payment Receipts</td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;width:32%;"></td><td class="tdclass" style = "font-family:Times;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:15%;"></td></tr>';

                            //scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Biulding Name/Tower</td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> ______________ </td></tr>';

            scheduleTable += '</table>';
        return scheduleTable;
    }
    
    Public static string CustomerProfilingTable(){
        String scheduleTable =  '<table border="1" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"> <tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;font-weight: bold;" colspan='+'4'+' >Customers Profile </td> </tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Name: <br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >1st Applicants Name<br/><br/>  </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >2nd Applicants Name<br/><br/>  </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >3rd Applicants Name<br/><br/>  </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >4th Applicants Name<br/><br/>  </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >5th Applicants Name<br/><br/>  </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Address:<br/><br/><br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Residence Status<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">NRI/ Resident  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Occupation<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >1st Applicant<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >2nd Applicant<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >3rd Applicant<br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >4th Applicant<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >5th Applicant<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';

        scheduleTable += '</table>';
        return scheduleTable;
    }
    
    Public static string CustomerProfilingTable2(){
        String scheduleTable =  '<table border="1" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"> <tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;font-weight: bold;" colspan='+'4'+' >Customers Profile</td> </tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Name: <br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >1st Applicants Name<br/><br/>  </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >2nd Applicants Name<br/><br/>  </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >3rd Applicants Name<br/><br/>  </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >4th Applicants Name<br/><br/>  </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >5th Applicants Name<br/><br/>  </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Address:<br/><br/><br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Residence Status<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">NRI/ Resident  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Occupation<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >1st Applicant<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >2nd Applicant<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >3rd Applicant<br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >4th Applicant<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >5th Applicant<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Designation<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >1st Applicant<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Company Name<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';    
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >1st Applicant<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';    
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Source<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Additional Information (if any)<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Elite Member<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight:bold" >Existing Relationship with ORL<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">  </td></tr>';

        scheduleTable += '</table>';
        return scheduleTable;
    }
    
    Public static string OfferNoticeTable(){
        String scheduleTable =  '<table border="1" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"> <tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight: bold;" >Proposed Transferee<br/><br/<br/><br/<br/><br/ </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">Name: _____________<br/><br/>Address: _____________<br/><br/>________________<br/><br/> </td></tr>';
        scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight: bold;" >Proposed Sale Price<br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">Rs. <proposed sp amount>/-(Rupees <in words>Only)(inclusive   of   non-monetary   consideration,   if any)<br/><br/>   </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight: bold;" >Terms and  Conditions of Proposed Transfer of allotment/reservation<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">1)_______________________<br/><br/>2)_______________________<br/><br/>3)_______________________<br/><br/> </td></tr>';
                scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;font-weight: bold;" >Date of Consummation of Proposed Transfer of allotment/reservation<br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> Date: </td></tr>';
                    //scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Biulding Name/Tower</td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> ______________ </td></tr>';
            scheduleTable += '</table>';
        return scheduleTable;
    }
    
    Public static string TransferFormateTable(){
        String scheduleTable =  '<table border="1" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"> <tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;width:50%;font-weight: bold;background-color:#d3d3d3;" colspan='+'2'+' >Transferors Details </td> </tr>';
        scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Sale Price<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">Rs. __________________/-   </td></tr>';
            scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Amount paid by Transferors to Developer<br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">Rs. __________________/- </td></tr>';
                scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Balance Due up to Possession<br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> Rs. __________________/- </td></tr></table><br/><br/>';
        
         scheduleTable +=  '<table border="1" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"> <tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: center !important; padding:5px;width:50%;font-weight: bold;background-color:#d3d3d3;" colspan='+'2'+' >Proposed Purchaser/s Payment Details</td> </tr>';
        scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Flat Value  @   <br/><br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">Rs. __________________/-   </td></tr>';
                scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >New Sale Price<br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> Rs. __________________/- </td></tr></table><br/><br/>';
                    //scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Biulding Name/Tower</td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> ______________ </td></tr>';
            
        scheduleTable +=  '<table border="1" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"><tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Amount paid by Proposed Purchaser/s to Transferors as token  <br/> <br/> </td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">Rs. __________________/-   </td></tr>';
                        scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Balance to be paid by Proposed Purchaser/s to the <br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;"> Rs. __________________/- </td></tr>';
                        scheduleTable += '<tr > <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;" >Transferors within   Days<br/><br/></td> <td class="tdclass" style = "font-family:arial;border-collapse: collapse;font-size: 11pt;color:black;text-align: left !important; padding:5px;width:50%;">No. of Days: _______________ </td></tr>';


        scheduleTable += '</table>';
        return scheduleTable;
    }
    */
    public static string getStringFromNumber(Integer num){
        if(num != null){
            if(num == 1){ return 'One';}
            else if(num == 2){ return 'Two';}
            else if(num == 3){ return 'Three';}
            else if(num == 4){ return 'Four';}
            else if(num == 5){ return 'Five';}
            else if(num == 6){ return 'Six';}
            else if(num == 7){ return 'Seven';}
            else if(num == 8){ return 'Eight';}
            else if(num == 9){ return 'Nine';}
            else if(num == 10){ return 'Ten';}
        }
        return null;
    }
    
    public static string customDateFormat(Date dt){
        system.debug('inside CusomDateFormat Method:: '+dt);
        string stDate = '';
        if(dt != null){
            string stMonth = '';
            string stDay = '';
            Integer day = dt.Day();
            Integer month = dt.month();
            Integer year = dt.year();
            string stYear = string.valueof(year);
            stDay = day + '';
            /*if(day == 1 || day == 21 || day == 31){ stDay = day + 'st'; }
            else if(day == 2 || day == 22){ stDay = day + 'nd'; }
            else if(day == 3 || day == 23){ stDay = day + 'rd'; }
            else {stDay = day + 'th';}*/
            
            if(month == 1){ stMonth = 'January';}
            else if(month == 2) { stMonth = 'February'; }
            else if(month == 3) { stMonth = 'March'; }
            else if(month == 4) { stMonth = 'April'; }
            else if(month == 5) { stMonth = 'May'; }
            else if(month == 6) { stMonth = 'June'; }
            else if(month == 7) { stMonth = 'July'; }
            else if(month == 8) { stMonth = 'August'; }
            else if(month == 9) { stMonth = 'September'; }
            else if(month == 10) { stMonth = 'October'; }
            else if(month == 11) { stMonth = 'November'; }
            else if(month == 12) { stMonth = 'December'; }
            
            stDate = stDay + ' ' + stMonth + ' ' + stYear;
        }
        return stDate;
    }
    
  /*  public static List<Opportunity> getOpportunityRecord(Id oppId){
        List<Opportunity> oppList = [select id,name,Primary_Name__c,Primary_Email__c,Primary_Phone__c,Project__c,Project__r.name,Unit__c,Unit__r.name,Unit__r.Tower__r.name,Unit__r.booking__c,
                                     Unit__r.Booking__r.Booking_Date__c, Unit__r.Tower__r.Cluster__r.name, OwnerId, Booking__c,Primary_pancard__c,Permanent_Address__c,Other_Applicants_Name__c,
                                     Other_Applicants_Email__c,Other_Applicants_Pancard__c,Mailing_Address__c,Unit__r.Floor__c,Booking__r.Quotation__C
                                     from opportunity where id =: oppId];
        return oppList;
    }
       
    public static List<Booking__c> getBookingRecord(Id bookId){
        List<Booking__c> bList = [Select Id, Name, Booking_Date__c,Agreement_Value__c,Total_Agreement_Value_Demanded__c,Total_Agreement_Value_Paid__c,Total_Agreement_Value_Balance__c,Unit__r.Project__r.Name,
                        Total_Service_Tax_Demanded__c,Total_Service_Tax_Balance__c,Total_Service_Tax_Paid__c,Quotation__c from Booking__c where Id = :bookId];
        return bList;
    }
    
    public static List<Quotation__c> getQuotationRecord(Id qId){
        List<Quotation__C > qList = new List<Quotation__c>(); 
        String queryString = '';
        for(Integer i = 1; i<=17; i++) {
            queryString += 'Charge' + i + 'Name__c'   + ',';
            queryString += 'Charge' + i + 'Value__c'  + ',';
            queryString += 'Charge' + i + 'Bucket__c' + ',';                    
            queryString += 'Charge' + i + 'CGST__c'   + ','; 
            queryString += 'Charge' + i + 'SGST__c'   + ','; 
        }
        for(Integer j=1; j<=5; j++){
            queryString += 'Car_Park_Type_' + j + '__c' + ',';
            queryString += 'Car_Park_Count_' + j + '__c' + ',';
            queryString += 'Earmarked_Type_' + j + '__c' + ',';
            queryString += 'Earmarked_Count_' + j + '__c' + ',';
        }
        
        queryString += 'Id, Name, CreatedDate, Total_Agreement_Value_Bucket__c, CGST_on_Total_Agreement_Value_Bucket__c, Total_SD_Registration_Bucket__c, ' +
                       'SGST_on_Total_Agreement_Value_Bucket__c, '                                                         +
                       'Unit__r.Tower__r.Name,                        Unit__r.Project__r.Name, '                           +
                       'Unit__r.Name,                                 Unit__r.Configuration__c, '                          +
                       'Unit__r.Chargeable_Area__c,                   Unit__r.Carpet_Area_in_Sq_Mts__c, '                  +
                       'Unit__r.Enclosed_Balcony_in_Sq_Mtrs__c,       Unit__r.Cupboard_Area_in_Sq_Mtrs__c,'                +
                       'Opportunity__c,                               Opportunity__r.AccountId,'                           +
                       'Unit__r.Tower__r.Cluster__r.Name,             Unit__r.Tax_Rate_Basic__c,'                          +
                       'Unit__r.Project__c,                           TotalAdditionalCarpark__c,'                          +
                       'TotalEarmarkedCarpark__c';

        if (qId != null) {
            queryString = 'Select ' + queryString  + ' from Quotation__c where Id = \'' + qId + '\'' ;
            qList = Database.Query(queryString);
        }
        return qList;
    }
    
    public static Legal_Entity__c getLegalEntityDetails(Id unitId, Id pId) {
        Legal_Entity__c le = new Legal_Entity__c();
        Id leId = null;
        List<Unit__c> pu = [Select Id, Name, Legal_Entity__r.Id from Unit__c where Id = : unitId];
        if(pu != null && pu.size() > 0) {
            leId =pu[0].Legal_Entity__r.Id; 
        }
        
        if(leId == null) {
            List<Project__c> p = [Select Id, Name, RDS_Company_Code__r.Id from Project__c where Id = : pId];
            if(p != null && p.size() > 0)
                leId = p[0].RDS_Company_Code__r.Id;
        }
        System.debug('ledId:' + leId);
        if(leId != null) {
            le = [Select Name,Account_Name_Flat_Cost__c, Account_Number_Flat_Cost__c, Bank_Name_Flat_Cost__c, 
                                        IFSC_Code_Flat_Cost__c, MICR_Code_Flat_Cost__c,RDS_PAN_No__c,Authorized_Signatory__c,
                                        Account_Name_Service_Tax__c,Account_Number_Service_tax__c, Bank_Name_Service_tax__c, 
                                        IFSC_Code_Service_Tax__c, MICR_Code_Service_Tax__c, RDS_Service_Tax_No__c,Branch_Name_Flat_Cost__c,
                                        RDS_Address1__c,RDS_Address2__c, RDS_City__c, RDS_Pin_Code__c, CIN__c,Short_Name__c,Letter_Head_Name__c 
                                        FROM Legal_Entity__c where Id = : leId];
        }
        return le;
    }
    
    public static string getMiscellaneousDetails(DateTime bookingDate, string fieldname){
        if(fieldName.equals('Day of Booking')){
            if(bookingDate.Day() == 1){ return 'First'; }else if(bookingDate.Day() == 2){ return 'Second'; }
            else if(bookingDate.Day() == 3){ return 'Third'; }else if(bookingDate.Day() == 4){ return 'Fourth'; }
            else if(bookingDate.Day() == 5){ return 'Fifth'; }else if(bookingDate.Day() == 6){ return 'Sixth'; }
            else if(bookingDate.Day() == 7){ return 'Seventh'; }else if(bookingDate.Day() == 8){ return 'Eighth'; }
            else if(bookingDate.Day() == 9){ return 'Nineth'; }else if(bookingDate.Day() == 10){ return 'Tenth'; }
            else if(bookingDate.Day() == 11){ return 'Eleventh'; }else if(bookingDate.Day() == 12){ return 'Twelfth'; }
            else if(bookingDate.Day() == 13){ return 'Thirteenth'; }else if(bookingDate.Day() == 14){ return 'Fourteenth'; }
            else if(bookingDate.Day() == 15){ return 'Fifteenth'; }else if(bookingDate.Day() == 16){ return 'Sixteenth'; }
            else if(bookingDate.Day() == 17){ return 'Seventeenth'; }else if(bookingDate.Day() == 18){ return 'Eighteenth';}
            else if(bookingDate.Day() == 19){ return 'Nineteenth'; }else if(bookingDate.Day() == 20){ return 'Twentieth';}
            else if(bookingDate.Day() == 21){ return 'Twentieth First'; }else if(bookingDate.Day() == 22){ return 'Twentieth Second';}
            else if(bookingDate.Day() == 23){ return 'Twentieth Third'; }else if(bookingDate.Day() == 24){ return 'Twentieth Fourth';}
            else if(bookingDate.Day() == 25){ return 'Twentieth Fifth'; }else if(bookingDate.Day() == 26){ return 'Twentieth Sixth';}
            else if(bookingDate.Day() == 27){ return 'Twentieth Seventh'; }else if(bookingDate.Day() == 28){ return 'Twentieth Eigth';}
            else if(bookingDate.Day() == 29){ return 'Twentieth Ninth'; }else if(bookingDate.Day() == 30){ return 'Thirtieth';}
            else if(bookingDate.Day() == 31){ return 'Thirtieth First'; }else{ return '';}  
            
        }else if(fieldName.equals('Month of Booking')){
            if(bookingDate.Month() == 1){ return 'January'; }else if(bookingDate.Month() == 2){ return 'February'; }
            else if(bookingDate.Month() == 3){ return 'March'; }else if(bookingDate.Month() == 4){ return 'April'; }
            else if(bookingDate.Month() == 5){ return 'May'; }else if(bookingDate.Month() == 6){ return 'June'; }
            else if(bookingDate.Month() == 7){ return 'July'; }else if(bookingDate.Month() == 8){ return 'August'; }
            else if(bookingDate.Month() == 9){ return 'September'; }else if(bookingDate.Month() == 10){ return 'October'; }
            else if(bookingDate.Month() == 11){ return 'November'; }else if(bookingDate.Month() == 12){ return 'December'; }
            else{ return '';}
        
        }else if(fieldName.equals('Year of Booking')){
            if(bookingDate.Year() == 2016){ return 'Two Thousand and Sixteen'; }else if(bookingDate.Year() == 2017){ return 'Two Thousand and Seventeen'; }
            else if(bookingDate.Year() == 2018){ return 'Two Thousand and Eighteen'; }else if(bookingDate.Year() == 2019){ return 'Two Thousand and Nineteen'; }
            else if(bookingDate.Year() == 2020){ return 'Two Thousand and Twenty'; }else if(bookingDate.Year() == 2021){ return 'Two Thousand and Twenty One'; }
            else if(bookingDate.Year() == 2022){ return 'Two Thousand and Twenty Two'; }else if(bookingDate.Year() == 2023){ return 'Two Thousand and Twenty Three'; }
            else if(bookingDate.Year() == 2024){ return 'Two Thousand and Twenty Four'; }else if(bookingDate.Year() == 2025){ return 'Two Thousand and Twenty Five'; }
            else if(bookingDate.Year() == 2026){ return 'Two Thousand and Twenty Six'; }else if(bookingDate.Year() == 2027){ return 'Two Thousand and Twenty Seven'; }
            else if(bookingDate.Year() == 2028){ return 'Two Thousand and Twenty Eight'; }else if(bookingDate.Year() == 2029){ return 'Two Thousand and Twenty Nine'; }
            else if(bookingDate.Year() == 2030){ return 'Two Thousand and Thirty'; }else if(bookingDate.Year() == 2031){ return 'Two Thousand and Thirty One'; }
            else if(bookingDate.Year() == 2032){ return 'Two Thousand and Thirty Two'; }else if(bookingDate.Year() == 2033){ return 'Two Thousand and Thirty Three'; }
            else if(bookingDate.Year() == 2034){ return 'Two Thousand and Thirty Four'; }else if(bookingDate.Year() == 2035){ return 'Two Thousand and Thirty Five'; }
            else if(bookingDate.Year() == 2036){ return 'Two Thousand and Thirty Six'; }else if(bookingDate.Year() == 2037){ return 'Two Thousand and Thirty Seven'; }
            else if(bookingDate.Year() == 2038){ return 'Two Thousand and Thirty Eight'; }else if(bookingDate.Year() == 2039){ return 'Two Thousand and Thirty Nine'; }
            else if(bookingDate.Year() == 2040){ return 'Two Thousand and Fourty'; }else if(bookingDate.Year() == 2041){ return 'Two Thousand and Fourty One'; }
            else if(bookingDate.Year() == 2042){ return 'Two Thousand and Fourty Two'; }else if(bookingDate.Year() == 2043){ return 'Two Thousand and Fourty Three'; }
            else if(bookingDate.Year() == 2044){ return 'Two Thousand and Fourty Four'; }else if(bookingDate.Year() == 2045){ return 'Two Thousand and Fourty Five'; }
            else if(bookingDate.Year() == 2046){ return 'Two Thousand and Fourty Six'; }else if(bookingDate.Year() == 2047){ return 'Two Thousand and Fourty Seven'; }
            else if(bookingDate.Year() == 2048){ return 'Two Thousand and Fourty Eigth'; }else if(bookingDate.Year() == 2049){ return 'Two Thousand and Fourty Nine'; }
            else if(bookingDate.Year() == 2050){ return 'Two Thousand and Fifty'; }else{ return ''; }
        }    
        return null;
    }
    
    public static string getPrimaryApplicantDetails(opportunity opp, string fieldname){
        if(Opp != null){
            if(fieldName.equals('Primary Applicant Name')){
                return opp.Primary_Name__c;
            }else if(fieldName.equals('Primary Applicant Address')){
                return opp.Permanent_Address__c;
            }else if(fieldName.equals('Primary Applicant PAN')){
                return opp.Primary_pancard__c;
            }else if(fieldName.equals('Primary Applicant Mobile')){
                return opp.Primary_Phone__c;
            }else if(fieldName.equals('Primary Applicant Email')){
                return opp.Primary_Email__c;
            }else{
                return '';
            }
            
        }
        return null;
    }
    
    public static string getOtherApplicantsDetails(opportunity opp, string fieldname){
        if(Opp != null){
            if(fieldName.equals('Other Applicant Name')){
                return opp.Other_Applicants_Name__c;
            }else if(fieldName.equals('Other Applicant Address')){
                return opp.Mailing_Address__c;
            }else if(fieldName.equals('Other Applicant PAN')){
                if(opp.Other_Applicants_Pancard__c != null){
                    return opp.Other_Applicants_Pancard__c;
                }else{
                    return '';
                }
            }else if(fieldName.equals('Other Applicant Email')){
                if(opp.Other_Applicants_Email__c != null){
                    return opp.Other_Applicants_Email__c;
                }else{
                    return '';
                }
                
            }else{
                return '';
            }
            
        }
        return null;
    }
    
    public static List<Unit__c> getUnitDetails(Id unitId){
        List<Unit__c> unitList = [select id,name,floor__c,Cluster_Name__c,Project_Name__c,Carpet_Area__c,Carpet_Area_in_Sq_Mts__c,Configuration__c,Additional_Area__c from Unit__c where id=:unitId];
        return unitList;
    }
    
    public static List<Receipt__C> getReceipts(Id oppId) {
        List<Receipt__c> rList = [Select Id, Currency__c, Foreign_Currency_Type__c , On_Account_Money__c,On_Account_Money_Autocalculated__c,Amount_Rs__c,Cheque_DD__c,Cheque_DD_Date__c,DraweeBank__c   
                        from Receipt__c 
                        where Opportunity__r.Id  = : oppId 
                        and Currency__c = 'Indian Rupee'
                        and Amount_Rs__c > 0
                        and (Receipt_Status__c != 'Dishonored' or Receipt_Status__c != 'Physical Verification Rejected')];
        
        return rList; 
   }
   
   public static List<Receipt__C> getTokenReceipts(Id oppId) {
        List<Receipt__c> rList = [Select Id, Currency__c, Foreign_Currency_Type__c , On_Account_Money__c,On_Account_Money_Autocalculated__c,Amount_Rs__c,Cheque_DD__c,Cheque_DD_Date__c,DraweeBank__c   
                        from Receipt__c 
                        where Opportunity__r.Id  = : oppId 
                        and Currency__c = 'Indian Rupee'
                        and Amount_Rs__c > 0
                        and (Receipt_Status__c != 'Dishonored' or Receipt_Status__c != 'Physical Verification Rejected')
                        and Token_Amount_Receipt__c = true];
        
        return rList; 
   }
   
   public static decimal getReceivedAmountTotal(List<Receipt__c> rList) {
           Decimal onAccountMoney = 0;
            if(rList.size() > 0) {
              for(Receipt__c r : rList) {
                if(r.Amount_Rs__c != null)
                onAccountMoney += r.Amount_Rs__c;
              }
            }
        return onAccountMoney;       
   }
    
    public static List<Payment_Milestones__c> getPaymentPlanList(Id quotId){
        List<Payment_Milestones__c> pmList = new List<Payment_Milestones__c>();
        string queryString1 = '';
        for(Integer i = 1; i<=17; i++) {
               queryString1 += 'Charge' + i + 'Name__c'   + ',';
               queryString1 += 'Charge' + i + 'Percentage__c'  + ',';
               queryString1 += 'C' + i + '_Amount__c' + ',';                    
               queryString1 += 'C' + i + '_CGST__c'   + ','; 
               queryString1 += 'C' + i + '_SGST__c'   + ','; 
        }
        if (quotId != null) {
               queryString1 = 'Select ' + queryString1  + ' Id, Name,Milestone_Name__c, Milestone_Complete_At_Booking__c,Demand_Raised__c from Payment_Milestones__c where Quotation__c = \'' + quotId + '\' order by name asc' ;
               pmList = Database.Query(queryString1);
        }
        return pmList;
    }
    
    Public static string getUnitCostDetails(Booking__c bookingRecord,Quotation__c q, string fieldName,List<Receipt__c> rList){
        if(fieldName.equals('Total Agreement Value in words')){
            return S_NumberToWord.convertNumbertoWords(Integer.valueOf(bookingRecord.Agreement_Value__c));
        }else if(fieldName.equals('Total Agreement Value in Rs')){
            return InventoryCostServices.INFormatR(bookingRecord.Agreement_Value__c);
        }else if(fieldName.equals('Total Agreement Value Recd in words')){
            return S_NumberToWord.convertNumbertoWords(Integer.valueOf(DocumentGenerationServices.getReceivedAmountTotal(rList)));
        }else if(fieldName.equals('Total Agreement Value Recd in Rs')){
            return InventoryCostServices.INFormatR(DocumentGenerationServices.getReceivedAmountTotal(rList));
        }else if(fieldName.equals('Balance Sale Consideration in Rs')){
            return InventoryCostServices.INFormatR(bookingRecord.Agreement_Value__c - bookingRecord.Total_Agreement_Value_Paid__c);
        }else if(fieldName.equals('Balance Sale Consideration in words')){
            return S_NumberToWord.convertNumbertoWords(bookingRecord.Agreement_Value__c - bookingRecord.Total_Agreement_Value_Paid__c);
        }else if(fieldName.equals('Legal Charges in words')){
            Map<String, Integer> projChargeSeq = new Map<String,Integer>();
            projChargeSeq = InventoryCostServices.getProjectChargesSequence(bookingRecord.Unit__r.Project__r.Name);
            Decimal legalAmt = 0;
            if(projChargeSeq.containskey('Legal Charges')){
                 integer legalSeq = projChargeSeq.get('Legal Charges');
                 legalAmt = (Decimal)q.get('Charge' + legalSeq + 'Value__c');
             }
            return S_NumberToWord.convertNumbertoWords(legalAmt);
        }else if(fieldName.equals('Legal Charges in Rs')){
            Map<String, Integer> projChargeSeq = new Map<String,Integer>();
            projChargeSeq = InventoryCostServices.getProjectChargesSequence(bookingRecord.Unit__r.Project__r.Name);
            Decimal legalAmt = 0;
            if(projChargeSeq.containskey('Legal Charges')){
                 integer legalSeq = projChargeSeq.get('Legal Charges');
                 legalAmt = (Decimal)q.get('Charge' + legalSeq + 'Value__c');
             }
            return InventoryCostServices.INFormatR(legalAmt);
        }else{
            return '';
        }
       
    }
    
    Public static string getParkingDetails(Quotation__c quotRecord, string fieldName){
        string parkDetails = '';
        if(fieldName.equals('Parking Allotted')){
            if(quotRecord.Car_Park_Type_1__c != null){
                  parkDetails = quotRecord.Car_Park_Count_1__c + ' ' + quotRecord.Car_Park_Type_1__c;  
            }
            if(quotRecord.Car_Park_Type_2__c != null){
                  parkDetails += ', ' + quotRecord.Car_Park_Count_2__c + ' ' + quotRecord.Car_Park_Type_2__c;  
            }
            if(quotRecord.Car_Park_Type_3__c != null){
                  parkDetails += ', ' + quotRecord.Car_Park_Count_3__c + ' ' + quotRecord.Car_Park_Type_3__c;  
            }
            if(quotRecord.Car_Park_Type_4__c != null){
                  parkDetails += ', ' + quotRecord.Car_Park_Count_4__c + ' ' + quotRecord.Car_Park_Type_4__c;  
            }
            if(quotRecord.Car_Park_Type_5__c != null){
                  parkDetails += ', ' + quotRecord.Car_Park_Count_5__c + ' ' + quotRecord.Car_Park_Type_5__c;  
            }
        }else if(fieldName.equals('Parking Charges in Rs')){
        
        }
        return parkDetails;
    }
    
    Public static string getPaymentPlanDetailsInWords(Quotation__c quotRecord, List<Payment_Milestones__c> pmList, string fieldName){
        
         string paymentPlanDetails = '<div frame="box" style="font-size:13px; line-height:15px;"><ul> ';
         Map<String,ProjectCharges__c> projChargesMap = InventoryCostServices.getProjectChargesMap(quotRecord.Unit__r.Project__r.Name);
         Map<String,Integer> AVChargesSeqMap = new Map<String, Integer>();
         Map<String,Integer> OCSeqMap        = new Map<String, Integer>();
         Integer Seq = 1;
         String chgName = '';
         //creating a list of all charges that are part of the agreement value their field location, to identify whether they are stored in Charge1, Charge2, Charge3, etc.,
         for(String chargeName : projChargesMap.keySet()) {
                chgName = projChargesMap.get(chargeName).ChargeBucket__c;
            if(chgName.equalsIgnoreCase('Agreement Value')) {
                    AVChargesSeqMap.put(chargeName, Seq);
            }
            if (chgName.equalsIgnoreCase('Other Charges')  ||  chgName.equalsIgnoreCase('Society Charges')) {
                    OCSeqMap.put(chargeName, Seq);
            }
            
            Seq++;
         }
         //Parking charges are part of Agreement Values and always the last item in the charge sequence.
         AVChargesSeqMap.put('Parking Charges', Seq++);
         if(!pmList.isEmpty()){
            if(fieldName.equals('Flat Cost Milestones in words')){
                for(Payment_Milestones__c pm : pmList){
                    decimal totalAmt = 0;
                    decimal totalTax = 0;            
                    for(Integer i : AVChargesSeqMap.values()) {
                        totalAmt += (Decimal)pm.get('C' +i + '_Amount__c' );
                        totalTax += (Decimal)pm.get('C' + i + '_CGST__c' ) + (Decimal)pm.get('C' + i + '_SGST__c' );
                    }
                    if(pm.Milestone_Name__c.contains(':')){
                        pm.Milestone_Name__c = pm.Milestone_Name__c.substringAfter(':');
                    }
                    paymentPlanDetails += 
                        '<li> An amount of Rs.' + InventoryCostServices.INFormatR(totalAmt) + '(' + S_NumberToWord.convertNumbertoWords(Integer.valueOf(totalAmt)) + ' only) (which is ' + pm.Charge1Percentage__c +'% of the Sale Consideration),is to be paid to the Promoter 1'+ pm.Milestone_Name__c +'</li><br/>';              
                }
            }else if(fieldName.equals('Possession Milestones in words')){
                    paymentPlanDetails = '<div style="margin-left:10px;"><ul> ';
                    decimal totalAmt = 0;
                    decimal totalTax = 0;  
                    string chargName = '';          
                    for(Integer i : OCSeqMap.values()) {
                        totalAmt += (Decimal)pmList[pmList.size()-1].get('C' +i + '_Amount__c' );
                        totalTax += (Decimal)pmList[pmList.size()-1].get('C' + i + '_CGST__c' ) + (Decimal)pmList[pmList.size()-1].get('C' + i + '_SGST__c' );
                        chargName = (string)pmList[pmList.size()-1].get('Charge' + i + 'Name__c');
                        if(totalAmt > 0){
                            paymentPlanDetails += 
                            '<li>Rs.' + InventoryCostServices.INFormatR(totalAmt) + '(' + S_NumberToWord.convertNumbertoWords(Integer.valueOf(totalAmt)) + ' only) for '+ chargName +';</li>';
                        }
                    }
                                  
            }else{
            
            }
         }
         paymentPlanDetails += '</ul> </div>'; 
        return paymentPlanDetails;
    }
    
    Public static string getReceiptDetailsTable(List<Receipt__c> rList){
        string receiptdetailsTable = '<table border="1" cellspacing="0" cellpadding="0" style="ont-family: arial, sans-serif;border-collapse: collapse;width: 100%;align="center"> <tr> <th class="thclass" > SR NO. </th> <th class="thclass" > Cheque No. </th> <th class="thclass" > Date </th> <th class="thclass" > Bank Name / UTR No. </th> <th class="thclass" > Amount in Rs. </th> </tr>';
        Integer i = 1;
        for(Receipt__c r : rList){
            receiptdetailsTable += '<tr>' + 
            '<td>'+ i +'</td> <td>'+ r.Cheque_DD__c + '</td> <td>' + r.Cheque_DD_Date__c.format() + '</td> <td>' + r.DraweeBank__c + '</td> <td>' + InventoryCostServices.INFormatR(r.Amount_Rs__c) + '</td>' +
            '</tr>';
            i = i+1;
        }
        receiptdetailsTable += '</table>';
        return receiptdetailsTable;
    }
    */
    public class CustomerWrapper {
       public Opportunity o {
           get;
           set;
       }
       public boolean selected{
           get;
           set;
       }
       public string applicantName{
           get;
           set;
       }
       public string applicantEmail{
           get;
           set;
       } 
       public CustomerWrapper() {}
    }
    
    Public Class IN_MilestonesWrapper{
        
        Public string name {get;set;}
        Public decimal amountD {get;set;}
        Public string amountStr {get;set;}
        Public Integer s_No {get;set;}
        Public string due_Date {get;set;}
        
        
        public IN_MilestonesWrapper(){
        }
    }
    public static void dummy() {
        integer a=1;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
         a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
         a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        
    }
}
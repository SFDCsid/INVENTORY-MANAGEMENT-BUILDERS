public class ViewDocument{
    public string oppId{get;set;}
    public string docType{get;set;}
    public string docName{get;set;}
    public List<Opportunity> oppList{get;set;}
    public List<Document_Template__c> docRecord { get;set; }
    public List<Booking__c> bookingRecord {get;set;}
    public String renderProp {get;set;}
    public boolean renderStatus { get;set; }
    public boolean renderPageNo { get;set; }
    public List<Property__c> propertyRecord {get;set;}
    public List<Quotation__c> quoteRecord {get;set;}
    public List<Account> accountRecord {get;set;}
    public List<Project__c> projectRecord {get;set;}
    public List<Tower__c> towerRecord {get;set;}
    public List<Applicant__c> primaryApplicant{get;set;}
    public List<Applicant__c> otherApplicant{get;set;}
    public Map<Integer,Integer> pagenumberMap{get;set;}
    public List<Related_Document_History__c> rdListChk{get;set;}
    public List<Related_Document_History__c> rdList{get;set;}
public List<Related_Document_History__c> rdLatestAgreementList{get;set;}
    public String refno{get;set;}
    public String customFloorNo{get;set;}
    public String rdId{get;set;}
    
    public ViewDocument() {
        oppList = new List<opportunity>();
        renderProp  = 'pdf';
        renderStatus =true;
        renderPageNo = true;
        bookingRecord = new List<Booking__c>();
        docRecord = new List<Document_Template__c>();
        propertyRecord = new List<Property__c>();
        quoteRecord = new List<Quotation__c>();
        accountRecord = new List<Account>();
        projectRecord = new List<Project__c>();
        towerRecord = new List<Tower__c>();
        primaryApplicant = new List<Applicant__c>();
        otherApplicant = new List<Applicant__c>();
        rdListChk = new List<Related_Document_History__c>();
        rdList = new List < Related_Document_History__c>();
        rdLatestAgreementList = new List < Related_Document_History__c>();
        refno='';
        customFloorNo='';
        String strlabel='';
        rdId = '';
        Decimal docSeries; 
         if(Apexpages.currentPage().getParameters().containsKey('oppId') && Apexpages.currentPage().getParameters().get('oppId') != null){
            oppId = Apexpages.currentPage().getParameters().get('oppId');
        }
        if(Apexpages.currentPage().getParameters().containsKey('docType') && Apexpages.currentPage().getParameters().get('docType') != null){
            docType = Apexpages.currentPage().getParameters().get('docType');
        }
        if(Apexpages.currentPage().getParameters().containsKey('docName') && Apexpages.currentPage().getParameters().get('docName') != null){
            docName = Apexpages.currentPage().getParameters().get('docName');
        }
        if(Apexpages.currentPage().getParameters().containsKey('rdId') && Apexpages.currentPage().getParameters().get('rdId') != null){
            rdId = Apexpages.currentPage().getParameters().get('rdId');
        }
        if(string.isNotBlank(oppId)){
            oppList = DocumentGenerationServices.getOpportunityDetails(oppId);
        }
      
      if(String.isNotBlank(rdId)){
           rdList = [Select Id, Name , Customer_Email_Id__c, Document_Generated_By__c, Document_Generated_Date_Time__c, Submitted_for_Approval__c,
                                                     Document_Name__c,Document_Approved__c, Document_Send_To_Customer_By__c, Opportunity__c,Opportunity__r.Name,
                                                     Project_Template_Label__c,Template_Label__c,Document_Number_Series__c,Ref_No_formula__c,QR_Code__c 
                                                     from Related_Document_History__c where Id =:rdId];
         
            if(!rdList.isEmpty()){
               refno = 'Ref No. <span style="font-size: 14px;"> '+rdList[0].Ref_No_formula__c+'</span>';
            }
        }
        if(oppList != null && !oppList.isEmpty() && oppList.size() == 1)  {
            bookingRecord = DocumentGenerationServices.getBookingDetails(oppList[0].Booking__c);
            docRecord = DocumentGenerationServices.getDocumentTemplate(bookingRecord[0].Project__C, docType, docName);
            propertyRecord = DocumentGenerationServices.getPropertyDetails(oppList[0].Property__c);
            quoteRecord = DocumentGenerationServices.getQuotationDetails(bookingRecord[0].Quotation__C);
            accountRecord = DocumentGenerationServices.getAccountDetails(oppList[0].accountId);
            projectRecord = DocumentGenerationServices.getProjectDetails(bookingRecord[0].Project__c);
            system.debug('t='+propertyRecord[0].Tower__c);
            towerRecord = DocumentGenerationServices.getTowerDetails(propertyRecord[0].Tower__c);
            primaryApplicant = DocumentGenerationServices.getApplicantDetails(bookingRecord[0].id);
            otherApplicant = DocumentGenerationServices.getOtherApplicantsDetails(bookingRecord[0].id);
        }
          if(bookingRecord!=null){
            rdLatestAgreementList = [Select Id, Name , Customer_Email_Id__c, Document_Generated_By__c, Document_Generated_Date_Time__c, Submitted_for_Approval__c,
                                                     Document_Name__c,Document_Approved__c, Document_Send_To_Customer_By__c, Opportunity__c,Opportunity__r.Name,
                                                     Sale_Price_Due_Till_Date__c,Sale_Price_Received_Till_Date__c,Booking__r.Quotation__r.Total_Agreement_Value_Modified__c,Booking__c,CreatedDate 
                                                     from Related_Document_History__c where Document_Name__c =:'Agreement Form' AND Booking__c =:bookingRecord[0].id order by CreatedDate DESC limit 1];
        } 
        system.debug('docRecord='+docRecord);
        if(!propertyRecord.isEmpty()){
          customFloorNo = getFloorOrdinal(propertyRecord[0].Floor_No__c);  
        }
        if(!docRecord.isEmpty()){
          if(docRecord[0].Disable_Page_No__c){
           renderPageNo = false; 
        }   
        }
        
      if(!projectRecord.isEmpty()){
        if(docType=='Acceptance Form'){
          strlabel = projectRecord[0].Acceptance_Doc_Label__c;
          docSeries = projectRecord[0].Acceptance_Series__c;    
        }else{
            if(docType=='NRI Declaration Form'){
             strlabel = projectRecord[0].NRI_Doc_Label__c;
             docSeries = projectRecord[0].NRI_Series__c;
            }else{
              if(docType=='Agreement Form'){
              strlabel = projectRecord[0].Agreement_Doc_Label__c;
              docSeries = projectRecord[0].Agreement_Series__c; 
              }else{
               if(docType=='Allotment Form'){
              strlabel = projectRecord[0].Allotment_Doc_Label__c;
              docSeries = projectRecord[0].Allotment_Series__c;
               }else{
                   if(docType=='Mortgage Release Request Letter'){
                        strlabel = projectRecord[0].Mortgage_Release_Request_Doc_Label__c;
                        docSeries = projectRecord[0].Mortgage_Release_Request_Letter_Series__c;
                   }else{
                       if(docType=='Agreement signing undertaking'){
                          strlabel = projectRecord[0].Agreement_signing_undertaking_Doc_Label__c;
                          docSeries = projectRecord[0].Agreement_signing_undertaking_Series__c; 
                       }else{
                           if(docType=='Annexure B - Nomination Form'){
                              strlabel = projectRecord[0].Annexure_B_Nomination_Form_Doc_Label__c;
                              docSeries = projectRecord[0].Annexure_B_Nomination_Form_Series__c; 
                           }else{
                               if(docType=='TPA'){
                                  strlabel = projectRecord[0].TPA_Doc_Label__c;
                                  docSeries = projectRecord[0].TPA_Series__c; 
                               }else{
                                   if(docType=='Bank NOC'){
                                       strlabel = projectRecord[0].Bank_NOC_Doc_Label__c;
                                       docSeries = projectRecord[0].Bank_NOC_Series__c; 
                                   }else{
                                       if(docType=='Provisional NOC'){
                                           strlabel = projectRecord[0].Provisional_NOC_Doc_Label__c;
                                           docSeries = projectRecord[0].Provisional_NOC_Series__c; 
                                       }else{
                                           if(docType=='L&L NOC'){
                                               strlabel = projectRecord[0].L_L_NOC_Doc_Label__c;
                                               docSeries = projectRecord[0].L_L_NOC_Series__c;
                                           }else{
                                               if(docType=='Car Park Allotment Letter'){
                                                   strlabel = projectRecord[0].Car_Park_Allotment_Letter_Doc_Label__c;
                                                   docSeries = projectRecord[0].Car_Park_Allotment_Letter_Series__c;
                                               }else{
                                                   if(docType=='Possession Undertaking Letter'){
                                                       strlabel = projectRecord[0].Possession_Undertaking_Letter_Doc_Label__c;
                                                       docSeries = projectRecord[0].Possession_Undertaking_Letter_Series__c;
                                                   }else{
                                                       if(docType=='Possession Letter'){
                                                           strlabel = projectRecord[0].Possession_Letter_Doc_Label__c;
                                                           docSeries = projectRecord[0].Possession_Letter_Series__c;
                                                       }else{
                                                           if(docType=='Electricity Meter transfer NOC'){
                                                              strlabel = projectRecord[0].Electricity_Meter_transfer_NOC_Doc_Label__c;
                                                              docSeries = projectRecord[0].Electricity_Meter_transfer_NOC_Series__c; 
                                                           }else{
                                                               if(docType=='Rejection Notice - Pre Possession'){
                                                                   strlabel = projectRecord[0].Rejection_Notice_Pre_Poss_Doc_Label__c;
                                                                   docSeries = projectRecord[0].Rejection_Notice_Pre_Possession_Series__c;
                                                               }else{
                                                                   if(docType=='Rejection Notice - Post Possession'){
                                                                       strlabel = projectRecord[0].Rejection_Notice_Post_Poss_Doc_Label__c;
                                                                       docSeries = projectRecord[0].Rejection_Notice_Post_Possession_Serie__c;
                                                                   }else{
                                                                       if(docType=='ROFR NOC Loan case'){
                                                                           strlabel = projectRecord[0].ROFR_NOC_Loan_case_Doc_Label__c;
                                                                           docSeries = projectRecord[0].ROFR_NOC_Loan_case_Series__c;
                                                                       }else{
                                                                        if(docType=='Agreement Generation Request'){
                                                                           strlabel = projectRecord[0].Agreement_Request_Label__c;
                                                                           docSeries = projectRecord[0].Agreement_Request_Series__c;
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
        
        if(!docRecord.isEmpty()&&!bookingRecord.isEmpty()&&String.isBlank(refno)){
        system.debug('docName::'+docName+' docType::'+docType);
             system.debug('bookingRecordProj::'+bookingRecord[0].Project__c);
        //checking booking level
        rdListChk = [SELECT Id,Name,Document_Name__c,Submitted_for_Approval__c,QR_Code__c,Booking__c,Ref_No_formula__c,Opportunity__r.Project__c,Booking__r.Project__r.id,CreatedDate,Opportunity__c,Project_Template_Label__c,Template_Label__c,Document_Number_Series__c 
                  FROM Related_Document_History__c
                  WHERE Document_Name__c=: docType AND Opportunity__r.Project__c =: bookingRecord[0].Project__c AND Document_Number_Series__c!=null Order by CreatedDate DESC];
       system.debug('rdListChk::'+rdListChk);
        refno = 'Ref No. <span style="font-size: 14px;">';
       if(!rdListChk.isEmpty()){
             String refval = String.valueOf(Integer.valueOf(rdListChk[0].Document_Number_Series__c)+1);
             refval = refval.leftPad(4, '0' );
             refno = refno+projectRecord[0].Project_Template_Label__c+'-'+ strlabel +'-'+ refval+'</span>';              
             System.debug('rdListChk::'+rdListChk);
        }else{
            if(String.isNotBlank(projectRecord[0].Project_Template_Label__c)&&String.isNotBlank(strlabel)&&docSeries!=null){
                String refval = String.valueOf(Integer.valueOf(docSeries));
                  refval = refval.leftPad(4, '0' );
             refno = refno+projectRecord[0].Project_Template_Label__c+'-'+ strlabel +'-'+ refval+'</span>';              
            }
          
        }
        }
        system.debug('refno::'+refno);
        if(docRecord.size()>0){
            System.debug('Inside doc record field merge:');
            
            if(docRecord[0].Clause_0__c != null)
                docRecord[0].Clause_0__c               = findAndReplaceMergeFields(docRecord[0].Clause_0__c);
            
            if(docRecord[0].Clause_1__c != null)
                docRecord[0].Clause_1__c               = findAndReplaceMergeFields(docRecord[0].Clause_1__c);
            
            if(docRecord[0].Clause_2__c != null)   
                docRecord[0].Clause_2__c               = findAndReplaceMergeFields(docRecord[0].Clause_2__c);
            
            if(docRecord[0].Clause_3__c != null)
                docRecord[0].Clause_3__c               = findAndReplaceMergeFields(docRecord[0].Clause_3__c);
            
            if(docRecord[0].Clause_4__c != null)
                docRecord[0].Clause_4__c               = findAndReplaceMergeFields(docRecord[0].Clause_4__c);
            
            if(docRecord[0].Clause_5__c != null)
                docRecord[0].Clause_5__c               = findAndReplaceMergeFields(docRecord[0].Clause_5__c);
            
            if(docRecord[0].Clause_6__c != null)
                docRecord[0].Clause_6__c               = findAndReplaceMergeFields(docRecord[0].Clause_6__c);
            
            if(docRecord[0].Clause_7__c != null)   
                docRecord[0].Clause_7__c               = findAndReplaceMergeFields(docRecord[0].Clause_7__c);
            
            if(docRecord[0].Clause_8__c != null)
                docRecord[0].Clause_8__c               = findAndReplaceMergeFields(docRecord[0].Clause_8__c);
            
            if(docRecord[0].Clause_9__c != null)
                docRecord[0].Clause_9__c               = findAndReplaceMergeFields(docRecord[0].Clause_9__c);
            
            if(docRecord[0].Clause_10__c != null)
                docRecord[0].Clause_10__c              = findAndReplaceMergeFields(docRecord[0].Clause_10__c);
        }
        
        
    }
    public string getFloorOrdinal(Decimal i){
        string num = string.valueof(i);
        string suffix = 'th';
        string ordinal = '';
        i = integer.valueof(num.right(2));
        if(10 < i && i < 14) {
            ordinal =  num + suffix;
        }else{
            string onesDigit = num.right(1);
            if(onesDigit == '1'){
                suffix = 'st';
            }else if(onesDigit == '2'){
                suffix = 'nd';
            }else if(onesDigit == '3'){
                suffix = 'rd';
            }
            ordinal = num+suffix;
        }
        return ordinal;
    }
    public string findAndReplaceMergeFields(String fieldValue){
        String replacementString            = fieldValue;
        pattern p                           = pattern.compile('\\{!(.*?)\\}');
        Matcher m                           = p.matcher(fieldValue);
        
        System.debug('m:' + m);
        
        while(m.find()) {
            System.debug('inside while loop:');
            List<String> objectAndfield     = new List<String>();
            String mergeFieldWithoutQuote   = m.group().substring( 2, m.group().length() - 1);
            System.debug('mergeFieldWithoutQuote:' + mergeFieldWithoutQuote);
            objectAndfield                  = mergeFieldWithoutQuote.split('\\.');
            String replacableString         = replaceMergeField(objectAndfield[0],objectAndfield[1]);
            System.debug('replaceable string:' + replacableString);
            if(String.isNotBlank(replacableString)){
              replacableString.removeStart('\'');
              replacableString.removeEnd('\'');
              replacementString = replacementString.replace(m.group(),replacableString);   
            }else{
              replacementString = replacementString.replace(m.group(),'');   
            }            
        }
        return replacementString;
        
    }
    
    public string replaceMergeField(String objName, String fieldname){
        system.debug('Seventh:'+ objName+''+fieldname);
        
        if(objName=='Schedule-Typical(Multi Tower Project)' && fieldname != null){ 
            if(fieldname == 'First Schedule'){
                System.debug('Under Acceptance');
                return DocumentGenerationServices.getFirstScheduleDetails(bookingRecord[0], quoteRecord[0], propertyRecord[0],primaryApplicant[0],towerRecord[0], objName,docType);
            }else if(fieldname == 'Second Schedule'){
                return DocumentGenerationServices.getSecondScheduleDetails(quoteRecord[0].id);
            }else if(fieldname == 'Third Schedule'){
                return DocumentGenerationServices.getThirdScheduleDetails(propertyRecord[0].Property_Type__c,docType);
            }else if(fieldname == 'Fourth Schedule'){
                return DocumentGenerationServices.getFourthScheduleDetails(propertyRecord[0].Property_Type__c,primaryApplicant[0],docType);
            }else if(fieldname == 'Fifth Schedule'){
                system.debug('getFifthScheduleDetails:: ');
                return DocumentGenerationServices.getFifthScheduleDetails(propertyRecord[0].Property_Type__c,docType);
            }else if(fieldname == 'Eleventh Schedule'){
                return DocumentGenerationServices.getEleventhScheduleDetails(propertyRecord[0].id);
            }else{
                return '';
            }
        }else if(objName=='Schedule-Typical (Tower as Seprate Project)' && fieldname != null){
            if(fieldname == 'First Schedule'){
                return DocumentGenerationServices.getFirstScheduleDetails(bookingRecord[0], quoteRecord[0], propertyRecord[0],primaryApplicant[0],towerRecord[0], objName,docType);
            }else if(fieldname == 'Second Schedule'){
                return DocumentGenerationServices.getSecondScheduleDetails(quoteRecord[0].id);
            }else if(fieldname == 'Third Schedule'){
                return DocumentGenerationServices.getThirdScheduleDetails(propertyRecord[0].Property_Type__c,docType);
            }else if(fieldname == 'Fourth Schedule'){
                return DocumentGenerationServices.getFourthScheduleDetails(propertyRecord[0].Property_Type__c,primaryApplicant[0],docType);
            }else if(fieldname == 'Fifth Schedule'){
                return DocumentGenerationServices.getFifthScheduleDetails(propertyRecord[0].Property_Type__c,docType);
            }else if(fieldname == 'Eleventh Schedule'){
                return DocumentGenerationServices.getEleventhScheduleDetails(propertyRecord[0].id);
            }else{
                return '';
            }
        }else if(objName=='Schedule-Duplex' && fieldname != null){
            if(fieldname == 'First Schedule'){
                return DocumentGenerationServices.getFirstScheduleDetails(bookingRecord[0], quoteRecord[0], propertyRecord[0],primaryApplicant[0],towerRecord[0], objName,docType);
            }else if(fieldname == 'Second Schedule'){
                return DocumentGenerationServices.getSecondScheduleDetails(quoteRecord[0].id);
            }else if(fieldname == 'Third Schedule'){
                return DocumentGenerationServices.getThirdScheduleDetails(propertyRecord[0].Property_Type__c,docType);
            }else if(fieldname == 'Fourth Schedule'){
                return DocumentGenerationServices.getFourthScheduleDetails(propertyRecord[0].Property_Type__c,primaryApplicant[0],docType);
            }else if(fieldname == 'Fifth Schedule'){
                return DocumentGenerationServices.getFifthScheduleDetails(propertyRecord[0].Property_Type__c,docType);
            }else if(fieldname == 'Eleventh Schedule'){
                return DocumentGenerationServices.getEleventhScheduleDetails(propertyRecord[0].id);
            }else{
                return '';
            }
        }else if(objName=='Schedule-Penthouse' && fieldname != null){
            if(fieldname == 'First Schedule'){
                return DocumentGenerationServices.getFirstScheduleDetails(bookingRecord[0], quoteRecord[0], propertyRecord[0],primaryApplicant[0],towerRecord[0], objName,docType);
            }else if(fieldname == 'Second Schedule'){
                return DocumentGenerationServices.getSecondScheduleDetails(quoteRecord[0].id);
            }else if(fieldname == 'Third Schedule'){
                return DocumentGenerationServices.getThirdScheduleDetails(propertyRecord[0].Property_Type__c,docType);
            }else if(fieldname == 'Fourth Schedule'){
                return DocumentGenerationServices.getFourthScheduleDetails(propertyRecord[0].Property_Type__c,primaryApplicant[0],docType);
            }else if(fieldname == 'Fifth Schedule'){
                return DocumentGenerationServices.getFifthScheduleDetails(propertyRecord[0].Property_Type__c,docType);
            }else if(fieldname == 'Eleventh Schedule'){
                return DocumentGenerationServices.getEleventhScheduleDetails(propertyRecord[0].id);
            }else{
                return '';
            }
        }else if(objName=='Schedule-Bare Shell' && fieldname != null){
            if(fieldname == 'First Schedule'){
                return DocumentGenerationServices.getFirstScheduleDetails(bookingRecord[0], quoteRecord[0], propertyRecord[0],primaryApplicant[0],towerRecord[0], objName,docType);
            }else if(fieldname == 'Second Schedule'){
                return DocumentGenerationServices.getSecondScheduleDetails(quoteRecord[0].id);
            }else if(fieldname == 'Third Schedule'){
                return DocumentGenerationServices.getThirdScheduleDetails(propertyRecord[0].Property_Type__c,docType);
            }else if(fieldname == 'Fourth Schedule'){
                return DocumentGenerationServices.getFourthScheduleDetails(propertyRecord[0].Property_Type__c,primaryApplicant[0],docType);
            }else if(fieldname == 'Fifth Schedule'){
                return DocumentGenerationServices.getFifthScheduleDetails(propertyRecord[0].Property_Type__c,docType);
            }else if(fieldname == 'Eleventh Schedule'){
                return DocumentGenerationServices.getEleventhScheduleDetails(propertyRecord[0].id);
            }else{
                return '';
            }
        }
        
        /*else if(objName=='SeventhTable1' && fieldname != null){
if(fieldname == 'SeventhTable'){
return DocumentGenerationServices.getSeventhScheduleDetails(bookingRecord[0], quoteRecord[0], propertyRecord[0],primaryApplicant[0],towerRecord[0], objName);
}
else{
return '';
}
}

else if(objName=='Morgage NOC' && fieldname != null){
if(fieldname == 'MorgageNOC1'){
return DocumentGenerationServices.MortageReleaseNOCTable(bookingRecord[0]);               
}else{
return '';
}
}

else if(objName=='Contact Details Update' && fieldname != null){
if(fieldname == 'Single Tower'){
return DocumentGenerationServices.CantactDetailUpdateSingleTower(bookingRecord[0]);
}else if(fieldname == 'Multi Tower'){
return DocumentGenerationServices.CantactDetailUpdateMultiTower(bookingRecord[0]);
}
else{
return '';
}
}

else if(objName=='Possesion' && fieldname != null){
if(fieldname == 'KeyHandoverChecklist'){
return DocumentGenerationServices.TransferFormateTable();
}else{
return '';
}
}*/
        
        else if(objName == 'Account' && fieldname != null){
            
            if(accountRecord.size()>0)
                if(accountRecord[0].get(fieldname) != null)
                return String.valueOf(accountRecord[0].get(fieldname));
            else
                return '';
            else 
                return '';
        }
        else if(objName == 'Booking__c' && fieldname != null){
            if(bookingRecord.size()>0){
                if(bookingRecord[0].get(fieldname) != null && fieldName == 'Booking_Date__c'){
                    string stDate = DocumentGenerationServices.customDateFormat((Date)bookingRecord[0].get(fieldname));
                    return stDate;
                }
                 if(bookingRecord[0].get(fieldname) != null && fieldName == 'Possession_Schedule_Date__c'){
                    string stDate = DocumentGenerationServices.customDateFormat((Date)bookingRecord[0].get(fieldname));
                    return stDate;
                }
                
                else if(bookingRecord[0].get(fieldname) != null){
                    return String.valueOf(bookingRecord[0].get(fieldname));
                }else{    
                    return ''; 
                }
            }    
            else{
                return '';
            }    
        }else if(objName == 'CustomFields' && fieldname != null){

            if(fieldName == 'Sales Price Due Till Date'){
                     string strAmt='0/-';
                     if(!rdLatestAgreementList.isEmpty()){
                         if(rdLatestAgreementList[0].Sale_Price_Due_Till_Date__c!=null&&rdLatestAgreementList[0].Sale_Price_Due_Till_Date__c>0){
                            strAmt = String.valueOf(QuotationManagmentServices.INFormatR(rdLatestAgreementList[0].Sale_Price_Due_Till_Date__c));   
                         }
                     }
                    return strAmt;
                }
                 if(fieldName == 'Sale Price Due Till Date Percentage'){
                    string strPercentage = '0%';
                    Decimal amt = 0;
                     if(!rdLatestAgreementList.isEmpty()){
                        if(rdLatestAgreementList[0].Sale_Price_Due_Till_Date__c!=null&&rdLatestAgreementList[0].Sale_Price_Due_Till_Date__c>0){
                           amt = (rdLatestAgreementList[0].Sale_Price_Due_Till_Date__c/rdLatestAgreementList[0].Booking__r.Quotation__r.Total_Agreement_Value_Modified__c)*100;
                           amt = amt.setScale(2);
                            strPercentage =  String.valueOf(amt)+'%';
                        }
                     }
                    return strPercentage;
                }
                 if( fieldName == 'Sale Price Received Till Date'){
                     string strAmt='0/-';
                      if(!rdLatestAgreementList.isEmpty()){
                         if(rdLatestAgreementList[0].Sale_Price_Received_Till_Date__c!=null&&rdLatestAgreementList[0].Sale_Price_Received_Till_Date__c>0){
                            strAmt = String.valueOf(QuotationManagmentServices.INFormatR(rdLatestAgreementList[0].Sale_Price_Received_Till_Date__c));   
                         }
                     }
                    return strAmt;
                }
                 if(fieldName == 'Sale Price Received Till Date Percentage'){
                     string strPercentage = '0%';
                    Decimal amt = 0;
                     if(!rdLatestAgreementList.isEmpty()){
                        if(rdLatestAgreementList[0].Sale_Price_Received_Till_Date__c!=null&&rdLatestAgreementList[0].Sale_Price_Received_Till_Date__c>0){
                           amt = (rdLatestAgreementList[0].Sale_Price_Received_Till_Date__c/rdLatestAgreementList[0].Booking__r.Quotation__r.Total_Agreement_Value_Modified__c)*100;
                           amt = amt.setScale(2);
                            strPercentage =  String.valueOf(amt)+'%';
                        }
                     }   
                     return strPercentage;
                }
            
                return '';
     }
        else if(objName == 'Project__c' && fieldname != null){
            if(ProjectRecord.size()>0)
                if(ProjectRecord[0].get(fieldname) != null&&fieldname == 'Subsidiary_Company_Name__c')
                return '<b>'+String.valueOf(ProjectRecord[0].get(fieldname))+'</b>';
            else
                if(ProjectRecord[0].get(fieldname) != null)
                return String.valueOf(ProjectRecord[0].get(fieldname));
            else
                return '';
            else
                return '';
        }
        else if(objName == 'Tower__c' && fieldname != null){
            if(towerRecord.size()>0)
                if(towerRecord[0].get(fieldname) != null)
                return String.valueOf(towerRecord[0].get(fieldname));
            else
                return '';
            else
                return '';
        }
        else if(objName == 'Property__c' && fieldname != null){
            if(propertyRecord.size()>0)
                if(propertyRecord[0].get(fieldname) != null)
                return String.valueOf(propertyRecord[0].get(fieldname));
            else
                return '';
            else
                return '';
        }
        else if(objName == 'Opportunity' && fieldname != null){
            if(oppList.size()>0){
                if(oppList[0].get(fieldname) != null){
                  return String.valueOf(oppList[0].get(fieldname));  
                }           
                else{
                 return '';
                }
            }
            else
                return '';
        }
        else if(objName == 'Applicant__c' && fieldname != null){
            if(primaryApplicant.size()>0)
                if(primaryApplicant[0].get(fieldname) != null)
                return String.valueOf(primaryApplicant[0].get(fieldname));
            else
                return '';
            else
                return '';
        }
        else if(objName == 'Quotation__C' && fieldname != null){
            if(quoteRecord.size()>0)
                if(quoteRecord[0].get(fieldname) != null)
                return String.valueOf(quoteRecord[0].get(fieldname));
            else
                return '';
            else
                return '';
        }
        else if(objName == 'OtherApplicantDetails' && fieldname != null){
            if(otherApplicant.size()>0){
                for(Applicant__C ap : otherApplicant){
                    string address = ap.Permanent_Address__c + ', ' + ap.Mailing_City__c + ', ' + ap.Mailing_State__c +
                        ', ' + ap.Mailing_Country__c + ', ' + ap.Pincode__c;
                    if(ap.Applicant_Number__c == 'Second Applicant'){
                        if(fieldName == 'Second Applicant Name'){
                            return ap.name;
                        }else if(fieldName == 'Second Applicant Address'){
                            return address; 
                        }else if(fieldName == 'Second Applicant PAN'){
                            return ap.PancardNo__c; 
                        }else if(fieldName == 'Second Applicant Email'){
                            return ap.Email_Address__c; 
                        }else if(fieldName == 'Second Applicant Salutation'){
                            return ap.Salutation__c;
                        }else if(fieldName == 'Second Applicant Index'){
                            return ap.Index__c;
                        }
                    }else if(ap.Applicant_Number__c == 'Third Applicant'){
                        if(fieldName == 'Third Applicant Name'){
                            return ap.name;
                        }else if(fieldName == 'Third Applicant Address'){
                            return address; 
                        }else if(fieldName == 'Third Applicant PAN'){
                            return ap.PancardNo__c; 
                        }else if(fieldName == 'Third Applicant Email'){
                            return ap.Email_Address__c; 
                        }else if(fieldName == 'Third Applicant Salutation'){
                            return ap.Salutation__c;
                        }else if(fieldName == 'Third Applicant Index'){
                            return ap.Index__c;
                        }
                    }else if(ap.Applicant_Number__c == 'Fourth Applicant'){
                        if(fieldName == 'Fourth Applicant Name'){
                            return ap.name;
                        }else if(fieldName == 'Fourth Applicant Address'){
                            return address; 
                        }else if(fieldName == 'Fourth Applicant PAN'){
                            return ap.PancardNo__c; 
                        }else if(fieldName == 'Fourth Applicant Email'){
                            return ap.Email_Address__c; 
                        }else if(fieldName == 'Fourth Applicant Salutation'){
                            return ap.Salutation__c;
                        }else if(fieldName == 'Fourth Applicant Index'){
                            return ap.Index__c;
                        }
                    }else if(ap.Applicant_Number__c == 'Fifth Applicant'){
                        if(fieldName == 'Fifth Applicant Name'){
                            return ap.name;
                        }else if(fieldName == 'Fifth Applicant Address'){
                            return address; 
                        }else if(fieldName == 'Fifth Applicant PAN'){
                            return ap.PancardNo__c; 
                        }else if(fieldName == 'Fifth Applicant Email'){
                            return ap.Email_Address__c; 
                        }else if(fieldName == 'Fifth Applicant Salutation'){
                            return ap.Salutation__c;
                        }else if(fieldName == 'Fifth Applicant Index'){
                            return ap.Index__c;
                        }
                    }   
                }
            }
            return '';
        }else   if(objName == 'AllApplicantDetails' && fieldname != null){
            if(otherApplicant.size()>0){ 
                if(fieldname == 'All Applicant Names'){
                    return DocumentGenerationServices.getAllApplicantNames(otherApplicant);   
                } else if(fieldname == 'All Applicant Signatures'){
                    return DocumentGenerationServices.getAllApplicantSignatures(otherApplicant);     
                }else if(fieldname == 'All Applicant Names with Index'){
                    return DocumentGenerationServices.getAllApplicantNameswithIndex(otherApplicant);   
                }else if(fieldname == 'All Applicant Names with Index AFS'){
                    return DocumentGenerationServices.getAllApplicantNameswithIndexAFS(otherApplicant);
                }else if(fieldname == 'All Applicant Names Inline'){
                    return DocumentGenerationServices.getAllApplicantNamesInline(otherApplicant);     
                }else if(fieldname == 'All Applicant Names with Index and Linebreak'){
                    return DocumentGenerationServices.getAllApplicantNameswithIndexandLinebreak(otherApplicant);     
                }else if(fieldname == 'All Applicant Allotment Signature'){
                    return DocumentGenerationServices.getAllApplicantAllotmentSignature(otherApplicant,projectRecord[0].Subsidiary_Company_Name__c);
                }else if(fieldname == 'All Applicant Allotment Signature2'){
                    return DocumentGenerationServices.getAllApplicantAllotmentSignature2(otherApplicant,projectRecord[0].Subsidiary_Company_Name__c);
                }else if(fieldname == 'All Applicant Names with Allottees'){
                    return DocumentGenerationServices.getAllApplicantNameswithAllottees(otherApplicant); 
                }else if(fieldname == 'All Applicant Names with Linebreak and Allottees'){
                    return DocumentGenerationServices.getAllApplicantNameswithLinebreakandAllottees(otherApplicant); 
                }else if(fieldname == 'All Applicant Names For Car Park'){
                    return DocumentGenerationServices.getAllApplicantNamesForCarPark(otherApplicant);     
                }else if(fieldname == 'All Applicant Car Park Letter Signature'){
                    return DocumentGenerationServices.getCarParkSignatures(otherApplicant,projectRecord[0].Subsidiary_Company_Name__c);     
                }else if(fieldname == 'All Applicant Names Possession Letter'){
                    return DocumentGenerationServices.getAllApplicantNamesForPossessionLetter(otherApplicant,projectRecord[0].Subsidiary_Company_Name__c);     
                }else if(fieldname == 'All Applicant Names Possession Undertaking Letter'){
                    return DocumentGenerationServices.getAllApplicantNamesForPossessionUndertaking(otherApplicant,projectRecord[0].Subsidiary_Company_Name__c);     
                }else if(fieldname == 'All Applicant PANCards'){
                    return DocumentGenerationServices.getAllApplicantPANCards(otherApplicant);                         
                }else{ 
                    return '';  
                }
            }
            return '';
        }else if (objName == 'Annexure' && fieldname != null)
        {
            if(fieldname == 'Annexure A')
            {
                return DocumentGenerationServices.getAnnexureB(bookingRecord[0],docType);
            }
            
            if(fieldname == 'Annexure B')
            {
                return DocumentGenerationServices.getAnnexureA(ProjectRecord[0].id,docType);
            }
            
            else
                return '';
        }else if (objName == 'PageBreak' && fieldname != null){
            if(fieldname == 'sPageBreak')
                return DocumentGenerationServices.sPageBreak();   
            else
                return '';
        }else if (objName == 'Justify' && fieldname != null)
        {
            if(fieldname == 'sJustify')
            {
                return DocumentGenerationServices.startJustify();
            }
            
            if(fieldname == 'eJustify')
            {
                return DocumentGenerationServices.endJustify();
            }
            
            else
                return '';
        }else if(objName == 'lineBreak' && fieldname != null)
        {
            if(fieldname == 'lineBreak')
            {
                return DocumentGenerationServices.breakLine();
            }else
                return '';
        }else if(objName == 'olDecimal' && fieldname != null)
        {
            if(fieldname == 'sOLDecimal')
            {
                return DocumentGenerationServices.sOLDecimal();
            }
            if(fieldname == 'eOLDecimal')
            {
                return DocumentGenerationServices.eOLDecimal();
            }
            if(fieldname == 'sDecimalList')
            {
                return DocumentGenerationServices.sDecimalList();
            }
            if(fieldname == 'eDecimalList')
            {
                return DocumentGenerationServices.eDecimalList();
            }
            else 
                return '';
        }else if(objName == 'Table' && fieldname != null)
        {
            if(fieldname == 'TableStart')
            {
                return DocumentGenerationServices.tableStart();
            }
            if(fieldname == 'TableEnd')
            {
                return DocumentGenerationServices.tableEnd();
            }
            if(fieldname == 'TRowStart')
            {
                return DocumentGenerationServices.trowStart();
            }
            if(fieldname == 'TRowEnd')
            {
                return DocumentGenerationServices.trowEnd();
            }
            if(fieldname == 'TCellStart')
            {
                return DocumentGenerationServices.tcellStart();
            }
            if(fieldname == 'TCellStart2')
            {
                return DocumentGenerationServices.tcellStart2();
            }
            if(fieldname == 'TCellEnd')
            {
                return DocumentGenerationServices.tcellEnd();
            }
            if(fieldname == 'THeaderStart')
            {
                return DocumentGenerationServices.theaderStart();
            }
            if(fieldname == 'THeaderEnd')
            {
                return DocumentGenerationServices.theaderEnd();
            }
            else 
                return '';
        }else if(objName == 'QRCode' && fieldname != null)
        {
            if(fieldname == 'QRCodeField'&&!rdList.isEmpty())
            {
                return DocumentGenerationServices.QRCodeField(rdList);
            }
            else
                return '';
        }else if(objName == 'Addresses' && fieldname != null)
        {
            if(fieldname == 'Bank NOC Address')
            {
                return DocumentGenerationServices.getBankNOCAddress(bookingRecord[0]);
            }
            else if(fieldname == 'Provisional Bank NOC Address')
            {
                return DocumentGenerationServices.getProvisionalBankNOCAddress(bookingRecord[0]);
            }else if(fieldname == 'Primary Applicant Mailing Address')
            {
                return DocumentGenerationServices.getPrimaryMailingAddress(primaryApplicant[0]);
            }else if(fieldname == 'Primary Applicant Billing Address')
            {
                return DocumentGenerationServices.getPrimaryBillingAddress(primaryApplicant[0]);
            }else
                return '';
        }else if(objName == 'TPA Signature' && fieldname != null)
        {
            if(fieldname == 'TPASign')
            {
                return DocumentGenerationServices.TPASign(otherApplicant);
            }
            else 
                return '';
        }else if(objName == 'p' && fieldname != null)
        {
            if(fieldname == 'pStart')
            {
                return DocumentGenerationServices.pStart();
            }
            if(fieldname == 'pEnd') 
            {
                return DocumentGenerationServices.pEnd();
            }
            else
                return '';
        }else if(objName == 'ReferenceNo' && fieldname != null)
        {
            if(fieldname == 'refno')
            {
       System.debug('Inside refno::'+refno);
        
                return refno;
            }
            else
                return '';
        }else if(objName == 'FloorNo' && fieldname != null)
        {
            if(fieldname == 'FloorNo')
            {
             System.debug('Inside FloorNo::'+customFloorNo);
        
                return customFloorNo;
            }
            else
                return '';
        }
        else if(objName == 'ol' && fieldname != null)
        {
            if(fieldname == 'sOL')
            {
                return DocumentGenerationServices.sOL();
            }
            if(fieldname == 'eOL')
            {
                return DocumentGenerationServices.eOL();
            }
            
            if(fieldname == 'sLId')
            {
                return DocumentGenerationServices.sLId();
            }
            if(fieldname == 'eLId')
            {
                return DocumentGenerationServices.eLId();
            }
            if(fieldname == 'sLIa')
            {
                return DocumentGenerationServices.sLIa();
            }
            if(fieldname == 'eLIa')
            {
                return DocumentGenerationServices.eLIa();
            }
            if(fieldname == 'sLIUA')
            {
                return DocumentGenerationServices.sLIUA();
            }
            if(fieldname == 'eLIUA')
            {
                return DocumentGenerationServices.eLIUA();
            }
            if(fieldname == 'sLIr')
            {
                return DocumentGenerationServices.sLIr();
            }
            if(fieldname == 'eLIr')
            {
                return DocumentGenerationServices.eLIr();
            }else
                return '';
        }
        else{
            return '';
        }
        
    }
    
    
    /*  @AuraEnabled
public static Map<String,String> getAllFields(String obj){

Map<String,String> options                  = new Map<String,String>();
Map <String, Schema.SObjectType> schemaMap  = Schema.getGlobalDescribe();
Map <String, Schema.SObjectField> fieldMap  = schemaMap.get(obj).getDescribe().fields.getMap();

for(Schema.SObjectField sfield : fieldMap.Values())
{
schema.describefieldresult dfield = sfield.getDescribe();
if(dfield.isUpdateable())
options.put(dfield.getLabel(),dfield.getname());
}
return options;
}

public string getCurrentUserDetailsTable(){

string currentUserDetailsTable = '';

User currentuser=[SELECT Id,Name,Email,Phone,MobilePhone 
From User 
WHERE Id=:userinfo.getuserId()];

try{
currentUserDetailsTable +='<div frame="box" style="font-size:11px" cellspacing="0" cellpadding="0">';
currentUserDetailsTable +='The Application was generated by'+'</td><td></td></tr>';
currentUserDetailsTable +='Name      :'+ (String.valueof(currentuser.Name)!= null?string.valueOf(currentuser.Name):'')+'<br/>';
currentUserDetailsTable +='Email     :'+ (String.valueof(currentuser.Email)!= null?string.valueOf(currentuser.Email):'')+'<br/>';
currentUserDetailsTable +='Contact No:'+ (String.valueof(currentuser.MobilePhone)!= null?string.valueOf(currentuser.MobilePhone):'')+'<br/>';
currentUserDetailsTable +='</div>';


}catch(Exception ex){
}
return  currentUserDetailsTable;

} */
    //////////////////ADDED BY PRASHANT 26-09-2018////////////////////////////////////////////////////////////////////////////////////////////////
    /* public string getBookingOwnerDetailsTable(){

string bookingOwnerUserDetailsTable = '';

User bookingOwner=[SELECT Id,Name,Email,Phone,MobilePhone  
From User  
WHERE Id=:oppList[0].OwnerId];

try{
bookingOwnerUserDetailsTable +='<div frame="box" style="font-size:11px" cellspacing="0" cellpadding="0">';
bookingOwnerUserDetailsTable +='The Application was generated by'+'</td><td></td></tr>';
bookingOwnerUserDetailsTable +='Name      :'+ (String.valueof(bookingOwner.Name)!= null?string.valueOf(bookingOwner.Name):'')+'<br/>';
bookingOwnerUserDetailsTable +='Email     :'+ (String.valueof(bookingOwner.Email)!= null?string.valueOf(bookingOwner.Email):'')+'<br/>';
bookingOwnerUserDetailsTable +='Contact No:'+ (String.valueof(bookingOwner.MobilePhone)!= null?string.valueOf(bookingOwner.MobilePhone):'')+'<br/>';
bookingOwnerUserDetailsTable +='</div>';


}catch(Exception ex){
}
return bookingOwnerUserDetailsTable;

} */
    //////////////////////////END OF CODE WRITTEN BY PRASHANT/////////////////////////////////////////////////////////////////////////////
    
}
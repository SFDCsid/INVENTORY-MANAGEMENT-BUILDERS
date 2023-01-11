public class ViewDocumentSync{
    public string oppId{get;set;}
    public string docType{get;set;}
    public string docName{get;set;}
    public List<Opportunity> oppList{get;set;}
    public List<Document_Template__c> docRecord { get;set; }
    public List<Booking__c> bookingRecord {get;set;}
    public String renderProp {get;set;}
    public boolean renderStatus { get;set; }
    public List<Property__c> propertyRecord {get;set;}
    public List<Quotation__c> quoteRecord {get;set;}
    public List<Account> accountRecord {get;set;}
    public List<Project__c> projectRecord {get;set;}
    public List<Tower__c> towerRecord {get;set;}
    public List<Applicant__c> primaryApplicant{get;set;}
    public List<Applicant__c> otherApplicant{get;set;}
    
    public ViewDocumentSync() {
        oppList = new List<opportunity>();
        renderProp  = 'pdf';
        renderStatus =true;
        bookingRecord = new List<Booking__c>();
        docRecord = new List<Document_Template__c>();
        propertyRecord = new List<Property__c>();
        quoteRecord = new List<Quotation__c>();
        accountRecord = new List<Account>();
        projectRecord = new List<Project__c>();
        towerRecord = new List<Tower__c>();
        primaryApplicant = new List<Applicant__c>();
        otherApplicant = new List<Applicant__c>();
        
        if(Apexpages.currentPage().getParameters().containsKey('oppId') && Apexpages.currentPage().getParameters().get('oppId') != null){
            oppId = Apexpages.currentPage().getParameters().get('oppId');
        }
        if(Apexpages.currentPage().getParameters().containsKey('docType') && Apexpages.currentPage().getParameters().get('docType') != null){
            docType = Apexpages.currentPage().getParameters().get('docType');
        }
        if(Apexpages.currentPage().getParameters().containsKey('docName') && Apexpages.currentPage().getParameters().get('docName') != null){
            docName = Apexpages.currentPage().getParameters().get('docName');
        }
        
        if(string.isNotBlank(oppId)){
            oppList = DocumentGenerationServicesSync.getOpportunityDetails(oppId);
        }
        if(oppList != null && !oppList.isEmpty() && oppList.size() == 1)  {
            bookingRecord = DocumentGenerationServicesSync.getBookingDetails(oppList[0].Booking__c);
            docRecord = DocumentGenerationServicesSync.getDocumentTemplate(bookingRecord[0].Project__C, docType, docName);
            propertyRecord = DocumentGenerationServicesSync.getPropertyDetails(oppList[0].Property__c);
            quoteRecord = DocumentGenerationServicesSync.getQuotationDetails(bookingRecord[0].Quotation__C);
            accountRecord = DocumentGenerationServicesSync.getAccountDetails(oppList[0].accountId);
            projectRecord = DocumentGenerationServicesSync.getProjectDetails(bookingRecord[0].Project__C);
            towerRecord = DocumentGenerationServicesSync.getTowerDetails(propertyRecord[0].Tower__c);
            primaryApplicant = DocumentGenerationServicesSync.getApplicantDetails(bookingRecord[0].id);
            otherApplicant = DocumentGenerationServicesSync.getOtherApplicantsDetails(bookingRecord[0].id);
        }
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
            replacableString.removeStart('\'');
            replacableString.removeEnd('\'');
            replacementString               = replacementString.replace(m.group(),replacableString);
            
        }
        return replacementString;
        
    }
    
    public string replaceMergeField(String objName, String fieldname){
        system.debug('Seventh:'+ objName+''+fieldname);
        
        if(objName=='Schedule-Typical(Multi Tower Project)' && fieldname != null){ 
            if(fieldname == 'First Schedule'){
                return DocumentGenerationServicesSync.getFirstScheduleDetails(bookingRecord[0], quoteRecord[0], propertyRecord[0],primaryApplicant[0],towerRecord[0], objName);
            }else if(fieldname == 'Second Schedule'){
                return DocumentGenerationServicesSync.getSecondScheduleDetailsNew(quoteRecord[0].id);
            }else if(fieldname == 'Third Schedule'){
                return DocumentGenerationServicesSync.getThirdScheduleDetails(propertyRecord[0].Property_Type__c);
            }else if(fieldname == 'Fourth Schedule'){
                return DocumentGenerationServicesSync.getFourthScheduleDetails(propertyRecord[0].Property_Type__c);
            }else if(fieldname == 'Fifth Schedule'){
                system.debug('getFifthScheduleDetails:: ');
                return DocumentGenerationServicesSync.getFifthScheduleDetails(propertyRecord[0].Property_Type__c);
            }else{
                return '';
            }
        }else if(objName=='Schedule-Typical (Tower as Seprate Project)' && fieldname != null){
            if(fieldname == 'First Schedule'){
                return DocumentGenerationServicesSync.getFirstScheduleDetails(bookingRecord[0], quoteRecord[0], propertyRecord[0],primaryApplicant[0],towerRecord[0], objName);
            }else if(fieldname == 'Second Schedule'){
                return DocumentGenerationServicesSync.getSecondScheduleDetailsNew(quoteRecord[0].id);
            }else if(fieldname == 'Third Schedule'){
                return DocumentGenerationServicesSync.getThirdScheduleDetails(propertyRecord[0].Property_Type__c);
            }else if(fieldname == 'Fourth Schedule'){
                return DocumentGenerationServicesSync.getFourthScheduleDetails(propertyRecord[0].Property_Type__c);
            }else if(fieldname == 'Fifth Schedule'){
                return DocumentGenerationServicesSync.getFifthScheduleDetails(propertyRecord[0].Property_Type__c);
            }else{
                return '';
            }
        }else if(objName=='Schedule-Duplex' && fieldname != null){
            if(fieldname == 'First Schedule'){
                return DocumentGenerationServicesSync.getFirstScheduleDetails(bookingRecord[0], quoteRecord[0], propertyRecord[0],primaryApplicant[0],towerRecord[0], objName);
            }else if(fieldname == 'Second Schedule'){
                return DocumentGenerationServicesSync.getSecondScheduleDetailsNew(quoteRecord[0].id);
            }else if(fieldname == 'Third Schedule'){
                return DocumentGenerationServicesSync.getThirdScheduleDetails(propertyRecord[0].Property_Type__c);
            }else if(fieldname == 'Fourth Schedule'){
                return DocumentGenerationServicesSync.getFourthScheduleDetails(propertyRecord[0].Property_Type__c);
            }else if(fieldname == 'Fifth Schedule'){
                return DocumentGenerationServicesSync.getFifthScheduleDetails(propertyRecord[0].Property_Type__c);
            }else{
                return '';
            }
        }else if(objName=='Schedule-Penthouse' && fieldname != null){
            if(fieldname == 'First Schedule'){
                return DocumentGenerationServicesSync.getFirstScheduleDetails(bookingRecord[0], quoteRecord[0], propertyRecord[0],primaryApplicant[0],towerRecord[0], objName);
            }else if(fieldname == 'Second Schedule'){
                return DocumentGenerationServicesSync.getSecondScheduleDetailsNew(quoteRecord[0].id);
            }else if(fieldname == 'Third Schedule'){
                return DocumentGenerationServicesSync.getThirdScheduleDetails(propertyRecord[0].Property_Type__c);
            }else if(fieldname == 'Fourth Schedule'){
                return DocumentGenerationServicesSync.getFourthScheduleDetails(propertyRecord[0].Property_Type__c);
            }else if(fieldname == 'Fifth Schedule'){
                return DocumentGenerationServicesSync.getFifthScheduleDetails(propertyRecord[0].Property_Type__c);
            }else{
                return '';
            }
        }else if(objName=='Schedule-Bare Shell' && fieldname != null){
            if(fieldname == 'First Schedule'){
                return DocumentGenerationServicesSync.getFirstScheduleDetails(bookingRecord[0], quoteRecord[0], propertyRecord[0],primaryApplicant[0],towerRecord[0], objName);
            }else if(fieldname == 'Second Schedule'){
                return DocumentGenerationServicesSync.getSecondScheduleDetailsNew(quoteRecord[0].id);
            }/*else if(fieldname == 'Third Schedule'){
                return DocumentGenerationServices.getThirdScheduleDetails(propertyRecord[0].Property_Type__c);
            }else if(fieldname == 'Fourth Schedule'){
                return DocumentGenerationServices.getFourthScheduleDetails(propertyRecord[0].Property_Type__c);
            }else if(fieldname == 'Fifth Schedule'){
                return DocumentGenerationServices.getFifthScheduleDetails(propertyRecord[0].Property_Type__c);
            }*/else{
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
                    string stDate = DocumentGenerationServicesSync.customDateFormat((Date)bookingRecord[0].get(fieldname));
                    return stDate;
                }
                else if(bookingRecord[0].get(fieldname) != null){
                    return String.valueOf(bookingRecord[0].get(fieldname));
                }else{    
                    return ''; }
            }    
            else{
                return '';
            }    
        }
        else if(objName == 'Project__c' && fieldname != null){
            if(ProjectRecord.size()>0)
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
            if(oppList.size()>0)
                if(oppList[0].get(fieldname) != null)
                return String.valueOf(oppList[0].get(fieldname));
            else
                return '';
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
                        }
                    }   
                }
            }
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
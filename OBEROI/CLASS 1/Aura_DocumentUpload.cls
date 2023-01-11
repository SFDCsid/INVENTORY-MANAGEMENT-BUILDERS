public class Aura_DocumentUpload {
    
    @AuraEnabled
    public static List<String> getDocType(String objectName, String FieldName){
    List<String> DocType = new List<String>();

        Map<string,schema.sObjectType> objmap = schema.getGlobalDescribe();
        Schema.SObjectType obj = objmap.get(objectName);
        schema.DescribeSObjectResult result = obj.getDescribe();
        
        Map<string,schema.sObjectField> fldmap = result.fields.getMap();
        schema.sobjectField fields = fldmap.get(FieldName);
        schema.DescribeFieldResult fldres = fields.getDescribe();
        
        if(fldres.getType() == Schema.displayType.PICKLIST){
            List<Schema.PicklistEntry>  Entry = fldres.getPicklistValues();
            DocType.add('--Select One Value--');
            for( Schema.PicklistEntry p : Entry){
                DocType.add(p.getvalue());
            }
        }
        
        system.debug('DOCtype:::'+DocType);
        return DocType;
    }
    @AuraEnabled(cacheable = true)
    public static List<String> getObjectList(){
        //Added by Ashik
        List<String>  objectLst =new List<String>();
        objectLst.clear();
        objectLst.add('Account');
        objectLst.add('Opportunity');
        objectLst.add('Booking');
        objectLst.add('Applicants');
        objectLst.add('Project');
        objectLst.add('Tower');
        objectLst.add('Property');
        objectLst.add('Quotation');
        objectLst.add('OtherApplicantDetails');
        objectLst.add('Schedule-Typical(Multi Tower Project)');
        objectLst.add('Schedule-Typical (Tower as Seprate Project)');
        objectLst.add('Schedule-Duplex');
        objectLst.add('Schedule-Penthouse');
        objectLst.add('Schedule-Bare Shell');
        objectLst.add('SeventhTable1');
        objectLst.add('Morgage NOC');
        objectLst.add('Contact Details Update');
        objectLst.add('Possesion');
        /*objectLst.add(new Selectlist('Legal_Entity__c','Legal Entity'));
        objectLst.add(new Selectlist('UnitCost','UnitCost'));
        objectLst.add(new Selectlist('PaymentReceived','PaymentReceived'));
        objectLst.add(new Selectlist('PaymentPlanDetails','PaymentPlanDetails'));
        objectLst.add(new Selectlist('RMSignatureTable','RMSignatureTable'));
        objectLst.add(new Selectlist('PrimaryApplicantDetails','PrimaryApplicantDetails'));
        objectLst.add(new Selectlist('OtherApplicantDetails','OtherApplicantDetails'));
        objectLst.add(new Selectlist('ParkingDetails','ParkingDetails'));
        objectLst.add(new Selectlist('Miscellaneous','Miscellaneous'));*/

        return objectLst;
    }

    @AuraEnabled(cacheable = true)
    public static List<Selectlist> GetFieldList(String selectedObject){
        system.debug('prepareFieldList Got called::: '+selectedObject );
        List<Selectlist> fieldLst =new List<Selectlist>();
    try{
        
        if(selectedObject != 'UnitCost' 
           && selectedObject != 'PrimaryApplicantDetails' 
           && selectedObject != 'OtherApplicantDetails' 
           && selectedObject != 'PaymentReceived'
           && selectedObject != 'PaymentPlanDetails'
           && selectedObject != 'ParkingDetails'
           && selectedObject != 'RMSignatureTable'
           && selectedObject != 'Miscellaneous'
           && selectedObject != 'Schedule-Typical(Multi Tower Project)'
           && selectedObject != 'Schedule-Typical (Tower as Seprate Project)'
           && selectedObject != 'Schedule-Duplex'
           && selectedObject != 'Schedule-Penthouse'
           && selectedObject != 'Schedule-Bare Shell'
           && selectedObject != 'SeventhTable1'
           && selectedObject != 'Morgage NOC'
           && selectedObject != 'Contact Details Update'
           && selectedObject != 'Possesion'
        ){
               //fieldLst = getAllFields(selectedObject);
        }else if (selectedObject == 'OtherApplicantDetails'){
                fieldLst.clear();
                fieldLst.add(new Selectlist('Second Applicant Salutation','Second Applicant Salutation'));
                fieldLst.add(new Selectlist('Second Applicant Name','Second Applicant Name'));
                fieldLst.add(new Selectlist('Second Applicant Address','Second Applicant Address'));
                fieldLst.add(new Selectlist('Second Applicant PAN','Second Applicant PAN'));
                fieldLst.add(new Selectlist('Second Applicant Email','Second Applicant Email'));
                
                fieldLst.add(new Selectlist('Third Applicant Salutation','Third Applicant Salutation'));
                fieldLst.add(new Selectlist('Third Applicant Name','Third Applicant Name'));
                fieldLst.add(new Selectlist('Third Applicant Address','Third Applicant Address'));
                fieldLst.add(new Selectlist('Third Applicant PAN','Third Applicant PAN'));
                fieldLst.add(new Selectlist('Third Applicant Email','Third Applicant Email'));
                
                fieldLst.add(new Selectlist('Fourth Applicant Salutation','Fourth Applicant Salutation'));
                fieldLst.add(new Selectlist('Fourth Applicant Name','Fourth Applicant Name'));
                fieldLst.add(new Selectlist('Fourth Applicant Address','Fourth Applicant Address'));
                fieldLst.add(new Selectlist('Fourth Applicant PAN','Fourth Applicant PAN'));
                fieldLst.add(new Selectlist('Fourth Applicant Email','Fourth Applicant Email'));
                
                fieldLst.add(new Selectlist('Fifth Applicant Salutation','Fifth Applicant Salutation'));
                fieldLst.add(new Selectlist('Fifth Applicant Name','Fifth Applicant Name'));
                fieldLst.add(new Selectlist('Fifth Applicant Address','Fifth Applicant Address'));
                fieldLst.add(new Selectlist('Fifth Applicant PAN','Fifth Applicant PAN'));
                fieldLst.add(new Selectlist('Fifth Applicant Email','Fifth Applicant Email'));
                
        }else if (selectedObject == 'Schedule-Typical(Multi Tower Project)'){
                fieldLst.clear();
                fieldLst.add(new Selectlist('First Schedule','First Schedule'));
                fieldLst.add(new Selectlist('Second Schedule','Second Schedule'));
                fieldLst.add(new Selectlist('Third Schedule','Third Schedule'));
                fieldLst.add(new Selectlist('Fourth Schedule','Fourth Schedule'));
                fieldLst.add(new Selectlist('Fifth Schedule','Fifth Schedule'));
        }else if (selectedObject == 'Schedule-Typical (Tower as Seprate Project)'){
                fieldLst.clear();
                fieldLst.add(new Selectlist('First Schedule','First Schedule'));
                fieldLst.add(new Selectlist('Second Schedule','Second Schedule'));
                fieldLst.add(new Selectlist('Third Schedule','Third Schedule'));
                fieldLst.add(new Selectlist('Fourth Schedule','Fourth Schedule'));
                fieldLst.add(new Selectlist('Fifth Schedule','Fifth Schedule'));
        }else if (selectedObject == 'Schedule-Duplex'){
                fieldLst.clear();
                fieldLst.add(new Selectlist('First Schedule','First Schedule'));
                fieldLst.add(new Selectlist('Second Schedule','Second Schedule'));
                fieldLst.add(new Selectlist('Third Schedule','Third Schedule'));
                fieldLst.add(new Selectlist('Fourth Schedule','Fourth Schedule'));
                fieldLst.add(new Selectlist('Fifth Schedule','Fifth Schedule'));
        }else if (selectedObject == 'Schedule-Penthouse'){
                fieldLst.clear();
                fieldLst.add(new Selectlist('First Schedule','First Schedule'));
                fieldLst.add(new Selectlist('Second Schedule','Second Schedule'));
                fieldLst.add(new Selectlist('Third Schedule','Third Schedule'));
                fieldLst.add(new Selectlist('Fourth Schedule','Fourth Schedule'));
                fieldLst.add(new Selectlist('Fifth Schedule','Fifth Schedule'));
        }else if (selectedObject == 'Schedule-Bare Shell'){
                fieldLst.clear();
                fieldLst.add(new Selectlist('First Schedule','First Schedule'));
                fieldLst.add(new Selectlist('Second Schedule','Second Schedule'));
                fieldLst.add(new Selectlist('Third Schedule','Third Schedule'));
                fieldLst.add(new Selectlist('Fourth Schedule','Fourth Schedule'));
                fieldLst.add(new Selectlist('Fifth Schedule','Fifth Schedule'));
        }else if (selectedObject == 'SeventhTable1'){
            fieldLst.clear();
                fieldLst.add(new Selectlist('SeventhTable','SeventhTable'));
        }else if (selectedObject == 'Morgage NOC'){
            fieldLst.clear();
                fieldLst.add(new Selectlist('MorgageNOC1','MorgageNOC1'));
        }else if (selectedObject == 'Contact Details Update'){
            fieldLst.clear();
                fieldLst.add(new Selectlist('Single Tower','Single Tower'));
              fieldLst.add(new Selectlist('Multi Tower','Multi Tower'));
        }else if (selectedObject == 'Possesion'){
            fieldLst.clear();
                fieldLst.add(new Selectlist('KeyHandoverChecklist','KeyHandoverChecklist'));
        }
        
        }catch(Exception e){
            system.debug(e.getMessage()+':::'+e.getLineNumber());
        }
        return fieldLst;
    }


    public class Selectlist{
        @AuraEnabled public String fName;
        @AuraEnabled public String fValue;
        public Selectlist(String flName,String flValue){
            this.fName=flName;
            this.fValue=flValue;            
        }
    }
    
}
public with sharing class masterRecordController {
    public static List<Opportunity_c__c> returnOpportunityDetails(Id bkId)
    {
        List<Opportunity_c__c> oppDetails = new List<Opportunity_c__c>();
        String[] types = new String[]{'Opportunity_c__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            string sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                
                //field.key = dfield.getname();
                //field.val = dfield.getLabel ();
                //system.debug('Key : '+ field.key);
                //system.debug('Value for Key: '+ field.val);
                if(queryFields == null || queryFields == ''){
                    queryFields = dField.getName();
                }
                else{
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
            
        }
        
        String soqlQuery = 'Select ' + queryFields  + ' from Opportunity_c__c  Where Booking__c = \''+bkId+'\''; 
        system.debug(soqlQuery);
        oppDetails = Database.query(soqlQuery);
        return oppDetails;
    }
    
    public static List<Quotation__c> returnQuotationDetails(Id bkId)
    {
        List<Quotation__c> qtDetails = new List<Quotation__c>();
        String[] types = new String[]{'Quotation__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            string sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                
                //field.key = dfield.getname();
                //field.val = dfield.getLabel ();
                //system.debug('Key : '+ field.key);
                //system.debug('Value for Key: '+ field.val);
                if(queryFields == null || queryFields == ''){
                    queryFields = dField.getName();
                }
                else{
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
            
        }
        
        String soqlQuery = 'Select ' + queryFields  + ',Opportunity__r.Master_Source__c,Unit__r.Tower__r.Terms_Condition__c,Opportunity__r.Referrer_Name__r.Phone,Opportunity__r.Referrer_Name__r.Referrer_Name__c,Tower__r.Terms_Condition__c,Opportunity__r.CP_Account__r.MahaRERA_Registration_No__c,Opportunity__r.CP_Account__r.RG_Code__c,Opportunity__r.CP_Account__r.Channel_Partner_Name__c,Opportunity__r.CP_Account__r.Phone  from Quotation__c Where Booking__c = \''+bkId+'\''; 
        system.debug(soqlQuery);
        qtDetails = Database.query(soqlQuery);
        return qtDetails;
    }

    public static List<Booking__c> returnBookingDetails(Id bkId)
    {
        List<Booking__c> bookingDetails = new List<Booking__c>();
        String[] types = new String[]{'Booking__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            string sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                
                //field.key = dfield.getname();
                //field.val = dfield.getLabel ();
                //system.debug('Key : '+ field.key);
                //system.debug('Value for Key: '+ field.val);
                if(queryFields == null || queryFields == ''){
                    queryFields = dField.getName();
                }
                else{
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
            
        }
        
        String soqlQuery = 'Select ' + queryFields  + ',Unit__r.Name,Unit__r.Tower__r.Terms_Condition__c  from Booking__c Where id = \''+bkId+'\''; 
        system.debug(soqlQuery);
        bookingDetails = Database.query(soqlQuery);
        System.debug(bookingDetails);
        //String s = bookingDetails.Project__c;
        return bookingDetails;
        
    }
    
    public static List<Charge_Detail__c	> returnChargeDetails(Id cId)
    {
        List<Charge_Detail__c	> chargeDetails = new List<Charge_Detail__c	>();
        String[] types = new String[]{'Charge_Detail__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            string sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                
                //field.key = dfield.getname();
                //field.val = dfield.getLabel ();
                //system.debug('Key : '+ field.key);
                //system.debug('Value for Key: '+ field.val);
                if(queryFields == null || queryFields == ''){
                    queryFields = dField.getName();
                }
                else{
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
            
        }
        
        String soqlQuery = 'Select ' + queryFields  + ' from Charge_Detail__c Where Quotation__c = \''+cId+'\''; 
        system.debug(soqlQuery);
        chargeDetails = Database.query(soqlQuery);
        System.debug(chargeDetails);
        return chargeDetails;
        
    }


    public static List<Applicant__c> returnApplicantDetails(ID bkId)
    {
        List<Applicant__c> applicantDetails = new List<Applicant__c>();
        String[] types = new String[]{'Applicant__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            string sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                
                //field.key = dfield.getname();
                //field.val = dfield.getLabel ();
                //system.debug('Key : '+ field.key);
                //system.debug('Value for Key: '+ field.val);
                if(queryFields == null || queryFields == ''){
                    queryFields = dField.getName();
                }
                else{
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
            
        }
        
        String soqlQuery = 'Select ' + queryFields  + ' from Applicant__c Where Booking__c = \''+bkId+'\'ORDER BY Applicant_Sequence__c ASC'; 
        system.debug(soqlQuery);
        applicantDetails = Database.query(soqlQuery);
        return applicantDetails;
    }
    
    public static List<Receipt__c> returnReceiptDetails(Id bkId)
    {
        List<Receipt__c> receiptDetails = new List<Receipt__c>();
        String[] types = new String[]{'Receipt__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            string sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                
                //field.key = dfield.getname();
                //field.val = dfield.getLabel ();
                //system.debug('Key : '+ field.key);
                //system.debug('Value for Key: '+ field.val);
                if(queryFields == null || queryFields == ''){
                    queryFields = dField.getName();
                }
                else{
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
            
        }
        
        String soqlQuery = 'Select ' + queryFields  + ', Booking__r.Unit__r.Name, Booking__r.Project__r.Name, Booking__r.Tower__r.Name from Receipt__c Where Booking__c = \''+bkId+'\''; 
        system.debug(soqlQuery);
        receiptDetails = Database.query(soqlQuery);
        return receiptDetails;
    }
    
    public static List<Unit__c> returnUnitDetails(Id bkId)
    {
        List<Unit__c> unitDetails = new List<Unit__c>();
        String[] types = new String[]{'Unit__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            string sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                
                //field.key = dfield.getname();
                //field.val = dfield.getLabel ();
                //system.debug('Key : '+ field.key);
                //system.debug('Value for Key: '+ field.val);
                if(queryFields == null || queryFields == ''){
                    queryFields = dField.getName();
                }
                else{
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
            
        }
        
        String soqlQuery = 'Select ' + queryFields  + ', Tower__r.RERA_No__c, Tower__r.Terms_Condition__c from Unit__c Where Id = \''+bkId+'\''; 
        system.debug(soqlQuery);
        unitDetails = Database.query(soqlQuery);
        system.debug(unitDetails);
        return unitDetails;
        
    }
    
    
    
  /* public static List<Tower__c> returnTowerDetails(Id bkId)
    {
        List<Tower__c> TDetails = new List<Tower__c>();
        String[] types = new String[]{'Tower__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            string sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                System.debug(dfield);
                //Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                System.debug(fieldLabel);
                //field.key = dfield.getname();
                //field.val = dfield.getLabel ();
                //system.debug('Key : '+ field.key);
                //system.debug('Value for Key: '+ field.val);
                if(queryFields == null || queryFields == ''){
                    queryFields = dField.getName();
                    
                }
                else{
                    queryFields = queryFields + ', ' + dField.getName();
                    System.debug(queryFields);
                }
            }
            
        }
        
        String soqlQuery = 'Select ' + queryFields  + 'Name from Tower__c Where Booking__c = \''+bkId+'\''; 
        system.debug(soqlQuery);
        TDetails = Database.query(soqlQuery);
        system.debug(TDetails);
        return TDetails;
        
    }
    
    
    
     public static List<Project__c> returnProjectDetails(Id bkId)
    {
        List<Project__c> PDetails = new List<Project__c>();
        String[] types = new String[]{'Project__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            string sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                
                //field.key = dfield.getname();
                //field.val = dfield.getLabel ();
                //system.debug('Key : '+ field.key);
                //system.debug('Value for Key: '+ field.val);
                if(queryFields == null || queryFields == ''){
                    queryFields = dField.getName();
                }
                else{
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
            
        }
        
        String soqlQuery = 'Select ' + queryFields  + ' from Project__c Where Booking__c = \''+bkId+'\''; 
        system.debug(soqlQuery);
        PDetails = Database.query(soqlQuery);
        system.debug(PDetails);
        return PDetails;
        
    }*/
    
    
    
    
    
    public static List<Payment_Milestone__c> returnBLDetails(Id qId)
    {
        List<Payment_Milestone__c> blDetails = new List<Payment_Milestone__c>();
        String[] types = new String[]{'Payment_Milestone__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            string sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                //Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                
                //field.key = dfield.getname();
                //field.val = dfield.getLabel ();
                //system.debug('Key : '+ field.key);
                //system.debug('Value for Key: '+ field.val);
                if(queryFields == null || queryFields == ''){
                    queryFields = dField.getName();
                }
                else{
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
            
        }
        
        String soqlQuery = 'Select ' + queryFields  + ' from Payment_Milestone__c Where Quotation__c = \''+qId+'\''; 
        system.debug(soqlQuery);
        blDetails = Database.query(soqlQuery);
        system.debug(blDetails);
        return blDetails;
    }
}
//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 29-10-2022
//-------------------------------------------//
public class Ex_BookingPrints {

    public Id BKID {get;set;}
    public string bkids {get;set;}
    public Opportunity__c opp {get;set;}
    public List<Booking__c>  bklist {get;set;}
    public List<Quotation__c>  Qlist {get;set;}
    public List <Applicant__c> lstApp {get; set;}
    public List <Charge_Detail__c> chargelist {get; set;}
    public List <Payment_Milestone__c> psmwList {get;set;}
    public List<paymentScheduleWrapper> pswList  {get;set;}
    public Decimal StampDuty {get;set;}
    public Decimal regCharge {get;set;}
    public Decimal leagal {get;set;}
    public Decimal Totalcost {get;set;}
    public string strcararea {get;set;}
    public string strStampDuty {get;set;}
    public string strregCharge {get;set;}
    public string strleagal {get;set;}
    public string strTotalcost {get;set;}
    public string stragmt {get;set;}
    public string stragmtval {get;set;}
    public List<Receipt__c> lstRc {get;set;}
    public List<Booking__c> refBkList {get;set;}
    
    public EX_Bookingprints()
    {
        
        lstApp = new List<Applicant__c>();
        psmwList = new List<Payment_Milestone__c>();
        pswList = new List<paymentScheduleWrapper>();
        opp = new Opportunity__c();
        bklist = new List<Booking__c> ();
        chargelist = new List <Charge_Detail__c>();
        lstRc = new List<Receipt__c> ();
        refBkList = new List<Booking__c> ();
        bkids = '';
        strStampDuty = '';
        strregCharge  = '';
        strleagal = '';
        strTotalcost = '';
        stragmt = '';
        strcararea = '';
        stragmtval = '';
        StampDuty = 0;
        regCharge = 0;
        leagal  =  0;  
        Totalcost = 0;
     
        bkids = apexpages.currentPage().getparameters().get('BKID');
        
         lstApp = returnApplicant (bkids);
         bklist = returnbooking (bkids);
         lstRc = masterRecordController.returnReceiptDetails(bkids);
         if (bklist[0].Referrer_Name__c != null) {
            refBkList = getReferenceInfo(bklist[0].Referrer_Name__c);
         }
         
     //   lstApp = returnApplicant(bkids);
        
       /* if(BKID != null){
            
            bklist =  [select id,Name,Quotation__c 
                      from Booking__c 
                      where id =: BKID];
                    
             
            
                       
         }  */
          
        chargelist = [select id,Name,Quotation__c,Charge_Amount__c 
                      from Charge_Detail__c 
                      where Quotation__c =: bklist[0].Quotation__c];
            
                   for(Charge_Detail__c cd: chargelist) {
                  
                    
                  if(cd.Name.equalsIgnoreCase('Stamp Duty')) {
                    StampDuty += cd.Charge_Amount__c;
                    strStampDuty = Ex_INFormat.INFormating(StampDuty);
                }
                if (cd.Name.equalsIgnoreCase('Registration')) {
                    regCharge += cd.Charge_Amount__c;
                    strregCharge = Ex_INFormat.INFormating(regCharge);
                }
                if (cd.Name.equalsIgnoreCase('Legal & MSEB')) {
                    leagal += cd.Charge_Amount__c;
                    strleagal = Ex_INFormat.INFormating(leagal);
                }
                
            }
        
         
        Totalcost += bklist[0].Agreement_Value__c + bklist[0].Agreement_Value_Tax__c + bklist[0].SDR_Value__c + bklist[0].SDR_Tax__c; 
        strTotalcost = Ex_INFormat.INFormating(Totalcost);
        
        stragmt =  Ex_INFormat.INFormating(bklist[0].Agreement_Value_Tax__c);
        if(bklist[0].Unit__r.Total_Carpet_Area_Sq_Ft__c!= Null)
        strcararea = string.valueOf(bklist[0].Unit__r.Total_Carpet_Area_Sq_Ft__c);
        stragmtval = Ex_INFormat.INFormating(bklist[0].Agreement_Value__c);
        
        psmwList = getPaymentScheduleInfo(bklist[0].Quotation__c);
        system.debug('psmwList: '+psmwList);
        
        if(psmwList != null) {
            
            
            Decimal totalPercentage = 0;
            Decimal totalAmount = 0;
            Decimal TotalTax = 0;
            Decimal Total = 0;
            Decimal Total1 = 0;  
            
            
            for(Payment_Milestone__c pm: psmwList) {
                
                Total = pm.Charge_Bucket_1_Amount__c + pm.Charge_Bucket_1_Total_Tax__c;
                
                pswList.add(new paymentScheduleWrapper(pm.Milestone_Name__c,currencyFormat(pm.Charge_Bucket_1_Percentage__c), currencyFormat(pm.Charge_Bucket_1_Amount__c), currencyFormat(pm.Charge_Bucket_1_Total_Tax__c ), currencyFormat(Total)));
                
                
                totalPercentage +=  pm.Charge_Bucket_1_Percentage__c;
                totalAmount +=  pm.Charge_Bucket_1_Amount__c;
                TotalTax +=  pm.Charge_Bucket_1_Total_Tax__c;
                Total1 += pm.Charge_Bucket_1_Amount__c + pm.Charge_Bucket_1_Total_Tax__c;
                
            }
            pswList.add(new paymentScheduleWrapper('Total',currencyFormat(totalPercentage), currencyFormat(totalAmount),currencyFormat(TotalTax), currencyFormat(Total1)));
        }
        
    }
    
    
     public List<Booking__c> returnbooking(string bkidss)
    {
        List<Booking__c> bkListss = new List<Booking__c>();
        String[] types = new String[]{'Booking__c'};
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        String queryFields = '';
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
                    
            for(Schema.SObjectField sfield : fieldMap.Values()) {
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }  
        String soqlQuery = 'Select ' + queryFields  + ',Project__r.Name,Tower__r.Terms_Condition__c,Unit__r.Project__r.Name,Unit__r.Tower__r.Name,Unit__r.Name,Unit__r.Configuration__c,Owner.Name,Unit__r.Premium_View__c,Unit__r.Total_Carpet_Area_Sq_Ft__c,Opportunity__r.Media__c,Opportunity__r.Channel_Partner__r.Name,Opportunity__r.Channel_Partner__r.CP_Unique_Code__c,Opportunity__r.Referrer_Name__c  from Booking__c Where Id = \''+bkidss+'\''; 
        system.debug(soqlQuery);
        bkListss = Database.query(soqlQuery);
        System.debug('bk List:'+bkListss);
        return bkListss;
    
    }
    
    
    
    
     public List<Applicant__c> returnApplicant(string d)
    {
        List<Applicant__c> apList = new List<Applicant__c>();
        String[] types = new String[]{'Applicant__c'};
            Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        String queryFields = '';
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            
            for(Schema.SObjectField sfield : fieldMap.Values()) {
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + '  from Applicant__c Where Booking__c = \''+d+'\'ORDER BY Applicant_Sequence__c ASC'; 
        system.debug(soqlQuery);
        apList = Database.query(soqlQuery);
        system.debug('App List'+apList);
        
        return apList;
        
    }   
    
    
 /*    public  List<Charge_Detail__c> returncharge(Id CId) {
        List<Charge_Detail__c> chargeList = new List<Charge_Detail__c>();
        String[] types = new String[]{'Charge_Detail__c'};
            string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ' from Charge_Detail__c Where Quotation__c = \''+CId+'\''; 
        system.debug(soqlQuery);
        chargeList = Database.query(soqlQuery);
        if (chargeList.size() > 0) {
            return chargeList;
        } else {
            return null;
        }
    }
       */
    
    
    
    
    
    public Static List<Payment_Milestone__c> getPaymentScheduleInfo(Id QId) {
        List<Payment_Milestone__c> psmwList = new List<Payment_Milestone__c>();
        String[] types = new String[]{'Payment_Milestone__c'};
            string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ' from Payment_Milestone__c Where Quotation__c = \''+QId+'\' ORDER BY Sequence_No__c ASC'; 
        system.debug(soqlQuery);
        psmwList = Database.query(soqlQuery);
        if (psmwList.size() > 0) {
            return psmwList;
        } else {
            return null;
        }
    }
    public Static List<Booking__c> getReferenceInfo(Id rID) {
        List<Booking__c> bklist = new List<Booking__c>();
        String[] types = new String[]{'Booking__c'};
            string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ', Unit__r.Name from Booking__c Where Referrer_Name__c = \''+rID+'\''; 
        system.debug(soqlQuery);
        bklist = Database.query(soqlQuery);
        if (bklist.size() > 0) {
            return bklist;
        } else {
            return null;
        }
    }
    
    public class paymentScheduleWrapper {
        public String milestoneName {get;set;}
        public String percentDue {get;set;}
        public String milestoneAmount {get;set;}
        public String milestoneGST {get;set;}
        public String milestoneTotal {get;set;}
        
        public paymentScheduleWrapper(String milestoneName,  String percentDue, String milestoneAmount, String milestoneGST, String milestoneTotal ) {
            this.milestoneName = milestoneName;
            this.percentDue = percentDue;
            this.milestoneAmount = milestoneAmount;
            this.milestoneGST = milestoneGST;
            this.milestoneTotal = milestoneTotal;
        }
    }
    
        public  String currencyFormat(Decimal amt) {
        String formattedAmount = '';
        Decimal tempAmt = amt.setscale(2,RoundingMode.HALF_UP);
        String stringAmt = tempAmt.toPlainString();
        String decimalPart;
        List<String> tempStr = new List<String>();
        if(String.isNotBlank(stringAmt)) {
            tempStr = stringAmt.split('\\.');
            if(tempStr != null && tempStr.size() ==2) {
                decimalPart = tempStr[1];
            }
        }
        formattedAmount = (tempAmt.format().contains('.')?tempAmt.format():(tempAmt.format()+'.'+decimalPart));
        return formattedAmount+ '/-';
    }
    
    
    
}
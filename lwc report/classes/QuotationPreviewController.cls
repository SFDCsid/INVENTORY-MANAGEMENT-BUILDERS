public class QuotationPreviewController {
    public Id qId {get;set;}
    public Quotation__c q {get;set;}
    public List<Car_Park_Required__c> carParkReqList {get;set;}
    public List<Charge_Detail__c> quotationChargeList {get;set;}
    public List<chargeDetailWrapper> statutoryChargeList {get;set;}
    public List<chargeDetailWrapper> otherChargeList {get;set;}
    public List<Discount_Applied__c> discountList {get;set;}
    public List<Payment_Milestone__c> pmList {get;set;}
    public List<paymentScheduleWrapper> pswList {get;set;}
    
    public Decimal quoAgreementValue {get;set;}
    public Decimal netAgreementValue {get;set;}
    public Decimal otherChargeValue {get;set;}
    public Decimal statutoryChargeValue {get;set;}
    public Decimal netAgreementTaxValue {get;set;}
    public Decimal otherChargeTaxValue {get;set;}
    public Decimal statutoryChargeTaxValue {get;set;}
    public Decimal totalDiscount {get;set;}
    public Decimal creditNoteAmount {get;set;}
    public Decimal cashbackAmount {get;set;}
    
    public String quoAgreementValueString {get;set;}
    public String netAgreementValueString {get;set;}
    public String otherChargeValueString {get;set;}
    public String statutoryChargeValueString {get;set;}
    public String netAgreementTaxValueString {get;set;}
    public String otherChargeTaxValueString {get;set;}
    public String statutoryChargeTaxValueString {get;set;}
    public String totalDiscountString {get;set;}
    public String grandTotalValueString {get;set;}
    public String creditNoteAmountString {get;set;}
    public String cashbackAmountString {get;set;}
    public String totalOtherChargeValueString {get;set;}
    public String allInclusiveValueString {get;set;}
    
    public QuotationPreviewController() {
        q = new Quotation__c();
        carParkReqList = new List<Car_Park_Required__c>();
        quotationChargeList = new List<Charge_Detail__c>();
        statutoryChargeList = new List<chargeDetailWrapper>();
        otherChargeList = new List<chargeDetailWrapper>();
        discountList = new List<Discount_Applied__c>();
        pmList = new List<Payment_Milestone__c>();
        pswList = new List<paymentScheduleWrapper>();
        quoAgreementValue = 0;
        netAgreementValue = 0;
        otherChargeValue = 0;
        statutoryChargeValue = 0;
        netAgreementTaxValue = 0;
        otherChargeTaxValue = 0;
        statutoryChargeTaxValue = 0;
        totalDiscount = 0;
        creditNoteAmount = 0;
        cashbackAmount = 0;
        
        if(ApexPages.currentPage().getParameters().containsKey('qId')) {
            qId = (Id)ApexPages.currentPage().getParameters().get('qId');
        }
        
        if(qId != null) {
			q = getQuotationInfo(qId);
            system.debug('Quotation: '+q);
            
            if(q != null) {
                carParkReqList = [Select Id, Name, Car_Park_Amount__c, Car_Park_Count__c, Car_Park_Type__c, Quotation__c from Car_Park_Required__c
                                  where Quotation__c =: q.Id];
                system.debug('carParkReqList: '+carParkReqList);
                
                for(Integer i = 1; i<=5; i++) {
                    if(String.isNotBlank((String)q.get('Charge_Bucket_'+i+'__c'))) {
                        if(((String)q.get('Charge_Bucket_'+i+'__c')).equalsIgnoreCase('Agreement Value')) {
                            if(q.get('Charge_Bucket_'+i+'_Amount__c') != null && q.get('Charge_Bucket_'+i+'_Amount__c') != 0)
                            	netAgreementValue = (Decimal)q.get('Charge_Bucket_'+i+'_Amount__c');
                            if(q.get('Charge_Bucket_'+i+'_Total_Tax__c') != null && q.get('Charge_Bucket_'+i+'_Total_Tax__c') != 0)
                            	netAgreementTaxValue = (Decimal)q.get('Charge_Bucket_'+i+'_Total_Tax__c');
                        } else if(((String)q.get('Charge_Bucket_'+i+'__c')).equalsIgnoreCase('Other Charges')) {
                            if(q.get('Charge_Bucket_'+i+'_Amount__c') != null && q.get('Charge_Bucket_'+i+'_Amount__c') != 0)
                            	otherChargeValue = (Decimal)q.get('Charge_Bucket_'+i+'_Amount__c');
                            if(q.get('Charge_Bucket_'+i+'_Total_Tax__c') != null && q.get('Charge_Bucket_'+i+'_Total_Tax__c') != 0)
                            	otherChargeTaxValue = (Decimal)q.get('Charge_Bucket_'+i+'_Total_Tax__c');
                        } else if(((String)q.get('Charge_Bucket_'+i+'__c')).equalsIgnoreCase('Statutory Charges')) {
                            if(q.get('Charge_Bucket_'+i+'_Amount__c') != null && q.get('Charge_Bucket_'+i+'_Amount__c') != 0)
                            	statutoryChargeValue = (Decimal)q.get('Charge_Bucket_'+i+'_Amount__c');
                            if(q.get('Charge_Bucket_'+i+'_Total_Tax__c') != null && q.get('Charge_Bucket_'+i+'_Total_Tax__c') != 0)
                            	statutoryChargeTaxValue = (Decimal)q.get('Charge_Bucket_'+i+'_Total_Tax__c');
                        }
                    }
                }
                if(q.Total_Discount__c != null && q.Total_Discount__c != 0) {
                    totalDiscount = q.Total_Discount__c;
                }
                quoAgreementValue = netAgreementValue + totalDiscount;
                
                quotationChargeList = getChargeDetailInfo(q.Id);
                system.debug('quotationChargeList: '+quotationChargeList);
                
                if(quotationChargeList != null) {
                    for(Charge_Detail__c cd: quotationChargeList) {
                        if(cd.Charge_Bucket__c.equalsIgnoreCase('Statutory Charges'))
                            statutoryChargeList.add(new chargeDetailWrapper(cd.Name, InventoryPriceManagementServices.currencyFormat(cd.Charge_Amount__c), cd.Charge_Bucket__c));
                        else if(cd.Charge_Bucket__c.equalsIgnoreCase('Other Charges'))
                            otherChargeList.add(new chargeDetailWrapper(cd.Name, InventoryPriceManagementServices.currencyFormat(cd.Charge_Amount__c), cd.Charge_Bucket__c));
                    }
                }
                
                discountList = getDiscountInfo(q.Id);
                system.debug('discountList: '+discountList);
				
                if(discountList != null) {
                    for(Discount_Applied__c d: discountList) {
                        if(d.Discount_Category__c.equalsIgnoreCase('Credit Note'))
                            creditNoteAmount += d.Total__c;
                        else if(d.Discount_Category__c.equalsIgnoreCase('Cashback'))
                            cashbackAmount += d.Total__c;
                    }
                }
                
                pmList = getPaymentScheduleInfo(q.Id);
                system.debug('pmList: '+pmList);
                
                if(pmList != null) {
                    Decimal totalPercentage = 0;
                    Decimal totalAmount = 0;
                    Decimal totalTax = 0;
                    
                    for(Payment_Milestone__c pm: pmList) {
                        for(Integer i = 1; i <= 5; i++) {
                            if(String.isNotBlank((String)pm.get('Charge_Bucket_'+i+'__c')) && ((String)pm.get('Charge_Bucket_'+i+'__c')).equalsIgnoreCase('Agreement Value')) {
                                pswList.add(new paymentScheduleWrapper(pm.Milestone_Name__c, (Decimal)pm.get('Charge_Bucket_'+i+'_Percentage__c')+'%', InventoryPriceManagementServices.currencyFormat((Decimal)pm.get('Charge_Bucket_'+i+'_Amount__c')), InventoryPriceManagementServices.currencyFormat((Decimal)pm.get('Charge_Bucket_'+i+'_Total_Tax__c'))));
                                
                                totalPercentage += (Decimal)pm.get('Charge_Bucket_'+i+'_Percentage__c');
                                totalAmount += (Decimal)pm.get('Charge_Bucket_'+i+'_Amount__c');
                                totalTax += (Decimal)pm.get('Charge_Bucket_'+i+'_Total_Tax__c');
                            }
                        }
                    }
                    pswList.add(new paymentScheduleWrapper('Total', totalPercentage+'%', InventoryPriceManagementServices.currencyFormat(totalAmount), InventoryPriceManagementServices.currencyFormat(totalTax)));
                }
                
                quoAgreementValueString = InventoryPriceManagementServices.currencyFormat(quoAgreementValue);
                totalDiscountString = InventoryPriceManagementServices.currencyFormat(totalDiscount);
                netAgreementValueString = InventoryPriceManagementServices.currencyFormat(netAgreementValue);
                otherChargeValueString = InventoryPriceManagementServices.currencyFormat(otherChargeValue);
                statutoryChargeValueString = InventoryPriceManagementServices.currencyFormat(statutoryChargeValue);
                netAgreementTaxValueString = InventoryPriceManagementServices.currencyFormat(netAgreementTaxValue);
                otherChargeTaxValueString = InventoryPriceManagementServices.currencyFormat(otherChargeTaxValue);
                statutoryChargeTaxValueString = InventoryPriceManagementServices.currencyFormat(statutoryChargeTaxValue);
                grandTotalValueString = InventoryPriceManagementServices.currencyFormat(netAgreementValue + netAgreementTaxValue + statutoryChargeValue);
                creditNoteAmountString = InventoryPriceManagementServices.currencyFormat(creditNoteAmount);
                cashbackAmountString = InventoryPriceManagementServices.currencyFormat(cashbackAmount);
                totalOtherChargeValueString = InventoryPriceManagementServices.currencyFormat(otherChargeValue + otherChargeTaxValue);
                allInclusiveValueString = InventoryPriceManagementServices.currencyFormat(netAgreementValue + netAgreementTaxValue + statutoryChargeValue + otherChargeValue + otherChargeTaxValue);
            } else {
                
            }         
        } else {
            
        }
    }
    
    public static Quotation__c getQuotationInfo(Id qId) {
        List<Quotation__c> qList = new List<Quotation__c>();
        String[] types = new String[]{'Quotation__c'};
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
        queryFields += ', Unit__r.Total_Carpet_Area_Sq_Ft__c, Unit__r.Total_Carpet_Area_Sq_Mtr__c, Unit__r.Other_Useable_Area_Sq_Mtr__c, Unit__r.RERA_Carpet_Area_Sq_Mtr__c';
        String soqlQuery = 'Select ' + queryFields  + ', Unit__r.Project__r.Project_Logo__c, Unit__r.Tower__r.RERA_No__c, Unit__r.Floor__c, Unit__r.Name, Unit__r.Unit_Type__c, Unit__r.Configuration__c, Unit__r.Tower__r.Terms_Condition__c from Quotation__c Where Id = \''+qId+'\''; 
        system.debug(soqlQuery);
        qList = Database.query(soqlQuery);
        if (qList.size() > 0) {
            return qList[0];
        } else {
            return null;
        }
    }
    
    public static List<Charge_Detail__c> getChargeDetailInfo(Id qId) {
        List<Charge_Detail__c> chargeDetailList = new List<Charge_Detail__c>();
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
        String soqlQuery = 'Select ' + queryFields  + ' from Charge_Detail__c Where Quotation__c = \''+qId+'\''; 
        system.debug(soqlQuery);
        chargeDetailList = Database.query(soqlQuery);
        if (chargeDetailList.size() > 0) {
            return chargeDetailList;
        } else {
            return null;
        }
    }
    
    public static List<Discount_Applied__c> getDiscountInfo(Id qId) {
        List<Discount_Applied__c> dList = new List<Discount_Applied__c>();
        String[] types = new String[]{'Discount_Applied__c'};
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
        String soqlQuery = 'Select ' + queryFields  + ' from Discount_Applied__c Where Quotation__c = \''+qId+'\''; 
        system.debug(soqlQuery);
        dList = Database.query(soqlQuery);
        if (dList.size() > 0) {
            return dList;
        } else {
            return null;
        }
    }
    
    public static List<Payment_Milestone__c> getPaymentScheduleInfo(Id qId) {
        List<Payment_Milestone__c> pmList = new List<Payment_Milestone__c>();
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
        String soqlQuery = 'Select ' + queryFields  + ' from Payment_Milestone__c Where Quotation__c = \''+qId+'\' ORDER BY Sequence_No__c ASC'; 
        system.debug(soqlQuery);
        pmList = Database.query(soqlQuery);
        if (pmList.size() > 0) {
            return pmList;
        } else {
            return null;
        }
    }
    
    public class chargeDetailWrapper {
        public String chargeName {get;set;}
        public String chargeValueString {get;set;}
        public String chargeBucket {get;set;}
        
        public chargeDetailWrapper(String name, String amount, String bucket) {
            this.chargeName = name;
            this.chargeValueString = amount;
            this.chargeBucket = bucket;
        }
    }
    
    public class paymentScheduleWrapper {
        public String milestoneName {get;set;}
        public String percentDue {get;set;}
        public String milestoneAmount {get;set;}
        public String milestoneGST {get;set;}

        public paymentScheduleWrapper(String milestoneName, String percentDue, String milestoneAmount, String milestoneGST) {
            this.milestoneName = milestoneName;
            this.percentDue = percentDue;
            this.milestoneAmount = milestoneAmount;
            this.milestoneGST = milestoneGST;
        }
    }
}
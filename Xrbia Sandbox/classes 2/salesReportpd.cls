public with sharing class salesReportpd {
    
    @AuraEnabled (cacheable=true)
    public static Map<String,String> getProject(){
        Map<String,String> projectMap = new Map<String,String>();
        for (Project__c projectObj : [Select id,Name FROM Project__c]) {
            projectMap.put(projectObj.id, projectObj.Name);
        }
        return projectMap;  
    }

    @AuraEnabled (cacheable=true)
    public static Map<String, reportDataWrapperClass> Wrapper(String pId, Date sdate, Date edate ){
        Map<String, reportDataWrapperClass> wrapperMap = new Map<String, reportDataWrapperClass>();
        List<AggregateResult> bankLoanBooking = new List<AggregateResult>();
        List<AggregateResult> cibilDoneList = new List<AggregateResult>();
        List<AggregateResult> cibilNotDoneList = new List<AggregateResult>();
        List<AggregateResult> bacCibilClearList = new List<AggregateResult>();
        List<AggregateResult> bacCibilNotClearList = new List<AggregateResult>();
        List<AggregateResult> netBookingList = new List<AggregateResult>();
        List<AggregateResult> netBookingAgreementValueList = new List<AggregateResult>();

        if(pId == 'All'){
            bankLoanBooking = [select owner.name ownerName, Count(Id) blCount from Opportunity__c where Booking__c != null 
                              AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND 
                              Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate group by owner.name];
            System.debug('bankLoanBooking::'+bankLoanBooking);
        }else if(pId != 'All'){
            bankLoanBooking = [select owner.name ownerName, Count(Id) blCount from Opportunity__c where Project__c =:pId AND Booking__c != null 
                              AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND 
                              Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate group by owner.name];
            System.debug('bankLoanBooking::'+bankLoanBooking);
        }

        if(pId == 'All'){
            cibilDoneList = [select owner.name ownerName, Count(Id) cibildone from Opportunity__c where Booking__c != null 
                            AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND Booking__r.CBIL_Checked__c =: true
                            AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate group by owner.name];
            System.debug('cibilDoneList::'+cibilDoneList);
        }else if(pId != 'All'){
            cibilDoneList = [select owner.name ownerName, Count(Id) blCount from Opportunity__c where Booking__c != null AND Project__c =: pId
                            AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND Booking__r.CBIL_Checked__c =: true
                            AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate group by owner.name];
            System.debug('cibilDoneList::'+cibilDoneList);
        }

        if(pId == 'All'){
            cibilNotDoneList = [select owner.name ownerName, Count(Id) cibilnotdone from Opportunity__c where Booking__c != null 
                                AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND Booking__r.CBIL_Checked__c =: false
                                AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate group by owner.name];
            System.debug('cibilNotDoneList::'+cibilNotDoneList);
        }else if(pId != 'All'){
            cibilNotDoneList = [select owner.name ownerName, Count(Id) cibilnotdone from Opportunity__c where Booking__c != null AND Project__c =: pId
                                AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND Booking__r.CBIL_Checked__c =: false
                                AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate group by owner.name];
            System.debug('cibilNotDoneList::'+cibilNotDoneList);
        }

        if(pId == 'All'){
            bacCibilClearList = [select owner.name ownerName, Count(Id) cibilclear from Opportunity__c where Booking__c != null 
                                AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND Booking__r.CBIL_Checked__c =: true
                                AND Booking__r.Welcome_Call_Done__c =: true AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate group by owner.name];
            System.debug('bacCibilClearList::'+bacCibilClearList);
        }else if(pId != 'All'){
            bacCibilClearList = [select owner.name ownerName, Count(Id) cibilclear from Opportunity__c where Booking__c != null AND Project__c =: pId
                                AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND Booking__r.CBIL_Checked__c =: true
                                AND Booking__r.Welcome_Call_Done__c =: true AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate group by owner.name];
            System.debug('bacCibilClearList::'+bacCibilClearList);
        }

        if(pId == 'All'){
            netBookingList = [select owner.name ownerName, Count(Id) netBooking from Opportunity__c where Booking__c != null 
                              AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND Booking__r.CBIL_Checked__c =: true
                              AND Booking__r.Welcome_Call_Done__c =: true AND Booking__r.Booking_Stages__c ='Booking Confirmed' AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate 
                              group by owner.name];
            System.debug('netBookingList::'+netBookingList);
        }else if(pId != 'All'){
            netBookingList = [select owner.name ownerName, Count(Id) netBooking from Opportunity__c where Booking__c != null AND Project__c =: pId
                              AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND Booking__r.CBIL_Checked__c =: true
                              AND Booking__r.Welcome_Call_Done__c =: true AND Booking__r.Booking_Stages__c ='Booking Confirmed' AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate 
                              group by owner.name];
            System.debug('netBookingList::'+netBookingList);
        }
        if(pId == 'All'){
            netBookingAgreementValueList = [select owner.name ownerName, SUM(Booking__r.Agreement_Value__c) netBookingValue from Opportunity__c where Booking__c != null 
                                            AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND Booking__r.CBIL_Checked__c =: true
                                            AND Booking__r.Welcome_Call_Done__c =: true AND Booking__r.Booking_Stages__c ='Booking Confirmed' AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate 
                                            group by owner.name];
            System.debug('netBookingAgreementValueList::'+netBookingAgreementValueList);
        }else if(pId != 'All'){
            netBookingAgreementValueList = [select owner.name ownerName, SUM(Booking__r.Agreement_Value__c) netBookingValue from Opportunity__c where Booking__c != null AND Project__c =: pId
                                            AND(Booking__r.PAYMENT_OPTIONS__c ='CLP + ADF BANK LOAN' OR Booking__r.PAYMENT_OPTIONS__c ='CLP BANK LOAN') AND Booking__r.CBIL_Checked__c =: true
                                            AND Booking__r.Welcome_Call_Done__c =: true AND Booking__r.Booking_Stages__c ='Booking Confirmed' AND Booking__r.Booking_Date__c >=: sdate AND Booking__r.Booking_Date__c <=: edate 
                                            group by owner.name];
            System.debug('netBookingAgreementValueList::'+netBookingAgreementValueList);
        }

        
        

        if(!bankLoanBooking.isEmpty() && bankLoanBooking != null) {
            for(AggregateResult ag: bankLoanBooking) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.totalBankLoanBooking = (Decimal)ag.get('blCount');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.totalBankLoanBooking = (Decimal)ag.get('blCount'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }

        if(!cibilDoneList.isEmpty() && cibilDoneList != null) {
            for(AggregateResult ag: cibilDoneList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.cibilDoneCount = (Decimal)ag.get('cibildone');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.cibilDoneCount = (Decimal)ag.get('cibildone'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!cibilNotDoneList.isEmpty() && cibilNotDoneList != null) {
            for(AggregateResult ag: cibilNotDoneList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.cibilNotDoneCount = (Decimal)ag.get('cibilnotdone');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.cibilNotDoneCount = (Decimal)ag.get('cibilnotdone'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }

        if(!bacCibilClearList.isEmpty() && bacCibilClearList != null) {
            for(AggregateResult ag: bacCibilClearList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.BacCibilClearCount = (Decimal)ag.get('cibilclear');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.BacCibilClearCount = (Decimal)ag.get('cibilclear'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!netBookingList.isEmpty() && netBookingList != null) {
            for(AggregateResult ag: netBookingList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.netBookingCount = (Decimal)ag.get('netBooking');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.netBookingCount = (Decimal)ag.get('netBooking'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!netBookingAgreementValueList.isEmpty() && netBookingAgreementValueList != null) {
            for(AggregateResult ag: netBookingAgreementValueList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.agreementValueSum = (Decimal)ag.get('netBookingValue');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.agreementValueSum = (Decimal)ag.get('netBookingValue'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        
        System.debug('wrapperMap::'+wrapperMap);
        return wrapperMap;
    }

    public class reportDataWrapperClass{
        @AuraEnabled 
        public Decimal totalBankLoanBooking{get;set;}
        @AuraEnabled 
        public Decimal cibilDoneCount{get;set;}
        @AuraEnabled 
        public Decimal cibilNotDoneCount{get;set;}
        @AuraEnabled 
        public Decimal BacCibilClearCount{get;set;}
        @AuraEnabled 
        public Decimal BacCibilNotClearCount{get;set;} 
        @AuraEnabled 
        public Decimal BacCibilNotClearCountInTatCanc{get;set;} 
        @AuraEnabled 
        public Decimal BacCibilNotClearCountInTatNotCanc{get;set;} 
        @AuraEnabled 
        public Decimal netBookingCount{get;set;}
        @AuraEnabled 
        public Decimal agreementValueSum{get;set;}

        public reportDataWrapperClass() {
            this.totalBankLoanBooking = 0;
            this.cibilDoneCount = 0;
            this.cibilNotDoneCount = 0;
            this.BacCibilClearCount = 0;
            this.BacCibilNotClearCount = 0;
            this.BacCibilNotClearCountInTatCanc = 0;
            this.BacCibilNotClearCountInTatNotCanc = 0;
            this.netBookingCount = 0;
            this.agreementValueSum = 0;
        }
    }

}
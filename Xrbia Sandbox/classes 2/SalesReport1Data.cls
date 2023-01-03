public with sharing class SalesReport1Data {
    
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
        List<AggregateResult> totalOpportunitiesList = new List<AggregateResult>();
        List<AggregateResult> unqualifiedLeadList = new List<AggregateResult>();
        List<AggregateResult> oppOfBookingList = new List<AggregateResult>();
        List<AggregateResult> agreementValueList = new List<AggregateResult>();
        List<AggregateResult> cancelledList = new List<AggregateResult>();
        List<AggregateResult> netBookingList = new List<AggregateResult>();
        List<AggregateResult> bookingInLoanList = new List<AggregateResult>();
        List<AggregateResult> bookingInSelfFundList = new List<AggregateResult>();

        //Total Opportunities 
        if(pId == 'All'){
            totalOpportunitiesList = [select owner.name ownerName, count(Id) oppCount from Opportunity__c where (StageName__c ='Assigned' 
                                      OR StageName__c ='Under Conversion' OR StageName__c ='Inventory Selected' OR StageName__c ='Under Negotiation') 
                                      AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('totalOpportunitiesList:'+totalOpportunitiesList);
        }else if(pId != 'All'){
            totalOpportunitiesList = [select owner.name ownerName, count(Id) oppCount from Opportunity__c where Project__c =: pId AND (StageName__c ='Assigned' 
                                      OR StageName__c ='Under Conversion' OR StageName__c ='Inventory Selected' OR StageName__c ='Under Negotiation') 
                                      AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('totalOpportunitiesList:'+totalOpportunitiesList);
        }

        //Unqualified Opportunities
        if(pId == 'All'){
            unqualifiedLeadList = [select owner.name ownerName, count(Id) unCount from Opportunity__c where StageName__c ='Unqualified' 
                                   AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('unqualifiedLeadList::'+unqualifiedLeadList);
        }else if(pId != 'All'){
            unqualifiedLeadList = [select owner.name ownerName, count(Id) unCount from Opportunity__c where Project__c =: pId AND StageName__c ='Unqualified' 
                                   AND Created_Date__c >=:sdate AND Created_Date__c <=:edate group by owner.name];
            System.debug('unqualifiedLeadList::'+unqualifiedLeadList);
        }

        //Opportunities of bookings
        if(pId == 'All'){
            oppOfBookingList = [select owner.name ownerName, count(Id) bookCount from Opportunity__c where (StageName__c ='Booking in-process' 
                                OR StageName__c ='Booking Confirmed' OR StageName__c ='Booking Cancelled') AND Booking__c != null 
                                AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by owner.name];
            System.debug('oppOfBookingList::'+oppOfBookingList);
        }else if(pId != 'All'){
            oppOfBookingList = [select owner.name ownerName, count(Id) bookCount from Opportunity__c where Project__c =: pId AND (StageName__c ='Booking in-process' 
                                OR StageName__c ='Booking Confirmed' OR StageName__c ='Booking Cancelled') AND Booking__c != null
                                AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by owner.name];
            System.debug('oppOfBookingList::'+oppOfBookingList);
        }
        
        //Booking Agreement Value
        if(pId == 'All'){
            agreementValueList = [select owner.name ownerName, SUM(Amount__c) amount from Opportunity__c where (StageName__c ='Booking in-process' 
                                  OR StageName__c ='Booking Confirmed' OR StageName__c ='Booking Cancelled' ) AND Amount__c != null AND Booking__c != null AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate
                                  group by owner.name ];
            System.debug('agreementValueList:'+agreementValueList);
        }else if(pId != 'All'){
            agreementValueList = [select owner.name ownerName, SUM(Amount__c) amount from Opportunity__c where Project__c =: pId AND (StageName__c ='Booking in-process' 
                                  OR StageName__c ='Booking Confirmed' OR StageName__c ='Booking Cancelled' ) AND Amount__c != null AND Booking__c != null AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate
                                  group by owner.name ];
            System.debug('agreementValueList:'+agreementValueList);
        }   
        
        //Cancel List
        if(pId == 'All'){
            cancelledList = [select owner.name ownerName, Count(Id) cancel from Opportunity__c where StageName__c ='Booking Cancelled' AND 
                            Booking__c != null AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by owner.name ];
            System.debug('cancelledList::'+cancelledList);
        }else if(pId != 'All'){
            cancelledList = [select owner.name ownerName, Count(Id) cancel from Opportunity__c where Project__c =: pId AND StageName__c ='Booking Cancelled' AND 
                            Booking__c != null AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by owner.name ];
            System.debug('cancelledList::'+cancelledList);
        }

        //Net bookings
        if(pId == 'All'){
            netBookingList = [select owner.name ownerName, Count(Id) netBook from Opportunity__c where (StageName__c ='Booking in-process' 
                              OR StageName__c ='Booking Confirmed') AND Booking__c != null AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by owner.name];
            System.debug('netBookingList::'+netBookingList);
        }else if(pId != 'All'){
            netBookingList = [select owner.name ownerName, Count(Id) netBook from Opportunity__c where Project__c =: pId AND (StageName__c ='Booking in-process' 
                              OR StageName__c ='Booking Confirmed') AND Booking__c != null AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by owner.name];
            System.debug('netBookingList::'+netBookingList);
        }

        //Booking In Bank Loan
        if(pId == 'All'){
            bookingInLoanList = [select owner.name ownerName, Count(Id) bankLoan from Opportunity__c where (StageName__c ='Booking in-process' 
                                OR StageName__c ='Booking Confirmed') AND Booking__c != null AND (Booking__r.PAYMENT_OPTIONS__c='CLP + ADF BANK LOAN' 
                                OR Booking__r.PAYMENT_OPTIONS__c='CLP BANK LOAN') AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by owner.name ];
            System.debug('bookingInLoanList::'+bookingInLoanList);
        }else if(pId != 'All'){
            bookingInLoanList = [select owner.name ownerName, Count(Id) bankLoan from Opportunity__c where Project__c =: pId AND (StageName__c ='Booking in-process' 
                                OR StageName__c ='Booking Confirmed') AND Booking__c != null AND (Booking__r.PAYMENT_OPTIONS__c='CLP + ADF BANK LOAN' 
                                OR Booking__r.PAYMENT_OPTIONS__c='CLP BANK LOAN') AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by owner.name ];
            System.debug('bookingInLoanList::'+bookingInLoanList);
        }

        //Self funding Booking
        if(pId == 'All'){
            bookingInSelfFundList = [select owner.name ownerName, Count(Id) selfFund from Opportunity__c where (StageName__c ='Booking in-process' 
                                    OR StageName__c ='Booking Confirmed') AND Booking__c != null AND (Booking__r.PAYMENT_OPTIONS__c='SELF FUNDING – CLP' 
                                    OR Booking__r.PAYMENT_OPTIONS__c='UPFRONT PAYMENT') AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by owner.name ];
            System.debug('bookingInSelfFundList::'+bookingInSelfFundList);
        }else if(pId != 'All'){
            bookingInSelfFundList = [select owner.name ownerName, Count(Id) selfFund from Opportunity__c where Project__c =: pId AND (StageName__c ='Booking in-process' 
                                    OR StageName__c ='Booking Confirmed') AND Booking__c != null AND (Booking__r.PAYMENT_OPTIONS__c='SELF FUNDING – CLP' 
                                    OR Booking__r.PAYMENT_OPTIONS__c='UPFRONT PAYMENT') AND Booking__r.Booking_Date__c >=:sdate AND Booking__r.Booking_Date__c <=:edate group by owner.name ];
            System.debug('bookingInSelfFundList::'+bookingInSelfFundList);
        }

        
        if(!totalOpportunitiesList.isEmpty() && totalOpportunitiesList != null) {
            for(AggregateResult ag: totalOpportunitiesList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.totalOpportunities = (Decimal)ag.get('oppCount');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.totalOpportunities = (Decimal)ag.get('oppCount'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!unqualifiedLeadList.isEmpty() && unqualifiedLeadList != null) {
            for(AggregateResult ag: unqualifiedLeadList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.UnqualifiedOpportunities = (Decimal)ag.get('unCount');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.UnqualifiedOpportunities = (Decimal)ag.get('unCount'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!oppOfBookingList.isEmpty() && oppOfBookingList != null) {
            for(AggregateResult ag: oppOfBookingList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.BookingOpportunity = (Decimal)ag.get('bookCount');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.BookingOpportunity = (Decimal)ag.get('bookCount'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!agreementValueList.isEmpty() && agreementValueList != null) {
            for(AggregateResult ag: agreementValueList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.totalAgrValue = (Decimal)ag.get('amount');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.totalAgrValue = (Decimal)ag.get('amount'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }

        if(!cancelledList.isEmpty() && cancelledList != null) {
            for(AggregateResult ag: cancelledList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.totalCancel = (Decimal)ag.get('cancel');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.totalCancel = (Decimal)ag.get('cancel');   
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }

        if(!netBookingList.isEmpty() && netBookingList != null) {
            for(AggregateResult ag: netBookingList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.totalNetBooking = (Decimal)ag.get('netBook');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.totalNetBooking = (Decimal)ag.get('netBook'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }

        if(!bookingInLoanList.isEmpty() && bookingInLoanList != null) {
            for(AggregateResult ag: bookingInLoanList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.bankBookings = (Decimal)ag.get('bankLoan');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.bankBookings = (Decimal)ag.get('bankLoan'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        if(!bookingInSelfFundList.isEmpty() && bookingInSelfFundList != null) {
            for(AggregateResult ag: bookingInSelfFundList) {
                if(wrapperMap.containsKey((String)ag.get('ownerName'))) {
                    reportDataWrapperClass rwc = wrapperMap.get((String)ag.get('ownerName'));                    
                   	rwc.selfFundingBooking = (Decimal)ag.get('selfFund');                                                            
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                                
                } else {
                    reportDataWrapperClass rwc = new reportDataWrapperClass();                    
                    rwc.selfFundingBooking = (Decimal)ag.get('selfFund'); 
                    wrapperMap.put((String)ag.get('ownerName'), rwc);                    
                }
            }
        }
        
        System.debug('wrapperMap:'+wrapperMap);
        return wrapperMap;
    }
    public class reportDataWrapperClass{
        @AuraEnabled 
        public Decimal totalOpportunities{get;set;}
        @AuraEnabled 
        public Decimal UnqualifiedOpportunities{get;set;} 
        @AuraEnabled 
        public Decimal BookingOpportunity{get;set;}
        @AuraEnabled 
        public Decimal totalAgrValue{get;set;}
        @AuraEnabled 
        public Decimal totalCancel{get;set;}
        @AuraEnabled 
        public Decimal totalNetBooking{get;set;}
        @AuraEnabled 
        public Decimal bankBookings{get;set;}
        @AuraEnabled 
        public Decimal selfFundingBooking{get;set;}  

        public reportDataWrapperClass() {
            this.totalOpportunities = 0;
            this.UnqualifiedOpportunities = 0;
            this.BookingOpportunity = 0;
            this.totalAgrValue = 0;
            this.totalCancel = 0;
            this.totalNetBooking = 0;
            this.bankBookings = 0;
            this.selfFundingBooking = 0;
        }
    }
}
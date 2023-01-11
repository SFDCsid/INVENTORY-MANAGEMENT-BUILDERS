trigger BookingTrigger on Booking__c (before update, After Insert,After Update, Before Insert) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        String Projectid ='';
        String BrokerCode ='';
        List<Account> a = new List<Account>();
        List<Channel_Partner_Project__c> CPProjetList = new List<Channel_Partner_Project__c>();  
        for(booking__c b :trigger.new){
            If(B.Booking_Through__c == 'Partner'){
                Id cpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
                If(B.Booking_Through__c == 'Partner' && B.Vendor_Code__c != ''){
                    BrokerCode = b.Vendor_Code__c;
                    Projectid  = B.Project__c ;
                }
                a= [Select Id, Name,Broker_Code__c From Account Where Broker_Code__c =: BrokerCode AND recordtypeid =: cpRecordTypeId];
                CPProjetList = [Select Id, Name,account__c,Extended__c,account__r.Broker_Code__c FROM Channel_Partner_Project__c WHERE Project__c =:Projectid AND account__r.Broker_Code__c =: BrokerCode order by CreatedDate desc limit 1];
                if(CPProjetList.size()>0){
                    
                }Else{
                    Channel_Partner_Project__c CPProj = new Channel_Partner_Project__c ();
                    CPProj.Account__c = a[0].id;
                    CPProj.Project__c = Projectid ;
                    insert CPProj;                 
                }
            }Else{}
            
            
            
        }
    }
    if((trigger.isupdate || trigger.isinsert) && trigger.isbefore){
        for (booking__c p : Trigger.new) {
            
            if (p.Booking_Amount_Own_Contribution_Amount__c != null && p.Booking_Amount_Own_Contribution_Amount__c >= 0) {
                Integer n = Integer.valueOf(p.Booking_Amount_Own_Contribution_Amount__c);
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.Booking_Amount_Own_Contri_Amt_Words__c = amo1;
            } else {
                p.Booking_Amount_Own_Contri_Amt_Words__c = null;
            }
            
            if (p.ROFR_Charges_Amount__c != null && p.ROFR_Charges_Amount__c >= 0) {
                Integer n = Integer.valueOf(p.ROFR_Charges_Amount__c);
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.ROFR_Charges_Amount_words__c = amo1;
            } else {
                p.ROFR_Charges_Amount_words__c = null;
            }
            if (p.Offer_Price__c != null && p.Offer_Price__c >= 0) {
                Integer n = Integer.valueOf(p.Offer_Price__c);
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.Offer_Price_words__c = amo1;
            } else {
                p.Offer_Price_words__c = null;
            }
            if (p.Amount_Payable_to_Bank__c != null && p.Amount_Payable_to_Bank__c >= 0) {
                Integer n = Integer.valueOf((p.Amount_Payable_to_Bank__c).setscale(0,RoundingMode.HALF_UP));
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.Amount_Payable_to_Bank_words__c = amo1;
            } else {
                p.Amount_Payable_to_Bank_words__c = null;
            }
            if (p.Loan_Amount__c != null && p.Loan_Amount__c >= 0) {
                Integer n = Integer.valueOf((p.Loan_Amount__c).setscale(0,RoundingMode.HALF_UP));
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.Loan_Amount_in_Words__c = amo1;
            } else {
                p.Loan_Amount_in_Words__c = null;
            }
            if (p.Amount_paid_excl_GST__c != null && p.Amount_paid_excl_GST__c >= 0) {
                Integer n = Integer.valueOf((p.Amount_paid_excl_GST__c).setscale(0,RoundingMode.HALF_UP));
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.Amount_paid_excl_GST_in_words__c = amo1;
                p.Comma_separator_Amount_paid_excl_GST__c = QuotationManagmentServices.INFormatR(p.Amount_paid_excl_GST__c);
            } else {
                p.Amount_paid_excl_GST_in_words__c = null;
            }
            if (p.TDS_amount__c != null && p.TDS_amount__c >= 0) {
                Integer n = Integer.valueOf((p.TDS_amount__c).setscale(0,RoundingMode.HALF_UP));
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.TDS_amount_in_words__c = amo1;
                p.Comma_separator_TDS_amount__c = QuotationManagmentServices.INFormatR(p.TDS_amount__c);
            } else {
                p.TDS_amount_in_words__c = null;
            }
            if (p.balance_payable__c != null && p.balance_payable__c >= 0) {
                Integer n = Integer.valueOf((p.balance_payable__c).setscale(0,RoundingMode.HALF_UP));
                string amo = NumbersToWordsConversionClass.numberToEnglish(n);
                string amo1 = amo.remove(',');
                p.balance_payable_in_words__c = amo1;
                p.Comma_separator_balance_payable__c = QuotationManagmentServices.INFormatR(p.balance_payable__c);
            } else {
                p.balance_payable_in_words__c = null;
            }
        }
    }
    
}
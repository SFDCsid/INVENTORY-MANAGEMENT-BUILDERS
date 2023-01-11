trigger ConvertNumToWord on Quotation__c (before update) {/*
	for (Quotation__c p : Trigger.new) {
        if (p.Total_Agreement_Value_Original__c != null && p.Total_Agreement_Value_Original__c >= 0) {
            
            Integer n = Integer.valueOf(p.Total_Agreement_Value_Original__c);
            string amo = NumbersToWordsConversionClass.numberToEnglish(n);
            string amo1 = amo.remove(',');
            p.Total_Agreement_Value_Original_in_words__c = amo1;
        } else {
            p.Total_Agreement_Value_Original_in_words__c = null;
        }
    }*/
}
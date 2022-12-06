trigger getRecid on QUOTATION__c (after insert) {
    PRACTICECLASS.getRecordidforquotation(trigger.new);
}
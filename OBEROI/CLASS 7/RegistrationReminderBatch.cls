global class RegistrationReminderBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date dt = system.today();
        string query = 'Select Id,Next_reg_reminder_to_be_send_on__c,RM__c,RM_User__c'
            +' from Booking__c Where Next_reg_reminder_to_be_send_on__c =: dt AND IsRegistered__c = false';
        
        system.debug(query+'query');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Booking__c> bkList) {
        system.debug('bkList'+ bkList.size());
        try{
            RegistrationReminderBatchHelper.creatCase(bkList);
        }
        Catch (Exception ex ){
            system.debug('Exception Ala ---' + ex.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        system.debug('FINISH ---' + BC);
    }
}
global class DemandAgeingEmailBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //string yesterday = string.valueOf(system.today()-1) ;
        //String st = 'a00p000000AuAGb';
        string query = 'Select Id,Name,Next_L5_Letter_to_be_sent_on__c,Ageing_4_22_Days_Reminder_Sent__c,Ageing_23_52_Days_Reminder_Sent__c,Ageing_53_82_Days_Reminder_Sent__c,Ageing_83_112_Days_Reminder_Sent__c,Ageing_112_Days_Reminder__c,Ageing_4_22_Days__c,Ageing_23_52_Days__c,Ageing_53_82_Days__c,Ageing_83_112_Days__c,Ageing_112_Days__c,RM__c,RM_User__c,Total_Ageing_Amount__c,Largest_Bucket__c from Booking__c WHERE (Ageing_4_22_Days__c != 0.00 OR Ageing_23_52_Days__c != 0.00 OR Ageing_53_82_Days__c != 0.00 OR Ageing_83_112_Days__c != 0.00 OR Ageing_112_Days__c != 0.00)';
        //string query = 'Select Id,Name,Next_L5_Letter_to_be_sent_on__c,Ageing_4_22_Days_Reminder_Sent__c,Ageing_23_52_Days_Reminder_Sent__c,Ageing_53_82_Days_Reminder_Sent__c,Ageing_83_112_Days_Reminder_Sent__c,Ageing_112_Days_Reminder__c,Ageing_4_22_Days__c,Ageing_23_52_Days__c,Ageing_53_82_Days__c,Ageing_83_112_Days__c,Ageing_112_Days__c,RM__c,RM_User__c,Total_Ageing_Amount__c,Largest_Bucket__c from Booking__c WHERE id =: st';
        
        system.debug('query::::::::::::'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Booking__c> bkList) {
        Boolean createCase;
        Decimal LargeBucket = 0;
        
        system.debug('bkList'+ bkList.size());
        List<Booking__c> bookList = new List<Booking__c>();
        
        for(Booking__c bk: bkList){
            
            system.debug('bk'+bk);
            if(bk.Ageing_4_22_Days__c !=  0.00){
                bk.Largest_Bucket__c = Schema.Booking__c.fields.Ageing_4_22_Days__c.getDescribe().getLabel();
                LargeBucket = bk.Ageing_4_22_Days__c;
            }
            if(bk.Ageing_23_52_Days__c !=  0.00){
                bk.Largest_Bucket__c = Schema.Booking__c.fields.Ageing_23_52_Days__c.getDescribe().getLabel();
                LargeBucket = bk.Ageing_23_52_Days__c;
            }
            if(bk.Ageing_53_82_Days__c !=  0.00){
                bk.Largest_Bucket__c = Schema.Booking__c.fields.Ageing_53_82_Days__c.getDescribe().getLabel();
                LargeBucket = bk.Ageing_53_82_Days__c;
            }
            if(bk.Ageing_83_112_Days__c !=  0.00){
                bk.Largest_Bucket__c = Schema.Booking__c.fields.Ageing_83_112_Days__c.getDescribe().getLabel();
                LargeBucket = bk.Ageing_83_112_Days__c;
            }
            if(bk.Ageing_112_Days__c !=  0.00){
                bk.Largest_Bucket__c = Schema.Booking__c.fields.Ageing_112_Days__c.getDescribe().getLabel();
                LargeBucket = bk.Ageing_112_Days__c;
            }
            
            if(bk.Ageing_4_22_Days__c == 0.00 && bk.Ageing_4_22_Days_Reminder_Sent__c == true){
                bk.Ageing_4_22_Days_Reminder_Sent__c = false;
            }
            if(bk.Ageing_23_52_Days__c == 0.00 && bk.Ageing_23_52_Days_Reminder_Sent__c == true){
                bk.Ageing_23_52_Days_Reminder_Sent__c = false;
            }
            if(bk.Ageing_53_82_Days__c == 0.00 && bk.Ageing_53_82_Days_Reminder_Sent__c == true){
                bk.Ageing_53_82_Days_Reminder_Sent__c = false;
            }
            system.debug('bk'+bk.Ageing_53_82_Days_Reminder_Sent__c);
            system.debug('bkageing'+bk.Ageing_53_82_Days_Reminder_Sent__c);
            if(bk.Ageing_83_112_Days__c == 0.00 && bk.Ageing_83_112_Days_Reminder_Sent__c == true){
                bk.Ageing_83_112_Days_Reminder_Sent__c = false;
            }
            if(bk.Ageing_112_Days__c == 0.00 && bk.Ageing_112_Days_Reminder__c == true ){
                bk.Ageing_112_Days_Reminder__c = false;
            }
            if(bk.Ageing_4_22_Days__c == 0.00 && bk.Ageing_23_52_Days__c == 0.00 && bk.Ageing_53_82_Days__c == 0.00 && bk.Ageing_83_112_Days__c == 0.00 && bk.Ageing_112_Days__c == 0.00){
                   bk.Largest_Bucket__c = '';
                   createCase = false;
               }else{
                   createCase = true;
               }
            bookList.add(bk);
        }
        try{
            system.debug('createCaseTry'+createCase);
            update bookList;
            if(createCase){
                DemandAgeingEmailBatchHelper.creatCase(bookList);
            }
        }
        Catch (Exception ex ){
            system.debug('Exception Ala ---' + ex.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        system.debug('FINISH ---' + BC);
    }
}
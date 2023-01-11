global class AllotmentCaseGenPerBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string st = 'a00p000000Aet4eAAB';
        string query = 'Select Id,Quotation__r.Sale_Price_for_Carpet_Area_of_the_Unit__c,Total_Credits__c,'+
            'Project__r.Allotment_case_generation__c from Booking__c Where Allotment_Generation__c = false';
        
        system.debug(query+'query');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Booking__c> bkList) {
        system.debug('bkList'+ bkList.size());
        List<Booking__c> bookList = new List<Booking__c>();
        
        for(Booking__c bk: bkList){
            if(bk.Total_Credits__c != 0.0 && bk.Total_Credits__c != null){
                decimal per = (bk.Total_Credits__c / bk.Quotation__r.Sale_Price_for_Carpet_Area_of_the_Unit__c)*100;
                system.debug('per'+per);
                system.debug('projper'+bk.Project__r.Allotment_case_generation__c);
                if(per >= bk.Project__r.Allotment_case_generation__c){
                    bk.Allotment_Generation__c = true;
                    bookList.add(bk);
                }
            }
            try{
                update bookList;
            }
            Catch (Exception ex ){
                system.debug('Exception Ala ---' + ex.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        system.debug('FINISH ---' + BC);
    }
    
   
}
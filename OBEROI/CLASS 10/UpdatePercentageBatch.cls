global class UpdatePercentageBatch implements Database.Batchable<sObject>,Schedulable {
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        String query;
        query = 'select id,name,Total_Received_Amount__c,Total_Received_Percentage__c,Quotation__r.Sale_Price_for_Carpet_Area_of_the_Unit__c from Booking__c where Total_Received_Amount__c > 0 and Status__c = \'Booking In Process\'';
        return database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext BC, List<sObject> BookList) {
        updateTotalReceivedPercentage(BookList);
        
    }
   
    global void finish(Database.BatchableContext BC) {
        
    }
    
    public static void updateTotalReceivedPercentage(list<Booking__c> blist){
        list<Booking__c> updateBList = new list<Booking__c>();
        for(Booking__c b : blist){
            b.Total_Received_Percentage__c = (b.Total_Received_Amount__c / b.Quotation__r.Sale_Price_for_Carpet_Area_of_the_Unit__c)*100;
            updateBList.add(b);
        }
        System.debug('updateBList :::' +updateBList);
        update updateBList;
    }
     global void execute(SchedulableContext sc) {
                UpdatePercentageBatch upb = new UpdatePercentageBatch (); 
                database.executebatch(upb,50);
        }

}
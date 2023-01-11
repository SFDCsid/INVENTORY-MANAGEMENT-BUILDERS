/*
* Name: OpportunityTriggerController
* Author: IBM India Pvt. Ltd.
*/
public class OpportunityTriggerController{
    
    
    public static void createQuickBooking(Map<Id,Id> mapOpportunityId){
        //Booking__c quickBooking = null;
        system.debug('mapOpportunityId'+mapOpportunityId.keyset());
        system.debug('mapOpportunityId'+mapOpportunityId.values());
        List<Booking__c> lstquickbook = new List<Booking__c>();
        for(String qbook : mapOpportunityId.keyset()){
             Booking__c quickBooking = new Booking__c();
             quickBooking.Opportunity__c = qbook;
             quickBooking.Project__c = mapOpportunityId.get(qbook);
             quickBooking.Booking_Confirmation_Date__c = Date.Today();
             //quickBooking.Booking_Confirmation_Date__c = System.now();
             quickBooking.Status__c = 'New';
             lstquickbook.add(quickBooking);
             system.debug('lstquickbook'+lstquickbook);
        }
        if(lstquickbook.size() > 0){
            insert lstquickbook;
        }
    }
}
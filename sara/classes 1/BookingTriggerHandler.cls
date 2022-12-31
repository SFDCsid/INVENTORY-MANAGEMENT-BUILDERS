public class BookingTriggerHandler {
    public static void beforeUpdate(Map<Id, Booking__c> oldMap, Map<Id, Booking__c> newMap) {
        Map<Id, List<Booking__c>> bookingMap = new Map<Id, List<Booking__c>>();
        
        for(Booking__c oldBooking: oldMap.values()) {
            Booking__c newBooking = newMap.get(oldBooking.Id);
            
            if(oldBooking.Booking_Cancellation_Approval_Required__c != newBooking.Booking_Cancellation_Approval_Required__c && newBooking.Booking_Cancellation_Approval_Required__c) {
                if(!bookingMap.containsKey(newBooking.Project__c)) {
                    List<Booking__c> newList = new List<Booking__c>();
                    newList.add(newBooking);
                    bookingMap.put(newBooking.Project__c, newList);
                } else {
                    bookingMap.get(newBooking.Project__c).add(newBooking);
                }
            }
            if(!bookingMap.isEmpty() && bookingMap != null)
                BookingHandlerServices.getApprovalDetails(bookingMap);
        }
    }
    
    public static void afterUpdate(Map<Id, Booking__c> oldMap, Map<Id, Booking__c> newMap) {
        List<Booking__c> bList = new List<Booking__c>();
        
        for(Booking__c oldBooking: oldMap.values()) {
            Booking__c newBooking = newMap.get(oldBooking.Id);
            
        	if(oldBooking.Booking_Stages__c != newBooking.Booking_Stages__c && newBooking.Booking_Stages__c == 'Booking Cancelled')
                bList.add(newBooking);
        }
        if(!bList.isEmpty() && bList != null)
            BookingHandlerServices.bookingCancellation(bList);
    }
}
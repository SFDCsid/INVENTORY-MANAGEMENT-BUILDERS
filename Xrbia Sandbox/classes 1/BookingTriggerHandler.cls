//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 27-10-2022
//-------------------------------------------//
public class BookingTriggerHandler {
    public static void afterInsert(List<Booking__c> bList) {
        Map<Id, Booking__c> quotationBookingMap = new Map<Id, Booking__c>();
        Set<Id> towerIdSet = new Set<Id>();
        
        for(Booking__c b: bList) {
            if(b.Booking_Date__c != null && b.Tower__c != null) {
                quotationBookingMap.put(b.Quotation__c, b);
                towerIdSet.add(b.Tower__c);
            }
        }
        if(quotationBookingMap != null && !towerIdSet.isEmpty())
            BookingHandlerServices.updatePaymentMilestoneDueDate(quotationBookingMap, towerIdSet);
    }
    
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
            if (oldBooking.CBIL_Approved__c != newBooking.CBIL_Approved__c) {
                BookingHandlerServices.updateBookingCBILStatus(newBooking);
            }    
            if (oldBooking.Welcome_Call_Status__c != newBooking.Welcome_Call_Status__c) {
                BookingHandlerServices.updateBookingWelcomeCallStatus(newBooking);
            }
            if (oldBooking.Transaction_Status__c != newBooking.Transaction_Status__c) {
                BookingHandlerServices.updateBookingWelcomeCallStatus(newBooking);
            }
        }
    }
    
    public static void afterUpdate(Map<Id, Booking__c> oldMap, Map<Id, Booking__c> newMap) {
        List<Booking__c> bList = new List<Booking__c>();
        Map<Id, Booking__c> quotationBookingMap = new Map<Id, Booking__c>();
        Set<Id> towerIdSet = new Set<Id>();
        
        for(Booking__c oldBooking: oldMap.values()) {
            Booking__c newBooking = newMap.get(oldBooking.Id);
            
        	if(oldBooking.Booking_Stages__c != newBooking.Booking_Stages__c && newBooking.Booking_Stages__c == 'Booking Cancelled')
                bList.add(newBooking);
            if(oldBooking.Booking_Date__c != newBooking.Booking_Date__c && newBooking.Quotation__c != null && newBooking.Tower__c != null) {
                quotationBookingMap.put(newBooking.Quotation__c, newBooking);
                towerIdSet.add(newBooking.Tower__c);
            }
        }
        if(!bList.isEmpty() && bList != null)
            BookingHandlerServices.bookingCancellation(bList);
        if(quotationBookingMap != null && !towerIdSet.isEmpty())
            BookingHandlerServices.updatePaymentMilestoneDueDate(quotationBookingMap, towerIdSet);
    }
}
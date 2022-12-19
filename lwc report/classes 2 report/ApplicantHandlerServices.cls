public class ApplicantHandlerServices {
    public static void rollUpOnBooking(Map<Id, Applicant__c> applicantMap) {
        List<Booking__c> updateBookingList = new List<Booking__c>();
        List<Booking__c> bookingList = new List<Booking__c>();
        Map<Id, Booking__c> bookingMap = new Map<Id, Booking__c>();
        
        bookingList = [Select Id, Name, Primary_Applicant_Title__c, Primary_Applicant_Name__c, Primary_Applicant_Mobile__c, Primary_Applicant_Email__c
                       from Booking__c where Id IN: applicantMap.keySet()];
        system.debug('bookingList: '+bookingList);
        
        if(!bookingList.isEmpty() && bookingList != null) {
            for(Booking__c b: bookingList) {
                bookingMap.put(b.Id, b);
            }
        }
        
        if(!applicantMap.isEmpty() && applicantMap != null) {
            for(Id bId: applicantMap.keySet()) {
                if(bookingMap.containsKey(bId)) {
                    Booking__c b = bookingMap.get(bId);
                    b.Primary_Applicant_Title__c = applicantMap.get(bId).Applicant_Title__c;
                    b.Primary_Applicant_Name__c = applicantMap.get(bId).Name;
                    b.Primary_Applicant_Mobile__c = applicantMap.get(bId).Mobile_Number__c;
                    b.Primary_Applicant_Email__c = applicantMap.get(bId).Email__c;
                    updateBookingList.add(b);
                }
            }
        }
        if(!updateBookingList.isEmpty() && updateBookingList != null)
            update updateBookingList;
    }
}
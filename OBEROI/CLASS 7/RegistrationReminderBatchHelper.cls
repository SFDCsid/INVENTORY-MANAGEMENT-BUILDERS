public class RegistrationReminderBatchHelper {
    
    public static void creatCase(list<Booking__c> bookList){
        system.debug('bookList'+bookList);
        List<Case> cList = new List<Case>();
        Id recId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Registration Reminder').getRecordTypeId();
        for(Booking__c bklt : bookList){
            Case c = new Case();
            c.Booking__c = bklt.Id;
            c.OwnerId = bklt.RM_User__c;
            c.Status = 'New';
            c.Type = 'Registration Reminder';
            c.Stage__c = 'New';
            c.RecordTypeId = recId;
            c.Subject = 'Registration Reminder';
            bklt.Last_registration_reminder_sent_on__c = system.today();
            cList.add(c);
            System.debug('Case created Successfully!!!!!!');
        }
        insert cList;
        update bookList;
    }
}
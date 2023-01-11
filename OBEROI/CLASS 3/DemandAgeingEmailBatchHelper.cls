public class DemandAgeingEmailBatchHelper {
    
    public static void creatCase(list<Booking__c> bookList) {
        system.debug('bookList'+bookList);
        List<Case> cList = new List<Case>();
        Id recId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Demand Ageing').getRecordTypeId();
        for(Booking__c bklt : bookList){
            
            if(bklt.Largest_Bucket__c == 'Ageing 4-22 Days' && bklt.Largest_Bucket__c != null 
               && bklt.Ageing_4_22_Days_Reminder_Sent__c != true){
                   Case c = new Case();
                   c.Booking__c = bklt.Id;
                   c.OwnerId = bklt.RM_User__c;
                   c.Status = 'New';
                   c.Stage__c = 'Demand Reminder';
                   c.RecordTypeId = recId;
                   c.Subject = 'L1 - 1st Reminder';
                   c.Type = 'L1 - 1st Reminder';
                   c.Origin = 'System Generated';
                   cList.add(c);
                   bklt.Ageing_4_22_Days_Reminder_Sent__c = true;
               }else if(bklt.Largest_Bucket__c == 'Ageing 23-52 Days' && bklt.Largest_Bucket__c != null 
                        && bklt.Ageing_23_52_Days_Reminder_Sent__c != true){
                            Case c = new Case();
                            c.Booking__c = bklt.Id;
                            c.OwnerId = bklt.RM_User__c;
                            c.Status = 'New';
                            c.Stage__c = 'Demand Reminder';
                            c.RecordTypeId = recId;
                            c.Subject = 'L2 - 2nd Reminder';
                            c.Type = 'L2 - 2nd Reminder';
                            c.Origin = 'System Generated';
                            cList.add(c);
                            bklt.Ageing_23_52_Days_Reminder_Sent__c = true;
                        }else if(bklt.Largest_Bucket__c == 'Ageing 53-82 Days' && bklt.Largest_Bucket__c != null 
                                 && bklt.Ageing_53_82_Days_Reminder_Sent__c != true){
                                     Case c = new Case();
                                     c.Booking__c = bklt.Id;
                                     c.OwnerId = bklt.RM_User__c;
                                     c.Status = 'New';
                                     c.Stage__c = 'Demand Reminder';
                                     c.RecordTypeId = recId;
                                     c.Subject = 'L3 - 3rd Reminder';
                                     c.Type = 'L3 - 3rd Reminder';
                                     c.Origin = 'System Generated';
                                     cList.add(c);
                                     bklt.Ageing_53_82_Days_Reminder_Sent__c = true;
                                 }else if(bklt.Largest_Bucket__c == 'Ageing 83-112 Days' && bklt.Largest_Bucket__c != null 
                                          && bklt.Ageing_83_112_Days_Reminder_Sent__c != true){
                                              Case c = new Case();
                                              c.Booking__c = bklt.Id;
                                              c.OwnerId = bklt.RM_User__c;
                                              c.Status = 'New';
                                              c.Stage__c = 'Demand Reminder';
                                              c.RecordTypeId = recId;
                                              c.Subject = 'L4 - Default Notice Letter';
                                              c.Type = 'L4 - Default Notice Letter';
                                              c.Origin = 'System Generated';
                                              cList.add(c);
                                              bklt.Ageing_83_112_Days_Reminder_Sent__c = true;
                                          }else if(bklt.Largest_Bucket__c == 'Ageing >112 Days' && bklt.Largest_Bucket__c != null 
                                                   && bklt.Ageing_112_Days_Reminder__c != true && bklt.Next_L5_Letter_to_be_sent_on__c != system.today()){
                                                       Case c = new Case();
                                                       c.Booking__c = bklt.Id;
                                                       c.OwnerId = bklt.RM_User__c;
                                                       c.Status = 'New';
                                                       c.Stage__c = 'Demand Reminder';
                                                       c.RecordTypeId = recId;
                                                       c.Subject = 'L5 - Default Notice Letter';
                                                       c.Type = 'L5 - Default Notice Letter';
                                                       c.Origin = 'System Generated';
                                                       cList.add(c);
                                                       bklt.Ageing_112_Days_Reminder__c = true;
                                                       bklt.L5_Case_Creation_Date__c = system.today();
                                                   }else if(bklt.Largest_Bucket__c == 'Ageing >112 Days' && bklt.Largest_Bucket__c != null 
                                                            && bklt.Ageing_112_Days_Reminder__c == true && bklt.Next_L5_Letter_to_be_sent_on__c == system.today()){
                                                                Case c = new Case();
                                                                c.Booking__c = bklt.Id;
                                                                c.OwnerId = bklt.RM_User__c;
                                                                c.Status = 'New';
                                                                c.Stage__c = 'Demand Reminder';
                                                                c.RecordTypeId = recId;
                                                                c.Subject = 'L5 - Default Notice Letter';
                                                                c.Type = 'L5 - Default Notice Letter';
                                                                c.Origin = 'System Generated';
                                                                cList.add(c);
                                                                bklt.Ageing_112_Days_Reminder__c = true;
                                                                bklt.L5_Case_Creation_Date__c = system.today();
                                                            }
            bklt.Demand_Reminder_Send_Date__c = system.today();
            
            System.debug('Case created Successfully!!!!!!'); 
        }
        If(cList.size()>0){
            insert cList;
            update bookList;
        }
    }
}
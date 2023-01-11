trigger SubventionIntrestCasetrg on Case (before Update,after Update) {
    if(Trigger.isbefore && Trigger.isUpdate){
        List<case> Cinsert = new List<case>();
        List<case> Cupdate = new List<case>();
        Set<id> caseid = New Set<id>();
        
        Set<id> bookid = New Set<id>(); 
        List<Booking__c> booklist = new List<Booking__c>(); 
        Map<id,Booking__c> bookmap=new Map<id,Booking__c>();
        String Remark;
        for(case ca : Trigger.New){
            if(ca.status=='new' && ca.RecordTypeId=='012p0000000TZ2z' && ca.Subvention_amount_correct__c == 'No' && 
               ca.Reason_for_incorrect_subvention_amount__c == 'Receipt of Advance / Self Contribution amount from Bank' &&
               ca.Booking__c!=null && Trigger.oldmap.get(ca.id).Reason_for_incorrect_subvention_amount__c != ca.Reason_for_incorrect_subvention_amount__c){
                   
                   //closed current case
                   ca.Stage__c='Close';
                   ca.Status='Closed';
                   
                   //creating new case
                   Case new_case =new Case();
                   new_case.Status='New';
                   new_case.Origin='System Generated';
                   new_case.Remarks_Finance_Team__c=ca.Remarks_Finance_Team__c;  
                   new_case.Booking__c=ca.Booking__c;
                   new_case.Receipt_Record_link__c=ca.Receipt_Record_link__c;
                   
                   new_case.Stage__c='RM Verification';
                   new_case.RecordTypeId='012p0000000TZ2z';
                   new_case.Subvention_amount_correct__c=ca.Subvention_amount_correct__c;
                   new_case.Reason_for_incorrect_subvention_amount__c=ca.Reason_for_incorrect_subvention_amount__c;
                   new_case.Subject='Subvention Interest - RM Verification';
                    
 
                   Cinsert.add(new_case); 
                   //caseid.add(ca.id);
                   bookid.add(ca.Booking__c);
               }
            else if(ca.Self_cont_amount_received_from_Bank__c!=null && ca.Sub_Interest_amount_paid_for_this_amount__c!=null &&
                    ca.status=='new' && ca.RecordTypeId=='012p0000000TZ2z' && ca.Subvention_amount_correct__c == 'No' &&
                    ca.Reason_for_incorrect_subvention_amount__c == 'Receipt of Advance / Self Contribution amount from Bank'
                    &&
                    (Trigger.oldmap.get(ca.id).Self_cont_amount_received_from_Bank__c !=ca.Self_cont_amount_received_from_Bank__c || 
                     Trigger.oldmap.get(ca.id).Sub_Interest_amount_paid_for_this_amount__c !=ca.Sub_Interest_amount_paid_for_this_amount__c))
            {
                bookid.add(ca.Booking__c);
                Cupdate.add(ca);
            }
            else if(ca.status=='new' && ca.RecordTypeId=='012p0000000TZ2z' && 
                    ca.Subvention_amount_correct__c == 'Yes' && 
                     
                    Trigger.oldmap.get(ca.id).Interest_amount_is_checked__c != ca.Interest_amount_is_checked__c 
                    && ca.Interest_amount_is_checked__c == True && ca.Stage__c=='AR Verification'){
                        ca.Stage__c='Close';
                        ca.Status='Closed';
                    }
        }
         
        if(bookid.size()>0){
            booklist=[select id,RM_User__c,Property__r.Finance_Subvention_interest_user__c from Booking__c where id IN: bookid];
            for(Booking__c b:booklist){
                bookmap.put(b.id,b);
            }
        }
        
        if(Cinsert.size()>0){
            for(Case c:Cinsert){
                if(bookmap.get(c.Booking__c).RM_User__c!=null)
                    c.OwnerId=bookmap.get(c.Booking__c).RM_User__c;
            }
            insert Cinsert;
        }
        if(Cupdate.size()>0){
            for(Case c:Cupdate){
                if(bookmap.get(c.Booking__c).Property__r.Finance_Subvention_interest_user__c!=null){
                    c.OwnerId=bookmap.get(c.Booking__c).Property__r.Finance_Subvention_interest_user__c;
                    c.Stage__c='Finance Verification';
                    c.Subvention_amount_correct__c = '';
                    c.Reason_for_incorrect_subvention_amount__c = '';
                }
                    
            }
            //update Cupdate;
        }
        
        
        
    }
    
}
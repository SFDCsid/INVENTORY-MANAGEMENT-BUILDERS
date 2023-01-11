trigger RHX_Booking on Booking__c(after insert,After Update) { //after delete, after insert, after undelete, after update, before delete
    /* Type rollClass = System.Type.forName('rh2', 'ParentUtil');
if(rollClass != null) {
rh2.ParentUtil pu = (rh2.ParentUtil) rollClass.newInstance();
if (trigger.isAfter) {
pu.performTriggerRollups(trigger.oldMap, trigger.newMap, new String[]{'Booking__c'}, null);
}
}*/
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
        List<Booking__c> book = Trigger.New; 
        Id quot=book[0].Quotation__c;
        Id opp = book[0].Opportunity__c;
        Date bookingdate=book[0].Booking_Date__c;
        List<Quotation__c> quotList = [select id,name,Sale_Price_for_Carpet_Area_of_the_Unit__c from Quotation__c where id =: quot];
        List<Opportunity> optyList = [select id,name,amount from Opportunity where id =: opp];
        List<Quotation_Billing_Line_Item__c> QBLineItem = [select id,name,Quotation__c,Due_After_Days__c,Due_Date__c from Quotation_Billing_Line_Item__c where Quotation__c =: quot];
        //and Milestone_Type__c = 'Time Linked'];
        List<Quotation_Billing_Line_Item__c> QBupdateList = new List<Quotation_Billing_Line_Item__c>();
        for(Quotation_Billing_Line_Item__c q:QBLineItem){
            Integer days=Integer.valueOf(q.Due_After_Days__c);
            if(days != null && days > 0){
                days = days - 1;
                q.Due_Date__c = bookingdate.addDays(days);
                QBupdateList.add(q);
            }Else if(days == 0){
                q.Due_Date__c = bookingdate.addDays(days);
                QBupdateList.add(q);
            }Else{
            }
        }
        system.debug('Q:'+QBupdateList);
        if(!QBupdateList.isEmpty())
            update QBupdateList;
        
        if(quotList != null && quotList.size()>0){
            optyList[0].amount = quotList[0].Sale_Price_for_Carpet_Area_of_the_Unit__c;
            update optyList[0];
        }
    }
    if(trigger.isafter &&trigger.isUpdate){
        Set<id> bookid = New Set<id>();
        For(Booking__c bk :trigger.new){
            if(bk.status__c != Trigger.oldmap.get(bk.id).Status__c && bk.status__c == 'Booked'){
                Bookid.add(Bk.id);
            }
        }
        //Call class Pass set of ids
        //BookingEmailToCustomer.sendEmail(Bookid);
    }
}
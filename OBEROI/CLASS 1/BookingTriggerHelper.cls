/**
* @Author:      Ravi Kumar K
* @Company:     IBM
* @Date:        12/03/2019
* @Description: Helper class for BookingTriggerHandler
*
* History
* <Date>       <Authors Name>      <Brief Description of Change>
12/03/2019    Ravi Kumar K     Added an method setParking
16/5/19       Amit Kohakade    Added v1.1 version changes in updateLineItemPaymentDate method. Updated <date> in Description__c and Payment_Plan_Line_Item_Name__c  field with Booking date + Due After Days of Billing Plan Line Item      
* -------------------------------------------------------------
*/
public without sharing class BookingTriggerHelper {
    
    public static Map<String,List<Id>> setParking(List<Booking__c> bookings,Map<Id,Booking__c> bookingDetailsMap,String methodName){
        Set<Id> ProjectIdSetBooked = new Set<Id>();
        Set<Id> ProjectIdSetCancelled = new Set<Id>();
        
        for(Booking__c singleBooking:bookings){
            if(methodName=='Insert'){
                system.debug('methodName--'+singleBooking.Status__c);
                system.debug('methodName--'+singleBooking.Project__c);
                if(singleBooking.Status__c=='Booked' && singleBooking.Project__c!=null){
                    ProjectIdSetBooked.add(singleBooking.Project__c); 
                }
                if(singleBooking.Status__c=='Cancelled' && singleBooking.Project__c!=null){
                    ProjectIdSetCancelled.add(singleBooking.Project__c);
                }
            }  
            
            if(methodName=='Update'){
                if(singleBooking.Status__c=='Booked' && singleBooking.Status__c!=bookingDetailsMap.get(singleBooking.Id).Status__c
                   && singleBooking.Project__c!=null){
                       ProjectIdSetBooked.add(singleBooking.Project__c); 
                   }
                if(singleBooking.Status__c=='Cancelled' && singleBooking.Status__c!=bookingDetailsMap.get(singleBooking.Id).Status__c
                   && singleBooking.Project__c!=null){
                       ProjectIdSetCancelled.add(singleBooking.Project__c);
                       System.debug('ProjectIdSetCancelled__'+ProjectIdSetCancelled);
                   }
            }
        }
        Map<String,List<Id>> resultMap;
        //Validation Message
        if(ProjectIdSetBooked.size()>0){
            System.debug('Size__'+ProjectIdSetBooked.size());
            System.debug('towerId__'+ProjectIdSetBooked);
            Map<Id,Project__c> projectMap = new Map<Id,Project__c>([SELECT id, X_of_Triple_Parking__c, X_of_Tandem_Parking__c,X_of_Single_Parking__c,
                                                                    X_of_Single_Parking_Remaining__c,X_of_Tandem_Parking_Remaining__c,X_of_Triple_Parking_Remaining__c
                                                                    FROM Project__c WHERE Id=:ProjectIdSetBooked]);       
            for(Booking__c bookingRecord: bookings){
                if(bookingRecord.X_of_Single_Parking__c != null && projectMap.get(bookingRecord.Project__c).X_of_Single_Parking_Remaining__c != null
                   && projectMap.get(bookingRecord.Project__c).X_of_Single_Parking_Remaining__c!=0 && projectMap.get(bookingRecord.Project__c).X_of_Single_Parking_Remaining__c - bookingRecord.X_of_Single_Parking__c<0){
                       bookingRecord.X_of_Single_Parking__c.addError(Label.Requested_of_parking_unavailable);
                   }if(bookingRecord.X_of_Tandem_Parking__c != null && projectMap.get(bookingRecord.Project__c).X_of_Tandem_Parking_Remaining__c != null
                       && projectMap.get(bookingRecord.Project__c).X_of_Tandem_Parking_Remaining__c!=0 && projectMap.get(bookingRecord.Project__c).X_of_Tandem_Parking_Remaining__c - bookingRecord.X_of_Tandem_Parking__c<0){
                           bookingRecord.X_of_Tandem_Parking__c.addError(Label.Requested_of_parking_unavailable);
                       }if(bookingRecord.X_of_Triple_Parking__c != null && projectMap.get(bookingRecord.Project__c).X_of_Triple_Parking_Remaining__c != null
                           && projectMap.get(bookingRecord.Project__c).X_of_Triple_Parking_Remaining__c!=0 && projectMap.get(bookingRecord.Project__c).X_of_Triple_Parking_Remaining__c - bookingRecord.X_of_Triple_Parking__c<0){
                               bookingRecord.X_of_Triple_Parking__c.addError(Label.Requested_of_parking_unavailable);
                           }
            }
            resultMap = BookingTriggerHandler.setParkingDetailsForBooked(ProjectIdSetBooked);
        }
        if(ProjectIdSetCancelled.size()>0){
            System.debug('Cancelled__');
            resultMap = BookingTriggerHandler.setParkingDetailsForcancelled(ProjectIdSetCancelled);
        }
        return resultMap;
    }
    
    //Once booking is created for Grande, automatically create a booking for Grand Studio : code added by Shweta 
    public static void createGrandBooking(List<Booking__c> bookingNewList){
        
        List<Booking__c> BookingList = new List<Booking__c>(); 
        map<String , Property__c> propertyMap= new map<String , Property__c>();
        Set<Id> setOfPropertyIds = new Set<Id>();
        Set<Id> setOfBPIds = new Set<Id>();
        map<String,String> mapBillingPlan = new map<String,String>();
        map<String,Booking__c> mapBooking = new map<String,Booking__c>();
        List<Database.SaveResult> srList = new List<Database.SaveResult>();
        try{
            for(Booking__c BookingObj : bookingNewList){
                setOfPropertyIds.add(BookingObj.Property__c);
                system.debug('setOfPropertyIds---->'+setOfPropertyIds);
                setOfBPIds.add(BookingObj.Billing_Plan__c);
            }          
            List<Property__c> propertyList = [Select Related_Jodi_Property__c,Is_Jodi_Flat__c, Unit_Type__c from Property__c where Id in : setOfPropertyIds];
            system.debug('propertyList======'+propertyList);
            for(Payment_Plan__c pp : [select id,Related_Jodi_Billing_Plan__c from Payment_Plan__c where Id IN : setOfBPIds]){
                mapBillingPlan.put(pp.Id,pp.Related_Jodi_Billing_Plan__c);
            }
            system.debug('mapBillingPlanmapBillingPlan'+mapBillingPlan);
            if(propertyList.size() > 0){
                for(Property__c propertyObj : propertyList){
                    propertyMap.put(propertyObj.Id, propertyObj);
                }               
                for(Booking__c bookingObj : bookingNewList){
                    system.debug('In if ======'+bookingObj.Property__r.Related_Jodi_Property__c);
                    if(propertyMap.get(bookingObj.Property__c).Related_Jodi_Property__c != null){
                        Booking__c bookingNewObj = new Booking__c();
                        bookingNewObj.Site__c = bookingObj.Site__c;
                        bookingNewObj.Project__c = bookingObj.Project__c;
                        bookingNewObj.Tower__c = bookingObj.Tower__c;
                        bookingNewObj.Property__c = propertyMap.get(bookingObj.Property__c).Related_Jodi_Property__c;
                        if(mapBillingPlan != null && mapBillingPlan.size() > 0){
                            bookingNewObj.Billing_Plan__c = mapBillingPlan.get(bookingObj.Billing_Plan__c);
                        }
                        //bookingNewObj.Search_Term__c = bookingObj.Search_Term__c;
                        bookingNewObj.Opportunity__c = bookingObj.Opportunity__c;
                        bookingNewObj.Booking_Date__c = bookingObj.Booking_Date__c;
                        bookingNewObj.Order_Reason__c = bookingObj.Order_Reason__c;
                        bookingNewObj.Primary_Applicant__c  = bookingObj.Primary_Applicant__c;
                        bookingNewObj.Related_Booking__c = bookingObj.Id;
                        bookingNewObj.Billing_Street__c = bookingObj.Billing_Street__c;
                        bookingNewObj.Billing_City__c = bookingObj.Billing_City__c;
                        bookingNewObj.Billing_Country__c = bookingObj.Billing_Country__c;
                        bookingNewObj.Billing_Location__c = bookingObj.Billing_Location__c;
                        bookingNewObj.Billing_Post_Code__c = bookingObj.Billing_Post_Code__c;
                        bookingNewObj.Mobile__c = bookingObj.Mobile__c;
                        bookingNewObj.Email__c = bookingObj.Email__c;
                        bookingNewObj.PAN_Number__c = bookingObj.PAN_Number__c;
                        bookingNewObj.Sales_Rep__c = Userinfo.getUserid();
                        BookingList.add(bookingNewObj);
                        //mapBooking.put(bookingObj.Id,);
                    }
                }
                if(BookingList.size() > 0){
                    //insert BookingList;
                    srList = Database.insert(BookingList, false);
                }
            }
            List<Id> lstInsertId = new List<Id>();
            system.debug('@@srLis--'+srList );
            for (Database.SaveResult s : srList){
              system.debug('@@s.isSuccess()--'+s.isSuccess());
                if (s.isSuccess()) {
                  system.debug(s.getId()); 
                    lstInsertId.add(s.getId()); 
                } 
            }
            system.debug('mapBookingmapBookingmapBooking'+lstInsertId);
            for(Booking__c bk : [select id,Related_Booking__c from Booking__c where Id IN : lstInsertId]){
                //mapBooking.put(bk.Related_Booking__c,bk.Id);
                mapBooking.put(bk.Related_Booking__c,bk);
            }
            system.debug('mapBookingmapBookingmapBooking'+mapBooking);
            List<Booking__c> listRelatedJodiMaster = new List<Booking__c>();
            for(Booking__c bkg : [select id,Related_Jodi_Booking__c from Booking__c where Id IN : mapBooking.keyset()]){
                bkg.Related_Jodi_Booking__c = mapBooking.get(bkg.Id).Id;
                listRelatedJodiMaster.add(bkg);
                
            }
            system.debug('mapBookingmapBookingmapBooking'+listRelatedJodiMaster);
            if(listRelatedJodiMaster.size()>0 && !listRelatedJodiMaster.isEmpty()){
                update listRelatedJodiMaster;
            }
        }
        catch(Exception ex){
            system.debug('error======'+ex);
        }
        
    }
    
    // To update Billing Plan line Item payment Date 
     public static void updateLineItemPaymentDate(List<Booking__c> bookingNewList){
     
         map<id,id> mapbookingToBillingPlan= new map<id,id>();
         map<id,Date> mapIdToBookingDate= new map<id,Date>();
         List<Billing_Plan_Line_Item__c> listbpli = new List<Billing_Plan_Line_Item__c>();
          //  try{
                for(Booking__c BookingObj : bookingNewList){
                    mapbookingToBillingPlan.put(BookingObj.Billing_Plan__c, BookingObj.Id);
                    mapIdToBookingDate.put(BookingObj.Id, BookingObj.Booking_Date__c);
                }  
                 system.debug('@@mapbookingToBillingPlan'+mapbookingToBillingPlan);
                if(mapbookingToBillingPlan.size()>0 && !mapbookingToBillingPlan.isEmpty()){
                system.debug('@@mapbookingToBillingPlan');
                    for(Billing_Plan_Line_Item__c bpli: [SELECT Id,Payment_plan__c,Payment_Date__c,Due_After_Days__c,Payment_Plan_Line_Item_Name__c,/*v1.1 Starts*/Description__c/*v1.1 Ends*/ 
                                                         FROM Billing_Plan_Line_Item__c 
                                                         WHERE Payment_Plan__c =:mapbookingToBillingPlan.keyset()]){
                         if(mapIdToBookingDate.get(mapbookingToBillingPlan.get(bpli.Payment_plan__c)) != null ){
                         if(bpli.Due_After_Days__c != null){
                         bpli.Payment_Date__c = mapIdToBookingDate.get(mapbookingToBillingPlan.get(bpli.Payment_plan__c)).addDays(Integer.valueof(bpli.Due_After_Days__c)-1);
                         }
                         system.debug('@@bpli.Payment_Plan_Line_Item_Name__c-->'+bpli.Payment_Plan_Line_Item_Name__c);
                         if(bpli.Payment_Plan_Line_Item_Name__c.contains('To be paid on or before <') ){
                            //v1.1 Starts added update for < Date > and <Date> both, earlier <Date> is missed
                            //bpli.Payment_Plan_Line_Item_Name__c= bpli.Payment_Plan_Line_Item_Name__c.replace('< Date >',String.valueOf(bpli.Payment_Date__c));
                            
                            bpli.Payment_Plan_Line_Item_Name__c = (bpli.Payment_Plan_Line_Item_Name__c.contains('< Date >')) ? bpli.Payment_Plan_Line_Item_Name__c.replace('< Date >',String.valueOf(bpli.Payment_Date__c.format())) : bpli.Payment_Plan_Line_Item_Name__c.replace('<Date>',String.valueOf(bpli.Payment_Date__c.format()));
                            //v1.1 Ends
                         }
                         
                         //v1.1 Starts
                         system.debug('@@bpli.Description__c before-->'+bpli.Description__c);
                         if(!String.isBlank(bpli.Description__c) && bpli.Description__c.contains('To be paid on or before <') ){
                            /*if(bpli.Description__c.contains('To be paid on or before <') ){
                                bpli.Description__c= bpli.Description__c.replace('< Date >',String.valueOf(bpli.Payment_Date__c));
                            }*/
                            
                            
                            bpli.Description__c = (bpli.Description__c.contains('< Date >')) ? bpli.Description__c.replace('< Date >',String.valueOf(bpli.Payment_Date__c.format())) : bpli.Description__c.replace('<Date>',String.valueOf(bpli.Payment_Date__c.format()));
                         }
                         system.debug('@@bpli.Description__c after-->'+bpli.Description__c);
                         //v1.1 Ends
                         
                         listbpli.add(bpli);  
                    }
                    }
                }
                system.debug('@@listbpli'+listbpli);
                if(listbpli .size()>0 && !listbpli.isEmpty()){
                system.debug('@@updated call');
                    update listbpli;
                }
           /* }
             catch(Exception ex){
            system.debug('error in updateing Payment date'+ex);
        }*/
        
    }
    
    public static void updateSalesUserQuota() {
        List<Booking__c> newBookingLst = (List<Booking__c>) Trigger.new;
        system.debug('newBookingLst----->'+newBookingLst);
        Map<Id, Booking__c> oldBookingMap;
        if(Trigger.isUpdate) {
            system.debug('In Trigger.isupdate');
            oldBookingMap = (Map<Id, Booking__c>) Trigger.oldMap;
            system.debug('oldBookingMap----->'+oldBookingMap);
        }
        Set<String> setUniqueId;
        Map<String, Booking__c> mapBookingUnique = new Map<String, Booking__c>();
        List<User_Quota__c> lstUserQuotaToUpdate = new List<User_Quota__c>();
        for(Booking__c booking : newBookingLst) {
            if((booking.Status__c == 'Booked' || booking.Status__c == 'Cancelled')) {
                //setQueryFilterString = 'WHERE User__c = \'' + booking.Sales_Rep__c + '\' AND Project__c = \'' + booking.Project__c + '\' AND Year__c = \'' + booking.Booking_Date__c.year() + '\' AND Month__c = \'' + booking.Booking_Date__c.month() + '\'';
                Datetime dtBookingDate = DateTime.newInstance(booking.Booking_Date__c, Time.newInstance(0, 0, 0, 1));
                mapBookingUnique.put(booking.Project__c + '' + dtBookingDate.format('MMMM') + '' + booking.Booking_Date__c.year() + '' + booking.Sales_Rep__c, booking);
                system.debug('mapBookingUnique--->'+mapBookingUnique);
            }
        }
        
        for(User_Quota__c userQuota : [SELECT Id, Achievement__c, Unique_Id__c FROM User_Quota__c WHERE Unique_Id__c = :mapBookingUnique.keySet()]) {
            system.debug('userQuota---->'+userQuota);
            if(mapBookingUnique.containsKey(userQuota.Unique_Id__c)) {
                if(mapBookingUnique.get(userQuota.Unique_Id__c).Status__c == 'Booked') {
                    system.debug('mapBookingUnique.get(userQuota.Unique_Id__c).Total_Sales_Cost__c'+mapBookingUnique.get(userQuota.Unique_Id__c).Total_Sales_Cost__c);
                    userQuota.Achievement__c += mapBookingUnique.get(userQuota.Unique_Id__c).Total_Sales_Cost__c;
                } else if(mapBookingUnique.get(userQuota.Unique_Id__c).Status__c == 'Cancelled') {
                    userQuota.Achievement__c -= mapBookingUnique.get(userQuota.Unique_Id__c).Total_Sales_Cost__c;
                }
                lstUserQuotaToUpdate.add(userQuota);
                system.debug('lstUserQuotaToUpdate----->'+lstUserQuotaToUpdate);
            }
        }
        if(lstUserQuotaToUpdate != null && lstUserQuotaToUpdate.size() > 0) {
            Database.update(lstUserQuotaToUpdate);
        }
    }
}
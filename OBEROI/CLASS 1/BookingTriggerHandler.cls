/**
* @Author:     Ravi Kumar K 
* @Company:     IBM
* @Date:        12/03/2019
* @Description: Handler Class for Trigger on Booking Object
*
* History
* <Date>       <Authors Name>      <Brief Description of Change>
12/03/2019    Ravi Kumar K     Added an method setParkingDetails
* -------------------------------------------------------------
*/

public without sharing class BookingTriggerHandler{
    
    /**
* @Author: Ravi Kumar K
* @Company: IBM
* @date: 12/03/2019
* @description: Decremating the Parking details in Tower Object based on Booking Status Booked
* @param: input : Set of Bookings which has Status Booked
* @return: Map of Success and Failure Tower Id's
*/
    
    public static Map<String,List<Id>> setParkingDetailsForBooked(Set<Id> projectIdSetBooked){
        
        List<Project__c> updateProjectList = new List<Project__c>();
        system.debug('projectIdSetBooked--->'+projectIdSetBooked);
        if(projectIdSetBooked.size()>0){
            Map<Object,AggregateResult> aggregateResultMapBooked = setParkingDetailsUtils(projectIdSetBooked);
            System.debug('aggregateResultMapBooked__'+aggregateResultMapBooked);
            system.debug('projectIdSetBooked---->'+projectIdSetBooked);
            for(Project__c singleProject:[SELECT X_of_Single_Parking__c,X_of_Single_Parking_Remaining__c,X_of_Tandem_Parking_Remaining__c,X_of_Triple_Parking_Remaining__c,X_of_Tandem_Parking__c,X_of_Triple_Parking__c FROM Project__c WHERE Id=:projectIdSetBooked FOR UPDATE]){
                system.debug('singleProject---->'+singleProject);
                if((Decimal)aggregateResultMapBooked.get(singleProject.Id).get('singleParking')!=null){
                    if(singleProject.X_of_Single_Parking__c - (Decimal)aggregateResultMapBooked.get(singleProject.Id).get('singleParking')>=0){
                        System.debug('1__'+singleProject.X_of_Single_Parking__c);
                        singleProject.X_of_Single_Parking_Remaining__c = singleProject.X_of_Single_Parking__c - (Decimal)aggregateResultMapBooked.get(singleProject.Id).get('singleParking');  
                    }   
                }
                if((Decimal)aggregateResultMapBooked.get(singleProject.Id).get('tandemParking')!=null){
                    System.debug('2__'+singleProject.X_of_Tandem_Parking__c);
                    singleProject.X_of_Tandem_Parking_Remaining__c = singleProject.X_of_Tandem_Parking__c - (Decimal)aggregateResultMapBooked.get(singleProject.Id).get('tandemParking');
                }
                if((Decimal)aggregateResultMapBooked.get(singleProject.Id).get('tripleParking')!=null){
                    System.debug('3__'+singleProject.X_of_Triple_Parking__c);
                    singleProject.X_of_Triple_Parking_Remaining__c = singleProject.X_of_Triple_Parking__c - (Decimal)aggregateResultMapBooked.get(singleProject.Id).get('tripleParking');
                }
                System.debug('singleTower__'+singleProject);
                updateProjectList.add(singleProject);
            }
        }
        if(updateProjectList.size()>0){
            List<Database.SaveResult> updateResults = Database.update(updateProjectList, false);
            Map<String,List<Id>> resultMap = new Map<String,List<Id>>();
            List<Id> successIds = new List<Id>();
            List<Id> failureIds = new List<Id>();
            for (Database.SaveResult result : updateResults){
                if (result.isSuccess()){
                    successIds.add(result.getId());
                }else{
                    failureIds.add(result.getId());
                }
            }
            if(successIds.size()>0){
                resultMap.put('SUCCESS',successIds);
            }if(failureIds.size()>0){
                resultMap.put('FAILURE',failureIds);
            }
            return resultMap ;
        }
        return null ;
    }
    
    /**
* @Author: Ravi Kumar K
* @Company: IBM
* @date: 12/03/2019
* @description: incremting the Parking details in Tower Object based on Cancellation of Booking
* @param: input : Set of Bookings which has Status Cancelled 
* @return: Map of Success and Failure Tower Id's
*/
    
    public static Map<String,List<Id>> setParkingDetailsForcancelled(Set<Id> projectIdSetCancelled){
        
        List<Project__c> updateProjectList = new List<Project__c>();
        if(projectIdSetCancelled.size()>0){
            Map<Object,AggregateResult> aggregateResultMapCancelled = setParkingDetailsUtils(projectIdSetCancelled);
            for(Project__c singleProject:[SELECT X_of_Single_Parking__c,X_of_Single_Parking_Remaining__c,X_of_Tandem_Parking_Remaining__c,X_of_Triple_Parking_Remaining__c,X_of_Tandem_Parking__c,X_of_Triple_Parking__c FROM Project__c WHERE Id=:ProjectIdSetCancelled FOR UPDATE]){
                if((Decimal)aggregateResultMapCancelled.get(singleProject.Id).get('singleParking')!=null){
                    singleProject.X_of_Single_Parking_Remaining__c = singleProject.X_of_Single_Parking_Remaining__c + (Decimal)aggregateResultMapCancelled.get(singleProject.Id).get('singleParking');
                }
                if((Decimal)aggregateResultMapCancelled.get(singleProject.Id).get('tandemParking')!=null){
                    singleProject.X_of_Tandem_Parking_Remaining__c = singleProject.X_of_Tandem_Parking_Remaining__c + (Decimal)aggregateResultMapCancelled.get(singleProject.Id).get('tandemParking');
                }
                if((Decimal)aggregateResultMapCancelled.get(singleProject.Id).get('tripleParking')!=null){
                    singleProject.X_of_Triple_Parking_Remaining__c = singleProject.X_of_Triple_Parking_Remaining__c + (Decimal)aggregateResultMapCancelled.get(singleProject.Id).get('tripleParking');
                }
                System.debug('singleProject__'+singleProject);
                updateProjectList.add(singleProject);
            }
        }
        if(updateProjectList.size()>0){
            List<Database.SaveResult> updateResults = Database.update(updateProjectList, false);
            Map<String,List<Id>> resultMap = new Map<String,List<Id>>();
            List<Id> successIds = new List<Id>();
            List<Id> failureIds = new List<Id>();
            for (Database.SaveResult result : updateResults){
                if (result.isSuccess()){
                    successIds.add(result.getId());
                }else{
                    failureIds.add(result.getId());
                }
            }
            if(successIds.size()>0){
                resultMap.put('SUCCESS',successIds);
            }if(failureIds.size()>0){
                resultMap.put('FAILURE',failureIds);
            }
            return resultMap ;
        }
        return null ;
    }
    
    /**
* @Author: Ravi Kumar K
* @Company: IBM
* @date: 12/03/2019
* @description: Utils class for setParkingDetails
* @param: input : List of Bookings Either Cancelled and Booked bookings
* @return: Map<Object,AggregateResult>
*/
    public static Map<Object,AggregateResult> setParkingDetailsUtils(Set<Id> projectIds){
        system.debug('projectIds--->'+projectIds);
        AggregateResult[] groupedResultsBooked = [SELECT SUM(X_of_Single_Parking__c) singleParking,SUM(X_of_Tandem_Parking__c) tandemParking,
                                                  SUM(X_of_Triple_Parking__c) tripleParking,Project__c
                                                  FROM Booking__c WHERE Project__c=:projectIds GROUP BY Project__c];
        system.debug('groupedResultsBooked------->'+groupedResultsBooked);
        Map<Object,AggregateResult> aggregateResultMap = new Map<Object,AggregateResult>();
        if(groupedResultsBooked.size()>0){
            for(AggregateResult singleResult:groupedResultsBooked){
                aggregateResultMap.put(singleResult.get('Project__c'),singleResult);
            }  
        }
        System.debug('aggregateResultMap__'+aggregateResultMap);
        return aggregateResultMap;
    }
    
    public static void beforeInsert(list<Booking__c> newBookinglist){
        
        //auto pull the discount from Billing Plan
        //auto pull the pricing 
        //auto pull default parking here
        
    }
    
    
    public static void afterInsert(map<Id,Booking__c> newBookingMap){
        
        //Decrement parking stock, display error if not available
        set<Id> propertyIdSet = new set<Id>();
        map <Id, Id> propertyVsTowerMap = new map<Id, Id>();
        
        //Tower id is populated by process builder which is not available when trigger is fired, hence use Property to locate Tower
        for(Id bookingRecId : newBookingMap.keySet()){
            propertyIdSet.add(newBookingMap.get(bookingRecId).Property__c);
        }
        
        for(Property__c property : [select Id, Tower__c
                                    from Property__c
                                    where Id IN : propertyIdSet]){
                                        
                                        propertyVsTowerMap.put(property.Id,property.Tower__c);
                                        
                                    }
        
        map <Id,Tower__c> towerMap = new map<Id, Tower__c>([select id, X_of_Triple_Parking__c, X_of_Tandem_Parking__c,X_of_Single_Parking__c 
                                                            from Tower__c
                                                            where id IN : propertyVsTowerMap.values()]);
        
        
        Booking__c bookingRec;
        Id towerId;
        for(Id bookingRecId : newBookingMap.keySet()){
            bookingRec = newBookingMap.get(bookingRecId);
            towerId = propertyVsTowerMap.get(bookingRec.Property__c);
            if(bookingRec.X_of_Single_Parking__c != null && towerMap.get(towerId).X_of_Single_Parking__c != null){
                if(towerMap.get(towerId ).X_of_Single_Parking__c - bookingRec.X_of_Single_Parking__c >= 0){
                    towerMap.get(towerId ).X_of_Single_Parking__c -= bookingRec.X_of_Single_Parking__c;
                }
                else{
                    bookingRec.X_of_Single_Parking__c.addError(Label.Requested_of_parking_unavailable);
                }
            }
            
            if(bookingRec.X_of_Tandem_Parking__c != null && towerMap.get(towerId ).X_of_Tandem_Parking__c != null){
                if(towerMap.get(towerId ).X_of_Tandem_Parking__c - bookingRec.X_of_Tandem_Parking__c >= 0){
                    towerMap.get(towerId ).X_of_Tandem_Parking__c -= bookingRec.X_of_Tandem_Parking__c ;
                }
                else{
                    bookingRec.X_of_Tandem_Parking__c.addError(Label.Requested_of_parking_unavailable);
                }
            }
            
            if(bookingRec.X_of_Triple_Parking__c != null && towerMap.get(towerId ).X_of_Triple_Parking__c != null){
                if(towerMap.get(towerId).X_of_Triple_Parking__c - bookingRec.X_of_Triple_Parking__c >= 0){
                    towerMap.get(towerId).X_of_Triple_Parking__c -= bookingRec.X_of_Triple_Parking__c;
                }
                else{
                    bookingRec.X_of_Triple_Parking__c.addError(Label.Requested_of_parking_unavailable);
                }
            }
            
        }
        if(!towerMap.isEmpty())
            database.update(towerMap.values());
        
    }
    
    public static void afterUpdate(map<Id, Booking__c> oldBookingMap, map<Id,Booking__c> newBookingMap){
        
        //decrement parking from inventory when # of parking number changed, check availability, if not available display error
        
        set<Id> bookingIdSet = new set<Id>();
        set <Id> towerIdSet = new set<Id>();
        Booking__c bookingNew, bookingOld;
        for(Id bookingId: newBookingMap.keySet()){
            bookingNew = newBookingMap.get(bookingId);
            bookingOld = oldBookingMap.get(bookingId);
            if(bookingNew.Status__c.equalsIgnoreCase('Booked') 
               && ( bookingNew.Status__c != bookingOld.Status__c
                   || bookingNew.X_of_Single_Parking__c != bookingOld .X_of_Single_Parking__c 
                   || bookingNew.X_of_Tandem_Parking__c != bookingOld .X_of_Tandem_Parking__c 
                   || bookingNew.X_of_Triple_Parking__c != bookingOld .X_of_Triple_Parking__c)){
                       bookingIdSet.add(bookingNew.Id);
                       towerIdSet.add(bookingNew.Tower__c);
                   }
        }
        
        map <Id,Tower__c> towerMap = new map<Id, Tower__c>([select id, X_of_Triple_Parking__c, X_of_Tandem_Parking__c,X_of_Single_Parking__c 
                                                            from Tower__c
                                                            where id IN : towerIdSet]);
        
        decimal delta, towerQty;
        
        for(Id bookingId : bookingIdSet){
            bookingNew = newBookingMap.get(bookingId);
            bookingOld = oldBookingMap.get(bookingId);
            delta = 0;
            if(bookingNew.X_of_Single_Parking__c != oldBookingMap.get(bookingNew.Id).X_of_Single_Parking__c){
                delta = (bookingNew.X_of_Single_Parking__c == null ? 0 : bookingNew.X_of_Single_Parking__c)
                    - (oldBookingMap.get(bookingNew.Id).X_of_Single_Parking__c == null ? 0 : oldBookingMap.get(bookingNew.Id).X_of_Single_Parking__c);
                towerQty = towerMap.get(bookingNew.Tower__c).X_of_Single_Parking__c == null ? 0 : towerMap.get(bookingNew.Tower__c).X_of_Single_Parking__c;
                if(towerQty - delta < 0){
                    bookingNew.X_of_Single_Parking__c.addError(Label.Requested_of_parking_unavailable);
                }
                else  {
                    towerMap.get(bookingNew.Tower__c).X_of_Single_Parking__c = towerQty - delta;
                }
            }
            delta = 0;
            if(bookingNew.X_of_Tandem_Parking__c!= oldBookingMap.get(bookingNew.Id).X_of_Tandem_Parking__c){
                delta = (bookingNew.X_of_Tandem_Parking__c== null ? 0 : bookingNew.X_of_Tandem_Parking__c)
                    - (oldBookingMap.get(bookingNew.Id).X_of_Tandem_Parking__c== null ? 0 : oldBookingMap.get(bookingNew.Id).X_of_Tandem_Parking__c);
                towerQty = towerMap.get(bookingNew.Tower__c).X_of_Tandem_Parking__c== null ? 0 : towerMap.get(bookingNew.Tower__c).X_of_Tandem_Parking__c;
                if(towerQty - delta < 0){
                    bookingNew.X_of_Tandem_Parking__c.addError(Label.Requested_of_parking_unavailable);
                }
                else  {
                    towerMap.get(bookingNew.Tower__c).X_of_Tandem_Parking__c= towerQty - delta;
                }
            }
            delta = 0;
            if(bookingNew.X_of_Triple_Parking__c!= oldBookingMap.get(bookingNew.Id).X_of_Triple_Parking__c){
                delta = (bookingNew.X_of_Triple_Parking__c== null ? 0 : bookingNew.X_of_Triple_Parking__c)
                    - (oldBookingMap.get(bookingNew.Id).X_of_Triple_Parking__c== null ? 0 : oldBookingMap.get(bookingNew.Id).X_of_Triple_Parking__c);
                towerQty = towerMap.get(bookingNew.Tower__c).X_of_Triple_Parking__c== null ? 0 : towerMap.get(bookingNew.Tower__c).X_of_Triple_Parking__c;
                if(towerQty - delta < 0){
                    bookingNew.X_of_Triple_Parking__c.addError(Label.Requested_of_parking_unavailable);
                }
                else  {
                    towerMap.get(bookingNew.Tower__c).X_of_Triple_Parking__c = towerQty - delta;
                }
            }
            
            //Cancelled to Booked
            if(bookingNew.Status__c != bookingOld.Status__c){
                if(bookingNew.X_of_Single_Parking__c != null && towerMap.get(bookingNew.Tower__c).X_of_Single_Parking__c != null){
                    if(towerMap.get(bookingNew.Tower__c).X_of_Single_Parking__c - bookingNew.X_of_Single_Parking__c >= 0){
                        towerMap.get(bookingNew.Tower__c).X_of_Single_Parking__c -= bookingNew.X_of_Single_Parking__c;
                    }
                    else{
                        bookingNew.X_of_Single_Parking__c.addError(Label.Requested_of_parking_unavailable);
                    }
                }
                
                if(bookingNew.X_of_Tandem_Parking__c != null && towerMap.get(bookingNew.Tower__c).X_of_Tandem_Parking__c != null){
                    if(towerMap.get(bookingNew.Tower__c).X_of_Tandem_Parking__c - bookingNew.X_of_Tandem_Parking__c >= 0){
                        towerMap.get(bookingNew.Tower__c).X_of_Tandem_Parking__c -= bookingNew.X_of_Tandem_Parking__c;
                    }
                    else{
                        bookingNew.X_of_Tandem_Parking__c.addError(Label.Requested_of_parking_unavailable);
                    }
                }
                
                if(bookingNew.X_of_Triple_Parking__c != null && towerMap.get(bookingNew.Tower__c).X_of_Triple_Parking__c != null){
                    if(towerMap.get(bookingNew.Tower__c).X_of_Triple_Parking__c - bookingNew.X_of_Triple_Parking__c >= 0){
                        towerMap.get(bookingNew.Tower__c).X_of_Triple_Parking__c -= bookingNew.X_of_Triple_Parking__c;
                    }
                    else{
                        bookingNew.X_of_Triple_Parking__c.addError(Label.Requested_of_parking_unavailable);
                    }
                }         
            }
        }
        
        if(!towerMap.isEmpty())
            database.update(towerMap.values());
        
        
    }
    
    
    //To be tested and optimized - check with Aditya if this is required
   // public static void beforeBooking( list<Booking__c> newBookinglist){
        /*Set<String> stProject = new Set<String>();
Map<String,String> maptarget = new Map<String,String>();
for(Booking__c lbook : newBookinglist){
stProject.add(lbook.Project__c);
}
for(User_Target_Allocation__c ut : [select Project_Target_Allocation__r.Project__c,id,name,PMonth__c,Year__c,Sales_User__c from User_Target_Allocation__c where Project_Target_Allocation__r.Project__c IN : stProject]){
maptarget.put(ut.Project_Target_Allocation__r.Project__c+ut.PMonth__c+ut.Year__c+ut.Sales_User__c,ut.Sales_User__c);
}
System.debug('maptargetmaptarget'+maptarget);
for(Booking__c ut : newBookinglist){
if(maptarget != null && maptarget.size() > 0 && !maptarget.ContainsKey(ut.Project__c+ut.Month__c+ut.Year__c+ut.Sales_Rep__c)){
//ut.addError('User allocation not persist for this Sales Rep');
}
}*/
  //  }
    
    //Ravi Kumar K
    /*
    public static void setPricingDetails(List<Booking__c> bookingList,map<id,Booking__c> oldBookingMap,String methodName){
        
        Set<Id> bookingIdSet = new Set<Id>();
        
        For(Booking__c sinlgleBooking:bookingList){
            bookingIdSet.add(sinlgleBooking.Id);
        }
        
        List<Booking__c> queriedBookingList = [SELECT Billing_Plan__c,Billing_Plan__r.Basic_Cost_After_Discount_Formula__c,Billing_Plan__r.Basic_Cost_Formula__c,
                                               Billing_Plan__r.Floor_Rise_Cost_After_Discount_Formula__c,Billing_Plan__r.Floor_Rise_Cost_Formula__c,
                                               Billing_Plan__r.PLC_Cost_After_Discount_Formula__c,Billing_Plan__r.PLC_Cost_Formula__c FROM Booking__c WHERE Id=:bookingIdSet];
        List<Booking__c> updateBookingList = new List<Booking__c>();
        if(queriedBookingList.size()>0){
            For(Booking__c sinlgleBooking:queriedBookingList){
                if(methodName=='Update' && sinlgleBooking.Billing_Plan__c!=oldBookingMap.get(sinlgleBooking.id).Billing_Plan__c){
                    setPricingDetailsUtil(sinlgleBooking); 
                }
                if(methodName=='Insert'){
                    setPricingDetailsUtil(sinlgleBooking);
                }
            }  
        }
        
    }
    
    public static void setPricingDetailsUtil(Booking__c sinlgleBooking){
        
        List<Booking__c> updateBookingList = new List<Booking__c>();
        if(sinlgleBooking.Billing_Plan__c!=null){
            if(sinlgleBooking.Billing_Plan__r.Basic_Cost_After_Discount_Formula__c!=null)
            {
                sinlgleBooking.Basic_Cost_Formula__c = sinlgleBooking.Billing_Plan__r.Basic_Cost_After_Discount_Formula__c;
                if(!updateBookingList.contains(sinlgleBooking))
                    updateBookingList.add(sinlgleBooking);
            }else if(sinlgleBooking.Billing_Plan__r.Basic_Cost_Formula__c!=null){
                sinlgleBooking.Basic_Cost_Formula__c = sinlgleBooking.Billing_Plan__r.Basic_Cost_Formula__c;
                if(!updateBookingList.contains(sinlgleBooking))
                    updateBookingList.add(sinlgleBooking);
            }
            if(sinlgleBooking.Billing_Plan__r.Floor_Rise_Cost_After_Discount_Formula__c!=null)
            {
                sinlgleBooking.Floor_Rise_Cost_Formula__c = sinlgleBooking.Billing_Plan__r.Floor_Rise_Cost_After_Discount_Formula__c;
                if(!updateBookingList.contains(sinlgleBooking))
                    updateBookingList.add(sinlgleBooking);
            }else if(sinlgleBooking.Billing_Plan__r.Floor_Rise_Cost_Formula__c!=null){
                sinlgleBooking.Floor_Rise_Cost_Formula__c = sinlgleBooking.Billing_Plan__r.Floor_Rise_Cost_Formula__c;
                if(!updateBookingList.contains(sinlgleBooking))
                    updateBookingList.add(sinlgleBooking);
            }
            if(sinlgleBooking.Billing_Plan__r.PLC_Cost_After_Discount_Formula__c!=null)
            {
                sinlgleBooking.PLC_Cost_Formula__c = sinlgleBooking.Billing_Plan__r.PLC_Cost_After_Discount_Formula__c;
                if(!updateBookingList.contains(sinlgleBooking))
                    updateBookingList.add(sinlgleBooking);
            }else if(sinlgleBooking.Billing_Plan__r.PLC_Cost_Formula__c!=null){
                sinlgleBooking.PLC_Cost_Formula__c = sinlgleBooking.Billing_Plan__r.PLC_Cost_Formula__c;
                if(!updateBookingList.contains(sinlgleBooking))
                    updateBookingList.add(sinlgleBooking);
            }
            
        }
        if(sinlgleBooking.Billing_Plan__c==null){
            sinlgleBooking.Basic_Cost_Formula__c = null;
            sinlgleBooking.Floor_Rise_Cost_Formula__c = null;
            sinlgleBooking.PLC_Cost_Formula__c = null;
            updateBookingList.add(sinlgleBooking);
        }
        
        if(updateBookingList.size()>0){
            update updateBookingList;
        }
        
    }
    */
    @future
    public static void setPropoertyRemoveBlockedBy(id bookingid){
        List<Property__c> pr= new List<Property__c>();
        //property[] p = [SELECT Blocked_By__c,Block_Comments__c,Booking__c,Description__c,Id,Name FROM Property__c WHERE Id = :bookingid];
        booking__c[] b =[select id from booking__c where id=:bookingid];
        for(booking__c book: b){
            //id propertyid =[select id from property__c where Booking__c=book.id limit 1].id;
            property__c prop = new Property__c(Booking__c=book.id);
            prop.Block_Comments__c='';
            prop.Blocked_By__c=userinfo.getuserid();
            pr.add(prop);
        }
        update pr;
    }
    
    
    
    
    
    //Added By Vaidehi
    public static void insertRMDetails(list<Booking__c> bookinglst){
      set<id> propid = new set<id>();           
            if(bookinglst != null && bookinglst.size() > 0){
                for(Booking__c booking :bookinglst){
                    propid.add(booking.Property__c);
                }
            
            map<id, Property__c> propMap;
            if(propid != null && propid.size()>0)
               propMap  = new map<id, Property__c>([Select id, Tower__c, Original_RM_Name__c,CRM_Lead__c,Project_Name__r.Site_Head__c,Project_Name__r.Site_Support__c,
                Project_Name__r.Central_Support__c,Project_Name__r.Sales_Head__c,Project_Name__r.AR_Finance__c,Project_Name__r.CFO__c,Project_Name__r.MD__c, Support_Head__c, AR_Head__c from Property__c where id in: propid]);
            
            
                for(Booking__c booking :bookinglst){
                    if(propMap.containskey(booking.Property__c)){
                      //  booking.Old_Property__c = booking.PropStrength__Property__c;
                       // booking.Tower__c = propMap.get(booking.PropStrength__Property__c).PropStrength__Tower__c;
                        booking.RM_User__c = propMap.get(booking.Property__c).Original_RM_Name__c;
                        booking.CRM_Lead__c = propMap.get(booking.Property__c).CRM_Lead__c;
                        booking.Site_Head__c = propMap.get(booking.Property__c).Project_Name__r.Site_Head__c;
                        booking.Site_Support__c = propMap.get(booking.Property__c).Project_Name__r.Site_Support__c;
                        booking.Central_Support__c = propMap.get(booking.Property__c).Project_Name__r.Central_Support__c;
                        booking.Sales_Head__c = propMap.get(booking.Property__c).Project_Name__r.Sales_Head__c;
                        booking.AR_Finance__c = propMap.get(booking.Property__c).Project_Name__r.AR_Finance__c;
                        booking.CFO__c = propMap.get(booking.Property__c).Project_Name__r.CFO__c;
                        booking.MD__c = propMap.get(booking.Property__c).Project_Name__r.MD__c;
                      //  booking.AR_Team__c = propMap.get(booking.Property__c).AR_Head__c;
                       // booking.Support_Head__c = propMap.get(booking.Property__c).Support_Head__c;
                    }
                }
            }  
   
    
    }
}
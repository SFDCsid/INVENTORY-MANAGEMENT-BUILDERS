public class CarParkSlotNoHandler {
    public static void myMethodOne(list<Car_Park_Slot_No__c>newcarparklist){
        set<Id>bookingId = new set<Id>();
        ///set<Id>quotationId = new set<Id>();
        
        for(Car_Park_Slot_No__c cps : newcarparklist){
            bookingId.add(cps.Booking__c);
        }
        
        /*Map<Id, Booking__c>bookigById = new Map<Id, Booking__c>(
        [Select Id, Quotation__r.Earmarked_Car_Parking_Type_1__c,Quotation__r.Earmarked_Car_Parking_Count_1__c From Booking__c WHERE Id =:bookingId]);
        system.debug('the result is--'+bookigById);
        
        for(Car_Park_Slot_No__c cps : newcarparklist){
            system.debug('result for cps--'+cps);
            if(cps.Type__c == bookigById.get(cps.Booking__c).Quotation__r.Earmarked_Car_Parking_Type_1__c){
                 system.debug('inside if--'+bookigById.get(cps.Booking__c).Quotation__r.Earmarked_Car_Parking_Type_1__c); 
                list<Car_Park_Slot_No__c> cps1 = [Select Id,Name,Type__c,Booking__c from Car_Park_Slot_No__c Where Booking__c=:bookingId AND Type__c =:cps.Type__c];
                if(cps1.size()>0){
                    if(cps1.size() == bookigById.get(cps.Booking__c).Quotation__r.Earmarked_Car_Parking_Count_1__c){
                        cps.addError('Error');
                    }
                }
              }
            
           }*/
        List<Booking__c> Blist = [Select Id,Quotation__c From Booking__c WHERE Id =:bookingId];
        if(Blist.size()>0){
        
        List<Quotation__c> QList = [Select Id,name,Earmarked_Car_Parking_Type_1__c,Earmarked_Car_Parking_Type_2__c,Earmarked_Car_Parking_Type_3__c,Earmarked_Car_Parking_Type_4__c,Earmarked_Car_Parking_Type_5__c,
                                    Earmarked_Car_Parking_Count_1__c,Earmarked_Car_Parking_Count_2__c,Earmarked_Car_Parking_Count_3__c,Earmarked_Car_Parking_Count_4__c,Earmarked_Car_Parking_Count_5__c,
                                    Car_Park_Type_1__c,Car_Park_Type_2__c,Car_Park_Type_3__c,Car_Park_Type_4__c,Car_Park_Type_5__c,Car_Park_Count_1__c,Car_Park_Count_2__c,Car_Park_Count_3__c,Car_Park_Count_4__c,Car_Park_Count_5__c
                                     from Quotation__c where id =: Blist[0].Quotation__c];
        string parkingDetails = 'NA';
        map<string,Integer> parkingMap = new Map<string,Integer>();
        if(QList.size()>0){
        for(Integer j=1;j<=5;j++){
            string earmarkedName = (string) QList[0].get('Earmarked_Car_Parking_Type_' + j +'__c');
            decimal earmarkedCOunt = (decimal) QList[0].get('Earmarked_Car_Parking_Count_' + j +'__c');
            string additionalParkingName = (string) QList[0].get('Car_Park_Type_' + j +'__c');
            decimal additionalParkingCOunt = (decimal) QList[0].get('Car_Park_Count_' + j +'__c');
            if(string.isNotBlank(earmarkedName) && earmarkedCOunt != null){
                earmarkedName = earmarkedName.toLowerCase();
                earmarkedName = earmarkedName.substring(0,1).toUpperCase() + earmarkedName.substring(1,earmarkedName.length());
                if(parkingMap.containskey(earmarkedName)){
                    Integer cc = parkingMap.get(earmarkedName) + Integer.valueOf(earmarkedCOunt);
                    parkingMap.put(earmarkedName, cc);
                }else{
                    Integer cc = Integer.valueOf(earmarkedCOunt);
                    parkingMap.put(earmarkedName, cc);
                }
            }
            if(string.isNotBlank(additionalParkingName) && additionalParkingCOunt != null){
                additionalParkingName = additionalParkingName.toLowerCase();
                additionalParkingName = additionalParkingName.substring(0,1).toUpperCase() + additionalParkingName.substring(1,additionalParkingName.length());
                if(parkingMap.containskey(additionalParkingName)){
                    Integer cc = parkingMap.get(additionalParkingName) + Integer.valueOf(additionalParkingCOunt);
                    parkingMap.put(additionalParkingName, cc);
                }else{
                    Integer cc = Integer.valueOf(additionalParkingCOunt);
                    parkingMap.put(additionalParkingName, cc);
                }
            }
        }
       } 
        for(Car_Park_Slot_No__c cps : newcarparklist){
            system.debug('result for cps--'+cps);
            if(!parkingMap.containskey(cps.Type__c)){
                cps.addError('This type of car parking is not allocated for this booking.');
            }
            for(string st : parkingMap.keyset()){
                System.debug('St:::::::'+st);
                System.debug('cps.Type__c::::::::'+cps.Type__c);
                if(cps.Type__c == st){
                    system.debug('parkingMap::::::::'+parkingMap.get(st));
                    list<Car_Park_Slot_No__c> cps1 = [Select Id,Name,Type__c,Booking__c from Car_Park_Slot_No__c Where Booking__c=:bookingId AND Type__c =:cps.Type__c];
                    if(cps1.size()>0){
                        if(cps1.size() == parkingMap.get(st)){
                            cps.addError('You have already allocated slot no for this booking.');
                        }
                    }
                }
            }
        }
        
    }
  } 
    public static void updateslotno(list<Car_Park_Slot_No__c> newcarparklist){
        set<Id>bookingId = new set<Id>();
        ///set<Id>quotationId = new set<Id>();
        
        for(Car_Park_Slot_No__c cps : newcarparklist){
            bookingId.add(cps.Booking__c);
        }
        
        map<string,string> slotnomap = new Map<string,string>();
        list<Car_Park_Slot_No__c> cps1 = [Select Id,Name,Type__c,Booking__c,Booking__r.Quotation__c,Car_Park_Slot_No_1__c,Car_Park_Slot_No_2__c,Level__c from Car_Park_Slot_No__c Where Booking__c=:bookingId];
        List<Quotation__c> qList = [Select id,name,Car_Park_slot_No_Details__c from Quotation__c where id =: cps1[0].Booking__r.Quotation__c];
        String slotno;
        String level;
        if(qList.size()>0){
        for(Car_Park_Slot_No__c cpsn : cps1){
            //string level = (string) cpsn.get(Level__c');
            //String slotno = String.valueOf((string) cpsn.get(cpsn.Car_Park_Slot_No_1__c));
            //if(cpsn.Car_Park_Slot_No_2__c != null){
                //slotno = String.valueOf((string) cpsn.get(Car_Park_Slot_No_2__c));
            //}
            if(cpsn.Level__c != null && cpsn.Car_Park_Slot_No_1__c != null){
                level = cpsn.Level__c;
                if(string.isNotBlank(slotno) && slotnomap.containskey(cpsn.Level__c)){
                    System.debug('Inner if slot no:::'+ slotno);
                    System.debug('Inner if Level:::'+ level);
                    //level = cpsn.Level__c;
                    slotno = slotnomap.get(level)+','+String.valueOf(cpsn.Car_Park_Slot_No_1__c);
                    slotnomap.put(level,slotno);
                }else{
                    System.debug('Inner else slot no:::'+ slotno);
                    System.debug('Inner if Level:::'+ level);
                    //level = cpsn.Level__c;
                    slotno = String.valueOf(cpsn.Car_Park_Slot_No_1__c);
                    slotnomap.put(level,slotno);
                }
                if(cpsn.Car_Park_Slot_No_2__c != null){
                    slotno += ','+String.valueOf(cpsn.Car_Park_Slot_No_2__c);
                    slotnomap.put(level,slotno);
                }
                
            }
        }
        if(!slotnomap.isEmpty()){
                System.debug('slotnomap:::::::'+ slotnomap);
                string slotnoDetails = 'car parking number/'; 
                slotnoDetails += '\'s';
                for(string st : slotnomap.keyset()){
                    System.debug('slotnomap:::::::'+ slotnomap);
                    slotnoDetails += ' '+ slotnomap.get(st) + ' on '+ st +' Level and ';
                }
                //slotnoDetails = slotnoDetails.replaceAll('null','');
                slotnoDetails = slotnoDetails.removeEnd(' and ');
                slotnoDetails += '.';
                System.debug('parkingDetails:::::::'+ slotnoDetails);
                qList[0].Car_Park_slot_No_Details__c = slotnoDetails;
                update qList;
                //1 [One] car parking space/s (Configuration – Tandem) & 1 [One] car parking space/s (Configuration – Single)';
            }
    }
   } 

}
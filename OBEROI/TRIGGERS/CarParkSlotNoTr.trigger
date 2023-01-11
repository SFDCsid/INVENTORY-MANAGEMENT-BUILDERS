trigger CarParkSlotNoTr on Car_Park_Slot_No__c (after update, before update, before insert, after insert){
    if((trigger.isupdate) && trigger.isbefore){ //|| trigger.isinsert
        
        for(Car_Park_Slot_No__c cp : Trigger.New){
            if(cp.Booking__c!= trigger.oldmap.get(cp.id).Booking__c || cp.Type__c!= trigger.oldmap.get(cp.id).Type__c){
                CarParkSlotNoHandler.myMethodOne(trigger.new);
            }
        }
    }
    if((trigger.isupdate) && trigger.isAfter){ //|| trigger.isinsert
        CarParkSlotNoHandler.updateslotno(trigger.new);
    }
}
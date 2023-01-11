public class duplicatecarparkslotnohandler {
      public static void mymethod1(List<Car_Park_Slot_No__c>listcarpark){
        
        Set<Decimal> slotno1 = new Set<Decimal>();
        Set<String> level = new Set<String>();
        Set<String> project = new Set<String>();

        for(Car_Park_Slot_No__c cpsn : listcarpark){
            slotno1.add(cpsn.Car_Park_Slot_No_1__c);
            level.add(cpsn.Level__c);
            project.add(cpsn.Project__c);
          }
          
          List<Car_Park_Slot_No__c> duplicateCarparklist = [SELECT Id, Name,Car_Park_Slot_No_1__c,Level__c,Project__c
                                             FROM Car_Park_Slot_No__c 
                                             WHERE Car_Park_Slot_No_1__c =:slotno1 AND Level__c=:level AND Project__c=:project];
          system.debug('--the list contain--'+listcarpark);
          
          for(Car_Park_Slot_No__c carpark : listcarpark){
              if(duplicateCarparklist.size()!=0){
                carpark.addError('Error');
            }
          }
  }
}
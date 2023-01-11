Public class CarPark{
    
    
    @AuraEnabled(cacheable=true)
    public static Booking__c getBooking(string bId) {
        //Property__c property = QuotationManagmentServices.getPropertyDetails(uId);
        Booking__c booking = [select id,name,Quotation__c,Quotation__r.Name,Project__c,Project__r.Name,Tower__c,Tower__r.Tower_Name__c,Property__c,Booking_Special_Conditions__c,Project__r.ITC_BENEFIT__c from Booking__c where id=: bId];
        return booking;
    }
    @AuraEnabled(cacheable=true)
    public static Opportunity getOpportunity(string oppId) { //List<QuotationManagmentServices.SAPPricingWrapper> AVList,
        Opportunity op = QuotationManagmentServices.getOpportunityDetails(oppId);
        system.debug('op:: '+op);
        return op;
    }
    @AuraEnabled(cacheable=true)
    public static List<QuotationManagmentServices.CarParkWrapper> getCarParkingList(string pId) {
        system.debug('pId::'+pId);
        List<QuotationManagmentServices.CarParkWrapper> carparkList = new List<QuotationManagmentServices.CarParkWrapper>();
        Map<string,Decimal> parkingMap = QuotationManagmentServices.getAdditionalCarParks(pId);
        if(parkingMap != null && !parkingMap.isEmpty()){
            for(string cp: parkingMap.keySet()){
                /* QuotationManagmentServices.CarParkWrapper wc = new QuotationManagmentServices.CarParkWrapper();
wc.carParkName = cp;
wc.originalcount = Integer.valueof(parkingMap.get(cp));
wc.selectedCount = 0;
wc.parkingAmount = 0;*/
                carparkList.add(new QuotationManagmentServices.CarParkWrapper(cp,Integer.valueof(parkingMap.get(cp)),0,0));
            }
        }
        system.debug('carparkList:::'+carparkList);
        return carparkList;
    }
    @AuraEnabled
    public static void saveQuotation(string carparkList,string qId,string pId){ ///, string selectedcarparks
        List<string> carparkMapCount = (List<string>)JSON.deserialize(carparkList, List<string>.class);
        Map<string,List<Car_Parking__c>> addAvailableParkingMap = new Map<string,List<Car_Parking__c>>();
        List <Car_Parking__c>  ParkingListToUpdate = new List <Car_Parking__c>();
        Map<string,decimal> additionalParkingMap = new Map<string,decimal>();
        system.debug('carparkList::::::::::'+carparkList);
        system.debug('qId::::::'+qId);
        Quotation__c q = [select id,name,Car_Park_Type_1__c,Car_Park_Type_2__c,Car_Park_Type_3__c,Car_Park_Type_4__c,Car_Park_Type_5__c, 
                          Car_Park_Count_1__c,Car_Park_Count_2__c,Car_Park_Count_3__c,Car_Park_Count_4__c,Car_Park_Count_5__c
                          from Quotation__c where id=:qId];
        
        system.debug('carparkList:: '+carparkList);
        system.debug('carparkMapCount :: '+carparkMapCount);
        /******** Add Car parking details on Quotation record   ***********/
        List<FinalCarPArk> cpList = new List<FinalCarPArk>();
        if(carparkMapCount != null && !carparkMapCount.isEmpty()){
            for(Integer i=0;i<carparkMapCount.size();i=i+3){
                FinalCarPArk fp = new FinalCarPArk();
                fp.carparkNAme = carparkMapCount[i];
                fp.carparkCount = Decimal.valueOf(carparkMapCount[i+1]);
                //fp.carparkAmount = Decimal.valueOf(carparkMapCount[i+2]);
                cpList.add(fp); 
            }
        }
        system.debug('cpList :: '+cpList);
        Boolean AdditionalCarParkApplied = False;
        if(cpList != null && !cpList.isEmpty()){
            AdditionalCarParkApplied = True;
            for(Integer i=0;i<cpList.size();i++){
                if(cpList[i].carparkCount != null && cpList[i].carparkCount > 0){
                    Integer s = i+1;
                    if(q.get('Car_Park_Type_'+s+'__c') == Null){
                        q.put('Car_Park_Type_'+s+'__c',cpList[i].carparkNAme);
                        q.put('Car_Park_Count_'+s+'__c',cpList[i].carparkCount);
                    }else{
                        
                        q.put('Car_Park_Count_'+s+'__c',(Integer.valueOf(q.get('Car_Park_Count_'+s+'__c'))+cpList[i].carparkCount));
                    }
                    additionalParkingMap.put(cpList[i].carparkNAme, cpList[i].carparkCount);
                    //q.put('Car_Park_Charge_'+s+'__c',cpList[i].carparkAmount.setscale(0, RoundingMode.HALF_UP));
                }
            }
            update q;
        }
        List<Car_Parking__c> carParking_List = [select id,Status__c,Name,Type__c From Car_Parking__c where  Status__c =: 'Available' and Project__c =: pId and Additional_Earmarked__c = 'Additional'];
        if(carParking_List != null && !carParking_List.isEmpty()){
              for(Car_Parking__c cp : carParking_List){
                  if(addAvailableParkingMap.containsKey(cp.Type__c)){
                      List<Car_Parking__c> cc = addAvailableParkingMap.get(cp.Type__c);
                         cc.add(cp);
                         addAvailableParkingMap.put(cp.Type__c,cc);
                      }else{
                         List<Car_Parking__c> cc = new List<Car_Parking__c>();
                         cc.add(cp);
                         addAvailableParkingMap.put(cp.Type__c,cc);
                      }
               }
         }
         if(!additionalParkingMap.isEmpty()){
               system.debug('additionalParkingMap::::::::'+additionalParkingMap);
                for(string st : additionalParkingMap.keyset()){
                    system.debug('st::::::::'+st);
                    Integer s = Integer.valueOf(additionalParkingMap.get(st));
                    system.debug('s::::::::'+s);
                    for(Integer r=0; r<s; r++){
                        addAvailableParkingMap.get(st)[r].Status__c = 'Allotted'; 
                        ParkingListToUpdate.add(addAvailableParkingMap.get(st)[r]);
                    }
                }
            }
          if(ParkingListToUpdate.size() > 0){
                system.debug('ParkingListToUpdate::::::::'+ParkingListToUpdate);
                update ParkingListToUpdate;
            }        
              
    }
    
    public class FinalCarPArk{
        public string carparkNAme;
        public Decimal carparkCount;
        public Decimal carparkAmount;
        
        public FinalCarPArk(){
            
        }
    }
}
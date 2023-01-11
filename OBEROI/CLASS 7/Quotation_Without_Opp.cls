Public class Quotation_Without_Opp{
    @AuraEnabled(cacheable=true)
    public static Property__c getProperty(string uId) {
        Property__c property = QuotationManagmentServices.getPropertyDetails(uId);
        return property;
    }
    /*@AuraEnabled(cacheable=true)
    public static Opportunity getOpportunity(string oppId) { //List<QuotationManagmentServices.SAPPricingWrapper> AVList,
        Opportunity op = QuotationManagmentServices.getOpportunityDetails(oppId);
        system.debug('op:: '+op);
        return op;
    }*/
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
    @AuraEnabled(cacheable=true)
    public static Map<string, Decimal> getParkingCharges(string pId) {
        Map<string,Decimal> parkingCharges = QuotationManagmentServices.getParkingCharges(pId);
        system.debug('parkingCharges:: '+parkingCharges);
        return parkingCharges;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Discount__c> getDiscountList(string pId) {
        List<Discount__c> dList = new List<Discount__c>();
        dList = QuotationManagmentServices.getProjectLevelDiscounts(pId);
        return dList;
    }
    
    /* @AuraEnabled(cacheable=true)
public static List<string> getChargesName(string unitId, string propertyTypeId) {
List<string> chargesNameList = new List<string>();
chargesNameList = QuotationManagmentServices.getAllChargesName(unitId, propertyTypeId);
system.debug('chargesName::'+chargesNameList);
return chargesNameList;
}

@AuraEnabled(cacheable=true)
public static Map<string,decimal> getAVCharges(string unitId) {
map<string,decimal> allchargesMap = new Map<string,decimal>();
allchargesMap = QuotationManagmentServices.getAVChargesMap(unitId);
system.debug('allchargesMap ::'+allchargesMap);
return allchargesMap ;
}

@AuraEnabled(cacheable=true)
public static Map<string,decimal> getOtherCharges(string propertyTypeId) {
map<string,decimal> allchargesMap = new Map<string,decimal>();
allchargesMap = QuotationManagmentServices.getOtherChargesMap(propertyTypeId);
system.debug('allchargesMap ::'+allchargesMap);
return allchargesMap ;
} */
    
    @AuraEnabled(cacheable=true)
    public static List<QuotationManagmentServices.AdditionalChargesWrapper> getAdditionChargsList(string pId) {
        List<QuotationManagmentServices.AdditionalChargesWrapper> acList = new List<QuotationManagmentServices.AdditionalChargesWrapper>();
        acList = QuotationManagmentServices.getadditionalChargesWrapper(pId);
        return acList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<QuotationManagmentServices.SAPPricingWrapper> getSAPPricingList(string uId, boolean isSubventionPlan, decimal subventionRate) {
        List<QuotationManagmentServices.SAPPricingWrapper> SAPList = new List<QuotationManagmentServices.SAPPricingWrapper>();
        system.debug('isSubventionPlan::: '+isSubventionPlan);
        system.debug('subventionRate::: '+subventionRate);
        SAPList = QuotationManagmentServices.getSAPPricingWrapper(uId);
        if(!SAPList.isEmpty()){
            if(isSubventionPlan){
                Property__c property = QuotationManagmentServices.getPropertyDetails(uId);
                decimal netValue = 0;
                for(QuotationManagmentServices.SAPPricingWrapper sp : SAPList){
                    if(sp.chargeName == 'Basic'){
                        sp.valueD = sp.modifiedValueD = (subventionRate * property.Carpet_Area__c).setscale(0, RoundingMode.HALF_UP);
                        netValue += sp.modifiedValueD;
                        sp.rateD = sp.modifiedRateD = subventionRate; 
                        sp.rateSTR = sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                        sp.valueSTR = sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                        sp.isModified = true;
                        if(sp.modifiedValueD != sp.valueD){
                            sp.modifiedClass = 'mClass';
                        }else{
                            sp.modifiedClass = '';
                        } 
                    }else if(sp.chargeName == 'Floor Rise'){
                        netValue += sp.modifiedValueD;
                    }else if(sp.chargeName == 'PLC'){
                        netValue += sp.modifiedValueD;
                    }
                }
                QuotationManagmentServices.GSTWrapper gp = QuotationManagmentServices.getTaxValue(netValue, uId);
                for(QuotationManagmentServices.SAPPricingWrapper sp : SAPList){
                    if(sp.chargeName == 'Net Value'){
                        sp.valueD = sp.modifiedValueD = netValue;
                        sp.rateD = sp.modifiedRateD = sp.modifiedValueD; 
                        sp.rateSTR = sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                        sp.valueSTR = sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                        sp.isModified = true;
                        if(sp.modifiedValueD != sp.valueD)
                            sp.modifiedClass = 'mClass';
                        else
                            sp.modifiedClass = '';
                    }
                    if(sp.chargeName == 'Sale Value'){
                        sp.rateD = sp.modifiedRateD = netvalue + gp.totalGST;
                        sp.valueD = sp.modifiedValueD = netvalue + gp.totalGST;
                        sp.rateSTR = sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                        sp.valueSTR = sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                        sp.isModified = true;
                        if(sp.modifiedValueSTR != sp.valueSTR)
                            sp.modifiedClass = 'mClass';
                        else
                            sp.modifiedClass = '';
                    }else if(sp.chargeName == 'CGST'){
                        sp.rateD = sp.modifiedRateD = gp.CGST;
                        sp.valueD = sp.modifiedValueD = gp.CGST;
                        sp.rateSTR = sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                        sp.valueSTR = sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                        sp.isModified = true;
                        if(sp.modifiedValueSTR != sp.valueSTR)
                            sp.modifiedClass = 'mClass';
                        else
                            sp.modifiedClass = '';
                    }else if(sp.chargeName == 'SGST'){
                        sp.rateD = sp.modifiedRateD = gp.SGST;
                        sp.valueD = sp.modifiedValueD = gp.SGST;
                        sp.rateSTR = sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                        sp.valueSTR = sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                        sp.isModified = true;
                        if(sp.modifiedValueSTR != sp.valueSTR)
                            sp.modifiedClass = 'mClass';
                        else
                            sp.modifiedClass = '';
                    }else if(sp.chargeName == 'Tax Value'){
                        sp.rateD = sp.modifiedRateD = gp.totalGST;
                        sp.valueD = sp.modifiedValueD = gp.totalGST;
                        sp.rateSTR = sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                        sp.valueSTR = sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                        sp.isModified = true;
                        if(sp.modifiedValueSTR != sp.valueSTR)
                            sp.modifiedClass = 'mClass';
                        else
                            sp.modifiedClass = '';
                    }
                }
            }
        }
        return SAPList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Payment_Plan__C> getBillingPlanList(string tId) {
        List<Payment_Plan__C> ppList = new List<Payment_Plan__C>();
        ppList = QuotationManagmentServices.getPlanList(tId);
        system.debug('ppList::'+ppList);
        return ppList;
    }
    @AuraEnabled(cacheable=true)
    public static string getEarmarkedParkingDetails(string pRecord) { 
        system.debug('pRecord:: '+pRecord);
        Property__C property= (Property__C)JSON.deserialize(pRecord, Property__c.class);
        string carparkDetails = '';
        system.debug('property:: '+property);
        for(Integer i=1;i<=5;i++){
            string cType = (string)property.get('Car_Park_Type_' + i +'__c');
            Integer cCount = Integer.valueOf((Decimal)property.get('Car_Park_Count_' + i +'__c'));
            system.debug('cType:: '+cType);
            system.debug('cCount:: '+cCount);
            if(string.isNotBlank(cType)){
                
                if(string.isNotBlank(carparkDetails)){
                    carparkDetails = carparkDetails + ', ' + cType + ' - ' + cCount;
                }else{
                    carparkDetails = cType + ' - ' + cCount;    
                }    
            }
        }
        system.debug('carparkDetails:: '+carparkDetails);
        return carparkDetails;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<QuotationManagmentServices.SAPPricingWrapper> applyCarParking(string AVList, decimal carParkAmount, string uId, decimal discountedAmount,boolean isSubventionPlan, decimal subventionRate) { 
        List<QuotationManagmentServices.SAPPricingWrapper> listToSave = (List<QuotationManagmentServices.SAPPricingWrapper>)JSON.deserialize(AVList, List<QuotationManagmentServices.SAPPricingWrapper>.class);
        Property__c property = QuotationManagmentServices.getPropertyDetails(uId);
        system.debug('inside apply car park::'+ listToSave  + ':::carParkAmount:: '+ carParkAmount + '::: discountedAmount:::'+discountedAmount + ':::isSubventionPlan:: '+isSubventionPlan + ' ::: subventionRate:: '+subventionRate);
        if(carParkAmount != null){
            decimal netvalue = 0;
            Map<string,QuotationManagmentServices.SAPPricingWrapper> avChargesMap = new  Map<string,QuotationManagmentServices.SAPPricingWrapper>();
            for(QuotationManagmentServices.SAPPricingWrapper st : getSAPPricingList(uId, isSubventionPlan, subventionRate)){ //getSAPPricingList(uId, isSubventionPlan, subventionRate)
                avChargesMap.put(st.chargeName,st);
            }
            for(QuotationManagmentServices.SAPPricingWrapper sp : listToSave){
                if(sp.chargeName == 'Car Parking'){
                    sp.modifiedRateD = carParkAmount;
                    sp.modifiedValueD = carParkAmount;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(carParkAmount);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(carParkAmount);
                    sp.isModified = true;
                    if(sp.modifiedValueD != sp.valueD)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }
                /*if(sp.chargeName == 'Basic'){
sp.modifiedValueD = avChargesMap.get('Basic').modifiedValueD - discountedAmount;
netvalue += sp.modifiedValueD;
sp.modifiedRateD = (sp.modifiedValueD/property.Carpet_Area__c).setscale(2, RoundingMode.HALF_UP); 
sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
sp.isModified = true;
if(sp.modifiedValueD != sp.valueD){
sp.modifiedClass = 'mClass';
}else{
sp.modifiedClass = '';
}    
}else if(sp.chargeName == 'Floor Rise'){
sp.modifiedValueD = avChargesMap.get('Floor Rise').modifiedValueD - discountedAmount;
netvalue += sp.modifiedValueD;
sp.modifiedRateD = (sp.modifiedValueD/property.Carpet_Area__c).setscale(2, RoundingMode.HALF_UP);
sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
sp.isModified = true;
if(sp.modifiedValueD != sp.valueD){
sp.modifiedClass = 'mClass';
}else{
sp.modifiedClass = '';
}    
}else if(sp.chargeName == 'PLC'){
sp.modifiedValueD = avChargesMap.get('PLC').modifiedValueD - discountedAmount;
netvalue += sp.modifiedValueD;
sp.modifiedRateD = (sp.modifiedValueD/property.Carpet_Area__c).setscale(2, RoundingMode.HALF_UP); 
sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
sp.isModified = true;
if(sp.modifiedValueD != sp.valueD){
sp.modifiedClass = 'mClass';
}else{
sp.modifiedClass = '';
}    
}*/
            }
            //netvalue += carParkAmount;
            for(QuotationManagmentServices.SAPPricingWrapper sp : listToSave){
                if(sp.chargeName == 'Net Value'){
                    system.debug('Net Value:: '+netvalue);
                    sp.modifiedRateD = sp.modifiedValueD + carParkAmount; //netvalue;
                    sp.modifiedValueD = sp.modifiedValueD + carParkAmount; //netvalue;
                    netvalue = sp.modifiedValueD;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueD != sp.valueD)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }
            }
            
            system.debug('netvalue::'+netvalue);
            QuotationManagmentServices.GSTWrapper gp = QuotationManagmentServices.getTaxValue(netvalue, uId);
            system.debug('inside applycarparking gp::'+gp);
            for(QuotationManagmentServices.SAPPricingWrapper sp : listToSave){
                if(sp.chargeName == 'Sale Value'){
                    sp.modifiedRateD = netvalue + gp.totalGST;
                    sp.modifiedValueD = netvalue + gp.totalGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }else if(sp.chargeName == 'CGST'){
                    sp.modifiedRateD = gp.CGST;
                    sp.modifiedValueD = gp.CGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }else if(sp.chargeName == 'SGST'){
                    sp.modifiedRateD = gp.SGST;
                    sp.modifiedValueD = gp.SGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }else if(sp.chargeName == 'Tax Value'){
                    sp.modifiedRateD = gp.totalGST;
                    sp.modifiedValueD = gp.totalGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }
            }
        }
        system.debug('listToSave:: '+listToSave);
        return listToSave;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<QuotationManagmentServices.SAPPricingWrapper> applyDiscount(string AVList, string discountRecord, string unitID, decimal discountAmount, boolean isApply, decimal carparkAmount) { 
        system.debug('discountRecord:: '+discountRecord);
        List<QuotationManagmentServices.SAPPricingWrapper> avFinal = (List<QuotationManagmentServices.SAPPricingWrapper>)JSON.deserialize(AVList, List<QuotationManagmentServices.SAPPricingWrapper>.class);
        Discount__C d1= (Discount__C)JSON.deserialize(discountRecord, Discount__C.class);
        Property__c property = QuotationManagmentServices.getPropertyDetails(unitId);
        system.debug('inside apply discount::' +':: avFinal::' + '::unitId:::'+unitID+':::discountAmount::'+discountAmount+':::isApply::'+isApply + '::carparkAmount:: '+carparkAmount);
        if(d1 != null){
            Decimal basicValue = 0;
            Decimal floorRisevalue = 0;
            Decimal PLCvalue = 0;
            Decimal netvalue = 0;
            for(QuotationManagmentServices.SAPPricingWrapper sp : avFinal){
                if(sp.chargeName == 'Basic'){
                    if(d1.Type__c == 'Percentage'){
                        decimal disAmt = ((sp.modifiedValueD * discountAmount)/100).setscale(0, RoundingMode.HALF_UP);
                        sp.modifiedValueD = sp.modifiedValueD - disAmt;
                    }else if(d1.Type__c == 'PSF'){
                        decimal disAmt = (discountAmount * property.Carpet_Area__c).setscale(0, RoundingMode.HALF_UP);
                        sp.modifiedValueD = sp.modifiedValueD - disAmt;
                    }else if(d1.Type__c == 'Lumpsum'){
                        sp.modifiedValueD = sp.modifiedValueD - discountAmount;
                    }
                    basicValue = sp.modifiedValueD;
                    sp.modifiedRateD = (sp.modifiedValueD/property.Carpet_Area__c).setscale(2, RoundingMode.HALF_UP); 
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueD != sp.valueD){
                        sp.modifiedClass = 'mClass';
                    }else{
                        sp.modifiedClass = '';
                    }    
                }else if(sp.chargeName == 'Floor Rise'){
                    if(d1.Type__c == 'Percentage'){
                        decimal disAmt = ((sp.modifiedValueD * discountAmount)/100).setscale(0, RoundingMode.HALF_UP);
                        sp.modifiedValueD = sp.modifiedValueD - disAmt;
                    }
                    //sp.modifiedValueD = sp.modifiedValueD - d.Total__C;
                    floorRisevalue = sp.modifiedValueD;
                    sp.modifiedRateD = (sp.modifiedValueD/property.Carpet_Area__c).setscale(2, RoundingMode.HALF_UP);
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueD != sp.valueD){
                        sp.modifiedClass = 'mClass';
                    }else{
                        sp.modifiedClass = '';
                    }    
                }else if(sp.chargeName == 'PLC'){
                    if(d1.Type__c == 'Percentage'){
                        decimal disAmt = ((sp.modifiedValueD * discountAmount)/100).setscale(0, RoundingMode.HALF_UP);
                        sp.modifiedValueD = sp.modifiedValueD - disAmt;
                    }    
                    //sp.modifiedValueD = sp.modifiedValueD - d.Total__C;
                    PLCvalue = sp.modifiedValueD;
                    sp.modifiedRateD = (sp.modifiedValueD/property.Carpet_Area__c).setscale(2, RoundingMode.HALF_UP); 
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueD != sp.valueD){
                        sp.modifiedClass = 'mClass';
                    }else{
                        sp.modifiedClass = '';
                    }    
                }
                
            }
            system.debug('basicValue::: '+basicValue + ' :: floorRisevalue :: '+ ' :: PLCvalue:: '+PLCvalue);
            for(QuotationManagmentServices.SAPPricingWrapper sp : avFinal){
                if(sp.chargeName == 'Net Value'){
                    
                    sp.modifiedValueD = basicValue + floorRisevalue + PLCvalue + carparkAmount;
                    netvalue = sp.modifiedValueD;
                    sp.modifiedRateD = sp.modifiedValueD; 
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueD != sp.valueD)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                    
                    system.debug('netvalue::'+netvalue);     
                }
                
            }
            system.debug('netvalue::'+netvalue);
            QuotationManagmentServices.GSTWrapper gp = QuotationManagmentServices.getTaxValue(netvalue, unitId);
            system.debug('inside applydiscount gp::'+gp);
            for(QuotationManagmentServices.SAPPricingWrapper sp : avFinal){
                if(sp.chargeName == 'Sale Value'){
                    sp.modifiedRateD = netvalue + gp.totalGST;
                    sp.modifiedValueD = netvalue + gp.totalGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }else if(sp.chargeName == 'CGST'){
                    sp.modifiedRateD = gp.CGST;
                    sp.modifiedValueD = gp.CGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }else if(sp.chargeName == 'SGST'){
                    sp.modifiedRateD = gp.SGST;
                    sp.modifiedValueD = gp.SGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }else if(sp.chargeName == 'Tax Value'){
                    sp.modifiedRateD = gp.totalGST;
                    sp.modifiedValueD = gp.totalGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }
            }
        }
        return avFinal;
    }
    @AuraEnabled(cacheable=true)
    public static List<QuotationManagmentServices.SAPPricingWrapper> removeDiscount(string AVList, string discountRecord, string uId, decimal carparkAmount) { 
        List<QuotationManagmentServices.SAPPricingWrapper> avFinal = (List<QuotationManagmentServices.SAPPricingWrapper>)JSON.deserialize(AVList, List<QuotationManagmentServices.SAPPricingWrapper>.class);
        Discount__C d= (Discount__C)JSON.deserialize(discountRecord, Discount__C.class);
        Property__c property = QuotationManagmentServices.getPropertyDetails(uId);
        system.debug('inside remove discount::' +':: avFinal::'+AVList + ' ::: discountRecord:::' +discountRecord);
        system.debug('d.total'+d.Total__C);
        if(d != null){
            decimal netvalue = 0;
            Decimal basicValue = 0;
            Decimal floorRisevalue = 0;
            Decimal PLCvalue = 0;
            for(QuotationManagmentServices.SAPPricingWrapper sp : avFinal){
                if(sp.chargeName == 'Basic'){
                    if(d.Type__c == 'Percentage'){
                        sp.modifiedValueD = sp.modifiedValueD + d.Basic_Amount__c;
                    }else if(d.Type__c == 'PSF'){
                        sp.modifiedValueD = sp.modifiedValueD + d.Total__C;
                    }else if(d.Type__c == 'Lumpsum'){
                        sp.modifiedValueD = sp.modifiedValueD + d.Total__C;
                    }
                    basicValue = sp.modifiedValueD;
                    sp.modifiedRateD = (sp.modifiedValueD/property.Carpet_Area__c).setscale(2, RoundingMode.HALF_UP); 
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueD != sp.valueD){
                        sp.modifiedClass = 'mClass';
                    }else{
                        sp.modifiedClass = '';
                    }    
                }else if(sp.chargeName == 'Floor Rise'){
                    if(d.Type__c == 'Percentage'){
                        sp.modifiedValueD = sp.modifiedValueD + d.Floor_Rise_Amount__c;
                    }
                    //sp.modifiedValueD = sp.modifiedValueD + d.Total__C;
                    floorRisevalue = sp.modifiedValueD;
                    sp.modifiedRateD = (sp.modifiedValueD/property.Carpet_Area__c).setscale(2, RoundingMode.HALF_UP); 
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueD != sp.valueD){
                        sp.modifiedClass = 'mClass';
                    }else{
                        sp.modifiedClass = '';
                    }    
                }else if(sp.chargeName == 'PLC'){
                    if(d.Type__c == 'Percentage'){
                        sp.modifiedValueD = sp.modifiedValueD + d.PLC_Amount__c;
                    }
                    //sp.modifiedValueD = sp.modifiedValueD + d.Total__C;
                    PLCvalue = sp.modifiedValueD;
                    sp.modifiedRateD = (sp.modifiedValueD/property.Carpet_Area__c).setscale(2, RoundingMode.HALF_UP); 
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueD != sp.valueD){
                        sp.modifiedClass = 'mClass';
                    }else{
                        sp.modifiedClass = '';
                    }    
                }
                
            }
            for(QuotationManagmentServices.SAPPricingWrapper sp : avFinal){
                if(sp.chargeName == 'Net Value'){
                    sp.modifiedValueD = basicValue + floorRisevalue + PLCvalue + carparkAmount;
                    netvalue = sp.modifiedValueD; 
                    sp.modifiedRateD = sp.modifiedValueD; 
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueD != sp.valueD)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }
                
            }
            QuotationManagmentServices.GSTWrapper gp = QuotationManagmentServices.getTaxValue(netvalue, uId);
            system.debug('inside remove discount gp::'+gp);
            for(QuotationManagmentServices.SAPPricingWrapper sp : avFinal){
                if(sp.chargeName == 'Sale Value'){
                    sp.modifiedRateD = netvalue + gp.totalGST;
                    sp.modifiedValueD = netvalue + gp.totalGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }else if(sp.chargeName == 'CGST'){
                    sp.modifiedRateD = gp.CGST;
                    sp.modifiedValueD = gp.CGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }else if(sp.chargeName == 'SGST'){
                    sp.modifiedRateD = gp.SGST;
                    sp.modifiedValueD = gp.SGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }else if(sp.chargeName == 'Tax Value'){
                    sp.modifiedRateD = gp.totalGST;
                    sp.modifiedValueD = gp.totalGST;
                    sp.modifiedRateSTR = QuotationManagmentServices.INFormatR(sp.modifiedRateD);
                    sp.modifiedValueSTR = QuotationManagmentServices.INFormatR(sp.modifiedValueD);
                    sp.isModified = true;
                    if(sp.modifiedValueSTR != sp.valueSTR)
                        sp.modifiedClass = 'mClass';
                    else
                        sp.modifiedClass = '';
                }
            }
        }
        return avFinal;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static Discount__C getAppliedDiscounts(string AVList, string discountRecord,string unitID, decimal discountAmount, boolean isApply) { 
        Discount__C d= QuotationManagmentServices.calculateDiscountLogic(AVList, discountRecord, unitID, discountAmount);
        return d;
    }
    @AuraEnabled(cacheable=true)
    public static List<QuotationManagmentServices.PlanDetailsWrapper> getPlanDetail(string AVList, string planId,string uId) {
        List<QuotationManagmentServices.SAPPricingWrapper> avFinal = (List<QuotationManagmentServices.SAPPricingWrapper>)JSON.deserialize(AVList, List<QuotationManagmentServices.SAPPricingWrapper>.class);
        List<QuotationManagmentServices.PlanDetailsWrapper> ppList = new List<QuotationManagmentServices.PlanDetailsWrapper>();
        ppList = QuotationManagmentServices.getPlanDetails(planId,avFinal,uId);
        system.debug('ppList::'+ppList);
        return ppList;
    }
    @AuraEnabled(cacheable=true)
    public static List<QuotationManagmentServices.PlanDetailsWrapper> addPlanRow(string planDetails, string planRecord, Integer milestoneNo) {
        system.debug('planDetails::'+planDetails + '::: planRecord'+planRecord + ':::: milestoneNo'+milestoneNo);
        List<QuotationManagmentServices.PlanDetailsWrapper> planList = (List<QuotationManagmentServices.PlanDetailsWrapper>)JSON.deserialize(planDetails, List<QuotationManagmentServices.PlanDetailsWrapper>.class);
        QuotationManagmentServices.PlanDetailsWrapper pRecord = (QuotationManagmentServices.PlanDetailsWrapper)JSON.deserialize(planRecord, QuotationManagmentServices.PlanDetailsWrapper.class);
        QuotationManagmentServices.PlanDetailsWrapper newRecord = new QuotationManagmentServices.PlanDetailsWrapper();
        newRecord.milestone_no = milestoneNo;
        newRecord.milestone_Name = '';
        newRecord.days_after_due = 0;
        newRecord.due_Date = '';
        newRecord.dueDateIn = null;
        newRecord.milestone_type = pRecord.milestone_type;
        newRecord.milestone_Percentage = 0;
        newRecord.payment_group = pRecord.payment_group;
        newRecord.iseditable = PRecord.iseditable;
        newRecord.amountD = 0;
        newRecord.amountSTR = QuotationManagmentServices.InFormatR(newRecord.amountD);
        newRecord.SGST_D = 0;
        newRecord.SGST_STR = QuotationManagmentServices.InFormatR(newRecord.SGST_D);
        newRecord.CGST_D = 0;
        newRecord.CGST_STR = QuotationManagmentServices.InFormatR(newRecord.CGST_D);
        newRecord.total_GST_D = 0;
        newRecord.total_GST_STR = QuotationManagmentServices.InFormatR(newRecord.total_GST_D);
        newRecord.milestone_Total_D = 0;
        newRecord.milestone_Total_STR = QuotationManagmentServices.InFormatR(newRecord.milestone_Total_D);
        newRecord.bpl_Item = pRecord.bpl_Item;
        newRecord.isRowAdjustable = true;
        newRecord.SAP_milestone_No = pRecord.SAP_milestone_No;
        
        if(planList.size() == milestoneNo)
            planList.add(newRecord);
        else
            planList.add(milestoneNo, newRecord);    
        Integer i=1;
        for(QuotationManagmentServices.PlanDetailsWrapper pl : planList){
            pl.milestone_no = i;
            i++;
        }
        system.debug('planList::'+planList);
        return planList;
    } 
    @AuraEnabled(cacheable=true)
    public static List<QuotationManagmentServices.PlanDetailsWrapper> updatePlanDetails(string planDetails, string AVList) {
        List<QuotationManagmentServices.PlanDetailsWrapper> ppList = QuotationManagmentServices.getUpdatedPlanDetails(planDetails, AVList);
        return ppList;
    }
    /*@AuraEnabled(cacheable=true)
public static QuotationManagmentServices.NPVWrapper getNPV(string planDetails, string pId, string uId) {
List<QuotationManagmentServices.PlanDetailsWrapper> planList = (List<QuotationManagmentServices.PlanDetailsWrapper>)JSON.deserialize(planDetails, List<QuotationManagmentServices.PlanDetailsWrapper>.class);
QuotationManagmentServices.NPVWrapper nRecord = new QuotationManagmentServices.NPVWrapper();
Property__c property = QuotationManagmentServices.getPropertyDetails(uId);
Decimal npvAmount = QuotationManagmentServices.calculateNPV(planList, pId);
nRecord.NPVAmountD = npvAmount;
nRecord.NPVAmountPSFD = npvAmount/property.Carpet_Area__c;
nRecord.NPVAmountSTR = QuotationManagmentServices.INFormatR(nRecord.NPVAmountD);
nRecord.NPVAmountPSFSTR = QuotationManagmentServices.INFormatR(nRecord.NPVAmountPSFD); 

return nRecord;
}*/
    
    @AuraEnabled(cacheable=true)
    public static String INFormat(decimal amount) { //List<QuotationManagmentServices.SAPPricingWrapper> AVList,
        system.debug('inside INFormat');
        return QuotationManagmentServices.INFormatR(amount);
    }
    
    @AuraEnabled
    public static String saveQuotation(string AVList, string otherChrges, string discountList, string planDetails, string carparkList, string fieldList){ ///, string selectedcarparks
        List<QuotationManagmentServices.SAPPricingWrapper> avFinal = (List<QuotationManagmentServices.SAPPricingWrapper>)JSON.deserialize(AVList, List<QuotationManagmentServices.SAPPricingWrapper>.class);
        List<QuotationManagmentServices.AdditionalChargesWrapper> otherChrgesList = (List<QuotationManagmentServices.AdditionalChargesWrapper>)JSON.deserialize(otherChrges, List<QuotationManagmentServices.AdditionalChargesWrapper>.class);
        List<Discount__C> dList = (List<Discount__C>)JSON.deserialize(discountList, List<Discount__C>.class);
        List<QuotationManagmentServices.PlanDetailsWrapper> planList = (List<QuotationManagmentServices.PlanDetailsWrapper>)JSON.deserialize(planDetails, List<QuotationManagmentServices.PlanDetailsWrapper>.class);
        List<string> carparkMapCount = (List<string>)JSON.deserialize(carparkList, List<string>.class);
        
        system.debug('carparkList:: '+carparkList);
        system.debug('avFinal:: '+avFinal);
        system.debug('otherChrgesList:: '+otherChrgesList);
        
        system.debug('dList :: '+dList );
        system.debug('planList :: '+planList );
        system.debug('carparkMapCount :: '+carparkMapCount);
        system.debug('fieldList:: '+fieldList);
        
        List<QuotationParser> qparse = QuotationParser.parse(fieldList);
        Map<String,String> parseMap = new Map<String,String>();
        for(QuotationParser qp : qparse){
            system.debug('label::'+qp.label + ' ::: value::: '+qp.value);
            parseMap.put(qp.label,qp.value); 
        }
        string selectedPlan = parseMap.get('selectedPlan');
        string uId = parseMap.get('unitId');
        boolean editschedule = boolean.valueOf(parseMap.get('editschedule'));
        string opId = parseMap.get('oppId');
        //boolean isMilestoneUpdated = boolean.valueOf(parseMap.get('isMilestoneUpdated'));
        string additionalComments = parseMap.get('additionalComments');
        boolean isSourceChange = boolean.valueOf(parseMap.get('changeInSource'));
        string revisedBookingSource = '';
        if(string.isNotBlank(parseMap.get('revisedBookingSource'))){
            revisedBookingSource = parseMap.get('revisedBookingSource');
        }
        string revisedCP = '';
        if(string.isNotBlank(parseMap.get('revisedCP'))){
            revisedCP = parseMap.get('revisedCP');
        }
        
        /*if(string.isNotBlank(parseMap.get('revisedBrokeragePercentage'))){
revisedBrokeragePercentage = Decimal.valueOf(parseMap.get('revisedBrokeragePercentage'));
}*/
        string referredBy = '';
        string referProject = '';
        string referTower = '';
        string referFlat = '';
        string referEmpCode = '';
        if(string.isNotBlank(parseMap.get('referredBy'))){
            referredBy = string.valueOf(parseMap.get('referredBy'));
        }
        if(string.isNotBlank(parseMap.get('referProject'))){
            referProject = string.valueOf(parseMap.get('referProject'));
        }
        if(string.isNotBlank(parseMap.get('referTower'))){
            referTower = string.valueOf(parseMap.get('referTower'));
        }
        if(string.isNotBlank(parseMap.get('referFlat'))){
            referFlat = string.valueOf(parseMap.get('referFlat'));
        }
        if(string.isNotBlank(parseMap.get('referEmpCode'))){
            referEmpCode = string.valueOf(parseMap.get('referEmpCode'));
        }
        
        system.debug('selectedPlan:: '+selectedPlan);
        system.debug('uId:: '+uId);
        system.debug('editschedule:: '+editschedule);
        system.debug('opId:: '+opId);
        //system.debug('isMilestoneUpdated:: '+isMilestoneUpdated);
        system.debug('additionalComments:: '+additionalComments);
        system.debug('referredBy:: '+referredBy);
        system.debug('referProject:: '+referProject);
        system.debug('referTower:: '+referTower);
        system.debug('referFlat:: '+referFlat);
        system.debug('referEmpCode:: '+referEmpCode);
        
        Property__c property = QuotationManagmentServices.getPropertyDetails(uId);
        Quotation__c q = new Quotation__c();
        
        /******** Add Car parking details on Quotation record   ***********/
        List<FinalCarPArk> cpList = new List<FinalCarPArk>();
        if(carparkMapCount != null && !carparkMapCount.isEmpty()){
            for(Integer i=0;i<carparkMapCount.size();i=i+3){
                FinalCarPArk fp = new FinalCarPArk();
                fp.carparkNAme = carparkMapCount[i];
                fp.carparkCount = Decimal.valueOf(carparkMapCount[i+1]);
                fp.carparkAmount = Decimal.valueOf(carparkMapCount[i+2]);
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
                    q.put('Car_Park_Type_'+s+'__c',cpList[i].carparkNAme);
                    q.put('Car_Park_Count_'+s+'__c',cpList[i].carparkCount);
                    q.put('Car_Park_Charge_'+s+'__c',cpList[i].carparkAmount.setscale(0, RoundingMode.HALF_UP));
                }
            }
        }
        
        /***************      Add EARMARKED CAR PARKING  **********************************/
        for(Integer i=1;i<=5;i++){
            string ctype = (string)property.get('Car_Park_Type_' + i + '__c');
            Decimal cCOunt = (Decimal)property.get('Car_Park_Count_' + i + '__c');
            if(string.isNotBlank(cType)){
                q.put('Earmarked_Car_Parking_Type_'+i+'__c',ctype);
                q.put('Earmarked_Car_Parking_Count_'+i+'__c',cCOunt);
            }
            
        }      
        
        /************** Add Agreement value Details and Other charges Details ************/   
        Integer seq = 1;
        if(avFinal != null && !avFinal.isEmpty()){
            for(Integer i=0;i<avFinal.size();i++){
                if(avFinal[i].chargeName != 'Net Value' && avFinal[i].chargeName != 'Tax Value' &&
                   avFinal[i].chargeName != 'CGST' && avFinal[i].chargeName != 'SGST' &&
                   avFinal[i].chargeName != 'Sale Value'){
                       q.put('Charge_'+seq+'_Name__c',avFinal[i].chargeName);
                       q.put('Charge_'+seq+'_Bucket__c','Agreement Value'); 
                       q.put('Charge_'+seq+'_Value_Original__c',avFinal[i].valueD.setscale(0, RoundingMode.HALF_UP));
                       q.put('Charge_'+seq+'_Value_Modified__c',avFinal[i].modifiedValueD.setscale(0, RoundingMode.HALF_UP));
                       q.put('Charge_'+seq+'_Rate_Original__c',avFinal[i].rateD.setscale(0, RoundingMode.HALF_UP));
                       q.put('Charge_'+seq+'_Rate_Modified__c',avFinal[i].modifiedRateD.setscale(0, RoundingMode.HALF_UP));
                       seq++;
                   }else if(avFinal[i].chargeName == 'Net Value'){
                       q.put('Total_Agreement_Value_Original__c',avFinal[i].valueD.setscale(0, RoundingMode.HALF_UP));
                       q.put('Total_Agreement_Value_Modified__c',avFinal[i].modifiedValueD.setscale(0, RoundingMode.HALF_UP));
                   }else if(avFinal[i].chargeName == 'CGST'){
                       q.put('Total_CSGT_Original__c',avFinal[i].valueD.setscale(0, RoundingMode.HALF_UP));
                       q.put('Total_CSGT_Modified__c',avFinal[i].modifiedValueD.setscale(0, RoundingMode.HALF_UP));
                   }else if(avFinal[i].chargeName == 'SGST'){
                       q.put('Total_SGST_Original__c',avFinal[i].valueD.setscale(0, RoundingMode.HALF_UP));
                       q.put('Total_SGST_Modified__c',avFinal[i].modifiedValueD.setscale(0, RoundingMode.HALF_UP));
                   }
            }
        }
        q.AV_Discount_Percentage__c = (((q.Total_Agreement_Value_Original__c - q.Total_Agreement_Value_Modified__c)/q.Total_Agreement_Value_Original__c)*100).setscale(2);
        Decimal total_Additional_Charges_O = 0;
        Decimal total_Additional_Charges_M = 0;
        if(otherChrgesList != null && !otherChrgesList.isEmpty()){
            for(Integer i=0;i<otherChrgesList.size();i++){
                q.put('Charge_'+seq+'_Name__c',otherChrgesList[i].chargeName);
                q.put('Charge_'+seq+'_Bucket__c','Additional Charge'); 
                q.put('Charge_'+seq+'_Value_Original__c',otherChrgesList[i].chargeAmountD.setscale(0, RoundingMode.HALF_UP));
                q.put('Charge_'+seq+'_Value_Modified__c',otherChrgesList[i].modifiedChargeAmountD.setscale(0, RoundingMode.HALF_UP));
                total_Additional_Charges_O += otherChrgesList[i].chargeAmountD.setscale(0, RoundingMode.HALF_UP);
                total_Additional_Charges_M += otherChrgesList[i].modifiedChargeAmountD.setscale(0, RoundingMode.HALF_UP);
                seq++;
            }
        }
        q.put('Total_Additional_Charges_Original__c',total_Additional_Charges_O);
        q.put('Total_Additional_Charges_Modified__c',total_Additional_Charges_M);
        q.Billing_Plan__c = selectedPlan; 
        if(dList != null && !dList.isEmpty()){
            q.Discount_Applied__c = true;
        }
        q.Project__C = property.Project_Name__c;
        q.Site_Name__c = property.Project_Name__r.Site__r.name;
        q.Property__c = property.id;
        q.Tower__c = property.Tower__C;
        q.OC_Received__c = property.OC_Received__c;
        //q.Opportunity__c = opId;
        q.Unit_Configuration__c = property.Property_Type_Name__c;
        q.Unit_Floor_No__c = property.Floor_No__c;
        q.Carpet_Area__c = property.Carpet_Area__c;
        q.Customized_Billing_Plan__c = editschedule;
        //q.New_Quotation_Milestone_Updated__c = isMilestoneUpdated;
        q.Additional_Comments__c = additionalComments;
        q.Change_In_Source__c = isSourceChange;
        q.Booked_Unit_Quotation__c = true; 
        q.Quote_Status__c = 'Valid';
        /*if(q.Discount_Applied__c || q.Customized_Billing_Plan__c || q.Change_In_Source__c || AdditionalCarParkApplied){
            q.Quote_Status__c = 'Approval Pending';
        }else{
            q.Quote_Status__c = 'Valid';
            q.Final_Approved_Date__c = system.today();
        }*/
        if(AdditionalCarParkApplied){
            q.Additional_Car_Park_Applied__c = true;
        }
        system.debug('revisedCP:::'+revisedCP);
        if(string.isNotBlank(revisedCP))
            q.Channel_Partner__c = revisedCP;
        q.Revised_Booking_Source__c = revisedBookingSource; 
        if(property.Project_Name__r.Broker_Percentage__c != null)
            q.Brokerage_Percentage__c = property.Project_Name__r.Broker_Percentage__c; 
        
        if(string.isNotBlank(referredBy)){
            q.Referred_By__c = referredBy;
        }
        if(string.isNotBlank(referProject)){
            q.Referred_Project__c = referProject;
        }
        if(string.isNotBlank(referTower)){
            q.Referred_Tower__c = referTower;
        }
        if(string.isNotBlank(referFlat)){
            q.Referred_Flat__c = referFlat;
        }
        if(string.isNotBlank(referEmpCode)){
            q.Referred_Emp_Code__c = referEmpCode;
        }    
        
        /*********************  Add Approvers team on quotation  ***********************/  
        Map<string,Team_Members__c> approversTeam = QuotationManagmentServices.getApproversTeam(property.Project_Name__c);  
        for(string tm : approversTeam.keyset()){
            if(tm == 'First Level'){
                q.Site_Head__c = approversTeam.get(tm).User__C;
            }else if(tm == 'Second Level'){
                q.Central_Support__c = approversTeam.get(tm).User__C;
            }else if(tm == 'Third Level'){
                q.Account__c = approversTeam.get(tm).User__C;
            }else if(tm == 'Fourth Level'){
                q.Sales_Head__c = approversTeam.get(tm).User__C;
            }else if(tm == 'Fifth Level'){
                q.CFO__c = approversTeam.get(tm).User__C;
            }else if(tm == 'Sixth Level'){
                q.MD__c = approversTeam.get(tm).User__C;
            }
        }   
        
        insert q;
        // Usefule for sharing error
        List<Quotation__C> qList = [select id,name from Quotation__C where id=: q.id];
        
        Quotation__Share quotShr4 = new Quotation__Share();
        quotShr4.ParentId = q.id;
        quotShr4.UserOrGroupId = UserInfo.getUserId();
        quotShr4.AccessLevel = 'Edit';
        Database.SaveResult sr = Database.insert(quotShr4,false);
        //insert quotShr4;
        Approval.UnlockResult[] lrList = Approval.unlock(qList, false);
        // Iterate to see success and failure
        for(Approval.UnlockResult lr : lrList) {
            if (lr.isSuccess()) {
                System.debug('UnLocked record id –> ' + lr.getId());
            }
            else {
                for(Database.Error err : lr.getErrors()) {
                    System.debug('error check –> '+err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
        
        /***************** Insert Discount Applied records  ********************/
        if(dList != null && !dList.isEmpty()){
            List<Discount_Applied__c> dListForInsert = new List<Discount_Applied__c>();
            for(Discount__C dRecord : dList){
                Discount_Applied__c d = new Discount_Applied__c();
                d.PSF_Lumpsum_Percentage__c = dRecord.Lumpsum_Amount__c;
                d.Quotation__c = q.id;
                d.Reason__c = dRecord.Reason__c;
                d.Total_Amount__c = dRecord.Total__c.setscale(0, RoundingMode.HALF_UP);
                d.Type__c = dRecord.Type__c;
                dListForInsert.add(d); 
            }
            if(!dListForInsert.isEmpty()){
                insert dListForInsert;
            }
        }       
        /********************** Insert Quotation Billing line Items  ***********************/
        Map<Boolean, List<QuotationManagmentServices.PlanDetailsWrapper>> pdMap = new Map<Boolean, List<QuotationManagmentServices.PlanDetailsWrapper>>();
        Map<string,Integer> paymentGroupMap = new Map<string,Integer>();
        if(planList != null && !planList.isEmpty()){
            for(QuotationManagmentServices.PlanDetailsWrapper pd : planList){
                if(pdMap.containsKey(pd.isRowAdjustable)){
                    List<QuotationManagmentServices.PlanDetailsWrapper> dummyList = pdMap.get(pd.isRowAdjustable);
                    dummyList.add(pd);
                    pdMap.put(pd.isRowAdjustable, dummyList);
                }else{
                    List<QuotationManagmentServices.PlanDetailsWrapper> dummyList = new List<QuotationManagmentServices.PlanDetailsWrapper>();
                    dummyList.add(pd);
                    pdMap.put(pd.isRowAdjustable,dummyList); 
                }
                
                /*    if(pd.isRowAdjustable){
// system.debug('milestone no::: '+pd.Payment_Group__c);
if(paymentGroupMap.containsKey(pd.Payment_Group__c)){
Integer seq2 = paymentGroupMap.get(pd.Payment_Group__c);
seq2 = seq2 + 1;
paymentGroupMap.put(pd.Payment_Group__c, seq2);
}else{
paymentGroupMap.put(pd.Payment_Group__c, 1);
}
}*/
            }
        }
        //system.debug('paymentGroupMap::: '+paymentGroupMap);
        List<Quotation_Billing_Line_Item__c> bplListForInsert = new List<Quotation_Billing_Line_Item__c>();
        Map<string,List<Payment_Plan_Line_Item__c>> pplMap = new Map<string,List<Payment_Plan_Line_Item__c>>();
        List<Payment_Plan_Line_Item__c> plList = [select id,name,Payment_Plan__c,Percentage__c,Order__c,Percentage_Of_Value_To_Be_Invoiced__c,
                                                  Date_Description__c,Description__c,Terms_of_Payment_Key__c,Payment_Group__c,Milestone_Number__c,
                                                  Payment_Date__c,Usage__c from Payment_Plan_Line_Item__c 
                                                  where Payment_Plan__c =: selectedPlan and Usage__c != null and Date_Description__c = null order by Terms_of_Payment_Key__c ASC];
        system.debug('plList:: '+plList.size());
        if(plList != null && !plList.isEmpty()){
            for(Payment_Plan_Line_Item__c pl : plList){
                if(pplMap.containsKey(pl.Payment_Group__c)){
                    List<Payment_Plan_Line_Item__c> dummyList = pplMap.get(pl.Payment_Group__c);
                    dummyList.add(pl);
                    pplMap.put(pl.Payment_Group__c, dummyList);
                }else{
                    List<Payment_Plan_Line_Item__c> dummyList = new List<Payment_Plan_Line_Item__c>();
                    dummyList.add(pl); 
                    pplMap.put(pl.Payment_Group__c, dummyList);
                }
            }
        }   
        system.debug('pplMap::: '+pplMap);
        Integer seq1 = 0;
        //Integer seq5;
        decimal totalMilestonesAmount = 0;
        decimal totalMilestonesCGST = 0;
        decimal totalMilestonesSGST = 0;
        
        decimal totalIN01Amount_c = 0;
        decimal totalIN01CGST_c = 0;
        decimal totalIN01SGST_c = 0;
        
        decimal IN01_Amount = 0;
        decimal IN01_CGST = 0;
        decimal IN01_SGST = 0;
        for(boolean key : pdMap.keySet()){
            if(key){   //////// create completed billing milestones item
                for(QuotationManagmentServices.PlanDetailsWrapper pd : pdMap.get(key)){
                    Quotation_Billing_Line_Item__c newItem = new Quotation_Billing_Line_Item__c();
                    newItem.Billing_Plan__c = selectedPlan;
                    newItem.Billing_Plan_Line_Item__c = pd.bpl_Item.id;
                    newItem.Is_IN00_01_Milesone__c = pd.bpl_Item.Is_IN00_01_Milesone__c;
                    newItem.Line_Item_Name__c = pd.milestone_Name;
                    newItem.Percentage_Of_Value_To_Be_Invoiced__c = pd.milestone_Percentage;
                    newItem.Property__c = property.id;
                    newItem.Quotation__c = q.id;
                    newItem.Sequence_Number__c = pd.milestone_no;
                    seq1 = pd.milestone_no;
                    newItem.Payment_Group__c = pd.payment_group;
                    newItem.Due_After_Days__c = pd.days_after_due;
                    newItem.Due_Date__c= pd.dueDateIn;
                    newItem.Milestone_Amount__c = pd.amountD.setscale(0, RoundingMode.HALF_UP);
                    newItem.Milestone_Type__c = pd.milestone_type;
                    newItem.CGST__c = pd.CGST_D.setscale(0, RoundingMode.HALF_UP);
                    newItem.SGST__c = pd.SGST_D.setscale(0, RoundingMode.HALF_UP);
                    newItem.Total_GST__c = pd.total_GST_D.setscale(0, RoundingMode.HALF_UP);     
                    newItem.Usage__c = '';
                    newItem.Milestone_Number__c = pd.SAP_milestone_No;
                    string seq0;
                    //system.debug('paymentGroupMap::'+paymentGroupMap);
                    if(paymentGroupMap.containsKey(pd.payment_group)){
                        Integer k = paymentGroupMap.get(pd.payment_group);
                        k = k+1;
                        paymentGroupMap.put(pd.payment_group,k);
                        seq0 = string.valueOf(k);
                    }else{
                        seq0 = '1';
                        paymentGroupMap.put(pd.payment_group,1);
                    }
                    //string seq0 = string.valueOf(seq5);
                    // system.debug('seq0'+seq0);
                    if(seq0.length() == 1){
                        seq0 = '0' + seq0; 
                    } 
                    if(pd.payment_group == 'IN' && !newItem.Is_IN00_01_Milesone__c)
                        newItem.Terms_of_Payment_Key__c = pd.bpl_Item.Terms_of_Payment_Key__c;
                    else
                        newItem.Terms_of_Payment_Key__c = pd.payment_group + seq0;    
                    ////Change added by ashish
                    /* string DD= newItem.Terms_of_Payment_Key__c;
DD = DD.substring(0,2);
If(dd == 'IN'){
DD = newItem.Terms_of_Payment_Key__c;
DD = DD.replace('IN','ST');                    
}Else{
DD = newItem.Terms_of_Payment_Key__c;
}                    
newItem.Date_Description_c__c = DD; */ 
                    newItem.Date_Description_c__c = newItem.Terms_of_Payment_Key__c;
                    ////Change added by ashish end 
                    newItem.IsCompleted_Milestone__c = true;
                    /*if(newItem.Terms_of_Payment_Key__c != 'PS01'){
totalMilestonesAmount += newItem.Milestone_Amount__c;
totalMilestonesCGST += newItem.CGST__c;
totalMilestonesSGST += newItem.SGST__c;
}*/
                    bplListForInsert.add(newItem); 
                }
            }else{ //////// create In-completed billing milestones item
                for(QuotationManagmentServices.PlanDetailsWrapper pd : pdMap.get(key)){
                    if(pd.payment_group == 'IN' && pd.bpl_Item.Is_IN00_01_Milesone__c){
                        totalIN01Amount_c = pd.amountD;
                        totalIN01CGST_c = pd.CGST_D;
                        totalIN01SGST_c = pd.SGST_D;
                    }
                    Integer x =1;
                    system.debug('pd.payment_group:: '+pd.payment_group);
                    for(Payment_Plan_Line_Item__c plRecord : pplMap.get(pd.payment_group)){
                        seq1 ++;
                        Quotation_Billing_Line_Item__c newItem = new Quotation_Billing_Line_Item__c();
                        newItem.Billing_Plan__c = selectedPlan;
                        newItem.Billing_Plan_Line_Item__c = pd.bpl_Item.id;
                        newItem.Is_IN00_01_Milesone__c = pd.bpl_Item.Is_IN00_01_Milesone__c;
                        if(pplMap.get(pd.payment_group).size() > 0){
                            newItem.Line_Item_Name__c = plRecord.Description__c;
                            newItem.Due_Date__c= plRecord.Payment_Date__c;
                        }else{
                            newItem.Line_Item_Name__c = pd.milestone_Name;
                            newItem.Due_Date__c= pd.dueDateIn;
                        } 
                        if(pd.bpl_Item.Terms_of_Payment_Key__c == 'IN01'){
                            newItem.Percentage_Of_Value_To_Be_Invoiced__c = Decimal.valueOf(plRecord.Percentage_Of_Value_To_Be_Invoiced__c);
                        }else{    
                            newItem.Percentage_Of_Value_To_Be_Invoiced__c = (pd.milestone_Percentage/pplMap.get(pd.payment_group).size()).setscale(2,RoundingMode.HALF_UP);
                        }
                        newItem.Property__c = property.id;
                        newItem.Quotation__c = q.id;
                        newItem.Sequence_Number__c = seq1;
                        newItem.Payment_Group__c = pd.payment_group;
                        newItem.Due_After_Days__c = pd.days_after_due;
                        newItem.Milestone_Type__c = pd.milestone_type;
                        
                        newItem.Milestone_Amount__c = (pd.amountD/pplMap.get(pd.payment_group).size()).setscale(0,RoundingMode.HALF_UP);
                        newItem.CGST__c = (pd.CGST_D/pplMap.get(pd.payment_group).size()).setscale(0,RoundingMode.HALF_UP);   //((pd.CGST_D * newItem.Percentage_Of_Value_To_Be_Invoiced__c)/100).setscale(0, RoundingMode.HALF_UP);
                        newItem.SGST__c = (pd.SGST_D/pplMap.get(pd.payment_group).size()).setscale(0,RoundingMode.HALF_UP);    ///((pd.SGST_D * newItem.Percentage_Of_Value_To_Be_Invoiced__c)/100).setscale(0, RoundingMode.HALF_UP);
                        
                        newItem.Total_GST__c = newItem.CGST__c + newItem.SGST__c;     
                        newItem.Usage__c = plRecord.Usage__c;
                        newItem.Milestone_Number__c = plRecord.Milestone_Number__c;
                        newItem.Terms_of_Payment_Key__c =plRecord.Terms_of_Payment_Key__c;
                        newItem.Date_Description_c__c = ''; 
                        newItem.IsCompleted_Milestone__c = false;
                        newItem.Billing_Item_Name__c = pd.milestone_Name;
                        newItem.Billing_Item_Due_Date__c = pd.dueDateIn;
                        
                        if(pd.payment_group == 'IN' && pd.bpl_Item.Is_IN00_01_Milesone__c){
                            if(x != pplMap.get(pd.payment_group).size()){
                                IN01_Amount += newItem.Milestone_Amount__c;
                                IN01_CGST += newItem.CGST__c;
                                IN01_SGST += newItem.SGST__c;
                            }else{
                                newItem.IN01_Last_Milestone__c = true;
                            }
                        }
                        x++;
                        
                        bplListForInsert.add(newItem);
                    }
                }
            }
        }
        /*IN01_Amount = totalIN01Amount_c - IN01_Amount;
IN01_CGST = totalIN01CGST_c - IN01_CGST;
IN01_SGST = totalIN01SGST_c - IN01_SGST;*/
        system.debug('paymentGroupMap::: '+paymentGroupMap);
        system.debug('totalIN01Amount_c::: '+totalIN01Amount_c);
        system.debug('totalIN01CGST_c::: '+totalIN01CGST_c);
        system.debug('totalIN01SGST_c::: '+totalIN01SGST_c);
        system.debug('IN01_Amount::: '+IN01_Amount);
        system.debug('IN01_CGST::: '+IN01_CGST);
        system.debug('IN01_SGST::: '+IN01_SGST);
        
        for(Quotation_Billing_Line_Item__c ql : bplListForInsert){
            if(ql.Payment_Group__c == 'IN' && ql.Is_IN00_01_Milesone__c && !ql.IsCompleted_Milestone__c && ql.IN01_Last_Milestone__c){
                system.debug('inside last IN condition');
                if(totalIN01Amount_c > IN01_Amount){
                    ql.Milestone_Amount__c = (totalIN01Amount_c - IN01_Amount).setscale(0,RoundingMode.HALF_UP);
                }else if(IN01_Amount > totalIN01Amount_c){
                    system.debug('inside the greater condition');
                    ql.Milestone_Amount__c = (IN01_Amount - totalIN01Amount_c).setscale(0,RoundingMode.HALF_UP);
                }
                
                if(totalIN01CGST_c > IN01_CGST){
                    ql.CGST__c = (totalIN01CGST_c - IN01_CGST).setscale(0,RoundingMode.HALF_UP);
                }else if(IN01_CGST > totalIN01CGST_c){
                    ql.CGST__c = (IN01_CGST - totalIN01CGST_c).setscale(0,RoundingMode.HALF_UP);
                }
                
                if(totalIN01SGST_c > IN01_SGST){
                    ql.SGST__c = (totalIN01SGST_c - IN01_SGST).setscale(0,RoundingMode.HALF_UP);
                }else if(IN01_SGST > totalIN01SGST_c){
                    ql.SGST__c = (IN01_SGST - totalIN01SGST_c).setscale(0,RoundingMode.HALF_UP);
                }
                ql.Total_GST__c = ql.CGST__c + ql.SGST__c;
            }
        }
        for(Quotation_Billing_Line_Item__c ql : bplListForInsert){
            if(ql.Terms_of_Payment_Key__c != 'PS01' && ql.Terms_of_Payment_Key__c != 'INPS'){
                totalMilestonesAmount += ql.Milestone_Amount__c;
                totalMilestonesCGST += ql.CGST__c;
                totalMilestonesSGST += ql.SGST__c;
            }
        }
        for(Quotation_Billing_Line_Item__c ql : bplListForInsert){
            if(ql.Terms_of_Payment_Key__c == 'PS01' || ql.Terms_of_Payment_Key__c == 'INPS'){
                if(totalMilestonesAmount > q.Total_Agreement_Value_Modified__c){
                    ql.Milestone_Amount__c = (totalMilestonesAmount - q.Total_Agreement_Value_Modified__c).setscale(0,RoundingMode.HALF_UP);
                }else if(q.Total_Agreement_Value_Modified__c > totalMilestonesAmount){
                    ql.Milestone_Amount__c = (q.Total_Agreement_Value_Modified__c - totalMilestonesAmount).setscale(0,RoundingMode.HALF_UP);
                }
                
                if(totalMilestonesCGST > q.Total_CSGT_Modified__c){
                    ql.CGST__c = (totalMilestonesCGST - q.Total_CSGT_Modified__c).setscale(0,RoundingMode.HALF_UP);
                }else if(q.Total_CSGT_Modified__c > totalMilestonesCGST){
                    ql.CGST__c = (q.Total_CSGT_Modified__c - totalMilestonesCGST).setscale(0,RoundingMode.HALF_UP);
                }
                
                if(totalMilestonesSGST > q.Total_SGST_Modified__c){
                    ql.SGST__c = (totalMilestonesSGST - q.Total_SGST_Modified__c).setscale(0,RoundingMode.HALF_UP);
                }else if(q.Total_SGST_Modified__c > totalMilestonesSGST){
                    ql.SGST__c = (q.Total_SGST_Modified__c - totalMilestonesSGST).setscale(0,RoundingMode.HALF_UP);
                }
                ql.Total_GST__c = ql.CGST__c + ql.SGST__c;
                
            }
        }
        
        if(!bplListForInsert.isEmpty()){           
            insert bplListForInsert;
        }
        /*   Approval.lockResult[] lrList2 = Approval.lock(qList, false);
// Iterate to see success and failure
for(Approval.lockResult lr : lrList2) {
if (lr.isSuccess()) {
System.debug('Locked record id –> ' + lr.getId());
}
else {
for(Database.Error err : lr.getErrors()) {
System.debug('error check –> '+err.getStatusCode() + ': ' + err.getMessage());
}
}
}*/
        
        return q.id+','+ property.get('Jodi_Property_Material_Name__c');
    }
    public class FinalCarPArk{
        public string carparkNAme;
        public Decimal carparkCount;
        public Decimal carparkAmount;
        
        public FinalCarPArk(){
            
        }
    }
  }
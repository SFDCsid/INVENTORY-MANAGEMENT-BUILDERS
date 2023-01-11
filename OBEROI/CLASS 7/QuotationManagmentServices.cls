Public Class QuotationManagmentServices{
    
    public static Property__c getPropertyDetails(string uId){
        Property__c property = new Property__c();
        List<Property__c> propertyList = [select id,name,Property_Name__c,Project_Name__c,RecordTypeId,Property_Type__c,Tower__c,
                                          Floor_No__c,House_Unit_No__c,Property_Type_Name__c,Carpet_Area__c,Material_No__c,BW__c,ST__c,PT__c,EL__c,
                                          Tower__r.Name,Project_Name__r.Name,Tower__r.Tower_Name__c,Project_Name__r.Quotation_Validity__c, OC_Received__c,
                                          Car_Park_Type_1__c, Car_Park_Type_2__c, Car_Park_Type_3__c, Car_Park_Type_4__c, Car_Park_Type_5__c, Market_Value__c,
                                          Car_Park_Count_1__c, Car_Park_Count_2__c, Car_Park_Count_3__c, Car_Park_Count_4__c, Car_Park_Count_5__c,Project_Name__r.Site__r.name,
                                          Jodi_Property__c,Jodi_Property_Material_Name__c,Project_Name__r.Broker_Percentage__c
                                          from Property__c where id =: uId];
        if(propertyList != null && !propertyList.isEmpty())
            property = propertyList[0];           
        return property;            
    }
    public static Opportunity getOpportunityDetails(string oppId){
        List<Opportunity> opList = new list<Opportunity>();
        DescribeSObjectResult pmResult = Opportunity.getSObjectType().getDescribe();  
        List<String> PmFieldNames = new List<String>( pmResult.fields.getMap().keySet() );
        String pmQuery = ' SELECT ' + String.join( PmFieldNames, ',' ) + ', Broker_Account__r.Name' + ' FROM ' + pmResult.getName() + ' where id=' + '\'' + oppId + '\'';
        
        opList = Database.query( pmQuery );
        Opportunity op = new Opportunity();
        if(!opList.isEmpty()){
            op = opList[0];
        }
        return op;
    }
    
    public static Map<string,Decimal> getAdditionalCarParks(string pId){
        List<Car_Parking__c> cpList = new List<Car_Parking__c>();
        Map<string,Decimal> carparksMap = new Map<string,Decimal>();
        cpList = [select id,name,Active__c,Project__c,Remarks__c,Status__c,Type__c from Car_Parking__c 
                  where Project__C =: pId and Status__c = 'Available' and Additional_Earmarked__c = 'Additional'];
        if(cpList != null && !cpList.isEmpty()){
            for(Car_Parking__c cp : cpList){
                if(carparksMap.containsKey(cp.Type__c)){
                    Decimal count = carparksMap.get(cp.Type__c);
                    count = count + 1;
                    carparksMap.put(cp.Type__c,count);
                }else{
                    carparksMap.put(cp.Type__c,1);
                } 
            }
        }           
        system.debug('carparksMap::'+carparksMap); 
        return carparksMap;
    } 
    public static Map<string,Decimal> getParkingCharges(string pId){
        Map<string,Decimal> parkingCharges = new Map<string, decimal>();
        List<Project__C> pr = [select Id,name, Car_Park_Type_1__c, Car_Park_Type_2__c, Car_Park_Type_3__c, Car_Park_Type_4__c,
                               Car_Park_Type_5__c, Car_Park_Charge_1__c, Car_Park_Charge_2__c, Car_Park_Charge_3__c, Car_Park_Charge_4__c,
                               Car_Park_Charge_5__c from Project__C where id=:pId];
        for(Project__C p : pr){
            for(Integer i=1;i<=5;i++){
                string cType = (string)p.get('Car_Park_Type_'+ i +'__c');
                Decimal cCharge = (Decimal)p.get('Car_Park_Charge_'+ i +'__c');
                if(string.isNotBlank(cType))
                    parkingCharges.put(cType, cCharge.setScale(0));
            }
        }   
        return parkingCharges;              
    }
    
    public static List<Discount__c> getProjectLevelDiscounts(Id projectId) {
        system.debug('ProjectId::::'+projectId);
        List<Discount__c> dList = new List<Discount__c>();
        dList = [Select Id, Name, Type__c, Applied__c, Start_Date__c, End_Date__c, Editable__c,total__C, Sequence_Number__c,
                 Lumpsum_Amount__c, PSF_Amount__c, Percentage_of_AV__c, Reason__c from Discount__c 
                 where Project__c = :projectId and start_date__c <= TODAY and (end_date__c = null OR end_date__c >= TODAY) ORDER BY Sequence_Number__c ASC];
        return dList;
    }
    
    public static List<Payment_Plan__C> getPlanList(Id towerId) {
        system.debug('towerId::::'+towerId);
        List<Payment_Plan__C> ppList = new List<Payment_Plan__C>();
        ppList = [Select Id, Name, Payment_Plan_Number__c, Active__c, Payment_Plan_Type__c, RecordTypeId, Site__c, 
                  Project__c, Tower__c, Status__c,Record_Type_Name__c,Billing_Plan_Name__c,Is_Editable__c, Is_Subvention_Plan__c,
                  Subvention_Base_Rate__c
                  from Payment_Plan__C 
                  where Tower__C =: towerId and Final_Check__c = true];
        return ppList;
    }
    
    /* public static list<string> getAllChargesName(string unitId, string propertyTypeId){
List<string> chargesName = new List<string>();
List<Other_Charges__c> otherChrges = getAdditionalChargesList(propertyTypeId);
List<SAP_Pricing__c> avChrges = getSAPPricingDetails(unitId);
Map<string,SAP_Pricing_Code__mdt> pricingMap = SAP_Pricing_Code__mdt.getAll();
if(avChrges != null && !avChrges.isEmpty()){
for(SAP_Pricing__c sp : avChrges){
chargesName.add(pricingMap.get(sp.Condition_Type__c).charge_Name__C);
}
}
if(otherChrges != null && !otherChrges.isEmpty()){
for(Other_Charges__c oc : otherChrges){
chargesName.add(oc.name);
}
}

return chargesName; 
} 

public static map<string,decimal> getAVChargesMap(string unitId){
map<string,decimal> allchargesMap = new Map<string,decimal>();
List<SAP_Pricing__c> avChrges = getSAPPricingDetails(unitId);
Map<string,SAP_Pricing_Code__mdt> pricingMap = SAP_Pricing_Code__mdt.getAll();
if(avChrges != null && !avChrges.isEmpty()){
for(SAP_Pricing__c sp : avChrges){
string cName = pricingMap.get(sp.Condition_Type__c).charge_Name__C;
decimal amount = sp.Value__c;
decimal rate = sp.Rate__c;

//allchargesMap.put(cName + ' ORIGINAL VALUE', amount);
allchargesMap.put(cName, amount);
allchargesMap.put(cName + ' ORIGINAL RATE', rate);
allchargesMap.put(cName + ' MODIFIED RATE', rate);
allchargesMap.put(cName + ' MODIFIED VALUE', amount);
}
}
return allchargesMap; 
}

public static map<string,decimal> getOtherChargesMap(string propertyTypeId){
map<string,decimal> allchargesMap = new Map<string,decimal>();
List<Other_Charges__c> otherChrges = getAdditionalChargesList(propertyTypeId);
if(otherChrges != null && !otherChrges.isEmpty()){
for(Other_Charges__c oc : otherChrges){
string cName = oc.name;
decimal amount = oc.Discount_Amount__c;

allchargesMap.put(cName + ' ORIGINAL VALUE', amount);
allchargesMap.put(cName + ' MODIFIED VALUE', amount);
}
}
return allchargesMap; 
} */
    
    public static List<Other_Charges__c> getOtherChargesList(string pId){
        List<Other_Charges__c> otherCharges = [select id,name,Active__c,Discount_Amount__c,Property_Type__c,
                                               Project__c,Order__c, Description__c,At_Actual__c from Other_Charges__c 
                                               where Property_Type__c =: pId and Available_At__c != 'For BareShell' and
                                               Active__c = true order by Order__c ASC];
        return otherCharges; 
    }
    
    public static List<SAP_Pricing__c> getAVChargesList(string uId){
        List<SAP_Pricing__c> finalSAPPricing = new List<SAP_Pricing__c>();
        list<SAP_Pricing__c> sapPricing = [select id,name,Sequence_Number__c,Property__c,Charge_Based_On__c,
                                           Condition_Description__c,Condition_Type__c,Rate__c,Value__c
                                           from SAP_Pricing__c where Property__c =: uId order by Sequence_Number__c asc];
        Map<string,SAP_Pricing_Code__mdt> pricingMap = SAP_Pricing_Code__mdt.getAll();               
        for(SAP_Pricing__c sa : sapPricing){
            if(pricingMap.containsKey(sa.Condition_Type__c)){
                finalSAPPricing.add(sa); 
            }
        }
        return finalSAPPricing;                    
    }  
    
    Public static List<additionalChargesWrapper> getadditionalChargesWrapper(string pId){
        List<Other_Charges__c> otherCharges = getOtherChargesList(pId);
        List<additionalChargesWrapper> additionalChrgs = new List<additionalChargesWrapper>();                                       
        if(otherCharges != null && !otherCharges.isEmpty()){
            for(Other_Charges__c oc : otherCharges){
                /* additionalChargesWrapper ac = new additionalChargesWrapper();
ac.chargeName = oc.name;
if(oc.order__c != null)
ac.order = Integer.valueOf(oc.order__c);
ac.chargeAmountD = oc.Discount_Amount__c; 
ac.chargeAmountSTR = INFormatR(oc.Discount_Amount__c);
ac.modifiedChargeAmountD = oc.Discount_Amount__c; 
ac.modifiedChargeAmountSTR = INFormatR(oc.Discount_Amount__c);*/
                additionalChrgs.add(new additionalChargesWrapper(oc.Description__c, oc.order__c, oc.Discount_Amount__c,oc.Discount_Amount__c,oc)); 
            }
        }                                      
        return additionalChrgs;                                        
    }
    
    public static List<SAPPricingWrapper> getSAPPricingWrapper(string uId){
        list<SAP_Pricing__c> sapPricing = getAVChargesList(uId);
        Map<string,SAP_Pricing_Code__mdt> pricingMap = SAP_Pricing_Code__mdt.getAll();                               
        List<SAPPricingWrapper> SAPPricingList = new List<SAPPricingWrapper>();     
        Integer count = 1;        
        if(sapPricing != null && !sapPricing.isEmpty()){
            for(SAP_Pricing__c sp : sapPricing){
                if(pricingMap.containskey(sp.Condition_Type__c)){
                    /* SAPPricingWrapper spWrapper = new SAPPricingWrapper();
spWrapper.sequence_Number = Integer.valueOf(sp.Sequence_Number__c);
spWrapper.chargeName = pricingMap.get(sp.Condition_Type__c).charge_Name__C;
spWrapper.charged_Based_On = sp.Charge_Based_On__c;
spWrapper.condition_Type = sp.Condition_Type__c;
spWrapper.rateD = sp.Rate__c;
spWrapper.rateSTR = INFormatR(sp.Rate__c);
spWrapper.valueD = sp.Value__c;
spWrapper.valueSTR = INFormatR(sp.Value__c);
spWrapper.modifiedRateD = sp.Rate__c;
spWrapper.modifiedRateSTR = INFormatR(sp.Rate__c);
spWrapper.modifiedValueD = sp.Value__c;
spWrapper.modifiedValueSTR = INFormatR(sp.Value__c);
spWrapper.isModified = false; */
                    
                    SAPPricingList.add(new SAPPricingWrapper(sp.Sequence_Number__c, pricingMap.get(sp.Condition_Type__c).charge_Name__C,sp.Charge_Based_On__c,
                                                             sp.Condition_Type__c,sp.Rate__c,sp.Value__c,sp.Rate__c,sp.Value__c,false,sp, true));
                    count ++;                     
                }
            }
            ///////// Add car parking Charge in the list    
            Decimal carPArkAmount = 0;
            /* SAPPricingWrapper spWrapper = new SAPPricingWrapper();
spWrapper.sequence_Number = Count;
spWrapper.chargeName = 'Car Parking';
spWrapper.charged_Based_On = 'Lumpsum';
spWrapper.condition_Type = 'Car Parking';
spWrapper.rateD = carPArkAmount;
spWrapper.rateSTR = INFormatR(carPArkAmount);
spWrapper.valueD = carPArkAmount;
spWrapper.valueSTR = INFormatR(carPArkAmount);
spWrapper.modifiedRateD = carPArkAmount;
spWrapper.modifiedRateSTR = INFormatR(carPArkAmount);
spWrapper.modifiedValueD = carPArkAmount;
spWrapper.modifiedValueSTR = INFormatR(carPArkAmount);
spWrapper.isModified = false; */
            SAPPricingList.add(new SAPPricingWrapper(Count, 'Car Parking','Lumpsum',
                                                     'Car Parking',carPArkAmount,carPArkAmount,carPArkAmount,carPArkAmount,false,null,false));
        }                                   
        return SAPPricingList;
    }
    
    public static List<SAPPricingWrapper> Charges(List<SAPPricingWrapper> AVchargesList, List<CarParkWrapper> carParkList){
        if(carParkList != null && !carParkList.isEmpty()){
            
        }
        return null;
    }
    
    Public static List<PlanDetailsWrapper> getPlanDetails(string planId, List<SAPPricingWrapper> AVList, string uId){
        List<Billing_Plan_Line_Item__c> bpll = [select id,name,Payment_Plan_Line_Item_Name__c,Payment_Group__c,Milestone_Number__c,
                                                Payment_Plan__c,Line_Item_Type__c,Terms_of_Payment_Key__c,Percentage_Of_Value_To_Be_Invoiced__c,
                                                Order__c,Usage__c,Date_Description__c,Due_After_Days__c,Is_IN00_01_Milesone__c
                                                from Billing_Plan_Line_Item__c where Payment_Plan__c =: planId order by Order__c ASC];     
        system.debug('bpll::'+bpll);
        List<PlanDetailsWrapper> planDetails = new List<PlanDetailsWrapper>();
        Map<string,SAPPricingWrapper> chargeMap = new Map<string,SAPPricingWrapper>();
        Property__c property = getPropertyDetails(uId);
        for(SAPPricingWrapper sp : AVList){
            if(sp.chargeName == 'Net Value' || sp.chargeName == 'Tax Value' || sp.chargeName == 'SGST' || sp.chargeName == 'CGST'){
                chargeMap.put(sp.chargeName,sp); 
            }
        }
        if(bpll != null && !bpll.isEmpty()){
            String type='Property__c';
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(type);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            
            integer order = 1;
            Decimal totalMilestonesAmount = 0;
            Decimal totalMilestonesCGST = 0;
            Decimal totalMilestonesSGST = 0;
            ////// Create Milestone excluding the PS01 Milestones    
            for(Billing_Plan_Line_Item__c bp : bpll){
                if(bp.Terms_of_Payment_Key__c != 'PS01' && bp.Terms_of_Payment_Key__c != 'INPS'){
                    Integer sq_no = order;
                    Integer due_Days = Integer.valueOf(bp.Due_After_Days__c); 
                    Integer dd_Days = 0;
                    if(due_Days > 0){
                        dd_Days = due_Days - 1;
                    }
                    Date dd = system.today().addDays(dd_Days);
                    string msName = bp.Payment_Plan_Line_Item_Name__c;
                    decimal mPercentage = Decimal.valueOf(bp.Percentage_Of_Value_To_Be_Invoiced__c);
                    decimal mAmount = ((mPercentage * chargeMap.get('Net Value').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP);  
                    decimal sGST = ((mPercentage * chargeMap.get('SGST').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP);
                    decimal cGST = ((mPercentage * chargeMap.get('CGST').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP); 
                    totalMilestonesAmount += mAmount;
                    totalMilestonesSGST += sGST;
                    totalMilestonesCGST += cGST;        
                    boolean isRowAdjustable = false;
                    if(bp.Usage__c == null && bp.Date_Description__c != null){ //&& bp.Terms_of_Payment_Key__c != 'PS01' && bp.Terms_of_Payment_Key__c != 'INPS'
                        isRowAdjustable = true;
                    }
                    /////////////// Add unit linked milestone 
                    boolean isTrue = false;
                    string item_Type = bp.Line_Item_Type__c;
                    if(fieldMap.containsKey(bp.Payment_Group__c + '__c')){
                        //system.debug('Label::: '+fieldMap.get(bp.Payment_Group__c + '__c').getDescribe().getLabel());
                        system.debug('Value::: '+(boolean)property.get(bp.Payment_Group__c + '__c'));
                        isTrue = (boolean)property.get(bp.Payment_Group__c + '__c');
                    }         
                    if(isTrue){
                        isRowAdjustable = true;
                        item_Type = 'Time Linked';
                        bp.Milestone_Number__c = '000000000000';
                    }
                    boolean isEditable = true;
                    /* if(bp.Terms_of_Payment_Key__c != null && bp.Terms_of_Payment_Key__c == 'IN01'){
isEditable = false;
} */
                    
                    planDetails.add(new PlanDetailsWrapper(isEditable, sq_no, msName, due_Days, dd, item_Type, 
                                                           mPercentage, bp.Payment_Group__c, mAmount, sGST, cGST, bp, isRowAdjustable,bp.Milestone_Number__c));
                    order++;    
                }                
            }
            
            ////// Create PS01 Milestones for calculating the balance amount
            for(Billing_Plan_Line_Item__c bp : bpll){
                if(bp.Terms_of_Payment_Key__c == 'PS01' || bp.Terms_of_Payment_Key__c == 'INPS'){
                    Integer sq_no = order;
                    Integer due_Days = Integer.valueOf(bp.Due_After_Days__c); 
                    Integer dd_Days = 0;
                    if(due_Days > 0){
                        dd_Days = due_Days - 1;
                    }
                    Date dd = system.today().addDays(dd_Days);
                    string msName = bp.Payment_Plan_Line_Item_Name__c;
                    decimal mPercentage = Decimal.valueOf(bp.Percentage_Of_Value_To_Be_Invoiced__c);
                    decimal mAmount = 0;
                    decimal sGST = 0;
                    decimal cGST = 0;
                    system.debug('totalMilestonesAmount::: '+totalMilestonesAmount);
                    system.debug('totalMilestonesAmount::: '+totalMilestonesAmount);
                    if(chargeMap.get('Net Value').modifiedValueD > totalMilestonesAmount){
                        mAmount = (chargeMap.get('Net Value').modifiedValueD - totalMilestonesAmount).setscale(0, RoundingMode.HALF_UP);
                    }else if(totalMilestonesAmount > chargeMap.get('Net Value').modifiedValueD){
                        mAmount = (totalMilestonesAmount - chargeMap.get('Net Value').modifiedValueD).setscale(0, RoundingMode.HALF_UP);
                    }
                    
                    if(chargeMap.get('SGST').modifiedValueD > totalMilestonesSGST){
                        sGST = (chargeMap.get('SGST').modifiedValueD - totalMilestonesSGST).setscale(0, RoundingMode.HALF_UP);
                    }else if(totalMilestonesSGST > chargeMap.get('SGST').modifiedValueD){
                        sGST = (totalMilestonesSGST - chargeMap.get('SGST').modifiedValueD).setscale(0, RoundingMode.HALF_UP);
                    }
                    
                    if(chargeMap.get('CGST').modifiedValueD > totalMilestonesCGST){
                        cGST = (chargeMap.get('CGST').modifiedValueD - totalMilestonesCGST).setscale(0, RoundingMode.HALF_UP);
                    }else if(totalMilestonesCGST > chargeMap.get('CGST').modifiedValueD){
                        cGST = (totalMilestonesCGST - chargeMap.get('CGST').modifiedValueD).setscale(0, RoundingMode.HALF_UP);
                    }
                    //decimal mAmount = ((mPercentage * chargeMap.get('Net Value').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP);  
                    //decimal sGST = ((mPercentage * chargeMap.get('SGST').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP);
                    //decimal cGST = ((mPercentage * chargeMap.get('CGST').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP);    
                    
                    
                    boolean isRowAdjustable = false;
                    if(bp.Usage__c == null && bp.Date_Description__c != null){
                        isRowAdjustable = true;
                    }
                    /////////////// Add unit linked milestone 
                    boolean isTrue = false;
                    string item_Type = bp.Line_Item_Type__c;
                    if(fieldMap.containsKey(bp.Payment_Group__c + '__c')){
                        //system.debug('Label::: '+fieldMap.get(bp.Payment_Group__c + '__c').getDescribe().getLabel());
                        system.debug('Value::: '+(boolean)property.get(bp.Payment_Group__c + '__c'));
                        isTrue = (boolean)property.get(bp.Payment_Group__c + '__c');
                    }         
                    if(isTrue){
                        isRowAdjustable = true;
                        item_Type = 'Time Linked';
                        bp.Milestone_Number__c = '000000000000';
                    }
                    boolean isEditable = true;
                    /* if(bp.Terms_of_Payment_Key__c != null && bp.Terms_of_Payment_Key__c == 'IN01'){
isEditable = false;
} */
                    
                    planDetails.add(new PlanDetailsWrapper(isEditable, sq_no, msName, due_Days, dd, item_Type, 
                                                           mPercentage, bp.Payment_Group__c, mAmount, sGST, cGST, bp, isRowAdjustable,bp.Milestone_Number__c));
                }
            } 
        }
        return planDetails; 
    }
    
    public static Discount__c calculateDiscountLogic(string AVList, string discountRecord, string unitID, decimal discountAmount) {
        system.debug('inside calculate discount logic method:: ');
        List<QuotationManagmentServices.SAPPricingWrapper> avFinal = (List<QuotationManagmentServices.SAPPricingWrapper>)JSON.deserialize(AVList, List<QuotationManagmentServices.SAPPricingWrapper>.class);
        Discount__C d= (Discount__C)JSON.deserialize(discountRecord, Discount__C.class);
        Property__c property = QuotationManagmentServices.getPropertyDetails(unitID);
        if(d != null){
            Decimal totalDiscount = 0;
            decimal basicAmount = 0;
            decimal floorRiseAmount = 0;
            decimal plcAmount = 0;
            
            if(d.Type__c == 'Lumpsum'){
                totalDiscount = discountAmount;
            }else if(d.Type__c == 'PSF'){
                totalDiscount = (discountAmount * property.Carpet_Area__c).setscale(0, RoundingMode.HALF_UP);
            }else if(d.Type__c == 'Percentage'){
                for(SAPPricingWrapper sp : avFinal){
                    if(sp.chargeName == 'Basic'){
                        basicAmount = ((sp.modifiedValueD * discountAmount)/100).setscale(0, RoundingMode.HALF_UP);
                    }else if(sp.chargeName == 'Floor Rise'){
                        floorRiseAmount = ((sp.modifiedValueD * discountAmount)/100).setscale(0, RoundingMode.HALF_UP);
                    }else if(sp.chargeName == 'PLC'){
                        plcAmount = ((sp.modifiedValueD * discountAmount)/100).setscale(0, RoundingMode.HALF_UP);
                    }
                }
                totalDiscount = basicAmount + floorRiseAmount + plcAmount;
            }else{
                
            }
            d.Total__C = totalDiscount; 
            d.Lumpsum_Amount__c = discountAmount;
            d.Applied__c = true;
            d.Basic_Amount__c = basicAmount;
            d.Floor_Rise_Amount__c = floorRiseAmount;
            d.PLC_Amount__c = plcAmount;
        } 
        return d;
    }
    Public static List<PlanDetailsWrapper> getUpdatedPlanDetails(string planDetails, string AVList){
        List<SAPPricingWrapper> avFinal = (List<SAPPricingWrapper>)JSON.deserialize(AVList, List<SAPPricingWrapper>.class);
        List<PlanDetailsWrapper> planList = (List<PlanDetailsWrapper>)JSON.deserialize(planDetails, List<PlanDetailsWrapper>.class);
        Map<string,SAPPricingWrapper> chargeMap = new Map<string,SAPPricingWrapper>();
        for(SAPPricingWrapper sp : avFinal){
            if(sp.chargeName == 'Net Value' || sp.chargeName == 'Tax Value' || sp.chargeName == 'SGST' || sp.chargeName == 'CGST'){
                chargeMap.put(sp.chargeName,sp); 
            }
        }
        Decimal totalMilestonesAmount = 0;
        Decimal totalMilestonesCGST = 0;
        Decimal totalMilestonesSGST = 0;
        for(PlanDetailsWrapper ppd : planList){
            system.debug('name::'+ppd.milestone_Name + ' ::: percentage::: '+ppd.milestone_Percentage);
            if(ppd.payment_group != 'PS' && ppd.bpl_Item.Terms_of_Payment_Key__c != 'INPS'){
                integer dd_Days = 0;
                if(ppd.days_after_due > 0){
                    dd_Days = ppd.days_after_due - 1;
                }
                ppd.due_Date = system.today().addDays(dd_Days).format();
                ppd.dueDateIn = system.today().addDays(dd_Days);
                ppd.amountD = ((ppd.milestone_Percentage * chargeMap.get('Net Value').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP);
                totalMilestonesAmount += ppd.amountD;
                ppd.amountSTR = QuotationManagmentServices.InFormatR(ppd.amountD);
                ppd.SGST_D = ((ppd.milestone_Percentage * chargeMap.get('SGST').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP);
                totalMilestonesSGST += ppd.SGST_D;
                ppd.SGST_STR = QuotationManagmentServices.InFormatR(ppd.SGST_D);
                ppd.CGST_D = ((ppd.milestone_Percentage * chargeMap.get('CGST').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP);
                totalMilestonesCGST += ppd.CGST_D;
                ppd.CGST_STR = QuotationManagmentServices.InFormatR(ppd.SGST_D);
                ppd.total_GST_D = ppd.SGST_D + ppd.CGST_D;
                ppd.total_GST_STR = InFormatR(ppd.total_GST_D);
                ppd.milestone_Total_D = ppd.amountD + ppd.SGST_D + ppd.CGST_D;
                ppd.milestone_Total_STR = InFormatR(ppd.milestone_Total_D);  
            }
        }
        for(PlanDetailsWrapper ppd : planList){
            system.debug('name::'+ppd.milestone_Name + ' ::: percentage::: '+ppd.milestone_Percentage);
            if(ppd.payment_group == 'PS' || ppd.bpl_Item.Terms_of_Payment_Key__c == 'INPS'){
                integer dd_Days = 0;
                if(ppd.days_after_due > 0){
                    dd_Days = ppd.days_after_due - 1;
                }
                ppd.due_Date = system.today().addDays(dd_Days).format();
                ppd.dueDateIn = system.today().addDays(dd_Days);
                //ppd.amountD = ((ppd.milestone_Percentage * chargeMap.get('Net Value').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP);
                if(totalMilestonesAmount > chargeMap.get('Net Value').modifiedValueD){
                    ppd.amountD = (totalMilestonesAmount - chargeMap.get('Net Value').modifiedValueD).setscale(0, RoundingMode.HALF_UP);
                }else if(chargeMap.get('Net Value').modifiedValueD > totalMilestonesAmount){
                    ppd.amountD = (chargeMap.get('Net Value').modifiedValueD - totalMilestonesAmount).setscale(0, RoundingMode.HALF_UP);
                }
                ppd.amountSTR = QuotationManagmentServices.InFormatR(ppd.amountD);
                //ppd.SGST_D = ((ppd.milestone_Percentage * chargeMap.get('SGST').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP);
                if(totalMilestonesSGST > chargeMap.get('SGST').modifiedValueD){
                    ppd.SGST_D = (totalMilestonesSGST - chargeMap.get('SGST').modifiedValueD).setscale(0, RoundingMode.HALF_UP);
                }else if(chargeMap.get('SGST').modifiedValueD > totalMilestonesSGST){
                    ppd.SGST_D = (chargeMap.get('SGST').modifiedValueD - totalMilestonesSGST).setscale(0, RoundingMode.HALF_UP);
                }
                ppd.SGST_STR = QuotationManagmentServices.InFormatR(ppd.SGST_D);
                //ppd.CGST_D = ((ppd.milestone_Percentage * chargeMap.get('CGST').modifiedValueD)/100).setscale(0, RoundingMode.HALF_UP);
                if(totalMilestonesCGST > chargeMap.get('CGST').modifiedValueD){
                    ppd.CGST_D = (totalMilestonesCGST - chargeMap.get('CGST').modifiedValueD).setscale(0, RoundingMode.HALF_UP);
                }else if(chargeMap.get('CGST').modifiedValueD > totalMilestonesCGST){
                    ppd.CGST_D = (chargeMap.get('CGST').modifiedValueD - totalMilestonesCGST).setscale(0, RoundingMode.HALF_UP);
                }
                ppd.CGST_STR = QuotationManagmentServices.InFormatR(ppd.SGST_D);
                ppd.total_GST_D = ppd.SGST_D + ppd.CGST_D;
                ppd.total_GST_STR = InFormatR(ppd.total_GST_D);
                ppd.milestone_Total_D = ppd.amountD + ppd.SGST_D + ppd.CGST_D;
                ppd.milestone_Total_STR = InFormatR(ppd.milestone_Total_D);  
            }
        }
        return planList;
    }
    
    // Calculate GST logic
    public static GSTWrapper getTaxValue(Decimal netvalue, string uId){
        list<SAP_Pricing__c> sapPricing = [select id,name,Sequence_Number__c,Property__c,Charge_Based_On__c,
                                           Condition_Description__c,Condition_Type__c,Rate__c,Value__c
                                           from SAP_Pricing__c where Property__c =: uId order by Sequence_Number__c asc];
        decimal ABT_for_GST = 0;
        Decimal cGSTp = 0;
        Decimal sGSTp = 0;
        for(SAP_Pricing__c sp : sapPricing){
            if(sp.Condition_Type__c == 'ZAB1'){
                ABT_for_GST = sp.Rate__C;
            }else if(sp.Condition_Type__c == 'JOCG'){
                cGSTp = sp.Rate__c;
            }else if(sp.Condition_Type__c == 'JOSG'){
                sGSTp = sp.Rate__c;
            }
        }
        Decimal Base_value_for_GST = 0;
        Base_value_for_GST = netvalue + ((netvalue * ABT_for_GST)/100); 
        system.debug('Base_value_for_GST:: '+Base_value_for_GST);
        GSTWrapper gp = new GSTWrapper();
        gp.CGST = (Base_value_for_GST * cGSTp)/100;
        system.debug('gp.CGST:: '+gp.CGST);
        gp.SGST = (Base_value_for_GST * sGSTp)/100; 
        system.debug('gp.SGST:: '+gp.SGST);
        gp.totalGST = gp.CGST + gp.SGST;
        
        return gp;
    }
    
    public static Map<string,Team_Members__c> getApproversTeam(string pId){
        Map<string,Team_Members__c> approversMap = new Map<string,Team_Members__c>();
        for(Team_Members__c tm : [select id,name,Approver_Type__c,Counter__c,IsActive__c,Last_Assignment__c,Team__c,
                                  User__c,User_Active__c from Team_Members__c where Team__r.Team_Type__c = 'Quotation Approvers Team' and
                                  Team__r.Project__c =:pId and User_Active__c = true and IsActive__c = true]){
                                      approversMap.put(tm.Approver_Type__c,tm);
                                  }
        return approversMap;
    }
    
    // calculate NPV of the money based on the payment plan
    /*  public static Decimal calculateNPV(List<PlanDetailsWrapper> pwList , Id projId){
Decimal NPV = 0.0;
Decimal NPVDayRate = 0;
Integer daysBetween =0; 
Decimal NPVofMoney = 0.0;
Decimal TotalNPV = 0.0;
List<Project__c> p = [Select Id, NPV__c, Name from Project__c where Id =: projId ];      
//system.debug('p size:: '+ p.size());   
if(p.size() == 1) {
NPV = p[0].NPV__c;
NPVDayRate = (NPV/365/100).setscale(18, RoundingMode.HALF_UP) + 1;
}
System.debug('NPV:' + NPV + NPVDayRate + ' ::: pwList:: '+pwList);
if(NPV != 0) {
for(PlanDetailsWrapper pw : pwList) {
NPVOfMoney =  0.0;
System.debug('plan wrapper list:' + pw.dueDateIn);
if(pw.dueDateIn != null) {
daysBetween = system.today().DaysBetween(pw.dueDateIn);
System.debug('Days between:' + daysBetween);
NPVofMoney = pw.amountD/NPVDayRate.pow(daysBetween);
System.debug('NPV of money:' + NPVOfMoney);
TotalNPV = TotalNPV + NPVofMoney;
}
}
//  System.debug('Total NPV:' + TotalNPV);

}
System.debug('Total NPV:' + TotalNPV);
return (TotalNPV.setscale(0,RoundingMode.HALF_UP));
}*/
    
    /********************  To fetch the customer view payment schedule ********************/
    public static List<PaymentMilestoneWrapper> getCustomerViewPaymentSchedule(string qId){
        List<Quotation__C> qList = [select id,name, Property__c,Property__r.Is_Inclusive_Sale_Price__c,Effective_Sale_Price__c,Billing_Plan__c from Quotation__C where id =: qId];
        List<Quotation_Billing_Line_Item__c> pmList = new List<Quotation_Billing_Line_Item__c>();
        List<PaymentMilestoneWrapper> pwList = new List<PaymentMilestoneWrapper>();
        DescribeSObjectResult pmResult = Quotation_Billing_Line_Item__c.getSObjectType().getDescribe();  
        List<String> PmFieldNames = new List<String>( pmResult.fields.getMap().keySet() );
        String pmQuery = ' SELECT ' + String.join( PmFieldNames, ',' ) + ' FROM ' + pmResult.getName() + ' where Quotation__c=' + '\'' + qId + '\'' +
            ' order by Sequence_Number__c asc'; //Sequence_Number__c due_date__c asc,
        pmList = Database.query( pmQuery );
        
        if(!pmList.isEmpty()){
            List<Quotation_Billing_Line_Item__c> completedMilestones = new List<Quotation_Billing_Line_Item__c>();
            
            Map<string, List<Quotation_Billing_Line_Item__c>> inMap = new Map<string, List<Quotation_Billing_Line_Item__c>>();
            for(Quotation_Billing_Line_Item__c pm : pmList){
                if(pm.IsCompleted_Milestone__c){
                    PaymentMilestoneWrapper pw = new PaymentMilestoneWrapper();
                    pw.milestoneName = pm.Line_Item_Name__c;    
                    if(pm.Line_Item_Name__c.containsIgnoreCase('<Date>') || pm.Line_Item_Name__c.containsIgnoreCase('< Date >') 
                       || pm.Line_Item_Name__c.containsIgnoreCase('«Date»') ){
                           pw.milestoneName = pw.milestoneName.replace('<Date>',customDateFormat(pm.Due_Date__c));
                           pw.milestoneName = pw.milestoneName.replace('< Date >',customDateFormat(pm.Due_Date__c));
                           pw.milestoneName = pw.milestoneName.replace('«Date»',customDateFormat(pm.Due_Date__c));
                       }
                    pw.milestonePercentage = pm.Percentage_Of_Value_To_Be_Invoiced__c;
                    pw.dueDate = pm.Due_Date__c.format();
                    pw.dueDateINDATE = pm.Due_Date__c;
                    pw.amountD = pm.Milestone_Amount__c;
                    if(qList[0].Property__r.Is_Inclusive_Sale_Price__c == True){
                        pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD + pm.Total_GST__c);
                    }else{
                        pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD);
                    }
                    pw.CGST_D = pm.CGST__c;
                    pw.CGST_STR = QuotationManagmentServices.INFormatR(pw.CGST_D);
                    pw.SGST_D = pm.SGST__c;
                    pw.SGST_STR = QuotationManagmentServices.INFormatR(pw.SGST_D);
                    pw.totalGST_D = pm.Total_GST__c;
                    pw.totalGST_STR = QuotationManagmentServices.INFormatR(pw.totalGST_D);
                    pw.totalMilestoneD = pw.amountD + pw.totalGST_D;
                    pw.totalMilestoneSTR = QuotationManagmentServices.INFormatR(pw.totalMilestoneD);
                    
                    pw.isCompletedMilestone = true;
                    pw.paymentGroup = pm.Payment_Group__c;
                    pw.dueDays = Integer.valueOf(pm.Due_After_Days__c);
                    pw.is_IN001Milestone = pm.Is_IN00_01_Milesone__c;
                    pw.Terms_of_Payment_Key = pm.Terms_of_Payment_Key__c;
                    pw.EffectiveAmountD = (pm.Percentage_Of_Value_To_Be_Invoiced__c/100)*qList[0].Effective_Sale_Price__c;
                    pw.EffectiveAmountS = QuotationManagmentServices.INFormatR(pw.EffectiveAmountD);
                    QuotationManagmentServices.GSTWrapper gpw = QuotationManagmentServices.getTaxValue(pw.EffectiveAmountD,qList[0].Property__c);
                    pw.GstForEffective = gpw.totalGST;
                    pw.GstForEffectiveS = QuotationManagmentServices.INFormatR(pw.GstForEffective);
                    pw.TotalGstForEffective =+ pw.GstForEffective;
                    pw.TotalGstForEffectiveS = QuotationManagmentServices.INFormatR(pw.TotalGstForEffective);
                    pw.TotalGstNamountD = pw.EffectiveAmountD + pw.GstForEffective;
                    pw.TotalGstNamountS = QuotationManagmentServices.INFormatR(pw.TotalGstNamountD);
                    pw.EtotalMilestoneD = pw.EffectiveAmountD + pw.GstForEffective;
                    pw.EtotalMilestoneSTR = QuotationManagmentServices.INFormatR(pw.EtotalMilestoneD);
                    System.debug('Line No 617::::::::::::::EffectiveAmountD:::::::::::'+pw.EffectiveAmountD);
                    System.debug('Line No 618::::::::::::::GstForEffective:::::::::::'+pw.GstForEffective);
                    System.debug('Line No 619::::::::::::::EffectiveAmountD+GstForEffective:::::::::::'+(pw.GstForEffective+pw.EffectiveAmountD));
                    System.debug('Line No 620::::::::::::::TotalGstNamountD:::::::::::'+pw.TotalGstNamountD);
                    
                    pwList.add(pw);
                }else{
                    if(pm.Payment_Group__c == 'IN' && pm.Is_IN00_01_Milesone__c){
                        if(inMap.containsKey(pm.Payment_Group__c)){
                            List<Quotation_Billing_Line_Item__c> dummyList = inMap.get(pm.Payment_Group__c);
                            dummyList.add(pm);
                            inMap.put(pm.Payment_Group__c, dummyList);
                        }else{
                            List<Quotation_Billing_Line_Item__c> dummyList = new List<Quotation_Billing_Line_Item__c>();
                            dummyList.add(pm);
                            inMap.put(pm.Payment_Group__c, dummyList);
                        }
                    }else{
                        List<Quotation_Billing_Line_Item__c> dummyList = new List<Quotation_Billing_Line_Item__c>();
                        dummyList.add(pm);
                        inMap.put(pm.Terms_of_Payment_Key__c, dummyList);
                    }
                }
            }    
            if(!inMap.isEmpty()){
                for(string key : inMap.keyset()){
                    PaymentMilestoneWrapper pw = new PaymentMilestoneWrapper();
                    pw.milestonePercentage = 0;
                    pw.amountD = 0;
                    pw.CGST_D = 0;
                    pw.SGST_D = 0;
                    pw.totalGST_D = 0;
                    pw.TotalGstForEffective = 0;
                    pw.EffectiveAmountD = 0;
                    for(Quotation_Billing_Line_Item__c qp : inMap.get(key)){
                        pw.milestoneName = qp.Billing_Item_Name__c ;
                        pw.milestonePercentage += qp.Percentage_Of_Value_To_Be_Invoiced__c;
                        pw.dueDate = qp.Billing_Item_Due_Date__c.format();
                        pw.dueDateINDATE = qp.Billing_Item_Due_Date__c;
                        pw.amountD += qp.Milestone_Amount__c; 
                        pw.CGST_D += qp.CGST__c;
                        pw.SGST_D += qp.SGST__c;
                        pw.totalGST_D += qp.Total_GST__c;
                        pw.paymentGroup = qp.Payment_Group__c;
                        pw.dueDays = Integer.valueOf(qp.Due_After_Days__c);
                        pw.is_IN001Milestone = qp.Is_IN00_01_Milesone__c;
                        pw.EffectiveAmountD += (qp.Percentage_Of_Value_To_Be_Invoiced__c/100)*qList[0].Effective_Sale_Price__c;
                        pw.EffectiveAmountS = QuotationManagmentServices.INFormatR(pw.EffectiveAmountD);
                        QuotationManagmentServices.GSTWrapper gpw = QuotationManagmentServices.getTaxValue(pw.EffectiveAmountD,qList[0].Property__c);
                        pw.GstForEffective = gpw.totalGST;
                        pw.GstForEffectiveS = QuotationManagmentServices.INFormatR(pw.GstForEffective);
                        pw.TotalGstForEffective =+ pw.GstForEffective;
                        pw.TotalGstForEffectiveS = QuotationManagmentServices.INFormatR(pw.TotalGstForEffective);
                        pw.TotalGstNamountD = pw.EffectiveAmountD + pw.GstForEffective;
                        pw.TotalGstNamountS = QuotationManagmentServices.INFormatR(pw.TotalGstNamountD);
                        
                        System.debug('Line No 673::::::::::::::EffectiveAmountD:::::::::::'+pw.EffectiveAmountD);
                        System.debug('Line No 674::::::::::::::GstForEffective:::::::::::'+pw.GstForEffective);
                        System.debug('Line No 675::::::::::::::EffectiveAmountD+GstForEffective:::::::::::'+(pw.GstForEffective+pw.EffectiveAmountD));
                        System.debug('Line No 676::::::::::::::TotalGstNamountD:::::::::::'+pw.TotalGstNamountD);
                        
                    }
                    if(qList[0].Property__r.Is_Inclusive_Sale_Price__c == True)
                        pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD + pw.totalGST_D);
                    else
                        pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD);
                    pw.CGST_STR = QuotationManagmentServices.INFormatR(pw.CGST_D);
                    pw.SGST_STR = QuotationManagmentServices.INFormatR(pw.SGST_D);
                    pw.totalGST_STR = QuotationManagmentServices.INFormatR(pw.totalGST_D);
                    pw.totalMilestoneD = pw.amountD + pw.totalGST_D;
                    pw.totalMilestoneSTR = QuotationManagmentServices.INFormatR(pw.totalMilestoneD);
                    pw.isCompletedMilestone = false;
                    pw.EtotalMilestoneD = pw.EffectiveAmountD + pw.GstForEffective;
                    pw.EtotalMilestoneSTR = QuotationManagmentServices.INFormatR(pw.EtotalMilestoneD);
                    pwList.add(pw);
                }
            }
        }
        
        return pwList;
        
    }  
    
    public static string customDateFormat(Date dt){
        system.debug('inside CusomDateFormat Method:: '+dt);
        string stDate = '';
        if(dt != null){
            string stMonth = '';
            Integer day = dt.Day();
            Integer month = dt.month();
            Integer year = dt.year();
            string stYear = string.valueof(year);
            
            if(month == 1){ stMonth = 'January';}
            else if(month == 2) { stMonth = 'February'; }
            else if(month == 3) { stMonth = 'March'; }
            else if(month == 4) { stMonth = 'April'; }
            else if(month == 5) { stMonth = 'May'; }
            else if(month == 6) { stMonth = 'June'; }
            else if(month == 7) { stMonth = 'July'; }
            else if(month == 8) { stMonth = 'August'; }
            else if(month == 9) { stMonth = 'September'; }
            else if(month == 10) { stMonth = 'October'; }
            else if(month == 11) { stMonth = 'November'; }
            else if(month == 12) { stMonth = 'December'; }
            
            stDate = day + ' ' + stMonth + ' ' + stYear;
        }
        return stDate;
    }
    
    // method for formatting the currency details to Indian Commas Format
    public static String INFormat(Decimal money) {
        Boolean negative = false;
        if(money < 0) {
            negative = true;
        }
        Decimal tempMoney = money;
        String m0 = tempMoney.setscale(2,RoundingMode.HALF_UP).toPlainString();
        String decimalPart;
        List<String> tempStr = new List<String>();
        if(String.isNotBlank(m0)) {
            tempStr = m0.split('\\.');
            if(tempStr != null && tempStr.size() ==2) {
                decimalPart = tempStr[1];
            }
        }
        
        //String m1 = String.valueOf(math.abs(money.setscale(0,RoundingMode.HALF_UP))).reverse();
        String m1 = tempStr[0].reverse();
        String mF = '';
        for(Integer i=0; i < m1.length() ; i++) {
            mF += m1.substring(i,i+1);
            if(i==2) {
                mF += ',';
            }
            if(i==4 || i==6 || i==8 || i==10 || i==12) {
                mF += ',';
            }
        }
        mf = mf.reverse();
        if(mf.substring(0,1).equals(',')) {
            mf = mf.substring(1);
        }
        if(String.isNotBlank(decimalPart)) 
            mf = mf + '.'  + decimalPart;
        
        if(!negative)
            mf =  mf + '/-';
        else
            mf = '- ' + mf + '/-';
        return mf;
    }
    
    // method for formatting the currency details to Indian Commas Format
    // No decimals, Rounded up.
    public static String INFormatR(Decimal money) {
        Boolean negative = false;
        if(money < 0) {
            negative = true;
        }
        String m1 = String.valueOf(math.abs(money.setscale(0,RoundingMode.HALF_UP))).reverse();
        String mF = '';
        for(Integer i=0; i < m1.length() ; i++) {
            mF += m1.substring(i,i+1);
            if(i==2) {
                mF += ',';
            }
            if(i==4 || i==6 || i==8 || i==10 || i==12) {
                mF += ',';
            }
        }
        mf = mf.reverse();
        if(mf.substring(0,1).equals(',')) {
            mf = mf.substring(1);
        }   
        if(!negative)
            mf =  mf + '/-';
        else
            mf = '- ' + mf + '/-';
        return mf;
    }
    
    public class CarParkWrapper{
        @AuraEnabled public string carParkName;
        @AuraEnabled Public Integer originalCount;
        @AuraEnabled Public Integer selectedCount;
        @AuraEnabled Public Decimal parkingAmount;
        
        public CarParkWrapper(){
            
        }
        public CarParkWrapper(String cpName, Integer Ocount, Integer sCount, Decimal amount){
            this.carParkName = cpName;
            this.originalCount = Ocount;
            this.selectedCount = sCount;
            this.parkingAmount = amount;
        }
        
    }
    public class AdditionalChargesWrapper{
        @AuraEnabled public string chargeName;
        @AuraEnabled Public Integer order;
        @AuraEnabled Public Decimal chargeAmountD;
        @AuraEnabled Public string chargeAmountSTR;
        @AuraEnabled Public Decimal modifiedChargeAmountD;
        @AuraEnabled Public string modifiedChargeAmountSTR;
        @AuraEnabled Public Other_Charges__c OCRecord;
        
        public AdditionalChargesWrapper(){
            
        }
        
        public AdditionalChargesWrapper(string cName, Decimal order, Decimal cAmount, Decimal mAmount, Other_Charges__c ocObj){
            this.chargeName = cName;
            if(order != null)
                this.order = Integer.valueOf(order);
            this.chargeAmountD = cAmount;
            this.chargeAmountSTR = INFormatR(cAmount);
            this.modifiedChargeAmountD = mAmount;
            this.modifiedChargeAmountSTR = INFormatR(mAmount);
            this.OCRecord = ocObj;
        }
        
    }
    public class SAPPricingWrapper{
        @AuraEnabled public Integer sequence_Number;
        @AuraEnabled Public string chargeName;
        @AuraEnabled Public string charged_Based_On;
        @AuraEnabled Public string condition_Type;
        @AuraEnabled Public Decimal rateD;
        @AuraEnabled Public string rateSTR;
        @AuraEnabled Public Decimal valueD;
        @AuraEnabled Public string valueSTR;
        @AuraEnabled Public Decimal modifiedRateD;
        @AuraEnabled Public string modifiedRateSTR;
        @AuraEnabled Public Decimal modifiedValueD;
        @AuraEnabled Public string modifiedValueSTR;
        @AuraEnabled Public Boolean isModified; 
        @AuraEnabled Public SAP_Pricing__c SAPRecord;
        @AuraEnabled Public string modifiedClass;
        @AuraEnabled Public Boolean isVisible;
        
        public SAPPricingWrapper(){
            
        }
        public SAPPricingWrapper(Decimal sq, string cName, string chargeBased, string conditn, decimal rate, decimal value, decimal mRate, decimal mValue, boolean isModify,SAP_Pricing__c spOBj, Boolean isVisible){
            this.sequence_Number = Integer.valueOf(sq);
            this.chargeName = cName;
            this.charged_Based_On = chargeBased;
            this.condition_Type = conditn;
            this.rateD = rate;
            this.rateSTR = INFormatR(rate);
            this.valueD = value;
            this.valueSTR = INFormatR(value);
            this.modifiedRateD = mRate;
            this.modifiedRateSTR = INFormatR(mRate);
            this.modifiedValueD = mValue;
            this.modifiedValueSTR = INFormatR(mValue);
            this.isModified = isModify;
            this.SAPRecord = spOBJ;
            if(isModify){
                modifiedClass = 'mClass';
            }else{
                modifiedClass = '';
            }
            this.isVisible = isVisible;
        }
    }
    public class PlanDetailsWrapper{
        @AuraEnabled public Integer milestone_no;
        @AuraEnabled Public string milestone_Name;
        @AuraEnabled Public Integer days_after_due;
        @AuraEnabled Public Date dueDateIn;
        @AuraEnabled Public string due_Date;
        @AuraEnabled Public string milestone_type;
        @AuraEnabled Public Decimal milestone_Percentage;
        @AuraEnabled Public string payment_group;
        @AuraEnabled Public boolean iseditable;
        @AuraEnabled Public decimal amountD;
        @AuraEnabled Public string amountSTR;
        @AuraEnabled Public Decimal SGST_D;
        @AuraEnabled Public String SGST_STR;
        @AuraEnabled Public Decimal CGST_D;
        @AuraEnabled Public String CGST_STR;
        @AuraEnabled Public Decimal total_GST_D;
        @AuraEnabled Public String total_GST_STR;
        @AuraEnabled Public Decimal milestone_Total_D;
        @AuraEnabled Public String milestone_Total_STR;
        @AuraEnabled Public Billing_Plan_Line_Item__c bpl_Item;
        @AuraEnabled Public boolean isRowAdjustable;
        @AuraEnabled Public string SAP_milestone_No;
        
        public PlanDetailsWrapper(){
            
        }
        
        public PlanDetailsWrapper(boolean is_editable,Integer seq_no, string milestoneName, Integer dueDays, date dueDate, string milestoneType, decimal percentage,
                                  string groupName, decimal amt, decimal sgst, decimal cgst, Billing_Plan_Line_Item__c bplObj, boolean isRowAdjustable, string SAP_milestone_No){
                                      this.milestone_no = seq_no;
                                      this.milestone_Name = milestoneName;
                                      this.days_after_due = dueDays;
                                      this.dueDateIn = dueDate;
                                      this.due_Date = dueDate.format();
                                      this.milestone_type =  milestoneType;
                                      this.milestone_Percentage = percentage;
                                      this.payment_group = groupName;
                                      this.iseditable = is_editable;
                                      this.amountD = amt;
                                      this.amountSTR = InFormatR(amt);
                                      this.SGST_D = sgst;
                                      this.SGST_STR = InFormatR(sgst);
                                      this.CGST_D = cgst;
                                      this.CGST_STR = InFormatR(cgst);
                                      this.total_GST_D = sgst + cgst;
                                      this.total_GST_STR = InFormatR(sgst + cgst);
                                      this.milestone_Total_D = amt + sgst + cgst;
                                      this.milestone_Total_STR = InFormatR(amt + sgst + cgst);  
                                      this.bpl_Item = bplObj;   
                                      this.isRowAdjustable = isRowAdjustable;                   
                                      this.SAP_milestone_No = SAP_milestone_No;
                                      
                                  }
    }
    /*public class NPVWrapper{
@AuraEnabled public Decimal NPVAmountD;
@AuraEnabled public Decimal NPVAmountPSFD;
@AuraEnabled public string NPVAmountSTR;
@AuraEnabled public string NPVAmountPSFSTR;

public NPVWrapper(){

}

}*/
    public class GSTWrapper{
        @AuraEnabled public Decimal CGST;
        @AuraEnabled public Decimal SGST;
        @AuraEnabled public Decimal totalGST;
        
        public GSTWrapper(){
            
        }
        
    }
    public class PaymentMilestoneWrapper{
        public string milestoneName {get;set;}
        public decimal milestonePercentage {get;set;}
        public string dueDate{get;set;}
        public decimal amountD{get;set;}
        public String amountSTR{get;set;}
        public Decimal CGST_D{get;set;}
        public string CGST_STR{get;set;}
        public Decimal SGST_D{get;set;}
        public string SGST_STR{get;set;}
        public Decimal totalGST_D{get;set;}
        public string totalGST_STR{get;set;}
        public Decimal totalMilestoneD{get;set;}
        public string totalMilestoneSTR{get;set;}
        public Boolean isCompletedMilestone{get;set;}
        public string paymentGroup {get;set;}
        public date dueDateINDATE{get;set;}
        public Integer dueDays {get;set;}
        public Boolean is_IN001Milestone{get;set;}
        public string Terms_of_Payment_Key{get;set;}
        ///////////////////////Added bu ashish For dispaly only///////////////
        public Decimal EffectiveAmountD{get;set;}
        public String EffectiveAmountS{get;set;}
        public Decimal GstForEffective{get;set;}
        public String GstForEffectiveS{get;set;}
        public Decimal TotalGstForEffective{get;set;}
        public String TotalGstForEffectiveS{get;set;}
        public Decimal TotalGstNamountD{get;set;}
        public String TotalGstNamountS{get;set;}
        public Decimal EtotalMilestoneD{get;set;}
        public string EtotalMilestoneSTR{get;set;}
        public PaymentMilestoneWrapper(){
            
        }
        
    }
}
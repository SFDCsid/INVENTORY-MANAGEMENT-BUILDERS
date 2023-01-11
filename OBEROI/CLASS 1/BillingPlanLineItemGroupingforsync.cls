public class BillingPlanLineItemGroupingforsync{

@AuraEnabled(cacheable=true)
    public static List<Payment_Plan__C> getBillingPlanList(string tId) {
        List<Payment_Plan__C> ppList = new List<Payment_Plan__C>();
        ppList = QuotationManagmentServices.getPlanList(tId);
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
    
   
    @AuraEnabled
    public static String saveQuotation(string planDetails, string carparkList, string fieldList){ ///, string selectedcarparks
     
        //List<QuotationManagmentServices.SAPPricingWrapper> avFinal = (List<QuotationManagmentServices.SAPPricingWrapper>)JSON.deserialize(AVList, List<QuotationManagmentServices.SAPPricingWrapper>.class);
        //List<QuotationManagmentServices.AdditionalChargesWrapper> otherChrgesList = (List<QuotationManagmentServices.AdditionalChargesWrapper>)JSON.deserialize(otherChrges, List<QuotationManagmentServices.AdditionalChargesWrapper>.class);
        //List<Discount__C> dList = (List<Discount__C>)JSON.deserialize(discountList, List<Discount__C>.class);
        List<QuotationManagmentServices.PlanDetailsWrapper> planList = (List<QuotationManagmentServices.PlanDetailsWrapper>)JSON.deserialize(planDetails, List<QuotationManagmentServices.PlanDetailsWrapper>.class);
        List<string> carparkMapCount = (List<string>)JSON.deserialize(carparkList, List<string>.class);
        
        system.debug('carparkList:: '+carparkList);
        //system.debug('avFinal:: '+avFinal);
        //system.debug('otherChrgesList:: '+otherChrgesList);        
        //system.debug('dList :: '+dList );
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
                return q.id;

   }
 }
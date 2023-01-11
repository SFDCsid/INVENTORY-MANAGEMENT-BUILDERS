public class CustomBillingPlanController {
    
    
    //Billing Plan Save
    @AuraEnabled
    public static string saveWrapperDetails(Id billingPlanId,list<Billing_Plan_Line_Item__c> bpLineList )
    {  
        system.debug('bpLineList'+bpLineList[0].Payment_Plan__c);
        system.debug('test');
        Integer timeLinkedCount =0;
        Integer TotalCount =0;
        Decimal TimeLinkedAmount =0.0;
        Decimal TimeLinkedPerc=0.0;
        Decimal percSum=0.0;
        Integer INCount = 0;   
        Integer CountGroup = 1;  
        Integer blankCount=0;
        Decimal percentageSum= 0.0;
        Integer percentageBlank =0;
        List<Id> listPropertyID = new List<Id>();
        //list<Billing_Plan_Sub_Line_Item__c> billingSubLineItems  = new list<Billing_Plan_Sub_Line_Item__c>();
        //map<Id,List<Billing_Plan_Sub_Line_Item__c>> mapBpliToSubLi = new map<Id,List<Billing_Plan_Sub_Line_Item__c>>();
        map<String,Integer> mapGroupToCount = new map<String, Integer>();
        List<Billing_Plan_Line_Item__c> listToUpsert= new List<Billing_Plan_Line_Item__c>();
        Set<String> uniqueKey= new Set<String>();
        Map<String,Billing_Plan_Line_Item__c> mapBillingPlanLineItems = new Map<String,Billing_Plan_Line_Item__c>();
        Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
        
        
        Payment_Plan__c PaymentPlanObj = [SELECT Property__c,Tower__c,Related_Jodi_Billing_Plan__c,Total_Sales_Amount_Time_of_Booking__c,Total_Sales_Amount__c
                                          FROM Payment_Plan__c WHERE Id=:billingPlanId];
        Payment_Plan__c DefaultBillingPlan = [SELECT Id FROM Payment_Plan__c
                                              WHERE Tower__c=:PaymentPlanObj.Tower__c
                                              AND RecordTypeId=:defaultRecordTypeId
                                              AND Active__c=true];
        for(Property__c propObj :[SELECT ID FROM Property__c WHERE Tower__c=:PaymentPlanObj.Tower__c]){
            listPropertyID.add(propObj.Id);
        }
       
        List<Payment_Plan_Line_Item__c> listPaymentPlanLineItem = [SELECT Id,Amount_Percent_BSP__c,Payment_Plan_Line_Item_Name__c,
                                                                           Percentage_Of_Value_To_Be_Invoiced__c,Order__c,
                                                                           Milestone_Number__c,Terms_of_Payment_Key__c,Payment_Group__c
                                                                            FROM Payment_Plan_Line_Item__c
                                                                           WHERE Payment_Plan__c=:DefaultBillingPlan.Id
                                                                           and Payment_Group__c =: 'IN'];
        system.debug('listPaymentPlanLineItem '+listPaymentPlanLineItem);
        if(listPaymentPlanLineItem.size()>0 && !listPaymentPlanLineItem.isEmpty()){
            for(Payment_Plan_Line_Item__c bpsliObj : listPaymentPlanLineItem){
                
                percSum = percSum+Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c);
                TotalCount = TotalCount+1;
                if((!bpsliObj.Milestone_Number__c.contains('1') && !bpsliObj.Milestone_Number__c.contains('2') &&
                    !bpsliObj.Milestone_Number__c.contains('3') && !bpsliObj.Milestone_Number__c.contains('4') &&
                    !bpsliObj.Milestone_Number__c.contains('5') && !bpsliObj.Milestone_Number__c.contains('6') &&
                    !bpsliObj.Milestone_Number__c.contains('7') && !bpsliObj.Milestone_Number__c.contains('8') &&
                    !bpsliObj.Milestone_Number__c.contains('9'))){
                        TimeLinkedCount= TimeLinkedCount+1;
                        TimeLinkedPerc = TimeLinkedPerc + Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c)  ;
                    }
            }
            
            
        }
        
        system.debug('percSum'+percSum);
        system.debug('TimeLinkedPerc'+TimeLinkedPerc);
        
        if(TimeLinkedPerc!=null){
            //TimeLinkedAmount = (TimeLinkedPerc * PaymentPlanObj.Total_Sales_Amount_Time_of_Booking__c)/100;
           TimeLinkedAmount = MATH.round((TimeLinkedPerc * PaymentPlanObj.Total_Sales_Amount__c)/100);
        }
        /*
        for(Billing_Plan_Sub_Line_Item__c bpsli : [SELECT Name,Billing_Plan_Sub_Line_Item_Name__c,Milestone_Number__c,Payment_Group__c,
                                                   Billing_Plan_Line_Item__c,Amount_Percent_BSP__c,Terms_of_Payment_Key__c,Percentage_Of_Value_To_Be_Invoiced__c 
                                                   FROM Billing_Plan_Sub_Line_Item__c
                                                   WHERE Billing_Plan_Line_Item__r.Payment_Plan__c =: billingPlanId]){
                                                       if(mapBpliToSubLi.containsKey(bpsli.Billing_Plan_Line_Item__c)){
                                                           mapBpliToSubLi.get(bpsli.Billing_Plan_Line_Item__c).add(bpsli);
                                                       } else{
                                                           mapBpliToSubLi.put(bpsli.Billing_Plan_Line_Item__c, new List<Billing_Plan_Sub_Line_Item__c>{bpsli});
                                                       }
                                                   }
        */
        /*
        if(mapBpliToSubLi.size()==null || mapBpliToSubLi.isEmpty()){
           
            billingSubLineItems=[SELECT Name,Billing_Plan_Sub_Line_Item_Name__c,Milestone_Number__c,Billing_Plan_Line_Item__c,Amount_Percent_BSP__c,
                                 Terms_of_Payment_Key__c,Percentage_Of_Value_To_Be_Invoiced__c, Payment_Group__c
                                 FROM Billing_Plan_Sub_Line_Item__c
                                 WHERE Billing_Plan_Line_Item__r.Payment_Plan__c =:DefaultBillingPlan.Id];
        }
        else
        //{
            System.debug('bpLineList --> '+bpLineList);           
            for(Billing_Plan_Line_Item__c bpli: bpLineList ){
                // To Update  
                System.debug('BPLI pay grp -- >'+bpli.Payment_Group__c);
                System.debug('bpli.Milestone_Number__c -- >'+(bpli.Milestone_Number__c >'0'));
                System.debug('mapBpliToSubLi -- >'+mapBpliToSubLi.get(bpli.Id));
                if(bpli.Payment_Group__c=='IN' && bpli.Milestone_Number__c >'0' && mapBpliToSubLi.get(bpli.Id)!=null){
                    //  system.debug('@@mapBpliToSubLi.get(bpli.Id)'+mapBpliToSubLi.get(bpli.Id));
                    billingSubLineItems = mapBpliToSubLi.get(bpli.Id); 
                }                  
            }    
        //} 
        */    
        /*
        if(billingSubLineItems.size()>0 && !billingSubLineItems.isEmpty()){
            for(Billing_Plan_Sub_Line_Item__c bpsliObj : billingSubLineItems){
                percSum = percSum+Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c);
                TotalCount = TotalCount+1;
                if((!bpsliObj.Milestone_Number__c.contains('1') && !bpsliObj.Milestone_Number__c.contains('2') &&
                    !bpsliObj.Milestone_Number__c.contains('3') && !bpsliObj.Milestone_Number__c.contains('4') &&
                    !bpsliObj.Milestone_Number__c.contains('5') && !bpsliObj.Milestone_Number__c.contains('6') &&
                    !bpsliObj.Milestone_Number__c.contains('7') && !bpsliObj.Milestone_Number__c.contains('8') &&
                    !bpsliObj.Milestone_Number__c.contains('9'))&& bpsliObj.Payment_Group__c == 'IN'){
                        TimeLinkedCount= TimeLinkedCount+1;
                        TimeLinkedPerc = TimeLinkedPerc + Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c)  ;
                    }
            }
            
            
        }
        
        system.debug('percSum'+percSum);
        system.debug('TimeLinkedPerc'+TimeLinkedPerc);
        
        if(TimeLinkedPerc!=null){
            //TimeLinkedAmount = (TimeLinkedPerc * PaymentPlanObj.Total_Sales_Amount_Time_of_Booking__c)/100;
           TimeLinkedAmount = MATH.round((TimeLinkedPerc * PaymentPlanObj.Total_Sales_Amount__c)/100);
        }
       
        */
        
        System.debug('bpLineListbpLineListbpLineList'+bpLineList);
        for(Billing_Plan_Line_Item__c billingLineItem : bpLineList ){
            
            if(billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c != null && billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c != ''){
                percentageSum = percentageSum  + Decimal.valueOf(billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c) ;
                System.debug('percentageSum -- > '+percentageSum);
                if(billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c=='0' || billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c=='0.0'){
                    percentageBlank = percentageBlank +1;
                }
            }
            
           
            if(billingLineItem.Payment_Plan_Line_Item_Name__c=='' || billingLineItem.Payment_Plan_Line_Item_Name__c==null||
               billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c=='' || billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c==null||
               billingLineItem.Due_After_Days__c==null){
                   blankCount=blankCount+1;
                  
               }
        }
        
        if(blankCount >0){
            return 'Missing Fields';
        }
        else if(percentageBlank >0){
            return 'Percentage zero';
        }
        else if(percentageSum!=100.00){
            return 'Percentage mismatch';
        }
        else{
            List<Billing_Plan_Line_Item__c > deleteExistingBillingPlanLineItem = [SELECT Id 
                                                                                  FROM Billing_Plan_Line_Item__c
                                                                                  WHERE Payment_Plan__c=:billingPlanId];
            system.debug('deleteExistingBillingPlanLineItemdeleteExistingBillingPlanLineItem'+deleteExistingBillingPlanLineItem);
            if(deleteExistingBillingPlanLineItem.size()>0 && !deleteExistingBillingPlanLineItem.isEmpty()){
                delete deleteExistingBillingPlanLineItem;
            }
            
            List<Payment_Term__c> listmetadata = getmetaData(billingPlanId);
            map<String,Payment_Term__c> mapNameToMetadata= new map<String,Payment_Term__c>();
            for(Payment_Term__c mdtValue :listmetadata){
                mapNameToMetadata.put(mdtValue.Name, mdtValue);
            }
            
            
            for(Billing_Plan_Line_Item__c planLineItem : bpLineList){
                Billing_Plan_Line_Item__c newItem = new Billing_Plan_Line_Item__c();
               
                
                
               if(planLineItem.Payment_Plan_Line_Item_Name__c.contains('Proportionate')){
                    
                   
                    
                  String PayLineTotal= planLineItem.Payment_Plan_Line_Item_Name__c.replace('N',String.valueOf(TotalCount));
                   string regex = '\\*';
                  String PayLineTime= PayLineTotal.replaceFirst(regex,String.valueOf(TimeLinkedCount));
                   newItem.Payment_Plan_Line_Item_Name__c= PayLineTime.replace('*',String.valueOf(TimeLinkedAmount));
                    
                }
                
                else{
                newItem.Payment_Plan_Line_Item_Name__c=planLineItem.Payment_Plan_Line_Item_Name__c;
                }
                system.debug('newItem.Description__c'+newItem.Description__c);
                system.debug('planLineItem.Description__c'+planLineItem.Description__c);
                system.debug('newItem.Payment_Plan_Line_Item_Name__c'+newItem.Payment_Plan_Line_Item_Name__c);
                system.debug('planLineItem.Payment_Plan_Line_Item_Name__c'+planLineItem.Payment_Plan_Line_Item_Name__c);
                
                
                if(planLineItem.Description__c.contains('Proportionate')){
                    newItem.Description__c = newItem.Payment_Plan_Line_Item_Name__c;
                }
                else{
                newItem.Description__c = planLineItem.Description__c;
                }
                
                
                
                
                
                newItem.Amount__c=planLineItem.Amount__c;
                if(newItem.Percentage_Of_Value_To_Be_Invoiced__c == null){
                newItem.Percentage_Of_Value_To_Be_Invoiced__c=planLineItem.Percentage_Of_Value_To_Be_Invoiced__c;
                }
                newItem.Sequence_Number__c = planLineItem.Sequence_Number__c;
                //To copy percentage value in number field to Roll up on billing Plan
                if(newItem.Percentage__c == null){
                newItem.Percentage__c=Decimal.valueOf(planLineItem.Percentage_Of_Value_To_Be_Invoiced__c);
                }
                newItem.Payment_Plan__c=billingPlanId;
                if(planLineItem.Order__c>0.0){
                    newItem.Order__c=planLineItem.Order__c;
                }
                else if(planLineItem.Payment_Plan_Line_Item_Name__c=='To be paid on or Before'){
                    newItem.Order__c=4;
                }
                else if(planLineItem.Payment_Plan_Line_Item_Name__c.contains('Proportionate ')){
                    newItem.Order__c=5;
                }
                else{
                    system.debug('planLineItem.Name'+planLineItem.Name);
                    newItem.Order__c=mapNameToMetadata.get(planLineItem.Terms_of_Payment_Key__c).Order__c;
                }
                newItem.Payment_Term_Order__c = newItem.Order__c;
                if(planLineItem.Milestone_Number__c!=null && planLineItem.Milestone_Number__c!=''){
                    newItem.Milestone_Number__c=planLineItem.Milestone_Number__c;
                }
                else{
                    newItem.Milestone_Number__c='000000000000';
                }
                
                system.debug('planLineItem.Terms_of_Payment_Key__c'+planLineItem.Terms_of_Payment_Key__c);
                if(planLineItem.Terms_of_Payment_Key__c!=null && planLineItem.Terms_of_Payment_Key__c!='' ){
                    newItem.Terms_of_Payment_Key__c=planLineItem.Terms_of_Payment_Key__c;
                    system.debug('planLineItem.Terms_of_Payment_Key__c'+newItem.Terms_of_Payment_Key__c);
                }
                else if(planLineItem.Payment_Plan_Line_Item_Name__c=='To be paid on or Before' && (planLineItem.Terms_of_Payment_Key__c==null || planLineItem.Terms_of_Payment_Key__c=='')){
                    newItem.Terms_of_Payment_Key__c='IN00';
                }
                else{
                    //newItem.Terms_of_Payment_Key__c=mapNameToMetadata.get(planLineItem.Name).Name;
                    newItem.Terms_of_Payment_Key__c=mapNameToMetadata.get(planLineItem.Terms_of_Payment_Key__c).Name;
                    //newItem.Terms_of_Payment_Key__c='IN00';
                }
                newItem.Due_After_Days__c=planLineItem.Due_After_Days__c;
                newItem.Payment_Plan_Line_Item_Name__c = planLineItem.Description__c;
                if(planLineItem.Description__c.contains('Proportionate')){
                    newItem.Payment_Plan_Line_Item_Name__c = newItem.Description__c;
                }
                newItem.Order__c = planLineItem.Sequence_Number__c;
                listToUpsert.add(newItem);
                
                
                
            }
                       
            if(listToUpsert.size()>0 && !listToUpsert.isEmpty()){
                system.debug('In');
                insert listToUpsert;
            }
            //UnComment for Jodi Billing Plan
            
            if(PaymentPlanObj.Related_Jodi_Billing_Plan__c != null && listToUpsert!=null && !listToUpsert.isEmpty()){
                insertJodiBillingLineItem(listToUpsert,PaymentPlanObj);
            }
            
           
            
            /*
            List<Billing_Plan_Sub_Line_Item__c> listExistingSublineItem = [SELECT Id
                                                                           FROM Billing_Plan_Sub_Line_Item__c
                                                                           WHERE Billing_Plan_Line_Item__r.Payment_Plan__c =:billingPlanId];
            if(listExistingSublineItem==null || listExistingSublineItem.isEmpty()){
                List<Payment_Plan_Line_Item__c> listPaymentPlanLineItem = [SELECT Id,Amount_Percent_BSP__c,Payment_Plan_Line_Item_Name__c,
                                                                           Percentage_Of_Value_To_Be_Invoiced__c,Order__c,
                                                                           Milestone_Number__c,Terms_of_Payment_Key__c,Payment_Group__c
                                                                            FROM Payment_Plan_Line_Item__c
                                                                           WHERE Payment_Plan__c=:DefaultBillingPlan.Id];
                system.debug('listPaymentPlanLineItem '+listPaymentPlanLineItem); 
                //insertSubLineItem(listPaymentPlanLineItem ,billingPlanId, DefaultBillingPlan);
            }
            */
            return 'Successful';
        }
    }
    
    @AuraEnabled
    public static void insertSubLineItem(List<Payment_Plan_Line_Item__c>paymentPlanLineItemList,Id billingPlanId, Payment_Plan__c DefaultBillingPlan){
        List<Billing_Plan_Line_Item__c> INLineItemId = [SELECT Id 
                           FROM Billing_Plan_Line_Item__c
                           WHERE Payment_Plan__c=:billingPlanId
                           AND Payment_Group__c='IN'];
                           //AND Line_Item_Type__c='Construction Linked'];
                           //
       map<string,Billing_Plan_Line_Item__c> mapBPL = new map<string,Billing_Plan_Line_Item__c>();
        
        for (Billing_Plan_Line_Item__c BPL:[SELECT Id,Line_Item_Type__c,Milestone_Number__c 
                           FROM Billing_Plan_Line_Item__c
                           WHERE Payment_Plan__c=:billingPlanId
                                            AND Payment_Group__c='IN']){
                                                if((!BPL.Milestone_Number__c.contains('1') && !BPL.Milestone_Number__c.contains('2') &&
                    !BPL.Milestone_Number__c.contains('3') && !BPL.Milestone_Number__c.contains('4') &&
                    !BPL.Milestone_Number__c.contains('5') && !BPL.Milestone_Number__c.contains('6') &&
                    !BPL.Milestone_Number__c.contains('7') && !BPL.Milestone_Number__c.contains('8') &&
                    !BPL.Milestone_Number__c.contains('9'))){
                           mapBPL.put('Time Linked',BPL); 
                    }
                                                else{
                                              mapBPL.put('Construction Linked',BPL);       
                                                }
                                            }
        
        system.debug('mapBPL'+mapBPL);
        
        if(INLineItemId.size()>0){
            List<Billing_Plan_Sub_Line_Item__c> bpSubLineItemList = new List<Billing_Plan_Sub_Line_Item__c>();
            for(Payment_Plan_Line_Item__c ppliIn: paymentPlanLineItemList){
                if(ppliIn.Payment_Group__c == 'IN'){
                    Billing_Plan_Sub_Line_Item__c newBpsli = new Billing_Plan_Sub_Line_Item__c();
                    if((!ppliIn.Milestone_Number__c.contains('1') && !ppliIn.Milestone_Number__c.contains('2') &&
                    !ppliIn.Milestone_Number__c.contains('3') && !ppliIn.Milestone_Number__c.contains('4') &&
                    !ppliIn.Milestone_Number__c.contains('5') && !ppliIn.Milestone_Number__c.contains('6') &&
                    !ppliIn.Milestone_Number__c.contains('7') && !ppliIn.Milestone_Number__c.contains('8') &&
                    !ppliIn.Milestone_Number__c.contains('9'))){
                    newBpsli.Billing_Plan_Line_Item__c = mapBPL.get('Time Linked').Id;
                    }
                    else{
                       newBpsli.Billing_Plan_Line_Item__c = mapBPL.get('Construction Linked').Id; 
                    }
                    newBpsli.Amount_Percent_BSP__c = ppliIn.Amount_Percent_BSP__c;
                    newBpsli.Billing_Plan_Sub_Line_Item_Name__c = ppliIn.Payment_Plan_Line_Item_Name__c;
                    newBpsli.Percentage_Of_Value_To_Be_Invoiced__c = ppliIn.Percentage_Of_Value_To_Be_Invoiced__c;
                    newBpsli.Order__c = ppliIn.Order__c;
                    newBpsli.Terms_of_Payment_Key__c = ppliIn.Terms_of_Payment_Key__c;
                    newBpsli.Payment_Group__c = ppliIn.Payment_Group__c;
                    newBpsli.Milestone_Number__c = ppliIn.Milestone_Number__c;
                    
                    
                    
                    bpSubLineItemList.add(newBpsli);
                }
            }
            if(bpSubLineItemList.size()>0 && !bpSubLineItemList.isEmpty()){
                insert bpSubLineItemList;
            }
        }
    }
    
    @AuraEnabled
    public static void insertJodiBillingLineItem(List<Billing_Plan_Line_Item__c> listBPLI, Payment_Plan__c PaymentPlanObj){
        
        List<Billing_Plan_Line_Item__c > existingJodiLineItem = [SELECT Id 
                                                                 FROM Billing_Plan_Line_Item__c 
                                                                 WHERE Payment_Plan__c=:PaymentPlanObj.Related_Jodi_Billing_Plan__c];
        if(existingJodiLineItem .size()>0 && !existingJodiLineItem .isEmpty()){
            delete existingJodiLineItem ;
        }
        //Added by Aditya For Proportionate of Jodi Start
        Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
        
        Payment_Plan__c ppObj = [SELECT Property__c,Tower__c,Related_Jodi_Billing_Plan__c,Total_Sales_Amount__c
                                          FROM Payment_Plan__c WHERE Id=:PaymentPlanObj.Related_Jodi_Billing_Plan__c];
        Payment_Plan__c DefaultBillingPlan = [SELECT Id FROM Payment_Plan__c
                                              WHERE Tower__c=:ppObj.Tower__c
                                              AND RecordTypeId=:defaultRecordTypeId
                                              AND Active__c=true];
        List<Payment_Plan_Line_Item__c> listPaymentPlanLineItem = [SELECT Id,Amount_Percent_BSP__c,Payment_Plan_Line_Item_Name__c,
                                                                           Percentage_Of_Value_To_Be_Invoiced__c,Order__c,
                                                                           Milestone_Number__c,Terms_of_Payment_Key__c,Payment_Group__c
                                                                            FROM Payment_Plan_Line_Item__c
                                                                           WHERE Payment_Plan__c=:DefaultBillingPlan.Id
                                                                           and Payment_Group__c =: 'IN'];
        system.debug('listPaymentPlanLineItem '+listPaymentPlanLineItem);
         Integer timeLinkedCount =0;
        Integer TotalCount =0;
        Decimal TimeLinkedAmount =0.0;
        Decimal TimeLinkedPerc=0.0;
        Decimal percSum=0.0;
        if(listPaymentPlanLineItem.size()>0 && !listPaymentPlanLineItem.isEmpty()){
            for(Payment_Plan_Line_Item__c bpsliObj : listPaymentPlanLineItem){
                percSum = percSum+Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c);
                TotalCount = TotalCount+1;
                if((!bpsliObj.Milestone_Number__c.contains('1') && !bpsliObj.Milestone_Number__c.contains('2') &&
                    !bpsliObj.Milestone_Number__c.contains('3') && !bpsliObj.Milestone_Number__c.contains('4') &&
                    !bpsliObj.Milestone_Number__c.contains('5') && !bpsliObj.Milestone_Number__c.contains('6') &&
                    !bpsliObj.Milestone_Number__c.contains('7') && !bpsliObj.Milestone_Number__c.contains('8') &&
                    !bpsliObj.Milestone_Number__c.contains('9'))){
                        TimeLinkedCount= TimeLinkedCount+1;
                        TimeLinkedPerc = TimeLinkedPerc + Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c)  ;
                    }
            }
        }
        system.debug('percSum'+percSum);
        system.debug('TimeLinkedPerc'+TimeLinkedPerc);
        if(TimeLinkedPerc!=null){
           TimeLinkedAmount = MATH.round((TimeLinkedPerc * ppObj.Total_Sales_Amount__c)/100);
        }
        
        //newItem.Payment_Plan_Line_Item_Name__c= PayLineTime.replace('*',String.valueOf(TimeLinkedAmount));
        //Added by Aditya for Proportionate of Jodi Stop
        List<Billing_Plan_Line_Item__c> listJodiBillingPlanInsert = new List<Billing_Plan_Line_Item__c>();
        for(Billing_Plan_Line_Item__c bpJodi: listBPLI){
            Billing_Plan_Line_Item__c bpliJodi = new Billing_Plan_Line_Item__c() ;
            bpliJodi.Payment_Plan__c = PaymentPlanObj.Related_Jodi_Billing_Plan__c;
            if(bpJodi.Description__c.contains('Proportionate')){
                String val = 'Proportionate N instalments upon casting of relevant slabs.Out of which * relevant slabs have been casted and the relevant amount of Rs. * towards the Sale Price is payable as below';
                String PayLineTotal= val.replace('N',String.valueOf(TotalCount));
                string regex = '\\*';
                String PayLineTime= PayLineTotal.replaceFirst(regex,String.valueOf(TimeLinkedCount));
               bpliJodi.Payment_Plan_Line_Item_Name__c=PayLineTime.replace('*',String.valueOf(TimeLinkedAmount));
               bpliJodi.Description__c=PayLineTime.replace('*',String.valueOf(TimeLinkedAmount));
            }
            else{
            bpliJodi.Payment_Plan_Line_Item_Name__c=bpJodi.Payment_Plan_Line_Item_Name__c;
            bpliJodi.Description__c=bpJodi.Description__c;}
            bpliJodi.Amount__c=bpJodi.Amount__c;
            bpliJodi.Due_After_Days__c=bpJodi.Due_After_Days__c;
            bpliJodi.Percentage_Of_Value_To_Be_Invoiced__c=bpJodi.Percentage_Of_Value_To_Be_Invoiced__c;
            bpliJodi.Order__c=bpJodi.Sequence_Number__c;
            bpliJodi.Milestone_Number__c=bpJodi.Milestone_Number__c;
            bpliJodi.Terms_of_Payment_Key__c=bpJodi.Terms_of_Payment_Key__c;
            bpliJodi.Sequence_Number__c=bpJodi.Sequence_Number__c;
            
            bpliJodi.Payment_Term_Order__c=bpJodi.Payment_Term_Order__c;
            listJodiBillingPlanInsert.add(bpliJodi);
        }
        insert listJodiBillingPlanInsert;
    }
    
    @AuraEnabled
    public static list<BillingPlanWrapper> getBillingPlanDetails(string bpID)
    {
        list<BillingPlanWrapper> bpWrapperList = new list<BillingPlanWrapper>();
        Opportunity opp =  getOpptyDetails(bpID);
        List<Payment_Term__c> metaGroupList = getmetaData(bpID);
        List<Billing_Plan_Line_Item__c> blList = billingLineItems(bpID);
        BillingPlanWrapper bpw = new BillingPlanWrapper(opp,blList,metaGroupList);
        system.debug(bpw+' *******');
        bpWrapperList.add(bpw);
        return bpWrapperList;
    }
    
    @AuraEnabled
    public static list<OppandProjectWrapper> OppProjDetailsWrapper(string oppID)
    {
        list<OppandProjectWrapper> bpProjWrapperList = new list<OppandProjectWrapper>();
        Opportunity opp =  getOpptyDetailswithID(oppId);
        Map<Id,List<Tower__c>> mapProjectIdtoTower = getTowerToProj();
        OppandProjectWrapper opw = new OppandProjectWrapper(opp,mapProjectIdtoTower);
        
        bpProjWrapperList.add(opw);
        return bpProjWrapperList;
    }
    
    //method to fetch tower associated to a project
    @AuraEnabled
    public static Map<Id,List<Tower__c>> getTowerToProj(){
        Map<Id,List<Tower__c>> mapProjectObjToTower = new Map<Id,List<Tower__c>>() ;
        for(Tower__c towObj : [SELECT Id,Project_Name__c,name FROM Tower__c]) {
            if (mapProjectObjToTower.containsKey(towObj.Project_Name__c))
            {
                mapProjectObjToTower.get(towObj.Project_Name__c).add(towObj);
            }
            else {
                mapProjectObjToTower.put(towObj.Project_Name__c, new List<Tower__c>{towObj});
            }
        }
        
        return mapProjectObjToTower;
    }
    
    //Method to fetch Opportunity details
    @AuraEnabled
    public static Opportunity getOpptyDetailswithID(string oppId){    
        Opportunity opp = [SELECT id,name,project__r.name, Default_Payment_Plan__c,project__c,Property__c,Property__r.name,recordtypeId FROM Opportunity where id =:OppId]; 
        return opp;
    }
    
    //Method to fetch data from Payment_Term__c
    @AuraEnabled
    public static list<Payment_Term__c> getmetaData(string bpID){
        Id towRecId = [SELECT Id,Tower__c FROM Payment_Plan__c WHERE Id =:bpID].Tower__c;
        system.debug('getmetaDatagetmetaData'+towRecId );
        Integer Mindicator = 0;
        Payment_Term__c[] groupingMappings = [SELECT Id, Name, Detailed_Description__c, Due_Days__c, Max_Occurrence__c,
            Min_Occurrence__c, Order__c, Tower__c, Type__c, Milestone_Indicator__c from Payment_Term__c WHERE Tower__c =: towRecId and Milestone_Indicator__c =: Mindicator];
        system.debug('groupingMappings'+groupingMappings);
        return groupingMappings;
    }
    
    //Method to fetch Opportunity details
    @AuraEnabled
    public static Opportunity getOpptyDetails(string bpID){    
        system.debug('bpId--'+bpId);
        Id OppId = [SELECT opportunity__c FROM Payment_Plan__c WHERE Id =:bpID].opportunity__c ;  
        system.debug('@@OppId'+OppId);  
        Opportunity opp = [SELECT id,name,project__r.name, Default_Payment_Plan__c,project__c,Property__c,Property__r.name,recordtypeId FROM Opportunity where id =:OppId]; 
        return opp;
    }
    
    //Method to fetch Billing Plan line item details from existing or from Default Billing Plan
    @AuraEnabled
    public static list<Billing_Plan_Line_Item__c> billingLineItems(string bpID){
        Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
        List<Billing_Plan_Line_Item__c> billingPlanLineItemList = new List<Billing_Plan_Line_Item__c>();
        Id towRecId = [SELECT Id,Tower__c 
                       FROM Payment_Plan__c
                       WHERE Id =:bpID].Tower__c;
        system.debug('towRecId--'+towRecId );
        Payment_Plan__c billingPlanObj = [SELECT Id, Tower__c
                                          FROM Payment_Plan__c
                                          WHERE Tower__c =:towRecId
                                          AND RecordTypeid =: defaultRecordTypeId
                                          AND Active__c = true];
        system.debug('@@billingPlanObj '+billingPlanObj );
        //Existing Billing Plan Lint Item
        List<Billing_Plan_Line_Item__c> existingBillingPlanLineItemList = [SELECT Id,Name,Amount__c,Payment_Plan_Line_Item_Name__c,Payment_Group__c,
                                                                           Percentage_Of_Value_To_Be_Invoiced__c, Milestone_Number__c,description__C,
                                                                           Terms_of_Payment_Key__c,Line_Item_Type__c,Order__c,Due_After_Days__c
                                                                           FROM Billing_Plan_Line_Item__c
                                                                           WHERE Payment_Plan__c =:bpID order by Order__c asc];
        
        
        if(existingBillingPlanLineItemList.size()>0){
            system.debug('existingBillingPlanLineItemList'+existingBillingPlanLineItemList);
            return existingBillingPlanLineItemList;
            
        }
        
        else{               
            // Default Billing Plan Line Item
            //Payment_Plan__c pp = [select id, Property__r.Total_Sales_Price__c from Payment_Plan__c  where Id =: bpID limit 1];
            //String totalSaleAmt = String.Valueof(pp.Property__r.Total_Sales_Price__c);
            //Decimal totalSaleAmt = pp.Property__r.Total_Sales_Price__c;
            //system.debug('totalSaleAmttotalSaleAmt'+totalSaleAmt);
            system.debug('@@billingPlanLineItemList'+billingPlanLineItemList);
            system.debug('@@billingPlanLineItemList'+billingPlanLineItemList.size());
            for (Billing_Plan_Line_Item__c BPL:[SELECT Id,Name,Amount__c,Payment_Plan_Line_Item_Name__c,Payment_Group__c,
                                       Percentage_Of_Value_To_Be_Invoiced__c, Milestone_Number__c,description__c,
                                       Terms_of_Payment_Key__c,Line_Item_Type__c,Order__c,Due_After_Days__c
                                       FROM Billing_Plan_Line_Item__c
                                       WHERE Payment_Plan__c =:billingPlanObj.Id order by Order__c asc]){
                BPL.description__c = BPL.Payment_Plan_Line_Item_Name__c;
                //BPL.Amount__c = (totalSaleAmt/100)*Decimal.Valueof(BPL.Percentage_Of_Value_To_Be_Invoiced__c);
                //system.debug('totalSaleAmttotalSaleAmt'+BPL.Amount__c);
                billingPlanLineItemList.add(BPL);
            }
            
        
        
            
            return billingPlanLineItemList;
        
        }
    }
    
    //Wrapper class for Oppty and Billing Plan Line Item List  
    public class BillingPlanWrapper {
        @AuraEnabled Public Opportunity oppObj { get; set;}
        @AuraEnabled Public list<Billing_Plan_Line_Item__c> bplitemList{get; set;}
        @AuraEnabled Public list<Payment_Term__c> metadataGroupingList{get;set;}
        
        
        public BillingPlanWrapper(Opportunity oppty ,list<Billing_Plan_Line_Item__c> bplList, 
                                  list<Payment_Term__c> mdgList) {
                                      oppObj = oppty;
                                      bplitemList = bplList;
                                      metadataGroupingList = mdgList ;
                                  }
    }
    
    //Wrapper class for Oppty and MapProjectToTower  
    public class OppandProjectWrapper {
        @AuraEnabled Public Opportunity oppObj { get; set;}
        @AuraEnabled Public Map<Id,List<Tower__c>> mapProjecttoTower{get;set;}
        
        public OppandProjectWrapper(Opportunity oppty ,Map<Id,List<Tower__c>> mapProjTow  ) {
            oppObj = oppty;
            mapProjecttoTower = mapProjTow;
        }
    }  
    
    // To save Billing Plan
    @AuraEnabled
    public static Id saveBillingPlan (Payment_Plan__c ppObj, Id oppId) {
        
        Id customizeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        ppObj.recordTypeId =customizeRecordTypeId ;
        ppObj.Opportunity__c= oppId;
        system.debug('@@ppObj--'+ppObj.recordTypeId );
        insert ppObj;
        //   ppObj =[SELECT Id,Opportunity__c,recordTypeId  FROM Payment_Plan__c WHERE ID=:ppObj.Id];
        system.debug('@@ppObj--'+ppObj);
        system.debug('@@ppObj--'+ppObj.Opportunity__c);
        return ppObj.Id;
    }
    
    // To delete Billing Plan record.
    @AuraEnabled
    public static void deleteBillingPlanOnCancel(Id ppObj){
        system.debug('Payment Plan Object to be deleted'+ppObj);
        Payment_Plan__c obj = new Payment_Plan__c();
        obj =[SELECT id,Name from Payment_Plan__c WHERE ID=:ppObj];
        delete obj;
    }
    
    //To Fetch Associated Billing Plan associated with one opportunity
    @AuraEnabled
    public static List<Payment_Plan__c> getBillingPlan(Id oppID){
        List<Payment_Plan__c> listPaymentPlan = new List<Payment_Plan__c>();
        for(Payment_Plan__c PayPlan: [SELECT ID,Name FROM Payment_Plan__c WHERE Opportunity__c=:oppID]){
            listPaymentPlan.add(PayPlan);
        }
        return listPaymentPlan;
    }
    
    // To Fetch Billing Plan Deatails
    @AuraEnabled
    public static Payment_Plan__c BillingPlanObj(Id bpId){
        system.debug('@@xx--'+bpId);
        Payment_Plan__c  ppObj = [SELECT Id,Basic_Cost_Formula__c,Basic_Cost_After_Discount_Formula__c,Floor_Rise_Cost_Formula__c,Floor_Rise_Cost_After_Discount_Formula__c,
                                  PLC_Cost_Formula__c,PLC_Cost_After_Discount_Formula__c,Total_Sales_Amount__c,Total_Sales_Amount_Time_of_Booking__c
                                  FROM Payment_Plan__c 
                                  WHERE Id=:bpId];
        return ppObj ;
        
    }
    
}
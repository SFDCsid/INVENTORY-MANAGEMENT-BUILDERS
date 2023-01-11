public class BookingController {
    //Billing Plan Save
    @AuraEnabled
    public static string saveWrapperDetails(Id billingPlanId,list<Billing_Plan_Line_Item__c> bpLineList )
    {  system.debug('Insert Call');
     Integer timeLinkedCount =0;
     Decimal TimeLinkedAmount =0.0;
     Decimal TimeLinkedPerc=0.0;
     Integer INCount = 0;   
     Integer CountGroup = 1;  
     Integer blankCount=0;
     Decimal percentageSum= 0.0;
     Integer percentageBlank =0;
     List<Id> listPropertyID = new List<Id>();
     list<Billing_Plan_Sub_Line_Item__c> billingSubLineItems  = new list<Billing_Plan_Sub_Line_Item__c>();
     map<Id,List<Billing_Plan_Sub_Line_Item__c>> mapBpliToSubLi = new map<Id,List<Billing_Plan_Sub_Line_Item__c>>();
     map<String,Integer> mapGroupToCount = new map<String, Integer>();
     List<Billing_Plan_Line_Item__c> listToUpsert= new List<Billing_Plan_Line_Item__c>();
     Set<String> uniqueKey= new Set<String>();
     Map<String,Billing_Plan_Line_Item__c> mapBillingPlanLineItems = new Map<String,Billing_Plan_Line_Item__c>();
     Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();
     
     system.debug('@@bpLineList --'+bpLineList );
     Payment_Plan__c PaymentPlanObj = [SELECT Property__c,Tower__c,Related_Jodi_Billing_Plan__c,Total_Sales_Amount_Time_of_Booking__c,Total_Sales_Amount__c FROM Payment_Plan__c WHERE Id=:billingPlanId];
     Payment_Plan__c DefaultBillingPlan = [SELECT Id FROM Payment_Plan__c WHERE Tower__c=:PaymentPlanObj.Tower__c AND RecordTypeId=:defaultRecordTypeId AND Active__c=true];
     for(Property__c propObj :[SELECT ID FROM Property__c WHERE Tower__c=:PaymentPlanObj.Tower__c]){
         listPropertyID.add(propObj.Id);
     }
     system.debug('billingPlan--'+billingPlanId);
     
     for(Billing_Plan_Sub_Line_Item__c bpsli : [SELECT Name,Billing_Plan_Sub_Line_Item_Name__c,Milestone_Number__c,Payment_Group__c,Billing_Plan_Line_Item__c,Amount_Percent_BSP__c,Terms_of_Payment_Key__c,Percentage_Of_Value_To_Be_Invoiced__c 
                                                FROM Billing_Plan_Sub_Line_Item__c WHERE Billing_Plan_Line_Item__r.Payment_Plan__c =: billingPlanId]){
                                                    if(mapBpliToSubLi.containsKey(bpsli.Billing_Plan_Line_Item__c)){
                                                        mapBpliToSubLi.get(bpsli.Billing_Plan_Line_Item__c).add(bpsli);
                                                    } else{
                                                        mapBpliToSubLi.put(bpsli.Billing_Plan_Line_Item__c, new List<Billing_Plan_Sub_Line_Item__c>{bpsli});
                                                    }
                                                }
     if(mapBpliToSubLi.size()==null || mapBpliToSubLi.isEmpty()){
         system.debug('default in');
         billingSubLineItems=[SELECT Name,Billing_Plan_Sub_Line_Item_Name__c,Milestone_Number__c,Billing_Plan_Line_Item__c,Amount_Percent_BSP__c,
                              Terms_of_Payment_Key__c,Percentage_Of_Value_To_Be_Invoiced__c, Payment_Group__c
                              FROM Billing_Plan_Sub_Line_Item__c WHERE Billing_Plan_Line_Item__r.Payment_Plan__c =:DefaultBillingPlan.Id];
     }
     else{
         system.debug('existing In');
         for(Billing_Plan_Line_Item__c bpli: bpLineList ){
             // To Update  
             if(bpli.Payment_Group__c=='IN' && bpli.Milestone_Number__c >'0' && mapBpliToSubLi.get(bpli.Id)!=null){
                 //  system.debug('@@mapBpliToSubLi.get(bpli.Id)'+mapBpliToSubLi.get(bpli.Id));
                 billingSubLineItems = mapBpliToSubLi.get(bpli.Id); 
             }                  
         }    
     } 
     system.debug('@@billingSubLineItems size -->'+billingSubLineItems.size() );   
     system.debug('@@billingSubLineItems -->'+billingSubLineItems );          
     
     if(billingSubLineItems.size()>0 && !billingSubLineItems.isEmpty()){
         for(Billing_Plan_Sub_Line_Item__c bpsliObj : billingSubLineItems){
             //  percSum = percSum+Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c);
             if((!bpsliObj.Milestone_Number__c.contains('1') && !bpsliObj.Milestone_Number__c.contains('2') && !bpsliObj.Milestone_Number__c.contains('3') && !bpsliObj.Milestone_Number__c.contains('4') &&
                 !bpsliObj.Milestone_Number__c.contains('5') && !bpsliObj.Milestone_Number__c.contains('6') && !bpsliObj.Milestone_Number__c.contains('7') && !bpsliObj.Milestone_Number__c.contains('8') &&
                 !bpsliObj.Milestone_Number__c.contains('9'))&& bpsliObj.Payment_Group__c == 'IN'){
                     TimeLinkedCount= TimeLinkedCount+1;
                     TimeLinkedPerc = TimeLinkedPerc + Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c)  ;
                 }
         }
         system.debug('@@TimeLinkedCount-->'+TimeLinkedCount);
         system.debug('@@TimeLinkedCount-->'+TimeLinkedPerc );
         
     }
     
     if(TimeLinkedPerc!=null){
         //TimeLinkedAmount = (TimeLinkedPerc * PaymentPlanObj.Total_Sales_Amount_Time_of_Booking__c)/100;
         TimeLinkedAmount = (TimeLinkedPerc * PaymentPlanObj.Total_Sales_Amount__c)/100;
     }
     system.debug('@@TimeLinkedAmount -->'+TimeLinkedAmount );
     //      system.debug('Amount---'+bookingObj.Billing_Plan__r.Total_Sales_Amount__c);
     /*  if(ppliObj.Payment_Plan_Line_Item_Name__c!=null || ppliObj.Payment_Plan_Line_Item_Name__c!=''){
if(ppliObj.Payment_Plan_Line_Item_Name__c.contains('Proportionate')){
INCount= INCount+1;
}
}
system.debug('@@INCount'+INCount); */
     
     
     
     for(Billing_Plan_Line_Item__c billingLineItem : bpLineList ){
         system.debug('@@mapGroupToCount'+mapGroupToCount);
         if(billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c != null && billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c != ''){
             percentageSum = percentageSum  + Decimal.valueOf(billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c) ;
             if(billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c=='0' || billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c=='0.0'){
                 percentageBlank = percentageBlank +1;
             }
         }
         /*   if(billingLineItem.Milestone_Number__c == '0'){
mapKey = billingLineItem.Payment_Group__c + '-' + '0';
//  billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
}else{
mapKey = billingLineItem.Payment_Group__c + '-' + '1';
//  billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c = '0';
} 
mapBillingPlanLineItems.put(mapKey, billingLineItem); */
         system.debug('@@billingLineItem.Payment_Plan_Line_Item_Name__c-->'+billingLineItem.Payment_Plan_Line_Item_Name__c);
         system.debug('@@billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c-->'+billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c);
         system.debug('@@billingLineItem.Due_After_Days__c-->'+billingLineItem.Due_After_Days__c);
         if(billingLineItem.Payment_Plan_Line_Item_Name__c=='' || billingLineItem.Payment_Plan_Line_Item_Name__c==null|| billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c=='' || billingLineItem.Percentage_Of_Value_To_Be_Invoiced__c==null || billingLineItem.Due_After_Days__c==null){
                blankCount=blankCount+1;
                system.debug('@@blankCount'+blankCount);
            }
     }
     
     if(blankCount >0){ return 'Missing Fields';
     }
     else if(percentageBlank >0){ return 'Percentage zero';
     }
     else if(percentageSum!=100.00){ return 'Percentage mismatch';
     }
     else{
         List<Billing_Plan_Line_Item__c > deleteExistingBillingPlanLineItem = [SELECT Id FROM Billing_Plan_Line_Item__c WHERE Payment_Plan__c=:billingPlanId];
         if(deleteExistingBillingPlanLineItem.size()>0 && !deleteExistingBillingPlanLineItem.isEmpty()){
             delete deleteExistingBillingPlanLineItem;
         }
         
         List<Payment_Term_Grouping__mdt> listmetadata = getmetaData();
         map<String,Payment_Term_Grouping__mdt> mapNameToMetadata= new map<String,Payment_Term_Grouping__mdt>();
         for(Payment_Term_Grouping__mdt mdtValue :listmetadata){
             mapNameToMetadata.put(mdtValue.Detailed_Description__c, mdtValue);
         }
         
         
         for(Billing_Plan_Line_Item__c planLineItem : bpLineList){
             Billing_Plan_Line_Item__c newItem = new Billing_Plan_Line_Item__c();
             if(planLineItem.Payment_Plan_Line_Item_Name__c.contains('Proportionate')){
                 system.debug('@@TimeLinkedCount-->'+TimeLinkedCount);
                 system.debug('@@TimeLinkedCount-->'+TimeLinkedPerc );
                 system.debug('billingSubLineItems.size() inside'+billingSubLineItems.size());
                 String PayLineTotal= planLineItem.Payment_Plan_Line_Item_Name__c.replace('[●]',String.valueOf(billingSubLineItems.size()));
                 system.debug('@@PayLineTotal-->'+PayLineTotal);
                 String PayLineTime= PayLineTotal.replace('[*]',String.valueOf(TimeLinkedCount));
                 system.debug('@@PayLineTime-->'+PayLineTime);
                 newItem.Payment_Plan_Line_Item_Name__c= PayLineTime.replace('[$]',String.valueOf(TimeLinkedAmount));
                 system.debug('@@'+newItem.Payment_Plan_Line_Item_Name__c);
             }
             else if(planLineItem.Payment_Plan_Line_Item_Name__c.contains('To be paid on or Before') ){
                 newItem.Payment_Plan_Line_Item_Name__c='To be paid on or Before';
             }
             else{
                 newItem.Payment_Plan_Line_Item_Name__c=planLineItem.Payment_Plan_Line_Item_Name__c;
             }
             newItem.Amount__c=planLineItem.Amount__c;
             newItem.Percentage_Of_Value_To_Be_Invoiced__c=planLineItem.Percentage_Of_Value_To_Be_Invoiced__c;
             newItem.Sequence_Number__c = planLineItem.Sequence_Number__c;
             //To copy percentage value in number field to Roll up on billing Plan
             newItem.Percentage__c=Decimal.valueOf(planLineItem.Percentage_Of_Value_To_Be_Invoiced__c);
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
                 system.debug('@@-->'+planLineItem.Payment_Plan_Line_Item_Name__c);
                 system.debug('@@-->'+mapNameToMetadata.get(planLineItem.Payment_Plan_Line_Item_Name__c));
                 if(mapNameToMetadata.get(planLineItem.Payment_Plan_Line_Item_Name__c)!=null){
                	 newItem.Order__c=mapNameToMetadata.get(planLineItem.Payment_Plan_Line_Item_Name__c).Order__c;
                  }
             }
             if(planLineItem.Milestone_Number__c!=null && planLineItem.Milestone_Number__c!=''){
                 newItem.Milestone_Number__c=planLineItem.Milestone_Number__c;
             }
             else{
                 newItem.Milestone_Number__c='0';
             }
             if(planLineItem.Terms_of_Payment_Key__c!=null && planLineItem.Terms_of_Payment_Key__c!='' ){
                 newItem.Terms_of_Payment_Key__c=planLineItem.Terms_of_Payment_Key__c;
             }
             else if(planLineItem.Payment_Plan_Line_Item_Name__c=='To be paid on or Before' && (planLineItem.Terms_of_Payment_Key__c==null || planLineItem.Terms_of_Payment_Key__c=='')){
                 newItem.Terms_of_Payment_Key__c='IN00';
             }
             else{
                 newItem.Terms_of_Payment_Key__c=mapNameToMetadata.get(planLineItem.Payment_Plan_Line_Item_Name__c).MasterLabel;
             }
             newItem.Due_After_Days__c=planLineItem.Due_After_Days__c;
             listToUpsert.add(newItem);
             // mapBillingPlanLineItems.put(mapKey,newItem);
             // uniqueKey.add(mapKey);
             // system.debug('uniqueKey--'+uniqueKey);
         }
         /*   for(String mKey : uniqueKey){
listToUpsert.add(mapBillingPlanLineItems.get(mKey));
mapBillingPlanLineItems.remove(mKey);
}
system.debug('listToUpsert'+listToUpsert);
//   system.debug('record to insert ---->> ' + listToUpsert.size()); */
         /*  if(!listToUpsert.isEmpty()){
system.debug('insert');
upsert new List<Billing_Plan_Line_Item__c>(listToUpsert);
system.debug('@@PaymentPlanObj.Related_Jodi_Billing_Plan__c'+PaymentPlanObj.Related_Jodi_Billing_Plan__c);*/
         system.debug('@@listToUpsert'+listToUpsert);
         if(listToUpsert.size()>0 && !listToUpsert.isEmpty()){
             system.debug('In');
             insert listToUpsert;
         }
         
         if(PaymentPlanObj.Related_Jodi_Billing_Plan__c != null && listToUpsert!=null && !listToUpsert.isEmpty()){
             insertJodiBillingLineItem(listToUpsert,PaymentPlanObj);
         }
         /* }
if(mapBillingPlanLineItems.values() != null && mapBillingPlanLineItems.values().size() > 0){
system.debug('@@mapBillingPlanLineItems.values()-->'+mapBillingPlanLineItems.values());
delete mapBillingPlanLineItems.values();
} */
         List<Billing_Plan_Sub_Line_Item__c> listExistingSublineItem = [SELECT Id FROM Billing_Plan_Sub_Line_Item__c WHERE Billing_Plan_Line_Item__r.Payment_Plan__c =:billingPlanId];
         if(listExistingSublineItem==null || listExistingSublineItem.isEmpty()){
             List<Payment_Plan_Line_Item__c> listPaymentPlanLineItem = [SELECT Id,Amount_Percent_BSP__c,Payment_Plan_Line_Item_Name__c,Percentage_Of_Value_To_Be_Invoiced__c,Order__c,
                                                                        Milestone_Number__c,Terms_of_Payment_Key__c,Payment_Group__c FROM Payment_Plan_Line_Item__c WHERE Payment_Plan__c=:DefaultBillingPlan.Id];
             insertSubLineItem(listPaymentPlanLineItem ,billingPlanId, DefaultBillingPlan);
         }
         return 'Successful';
     }
    }
    
    @AuraEnabled
    public static void insertSubLineItem(List<Payment_Plan_Line_Item__c>paymentPlanLineItemList,Id billingPlanId, Payment_Plan__c DefaultBillingPlan){
        Id INLineItemId = [SELECT Id FROM Billing_Plan_Line_Item__c WHERE Payment_Plan__c=:billingPlanId AND Payment_Group__c='IN' AND Line_Item_Type__c='Construction Linked'][0].Id;
        system.debug('@@INLineItemId>>>>>>>>>>>>>>>>>>>>'+INLineItemId  );
        if(INLineItemId!=null){
            List<Billing_Plan_Sub_Line_Item__c> bpSubLineItemList = new List<Billing_Plan_Sub_Line_Item__c>();
            for(Payment_Plan_Line_Item__c ppliIn: paymentPlanLineItemList){
                if(ppliIn.Payment_Group__c == 'IN'){
                    Billing_Plan_Sub_Line_Item__c newBpsli = new Billing_Plan_Sub_Line_Item__c();
                    newBpsli.Billing_Plan_Line_Item__c = INLineItemId;
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
        //    Id customizeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
        List<Billing_Plan_Line_Item__c > existingJodiLineItem = [SELECT Id FROM Billing_Plan_Line_Item__c WHERE Payment_Plan__c=:PaymentPlanObj.Related_Jodi_Billing_Plan__c];
        if(existingJodiLineItem .size()>0 && !existingJodiLineItem .isEmpty()){
            delete existingJodiLineItem ;
        }
        
        List<Billing_Plan_Line_Item__c> listJodiBillingPlanInsert = new List<Billing_Plan_Line_Item__c>();
        for(Billing_Plan_Line_Item__c bpJodi: listBPLI){
            Billing_Plan_Line_Item__c bpliJodi = new Billing_Plan_Line_Item__c() ;
            bpliJodi.Payment_Plan__c = PaymentPlanObj.Related_Jodi_Billing_Plan__c;
            bpliJodi.Payment_Plan_Line_Item_Name__c=bpJodi.Payment_Plan_Line_Item_Name__c;
            bpliJodi.Amount__c=bpJodi.Amount__c;
            bpliJodi.Due_After_Days__c=bpJodi.Due_After_Days__c;
            bpliJodi.Percentage_Of_Value_To_Be_Invoiced__c=bpJodi.Percentage_Of_Value_To_Be_Invoiced__c;
            bpliJodi.Order__c=bpJodi.Order__c;
            bpliJodi.Milestone_Number__c=bpJodi.Milestone_Number__c;
            bpliJodi.Terms_of_Payment_Key__c=bpJodi.Terms_of_Payment_Key__c;
            listJodiBillingPlanInsert.add(bpliJodi);
        }
        insert listJodiBillingPlanInsert;
    }
    
    @AuraEnabled
    public static list<BillingPlanWrapper> getBillingPlanDetails(string bpID)
    {
        list<BillingPlanWrapper> bpWrapperList = new list<BillingPlanWrapper>();
        Opportunity opp =  getOpptyDetails(bpID);
        List<Payment_Term_Grouping__mdt> metaGroupList = getmetaData();
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
        system.debug(opw+' *******');
        bpProjWrapperList.add(opw);
        return bpProjWrapperList;
    }
    
    //method to fetch tower associated to a project
    @AuraEnabled
    public static Map<Id,List<Tower__c>> getTowerToProj(){
        Map<Id,List<Tower__c>> mapProjectObjToTower = new Map<Id,List<Tower__c>>() ;
        for(Tower__c towObj : [SELECT Id,Project_Name__c,name FROM Tower__c]) {
            if (mapProjectObjToTower.containsKey(towObj.Project_Name__c)){
                mapProjectObjToTower.get(towObj.Project_Name__c).add(towObj);}
            
            else {mapProjectObjToTower.put(towObj.Project_Name__c, new List<Tower__c>{towObj});}
            
        }return mapProjectObjToTower;
    }
    
    //Method to fetch Opportunity details
    @AuraEnabled
    public static Opportunity getOpptyDetailswithID(string oppId){    
        Opportunity opp = [SELECT id,name,project__r.name, Default_Payment_Plan__c,project__c,Property__c,Property__r.name,recordtypeId FROM Opportunity where id =:OppId]; 
        return opp;
    }
    
    //Method to fetch meta data
    @AuraEnabled
    public static list<Payment_Term_Grouping__mdt> getmetaData(){
        Payment_Term_Grouping__mdt[] groupingMappings = [SELECT Detailed_Description__c, Max_Occurance__c, Min_Occurence__c,MasterLabel,Order__c FROM Payment_Term_Grouping__mdt];
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
        Id towRecId = [SELECT Id,Tower__c FROM Payment_Plan__c WHERE Id =:bpID].Tower__c;
        system.debug('towRecId--'+towRecId );
        Payment_Plan__c billingPlanObj = [SELECT Id, Tower__c FROM Payment_Plan__c WHERE Tower__c =:towRecId AND RecordTypeid =: defaultRecordTypeId AND Active__c = true];
        system.debug('@@billingPlanObj '+billingPlanObj );
        //Existing Billing Plan Lint Item
        List<Billing_Plan_Line_Item__c> existingBillingPlanLineItemList = [SELECT Id,Name,Amount__c,Payment_Plan_Line_Item_Name__c,Payment_Group__c,Percentage_Of_Value_To_Be_Invoiced__c, Milestone_Number__c, Terms_of_Payment_Key__c,Line_Item_Type__c,Order__c,Due_After_Days__c FROM Billing_Plan_Line_Item__c WHERE Payment_Plan__c =:bpID order by Order__c asc];
        if(existingBillingPlanLineItemList.size()>0){
            return existingBillingPlanLineItemList;
        }
        
        else{               
            // Default Billing Plan Line Item
            billingPlanLineItemList = [SELECT Id,Name,Amount__c,Payment_Plan_Line_Item_Name__c,Payment_Group__c,Percentage_Of_Value_To_Be_Invoiced__c, Milestone_Number__c,Terms_of_Payment_Key__c,Line_Item_Type__c,Order__c,Due_After_Days__c FROM Billing_Plan_Line_Item__c WHERE Payment_Plan__c =:billingPlanObj.Id order by Order__c asc];
            system.debug('@@billingPlanLineItemList'+billingPlanLineItemList);
            system.debug('@@billingPlanLineItemList'+billingPlanLineItemList.size());
            return billingPlanLineItemList;}
    }
    
    //Wrapper class for Oppty and Billing Plan Line Item List  
    public class BillingPlanWrapper {
        @AuraEnabled Public Opportunity oppObj { get; set;}
        @AuraEnabled Public list<Billing_Plan_Line_Item__c> bplitemList{get; set;}
        @AuraEnabled Public list<Payment_Term_Grouping__mdt> metadataGroupingList{get;set;}
        
        
        public BillingPlanWrapper(Opportunity oppty ,list<Billing_Plan_Line_Item__c> bplList, 
                                  list<Payment_Term_Grouping__mdt> mdgList) {
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
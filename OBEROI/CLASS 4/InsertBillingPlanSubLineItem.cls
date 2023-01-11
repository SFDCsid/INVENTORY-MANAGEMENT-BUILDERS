public class InsertBillingPlanSubLineItem {
    
    public static void InsertBillingPlanSubLineItemMethod(List<id> BillingPlanItemIdInserted){
        
        //Inserted
        List<Billing_Plan_Line_Item__c> ListBillingPlanItemInserted = [select id,Payment_Plan_Line_Item_Name__c,Payment_Plan__r.tower__r.Billing_Plan__c,
                                                                       payment_plan__r.Total_Sales_Amount__c,Payment_Group__c,description__c,payment_plan__r.recordtypeId
                                                                       from Billing_Plan_Line_Item__c where id in :BillingPlanItemIdInserted 
                                                                       and Payment_Group__c = 'In' 
                                                                      ];
      
        
        system.debug('ListBillingPlanItemInserted'+ListBillingPlanItemInserted);
        set<Id> SetBillingPlanItemInsertedwithproportionate = new set<id>() ; 
        Set<Id> SetBillingPlanItemRefered = new set<id>() ; 
        list<Billing_Plan_Line_Item__c> ListBPLI = new list<Billing_Plan_Line_Item__c>();
        id NonschemeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        Map<id,Id> mapinsertedrefred = new map<id,id>();
        for (Billing_Plan_Line_Item__c BPL:ListBillingPlanItemInserted){
            if(BPL.Payment_Plan_Line_Item_Name__c.contains('Proportionate') && BPL.Payment_Plan__r.tower__r.Billing_Plan__c != null &&
              BPL.Payment_Plan__r.recordtypeid == NonschemeId){
                system.debug('Inside for'+BPL.Payment_Plan__r.tower__r.Billing_Plan__c);
                SetBillingPlanItemInsertedwithproportionate.add(BPL.Id);
                SetBillingPlanItemRefered.add(BPL.Payment_Plan__r.tower__r.Billing_Plan__c);
                mapinsertedrefred.put(BPL.Id,BPL.Payment_Plan__r.tower__r.Billing_Plan__c);
                ListBPLI.add(BPL);
            }
        }
        
        system.debug('SetBillingPlanItemInsertedwithproportionate'+SetBillingPlanItemInsertedwithproportionate);
        system.debug('SetBillingPlanItemRefered'+SetBillingPlanItemRefered);
        system.debug('mapinsertedrefred'+mapinsertedrefred);
        
        //refered
        List<Billing_Plan_Line_Item__c> ListBillingPlanItemRefered = [select id,Payment_Plan_Line_Item_Name__c,Payment_Group__c
                                                                      from Billing_Plan_Line_Item__c where Payment_Plan__c in :SetBillingPlanItemRefered 
                                                                      and Payment_Group__c = 'In' 
                                                                     ];
        
        system.debug('ListBillingPlanItemRefered'+ListBillingPlanItemRefered);
        Set<Id> SetBillingPlanItemReferedwithproportionate = new set<id>(); 
        for (Billing_Plan_Line_Item__c BPL:ListBillingPlanItemRefered){
            if(BPL.Payment_Plan_Line_Item_Name__c.contains('Proportionate')){
                SetBillingPlanItemReferedwithproportionate.add(BPL.Id);
            }
        }
        
        system.debug('SetBillingPlanItemReferedwithproportionate'+SetBillingPlanItemReferedwithproportionate);
        //Inserted
        map<Id,Map<id,Billing_Plan_Sub_Line_Item__c>> MapBillingPlanSubItemRefered = new map<Id,map<id,Billing_Plan_Sub_Line_Item__c>>();
        for (Billing_Plan_Sub_Line_Item__c BPSL:[select id,name,Billing_Plan_Line_Item__r.Payment_Plan_Line_Item_Name__c,Billing_Plan_Sub_Line_Item_Name__c,Amount_Percent_BSP__c,
                                                 Percentage_Of_Value_To_Be_Invoiced__c,Order__c,Terms_of_Payment_Key__c,Payment_Group__c,Milestone_Number__c from  Billing_Plan_Sub_Line_Item__c
                                                 where Billing_Plan_Line_Item__c in :SetBillingPlanItemReferedwithproportionate]){
                                                     
                                                     if(!MapBillingPlanSubItemRefered.containsKey(BPSL.Billing_Plan_Line_Item__r.Id)){
                                                         MapBillingPlanSubItemRefered.put(BPSL.Billing_Plan_Line_Item__r.Id,new Map<id,Billing_Plan_Sub_Line_Item__c>());  
                                                     }
                                                     MapBillingPlanSubItemRefered.get(BPSL.Billing_Plan_Line_Item__r.Id).put(BPSL.id,BPSL);  
                                                 }
        
        
        system.debug('MapBillingPlanSubItemRefered'+MapBillingPlanSubItemRefered); 
        
        map<Id,map<id,Map<id,Billing_Plan_Sub_Line_Item__c>>> MapMapBillingPlanSubItemRefered = new map<Id,map<Id,map<id,Billing_Plan_Sub_Line_Item__c>>>();
        for (Billing_Plan_Sub_Line_Item__c BPSL:[select id,name,Billing_Plan_Line_Item__r.Payment_Plan__c,Billing_Plan_Sub_Line_Item_Name__c,Amount_Percent_BSP__c,
                                                 Percentage_Of_Value_To_Be_Invoiced__c,Order__c,Terms_of_Payment_Key__c,Payment_Group__c,Milestone_Number__c from  Billing_Plan_Sub_Line_Item__c
                                                 where Billing_Plan_Line_Item__c in :SetBillingPlanItemReferedwithproportionate]){
                                                     
                                                     if(!MapMapBillingPlanSubItemRefered.containsKey(BPSL.Billing_Plan_Line_Item__r.Payment_Plan__c)){
                                                         MapMapBillingPlanSubItemRefered.put(BPSL.Billing_Plan_Line_Item__r.Payment_Plan__c, new map<id,map<id,Billing_Plan_Sub_Line_Item__c>>());  
                                                     }
                                                     MapMapBillingPlanSubItemRefered.get(BPSL.Billing_Plan_Line_Item__r.Payment_Plan__c).put(BPSL.Billing_Plan_Line_Item__c,new map<id,Billing_Plan_Sub_Line_Item__c>());
                                                     
                                                     for (Billing_Plan_Sub_Line_Item__c MaBPSL: MapBillingPlanSubItemRefered.get(BPSL.Billing_Plan_Line_Item__c).values()){
                                                         MapMapBillingPlanSubItemRefered.get(BPSL.Billing_Plan_Line_Item__r.Payment_Plan__c).get(BPSL.Billing_Plan_Line_Item__c).put(MaBPSL.id,MaBPSL);   
                                                     }
                                                     
                                                 }
        
        
        map<string,Billing_Plan_Line_Item__c> nameBPL = new map<string,Billing_Plan_Line_Item__c>();
        
        for (Billing_Plan_Line_Item__c BPL:[select id,Payment_Plan_Line_Item_Name__c from  Billing_Plan_Line_Item__c
                                            where id in :SetBillingPlanItemReferedwithproportionate]){
                                                
                                                nameBPL.put(BPL.Payment_Plan_Line_Item_Name__c.substring(0,12),BPL);                                            
                                            }                                                
        
        system.debug('MapMapBillingPlanSubItemRefered'+MapMapBillingPlanSubItemRefered);
        system.debug('mapinsertedrefred'+mapinsertedrefred);
        system.debug('nameBPL'+nameBPL);
       
        list<Billing_Plan_Sub_Line_Item__c> newBPLS = new List<Billing_Plan_Sub_Line_Item__c>();
        for (Billing_Plan_Line_Item__c BPL:ListBPLI){
            for (Billing_Plan_Sub_Line_Item__c BPSL : MapMapBillingPlanSubItemRefered.get(mapinsertedrefred.get(BPL.Id)).get(nameBPL.get(BPL.Payment_Plan_Line_Item_Name__c.substring(0,12)).id).values()){
                
                Billing_Plan_Sub_Line_Item__c BP = new Billing_Plan_Sub_Line_Item__c();
                bp.Billing_Plan_Line_Item__c = BPL.Id;
                bp.Amount_Percent_BSP__c = BPSL.Amount_Percent_BSP__c;
                bp.Billing_Plan_Sub_Line_Item_Name__c = BPSL.Billing_Plan_Sub_Line_Item_Name__c;
                bp.Percentage_Of_Value_To_Be_Invoiced__c = BPSL.Percentage_Of_Value_To_Be_Invoiced__c;
                bp.Order__c = BPSL.Order__c;
                bp.Terms_of_Payment_Key__c = BPSL.Terms_of_Payment_Key__c;
                bp.Payment_Group__c = BPSL.Payment_Group__c;
                bp.Milestone_Number__c = BPSL.Milestone_Number__c;
                newBPLS.add(bp);
            }
            system.debug('newBPLS'+newBPLS);
            insert newBPLS;
        }
        
        Map<id,Map<id,Billing_Plan_Sub_Line_Item__c>> MapSubLiitm = new Map<id,Map<id,Billing_Plan_Sub_Line_Item__c>>();
        
        for (Billing_Plan_Sub_Line_Item__c BPSL: newBPLS){
            if(!MapSubLiitm.containsKey(BPSL.Billing_Plan_Line_Item__c)){
                MapSubLiitm.put(BPSL.Billing_Plan_Line_Item__c, new Map<id,Billing_Plan_Sub_Line_Item__c>());
            }
            MapSubLiitm.get(BPSL.Billing_Plan_Line_Item__c).put(BPSL.id,BPSL);
        }
        
        Integer timeLinkedCount =0;
        Decimal TimeLinkedAmount =0.0;
        Decimal TimeLinkedPerc=0.0;
        List<Billing_Plan_Line_Item__c> UpdateLineItem = new List<Billing_Plan_Line_Item__c>();
        for(Billing_Plan_Line_Item__c planLineItem : ListBillingPlanItemInserted){
            if(planLineItem.Payment_Plan_Line_Item_Name__c.contains('Proportionate')){
                
                String PayLineTotal= planLineItem.Payment_Plan_Line_Item_Name__c.replace('[●]',String.valueOf(MapSubLiitm.get(planLineItem.Id).values().size()));
                
                if(MapSubLiitm.get(planLineItem.Id).values().size()>0 && !MapSubLiitm.get(planLineItem.Id).values().isEmpty()){
                    for(Billing_Plan_Sub_Line_Item__c bpsliObj : MapSubLiitm.get(planLineItem.Id).values()){
                        //  percSum = percSum+Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c);
                        if((!bpsliObj.Milestone_Number__c.contains('1') && !bpsliObj.Milestone_Number__c.contains('2') &&
                            !bpsliObj.Milestone_Number__c.contains('3') && !bpsliObj.Milestone_Number__c.contains('4') &&
                            !bpsliObj.Milestone_Number__c.contains('5') && !bpsliObj.Milestone_Number__c.contains('6') &&
                            !bpsliObj.Milestone_Number__c.contains('7') && !bpsliObj.Milestone_Number__c.contains('8') &&
                            !bpsliObj.Milestone_Number__c.contains('9'))&& bpsliObj.Payment_Group__c == 'IN'){
                                TimeLinkedCount= TimeLinkedCount+1;
                                TimeLinkedPerc = TimeLinkedPerc + Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c)  ;
                                system.debug('TimeLinkedPerc'+TimeLinkedPerc);
                            }
                    }
                    
                    
                }
                
                if(TimeLinkedPerc!=null){
                    //TimeLinkedAmount = (TimeLinkedPerc * PaymentPlanObj.Total_Sales_Amount_Time_of_Booking__c)/100;
                    TimeLinkedAmount = (TimeLinkedPerc * planLineItem.payment_plan__r.Total_Sales_Amount__c)/100;
                }
                
                String PayLineTime= PayLineTotal.replace('[*]',String.valueOf(TimeLinkedCount));
                
                planLineItem.Payment_Plan_Line_Item_Name__c= PayLineTime.replace('[$]',String.valueOf(TimeLinkedAmount));
                
                
                
                UpdateLineItem.add(planLineItem);
                
            }
            
        }
        update UpdateLineItem;
        
        
        
        
        
    }
    
}
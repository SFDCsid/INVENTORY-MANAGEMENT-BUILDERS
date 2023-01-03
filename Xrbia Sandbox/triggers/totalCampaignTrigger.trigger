//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 13-10-2022
//-------------------------------------------//

trigger totalCampaignTrigger on Campaign__c (after insert,after update, after delete, after undelete) {
	set<Id> idSet = new set<Id>();
    List <Marketing_Vendor__c> actualCostList = new List <Marketing_Vendor__c>();
    List <Marketing_Vendor__c> amountPaidList = new List <Marketing_Vendor__c>();
    if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
        for(Campaign__c camp:trigger.new){
             idSet.add(camp.Marketing_Vendor__c);
        }
    }
    if(trigger.isUpdate || trigger.isDelete){
     	for(Campaign__c camp:trigger.old){
             idSet.add(camp.Marketing_Vendor__c);
        }
    }
    Map<Id,Decimal> campaignMap = new Map<Id,Decimal>();
    for(AggregateResult ar:[select Marketing_Vendor__c,SUM(Actual_Cost__c) costSum, SUM(Amount_Paid__c) amtPaid from Campaign__c where Marketing_Vendor__c IN:idSet GROUP BY Marketing_Vendor__c]){
        campaignMap.put((ID)ar.get('Marketing_Vendor__c'), double.valueOf(ar.get('costSum')));
    }
    
    for(Id ids:idSet){
        Marketing_Vendor__c mar = new Marketing_Vendor__c(id=ids);
        if(campaignMap.containsKey(ids)){
            mar.Total_Actual_Cost__c = campaignMap.get(ids);
        }
        else{
            mar.Total_Actual_Cost__c = 0;
        }
        actualCostList.add(mar);
        if(!actualCostList.isEmpty()){
            database.upsert(actualCostList,false);
        }
    }
    for(AggregateResult ar:[select Marketing_Vendor__c,SUM(Amount_Paid__c) amtPaid from Campaign__c where Marketing_Vendor__c IN:idSet GROUP BY Marketing_Vendor__c]){
        campaignMap.put((ID)ar.get('Marketing_Vendor__c'), double.valueOf(ar.get('amtPaid')));
    }
    for(Id ids:idSet){
        Marketing_Vendor__c mar = new Marketing_Vendor__c(id=ids);
        if(campaignMap.containsKey(ids)){
            mar.Total_Amount_Paid__c = campaignMap.get(ids);
        }
        else{
            mar.Total_Actual_Cost__c = 0;
        }
        amountPaidList.add(mar);
        if(!amountPaidList.isEmpty()){
            database.upsert(amountPaidList,false);
        }
    }
}
trigger OfferTrg on Offer__c (after insert,after update) {
    
    List<Offer__c> offerlist = new List<Offer__c>();

    Map<Id,Offer__c> OfferMap = new Map<Id,Offer__c>();
    if(Trigger.isInsert){
           
      if(Trigger.isAfter){
          for(Offer__c offer:Trigger.new){
              if(offer.Application__c!=null){
                   OfferMap.put(offer.Application__c,offer);
              } 
           }
      }

    }
    if(!OfferMap.isEmpty()){
        ApplicationHelper.updateOfferCreated(OfferMap);
    } 
    
    if(trigger.IsUpdate){
        if(trigger.IsAfter){
            for(Offer__c offer1:trigger.new){
                
                if(trigger.oldMap.get(offer1.Id).Approval_Status__c!=trigger.newMap.get(offer1.Id).Approval_Status__c && trigger.newMap.get(offer1.Id).Approval_Status__c=='Approved'){
                    offerlist.add(offer1);
                }
                                 
                }
               
            }
            if(!offerlist.isEmpty()){
               ApplicationHelper.OfferApprovedEmail(offerlist);
            }
        
        
    }
    }
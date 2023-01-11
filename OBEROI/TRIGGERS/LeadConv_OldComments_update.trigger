trigger LeadConv_OldComments_update on Lead (after update) {
    //list<lead> llist=new list<lead>();
    list<id> converted_opp_id=new list<id>();
    list<opportunity> converted_opportunity =new list<opportunity>();
    map<id,String> map_opp_comments=new map<id,String>();
    list<opportunity> update_converted_opportunity =new list<opportunity>();
    
    for(Lead l:Trigger.new){
        if(l.IsConverted == true && Trigger.oldMap.get(l.id).IsConverted == False){
            map_opp_comments.put(l.ConvertedOpportunityId,l.Old_Comments__c);
            converted_opp_id.add(l.ConvertedOpportunityId);
        }
    }
    
    if(converted_opp_id.size() > 0){
        converted_opportunity=[select id,Old_Comments__c,Related_Lead__r.Lead_Number__c,Internal_Comments__c 
                               FROM opportunity 
                               WHERE id IN :converted_opp_id];
        
        if(converted_opportunity.size() > 0){
            for(opportunity o :converted_opportunity){
                //if(String.isNotBlank(o.Old_Comments__c )){
                if(String.isBlank(o.Related_Lead__r.Lead_Number__c)){
                    o.Old_Comments__c+= '\n\n Old Lead Comments : \n' + map_opp_comments.get(o.id);
                    
                }
                else{ 
                    o.Old_Comments__c+= '\n\n Lead ('+o.Related_Lead__r.Lead_Number__c+') Comments : \n' + map_opp_comments.get(o.id);
                    
                }
                update_converted_opportunity.add(o);
                //}
            }
        }
    }
    if(update_converted_opportunity.size() > 0){
        update update_converted_opportunity;
    }
    
}
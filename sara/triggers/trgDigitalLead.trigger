trigger trgDigitalLead on Digital_Lead__c (after insert, after update) {
    Set<Id> digLeadId = new Set<Id>();
     
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            for(Digital_Lead__c dl : Trigger.new) {
                if(dl.Executed__c == false)
                    digLeadId.add(dl.Id);
            }
            system.debug('digLeadId: '+digLeadId);
            if(!digLeadId.isEmpty())
                DigitalLeadHandlerServices.fbLeadProcess(digLeadId);
        }
    }
    
    if(trigger.isAfter)
    {
        if(trigger.isUpdate)
        {
            for(Digital_Lead__c dl : trigger.new)
            {
                if(!dl.Executed__c)
                {
                    digLeadId.add(dl.Id);
                }
            }
            
            system.debug('digLeadId: '+digLeadId);
            if(!digLeadId.isEmpty())
                DigitalLeadHandlerServices.fbLeadProcess(digLeadId);
        }
    }
}
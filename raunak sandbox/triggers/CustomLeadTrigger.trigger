trigger CustomLeadTrigger on Lead_c__c (before insert, before update, after insert, after update) {
     if(trigger.isInsert)
    {
        if(trigger.isBefore)
        {
            for(Lead_c__c l: trigger.new)
            {
              //  if(!l.Legacy_Record__c)
             //   {
                    CustomDuplicationHandlerServices dcl = new  CustomDuplicationHandlerServices();
                    List<CustomDuplicationHandlerServices.duplicateWrapper> dupeWrapperList = new List<CustomDuplicationHandlerServices.duplicateWrapper>();
                    
                    dupeWrapperList = dcl.masterduplicateCalling(trigger.new);
                    system.debug('Duplicate wrapper List in trigger :: '+dupeWrapperList);
                    if(!dupeWrapperList.isEmpty())
                    {
                        system.debug('Wrapper is not empty ');
                        for(CustomDuplicationHandlerServices.duplicateWrapper dw: dupeWrapperList)
                        {
                            system.debug('Name::: '+dw.Name+' Record ID::' + dw.recordId);
                            for(Lead_c__c dl: trigger.new)
                            {
                                if(!test.isRunningTest())
                                    dl.addError('Duplicate Record Exist in system with Name '+dw.Name+'. Record Id is '+ dw.recordId);
                            }
                        }
                 //   }
                }
            }
        }
        if(Trigger.isAfter) {
            List<Lead_c__c> leadList = new List<Lead_c__c>();
            
           for(Lead_c__c l: trigger.new) {
                if(l.Campaign_Custom__c != Null) {
                    leadList.add(l);        
                }
            } 
            system.debug('leadList: '+leadList);
            if(!leadList.isEmpty())
                CampaignHandlerServices.calculateCampaignPerformance('Lead', LeadList, null);
        }
    }

  if(trigger.isUpdate)
   {
        if(trigger.isBefore)
        {
            CustomDuplicationHandlerServices dcl = new  CustomDuplicationHandlerServices();
            List<CustomDuplicationHandlerServices.duplicateWrapper> dupeWrapperList = new List< CustomDuplicationHandlerServices.duplicateWrapper>();
            
            for(Lead_c__c ll : trigger.new)
            {
                if(trigger.oldMap.get(ll.Id).isConverted__c) {
                    ll.addError('You are not allowed to make any changes on converted lead');
                } else {
                    if(trigger.oldMap.get(ll.id).Mobile__c != trigger.newMap.get(ll.Id).Mobile__c || 
                       trigger.oldMap.get(ll.id).Alternate_Mobile_No__c != trigger.newMap.get(ll.Id).Alternate_Mobile_No__c || 
                       trigger.oldMap.get(ll.id).Email__c != trigger.newMap.get(ll.Id).Email__c || 
                       trigger.oldMap.get(ll.id).Alternate_Email_Id__c != trigger.newMap.get(ll.Id).Alternate_Email_Id__c
                      ) {
                        dupeWrapperList = dcl.masterduplicateCalling(trigger.new);
                        system.debug('Duplicate wrapper List in trigger update :: '+dupeWrapperList);
                    }
                }
            }
            if(!dupeWrapperList.isEmpty())
            {
                system.debug('Wrapper is not empty in udpate ');
                for(CustomDuplicationHandlerServices.duplicateWrapper dw: dupeWrapperList)
                {
                    system.debug('update Name::: '+dw.Name+' Record ID::' + dw.recordId);

                    for(Lead_c__c dl: trigger.new)
                    {
                        if(!test.isRunningTest())
                        dl.addError('Duplicate Record Exist in system with name '+dw.name+'. Record Id is '+ dw.recordId);
                    }
                }
            }
            List<Lead_c__c> leadList = new List<Lead_c__c>();
            for(Lead_c__c ll : trigger.new)
            {
                if(trigger.oldMap.get(ll.Id).isConverted__c != trigger.newMap.get(ll.Id).isConverted__c && trigger.newMap.get(ll.Id).isConverted__c == true && ll.Lead_Stage__c != 'Visit Done') {
                    leadList.add(ll);
                } 
            }
            if(!leadList.isEmpty())
                LeadConversionServices.convertLead(leadList);
            
        }
       if(trigger.isAfter)
       {
           
       }
    }
}
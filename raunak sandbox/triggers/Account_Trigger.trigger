trigger Account_Trigger on Account (before insert, before update, after insert, after update) {
  
 /*   if(trigger.isInsert)
    {
        if(trigger.isBefore)
        {
           for(Account l: trigger.new)
            {
             
                    CustomDuplicationHandlerServices dcl1 = new  CustomDuplicationHandlerServices();
                    List<CustomDuplicationHandlerServices.duplicateWrapper> dupeWrapperList = new List<CustomDuplicationHandlerServices.duplicateWrapper>();
                    
                    dupeWrapperList = dcl1.accountMasterduplicateCalling(trigger.new);
                    system.debug('Duplicate wrapper List in trigger :: '+dupeWrapperList);
                    if(!dupeWrapperList.isEmpty())
                    {
                        system.debug('Wrapper is not empty ');
                        for(CustomDuplicationHandlerServices.duplicateWrapper dw: dupeWrapperList)
                        {
                            system.debug('Name::: '+dw.Name+' Record ID::' + dw.recordId);
                            for(Account dl: trigger.new)
                            {
                                if(!test.isRunningTest())
                                    dl.addError('Duplicate Record Exist in system with Name '+dw.Name+'. Record Id is '+ dw.recordId);
                            }
                        }
                
                }
            } 
        } 
    } 
      
       */

    if(trigger.isUpdate)
    {
        if(trigger.isBefore)
        {
            CustomDuplicationHandlerServices dcl = new CustomDuplicationHandlerServices();
            List<CustomDuplicationHandlerServices.duplicateWrapper> dupeWrapperList = new List<CustomDuplicationHandlerServices.duplicateWrapper>();
            for(Account aa : trigger.new)
            {
                if(trigger.oldMap.get(aa.id).PersonMobilePhone != trigger.newMap.get(aa.Id).PersonMobilePhone || trigger.oldMap.get(aa.id).Phone != trigger.newMap.get(aa.Id).Phone || trigger.oldMap.get(aa.id).PersonEmail != trigger.newMap.get(aa.Id).PersonEmail || trigger.oldMap.get(aa.id).Alternate_Email_Id__c != trigger.newMap.get(aa.Id).Alternate_Email_Id__c)
                {
                dupeWrapperList = dcl.accountMasterduplicateCalling(trigger.new);
                system.debug('Duplicate wrapper List in trigger update :: '+dupeWrapperList);
                }
            }
            if(!dupeWrapperList.isEmpty())
            {
                system.debug('Wrapper is not empty in udpate ');
                for(CustomDuplicationHandlerServices.duplicateWrapper dw: dupeWrapperList)
                {
                    system.debug('update name::: '+dw.name+' Record ID::' + dw.recordId);

                    for(Account da: trigger.new)
                    {
                        if(!test.isRunningTest())
                        da.addError('Duplicate Record Exist in system with name '+dw.name+'. Record Id is '+ dw.recordId);
                    }
                }
            }
        }
    } 

}
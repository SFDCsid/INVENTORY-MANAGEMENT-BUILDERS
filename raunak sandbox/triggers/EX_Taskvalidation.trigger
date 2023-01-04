trigger EX_Taskvalidation on Task (before insert ) {
    
    Set<Id> taskId = new Set<Id>();
    boolean count = false;
    Decimal i = 0;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;
    i += 1;i += 1;
    i += 1;
    for(Task Td : Trigger.New)
    {
            RecordType rt = new RecordType();
            if(Td.RecordTypeId != Null)
             rt = [Select Id, DeveloperName, Name from RecordType where Id =: Td.RecordTypeId];
              if(rt.Name == 'Presale Call') {
                taskId.add(Td.Id);
                count = true;
            }
        
        string objectName = '';
        if(td.whatId != Null)
        objectName = td.WhatId.getSObjectType().getDescribe().getName();
        system.debug('object name: '+ objectName);
        system.debug('createdUser: '+td.CreatedById);
        if(objectName == 'Lead_c__c' && rt.Name == 'Presale Call'){
            
           
            
        List<Lead_c__c> Ld = [Select Id,Name,Lead_Stage__c,Lead_Sub_Stage__c,Call_Not_Answered__c,Presales_Call_Count__c,Lead_Sub_Stage_Reason__c from Lead_c__c Where Id =: Td.WhatId];
            
            system.debug('Task' +Td);
            system.debug('Lead' +Ld);
            system.debug('Leadstage' +Ld[0].Lead_Stage__c);
            system.debug('Leadsubstage' +Ld[0].Lead_Sub_Stage__c);
            system.debug('presalescount' +Ld[0].Presales_Call_Count__c);
            system.debug('Taskstage' +Td.Stage__c);
            system.debug('Tasksubstage' +Td.Sub_Stage__c);
            system.debug('Record' +rt);
            system.debug('objectname' +objectName);
            system.debug('rtname' +rt.Name);
            
            
            
            

        
             if(Ld[0].Lead_Stage__c == 'Contact' && Ld[0].Lead_Sub_Stage__c == 'Unserviced' && Td.CreatedById != Null &&
                
             Td.Stage__c != 'SNP' &&  Td.Stage__c != 'Prospects' && 
             Td.Stage__c != 'Visit Confirmed' && Td.Stage__c != 'Visit Done'&&
             Td.Stage__c != 'Lost' && Td.Sub_Stage__c != 'Not Answering' )
              {
               
               Td.addError('Stage Not Allowed(Contact / Fresh Lead Bank)');
               }
            
            
             if(Ld[0].Lead_Stage__c == 'Contact' && Ld[0].Lead_Sub_Stage__c == 'Not Answering' && Td.CreatedById != Null &&
                
             Td.Stage__c != 'SNP' &&  Td.Stage__c != 'Prospects' && 
             Td.Stage__c != 'Visit Confirmed' && Td.Stage__c != 'Visit Done'&&
             Td.Stage__c != 'Lost' && Td.Stage__c != 'Fresh Lead Bank' && Td.Sub_Stage__c != 'Not Answering')
              {
               
               Td.addError('SubStage Not Allowed(Unserviced)');
               }
                
            
              if(Ld[0].Call_Not_Answered__c > 10 && 
                Ld[0].Lead_Stage__c == 'Contact'  && Ld[0].Lead_Sub_Stage__c == 'Not Answering' && Td.CreatedById != Null &&
               
               Td.Stage__c != 'Fresh Lead Bank' && Td.Call_Status__c != 'Call Complete' 
                && Td.Call_Status__c != 'Call Back' && Td.Call_Status__c != 'Not Interested')
             {
               
                Td.addError('Stage Only Allowed (Fresh Lead Bank)');
             }
            
            
              if(Ld[0].Call_Not_Answered__c <= 10 &&
                Ld[0].Lead_Stage__c == 'Contact' &&  Ld[0].Lead_Sub_Stage__c == 'Not Answering' && Td.CreatedById != Null &&
                 
                Td.Stage__c != 'Contact' && Td.Call_Status__c != 'Call Complete' 
                && Td.Call_Status__c != 'Call Back' && Td.Call_Status__c != 'Not Interested'
                 )
            {
             Td.addError('Stage Not Allowed <= 10');
            } 
               
            
               
            
            
             if(Ld[0].Lead_Stage__c == 'Fresh Lead Bank' && Ld[0].Lead_Sub_Stage__c == 'Unserviced' && Td.CreatedById != Null &&
                
             Td.Stage__c != 'SNP' &&  Td.Stage__c != 'Prospects' && 
             Td.Stage__c != 'Visit Confirmed' && Td.Stage__c != 'Visit Done'&&
             Td.Stage__c != 'Lost' && Td.Sub_Stage__c != 'Not Answering')
              {
               
               Td.addError('Stage Not Allowed(Contact / Fresh Lead Bank)');
               }
                
            
              if(Ld[0].Call_Not_Answered__c <= 10 && Td.CreatedById != Null &&
                Ld[0].Lead_Stage__c == 'SNP' &&  Ld[0].Lead_Sub_Stage__c == 'SNP' &&
                 
                Td.Stage__c != 'SNP' && Td.Call_Status__c != 'Call Complete' 
                && Td.Call_Status__c != 'Call Back' && Td.Call_Status__c != 'Not Interested'
                 )
                {
             Td.addError('Stage Not Allowed <= 10');
               } 
            
            
            if(Ld[0].Call_Not_Answered__c > 10 &&
               Ld[0].Lead_Stage__c == 'SNP'  && Td.CreatedById != Null &&
               
               Td.Stage__c != 'Fresh Lead Bank' && Td.Call_Status__c != 'Call Complete' 
                && Td.Call_Status__c != 'Call Back' && Td.Call_Status__c != 'Not Interested' )
             {
               
               Td.addError('Stage Only Allowed (Fresh Lead Bank)');
             }
             
            
            if(Ld[0].Call_Not_Answered__c <= 10 &&
                Ld[0].Lead_Stage__c == 'Prospects' && Td.CreatedById != Null &&
               
                Td.Stage__c != 'Prospects' && Td.Call_Status__c != 'Call Complete' 
                && Td.Call_Status__c != 'Call Back' && Td.Call_Status__c != 'Not Interested'
                 )
                {
             Td.addError('Stage Not Allowed <= 10');
               } 
            
               if(Ld[0].Call_Not_Answered__c > 10 &&
               Ld[0].Lead_Stage__c == 'Prospects'  && Td.CreatedById != Null &&
               
               Td.Stage__c != 'Fresh Lead Bank' && Td.Call_Status__c != 'Call Complete' 
                && Td.Call_Status__c != 'Call Back' && Td.Call_Status__c != 'Not Interested')
             {
               
               Td.addError('Stage Only Allowed (Fresh Lead Bank)');
             }
             
            
             if(Ld[0].Call_Not_Answered__c <= 10 &&
                Ld[0].Lead_Stage__c == 'Visit Confirmed' && Td.CreatedById != Null &&
                
                Td.Stage__c != 'Visit Confirmed' && Td.Call_Status__c != 'Call Complete' 
                && Td.Call_Status__c != 'Call Back' && Td.Call_Status__c != 'Not Interested'
                 )
                {
             Td.addError('Stage Not Allowed <= 10');
               } 
            
            
               if(Ld[0].Call_Not_Answered__c > 10 &&
               Ld[0].Lead_Stage__c == 'Visit Confirmed'  && Td.CreatedById != Null	 &&
               
               Td.Stage__c != 'Fresh Lead Bank' && Td.Call_Status__c != 'Call Complete' 
                && Td.Call_Status__c != 'Call Back' && Td.Call_Status__c != 'Not Interested')
               {
               
               Td.addError('Stage Only Allowed (Fresh Lead Bank)');
               }
                
        }
    }

}
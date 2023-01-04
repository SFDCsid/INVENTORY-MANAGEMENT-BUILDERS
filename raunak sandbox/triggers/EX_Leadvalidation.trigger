trigger EX_Leadvalidation on Lead_c__c (before update) {
    
  /*  for(Lead_c__c Ld : Trigger.New){
        
        if(trigger.oldMap.get(Ld.Id).Presales_Call_Count__c != trigger.newmap.get(Ld.Id).Presales_Call_Count__c &&
         trigger.oldMap.get(Ld.Id).Lead_Stage__c == 'Contact' && trigger.oldMap.get(Ld.Id).Lead_Sub_Stage__c == 'Unserviced' &&
         trigger.newmap.get(Ld.Id).Lead_Stage__c != 'SNP' &&  trigger.newmap.get(Ld.Id).Lead_Stage__c != 'Prospects' && 
         trigger.newmap.get(Ld.Id).Lead_Stage__c != 'Visit Confirmed' && trigger.newmap.get(Ld.Id).Lead_Stage__c != ' Visit Done'&&
         trigger.newmap.get(Ld.Id).Lead_Stage__c != 'Lost' )
        {
               
               
                Ld.addError('Stage Not Allowed(Contact / Fresh Lead Bank)');
           }
        
        
         if(trigger.oldMap.get(Ld.Id).Presales_Call_Count__c > 10 &&
            trigger.oldMap.get(Ld.Id).Lead_Stage__c == 'Contact' && trigger.oldMap.get(Ld.Id).Lead_Sub_Stage__c == 'Not Answering'&&
            trigger.oldMap.get(Ld.Id).Lead_Sub_Stage_Reason__c	 == 'Switched off,not reachable, not answering'&& 
            trigger.newmap.get(Ld.Id).Lead_Stage__c != 'Fresh Lead Bank')
        {
               
               
                Ld.addError('Stage Only Allowed (Fresh Lead Bank)');
           }
        
        
          if(trigger.oldMap.get(Ld.Id).Presales_Call_Count__c <= 10 &&
             //trigger.oldMap.get(Ld.Id).Lead_Stage__c !=  trigger.newmap.get(Ld.Id).Lead_Stage__c &&
             trigger.oldMap.get(Ld.Id).Lead_Stage__c == 'Contact' &&  trigger.oldMap.get(Ld.Id).Lead_Sub_Stage__c == 'Not Answering' &&
             trigger.oldMap.get(Ld.Id).Lead_Stage__c != 'Contact'
             )
          {
               
               
                Ld.addError('Stage Not Allowed <= 10');
           } 
         
        
        if(trigger.oldMap.get(Ld.Id).Presales_Call_Count__c != trigger.newmap.get(Ld.Id).Presales_Call_Count__c &&
           trigger.oldMap.get(Ld.Id).Lead_Stage__c == 'Fresh Lead Bank' && trigger.oldMap.get(Ld.Id).Lead_Sub_Stage__c == 'Unserviced' &&
           trigger.newmap.get(Ld.Id).Lead_Stage__c != 'SNP' &&  trigger.newmap.get(Ld.Id).Lead_Stage__c != 'Prospect' && 
           trigger.newmap.get(Ld.Id).Lead_Stage__c != 'Visit Confirmed' && trigger.newmap.get(Ld.Id).Lead_Stage__c != ' Visit Done'&&
           trigger.newmap.get(Ld.Id).Lead_Stage__c != 'Lost')
        {
               
               
                Ld.addError('Stage Not Allowed (Contact / Fresh Lead Bank)');
           }
        
        
         if(trigger.oldMap.get(Ld.Id).Presales_Call_Count__c > 10 &&
            trigger.oldMap.get(Ld.Id).Lead_Stage__c == 'SNP' && trigger.oldMap.get(Ld.Id).Lead_Sub_Stage__c == 'SNP'&&
            trigger.newmap.get(Ld.Id).Lead_Stage__c != 'Fresh Lead Bank')
        {
               
               
                Ld.addError('Stage Only Allowed (Fresh Lead Bank)');
           }
        
        
            if(trigger.oldMap.get(Ld.Id).Presales_Call_Count__c > 10 &&
               trigger.oldMap.get(Ld.Id).Lead_Stage__c == 'Prospects' && 
               trigger.oldMap.get(Ld.Id).Lead_Sub_Stage__c  != trigger.newMap.get(Ld.Id).Lead_Sub_Stage__c && 
              trigger.newmap.get(Ld.Id).Lead_Stage__c != 'Fresh Lead Bank')
             {
               
               Ld.addError('Stage Only Allowed (Fresh Lead Bank)');
            } 
        
        
              if(trigger.oldMap.get(Ld.Id).Presales_Call_Count__c > 10 &&
               trigger.oldMap.get(Ld.Id).Lead_Stage__c == 'Visit Confirmed' && trigger.oldMap.get(Ld.Id).Lead_Sub_Stage__c == 'Visit Confirmed'&&
              trigger.newmap.get(Ld.Id).Lead_Stage__c != 'Fresh Lead Bank')
             {
               
               Ld.addError('Stage Only Allowed (Fresh Lead Bank)');
            } 


              if(trigger.oldMap.get(Ld.Id).Presales_Call_Count__c <= 10 &&
             //trigger.oldMap.get(Ld.Id).Lead_Stage__c !=  trigger.newmap.get(Ld.Id).Lead_Stage__c &&
             trigger.oldMap.get(Ld.Id).Lead_Stage__c == 'SNP' &&  trigger.oldMap.get(Ld.Id).Lead_Sub_Stage__c == 'SNP' &&
             trigger.oldMap.get(Ld.Id).Lead_Stage__c != 'SNP'
             )
             {
               
               
                Ld.addError('Stage Not Allowed <= 10');
             } 


                if(trigger.oldMap.get(Ld.Id).Presales_Call_Count__c <= 10 &&
             //trigger.oldMap.get(Ld.Id).Lead_Stage__c !=  trigger.newmap.get(Ld.Id).Lead_Stage__c &&
                  trigger.oldMap.get(Ld.Id).Lead_Stage__c == 'Visit confirmed' &&  trigger.oldMap.get(Ld.Id).Lead_Sub_Stage__c == 'Visit confirmed' &&
                  trigger.oldMap.get(Ld.Id).Lead_Stage__c != 'Visit confirmed'
             )
             {
               
               
                Ld.addError('Stage Not Allowed <= 10');
              } 


              if(trigger.oldMap.get(Ld.Id).Presales_Call_Count__c <= 10 &&
             //trigger.oldMap.get(Ld.Id).Lead_Stage__c !=  trigger.newmap.get(Ld.Id).Lead_Stage__c &&
                 trigger.oldMap.get(Ld.Id).Lead_Stage__c == 'Prospects' &&  
                 trigger.oldMap.get(Ld.Id).Lead_Sub_Stage__c  != trigger.newMap.get(Ld.Id).Lead_Sub_Stage__c &&
                 trigger.oldMap.get(Ld.Id).Lead_Stage__c != 'Prospects'
             )
             {
               
               
                Ld.addError('Stage Not Allowed <= 10');
              } 
        
        
    } */

}
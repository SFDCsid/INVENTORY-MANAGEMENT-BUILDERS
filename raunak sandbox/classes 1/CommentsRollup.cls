public class CommentsRollup {
    
    public static void SMCommentsRollup(String opid,String svmid)
    {
        
        List<Opportunity_c__c>  oppList = new  List<Opportunity_c__c>();
        
        oppList = [select Id,Name,SM_Comment__c from Opportunity_c__c where Id =:opid];
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
        
       if(oppList[0].SM_Comment__c == null)
           
       {
           oppList[0].SM_Comment__c ='';
       }
        
        oppList[0].SM_Comment__c = oppList[0].SM_Comment__c +'\n'+string.ValueOf(myDate)+': '+svmid;

        Update oppList;
        
    }
    

    
}
public class Date_Time {
    Public Lead leadRecord{Get; Set;}
    Public Lead leadTemp{Get; Set;}
    Public Boolean isNull{Get; Set;}
    
    
    public Date_Time()
    {
        isNull = true;
        leadRecord = new Lead();
        leadTemp = new Lead();
        id leadId = ApexPages.currentPage().getParameters().get('id');
        string email = ApexPages.currentPage().getParameters().get('email');
        leadRecord = [SELECT Id, Email, Date_of_Site_Visit__c FROM Lead where id=:leadId];
        leadTemp.Date_of_Site_Visit__c = leadRecord.Date_of_Site_Visit__c;
        isNull = leadRecord == null? True : false;
        
    }
    
    Public PageReference Save()
    {
        system.debug('InnerSave');
        try{
            system.debug('InnerTry');
            //leadRecord.Date_of_Site_Visit__c = System.now();
            leadRecord.Date_of_Site_Visit__c = leadTemp.Date_of_Site_Visit__c;
            Update leadRecord;
            PageReference pg = Page.Thankyou;
            //pg.setRedirect(true);
            return pg;
        }catch(DMLException ex){
            System.debug('Error :'+ex.getMessage());
            Return Null;
        }
       
    }

}
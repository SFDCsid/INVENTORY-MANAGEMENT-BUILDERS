public class Dialercontroller {
    public  string leadIds= '';
    public Dialercontroller(ApexPages.StandardSetController controller){  
        for(sobject  so : controller.getSelected()){
            leadIds = leadIds +',' + so.get('id');
            
        }  
    } 
    public pagereference direct(){
                 string userId =  userinfo.getUserId();
                 User   u = [select id,massdialerIds__c from User where id=:userId];
                 u.massdialerIds__c = leadIds;
                 update u;
                 pagereference p =new pagereference('/lightning/n/Dialer?0.source=alohaHeader');  
                 return p;
    } 
   
}
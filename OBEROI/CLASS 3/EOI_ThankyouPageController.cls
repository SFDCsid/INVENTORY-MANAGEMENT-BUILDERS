public class EOI_ThankyouPageController {
    Public Id eoId {get;set;}
    Public Boolean iscp {get;set;}
    Public Boolean isrp {get;set;}
    Public String unique {get;set;}
    
    public  EOI_ThankyouPageController(){
        isrp = false;
        iscp = false;
        eoId = apexpages.currentpage().getparameters().get('eoId');
        Eoi__c eo = [Select Id,Name,Is_Channel_Partner_EOI__c From Eoi__c Where Id =: eoId];
        
        if(eo != null){
            unique = eo.Name;
            if(eo.Is_Channel_Partner_EOI__c == true){
                iscp = true;
            }else{
                isrp = true; 
            }
        }
    }
}
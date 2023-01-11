public class OzonetelCallDisposition {
    
    @InvocableMethod(label='CallDispositionAPI')
    public static void sendDisposition(List<Id> tskId){
        getTask(tskId);
    }
    
    @future (callout = true)
    public static void getTask(List<Id> tskId){
        Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        
        List<Task> tskList = new List<Task>();
        tskList = [Select Id, DID__c,Description__c ,Description,CallObject, Agent_ID__c 
                   From Task
                   Where Id IN : tskId];
        system.debug('TaskList::'+tskList);
        
        string customer='oberoi_poc';
        string api='KK8a62f972ff547cbbfcca385f101f8846';
        
        
        
        
        for(Task tk : tskList){
            String Enquiry = EncodingUtil.urlEncode(tk.Description__c, 'UTF-8');
            system.debug('Enquiry '+Enquiry);
            String Discription = EncodingUtil.urlEncode(tk.Description,'UTF-8');
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setEndpoint('https://in1-ccaas-api.ozonetel.com/CAServices/Disposition/DispositionAPI.php?customer='+customer+'&agentID='+tk.Agent_ID__c+'&apiKey='+api+'&did='+tk.DID__c+'&comments='+Discription+'&ucid='+tk.CallObject+'&action=set&disposition='+Enquiry);
            try{
                system.debug('request : '+ request);
                response=http.send(request);
                System.debug('Response Body : '+response.getBody());
                system.debug('Response : '+response);
                system.debug('Response : '+response.getStatus());
            }catch(System.Exception e){
                System.debug('Exception:- '+e.getMessage());
            }
        }
    }
}
public class FutureClass2 {
    
   /* @future(callout=true)
    public static void ZeroBounce(Id accId){
        Account acc = [SELECT Id,PersonEmail FROM Account WHERE Id=:accId];
        HttpRequest req = new HttpRequest(); 
        req.setMethod('GET');
        req.setEndpoint('https://api.zerobounce.net/v2/validate?api_key=0fb06213bb4a45108489a039525aaf84&email='+acc.PersonEmail); 
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Map<String, String> values = (Map<String, String>)
            JSON.deserialize(res.getBody(), Map<String, String>.class);
        String Status = values.get('status');
        String Sub_Status = values.get('sub_status');
        If(Status == 'valid'){
            acc.Is_Email_Validated__c = true;
            acc.Email_Status__c = Status;
            acc.Email_Sub_Status__c = Sub_Status;
        }else{
            acc.Email_Status__c = Status;
            acc.Email_Sub_Status__c = Sub_Status;
        }
        acc.Email_Validated_On__c = System.now();
		acc.On_Demand_Email_Check__c = false;        
        update acc;
    }    */
}
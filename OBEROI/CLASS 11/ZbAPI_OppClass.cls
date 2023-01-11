public class ZbAPI_OppClass {
    
    @future(callout=true)
    public static void ZeroBounce2(Id oppId){
        String jsonResponse;
        Opportunity opp = [SELECT Id,Email__c FROM Opportunity WHERE Id=:oppId];
        HttpRequest req = new HttpRequest(); 
        req.setMethod('GET');
        req.setEndpoint('https://api.zerobounce.net/v2/validate?api_key=8272ff0b1400478292076b7e093429ff&email='+opp.Email__c); 
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        if(!Test.isRunningTest()){
            res = http.send(req);
            System.debug('response:::' + res.getBody());
            jsonResponse = res.getBody();
        }
        else{
            jsonResponse = '{"address":"yashhwanii@stetig.in","status":"valid","sub_status":"mailbox_not_found","free_email":false,"did_you_mean":null,"account":"yashhwanii","domain":"stetig.in","domain_age_days":"2628","smtp_provider":"g-suite","mx_found":"true","mx_record":"aspmx.l.google.com","firstname":null,"lastname":null,"gender":null,"country":null,"region":null,"city":null,"zipcode":null,"processed_at":"2021-08-25 08:59:49.159"}';
        }
        Map<String, String> values = (Map<String, String>)
        JSON.deserialize(jsonResponse, Map<String, String>.class);
        String Status = values.get('status');
        String Sub_Status = values.get('sub_status');
        If(Status == 'valid'){
            opp.Is_Email_Validated__c = true;
            opp.Email_Status__c = Status;
            opp.Email_Sub_Status__c = Sub_Status;
        }else{
            opp.Email_Status__c = Status;
            opp.Email_Sub_Status__c = Sub_Status;
        }
        opp.Email_Validated_On__c = System.now();
        opp.On_Demand_Email_Check__c = false;        
        update opp;
    }    
}
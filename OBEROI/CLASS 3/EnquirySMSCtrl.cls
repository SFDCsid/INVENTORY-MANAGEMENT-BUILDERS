global class EnquirySMSCtrl{
   
   @future(Callout = True)
    global static void sendSMS(String url){
    // Instantiate a new http object
        Http h = new Http();

    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');

    // Send the request, and return a response
       String resBody = '';
       if(!Test.isRunningTest()){     
            HttpResponse res = h.send(req);
            resBody = res.getBody();  
           System.debug('resBody'+resBody);
       } 
   }
}
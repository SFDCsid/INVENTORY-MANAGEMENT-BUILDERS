public class CallCustomerController {
    @AuraEnabled
    public static String callAPI(String customerPh, String countryCode){
        
        system.debug('click2CallCloudagent');
        system.debug('customerPh from page::: ' + customerPh);
        system.debug('countryCode from page::: ' + countryCode);
        String campaignName = '';
        String userName = '';
        String apiKey = '';
        String agentId = '';
        
        if(customerPh.length() == 10 && (countryCode == '' || countryCode.equals('+91') || countryCode.equals('91') || countryCode.equals('0091') || countryCode.equals('091'))){          
            customerPh = '0' + customerPh;
            System.debug('Inside India Customer Phone:' + customerPh);
        } else {  
            system.debug('Inside International');
            List<User> userList = [Select Id/*, Enable_International_Calling__c*/ From User Where Id = :UserInfo.getUserId()];
            system.debug('userList'+userList);
            if(userList != null && userList.size() > 0){
                User usrRec = userList.get(0);
                //if(usrRec.Enable_International_Calling__c){ 
                System.debug('International Calling Enabled for user: ' + customerPh);
                if(countryCode != null && !String.isBlank(countryCode)){
                    if(customerPh != null && !String.isBlank(customerPh)){
                        customerPh = customerPh.removeStart('0');
                    }
                    if(countryCode.indexOf('\'++') != -1){
                        countryCode = countryCode.removeStart('\'++');
                        countryCode = '00' + countryCode;
                    } else if(countryCode.indexOf('\'+') != -1){
                        countryCode = countryCode.removeStart('\'+');
                        countryCode = '00' + countryCode;
                    } 
                    else if(countryCode.indexOf('+0') != -1){
                        countryCode = countryCode.removeStart('+0');
                        countryCode = '00' + countryCode;
                    } else if(countryCode.indexOf('0') != -1){
                        countryCode = countryCode.removeStart('0');
                        countryCode = '00' + countryCode;
                    } else if(countryCode.indexOf('+') != -1){
                        countryCode = countryCode.removeStart('+');
                        countryCode = '00' + countryCode;
                    } 
                    customerPh = countryCode + customerPh;
                }
                System.debug('countryCode:: ' + countryCode + ' customerPh:: ' + customerPh);
                //}           
            }
        }
        
        List<User> uList = [Select Id, CTI_Agent_ID__c, Campaign_Name__c, API_Key__c,CTI_Extension__c From User Where Id = :UserInfo.getUserId()];
        if(uList != null && !uList.isEmpty()) {
            campaignName = uList[0].Campaign_Name__c;
            agentID = uList[0].CTI_Agent_ID__c;
            apiKey = uList[0].API_Key__c; 
            userName = uList[0].CTI_Extension__c;
        }
        
        String queryString = 'api_key='+apiKey+'&username='+username+'&agentID='+agentId+'&campaignName='+campaignName+'&customerNumber='+customerPh;
        
        String endpoint = 'https://in1-ccaas-api.ozonetel.com/CAServices/AgentManualDial.php?'+queryString;
        System.debug('click2call URL:' + endpoint);
        Http httpProtocol = new Http();
        
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setMethod('GET');        
        request.setEndPoint(endpoint);        
        System.Debug('Request:'+request);
        
        HttpResponse response = new HttpResponse();
        if(!Test.isRunningTest()){
            response = httpProtocol.send(request);
        } else {
            response.setBody('DUMMY');
        }
        System.debug(response.getBody());
        string tempResponse = response.getBody();
        return tempResponse;                 
    }
    
    @AuraEnabled
    public static void UpdateMobileOnLead(String RecId, String Mobile){
        Lead l = new Lead();
        l.MobilePhone = Mobile;
        l.Id = RecId;
        Update l;
    }
}
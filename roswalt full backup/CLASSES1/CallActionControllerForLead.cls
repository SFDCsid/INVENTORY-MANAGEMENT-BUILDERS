global class CallActionControllerForLead {
    
    public String LeadId{get;set;}
    
    public CallActionControllerForLead (ApexPages.StandardController controller){  
        LeadId = controller.getId();
    }
    
    @RemoteAction
    global static Map<String,String> getPhoneFields(Id leadId) {
        system.debug('inside getphoneFields method'+leadId);
        List<Pair> lstfieldname = new List<Pair>();
        String queryFields;
        String sObjectName;
        Map<String,String> resultsMap = new Map<String,String>();
        // sObject types to describe
        String[] types = new String[]{'Lead'};
        // Make the describe call
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug('Got describe information for ' + results.size() + ' sObjects.');
        // For each returned result, get some info
        for(Schema.DescribeSobjectResult res : results) {
            System.debug('sObject Label: ' + res.getLabel());
            sObjectname = res.getName();
            System.debug('Number of fields: ' + res.fields.getMap().size());
            System.debug(res.isCustom() ? 'This is a custom object.' : 'This is a standard object.');
            System.debug('Fields Map:' + res.fields.getMap());
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            queryFields = 'Select ';
            for(Schema.SObjectField sfield : fieldMap.Values()){
                schema.describefieldresult dfield = sfield.getDescribe();
                Pair field = new Pair();
                //String fieldType = dfield.getType().name();
                String fieldLabel = dfield.getLabel();
                system.debug('fieldLabel::'+fieldLabel);
                if(fieldLabel.equalsIgnoreCase('Mobile Phone')) {
                    system.debug('Match found');
                    field.key = dfield.getname();
                    system.debug('lstfield key'+field.key );
                    field.val = dfield.getLabel();
                    system.debug('value '+field.val);
                    queryFields += dField.getName() + ',';
                    lstfieldname.add(field);
                    system.debug('lstfieldname'+lstfieldname);
                }
				if(fieldLabel.equalsIgnoreCase('Phone')) {
                    system.debug('Match found');
                    field.key = dfield.getname();
                    system.debug('lstfield key'+field.key );
                    field.val = dfield.getLabel();
                    system.debug('value '+field.val);
                    queryFields += dField.getName() + ',';
                    lstfieldname.add(field);
                    system.debug('lstfieldname'+lstfieldname);
                }                
            }            
        }
        if(queryFields.length() > 0 && queryFields.substring(queryFields.length() -1).equals(','))
            queryFields = queryFields.substring(0,queryFields.length() -1);
        String query = queryFields + ' FROM ' + sObjectName + ' where Id = :leadId';
        System.debug('List Field Names:' + lstFieldName);
        System.debug ('Query :' + query);
        List<sObject> sobjList = Database.query(query);
        
        system.debug('lstFieldName'+lstFieldName);
        for(Pair p : lstFieldName) {
            if(sObjList[0].get(p.key) != null) {
                System.debug('Field Name:' + p.val + '==>' + sObjList[0].get(p.key));
                String mobile = string.valueOf(sObjList[0].get(p.key));
                
                resultsMap.put(mobile.replace(mobile.substring(0,6),'XXXXXX'), string.valueOf(sObjList[0].get(p.key)));
            }
        }
        system.debug('results Map'+resultsMap);
        return resultsMap;
    }
    
    @RemoteAction
    global static String click2CallCloudagent (String recId, String customerPh) {
        List<Lead> leadList = new List<Lead>();
        List<User> uList = new List<User>();
        String campaignName = '';
        String userName = '';
        String apiKey = System.Label.OzoneTelAPIKey;
        String agentId = '';
        
        leadList = [Select Id, Name, MobilePhone, Phone from Lead where Id =: recId];
        system.debug('leadList: '+leadList);

        if(customerPh.length() > 10) {
            // if more than 10 digits are being passed, strip of the leading character, keep the last 10 and add 0 to it
            customerPh = customerPh.substring(customerPh.length() - 10);
            customerPh = '0' + customerPh;
            system.debug('Customer Phone:' + customerPh);
        }
        
        uList = [Select Id, OzoneTel_AgentId__c, Campaign_Name__c, OzoneTel_UserName__c From User Where Id =: UserInfo.getUserId()];
        if(!uList.isEmpty()) {
            campaignName = uList[0].Campaign_Name__c;
            agentId = uList[0].OzoneTel_AgentId__c;
            userName = uList[0].OzoneTel_UserName__c;
        }
          
        String parameterString = 'apiKey='+apiKey+'&userName='+userName+'&custNumber='+customerPh+'&phoneName='+agentId+'&did='+campaignName+'&uui=test';
        
        String endpoint = 'https://in1-ccaas-api.ozonetel.com/CAServices/PhoneManualDial.php?'+parameterString;
        System.debug('click2call URL:' + endpoint);
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setMethod('GET');        
        request.setEndPoint(endpoint);        
        System.Debug('Request:'+request);
        
        HttpResponse response = new HttpResponse();
        if(!Test.isRunningTest()) {
            response = httpProtocol.send(request);
        } else {
            response.setBody('DUMMY');
        }
        system.debug('Response: '+response.getBody());
        String tempResponse = response.getBody() + '- called customer';// on: ' + customerPh;
        return (tempResponse); 
    }
       
    public class Pair{
        public String key {get; set;}
        public String val {get; set;}
    }   
}
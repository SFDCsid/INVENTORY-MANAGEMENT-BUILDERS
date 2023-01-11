global class DocumentGenrationBatch implements Database.Batchable <sObject>, Database.Stateful{
    global Map<string,List<opportunity>> customerIdsMap;
    global Map<id,Map<string,string>> finalMap;
    global string docName;
    global DocumentGenrationBatch(Map<string,List<opportunity>> custIdsMap) {
        customerIdsMap = custIdsMap;
        if(customerIdsMap != null){
            for(string key : customerIdsMap.keyset()){
                docName = key;
                system.debug(docName);
            }
            
        }
    }
    global List < opportunity > start(Database.BatchableContext BC) {
        List<opportunity> optyIds = new List<opportunity>();
        if(customerIdsMap != null){
            for(string key : customerIdsMap.keyset()){
                optyIds.addAll(customerIdsMap.get(key));
                //docName = key;
               // system.debug(docName);
            }
            
        }
        return optyIds;
    }

    global void execute(Database.BatchableContext BC, List < opportunity > scope) {
        finalMap = new Map<id,Map<string,string>>();
        for(Opportunity op : scope) {
            Map<string,string> resultMap = new Map<string,string>();
            //System.debug('Opportunity is:' + op);
            system.debug('doc:: '+docName);
            resultMap = DocumentGenerationServices.generateDocumentMethod(docName, op);
            system.debug('resultMap is:: '+resultMap);
            finalMap.put(op.id,resultMap);
        }
    }
    global void finish(Database.BatchableContext BC) {
        system.debug('finalMap::: '+finalMap);
        List<User> uObj = [select id,Email,Name from User where id =: UserInfo.getUserId()];
        string htmlBody = 'Dear ' + uObj[0].Name + ',<br/><br/> The '+ docName +' generation process is complete. Please see below for details of the customer documents generated and their respective links.<br/>' + 
                           '<table border="1"> <tr> <th style="background-color:#C1C1C1">Sr.No.</th><th style="background-color:#C1C1C1">Customer Name</th>'+
                           '<th style="background-color:#C1C1C1">Opportunity Link</th> <th style="background-color:#C1C1C1">Related Document Link</th>' +
                           '<th style="background-color:#C1C1C1">Download Document Link</th></tr>';
        if(finalMap != null && !finalMap.isEmpty()){
            system.debug('inside send Method:::');
            List<opportunity> opList = new List<opportunity>();
            for(string key : customerIdsMap.keyset()){
                opList = customerIdsMap.get(key);
            }
            if(opList != null && !opList.isEmpty()){
                
                String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
                Integer srNo = 1;
                for(opportunity op : opList){
                    if(finalMap.containskey(op.id)){
                        Map<string,string> getDocName = new Map<string,string>();
                        getDocName = finalMap.get(op.id);
                        for(string st : getDocName.keyset()){
                            if(st.contains('Document Insertion Failure')){
                                htmlBody += '<tr> <td>'+ srNo + '</td> <td>'+'Vikas Gavhane' /*op.Primary_Name__c*/ + '</td> <td colspan="3">'+ getDocName.get(st) + '</td> </tr>';
                            }
                            else{
                                htmlBody += '<tr> <td>'+ srNo + '</td> <td>'+ 'Vikas Gavhane'/*op.Primary_Name__c*/ + '</td> <td>'+ baseUrl + '/' + op.id + '</td>' +  
                                            '<td>'+ baseUrl + '/' + st + '</td> <td> <a href="'+ baseUrl + '/sfc/servlet.shepherd/version/download/' + getDocName.get(st) + 
                                            '?asPdf=false&operationContext=CHATTER">Click Here </a>' + '</td> </tr>';
                            }
                        }
                        srNo++;
                    }
                }
                
                 List<String> toAddresses = new List<String>();
                 htmlBody += '</table><br/><br/> Thanks & Regards,<br/> ORL Team.';
                 // toAddresses.add(uObj[0].Email);
                 toAddresses.add('vikas.gavhane@stetig.in');
                // toAddresses.add('lalitha.bhat@stetig.in');
                  Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                 // Sets the paramaters of the email
                 email.setSubject( 'Documents have been generated');
                 email.setToAddresses( toAddresses);
                 email.setHtmlBody(htmlBody);
        
                 // Sends the email
                 Messaging.SendEmailResult [] r = 
                 Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                
            }
        }
    
    }
}
global with sharing class CTIHelper_PMT {
    
    
    global static string doPost(String virtualNumberCalled ,String callerPhoneCountryCode, String callerPhoneNumber) {
        if(callerPhoneCountryCode.contains('91')){
            if(!callerPhoneCountryCode.contains('+')){
                callerPhoneCountryCode = '+'+callerPhoneCountryCode;
            }
        }
        
        String finalReturnJson = null;
        list <Virtual_Number__c> virtualNumberCalledList = [select id, Advertisement__c, Is_Central_Number__c,
                                                            User__c, User__r.Role__c, Site_On_Advertisement__c
                                                            from Virtual_Number__c
                                                            where Name =: virtualNumberCalled
                                                            LIMIT 1];
        JSONGenerator gen = JSON.createGenerator(true);                                                
        if(!virtualNumberCalledList.isEmpty()){
            
             //PMT
            
            if(virtualNumberCalledList[0].Advertisement__c != null || virtualNumberCalledList[0].Is_Central_Number__c){
                list<lead> lstLeads = new list<lead>();
                lstLeads=[select id,Campaign__c,Name,Project__r.name,Project__c,Mobile_no__c,Site__c,Site__r.Name,Original_PMT_Owner__r.CTI_Agent_ID__c,User_Copy__r.CTI_Agent_ID__c //Modified on 15-05 
                          from lead 
                          where ((Country_Code_for_Phone__c =: callerPhoneCountryCode and Phone =: callerPhoneNumber)
                          or (Country_Code__c =: callerPhoneCountryCode and MobilePhone =: callerPhoneNumber)
                          or (Country_Code_for_Other_Mobile_Number__c =: callerPhoneCountryCode and Other_Mobile_Number__c =: callerPhoneNumber))                         
                          and Site__r.name =: virtualNumberCalledList[0].Site_On_Advertisement__c 
                          and Lead_Stage__c != 'Closed'];
               system.debug('lstLeads'+lstLeads);
                                   
                
                 if(!lstLeads.isEmpty() && lstLeads.size()>0){
                    gen.writeStartObject(); 
                    gen.writeStringField('team', 'PMT');
                    
                    
                    gen.writeStringField('campaignId', virtualNumberCalledList[0].Advertisement__c);
                    gen.writeFieldName('leads');
                    gen.writeStartArray();
                    for(lead currentlead:lstLeads){
                        gen.writeStartObject();
                        gen.writeStringField('leadId', currentlead.Id);
                        gen.writeStringField('callerName', currentlead.Name);
                        gen.writeStringField('siteId', currentlead.Site__c);
                        gen.writeStringField('siteName', currentlead.Site__r.Name);
                        gen.writeStringField('MobileNo', currentlead.Mobile_no__c);
						if(currentlead.Original_PMT_Owner__r.CTI_Agent_ID__c!=null){
                        gen.writeStringField('CTI_Agent_ID',currentlead.Original_PMT_Owner__r.CTI_Agent_ID__c);//Modified on 15-05
						}
						else{
							gen.writeStringField('CTI_Agent_ID', 'null'); 
						}
                        if(currentlead.Project__r.name != null){
                        gen.writeStringField('projectName', currentlead.Project__r.name);
                        }
                        else{
                           gen.writeStringField('projectName', 'null'); 
                        }
                        if(currentlead.Project__c != null){
                        gen.writeStringField('projectId', currentlead.Project__c);
                        }
                        else{
                          gen.writeStringField('projectId', 'null');  
                        }
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                    gen.writeEndObject();
                    
                }
                   
                
                else{
                    
                    
                    gen.writeStartObject(); 
                    gen.writeStringField('team', 'PMT');
                    
                    gen.writeStringField('LeadId', 'null');
                    gen.writeStringField('campaignId', ''+virtualNumberCalledList[0].Advertisement__c);
                    gen.writeEndObject();
                    
                }
                finalReturnJson= gen.getAsString();
                }
            }
         //Virtual Number not found
        if(finalReturnJson == null){
            finalReturnJson = '{ "virtualNumberCalled" : "Unidentified Virtual Number"}';
}
       system.debug('finalReturnJson'+finalReturnJson);
        return finalReturnJson;
            
        }
}
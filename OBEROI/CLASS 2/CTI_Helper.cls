/*Assumption: 1. When a virtual number is added to Advertisement, Advertisement lookup is populated on Virtual Number
*             2. When a virtual number is added to User, User lookup is populated on Virtual Number
*/

global with sharing class CTI_Helper{

    global static string doPost(String virtualNumberCalled ,String callerPhoneCountryCode, String callerPhoneNumber) {
        system.debug('virtualNumberCalled'+virtualNumberCalled+'**');
        system.debug('callerPhoneCountryCode'+callerPhoneCountryCode+'**');
        system.debug('callerPhoneNumber'+callerPhoneNumber+'**');
        String finalReturnJson = null;
        list <Virtual_Number__c> virtualNumberCalledList = [select id, Advertisement__c, Is_Central_Number__c, User__c, User__r.Role__c, Site_On_Advertisement__c
                                                            from Virtual_Number__c
                                                            where Name =: virtualNumberCalled
                                                            LIMIT 1];
        system.debug('virtualNumberCalledList '+virtualNumberCalledList);                                   
        if(!virtualNumberCalledList.isEmpty()){
            //PMT
            if(virtualNumberCalledList[0].Advertisement__c != null || virtualNumberCalledList[0].Is_Central_Number__c){
                list<lead> lstLeads = new list<lead>();
                lstLeads=[select id,Campaign__c,Name,Project__r.name,Project__c,Site__c,Site__r.Name,User_Copy__r.CTI_Agent_ID__c //Modified on 15-05
                          from lead 
                          where ((Country_Code_for_Phone__c =: callerPhoneCountryCode and Phone =: callerPhoneNumber)
                          or (Country_Code__c =: callerPhoneCountryCode and MobilePhone =: callerPhoneNumber)
                          or (Country_Code_for_Other_Mobile_Number__c =: callerPhoneCountryCode and Other_Mobile_Number__c =: callerPhoneNumber))                         
                          and Site__c =: virtualNumberCalledList[0].Site_On_Advertisement__c
                          and Lead_Stage__c != 'Closed'];
                PMTServiceWrapper  pmtWrap = new PMTServiceWrapper ();
                if(!lstLeads.isEmpty() && lstLeads.size()>0){
                    pmtWrap.team='PMT';
                    pmtWrap.campaignId = ''+virtualNumberCalledList[0].Advertisement__c;
                    for(lead currentlead:lstLeads){
                      PMTServiceWrapper.cls_leads objLead = new PMTServiceWrapper.cls_leads();
                      objLead.leadId = currentlead.id;
                      objLead.callerName = currentlead.Name;
                      objLead.siteId = currentlead.Site__c;
                      objLead.siteName = currentlead.Site__r.name;
                      objLead.projectName = currentlead.Project__r.name;
                      objLead.projectId = currentlead.Project__c;
					  objLead.CTI_Agent_ID = currentlead.User_Copy__r.CTI_Agent_ID__c;//Modified on 15-05
                      pmtWrap.leads.add(objLead);  
                    }

                }
                else{
                    pmtWrap.team = 'PMT';
                    pmtWrap.LeadId = 'null';
                    pmtWrap.campaignId = ''+virtualNumberCalledList[0].Advertisement__c;
                }
                finalReturnJson= json.Serialize(pmtWrap);
            }
              

            //Sales
            else if(virtualNumberCalledList[0].User__c != null && virtualNumberCalledList[0].User__r.Role__c == 'Sales'){
                contact objContact = new contact();
                SalesServiceWrapper salesWrap = new SalesServiceWrapper();
                try{
                    objContact =[select id,name, Account.RecordTypeId, Account.Name
                                from contact 
                                where ((Country_Code_for_Phone__c =: callerPhoneCountryCode and Phone =: callerPhoneNumber)
                                or (Country_Code__c =: callerPhoneCountryCode and MobilePhone =: callerPhoneNumber)
                                or (Country_Code_for_Other_Mobile_Number__c =: callerPhoneCountryCode and Other_Mobile_Number__c =: callerPhoneNumber))
                                LIMIT 1]; 

                    list<opportunity> lstOpportunity = new list<opportunity>();
                    
                    list<Booking__c> lstBookings4Opportunity = new list<Booking__c>();
                    
                    set <Id> opportunityIdSet = new set<Id>();
                    
                    for(Co_Owner__c coOwner : [select Opportunity__c 
                                               from Co_Owner__c
                                               where Contact__c =: objContact.Id]){
                        opportunityIdSet.add(coOwner.Opportunity__c);                      
                    }
                    
                    lstOpportunity = [select id,Name,Project__c, Project__r.Search_Term__c,Project__r.Site__c,Project__r.Site__r.Name
                                     from opportunity 
                                     where Opportunity_Status__c != 'Closed' and (Primary_Contact__c =: objContact.id or ID IN : opportunityIdSet )];
                    
                    map<Id, Opportunity> opportunityMap = new map<Id,Opportunity>(lstOpportunity);
                    
                    if(lstOpportunity.isEmpty()){
                        salesWrap.team='Sales';
                        salesWrap.OpportunityId='null';
                        salesWrap.UserId = ''+virtualNumberCalledList[0].User__c;
                    }
                    else {
                        RecordType rt = [select id
                                         from RecordType
                                         where DeveloperName='Channel_Partner'
                                         and SObjectType = 'Account'];
                        Id brokerRecordTypeId = rt.Id;
                        //Record Type is Broker
                        if(((String)objContact.Account.RecordTypeId).equalsIgnoreCase(''+brokerRecordTypeId)){
                        
                            salesWrap.team='Sales';
                            salesWrap.brokerId = objContact.Id;
                            salesWrap.brokerAgency = objContact.Account.Name;
                            salesWrap.callerName = objContact.Name;
                            salesWrap.UserId = ''+virtualNumberCalledList[0].User__c;
                        
                        }
                        
                        else {
                            lstBookings4Opportunity =[select Id, Opportunity__c, Tower__c, Tower__r.Search_Term__c, Property__c, Property__r.Search_Term__c
                                                      from Booking__c 
                                                      where Opportunity__c in :lstOpportunity ];
                            
                            map <Id, list<Booking__c>> oppVsBookingMap = new map<Id,list<Booking__c>>();
                            
                            for(Booking__c booking : lstBookings4Opportunity){
                                if(oppVsBookingMap.containsKey(booking.Opportunity__c)){
                                    oppVsBookingMap.get(booking.Opportunity__c).add(booking);
                                }
                                else {
                                    oppVsBookingMap.put(booking.Opportunity__c, new list<Booking__c>{booking});
                                }
                            }
                        
                            salesWrap.team='Sales';
                            salesWrap.contactId=objContact.id;
                            salesWrap.callerName=objContact.Name;
                            salesWrap.UserId = virtualNumberCalledList[0].User__c;
                            if(!lstBookings4Opportunity.isEmpty() && lstBookings4Opportunity.size()>0){
                                for(Id oppId : opportunityMap.keySet()){
                                    SalesServiceWrapper.cls_projects objProj = new SalesServiceWrapper.cls_projects();
                                    objProj.projectSearchTerm = opportunityMap.get(oppId).Project__r.Search_Term__c;
                                    objProj.projectId = opportunityMap.get(oppId).Project__c;
                                    objProj.siteId = opportunityMap.get(oppId).Project__r.Site__c;
                                    objProj.siteName = opportunityMap.get(oppId).Project__r.Site__r.Name;
                                    objProj.opportunityName = opportunityMap.get(oppId).Name;
                                    objProj.opportunityId = oppId;
                                    if(oppVsBookingMap.containsKey(oppId)){
                                        for(Booking__c booking : oppVsBookingMap.get(oppId)){
                                           SalesServiceWrapper.cls_booking objBookings = new SalesServiceWrapper.cls_booking(); 
                                           objBookings.towerSearchTerm = booking.Tower__r.Search_Term__c;
                                           objBookings.towerId = booking.Tower__c;
                                           objBookings.unitSearchTerm = booking.Property__r.Search_Term__c;
                                           objBookings.unitId = booking.Property__c;
                                           objBookings.bookingId = booking.Id;
                                           objProj.booking.add(objBookings);
                                        }
                                    }
                                    salesWrap.projects.add(objProj);
                                }

                            }
                        }
                        
                    }
                }
                catch(QueryException e){
                    salesWrap.team='Sales';
                    salesWrap.OpportunityId='null';
                    salesWrap.UserId = ''+virtualNumberCalledList[0].User__c;
                }

                finalReturnJson = json.Serialize(salesWrap);
            }
            //CRM
            else if(virtualNumberCalledList[0].User__c != null && virtualNumberCalledList[0].User__r.Role__c == 'CRM'){
                contact objContact = new contact();
                CRMServiceWrapper CRMWrap = new CRMServiceWrapper();
                try {
                
                    objContact =[select id,name 
                                 from contact 
                                 where ((Country_Code_for_Phone__c =: callerPhoneCountryCode and Phone =: callerPhoneNumber)
                                    or (Country_Code__c =: callerPhoneCountryCode and MobilePhone =: callerPhoneNumber)
                                    or (Country_Code_for_Other_Mobile_Number__c =: callerPhoneCountryCode and Other_Mobile_Number__c =: callerPhoneNumber)) ]; 
                    list<opportunity> lstOpportunity = new list<opportunity>();
                    list<Booking__c> lstBookings4Opportunity = new list<Booking__c>();
                    
                    if(objContact==null){
                        list <lead> leadList = [select id,name
                                                from Lead 
                                                where ((Country_Code_for_Phone__c =: callerPhoneCountryCode and Phone =: callerPhoneNumber)
                                                or (Country_Code__c =: callerPhoneCountryCode and MobilePhone =: callerPhoneNumber)
                                                or (Country_Code_for_Other_Mobile_Number__c =: callerPhoneCountryCode and Other_Mobile_Number__c =: callerPhoneNumber))
                                                LIMIT 1];
                        if(!leadList.isEmpty()){
                            for(Lead l : leadList){
                                CRMWrap.team = 'CRM';
                                CRMWrap.LeadId = l.Id;
                                CRMWrap.callerName = l.Name;
                                CRMWrap.UserId = virtualNumberCalledList[0].User__c; 
                            }
                        }
                        else {
                            CRMWrap.team='CRM';
                            CRMWrap.ContactId='null';
                            CRMWrap.UserId = virtualNumberCalledList[0].User__c; 
                        }
                    }
                    else{
                        //existing customer found
                        set <Id> opportunityIdSet = new set<Id>();
                        for(Co_Owner__c coOwner : [select Opportunity__c 
                                                   from Co_Owner__c
                                                   where Contact__c =: objContact.Id]){
                            opportunityIdSet.add(coOwner.Opportunity__c);                      
                        }
                        list <Opportunity> oppList =[select Id, Project__c, Project__r.Search_Term__c,Project__r.Site__c,Project__r.Site__r.Name
                                                     from Opportunity
                                                     where Primary_Contact__c =: objContact.id or ID IN : opportunityIdSet];
                                                     
                        map<Id, Opportunity> opportunityMap = new map<Id,Opportunity>(oppList);
                    
                                                     
                        CRMWrap.team='CRM';
                        CRMWrap.contactId=objContact.id;
                        CRMWrap.UserId = virtualNumberCalledList[0].User__c; 
                        CRMWrap.callerName=objContact.Name;
                        if(!oppList.isEmpty()){
                            map<Id,map<Id,list<booking__c>>> opportunityTowerBookingMap = new map<Id,map<Id,list<Booking__c>>>();
                            for(Booking__c b : [select id, Property__c, Property__r.Search_Term__c, Tower__c, Tower__r.Search_Term__c, Opportunity__c
                                                 from Booking__c
                                                 where Opportunity__c IN : oppList]) {
                                if(opportunityTowerBookingMap.containsKey(b.Opportunity__c)){
                                    if(opportunityTowerBookingMap.get(b.Opportunity__c).containsKey(b.Tower__c)){
                                        opportunityTowerBookingMap.get(b.Opportunity__c).get(b.Tower__c).add(b);
                                    }
                                    else {
                                        opportunityTowerBookingMap.get(b.Opportunity__c).put(b.Tower__c, new list<Booking__c>{b});
                                    }
                                }   
                                else {
                                    opportunityTowerBookingMap.put(b.Opportunity__c, new map<Id,list<Booking__c>>{b.Tower__c => new list<Booking__c>{b}});
                                }
                            }
                            for(Id oppId : opportunityMap.keySet()){
                                CRMServiceWrapper.cls_projects objProj = new CRMServiceWrapper.cls_projects();
                                objProj.projectSearchTerm = opportunityMap.get(oppId).Project__r.Search_Term__c;
                                objProj.projectId = opportunityMap.get(oppId).Project__c;
                                objProj.siteId = opportunityMap.get(oppId).Project__r.Site__c;
                                objProj.siteName = opportunityMap.get(oppId).Project__r.Site__r.Name;
                                objProj.opportunityName = opportunityMap.get(oppId).Name;
                                objProj.opportunityId = oppId; 
                                
                                if(opportunityTowerBookingMap.containsKey(oppId)){
                                    for(Id towerId : opportunityTowerBookingMap.get(oppId).keySet()){
                                        CRMServiceWrapper.cls_towers ObjTowers = new CRMServiceWrapper.cls_towers(); 
                                        ObjTowers.towerId = towerId;
                                        for(Booking__c b : opportunityTowerBookingMap.get(oppId).get(towerId)){
                                            ObjTowers.towerSearchTerm = b.Tower__r.Search_Term__c;
                                            CRMServiceWrapper.cls_units ObjUnits = new CRMServiceWrapper.cls_units(); 
                                            ObjUnits.unitId = b.Property__c; 
                                            ObjUnits.unitSearchTerm = b.Property__r.Search_Term__c;
                                            ObjUnits.bookingId = b.id;
                                            ObjTowers.units.add(ObjUnits); 
                                        }
                                        objProj.towers.add(ObjTowers);
                                    }
                                }
                                CRMWrap.projects.add(objProj);    
                            }
                        }
                    }
                
                }
                catch(QueryException e){
                    CRMWrap.team='CRM';
                    CRMWrap.ContactId='null';
                    CRMWrap.UserId = virtualNumberCalledList[0].User__c; 
                }
                
              finalReturnJson= json.Serialize(CRMWrap);
            }
        
        }
        
        //Virtual Number not found
        if(finalReturnJson == null)
            finalReturnJson = '{ "virtualNumberCalled" : "Unidentified Virtual Number"}';
        
       
        return finalReturnJson;
    }
}
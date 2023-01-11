/*
*  Author: Aditya Bhasin  
*  Description: Integration service class for Broker. Parsing is pending. Date to pull harcoded. Needs to be removed.
*  Date : 15/03/2019
*/

public class ORL_SAP_BrokerIntegrationService extends ORL_SAP_BaseIntegrationService {
    
    public static final string BROKER = 'Account';
    public static final string NONSCHEME = 'Non Scheme';
    public static final string LOGINPROGRESS = 'In Progress';
    public static final string INSERTCODE = 'I';
    public static final string UPDATECODE = 'U';
    public static final string RECORDTYPENAME = 'Channel Partner';
    Map<String,String> mapOfSalutationCustomMetaData = new Map<String,String>();
    Map<string,string> mapOfCountriesMetaData = new Map<String,String>();
    Map<string,Region__mdt> mapOfRegionMetaData= new Map<string,Region__mdt>();
    
    
    /*************************************Start: Pull Call Methods************************************/
    public void pullBrokerFromSAP() {
        ORL_BrokerDomain billPlndomObj = new ORL_BrokerDomain();
        //ORL_InventoryDomain invdomObj = new ORL_InventoryDomain();
        
        try{
            serviceSettings = retrieveServiceSettings(system.label.ORL_SAP_BrokerPullCall);
            Logger.logDebug('In pullBrokerFromSAP, serviceSettings'+serviceSettings);
            //create log for pull request
            initiateParentLog(BROKER);
            
            //Mapping done for meta data
            for(Country__mdt countryObj: [SELECT MasterLabel,Code__c FROM Country__mdt] ){
                
                mapOfCountriesMetaData.put(countryObj.Code__c,countryObj.MasterLabel);
            }   

            for(Region__mdt regionobj: [SELECT MasterLabel,Code__c,Country_Code__c FROM Region__mdt]){
                
                mapOfRegionMetaData.put(regionobj.Country_Code__c+'-'+regionobj.Code__c,regionobj);
            }
            system.debug('mapOfRegionMetaData'+mapOfRegionMetaData.keyset());
            system.debug('mapOfRegionMetaData'+mapOfRegionMetaData.values());
            //Mapping completed
            if(isServiceActive()){
                //initiate pull request
                ORL_SAP_BrokerPullInterface.zvendor_details pullRequest = new ORL_SAP_BrokerPullInterface.zvendor_details();
                
                pullRequest.inputHttpHeaders_x = new Map<String,String>();
                pullRequest.inputHttpHeaders_x.put('Authorization', getAuthCode());
                pullRequest.endpoint_x  = serviceSettings.EndPointURL__c;
                pullRequest.timeout_x = 120000;
                Logger.logDebug('In pullBrokerFromSAP, inputHttpHeaders_x'+pullRequest.inputHttpHeaders_x);
                Logger.logDebug('In pullBrokerFromSAP, endpoint_x'+pullRequest.endpoint_x);
                
                ORL_SAP_BrokerPullInterface.ZSD_FM_BROKER_DETAILSResponse_element responseObj = new ORL_SAP_BrokerPullInterface.ZSD_FM_BROKER_DETAILSResponse_element();
                
                ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_COMM_STRUCTURE BROKER_EMAIL_COMMUNICATION = new ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_COMM_STRUCTURE();
                ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_FAX_STRUCTURE BROKER_FAX_COMMUNICATION = new ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_FAX_STRUCTURE();
                ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_STRUCTURE BROKER_HEADER = new ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_STRUCTURE();
                ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_MOB_STRUCTURE BROKER_MOB_COMMUNICATION = new ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_MOB_STRUCTURE();
                ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_TEL_STRUCTURE BROKER_TEL_COMMUNICATION = new ORL_SAP_BrokerPullInterface.TABLE_OF_ZSDST_BROKER_TEL_STRUCTURE();
                ORL_SAP_BrokerPullInterface.ZSD_LEASE_INPUT dtParams = new ORL_SAP_BrokerPullInterface.ZSD_LEASE_INPUT();
                //Call method to retrieve Last success Log's date and time
                
                logger.logDebug('In pullBrokerFromSAP, Set Date Params for serviceSettings :'+serviceSettings);
                setDateParams(BROKER);
                
                logger.logDebug('In pullBrokerFromSAP, after Set Date Params:'+pullDates);
                /*dtParams.FROM_DATE = pullDates.FROMDATE;
                dtParams.FROM_TIME = pullDates.FROMTIME;
                dtParams.TO_DATE = pullDates.TODATE;
                dtParams.TO_TIME = pullDates.TOTIME;*/
                //FROMDATE":"5.3.2019","FROMTIME":"16:25:50","TODATE":"5.4.2019","TOTIME":"16:25:50"
                dtParams.FROM_DATE = '13.5.2019';
                dtParams.FROM_TIME = '12:30:00';
                dtParams.TO_DATE = '13.5.2019';
                dtParams.TO_TIME = '23:00:00';
                logger.logDebug('In pullBrokerFromSAP, responseObj:'+responseObj);
                logger.logDebug('In pullBrokerFromSAP, dtParams:'+dtParams);
                System.debug('dtParams --->> '+dtParams);
                System.debug('pullRequest --->> '+pullRequest);
                responseObj = pullRequest.ZSD_FM_BROKER_DETAILS(BROKER_EMAIL_COMMUNICATION,BROKER_FAX_COMMUNICATION,BROKER_HEADER,BROKER_MOB_COMMUNICATION,BROKER_TEL_COMMUNICATION,dtParams);
                logger.logDebug('In pullBrokerFromSAP, responseObj:'+responseObj);
               // logger.logDebug('In pullBrokerFromSAP, responseObj after:'+responseObj.RETURN_x.item);
                System.debug('BROKER_EMAIL_COMMUNICATION --->> '+responseObj.BROKER_EMAIL_COMMUNICATION.item);
                System.debug('BROKER_HEADER ---->> '+responseObj.BROKER_HEADER.item);
                System.debug('BROKER_MOB_COMMUNICATION ---->> '+responseObj.BROKER_MOB_COMMUNICATION.item);
                System.debug('BROKER_TEL_COMMUNICATION ---->> '+responseObj.BROKER_TEL_COMMUNICATION.item);
                System.debug('BROKER_FAX_COMMUNICATION ---->> '+responseObj.BROKER_FAX_COMMUNICATION.item);
                system.debug('RECORDTYPENAME'+RECORDTYPENAME);
                Id recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(RECORDTYPENAME).getRecordTypeId();
                system.debug(recordtypeId+'recordtypeId');
                List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE> brokerStructreList = new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE>();
                List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE> brokerMobStructreList = new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE>();
                List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE> brokerCommStructreList = new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE>();
                List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE> brokerTelStructureList = new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE>();
                List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE> brokerFaxStructureList = new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE>();
                Set<String> setOfBrokerCode = new Set<String>();
                Map<String,Account> accountMap = new Map<String,Account>();
                
               // brokerStructreList = responseObj.BROKER_HEADER;
                brokerStructreList = responseObj.BROKER_HEADER.item;
                brokerMobStructreList = responseObj.BROKER_MOB_COMMUNICATION.item;
                brokerCommStructreList = responseObj.BROKER_EMAIL_COMMUNICATION.item;
                brokerTelStructureList = responseObj.BROKER_TEL_COMMUNICATION.item;
                brokerFaxStructureList = responseObj.BROKER_FAX_COMMUNICATION.item;
                
                Map<String,List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE>> accountEmailComm = new Map<String,List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE>>();
                if(brokerCommStructreList != null && brokerCommStructreList.size() >0){
                    for(ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE brokerEmailStructure : brokerCommStructreList){
                        setOfBrokerCode.add(brokerEmailStructure.LIFNR);
                        if(accountEmailComm.get(brokerEmailStructure.LIFNR) == null){
                            accountEmailComm.put(brokerEmailStructure.LIFNR, new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE>());
                        }
                        accountEmailComm.get(brokerEmailStructure.LIFNR).add(brokerEmailStructure);
                    }
                }
                Map<String,List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE>> accountMobileComm = new Map<String,List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE>>();
                if(brokerMobStructreList != null && brokerMobStructreList.size() >0){
                    for(ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE brokerMobileStructure : brokerMobStructreList){
                        setOfBrokerCode.add(brokerMobileStructure.LIFNR);
                        if(accountMobileComm.get(brokerMobileStructure.LIFNR) == null){
                            accountMobileComm.put(brokerMobileStructure.LIFNR, new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE>());
                        }
                        accountMobileComm.get(brokerMobileStructure.LIFNR).add(brokerMobileStructure );
                    }
                }
                Map<String,List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE>> accountTelComm = new Map<String,List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE>>();
                if(brokerTelStructureList != null && brokerTelStructureList.size() >0){
                    for(ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE brokerTelStructure : brokerTelStructureList){
                        setOfBrokerCode.add(brokerTelStructure.LIFNR);
                        if(accountTelComm.get(brokerTelStructure.LIFNR) == null){
                            accountTelComm.put(brokerTelStructure.LIFNR, new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE>());
                        }
                        accountTelComm.get(brokerTelStructure.LIFNR).add(brokerTelStructure);
                    }
                }
                Map<String,List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE>> accountFaxComm = new Map<String,List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE>>();
                if(brokerFaxStructureList != null && brokerFaxStructureList.size() >0){
                    for(ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE  brokerFaxStructure : brokerFaxStructureList){
                    setOfBrokerCode.add(brokerFaxStructure.LIFNR);
                    if(accountFaxComm.get(brokerFaxStructure.LIFNR) == null){
                            accountFaxComm.put(brokerFaxStructure.LIFNR, new List<ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE>());
                        }
                        accountFaxComm.get(brokerFaxStructure.LIFNR).add(brokerFaxStructure);
                    }
                }
                Map<String,ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE> accountComm = new Map<String,ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE>();
                if(brokerStructreList != NULL && brokerStructreList.size() > 0){
                    for(ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE brokerStructreObj: brokerStructreList){
                        setOfBrokerCode.add(brokerStructreObj.LIFNR);
                        accountComm.put(brokerStructreObj.LIFNR, brokerStructreObj);
                    }
                }
                if(setOfBrokerCode != null && setOfBrokerCode.size() > 0){
                    List<Account> accountsToUpsert = new List<Account>();
                    for(Account act : [SELECT Name, AccountNumber,Broker_Code__c  FROM Account WHERE Broker_Code__c  IN: setOfBrokerCode]){
                        accountMap.put(act.AccountNumber, act);
                    }
                    //Delete the existing data
                    System.debug('accountMapaccountMap'+accountMap.keyset());
                    System.debug('accountMapaccountMap'+accountMap.values());
                    delete accountMap.values();
                    //
                    for(String accNum : setOfBrokerCode){
                        Account accountObj = new Account();
                        /*if(accountMap.get(accNum) != null){
                            accountObj = new Account(Id= accountMap.get(accNum).Id);  
                        }else{
                            accountObj = new Account();
                        }*/
                        
                        ORL_SAP_BrokerPullInterface.ZSDST_BROKER_STRUCTURE brokerStructreObj = accountComm.get(accNum);
                        if(brokerStructreObj != null && accountObj != null && (brokerStructreObj.NAME1 != null || accountObj.Name != null)){
                            accountObj.recordtypeId = recordtypeId;
                            accountObj.Title__c = brokerStructreObj.Title;
                            accountObj.Name_1__c = brokerStructreObj.NAME1;
                            accountObj.Name_2__c = brokerStructreObj.NAME2;
                            accountObj.name = brokerStructreObj.NAME1;               
                            accountObj.AccountNumber = brokerStructreObj.LIFNR;
                            accountObj.Broker_Code__c = brokerStructreObj.LIFNR;
                            accountObj.Search_Term_1__c = brokerStructreObj.SEARCH_TERM1;
                            accountObj.Search_Term_2__c = brokerStructreObj.SEARCH_TERM2;              
                            accountObj.City__c = brokerStructreObj.City;
                            accountObj.Country__c = brokerStructreObj.COUNTRY;
                            accountObj.Region__c = brokerStructreObj.REGION;
                            if(!String.isBlank(brokerStructreObj.COUNTRY)){
                                accountObj.Country_List__c = (mapOfCountriesMetaData != null && !mapOfCountriesMetaData.isEmpty() && mapOfCountriesMetaData.size()>0?  mapOfCountriesMetaData.get(brokerStructreObj.COUNTRY):'');
                            }
                            system.debug('CountryCountry'+accountObj.Country_List__c);
                            if(!String.isBlank(brokerStructreObj.REGION) && mapOfRegionMetaData != null && 
                            mapOfRegionMetaData.size()>0 && mapOfCountriesMetaData != null && mapOfCountriesMetaData.size()>0){
                                String reg = brokerStructreObj.COUNTRY+'-'+brokerStructreObj.REGION;
                                system.debug('RegionRegion'+reg);
                                if(mapOfRegionMetaData.containsKey(reg)){
                                accountObj.Region_List__c = mapOfRegionMetaData.get(reg).MasterLabel;}
                            }
                            system.debug('RegionRegion'+accountObj.Region_List__c);
                            accountObj.Postal_code__c = brokerStructreObj.POSTAL_CODE;     
                            accountObj.Street__c = brokerStructreObj.STREET;
                            accountObj.Street_2__c = brokerStructreObj.STREET1;
                            accountObj.Street_3__c = brokerStructreObj.STREET2;
                            accountObj.Street_4__c = brokerStructreObj.STREET3;
                            accountObj.Street_5__c = brokerStructreObj.LOCATION;               
                            accountObj.Tax_Number_1__c = brokerStructreObj.GST_NUMBER;
                            accountObj.Tax_Number_3__c = brokerStructreObj.PAN_NUMBER;
                        }
                        if(accountEmailComm != null && accountEmailComm.size() > 0 && accountEmailComm.get(accNum) != null){
                            Integer count = 1;
                            for(ORL_SAP_BrokerPullInterface.ZSDST_BROKER_COMM_STRUCTURE email : accountEmailComm.get(accNum)){
                                if(email.EMAIL_DEFAULT == 'X'){
                                    accountObj.Email_1__c = email.EMAIL;
                                }else if(count == 2){
                                    accountObj.Email_2__c = email.EMAIL;
                                }else if(count == 3){
                                    accountObj.Email_3__c = email.EMAIL;
                                }else if(count == 4){
                                    accountObj.Email_4__c = email.EMAIL;
                                }else if(count == 5){
                                    accountObj.Email_5__c = email.EMAIL;
                                }
                                count = count + 1;
                            }
                        }
                        if(accountMobileComm != null && accountMobileComm.size() > 0 && accountMobileComm.get(accNum) != null){
                            Integer count = 1;
                            for(ORL_SAP_BrokerPullInterface.ZSDST_BROKER_MOB_STRUCTURE obj : accountMobileComm.get(accNum)){
                                if(obj.MOB_DEFAULT == 'X'){
                                    accountObj.Mobile_1__c = obj.MOB_NUMBER;
                                }else if(count == 2){
                                    accountObj.Mobile_2__c = obj.MOB_NUMBER;
                                }else if(count == 3){
                                    accountObj.Mobile_3__c  = obj.MOB_NUMBER;
                                }else if(count == 4){
                                    accountObj.Mobile_4__c = obj.MOB_NUMBER;
                                }else if(count == 5){
                                    accountObj.Mobile_5__c = obj.MOB_NUMBER;
                                }
                                count = count + 1;
                            }
                        }
                        if(accountTelComm != null && accountTelComm.size() > 0 && accountTelComm.get(accNum) != null){
                            Integer count = 1;
                            for(ORL_SAP_BrokerPullInterface.ZSDST_BROKER_TEL_STRUCTURE obj : accountTelComm.get(accNum)){
                                if(obj.TEL_DEFAULT == 'X'){
                                    accountObj.Telephone_1__c = obj.TEL_NUMBER;
                                }else if(count == 2){
                                    accountObj.Telephone_2__c = obj.TEL_NUMBER;
                                }else if(count == 3){
                                    accountObj.Telephone_3__c  = obj.TEL_NUMBER;
                                }else if(count == 4){
                                    accountObj.Telephone_4__c = obj.TEL_NUMBER;
                                }else if(count == 5){
                                    accountObj.Telephone_5__c = obj.TEL_NUMBER;
                                }
                                count = count + 1;
                            }
                        }
                        if(accountFaxComm != null && accountFaxComm.size() > 0 && accountFaxComm.get(accNum) != null){
                            Integer count = 1;
                            for(ORL_SAP_BrokerPullInterface.ZSDST_BROKER_FAX_STRUCTURE obj : accountFaxComm.get(accNum)){
                                if(obj.FAX_DEFAULT == 'X'){
                                    accountObj.Fax_1__c = obj.FAX_NUMBER;
                                }else if(count == 2){
                                    accountObj.Fax_2__c = obj.FAX_NUMBER;
                                }else if(count == 3){
                                    accountObj.Fax_3__c  = obj.FAX_NUMBER;
                                }else if(count == 4){
                                    accountObj.Fax_4__c = obj.FAX_NUMBER;
                                }else if(count == 5){
                                    accountObj.Fax_5__c = obj.FAX_NUMBER;
                                }
                                count = count + 1;
                            }
                        }
                        accountsToUpsert.add(accountObj);
                    }
                    if(accountsToUpsert != null && accountsToUpsert.size() > 0){
                        upsert accountsToUpsert Broker_Code__c;
                    }
                    if(accountsToUpsert.size() > 0 ){
                        parentLog.Status__c = 'Success';
                        Integer recordCount = accountsToUpsert.size();
                        parentLog.SAP_Message__c = 'Records Received, Count: ' + recordCount;
                        insert parentLog;
                    }else{
                        logger.logDebug('In pullBillingPlanFromSAP, empty Response:');
                        parentLog.Status__c = 'Success';
                        parentLog.SAP_Message__c = 'Empty Response';
                        insert parentLog;
                    }
                    if(accountsToUpsert.size() >0){
                        for(Account accountObj: accountsToUpsert){
                            //Create sub logs 
                            createLogs(accountObj);
                            system.debug('Count%%%%%'+accountObj);
                        }
                    }
                    insert logLst;
                }
            }else{
                parentLog.Status__c = 'Failed';
                parentLog.SAP_Message__c = 'Service Inactivated in Salesforce';
                insert parentLog;
            }
        }catch(Exception ex){
            Logger.logException('Error in ORL_SAP_BillingPlanIntegrationService.inventoryPullCall:'+ex.getMessage());
            system.debug('error======'+ex.getStackTraceString());
            parentLog.Status__c = 'Failed';
            parentLog.SAP_Message__c = ex.getMessage();
            upsert parentLog;
        }
        
        logger.logDebug('In pullBillingPlanFromSAP, logs created, finish');   
    }
    
    public void createLogs( Account accountObj){
        system.debug('into createlog...');
        serviceSettings = retrieveServiceSettings(system.label.ORL_SAP_BrokerPullCall);
        SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();                 
        tstLog.Logging_Time__c = datetime.Now();
        tstLog.Logging_User__c = UserInfo.getUserId();
        tstLog.Parent_Log__c = parentLog.Id;
        tstLog.Related_Object__c = gtObjectName(accountObj.Id);
        tstLog.Status__c = 'Success';
        tstLog.SAP_Message__c = 'Pull Operation Completed';
        tstLog.Description__c = 'Pull Request for Account : '+accountObj.AccountNumber;
        tstLog.Type__c = serviceSettings.DeveloperName;
        tstLog.Account__c= accountObj.id;
        logLst.add(tstLog);
        
        //createInterfaceLogs();
    }
    /*************************************End: Pull Call Methods************************************/
}
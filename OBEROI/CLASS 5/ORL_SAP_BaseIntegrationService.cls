/*
*  Author: Vivek S
*  Description: Base Integration Layer class which will be extended by all incoming or out going webservices
*  Change Log: 25/01/2019 Created
*/
public virtual class ORL_SAP_BaseIntegrationService{
  
  public ORL_SAP_Interface_Parameters__mdt serviceSettings ;
  public list<SAP_Interface_Log__c> logLst = new list<SAP_Interface_Log__c>();
  public SAP_Interface_Log__c parentLog = new SAP_Interface_Log__c();
  public LastSuccessPullDates pullDates = new LastSuccessPullDates();
  public static final string STATSUCCESS = 'Success';

/*
*  Author: Vivek S
*  Description: methods to return Login details for service
*  Change Log: 25/01/2019 Created
*/ 
public ORL_SAP_Interface_Parameters__mdt retrieveServiceSettings(string servName){
   try{
      
      ORL_SAP_Interface_Parameters__mdt serviceSet = [SELECT id, DeveloperName, Active__c, EndPointURL__c, 
                                                            Logging_Enabled__c, Password__c, Username__c
                                                      FROM ORL_SAP_Interface_Parameters__mdt 
                                                      WHERE DeveloperName =: servName LIMIT 1];
      return serviceSet;
    }catch(Exception ex){
       Logger.logDebug('retrieveServiceSettings'+ex.getMessage());
       
    }   
    
    return NULL;
}

/*
*  Author: Vivek S
*  Description: methods to return Login details for service
*  Change Log: 25/01/2019 Created
*/  
   public string getAuthCode(){
   try{
    if(serviceSettings != NULL){
       return 'Basic ' + Encodingutil.base64Encode(Blob.valueOf(serviceSettings.Username__c + ':' + serviceSettings.Password__c));    
    }
    }catch(Exception ex){
      Logger.logDebug(ex.getMessage());
    }   
    
    Return NULL;
  }
  
/*
*  Author: Vivek S
*  Description: methods to check if service is active
*  Change Log: 25/02/2019 Created
*/  
   public Boolean isServiceActive(){
   try{
    if(serviceSettings != NULL){
       return serviceSettings.Active__c;    
    }
    }catch(Exception ex){
      Logger.logDebug(ex.getMessage());
    }   
    
    Return false;
  }  
  
/*
*  Author: Vivek S
*  Description: methods to log interface outcomes
*  Change Log: 25/01/2019 Created
*/  
  public void createInterfaceLogs(){
    try{
    
       if(!logLst.isEmpty() && serviceSettings != NULL && serviceSettings.Logging_Enabled__c){
       system.debug('RRRRRRRR'+logLst);
         Database.insert(logLst);
         system.debug('Count Insert *****'+logLst);
       }
    
    }catch(Exception ex){
       Logger.logDebug(ex.getMessage());
       system.debug('Account Exception'+ex.getMessage());
    }
  }
  
/*
*  Author: Vivek S
*  Description: methods to get Object name
*  Change Log: 10/02/2019 Created
*/
  public string gtObjectName(id objId){
    return objId.getSObjectType().getDescribe().getName();
  }

/*
*  Author: Vivek S
*  Description: methods to create parent log for Pull request's
*  Change Log: 14/02/2019 Created
*/  
  public void initiateParentLog(string objType){
       parentLog.Logging_Time__c = datetime.Now();
       parentLog.Logging_User__c = UserInfo.getUserId();
       parentLog.Status__c = 'In Progress';
       parentLog.SAP_Message__c = 'Not sent';
       parentLog.Description__c = 'Pull Request to SAP At '+parentLog.Logging_Time__c;
       parentLog.Type__c = serviceSettings != NULL ? serviceSettings.DeveloperName : '';
       parentLog.Related_Object__c = objType;
  }
  
/*
*  Author: Vivek S
*  Description: methods related to Date manipulations required for Pull functionality
*  Change Log: 14/02/2019 Created
*/  
Public void setDateParams(String resobj){
  pullDates.setDefualtValues();
  try{
     Logger.logDebug('IN Base class, serviceSettings :'+serviceSettings);
     if(serviceSettings != NULL){
       string serviceDevName = serviceSettings.DeveloperName;
       Logger.logDebug('IN Base class, serviceDevName:'+serviceDevName);
       String qry = ORL_Util.buildQuery('SAP_Interface_Log__c')+' Where Related_Object__c =: resobj AND Type__c =: serviceDevName AND Status__c =: STATSUCCESS AND IsParent__c = TRUE ORDER BY Logging_Time__c DESC'; 
       Logger.logDebug('IN Base class:'+qry);
       list<SAP_Interface_Log__c> lastLogLst = Database.Query(qry);
           if(lastLogLst != NULL && !lastLogLst.isEmpty()){
             Logger.logDebug('IN Base class:'+string.valueOf(lastLogLst));
                for(SAP_Interface_Log__c sli : lastLogLst){
                    if(!string.isBlank(sli.SAP_Message__c) && !sli.SAP_Message__c.contains('Empty Response')){
                        //DateTime lastLogDtTime = lastLogLst.get(0).Logging_Time__c;
                        //String res = lastLogLst.get(0).SAP_Message__c;
                        DateTime lastLogDtTime = sli.Logging_Time__c;
                        system.debug('@@@@@'+lastLogDtTime);
                        if(lastLogDtTime != NULL){
                           pullDates.setLastSuccessPullDates(ORL_SAP_BaseIntegrationService.getDateParameter(lastLogDtTime), ORL_SAP_BaseIntegrationService.getTimeParameter(lastLogDtTime));
                           break;
                        }
                        system.debug('pulldates');
                    }
                    system.debug('pulldates');
                }
                system.debug('pulldates');
           }
     }
    }catch(Exception ex){
       Logger.logDebug('IN Base class:'+ex.getMessage());
    }   
  
}

public static string getDateParameter(Datetime ipDt){
  string retStr = ipDt.day()+'.'+ipDt.month()+'.'+ipDt.year();
  return retStr;

}

public static string getTimeParameter(Datetime ipDt){
  string retStr = ipDt.hour()+':'+ipDt.minute()+':'+ipDt.second();
  return retStr;

}

public class LastSuccessPullDates{
  public string FROMDATE;
  public string FROMTIME;
  public string TODATE;
  public string TOTIME;
  public datetime currDtTime;
  
  public void setLastSuccessPullDates(string frmDt, string frmTime){
      FROMDATE = frmDt;
      FROMTIME = frmTime;
  }
  
  public void setDefualtValues(){
      currDtTime = Datetime.now();
      FROMDATE = getDateParameter(currDtTime.addMonths(-1));
      FROMTIME = getTimeParameter(currDtTime.addMonths(-1));
      TODATE = getDateParameter(currDtTime);
      TOTIME = getTimeParameter(currDtTime);
  }
  
}
  
}
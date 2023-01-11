/*
*  Author: Vivek S
*  Description: Integration service class for Inventory Objects
*  Change Log: 25/01/2019: created
*/

public class ORL_SAP_InventoryIntegrationService extends ORL_SAP_BaseIntegrationService {

public static final string PROPERTY = 'Property__c';
public static final string PROPERTYTYPE = 'Property_Type__c';
public static final string RENTAL = 'Commercial';
public static final string KMAT = 'KMAT';
public static final string FERT = 'FERT';
public static final string LOGINPROGRESS = 'In Progress';
public static final string DEFAULTPROPTYPE = 'a0Jp0000004AcuY';//This needs to be moved to custom setting

/*************************************Start: Create/Update Call Methods************************************/
public void createInventoryInSAP(list<string> invIds, string ObjType) {
    try{
       ORL_InventoryDomain invObj = new ORL_InventoryDomain(); 
       //get PropertyType records from DB
       list<sObject> propTypes = new list<sObject>();
       serviceSettings = retrieveServiceSettings(system.label.ORL_SAP_InventoryCreateCall);
       
       if(ObjType != NULL && ObjType.equals(PROPERTYTYPE)){
         propTypes = invObj.retrievePropTypeByIds(invIds);
       }else{
         propTypes = invObj.retrievePropByIds(invIds);
       }       
       
       for(sObject pObj : propTypes){
         SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
         
            try{
                Logger.logDebug('serviceSettings'+serviceSettings);
                logLst.add(tstLog);
                tstLog.Logging_Time__c = datetime.Now();
                tstLog.Logging_User__c = UserInfo.getUserId();
                  if(ObjType != NULL && ObjType.equals(PROPERTYTYPE)){
                     tstLog.Property_Type__c = pObj.Id;
                   }else{
                     tstLog.Property__c = pObj.Id;
                   }
                tstLog.Related_Object__c = gtObjectName(pObj.Id);
                tstLog.Status__c = LOGINPROGRESS;
                tstLog.SAP_Message__c = 'Not sent';
                tstLog.Description__c = 'Create Request for Property type: '+(pObj.get('Material_No__c') != NULL ? string.valueOf(pObj.get('Material_No__c')) : '');
                tstLog.Type__c = serviceSettings.DeveloperName;
            
            //move ahead only if service is active          
            if(isServiceActive()){
                //Initialising Proxy classes
                ORL_SAP_InventoryCreateInterface invCreateClsObj = new ORL_SAP_InventoryCreateInterface();
                ORL_SAP_InventoryCreateInterface.TABLE_OF_BAPI_MATRETURN2 retMsg = new ORL_SAP_InventoryCreateInterface.TABLE_OF_BAPI_MATRETURN2();
                ORL_SAP_InventoryCreateInterface.ZSDST_MATERIAL_STRUCTURE materialObj = new ORL_SAP_InventoryCreateInterface.ZSDST_MATERIAL_STRUCTURE();
                materialObj.SFDCID = string.valueOf(pObj.get('Id'));
                materialObj.MATERIAL = pObj.get('Material_No__c') != NULL ? string.valueOf(pObj.get('Material_No__c')) : '';
                materialObj.MATL_DESC = pObj.get('Description__c') != NULL ? string.valueOf(pObj.get('Description__c')) : '';
                materialObj.MATL_TYPE = ObjType.equals(PROPERTYTYPE) ? KMAT : FERT; // Conditional values
                materialObj.PLANT = ObjType.equals(PROPERTYTYPE) ? (pObj.get('Project3__c') != NULL ? string.valueOf(pObj.get('Project3__c')) : '') : (pObj.get('Project__c') != NULL ? string.valueOf(pObj.get('Project__c')) : ''); // Condition values
                materialObj.VKORG = pObj.get('Company_name__c') != NULL ? string.valueOf(pObj.get('Company_name__c')) : '';
                materialObj.DISTR_CHAN = '11'; //for now defaulted to 11
                materialObj.SATNR = ObjType.equals(PROPERTYTYPE) ? '' : (pObj.get('Property_Material_No__c') != NULL ? string.valueOf(pObj.get('Property_Material_No__c')) : ''); // Condition values
                materialObj.ATWRT = ObjType.equals(PROPERTYTYPE) ? '' : (pObj.get('Floor_SAP__c') != NULL ? string.valueOf(pObj.get('Floor_SAP__c')) : ''); // Condition values
                materialObj.MSTAV = ObjType.equals(PROPERTYTYPE) ? '41' : (pObj.get('Unit_Status__c') != NULL ? string.valueOf(pObj.get('Unit_Status__c')): ''); // Condition values
                materialObj.SALES_UNIT = pObj.get('Sales_Unit__c') != NULL ? string.valueOf(pObj.get('Sales_Unit__c')) : '';
                materialObj.DELY_UNIT = pObj.get('Carpet_Area__c') != NULL ? string.valueOf(pObj.get('Carpet_Area__c')) : '';
                materialObj.STEUC = pObj.get('Control_Code__c') != NULL ? string.valueOf(pObj.get('Control_Code__c')) :'';
                Logger.logdebug('materialObj:'+materialObj);

                ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE uomObj1 = new ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE();
                uomObj1.DENOMINATR = pObj.get('Carpet_Area__c') != NULL ? string.valueOf(integer.valueOf(pObj.get('Carpet_Area__c'))) : '';
                uomObj1.ALT_UNIT = pObj.get('Carpet_Area_UOM__c') != NULL ? string.valueOf(pObj.get('Carpet_Area_UOM__c')) : '';
                ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE uomObj2 = new ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE();
                uomObj2.DENOMINATR = pObj.get('Balcony_Area__c') != NULL ? string.valueOf(integer.valueOf(pObj.get('Balcony_Area__c'))) : '';
                uomObj2.ALT_UNIT = pObj.get('Balcony_Area_UOM__c') != NULL ? string.valueOf(pObj.get('Balcony_Area_UOM__c')) : '';
                ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE uomObj3 = new ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE();
                uomObj3.DENOMINATR = pObj.get('Saleable_Area__c') != NULL ? string.valueOf(integer.valueOf(pObj.get('Saleable_Area__c'))) : '';
                uomObj3.ALT_UNIT = pObj.get('Saleable_Area_UOM__c') != NULL ? string.valueOf(pObj.get('Saleable_Area_UOM__c')) : '';
                
                
                ORL_SAP_InventoryCreateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE UNITS_OF_MEASURE = new ORL_SAP_InventoryCreateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE();
                UNITS_OF_MEASURE.item = new ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE[]{};
                
                if(uomObj1.DENOMINATR != '' && uomObj1.ALT_UNIT != ''){
                  UNITS_OF_MEASURE.item.add(uomObj1);
                }
                
                if(uomObj2.DENOMINATR != '' && uomObj2.ALT_UNIT != ''){
                  UNITS_OF_MEASURE.item.add(uomObj2);
                }
                
                if(uomObj3.DENOMINATR != '' && uomObj3.ALT_UNIT != ''){
                  UNITS_OF_MEASURE.item.add(uomObj3);
                }
                
                
                Logger.logdebug('UNITS_OF_MEASURE:'+UNITS_OF_MEASURE);
                
                ORL_SAP_InventoryCreateInterface.zcreate_material pushCallObj = new ORL_SAP_InventoryCreateInterface.zcreate_material();
                
                pushCallObj.inputHttpHeaders_x = new Map<String,String>();
                pushCallObj.inputHttpHeaders_x.put('Authorization', getAuthCode());
                pushCallObj.endpoint_x  = serviceSettings.EndPointURL__c;
                Logger.logDebug('inputHttpHeaders_x'+pushCallObj.inputHttpHeaders_x);
                Logger.logDebug('endpoint_x'+pushCallObj.endpoint_x);
                
                ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATEResponse_element response = new ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATEResponse_element();
                response = pushCallObj.ZSD_FM_MATERIAL_CREATE(materialObj,retMsg,UNITS_OF_MEASURE);
                Logger.logDebug('Response: Recieved:'+string.valueOf(response));
                Logger.logDebug('Response: MATERIAL_NUMBER:'+string.valueOf(response.MATERIAL_NUMBER));
                Logger.logDebug('Response: RETURN_x:'+string.valueOf(response.RETURN_x));
                Logger.logDebug('Response: RETURNMESSAGES:'+string.valueOf(response.RETURNMESSAGES));
                Logger.logDebug('Response: UNITS_OF_MEASURE:'+string.valueOf(response.UNITS_OF_MEASURE));
                
                
                ///Add logic of Response handling here
                if(response.RETURN_x != NULL){
                    tstLog.Status__c = response.RETURN_x.TYPE_x;
                    tstLog.SAP_Message__c = response.RETURN_x.MESSAGE;
                }else{
                    tstLog.Status__c = 'No Response';
                    tstLog.SAP_Message__c = 'No Response Recieved from SAP';
                }
            }else{
               tstLog.Status__c = 'Failed';
               tstLog.SAP_Message__c = 'Service Deactivated in Salesforce';
            }           

            }catch(Exception ex){
               Logger.logException('Error in ORL_SAP_InventoryIntegrationService.createTestPushCall:'+ex.getMessage());
               tstLog.Status__c = 'Exception';
               tstLog.SAP_Message__c = ex.getMessage();
            }   
       }
       createInterfaceLogs();

    }catch(Exception ex){
       Logger.logException('Error in ORL_SAP_InventoryIntegrationService.createPushCall:'+ex.getMessage());
    }   
}//createInventoryInSAP

public void updateInventoryInSAP(list<string> invIds, string ObjType) {
    try{
       ORL_InventoryDomain invObj = new ORL_InventoryDomain(); 
       //get PropertyType records from DB
       list<sObject> propTypes = new list<sObject>();
       
       serviceSettings = retrieveServiceSettings(system.label.ORL_SAP_InventoryUpdateCall);
       
       if(ObjType != NULL && ObjType.equals(PROPERTYTYPE)){
         propTypes = invObj.retrievePropTypeByIds(invIds);
       }else{
         propTypes = invObj.retrievePropByIds(invIds);
       }       
       
       for(sObject pObj : propTypes){
         SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
         
            try{
                Logger.logDebug('serviceSettings'+serviceSettings);
                logLst.add(tstLog);
                tstLog.Logging_Time__c = datetime.Now();
                tstLog.Logging_User__c = UserInfo.getUserId();
                  if(ObjType != NULL && ObjType.equals(PROPERTYTYPE)){
                     tstLog.Property_Type__c = pObj.Id;
                   }else{
                     tstLog.Property__c = pObj.Id;
                   }
                tstLog.Related_Object__c = gtObjectName(pObj.Id);
                tstLog.Status__c = LOGINPROGRESS;
                tstLog.SAP_Message__c = 'Update Request Not sent';
                tstLog.Description__c = 'Update Request for Property type: '+(pObj.get('Material_No__c') != NULL ? string.valueOf(pObj.get('Material_No__c')) : '');
                tstLog.Type__c = serviceSettings.DeveloperName;
                
            //move ahead only if service is active          
            if(isServiceActive()){    
                //Initialising Proxy classes
                ORL_SAP_InventoryUpdateInterface invCreateClsObj = new ORL_SAP_InventoryUpdateInterface();
                ORL_SAP_InventoryUpdateInterface.TABLE_OF_BAPI_MATRETURN2 retMsg = new ORL_SAP_InventoryUpdateInterface.TABLE_OF_BAPI_MATRETURN2();
                ORL_SAP_InventoryUpdateInterface.ZSDST_MATERIAL_STRUCTURE materialObj = new ORL_SAP_InventoryUpdateInterface.ZSDST_MATERIAL_STRUCTURE();
                materialObj.SFDCID = string.valueOf(pObj.get('Id'));
                materialObj.MATERIAL = pObj.get('Material_No__c') != NULL ? string.valueOf(pObj.get('Material_No__c')) : '';
                materialObj.MATL_DESC = pObj.get('Description__c') != NULL ? string.valueOf(pObj.get('Description__c')) : '';
                materialObj.MATL_TYPE = ObjType.equals(PROPERTYTYPE) ? KMAT : FERT; // Conditional values
                materialObj.PLANT = ObjType.equals(PROPERTYTYPE) ? (pObj.get('Project3__c') != NULL ? string.valueOf(pObj.get('Project3__c')) : '') : (pObj.get('Project__c') != NULL ? string.valueOf(pObj.get('Project__c')) : ''); // Condition values
                materialObj.VKORG = pObj.get('Company_name__c') != NULL ? string.valueOf(pObj.get('Company_name__c')) : '';
                materialObj.DISTR_CHAN = '11'; //for now defaulted to 11
                materialObj.SATNR = ObjType.equals(PROPERTYTYPE) ? '' : (pObj.get('Property_Material_No__c') != NULL ? string.valueOf(pObj.get('Property_Material_No__c')) : ''); // Condition values
                materialObj.ATWRT = ObjType.equals(PROPERTYTYPE) ? '' : (pObj.get('Floor_SAP__c') != NULL ? string.valueOf(pObj.get('Floor_SAP__c')) : ''); // Condition values
                materialObj.MSTAV = ObjType.equals(PROPERTYTYPE) ? '41' : (pObj.get('Unit_Status__c') != NULL ? string.valueOf(pObj.get('Unit_Status__c')): ''); // Condition values
                materialObj.SALES_UNIT = pObj.get('Sales_Unit__c') != NULL ? string.valueOf(pObj.get('Sales_Unit__c')) : '';
                materialObj.DELY_UNIT = pObj.get('Carpet_Area__c') != NULL ? string.valueOf(pObj.get('Carpet_Area__c')) : '';
                materialObj.STEUC = pObj.get('Control_Code__c') != NULL ? string.valueOf(pObj.get('Control_Code__c')) :'';
                Logger.logdebug('materialObj:'+materialObj);

                ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE uomObj1 = new ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE();
                uomObj1.DENOMINATR = pObj.get('Carpet_Area__c') != NULL ? string.valueOf(integer.valueOf(pObj.get('Carpet_Area__c'))) : '';
                uomObj1.ALT_UNIT = pObj.get('Carpet_Area_UOM__c') != NULL ? string.valueOf(pObj.get('Carpet_Area_UOM__c')) : '';
                ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE uomObj2 = new ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE();
                uomObj2.DENOMINATR = pObj.get('Balcony_Area__c') != NULL ? string.valueOf(integer.valueOf(pObj.get('Balcony_Area__c'))) : '';
                uomObj2.ALT_UNIT = pObj.get('Balcony_Area_UOM__c') != NULL ? string.valueOf(pObj.get('Balcony_Area_UOM__c')) : '';
                ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE uomObj3 = new ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE();
                uomObj3.DENOMINATR = pObj.get('Saleable_Area__c') != NULL ? string.valueOf(integer.valueOf(pObj.get('Saleable_Area__c'))) : '';
                uomObj3.ALT_UNIT = pObj.get('Saleable_Area_UOM__c') != NULL ? string.valueOf(pObj.get('Saleable_Area_UOM__c')) : '';
                
                
                ORL_SAP_InventoryUpdateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE UNITS_OF_MEASURE = new ORL_SAP_InventoryUpdateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE();
                UNITS_OF_MEASURE.item = new ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE[]{};
                
                if(uomObj1.DENOMINATR != '' && uomObj1.ALT_UNIT != ''){
                  UNITS_OF_MEASURE.item.add(uomObj1);
                }
                
                if(uomObj2.DENOMINATR != '' && uomObj2.ALT_UNIT != ''){
                  UNITS_OF_MEASURE.item.add(uomObj2);
                }
                
                if(uomObj3.DENOMINATR != '' && uomObj3.ALT_UNIT != ''){
                  UNITS_OF_MEASURE.item.add(uomObj3);
                }
                
                
                Logger.logdebug('UNITS_OF_MEASURE:'+UNITS_OF_MEASURE);
                
                ORL_SAP_InventoryUpdateInterface.zchange_material pushCallObj = new ORL_SAP_InventoryUpdateInterface.zchange_material();
                
                pushCallObj.inputHttpHeaders_x = new Map<String,String>();
                pushCallObj.inputHttpHeaders_x.put('Authorization', getAuthCode());
                pushCallObj.endpoint_x  = serviceSettings.EndPointURL__c;
                Logger.logDebug('inputHttpHeaders_x'+pushCallObj.inputHttpHeaders_x);
                Logger.logDebug('endpoint_x'+pushCallObj.endpoint_x);
                
                ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGEResponse_element response = new ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGEResponse_element();
                response = pushCallObj.ZSD_FM_MATERIAL_CHANGE(materialObj,retMsg,UNITS_OF_MEASURE);
                Logger.logDebug('Response: Recieved:'+string.valueOf(response));
                Logger.logDebug('Response: MATERIAL_NUMBER:'+string.valueOf(response.MATERIAL_NUMBER));
                Logger.logDebug('Response: RETURN_x:'+string.valueOf(response.RETURN_x));
                Logger.logDebug('Response: RETURNMESSAGES:'+string.valueOf(response.RETURNMESSAGES));
                Logger.logDebug('Response: UNITS_OF_MEASURE:'+string.valueOf(response.UNITS_OF_MEASURE));
                
                
                ///Add logic of Response handling here
                if(response.RETURN_x != NULL){
                    tstLog.Status__c = response.RETURN_x.TYPE_x;
                    tstLog.SAP_Message__c = response.RETURN_x.MESSAGE;
                }else{
                    tstLog.Status__c = 'No Response';
                    tstLog.SAP_Message__c = 'No Response Recieved from SAP';
                }               
            }else{
               tstLog.Status__c = 'Failed';
               tstLog.SAP_Message__c = 'Service Deactivated in Salesforce';
            }
            
            }catch(Exception ex){
               Logger.logException('Error in ORL_SAP_InventoryIntegrationService.createTestPushCall:'+ex.getMessage());
               tstLog.Status__c = 'Exception';
               tstLog.SAP_Message__c = ex.getMessage();
            }   
       }
       createInterfaceLogs();

    }catch(Exception ex){
       Logger.logException('Error in ORL_SAP_InventoryIntegrationService.createPushCall:'+ex.getMessage());
    }   
}//updateInventoryInSAP


/*************************************End: Create/Update Call Methods************************************/


/*************************************Start: Pull Call Methods************************************/
public void pullInventoryFromSAP() {
    list<Property__c> propLst = new list<Property__c>();
    ORL_InventoryDomain invDomObj = new ORL_InventoryDomain();
    
    try{
        string rentalUnitRectypeId = ORL_Util.gtRecordtypeId(PROPERTY, RENTAL);
       
       serviceSettings = retrieveServiceSettings(system.label.ORL_SAP_InventoryPullCall);
       //create log for pull request
       initiateParentLog(PROPERTY);
    //move ahead only if service is active          
    if(isServiceActive()){    
       //initiate pull request
       ORL_SAP_InventoryPullInterface.zlease_details pullRequest = new ORL_SAP_InventoryPullInterface.zlease_details();
       
       pullRequest.inputHttpHeaders_x = new Map<String,String>();
       pullRequest.inputHttpHeaders_x.put('Authorization', getAuthCode());
       pullRequest.endpoint_x  = serviceSettings.EndPointURL__c;
       Logger.logDebug('inputHttpHeaders_x'+pullRequest.inputHttpHeaders_x);
       Logger.logDebug('endpoint_x'+pullRequest.endpoint_x);
       
       ORL_SAP_InventoryPullInterface.TABLE_OF_ZSDST_RENTAL_OBJ_STRUCTURE response = new ORL_SAP_InventoryPullInterface.TABLE_OF_ZSDST_RENTAL_OBJ_STRUCTURE();
       ORL_SAP_InventoryPullInterface.ZSD_LEASE_INPUT dtParams = new ORL_SAP_InventoryPullInterface.ZSD_LEASE_INPUT();
       
       //Call method to retrieve Last success Log's date and time
       logger.logDebug('Set Date Params for serviceSettings :'+serviceSettings);
       //setDateParams();
       logger.logDebug('after Set Date Params:'+pullDates);
       dtParams.FROM_DATE = pullDates.FROMDATE;
       dtParams.FROM_TIME = pullDates.FROMTIME;
       dtParams.TO_DATE = pullDates.TODATE;
       dtParams.TO_TIME = pullDates.TOTIME;
       
       logger.logDebug('RENTAL_OBJECTS:'+response);
       logger.logDebug('dtParams:'+dtParams);
       
       
       response = pullRequest.ZSD_FM_RENTAL_OBJECTS(dtParams,response);
       logger.logDebug('RENTAL_OBJECTS after:'+response);
       
       //parse response if sucess else log error in Log and exit
       if(response.item != NULL && !response.item.isEmpty()){
          parentLog.Status__c = 'Success';
          parentLog.SAP_Message__c = 'Records Recieved, Count: '+response.item.size();
          insert parentLog;
          list<string> proCodes = new list<string>();
          list<string> proNames = new list<string>();
          for(ORL_SAP_InventoryPullInterface.ZSDST_RENTAL_OBJ_STRUCTURE respObj: response.item){
            Property__c propObj = new Property__c();
            propObj.Property_Type__c = DEFAULTPROPTYPE;
            propObj.Rental_Company_Code__c = respObj.BUKRS;
            propObj.Rental_Company_Name__c = respObj.BUTXT;
            propObj.Project_Code__c = respObj.SWENR;
            propObj.Business_Entity_Name__c = respObj.XWETEXT;
            propObj.Rental_Type__c = respObj.ROTYPE;
            propObj.Rental_Property_Name__c = respObj.XMETXT;
            propObj.Number_of_Rental_Unit__c = respObj.SMENR;
            propObj.Rental_Building_Number__c = respObj.SGENR;
            propObj.Description_of_Building__c = respObj.XGETXT;
            propObj.Rental_Land__c = respObj.SGRNR;
            propObj.Description_of_Land__c = respObj.XGRTXT;
            propObj.Usage_Type__c = string.isNotBlank(respObj.SNUNR) ? Decimal.valueOf(respObj.SNUNR) : NULL;
            propObj.Description_of_usage_type__c = respObj.XMBEZ;
            propObj.Rental_Floor__c = string.isNotBlank(respObj.SSTOCKW)? Decimal.valueOf(respObj.SSTOCKW) : NULL;
            propObj.Description_for_Rental_Floor__c = respObj.XSTOCKL;
            propObj.Rental_End_Floor__c = string.isNotBlank(respObj.SSTCKBIS)? Decimal.valueOf(respObj.SSTCKBIS) : NULL;
            propObj.Description_for_End_Floor__c = respObj.TO_XSTOCKL;
            propObj.Total_Charge__c = respObj.TOTAL_CHARGABLE;
            propObj.Rental_Carpet_Area__c = respObj.CARPET_AREA;
            propObj.Parking_Space__c = respObj.PARKING_SPACE;
            propObj.Extra_Parking__c = respObj.EXTRA_PARKING;
            propObj.RecordtypeId = rentalUnitRectypeId;
            
            //retrieve Property name, Project code in list and call domain class to retrive existing records
            if(propObj.Project_Code__c != NULL && string.isNotBlank(propObj.Project_Code__c)){
               proCodes.add(propObj.Project_Code__c);
            }
            
            if(propObj.Number_of_Rental_Unit__c != NULL && string.isNotBlank(propObj.Number_of_Rental_Unit__c)){
               proNames.add(propObj.Number_of_Rental_Unit__c);
            }
            
            propLst.add(propObj);
            
          }
          
          logger.logDebug('Properties to add:'+propLst);
          
           //Retrieve Projects
           map<string, Project__c> projMap = proCodes.isEmpty() ? new map<string, Project__c>() : invDomObj.retrieveProjectBySAPCodes(proCodes);
           
           //Retrieve existing Properties
           map<string,Property__c> propMap = proNames.isEmpty() ? new map<string, Property__c>() : invDomObj.retrieveRentalPropBySAPIds(proNames);
           
           logger.logDebug('Projects to tag:'+projMap);
           logger.logDebug('Properties to update:'+propMap);
           
           //Bifurcate list for creation and update
           list<Property__c> newProperties = new list<Property__c>();
           list<Property__c> updateProperties = new list<Property__c>();
           list<Property__c> allProperties = new list<Property__c>();
           
           for(Property__c pObj: propLst){
             
             if(string.isNotBlank(pObj.Project_Code__c) && !projMap.isEmpty()){
               pObj.Project_Name__c = projMap.containsKey(pObj.Project_Code__c) ? projMap.get(pObj.Project_Code__c).id : NULL;
             }  
             
             if(!propMap.isEmpty() && propMap.containsKey(pObj.Number_of_Rental_Unit__c)){
                pObj.id = propMap.get(pObj.Number_of_Rental_Unit__c).id;
                updateProperties.add(pObj);
             }else{
                newProperties.add(pObj);
             }
           }
           
           //Do DML with Log object tag to each Property
           if(!newProperties.isEmpty()){
            try{
             invDomObj.insertProperties(newProperties);
             allProperties.addAll(newProperties);
             logger.logDebug('Properties inserted:'+newProperties);
            }catch (exception ex){
             SAP_Interface_Log__c tstLog1 = new SAP_Interface_Log__c();
             logLst.add(tstLog1);
             tstLog1.Logging_Time__c = datetime.Now();
             tstLog1.Logging_User__c = UserInfo.getUserId();
             tstLog1.Parent_Log__c = parentLog.Id;
             tstLog1.Related_Object__c = PROPERTY;
             tstLog1.Description__c = 'Pull Request for Properties Failed to Insert, count:'+newProperties.size();
             tstLog1.Status__c = 'Failed Insert';
             tstLog1.SAP_Message__c = ex.getMessage();
             
              parentLog.Status__c = 'Failed';
              parentLog.SAP_Message__c = ex.getMessage();
              upsert parentLog;
            }           
           }
           
           if(!updateProperties.isEmpty()){
             try{
               invDomObj.amendProperties(updateProperties);
               allProperties.addAll(updateProperties);
               logger.logDebug('Properties updated:'+updateProperties);
             }catch (exception ex){
                 SAP_Interface_Log__c tstLog1 = new SAP_Interface_Log__c();
                 logLst.add(tstLog1);
                 tstLog1.Logging_Time__c = datetime.Now();
                 tstLog1.Logging_User__c = UserInfo.getUserId();
                 tstLog1.Parent_Log__c = parentLog.Id;
                 tstLog1.Related_Object__c = PROPERTY;
                 tstLog1.Description__c = 'Pull Request for Properties Failed to Update, count:'+updateProperties.size();
                 tstLog1.Status__c = 'Failed Update';
                 tstLog1.SAP_Message__c = ex.getMessage();
                 
                 parentLog.Status__c = 'Failed';
                 parentLog.SAP_Message__c = ex.getMessage();
                 upsert parentLog;
             }  
           }
           
           if(!allProperties.isEmpty()){
             for(Property__c pObj: allProperties){
                SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
                logLst.add(tstLog);
                tstLog.Logging_Time__c = datetime.Now();
                tstLog.Logging_User__c = UserInfo.getUserId();
                tstLog.Property__c = pObj.Id;
                tstLog.Parent_Log__c = parentLog.Id;
                tstLog.Related_Object__c = gtObjectName(pObj.Id);
                tstLog.Status__c = 'Success';
                tstLog.SAP_Message__c = 'Pull Operation Completed';
                tstLog.Description__c = 'Pull Request for Property : '+pObj.Number_of_Rental_Unit__c;
                tstLog.Type__c = serviceSettings.DeveloperName;
             }
           }
           
           createInterfaceLogs();
          
       }else{
          parentLog.Status__c = 'Success';
          parentLog.SAP_Message__c = 'Empty Response';
          insert parentLog;
       }
    }else{
            parentLog.Status__c = 'Failed';
            parentLog.SAP_Message__c = 'Service Inactivated in Salesforce';
            insert parentLog;
    }
    }catch(Exception ex){
       Logger.logException('Error in ORL_SAP_InventoryIntegrationService.inventoryPullCall:'+ex.getMessage());
       parentLog.Status__c = 'Failed';
       parentLog.SAP_Message__c = ex.getMessage();
       upsert parentLog;
    }
     logger.logDebug('logs created, finish');   
}
/*************************************End: Pull Call Methods************************************/

/*************************************Start: Create/Update Test Call Methods************************************/
public void createTestPropPushCall() {
    SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
    try{
        logLst.add(tstLog);
        tstLog.Logging_Time__c = datetime.Now();
        tstLog.Logging_User__c = UserInfo.getUserId();
        tstLog.Property__c = 'a0Kp0000008qf3M';
        tstLog.Related_Object__c = gtObjectName(tstLog.Property__c);
        tstLog.Status__c = 'In Progress';
        tstLog.SAP_Message__c = '';
        
        serviceSettings = retrieveServiceSettings('InventoryCreateCall');
        Logger.logDebug('serviceSettings'+serviceSettings);
        ORL_SAP_InventoryCreateInterface invCreateClsObj = new ORL_SAP_InventoryCreateInterface();
        ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATEResponse_element response = new ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATEResponse_element();
        ORL_SAP_InventoryCreateInterface.TABLE_OF_BAPI_MATRETURN2 retMsg = new ORL_SAP_InventoryCreateInterface.TABLE_OF_BAPI_MATRETURN2();
        ORL_SAP_InventoryCreateInterface.ZSDST_MATERIAL_STRUCTURE materialObj = new ORL_SAP_InventoryCreateInterface.ZSDST_MATERIAL_STRUCTURE();
        materialObj.SFDCID = 'a0Mp0000008qf14';
        materialObj.MATERIAL = 'OE2-B-9401';
        materialObj.MATL_DESC = 'Test Property 0003';
        materialObj.MATL_TYPE = 'FERT';
        materialObj.PLANT = '1147';
        materialObj.VKORG = '1131';
        materialObj.DISTR_CHAN = '11';
        materialObj.SATNR = 'FLAT-OE2-SUPERI603';
        materialObj.ATWRT = 'FLOOR - 31';
        materialObj.MSTAV = '41';
        materialObj.SALES_UNIT = 'FTC';
        materialObj.DELY_UNIT = '227.000';
        materialObj.STEUC = '9954';
        Logger.logdebug('materialObj:'+materialObj);

        ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE uomObj = new ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE();
        uomObj.DENOMINATR = '227';
        uomObj.ALT_UNIT = 'FTC';
        ORL_SAP_InventoryCreateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE UNITS_OF_MEASURE = new ORL_SAP_InventoryCreateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE();
        UNITS_OF_MEASURE.item = new ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE[]{uomObj};
        Logger.logdebug('UNITS_OF_MEASURE:'+UNITS_OF_MEASURE);
        
        
        ORL_SAP_InventoryCreateInterface.zcreate_material pushCallObj = new ORL_SAP_InventoryCreateInterface.zcreate_material();
        
        pushCallObj.inputHttpHeaders_x = new Map<String,String>();
        pushCallObj.inputHttpHeaders_x.put('Authorization', getAuthCode());
        pushCallObj.endpoint_x  = serviceSettings.EndPointURL__c;
        Logger.logDebug('inputHttpHeaders_x'+pushCallObj.inputHttpHeaders_x);
        Logger.logDebug('endpoint_x'+pushCallObj.endpoint_x);
        
        response = pushCallObj.ZSD_FM_MATERIAL_CREATE(materialObj,retMsg,UNITS_OF_MEASURE);
        Logger.logDebug('Response: Recieved:'+string.valueOf(response));
        Logger.logDebug('Response: MATERIAL_NUMBER:'+string.valueOf(response.MATERIAL_NUMBER));
        Logger.logDebug('Response: RETURN_x:'+string.valueOf(response.RETURN_x));
        Logger.logDebug('Response: RETURNMESSAGES:'+string.valueOf(response.RETURNMESSAGES));
        Logger.logDebug('Response: UNITS_OF_MEASURE:'+string.valueOf(response.UNITS_OF_MEASURE));
        

    }catch(Exception ex){
       Logger.logException('Error in ORL_SAP_InventoryIntegrationService.createTestPushCall:'+ex.getMessage());
       tstLog.Status__c = 'Failed';
       tstLog.SAP_Message__c = ex.getMessage();
    }   
    createInterfaceLogs();
}

public void createTestPropTypePushCall() {
    SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
    try{
        logLst.add(tstLog);
        tstLog.Logging_Time__c = datetime.Now();
        tstLog.Logging_User__c = UserInfo.getUserId();
        tstLog.Property_Type__c = 'a0Jp0000004Aa19EAC';
        tstLog.Related_Object__c = gtObjectName(tstLog.Property_Type__c);
        tstLog.Status__c = 'In Progress';
        tstLog.SAP_Message__c = '';
        
        serviceSettings = retrieveServiceSettings('InventoryCreateCall');
        Logger.logDebug('serviceSettings'+serviceSettings);
        ORL_SAP_InventoryCreateInterface invCreateClsObj = new ORL_SAP_InventoryCreateInterface();
        ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATEResponse_element response = new ORL_SAP_InventoryCreateInterface.ZSD_FM_MATERIAL_CREATEResponse_element();
        ORL_SAP_InventoryCreateInterface.TABLE_OF_BAPI_MATRETURN2 retMsg = new ORL_SAP_InventoryCreateInterface.TABLE_OF_BAPI_MATRETURN2();
        ORL_SAP_InventoryCreateInterface.ZSDST_MATERIAL_STRUCTURE materialObj = new ORL_SAP_InventoryCreateInterface.ZSDST_MATERIAL_STRUCTURE();
        materialObj.SFDCID = 'a0Kp0000008qf16';
        materialObj.MATERIAL = 'FLAT-OE2-SUPERI609';
        materialObj.MATL_DESC = 'Test Property Type 0007';
        materialObj.MATL_TYPE = 'KMAT';
        materialObj.PLANT = '1147';
        materialObj.VKORG = '1131';
        materialObj.DISTR_CHAN = '11';
        materialObj.SATNR = '';
        materialObj.ATWRT = '';
        materialObj.MSTAV = '41';
        materialObj.SALES_UNIT = 'FTC';
        materialObj.DELY_UNIT = '227.000';
        materialObj.STEUC = '9954';
        Logger.logdebug('materialObj:'+materialObj);

        ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE uomObj = new ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE();
        uomObj.DENOMINATR = '227.000';
        uomObj.ALT_UNIT = 'FTC';
        ORL_SAP_InventoryCreateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE UNITS_OF_MEASURE = new ORL_SAP_InventoryCreateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE();
        UNITS_OF_MEASURE.item = new ORL_SAP_InventoryCreateInterface.ZSD_ST_UNIT_MEASURE[]{uomObj};
        Logger.logdebug('UNITS_OF_MEASURE:'+UNITS_OF_MEASURE);
        
        
        ORL_SAP_InventoryCreateInterface.zcreate_material pushCallObj = new ORL_SAP_InventoryCreateInterface.zcreate_material();
        
        pushCallObj.inputHttpHeaders_x = new Map<String,String>();
        pushCallObj.inputHttpHeaders_x.put('Authorization', getAuthCode());
        pushCallObj.endpoint_x  = serviceSettings.EndPointURL__c;
        Logger.logDebug('inputHttpHeaders_x'+pushCallObj.inputHttpHeaders_x);
        Logger.logDebug('endpoint_x'+pushCallObj.endpoint_x);
        
        response = pushCallObj.ZSD_FM_MATERIAL_CREATE(materialObj,retMsg,UNITS_OF_MEASURE);
        Logger.logDebug('Response: Recieved:'+string.valueOf(response));
        Logger.logDebug('Response: MATERIAL_NUMBER:'+string.valueOf(response.MATERIAL_NUMBER));
        Logger.logDebug('Response: RETURN_x:'+string.valueOf(response.RETURN_x));
        Logger.logDebug('Response: RETURNMESSAGES:'+string.valueOf(response.RETURNMESSAGES));
        Logger.logDebug('Response: UNITS_OF_MEASURE:'+string.valueOf(response.UNITS_OF_MEASURE));

    }catch(Exception ex){
       Logger.logException('Error in ORL_SAP_InventoryIntegrationService.createTestPushCall:'+ex.getMessage());
       tstLog.Status__c = 'Failed';
       tstLog.SAP_Message__c = ex.getMessage();
    }   
    createInterfaceLogs();
}
/************************************Update***********************************/
public void updateTestPropPushCall() {
    SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
    try{
        logLst.add(tstLog);
        tstLog.Logging_Time__c = datetime.Now();
        tstLog.Logging_User__c = UserInfo.getUserId();
        tstLog.Property__c = 'a0Kp0000008qf3M';
        tstLog.Related_Object__c = gtObjectName(tstLog.Property__c);
        tstLog.Status__c = 'In Progress';
        tstLog.SAP_Message__c = '';
        
        serviceSettings = retrieveServiceSettings('InventoryUpdateCall');
        Logger.logDebug('serviceSettings'+serviceSettings);
        ORL_SAP_InventoryUpdateInterface invCreateClsObj = new ORL_SAP_InventoryUpdateInterface();
        ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGEResponse_element response = new ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGEResponse_element();
        ORL_SAP_InventoryUpdateInterface.TABLE_OF_BAPI_MATRETURN2 retMsg = new ORL_SAP_InventoryUpdateInterface.TABLE_OF_BAPI_MATRETURN2();
        ORL_SAP_InventoryUpdateInterface.ZSDST_MATERIAL_STRUCTURE materialObj = new ORL_SAP_InventoryUpdateInterface.ZSDST_MATERIAL_STRUCTURE();
        materialObj.SFDCID = 'a0Mp0000008qf14';
        materialObj.MATERIAL = 'OE2-B-9401';
        materialObj.MATL_DESC = 'Test Update Property 0003';
        materialObj.MATL_TYPE = 'FERT';
        materialObj.PLANT = '1147';
        materialObj.VKORG = '1131';
        materialObj.DISTR_CHAN = '11';
        materialObj.SATNR = 'FLAT-OE2-SUPERI601';
        materialObj.ATWRT = 'FLOOR - 31';
        materialObj.MSTAV = '41';
        materialObj.SALES_UNIT = 'FTC';
        materialObj.DELY_UNIT = '227.000';
        materialObj.STEUC = '9954';
        Logger.logdebug('materialObj:'+materialObj);

        ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE uomObj = new ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE();
        uomObj.DENOMINATR = '227';
        uomObj.ALT_UNIT = 'FTC';
        ORL_SAP_InventoryUpdateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE UNITS_OF_MEASURE = new ORL_SAP_InventoryUpdateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE();
        UNITS_OF_MEASURE.item = new ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE[]{uomObj};
        Logger.logdebug('UNITS_OF_MEASURE:'+UNITS_OF_MEASURE);
        
        
        ORL_SAP_InventoryUpdateInterface.zchange_material pushCallObj = new ORL_SAP_InventoryUpdateInterface.zchange_material();
        
        pushCallObj.inputHttpHeaders_x = new Map<String,String>();
        pushCallObj.inputHttpHeaders_x.put('Authorization', getAuthCode());
        pushCallObj.endpoint_x  = serviceSettings.EndPointURL__c;
        Logger.logDebug('inputHttpHeaders_x'+pushCallObj.inputHttpHeaders_x);
        Logger.logDebug('endpoint_x'+pushCallObj.endpoint_x);
        
        response = pushCallObj.ZSD_FM_MATERIAL_CHANGE(materialObj,retMsg,UNITS_OF_MEASURE);
        Logger.logDebug('Response: Recieved:'+string.valueOf(response));
        Logger.logDebug('Response: MATERIAL_NUMBER:'+string.valueOf(response.MATERIAL_NUMBER));
        Logger.logDebug('Response: RETURN_x:'+string.valueOf(response.RETURN_x));
        Logger.logDebug('Response: RETURNMESSAGES:'+string.valueOf(response.RETURNMESSAGES));
        Logger.logDebug('Response: UNITS_OF_MEASURE:'+string.valueOf(response.UNITS_OF_MEASURE));

    }catch(Exception ex){
       Logger.logException('Error in ORL_SAP_InventoryIntegrationService.createTestPushCall:'+ex.getMessage());
       tstLog.Status__c = 'Failed';
       tstLog.SAP_Message__c = ex.getMessage();
    }   
    createInterfaceLogs();
}

public void updateTestPropTypePushCall() {
    SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
    try{
        logLst.add(tstLog);
        tstLog.Logging_Time__c = datetime.Now();
        tstLog.Logging_User__c = UserInfo.getUserId();
        tstLog.Property__c = 'a0Kp0000008qf3M';
        tstLog.Related_Object__c = gtObjectName(tstLog.Property__c);
        tstLog.Status__c = 'In Progress';
        tstLog.SAP_Message__c = '';
        
        serviceSettings = retrieveServiceSettings('InventoryUpdateCall');
        Logger.logDebug('serviceSettings'+serviceSettings);
        ORL_SAP_InventoryUpdateInterface invCreateClsObj = new ORL_SAP_InventoryUpdateInterface();
        ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGEResponse_element response = new ORL_SAP_InventoryUpdateInterface.ZSD_FM_MATERIAL_CHANGEResponse_element();
        ORL_SAP_InventoryUpdateInterface.TABLE_OF_BAPI_MATRETURN2 retMsg = new ORL_SAP_InventoryUpdateInterface.TABLE_OF_BAPI_MATRETURN2();
        ORL_SAP_InventoryUpdateInterface.ZSDST_MATERIAL_STRUCTURE materialObj = new ORL_SAP_InventoryUpdateInterface.ZSDST_MATERIAL_STRUCTURE();
        materialObj.SFDCID = 'a0Kp0000008qf13';
        materialObj.MATERIAL = 'FLAT-OE2-SUPERI603';
        materialObj.MATL_DESC = 'Test Update Property Type 0004';
        materialObj.MATL_TYPE = 'KMAT';
        materialObj.PLANT = '1147';
        materialObj.VKORG = '1131';
        materialObj.DISTR_CHAN = '11';
        materialObj.SATNR = '';
        materialObj.ATWRT = '';
        materialObj.MSTAV = '41';
        materialObj.SALES_UNIT = 'FTC';
        materialObj.DELY_UNIT = '227.000';
        materialObj.STEUC = '9954';
        Logger.logdebug('materialObj:'+materialObj);

        ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE uomObj = new ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE();
        uomObj.DENOMINATR = '227';
        uomObj.ALT_UNIT = 'FTC';
        ORL_SAP_InventoryUpdateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE UNITS_OF_MEASURE = new ORL_SAP_InventoryUpdateInterface.TABLE_OF_ZSD_ST_UNIT_MEASURE();
        UNITS_OF_MEASURE.item = new ORL_SAP_InventoryUpdateInterface.ZSD_ST_UNIT_MEASURE[]{uomObj};
        Logger.logdebug('UNITS_OF_MEASURE:'+UNITS_OF_MEASURE);
        
        
        ORL_SAP_InventoryUpdateInterface.zchange_material pushCallObj = new ORL_SAP_InventoryUpdateInterface.zchange_material();
        
        pushCallObj.inputHttpHeaders_x = new Map<String,String>();
        pushCallObj.inputHttpHeaders_x.put('Authorization', getAuthCode());
        pushCallObj.endpoint_x  = serviceSettings.EndPointURL__c;
        Logger.logDebug('inputHttpHeaders_x'+pushCallObj.inputHttpHeaders_x);
        Logger.logDebug('endpoint_x'+pushCallObj.endpoint_x);
        
        response = pushCallObj.ZSD_FM_MATERIAL_CHANGE(materialObj,retMsg,UNITS_OF_MEASURE);
        Logger.logDebug('Response: Recieved:'+string.valueOf(response));
        Logger.logDebug('Response: MATERIAL_NUMBER:'+string.valueOf(response.MATERIAL_NUMBER));
        Logger.logDebug('Response: RETURN_x:'+string.valueOf(response.RETURN_x));
        Logger.logDebug('Response: RETURNMESSAGES:'+string.valueOf(response.RETURNMESSAGES));
        Logger.logDebug('Response: UNITS_OF_MEASURE:'+string.valueOf(response.UNITS_OF_MEASURE));

    }catch(Exception ex){
       Logger.logException('Error in ORL_SAP_InventoryIntegrationService.createTestPushCall:'+ex.getMessage());
       tstLog.Status__c = 'Failed';
       tstLog.SAP_Message__c = ex.getMessage();
    }   
    createInterfaceLogs();
}


public void inventoryTestPullCall(){
       serviceSettings = retrieveServiceSettings('InventoryPullCall');
       Logger.logDebug('serviceSettings'+serviceSettings);
       ORL_SAP_InventoryPullInterface.zlease_details pullRequest = new ORL_SAP_InventoryPullInterface.zlease_details();
       
       pullRequest.inputHttpHeaders_x = new Map<String,String>();
       pullRequest.inputHttpHeaders_x.put('Authorization', getAuthCode());
       pullRequest.endpoint_x  = serviceSettings.EndPointURL__c;
       Logger.logDebug('inputHttpHeaders_x'+pullRequest.inputHttpHeaders_x);
       Logger.logDebug('endpoint_x'+pullRequest.endpoint_x);
       
       ORL_SAP_InventoryPullInterface.TABLE_OF_ZSDST_RENTAL_OBJ_STRUCTURE RENTAL_OBJECTS = new ORL_SAP_InventoryPullInterface.TABLE_OF_ZSDST_RENTAL_OBJ_STRUCTURE();
       
       
       ORL_SAP_InventoryPullInterface.ZSD_LEASE_INPUT dtParams = new ORL_SAP_InventoryPullInterface.ZSD_LEASE_INPUT();
       dtParams.FROM_DATE = '04.02.2019';
       dtParams.FROM_TIME = '00:00:00';
       dtParams.TO_DATE = '14.02.2019';
       dtParams.TO_TIME = '23:00:00';
       
       
       logger.logDebug('RENTAL_OBJECTS:'+RENTAL_OBJECTS);
       logger.logDebug('dtParams:'+dtParams);
       
       RENTAL_OBJECTS = pullRequest.ZSD_FM_RENTAL_OBJECTS(dtParams,RENTAL_OBJECTS);
       logger.logDebug('RENTAL_OBJECTS after:'+RENTAL_OBJECTS);
}

/*************************************End: Create Call Methods************************************/


}//ORL_SAP_InventoryIntegrationService
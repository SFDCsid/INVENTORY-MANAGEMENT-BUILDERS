/*
*  Author: IBM India Pvt. Ltd.  
*  Description: Integration service class for Billing Plan Objects
*/
public class ORL_SAP_BillingPlanPullService extends ORL_SAP_BaseIntegrationService {

public static final string PAYPLAN = 'Payment_Plan__c';
public static final string PAYPLANLINEITEM = 'Payment_Plan_Line_Item__c';
public static final string NONSCHEME = 'Non Scheme';
public static final string LOGINPROGRESS = 'In Progress';

/*************************************Start: Pull Call Methods************************************/
public void pullBillingPlanFromSAP() {
    ORL_PaymentPlanDomain billPlndomObj = new ORL_PaymentPlanDomain();
    ORL_InventoryDomain invdomObj = new ORL_InventoryDomain();
    List<Id> BillingPlanObjList = new List<Id>();
      List<Id> listTowerId = new List<Id>();
    try{
        serviceSettings = retrieveServiceSettings(system.label.ORL_SAP_BillingPlanPullCall);
        Logger.logDebug('In pullBillingPlanFromSAP, serviceSettings'+serviceSettings);
        //create log for pull request
        initiateParentLog(PAYPLAN);
        
        if(isServiceActive()){
        //initiate pull request
          ORL_SAP_BillingPlanPull.zbilling_plan pullRequest = new ORL_SAP_BillingPlanPull.zbilling_plan();
       
           pullRequest.inputHttpHeaders_x = new Map<String,String>();
           pullRequest.inputHttpHeaders_x.put('Authorization', getAuthCode());
           pullRequest.endpoint_x  = serviceSettings.EndPointURL__c;
           Logger.logDebug('In pullBillingPlanFromSAP, inputHttpHeaders_x'+pullRequest.inputHttpHeaders_x);
           Logger.logDebug('In pullBillingPlanFromSAP, endpoint_x'+pullRequest.endpoint_x);
           
           ORL_SAP_BillingPlanPull.ZSD_FM_BILLING_PLANResponse_element responseObj = new ORL_SAP_BillingPlanPull.ZSD_FM_BILLING_PLANResponse_element();
           
           ORL_SAP_BillingPlanPull.TABLE_OF_ZSDST_BILLING_PLAN EX_BILLING_PLAN = new ORL_SAP_BillingPlanPull.TABLE_OF_ZSDST_BILLING_PLAN();
           
           ORL_SAP_BillingPlanPull.TABLE_OF_ZSDST_BILLING_PLAN EX_BILLING_PLAN_FULL = new ORL_SAP_BillingPlanPull.TABLE_OF_ZSDST_BILLING_PLAN();
           
           ORL_SAP_BillingPlanPull.TABLE_OF_BAPIRET2 RETURN_x = new ORL_SAP_BillingPlanPull.TABLE_OF_BAPIRET2();
           
           ORL_SAP_BillingPlanPull.ZSD_LEASE_INPUT dtParams = new ORL_SAP_BillingPlanPull.ZSD_LEASE_INPUT();
            //Call method to retrieve Last success Log's date and time
            logger.logDebug('In pullBillingPlanFromSAP, Set Date Params for serviceSettings :'+serviceSettings);
            setDateParams(PAYPLAN);
            
           logger.logDebug('In pullBillingPlanFromSAP, after Set Date Params:'+pullDates);
           /*dtParams.FROM_DATE = pullDates.FROMDATE;
           dtParams.FROM_TIME = pullDates.FROMTIME;
           dtParams.TO_DATE = pullDates.TODATE;
           dtParams.TO_TIME = pullDates.TOTIME; */
           dtParams.FROM_DATE = '10.08.2019';
           dtParams.FROM_TIME = '00:00:00';
           dtParams.TO_DATE = '19.08.2019';
           dtParams.TO_TIME = '23:00:00';
           system.debug('@@requestObj --'+dtParams.FROM_DATE);
           system.debug('@@requestObj --'+dtParams.FROM_TIME);
           system.debug('@@requestObj --'+dtParams.TO_DATE);
           system.debug('@@requestObj --'+dtParams.TO_TIME);
           logger.logDebug('In pullBillingPlanFromSAP, responseObj:'+responseObj);
           logger.logDebug('In pullBillingPlanFromSAP, dtParams:'+dtParams);
           system.debug('@@requestObj --'+pullRequest.ZSD_FM_BILLING_PLAN(EX_BILLING_PLAN,EX_BILLING_PLAN_FULL,dtParams,RETURN_x));
           responseObj = pullRequest.ZSD_FM_BILLING_PLAN(EX_BILLING_PLAN,EX_BILLING_PLAN_FULL,dtParams,RETURN_x);
           system.debug('@@responseObj --'+responseObj);
           logger.logDebug('In pullBillingPlanFromSAP, responseObj after:'+responseObj.EX_BILLING_PLAN.item);
           logger.logDebug('In pullBillingPlanFromSAP, responseObj after:'+responseObj.EX_BILLING_PLAN_FULL.item);
           logger.logDebug('In pullBillingPlanFromSAP, responseObj after:'+responseObj.RETURN_x.item);
           
           //system.debug('@@responseObj.EX_BILLING_PLAN.item.size()-->'+responseObj.EX_BILLING_PLAN.item.size());
           
           if(responseObj.EX_BILLING_PLAN_FULL.item != NULL && !responseObj.EX_BILLING_PLAN_FULL.item.isEmpty()){
              parentLog.Status__c = 'Success';
              parentLog.SAP_Message__c = 'Records Received, Count: '+responseObj.EX_BILLING_PLAN_FULL.item.size();
              insert parentLog;
              
              list<string> plantCodes = new list<string>();
              list<string> towerCodes = new list<string>();
              list<string> billPlanCodes = new list<string>();
              list<string> itemCodes = new list<string>();
              map<string,BillingPlan> billPlanObjs = new map<string,BillingPlan>();
              
              for(ORL_SAP_BillingPlanPull.ZSDST_BILLING_PLAN pObj: responseObj.EX_BILLING_PLAN_FULL.item){
               //if(!string.isBlank(pObj.INDICATOR) //&& !string.isBlank(pObj.PLANT) 
                if(!string.isBlank(pObj.PLANT) && !string.isBlank(pObj.TOWER) && !string.isBlank(pObj.BP_NO) 
                   && !string.isBlank(pObj.BP_ITEM_NO)) {
                    Payment_Plan_Line_Item__c plObj = new Payment_Plan_Line_Item__c();
                    plObj.Plant__c = pObj.PLANT;
                    plObj.Tower__c = pObj.TOWER;
                    plObj.Payment_Plan_Number__c = pObj.BP_NO;
                    plObj.Item_of_Payment_Plan__c = pObj.BP_ITEM_NO;
                    plObj.Date_Category__c = pObj.DATE_CATEGORY;
                    plObj.Payment_Date__c = !string.isBlank(pObj.BILLING_DATE) ? Date.ValueOf(pObj.BILLING_DATE) : NULL;
                    plObj.Date_Description__c = pObj.DATE_DESC;
                    plObj.Usage__c = pObj.MILESTONE;
                    plObj.Description__c = pObj.DESCRIPTION;
                    plObj.Percentage_Of_Value_To_Be_Invoiced__c = pObj.VALUE_PERCENTAGE;
                    plObj.Percentage__c= Decimal.ValueOf(pObj.VALUE_PERCENTAGE);
                    plObj.Currency_Key__c = pObj.WAERS;
                    plObj.Value_to_be_Billed__c = !string.isBlank(pObj.BILLING_VALUE) ? Decimal.ValueOf(pObj.BILLING_VALUE) : 0.0;
                    plObj.Billing_Block_For_Payment_Plan__c = pObj.BILLING_BLOCK;
                    plObj.Rule_In_Payment_Plan__c = pObj.BP_RULE;
                    plObj.Milestone_Number__c = pObj.MILESTONE_NO;
                    system.debug('@@pObj.PAYMENT_TERM-->'+pObj.PAYMENT_TERM);
                    system.debug('@@pObj.MILESTONE-->'+pObj.MILESTONE);
                    system.debug('@@pObj.DATE_DESC-->'+pObj.DATE_DESC);
                    system.debug('@@pObj.BP_ITEM_NO-->'+pObj.BP_ITEM_NO);
                    if(String.isNotBlank(pObj.PAYMENT_TERM)){
                        plObj.Terms_of_Payment_Key__c = pObj.PAYMENT_TERM;}
                    plObj.ID_For_Adopting_Billing__c = pObj.BP_ID;
                    
                    BillingPlan bPlanObj;
                    
                    if(billPlanObjs.containsKey(plObj.Payment_Plan_Number__c)){
                      bPlanObj = billPlanObjs.get(plObj.Payment_Plan_Number__c);
                    }else{
                      bPlanObj = new BillingPlan(plObj.Payment_Plan_Number__c, plObj.Plant__c, plObj.Tower__c);
                      billPlanObjs.put(plObj.Payment_Plan_Number__c,bPlanObj);
                    }
                      bPlanObj.insertRespLst.add(plObj);
                      plantCodes.add(pObj.PLANT);
                      towerCodes.add(pObj.TOWER);
                      billPlanCodes.add(pObj.BP_NO);
                      itemCodes.add(pObj.BP_ITEM_NO);
                }
              }
              logger.logDebug('In pullBillingPlanFromSAP, billPlanObjs map:'+billPlanObjs);
              logger.logDebug('plantCodesplantCodes'+plantCodes);
              logger.logDebug('towerCodestowerCodes'+towerCodes);
              logger.logDebug('billPlanCodesbillPlanCodes'+billPlanCodes);
              logger.logDebug('itemCodesitemCodes'+itemCodes);
              logger.logDebug('itemCodesitemCodes'+itemCodes);
              
              map<string,Payment_Plan__c> newPayPlanMap = new map<string,Payment_Plan__c>();
              map<Id,Id> mapTowerToBillingPlan = new map<Id,Id>();
              List<Tower__c> listUpdateTower = new List<Tower__c>();
              list<Payment_Plan_Line_Item__c> toInsertLineItems = new list<Payment_Plan_Line_Item__c>();
              
              Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();  
              if(!billPlanObjs.isEmpty()){
                //check if Billing plan exist, if not than create new billing plans else retrieve existing from database
                  map<string,Payment_Plan__c> existingBillPlanMap = billPlndomObj.retrievePaymentPlanBySAPNumber(billPlanCodes);
                  logger.logDebug('In pullBillingPlanFromSAP, existingBillPlanMap map:'+existingBillPlanMap);
                  
                  map<string, Project__c> projMap = invdomObj.retrieveProjectByPlant(plantCodes);
                  logger.logDebug('In pullBillingPlanFromSAP, existing projMap:'+projMap);
                  
                  map<string,map<string,Tower__c>> towerMap = invdomObj.retrieveTowerByName(towerCodes,plantCodes);
                  logger.logDebug('In pullBillingPlanFromSAP, existing towerMap:'+towerMap);
                  
                    for(string plnStr: billPlanObjs.keySet()){
                        if(!existingBillPlanMap.containsKey(plnStr)){
                         //To check if update Billing Plan Item does not have any existing Billing Plan
                            Integer i = 0;
                            Boolean checkBPforupdate = false;
                            if(checkBPforupdate==false){
                                BillingPlan bPlanObj = billPlanObjs.get(plnStr);
                               newPayPlanMap.put(plnStr, new Payment_Plan__c(Status__c = 'Approved',Active__c = true,RecordTypeid =defaultRecordTypeId, Payment_Plan_Number__c = bPlanObj.billPlanNum, Payment_Plan_Type__c = NONSCHEME, Project__c = (projMap.containsKey(bPlanObj.projectStr) ? projMap.get(bPlanObj.projectStr).id : NULL), Site__c = (projMap.containsKey(bPlanObj.projectStr) ? projMap.get(bPlanObj.projectStr).Site__c : NULL), Tower__c = (towerMap.containsKey(bPlanObj.projectStr) ? (towerMap.get(bPlanObj.projectStr).containsKey(bPlanObj.towerStr) ? towerMap.get(bPlanObj.projectStr).get(bPlanObj.towerStr).Id : NULL) : NULL)));
                            }
                        }
                    }
                    
                    //update parentLog;
                    
                    Logger.logDebug('In pullBillingPlanFromSAP, New Payment plans to insert:'+string.valueOf(newPayPlanMap));
                    
                    if(!newPayPlanMap.isEmpty()){
                      database.insert(newPayPlanMap.values());
                        for(Payment_Plan__c newPlnObj: newPayPlanMap.values()){
                            mapTowerToBillingPlan.put(newPlnObj.Tower__c, newPlnObj.Id); 
                            existingBillPlanMap.put(newPlnObj.Payment_Plan_Number__c, newPlnObj);
                            BillingPlan billingPlanObj= billPlanObjs.get(newPlnObj.Payment_Plan_Number__c);
                        }
                    }
                    
                    if(!mapTowerToBillingPlan.isEmpty()){
                        for(Tower__c t: [SELECT Id
                                         FROM Tower__c
                                         WHERE Id=:mapTowerToBillingPlan.keyset()]){
                                t.Billing_Plan__c= mapTowerToBillingPlan.get(t.id);
                                listUpdateTower.add(t);
                        }
                    }
                    
                    if(listUpdateTower.size()>0 && !listUpdateTower.isEmpty()){
                        update listUpdateTower;
                    }
                    
                    Logger.logDebug('In pullBillingPlanFromSAP, final BillPlanMap:'+existingBillPlanMap);
                 
                      for(BillingPlan bPln: billPlanObjs.values()){
                        if(existingBillPlanMap != null && existingBillPlanMap.size()>0 && !String.isBlank(bPln.billPlanNum)){
                            bPln.assignBillingPlanRecord(existingBillPlanMap.get(bPln.billPlanNum));
                            SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
                            logLst.add(tstLog);
                            tstLog.Logging_Time__c = datetime.Now();
                            tstLog.Logging_User__c = UserInfo.getUserId();
                            tstLog.Payment_Plan__c = bPln.billPlanObj.Id;
                            tstLog.Parent_Log__c = parentLog.Id;
                            tstLog.Related_Object__c = gtObjectName(bPln.billPlanObj.Id);
                            tstLog.Status__c = 'Success';
                            tstLog.SAP_Message__c = 'Pull Operation Completed';
                            tstLog.Description__c = 'Pull Request for Payment Plan : '+bPln.billPlanNum;
                            tstLog.Type__c = serviceSettings.DeveloperName;
                            BillingPlanObjList.add(bPln.billPlanObj.Id);
                            if(bPln.billPlanObj.Tower__c != null){
                            listTowerId.add(bPln.billPlanObj.Tower__c);
                            }
                          //create, update or delete the records accordingly and update logs accrodingly
                          //insert records
                          system.debug('toInsertLineItemstoInsertLineItems'+bPln.insertRespLst);
                          if(!bPln.insertRespLst.isEmpty()){
                            toInsertLineItems.addAll(bPln.insertRespLst);
                             system.debug('@@toInsertLineItems'+toInsertLineItems);
                          }
                        }
                      }
                      
                      Logger.logDebug('In pullBillingPlanFromSAP, toInsertLineItems:'+toInsertLineItems);
                      
                      try{
                        Set<string> stBPNumber = new Set<string>();
                        Set<Id> stBPId = new Set<Id>();
                        list<Payment_Plan_Line_Item__c> lstPPLi = new list<Payment_Plan_Line_Item__c>();
                        for(string s : billPlanCodes){
                            stBPNumber.add(s);
                        }
                        system.debug('stBPNumberstBPNumber'+stBPNumber);
                        
                        if(stBPNumber != null && !stBPNumber.isEmpty() && stBPNumber.size() > 0){
                            for(Payment_Plan__c pp : [select id from Payment_Plan__c where Payment_Plan_Number__c IN: stBPNumber]){
                                stBPId.add(pp.Id);
                            }
                        }
                        if(stBPId != null && !stBPId.isEmpty() && stBPId.size() > 0){
                            for(Payment_Plan_Line_Item__c ppli : [select id from Payment_Plan_Line_Item__c where Payment_Plan__c IN : stBPId]){
                                lstPPLi.add(ppli);
                            }
                        }
                        if(!lstPPLi.isEmpty()){
                            delete lstPPLi;
                        }
                        if(!toInsertLineItems.isEmpty()){
                            billPlndomObj.insertPaymentPlanItems(toInsertLineItems);
                        }
                      }catch(Exception ex){
                        for(SAP_Interface_Log__c lg: logLst){
                          lg.Status__c = 'Failed';
                          lg.SAP_Message__c = 'Internal Exception:'+ex.getMessage();
                        }
                      }
                      
                     createInterfaceLogs();
              }
              
              
            }else{
                logger.logDebug('In pullBillingPlanFromSAP, empty Response:');
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
       Logger.logException('Error in ORL_SAP_BillingPlanIntegrationService.inventoryPullCall:'+ex.getMessage()+'Line Number--'+ex.getLineNumber());
       parentLog.Status__c = 'Failed';
       parentLog.SAP_Message__c = ex.getMessage();
       upsert parentLog;
    }
    
     logger.logDebug('In pullBillingPlanFromSAP, logs created, finish');   
    //Mapping Payment Group and description
        
        /*Map<String, Payment_Term_Grouping__mdt> cmdBillingMap = new Map<String,Payment_Term_Grouping__mdt>();
        List<Payment_Plan_Line_Item__c> listPaymentPlanItem = new List<Payment_Plan_Line_Item__c>();
        for(Payment_Term_Grouping__mdt obj1:[SELECT MasterLabel,Detailed_Description__c,Order__c 
            FROM Payment_Term_Grouping__mdt ]){
                cmdBillingMap.put(obj1.MasterLabel,obj1);
        } */  
        // Map BillingPlanId to associated Payment Plan Line Item
        /*
        List<Payment_Plan_Line_Item__c> listPaymentPlanItem = new List<Payment_Plan_Line_Item__c>();
        Map<Id, List<Payment_Plan_Line_Item__c>> mapBillingPlanIdtoItem = new Map<Id, List<Payment_Plan_Line_Item__c>>();
        List<Payment_Plan__c> lstPaymentPlan = [SELECT Id, Name, (SELECT Id, Payment_Plan__r.Tower__c,Name,Payment_Group__c,    
            Due_After_Days__c,Terms_of_Payment_Key__c,Milestone_Number__c,Order__c
            FROM Payment_Plan_Line_Items__r)
            FROM Payment_Plan__c WHERE Id IN : BillingPlanObjList];
        
        for (Payment_Plan__c p : lstPaymentPlan){
                mapBillingPlanIdtoItem.put(p.Id, p.Payment_Plan_Line_Items__r);
        }
        system.debug('mapBillingPlanIdtoItemmapBillingPlanIdtoItem'+mapBillingPlanIdtoItem);
        Map<String, Decimal> mapTowerToDuedate = new Map<String, Decimal>();
        
        for (Tower_Due_Date_Against_Billing_Plan__c p : [ SELECT Id, Name,Payment_Group__c,Due_After_Days__c,Tower__c
                            FROM Tower_Due_Date_Against_Billing_Plan__c WHERE Tower__c IN : listTowerId ]){
                mapTowerToDuedate.put(p.Tower__c+'-'+p.Payment_Group__c, p.Due_After_Days__c);
        }
        Map<String,Payment_Term__c> mapPaymentTerm = new Map<String,Payment_Term__c>();
        for(Payment_Term__c ptm : [ SELECT Id, Name, Detailed_Description__c, Due_Days__c, Max_Occurrence__c,
            Min_Occurrence__c, Order__c, Tower__c, Type__c from Payment_Term__c WHERE Tower__c IN : listTowerId ]){
            mapPaymentTerm.put(ptm.Tower__c+'-'+ptm.Name, ptm);
        }
        for(List<Payment_Plan_Line_Item__c> paymentLineItem : mapBillingPlanIdtoItem.values())
        {
            for(Payment_Plan_Line_Item__c plObj : paymentLineItem  ){
                
                if(plObj.Payment_Group__c=='PL' && plObj.Milestone_Number__c!='000000000000'){
                    plObj.Payment_Plan_Line_Item_Name__c = cmdBillingMap.get('PL1').Detailed_Description__c;
                    plObj.Order__c = cmdBillingMap.get('PL1').Order__c;
                    plObj.Due_After_Days__c = mapTowerToDuedate.get(plObj.Payment_Plan__r.Tower__c+'-'+'PL');
                }
                else if(plObj.Payment_Group__c=='PL' && plObj.Milestone_Number__c=='000000000000'){
                    plObj.Payment_Plan_Line_Item_Name__c = cmdBillingMap.get('PL0').Detailed_Description__c;
                    plObj.Order__c = cmdBillingMap.get('PL0').Order__c;
                  plObj.Due_After_Days__c = mapTowerToDuedate.get(plObj.Payment_Plan__r.Tower__c+'-'+'PL');
                }
                if(plObj.Payment_Group__c=='IN' && plObj.Milestone_Number__c!='000000000000'){
                    plObj.Payment_Plan_Line_Item_Name__c = cmdBillingMap.get('IN1').Detailed_Description__c;
                    plObj.Order__c = cmdBillingMap.get('IN1').Order__c;
                    plObj.Due_After_Days__c = mapTowerToDuedate.get(plObj.Payment_Plan__r.Tower__c+'-'+'IN');
                }
                else if(plObj.Payment_Group__c=='IN' && plObj.Milestone_Number__c=='000000000000'){
                    plObj.Payment_Plan_Line_Item_Name__c = cmdBillingMap.get('IN0').Detailed_Description__c;
                    plObj.Order__c = cmdBillingMap.get('IN0').Order__c;
                  plObj.Due_After_Days__c = mapTowerToDuedate.get(plObj.Payment_Plan__r.Tower__c+'-'+'IN');
                }
                else{
                    if(cmdBillingMap.get(plObj.Payment_Group__c)!= null){
                        if(cmdBillingMap.get(plObj.Payment_Group__c).Detailed_Description__c != null ){
                            plObj.Payment_Plan_Line_Item_Name__c = cmdBillingMap.get(plObj.Payment_Group__c).Detailed_Description__c;
                        }
                        if(cmdBillingMap.get(plObj.Payment_Group__c).Order__c != null){
                            plObj.Order__c = cmdBillingMap.get(plObj.Payment_Group__c).Order__c;
                        }
                            plObj.Due_After_Days__c = mapTowerToDuedate.get(plObj.Payment_Plan__r.Tower__c+'-'+plObj.Payment_Group__c);
                    }
                }
                if(mapPaymentTerm != null && mapPaymentTerm.size() > 0 &&
                mapPaymentTerm.get(plObj.Payment_Plan__r.Tower__c+'-'+plObj.Name) != null){
                    if(plObj.Payment_Group__c=='IN' && plObj.Milestone_Number__c!='000000000000'){
                        plObj.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get(plObj.Payment_Plan__r.Tower__c+'-'+'IN01').Detailed_Description__c;
                        plObj.Order__c = mapPaymentTerm.get(plObj.Payment_Plan__r.Tower__c+'-'+'IN01').Order__c;
                        plObj.Due_After_Days__c = mapPaymentTerm.get(plObj.Payment_Plan__r.Tower__c+'-'+'IN01').Due_Days__c;
                    }
                    else if (plObj.Payment_Group__c=='IN' && plObj.Milestone_Number__c=='000000000000'){
                        plObj.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get(plObj.Payment_Plan__r.Tower__c+'-'+'IN00').Detailed_Description__c;
                        plObj.Order__c = mapPaymentTerm.get(plObj.Payment_Plan__r.Tower__c+'-'+'IN00').Order__c;
                        plObj.Due_After_Days__c = mapPaymentTerm.get(plObj.Payment_Plan__r.Tower__c+'-'+'IN00').Due_Days__c;
                    }
                    else {
                        plObj.Due_After_Days__c = mapPaymentTerm.get(plObj.Payment_Plan__r.Tower__c+'-'+plObj.Name).Due_Days__c;
                        plObj.Order__c = mapPaymentTerm.get(plObj.Payment_Plan__r.Tower__c+'-'+plObj.Name).Order__c;
                        plObj.Payment_Plan_Line_Item_Name__c = mapPaymentTerm.get(plObj.Payment_Plan__r.Tower__c+'-'+plObj.Name).Detailed_Description__c;
                    }   
                }   
                listPaymentPlanItem.add(plObj );
            }
        }
        if(!listPaymentPlanItem.isEmpty()){
            update listPaymentPlanItem;
        }
        
    system.debug('@@listPaymentPlanItem'+listPaymentPlanItem);
    //system.debug('@@cmdBillingMap'+cmdBillingMap);
    system.debug('@@mapBillingPlanIdtoItem'+mapBillingPlanIdtoItem);*/
}
/*************************************End: Pull Call Methods************************************/

public class BillingPlan{

public string billPlanNum;
public string projectStr;
public string towerStr;
public Payment_Plan__c billPlanObj;
public list<Payment_Plan_Line_Item__c> billPlanItems = new list<Payment_Plan_Line_Item__c>();
list<Payment_Plan_Line_Item__c> insertRespLst = new list<Payment_Plan_Line_Item__c>();
list<Payment_Plan_Line_Item__c> updateRespLst = new list<Payment_Plan_Line_Item__c>();
list<Payment_Plan_Line_Item__c> deleteRespLst = new list<Payment_Plan_Line_Item__c>();

public BillingPlan(string num, string proj, string tow){
  this.billPlanNum = num;
  this.projectStr = proj;
  this.towerStr = tow;
}

public void assignBillingPlanRecord(Payment_Plan__c plnObj){
  this.billPlanObj = plnObj;
  
  if(!this.insertRespLst.isEmpty()){
    for(Payment_Plan_Line_Item__c lObj: insertRespLst){
      lObj.Payment_Plan__c = plnObj.Id;
    }
  }
  
  if(!this.updateRespLst.isEmpty()){
    for(Payment_Plan_Line_Item__c lObj: updateRespLst){
      lObj.Payment_Plan__c = plnObj.Id;
    }
  }
  
}

}

}//ORL_SAP_BillingPlanPullService
/*
*  Author: IBM India Pvt. Ltd.  
*  Description: Integration service class for Billing Plan Objects
*  Change Log: 21/02/2019: created Vivek S
*  Change Log: 10/03/2019: created Aditya Bhasin
*
*/

public class ORL_SAP_BillingPlanIntegrationService extends ORL_SAP_BaseIntegrationService {

public static final string PAYPLAN = 'Payment_Plan__c';
public static final string PAYPLANLINEITEM = 'Payment_Plan_Line_Item__c';
public static final string NONSCHEME = 'Non Scheme';
public static final string LOGINPROGRESS = 'In Progress';
public static final string INSERTCODE = 'I';
public static final string UPDATECODE = 'U';
public static final string DELETECODE = 'D';



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
          ORL_SAP_BillingPlanPullInterface.zbilling_plan pullRequest = new ORL_SAP_BillingPlanPullInterface.zbilling_plan();
       
           pullRequest.inputHttpHeaders_x = new Map<String,String>();
           pullRequest.inputHttpHeaders_x.put('Authorization', getAuthCode());
           pullRequest.endpoint_x  = serviceSettings.EndPointURL__c;
           Logger.logDebug('In pullBillingPlanFromSAP, inputHttpHeaders_x'+pullRequest.inputHttpHeaders_x);
           Logger.logDebug('In pullBillingPlanFromSAP, endpoint_x'+pullRequest.endpoint_x);
           
           ORL_SAP_BillingPlanPullInterface.ZSD_FM_BILLING_PLANResponse_element responseObj = new ORL_SAP_BillingPlanPullInterface.ZSD_FM_BILLING_PLANResponse_element();
           
           ORL_SAP_BillingPlanPullInterface.TABLE_OF_ZSDST_BILLING_PLAN EX_BILLING_PLAN = new ORL_SAP_BillingPlanPullInterface.TABLE_OF_ZSDST_BILLING_PLAN();
           
           ORL_SAP_BillingPlanPullInterface.TABLE_OF_BAPIRET2 RETURN_x = new ORL_SAP_BillingPlanPullInterface.TABLE_OF_BAPIRET2();
           
           ORL_SAP_BillingPlanPullInterface.ZSD_LEASE_INPUT dtParams = new ORL_SAP_BillingPlanPullInterface.ZSD_LEASE_INPUT();
            //Call method to retrieve Last success Log's date and time
            logger.logDebug('In pullBillingPlanFromSAP, Set Date Params for serviceSettings :'+serviceSettings);
            setDateParams(PAYPLAN);
            
           logger.logDebug('In pullBillingPlanFromSAP, after Set Date Params:'+pullDates);
           /*dtParams.FROM_DATE = pullDates.FROMDATE;
           dtParams.FROM_TIME = pullDates.FROMTIME;
           dtParams.TO_DATE = pullDates.TODATE;
           dtParams.TO_TIME = pullDates.TOTIME; */
           dtParams.FROM_DATE = '03.05.2019';
           dtParams.FROM_TIME = '13:00:00';
           dtParams.TO_DATE = '03.05.2019';
           dtParams.TO_TIME = '23:00:00'; 
           system.debug('@@requestObj --'+dtParams.FROM_DATE);
           system.debug('@@requestObj --'+dtParams.FROM_TIME);
           system.debug('@@requestObj --'+dtParams.TO_DATE);
           system.debug('@@requestObj --'+dtParams.TO_TIME);
           logger.logDebug('In pullBillingPlanFromSAP, responseObj:'+responseObj);
           logger.logDebug('In pullBillingPlanFromSAP, dtParams:'+dtParams);
           system.debug('@@requestObj --'+pullRequest.ZSD_FM_BILLING_PLAN(EX_BILLING_PLAN,dtParams,RETURN_x));
           responseObj = pullRequest.ZSD_FM_BILLING_PLAN(EX_BILLING_PLAN,dtParams,RETURN_x);
           system.debug('@@responseObj --'+responseObj);
           logger.logDebug('In pullBillingPlanFromSAP, responseObj after:'+responseObj.EX_BILLING_PLAN.item);
           logger.logDebug('In pullBillingPlanFromSAP, responseObj after:'+responseObj.RETURN_x.item);
           
           //system.debug('@@responseObj.EX_BILLING_PLAN.item.size()-->'+responseObj.EX_BILLING_PLAN.item.size());
           if(responseObj.EX_BILLING_PLAN.item != NULL && !responseObj.EX_BILLING_PLAN.item.isEmpty()){
              parentLog.Status__c = 'Success';
              parentLog.SAP_Message__c = 'Records Received, Count: '+responseObj.EX_BILLING_PLAN.item.size();
              insert parentLog;
              
              list<string> plantCodes = new list<string>();
              list<string> towerCodes = new list<string>();
              list<string> billPlanCodes = new list<string>();
              list<string> itemCodes = new list<string>();
              map<string,BillingPlan> billPlanObjs = new map<string,BillingPlan>();
              
              for(ORL_SAP_BillingPlanPullInterface.ZSDST_BILLING_PLAN pObj: responseObj.EX_BILLING_PLAN.item){
               if(!string.isBlank(pObj.INDICATOR) //&& !string.isBlank(pObj.PLANT) 
                   && !string.isBlank(pObj.TOWER) && !string.isBlank(pObj.BP_NO) 
                   && !string.isBlank(pObj.BP_ITEM_NO)) {
                    Payment_Plan_Line_Item__c plObj = new Payment_Plan_Line_Item__c();
                    plObj.Plant__c = !string.isBlank(pObj.PLANT) ? pObj.PLANT : '';
                    plObj.Tower__c = pObj.TOWER;
                    plObj.Payment_Plan_Number__c = pObj.BP_NO;
                    plObj.Item_of_Payment_Plan__c = pObj.BP_ITEM_NO;
                    plObj.Date_Category__c = pObj.DATE_CATEGORY;
                    if(!pObj.INDICATOR.equals(DELETECODE)){
                    plObj.Payment_Date__c = !string.isBlank(pObj.BILLING_DATE) ? Date.ValueOf(pObj.BILLING_DATE) : NULL;}
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
                    system.debug('@@pObj.INDICATOR-->'+pObj.INDICATOR);
                    system.debug('@@pObj.PAYMENT_TERM-->'+pObj.PAYMENT_TERM);
                    system.debug('@@pObj.MILESTONE-->'+pObj.MILESTONE);
                    system.debug('@@pObj.DATE_DESC-->'+pObj.DATE_DESC);
                    system.debug('@@pObj.BP_ITEM_NO-->'+pObj.BP_ITEM_NO);
                    if(String.isNotBlank(pObj.PAYMENT_TERM)){
                        plObj.Terms_of_Payment_Key__c = pObj.PAYMENT_TERM;}
                    /*else if(String.isNotBlank(pObj.MILESTONE)){
                        plObj.Terms_of_Payment_Key__c = pObj.MILESTONE;
                       }
                    else{
                            plObj.Terms_of_Payment_Key__c = 'IN01';
                    }
                    if(String.isNotBlank(pObj.DATE_DESC)){
                        plObj.Terms_of_Payment_Key__c = pObj.DATE_DESC;
                    }*/
                    plObj.ID_For_Adopting_Billing__c = pObj.BP_ID;
                    
                    BillingPlan bPlanObj;
                    
                    if(billPlanObjs.containsKey(plObj.Payment_Plan_Number__c)){
                      bPlanObj = billPlanObjs.get(plObj.Payment_Plan_Number__c);
                    }else{
                      bPlanObj = new BillingPlan(plObj.Payment_Plan_Number__c, plObj.Plant__c, plObj.Tower__c);
                      billPlanObjs.put(plObj.Payment_Plan_Number__c,bPlanObj);
                    }

                      if(pObj.INDICATOR.equals(INSERTCODE)){
                        bPlanObj.insertRespLst.add(plObj);
                      }else if(pObj.INDICATOR.equals(UPDATECODE)){
                        bPlanObj.updateRespLst.add(plObj);
                      }else if(pObj.INDICATOR.equals(DELETECODE)){
                        bPlanObj.deleteRespLst.add(plObj);
                      }
                      logger.logDebug('deleteRespLstdeleteRespLst'+bPlanObj.deleteRespLst);
                      plantCodes.add(pObj.PLANT);
                      towerCodes.add(pObj.TOWER);
                      billPlanCodes.add(pObj.BP_NO);
                      itemCodes.add(pObj.BP_ITEM_NO);
                }
              }
              //logger.logDebug('deleteRespLstdeleteRespLst'+bPlanObj.deleteRespLst);
              logger.logDebug('In pullBillingPlanFromSAP, billPlanObjs map:'+billPlanObjs);
              
              map<string,Payment_Plan__c> newPayPlanMap = new map<string,Payment_Plan__c>();
              map<Id,Id> mapTowerToBillingPlan = new map<Id,Id>();
              List<Tower__c> listUpdateTower = new List<Tower__c>();
              list<Payment_Plan_Line_Item__c> toInsertLineItems = new list<Payment_Plan_Line_Item__c>();
              list<Payment_Plan_Line_Item__c> toUpdateLineItems = new list<Payment_Plan_Line_Item__c>();
              list<Payment_Plan_Line_Item__c> toDeleteLineItems = new list<Payment_Plan_Line_Item__c>();
              
              Id defaultRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId();  
              if(!billPlanObjs.isEmpty()){
                //check if Billing plan exist, if not than create new billing plans else retrieve existing from database
                  map<string,Payment_Plan__c> existingBillPlanMap = billPlndomObj.retrievePaymentPlanBySAPNumber(billPlanCodes);
                  logger.logDebug('In pullBillingPlanFromSAP, existingBillPlanMap map:'+existingBillPlanMap);
                  
                   //retrieve existing billing plan line items by referring Payment plan and item codes
                  map<string,map<string,Payment_Plan_Line_Item__c>> lineItemsMap = billPlndomObj.retrievePaymentPlanItemsBySAPNumber(itemCodes, billPlanCodes);
                  logger.logDebug('In pullBillingPlanFromSAP, existing lineItemsMap map:'+lineItemsMap);
                  
                  map<string, Project__c> projMap = invdomObj.retrieveProjectByPlant(plantCodes);
                  logger.logDebug('In pullBillingPlanFromSAP, existing projMap:'+projMap);
                  
                  map<string,map<string,Tower__c>> towerMap = invdomObj.retrieveTowerByName(towerCodes,plantCodes);
                  logger.logDebug('In pullBillingPlanFromSAP, existing towerMap:'+towerMap);
                  
                    for(string plnStr: billPlanObjs.keySet()){
                      if(!existingBillPlanMap.containsKey(plnStr)){
                         //To check if update Billing Plan Item does not have any existing Billing Plan
                            Integer i = 0;
                            Boolean checkBPforupdate = false;
                            BillingPlan checkBPdetails = billPlanObjs.get(plnStr);
                            if(checkBPdetails.insertRespLst.isEmpty() && !checkBPdetails.updateRespLst.isEmpty()){
                            system.debug('@@checkBPdetails.updateRespLst.size()-->'+checkBPdetails.updateRespLst.size());
                                while (i < checkBPdetails.updateRespLst.size())
                                {
                                //system.debug('@@checkBPdetails.updateRespLst.get(i).Item_of_Payment_Plan__c-->'+checkBPdetails.updateRespLst.get(i).Item_of_Payment_Plan__c);
                                //system.debug('@@responseObj.EX_BILLING_PLAN.item.size()-->'+responseObj.EX_BILLING_PLAN.item.size());
                                //system.debug('@@i-->'+i);
                                
                                  if(checkBPdetails.updateRespLst.get(i).Payment_Plan_Number__c==plnStr )
                                  {
                                  //  checkBPdetails.updateRespLst.remove(i);
                                    checkBPforupdate=true;
                                    parentLog.Status__c = 'Success';
                                    parentLog.SAP_Message__c = 'Records Received, Count: '+responseObj.EX_BILLING_PLAN.item.size()+'and Billing Plan does not exist for BP_ITEM_NO'+checkBPdetails.updateRespLst.get(i).Item_of_Payment_Plan__c;
                                    checkBPdetails.updateRespLst.remove(i);
 
                                  }else
                                  {
                                    i++;
                                  }
                                } 
                      }
                    if(checkBPforupdate==false){
                        BillingPlan bPlanObj = billPlanObjs.get(plnStr);
                       newPayPlanMap.put(plnStr, new Payment_Plan__c(Active__c = true,RecordTypeid =defaultRecordTypeId, Payment_Plan_Number__c = bPlanObj.billPlanNum, Payment_Plan_Type__c = NONSCHEME, Project__c = (projMap.containsKey(bPlanObj.projectStr) ? projMap.get(bPlanObj.projectStr).id : NULL), Tower__c = (towerMap.containsKey(bPlanObj.projectStr) ? (towerMap.get(bPlanObj.projectStr).containsKey(bPlanObj.towerStr) ? towerMap.get(bPlanObj.projectStr).get(bPlanObj.towerStr).Id : NULL) : NULL)));
                      //system.debug('@@newPayPlanMap'+newPayPlanMap);
                      }
                      }
                    }
                    
                    update parentLog;
                    
                    Logger.logDebug('In pullBillingPlanFromSAP, New Payment plans to insert:'+string.valueOf(newPayPlanMap));
                    
                    if(!newPayPlanMap.isEmpty()){
                    //  billPlndomObj.insertPaymentPlan(newPayPlanMap.values());
                      database.insert(newPayPlanMap.values());
                      for(Payment_Plan__c newPlnObj: newPayPlanMap.values()){
                      //system.debug('@@newPlnObj'+newPlnObj.Id);
                         mapTowerToBillingPlan.put(newPlnObj.Tower__c, newPlnObj.Id); 
                        existingBillPlanMap.put(newPlnObj.Payment_Plan_Number__c, newPlnObj);
                        BillingPlan billingPlanObj= billPlanObjs.get(newPlnObj.Payment_Plan_Number__c);
                      }
                      //system.debug('billPlanObjs@@ --'+billPlanObjs);
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
                          //system.debug('BillingPlanBillingPlan'+bPln.billPlanObj.Id);
                      //system.debug('@@bPln.billPlanNum'+bPln.billPlanNum);
                      //system.debug('@@existingBillPlanMap.get(bPln.billPlanNum)'+existingBillPlanMap.get(bPln.billPlanNum));
                      if(existingBillPlanMap != null && existingBillPlanMap.size()>0 && !String.isBlank(bPln.billPlanNum)){
                        bPln.assignBillingPlanRecord(existingBillPlanMap.get(bPln.billPlanNum));
                          //system.debug('@@ bPln'+bPln);
                          //system.debug('@@bPln.billPlanObj.Id'+bPln.billPlanObj.Id);
                           //Create sub logs under Billing plan records
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
                          if(!bPln.insertRespLst.isEmpty()){
                          //check if line item already exist
                              if(lineItemsMap.containsKey(bPln.billPlanObj.Payment_Plan_Number__c)){
                            Set<string> listBPItemNo = (lineItemsMap.get(bPln.billPlanObj.Payment_Plan_Number__c)).keyset();
                             //system.debug('@@listBPItemNo '+listBPItemNo );
                             //system.debug('@@bPln.insertRespLst'+bPln.insertRespLst);
                            Integer j = 0;
                                while (j < bPln.insertRespLst.size())
                                {
                                  if(listBPItemNo.contains(bPln.insertRespLst.get(j).Item_of_Payment_Plan__c))
                                  {
                                    bPln.insertRespLst.remove(j);
                                  }else
                                  {
                                    j++;
                                  }
                                } 
                                                              } 
                            toInsertLineItems.addAll(bPln.insertRespLst);
                             //system.debug('@@toInsertLineItems'+toInsertLineItems);
                          }
                          //update records
                          if(!bPln.updateRespLst.isEmpty()){
                             for(Payment_Plan_Line_Item__c pObj: bPln.updateRespLst){
                               Boolean shiftToInsert = false;
                               if(lineItemsMap.containsKey(pObj.Payment_Plan_Number__c)){
                                 if(lineItemsMap.get(pObj.Payment_Plan_Number__c).containsKey(pObj.Item_of_Payment_Plan__c)){
                                   pObj.id = lineItemsMap.get(pObj.Payment_Plan_Number__c).get(pObj.Item_of_Payment_Plan__c).Id;
                                   toUpdateLineItems.add(pObj);
                                 }else{
                                   shiftToInsert = true;
                                 }
                               }else{
                                 shiftToInsert = true;
                               }
                               
                               if(shiftToInsert){
                                 toInsertLineItems.add(pObj);
                               }
                             }
                          }
                          //delete records
                          system.debug('deleteitemsofbillingplan'+bPln.deleteRespLst);
                          if(!bPln.deleteRespLst.isEmpty()){
                             for(Payment_Plan_Line_Item__c pObj: bPln.deleteRespLst){
                               if(lineItemsMap.containsKey(pObj.Payment_Plan_Number__c)){
                                 if(lineItemsMap.get(pObj.Payment_Plan_Number__c).containsKey(pObj.Item_of_Payment_Plan__c)){
                                   pObj.id = lineItemsMap.get(pObj.Payment_Plan_Number__c).get(pObj.Item_of_Payment_Plan__c).Id;
                                   toDeleteLineItems.add(pObj);
                                 }
                               }
                             }
                          }
                        }
                      }//for
                      
                      Logger.logDebug('In pullBillingPlanFromSAP, toInsertLineItems:'+toInsertLineItems);
                      Logger.logDebug('In pullBillingPlanFromSAP, toUpdateLineItems:'+toUpdateLineItems);
                      Logger.logDebug('In pullBillingPlanFromSAP, toDeleteLineItems:'+toDeleteLineItems);
                      
                      try{
                        if(!toInsertLineItems.isEmpty()){
                            billPlndomObj.insertPaymentPlanItems(toInsertLineItems);
                        }
                        
                        if(!toUpdateLineItems.isEmpty()){
                            billPlndomObj.amendPaymentPlanItems(toUpdateLineItems);
                        }
                        
                        if(!toDeleteLineItems.isEmpty()){
                           billPlndomObj.deletePaymentPlanItems(toDeleteLineItems);
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
        Map<String, Payment_Term_Grouping__mdt> cmdBillingMap = new Map<String,Payment_Term_Grouping__mdt>();
        List<Payment_Plan_Line_Item__c> listPaymentPlanItem = new List<Payment_Plan_Line_Item__c>();
        for(Payment_Term_Grouping__mdt obj1:[SELECT MasterLabel,Detailed_Description__c,Order__c FROM Payment_Term_Grouping__mdt ]){
                             cmdBillingMap.put(obj1.MasterLabel,obj1);
                                      }
                                      
        // Map BillingPlanId to associated Payment Plan Line Item
        Map<Id, List<Payment_Plan_Line_Item__c>> mapBillingPlanIdtoItem = new Map<Id, List<Payment_Plan_Line_Item__c>>();
        for (Payment_Plan__c p : [ SELECT Id, Name, (SELECT Id, Payment_Plan__r.Tower__c,Name,Payment_Group__c,Due_After_Days__c,Terms_of_Payment_Key__c,Milestone_Number__c,Order__c
                            FROM Payment_Plan_Line_Items__r)
        FROM Payment_Plan__c WHERE Id IN : BillingPlanObjList
        ]) {
                mapBillingPlanIdtoItem.put(p.Id, p.Payment_Plan_Line_Items__r);
        }
        
        Map<String, Decimal> mapTowerToDuedate = new Map<String, Decimal>();
        for (Tower_Due_Date_Against_Billing_Plan__c p : [ SELECT Id, Name,Payment_Group__c,Due_After_Days__c,Tower__c
                            FROM Tower_Due_Date_Against_Billing_Plan__c WHERE Tower__c IN : listTowerId ]){
                mapTowerToDuedate.put(p.Tower__c+'-'+p.Payment_Group__c, p.Due_After_Days__c);
        }
        
        for(List<Payment_Plan_Line_Item__c> paymentLineItem : mapBillingPlanIdtoItem.values()){
        for(Payment_Plan_Line_Item__c plObj : paymentLineItem  ){
            
            if(plObj.Payment_Group__c=='PL' && plObj.Milestone_Number__c!='000000000000'){
                plObj.Payment_Plan_Line_Item_Name__c = cmdBillingMap.get('PL1').Detailed_Description__c;
                plObj.Order__c = cmdBillingMap.get('PL1').Order__c;
               // plObj.Due_After_Days__c= cmdBillingMap.get('PL1').Days__c ;
                plObj.Due_After_Days__c = mapTowerToDuedate.get(plObj.Payment_Plan__r.Tower__c+'-'+'PL1');
            }
            else if(plObj.Payment_Group__c=='PL' && plObj.Milestone_Number__c=='000000000000'){
                plObj.Payment_Plan_Line_Item_Name__c = cmdBillingMap.get('PL0').Detailed_Description__c;
                plObj.Order__c = cmdBillingMap.get('PL0').Order__c;
              //  plObj.Due_After_Days__c= cmdBillingMap.get('PL0').Days__c ;
              plObj.Due_After_Days__c = mapTowerToDuedate.get(plObj.Payment_Plan__r.Tower__c+'-'+'PL0');
            }
            else{
            
         //   system.debug('@@cmdBillingMap.get(plObj.Payment_Group__c).Detailed_Description__c'+plObj.Terms_of_Payment_Key__c);
          //  system.debug('@@cmdBillingMap.get(plObj.Payment_Group__c).Detailed_Description__c'+plObj.Payment_Group__c);
            //  system.debug('@@cmdBillingMap.get(plObj.Payment_Group__c).Detailed_Description__c'+cmdBillingMap.get(plObj.Payment_Group__c));
              
              if(cmdBillingMap.get(plObj.Payment_Group__c)!= null){
               if(cmdBillingMap.get(plObj.Payment_Group__c).Detailed_Description__c != null ){
                plObj.Payment_Plan_Line_Item_Name__c = cmdBillingMap.get(plObj.Payment_Group__c).Detailed_Description__c;
                }
                 if(cmdBillingMap.get(plObj.Payment_Group__c).Order__c != null){
                plObj.Order__c = cmdBillingMap.get(plObj.Payment_Group__c).Order__c;
                }
              //   if(cmdBillingMap.get(plObj.Payment_Group__c).Days__c != null){
               // plObj.Due_After_Days__c= cmdBillingMap.get(plObj.Payment_Group__c).Days__c ;
               plObj.Due_After_Days__c = mapTowerToDuedate.get(plObj.Payment_Plan__r.Tower__c+'-'+plObj.Payment_Group__c);
              //  }
           }
            }
            listPaymentPlanItem.add(plObj );
            }
        }
        
        
        if(!listPaymentPlanItem.isEmpty()){
            update listPaymentPlanItem;
        }
    //system.debug('@@cmdBillingMap'+cmdBillingMap);
    //system.debug('@@mapBillingPlanIdtoItem'+mapBillingPlanIdtoItem);
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

}//ORL_SAP_InventoryIntegrationService
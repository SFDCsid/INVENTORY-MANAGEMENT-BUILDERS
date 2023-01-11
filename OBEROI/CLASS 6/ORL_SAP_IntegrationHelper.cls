/*
*Author: Vivek S, Aditya Bhasin
*Date: 15/02/2019
*Description: Integration Layer methods to make SOAP callouts to SAP
*Changed by:  Aditya Bhasin for Residential Customer Creation Logic on 19/03/2019
*Changed by:  Aditya Bhasin for Broker Logic on 03/04/2019
*Changed by:  Aditya Bhasin for Sales Order Creation and Updation Logic on 04/04/2019
*/ 
//TODO: add method headers
public class ORL_SAP_IntegrationHelper{

/************************************Start: Integration Layer Methods************************************/
    //Method to create Inventory in SAP
    @future (callout=true)
    public static void createInventoryInSAPFuture(list<string> invIds) {
       ORL_SAP_InventoryIntegrationService servObj = new ORL_SAP_InventoryIntegrationService();
       Logger.logDebug('In Future Class for createInventoryInSAPFuture');
       servObj.createInventoryInSAP(invIds,servObj.gtObjectName(invIds.get(0)));
       Logger.logDebug('Completed Future Class for createInventoryInSAPFuture');
    }
    
    //Method to update Inventory in SAP
    @future (callout=true)
    public static void updateInventoryInSAPFuture(list<string> invIds) {
       ORL_SAP_InventoryIntegrationService servObj = new ORL_SAP_InventoryIntegrationService();
       Logger.logDebug('In Future Class for updateInventoryInSAPFuture');
       servObj.updateInventoryInSAP(invIds,servObj.gtObjectName(invIds.get(0)));
       Logger.logDebug('Completed Future Class for updateInventoryInSAPFuture');
    }
    
    //Method to Pull Inventory from SAP
    @future (callout=true)
    public static void getInventoryFromSAPFuture() {
       ORL_SAP_InventoryIntegrationService servObj = new ORL_SAP_InventoryIntegrationService();
       Logger.logDebug('In Future Class for getInventoryFromSAPFuture');
       servObj.pullInventoryFromSAP();
       Logger.logDebug('Completed Future Class for getInventoryFromSAPFuture');
    }
    
    //Method to Pull Billing Plan from SAP
    @future (callout=true)
    public static void getBillingPlanFromSAPFuture() {
       //ORL_SAP_BillingPlanIntegrationService servObj = new ORL_SAP_BillingPlanIntegrationService();
       ORL_SAP_BillingPlanPullService servObj = new ORL_SAP_BillingPlanPullService();
       Logger.logDebug('In Future Class for getBillingPlanFromSAPFuture');
       servObj.pullBillingPlanFromSAP();
       Logger.logDebug('Completed Future Class for getBillingPlanFromSAPFuture');
    }
    
    //Method to Create Residential Customer in SAP
    @future (callout=true)
    public static void createResidentialCustomerInSAPFuture(id BookId) {
       ORL_SAP_CustomerIntegrationService servObj = new ORL_SAP_CustomerIntegrationService();
       Logger.logDebug('In Future Class for createResidentialCustomerInSAPFuture');
       servObj.createResidentialCustomerInSAP(BookId);
       Logger.logDebug('Completed Future Class for createResidentialCustomerInSAPFuture');
    }
    
    //Method to update Residential Customer in SAP
    @future (callout=true)
    public static void updateResidentialCustomerInSAPFuture(id BookId) {
       ORL_SAP_CustomerIntegrationService servObj = new ORL_SAP_CustomerIntegrationService();
       Logger.logDebug('In Future Class for updateResidentialCustomerInSAPFuture');
       servObj.updateResidentialCustomerInSAP(BookId);
       Logger.logDebug('Completed Future Class for updateResidentialCustomerInSAPFuture');
    }
    
    //Added by Nistha Anand to accomodate SalesOrder Creation and Updation functionality in SAP.
    //Method to call CreateSalesOrder in SAP Integration Service
    @future (callout=true)
    public static void createSalesOrderInSAPFuture(Id BookingId){
        system.debug('In call Create SalesOrder method'+BookingId);
        ORL_SAP_SalesOrderIntegrationServiceV1 createSalesOrderObj = new ORL_SAP_SalesOrderIntegrationServiceV1();
        createSalesOrderObj.createSalesOrderInSAP(BookingId);
        system.debug('Create Method Call Completed');
        
    }
    
    //Method to call UpdateSalesOrder in SAP Integration Service
    @future (callout=true)
    public static void updateSalesOrderInSAPFuture(Id BookingId){
        system.debug('In call Update SalesOrder method'+BookingId);
        ORL_SAP_SalesOrderIntegrationServiceV1 updateSalesOrderObj = new ORL_SAP_SalesOrderIntegrationServiceV1();
        updateSalesOrderObj.updateSalesOrderInSAP(BookingId);
        system.debug('Update Method Call Completed');
        }
        
    //Method to pull Broker from SAP Integration Service
    @future (callout=true)
    public static void getBrokerFromSAPFuture(){
        ORL_SAP_BrokerIntegrationService servObj = new ORL_SAP_BrokerIntegrationService();
       Logger.logDebug('In Future Class for getBrokerFromSAPFuture');
       servObj.pullBrokerFromSAP();
       Logger.logDebug('Completed Future Class for getBrokerFromSAPFuture');
        }
/************************************End: Integration Layer Methods************************************/    
 
}
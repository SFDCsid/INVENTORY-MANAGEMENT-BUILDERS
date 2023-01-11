/*
*  Author: Shweta Dewangan
*  Description: Integration service class for SalesOrder Object
*  Change Log: 15-03-2019: created
*/

public class ORL_SAP_SalesOrderIntegrationService extends ORL_SAP_BaseIntegrationService{

    public void createSalesOrderSAP(list<Property__c> propertyList, list<Booking__c> bookingList, list<Payment_Plan__c> paymentPlanList){
    List<ORL_SAP_SalesOrderCreateInterface.ZSD_ST_BILLING_PLAN> billingPlanList = new List<ORL_SAP_SalesOrderCreateInterface.ZSD_ST_BILLING_PLAN>();
    
        for(Booking__c bookingObj : bookingList){
            ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_HEADER orderHeaderObj = new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_HEADER();
            ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM orderItemObj = new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM();
            orderHeaderObj.SFDCID = bookingObj.Id;
            orderHeaderObj.VKORG = bookingObj.CompanyName__c;
            orderHeaderObj.VTWEG = bookingObj.Distribution_channel__c;
            orderHeaderObj.WERKS = bookingObj.PlantCode__c;
            //orderHeaderObj.AUART = bookingObj.CompanyName__c;
            orderHeaderObj.BSTKD = bookingObj.Customer_Reference_Number__c;
            orderHeaderObj.BSTDK = String.valueOf(bookingObj.Booking_Date__c);
            orderHeaderObj.AUGRU = bookingObj.Order_Reason__c;
            orderHeaderObj.AUDAT = String.valueOf(bookingObj.Booking_Date__c);
            orderHeaderObj.GWLDT = String.valueOf(bookingObj.Allotment_Date__c);
            orderHeaderObj.MAHDT = String.valueOf(bookingObj.Agreement_Date__c);
            
            //orderItemObj.POSNR = Sales Document Item not foud in Booking__c
            orderItemObj.MATNR = bookingObj.Material_No__c;
            //orderItemObj.ZMENG = bookingObj.Carpet_Area__c;
           // orderItemObj.ZIEME = bookingObj.Carpet_Area_UOM__c;
            //orderItemObj.KWMENG = bookingObj.Order Quantity not there;

            for(Property__c propertyObj : propertyList){    
                ORL_SAP_SalesOrderCreateInterface.ZSD_ST_CONDITION orderCondition = new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_CONDITION();       
                /*orderCondition.ITM_NUMBER = propertyObj.
                orderCondition.COND_TYPE =
                orderCondition.COND_RATE =*/
                
            }
            
        
        }
         
    }

}
/*
*  Author: Nistha Anand
*  Description: Integration service class for Sales Order Objects
*  Change Log: 28/03/2019: created by Aditya Bhasin
*  Change Log: Logic corrected by Aditya Bhasin for Sales order mapping fields 06.04.2019
*/

public class ORL_SAP_SalesOrderIntegrationServiceV1 extends ORL_SAP_BaseIntegrationService 
{
    public static final string LOGINPROGRESS = 'In Progress';
    public string single='0';
    public string tandom='0';
    public string triple='0';
    Map<string,string> mapOfBookingSource = new Map<String,String>();
    public string formatDate(date ipDt){
        string retStr;
        if(ipDt!=null)
          retStr = ipDt.day()+'.'+ipDt.month()+'.'+ipDt.year();
     else{
         
         retStr='';
     }
         return retStr;
        
    }

    public void createSalesOrderInSAP(String bookRec1) 
    {

        try{
            ORL_CustomerDomain cusDomObj = new ORL_CustomerDomain(); 
            serviceSettings = retrieveServiceSettings(system.label.ORL_SAP_SalesOrderCreate);
            Logger.logDebug('in service createSalesOrderInSAP, serviceSettings'+serviceSettings);
            for(BookingSource__mdt bsrcobj: [SELECT MasterLabel,Code__c FROM BookingSource__mdt]){
                
                mapOfBookingSource.put(bsrcobj.MasterLabel,bsrcobj.Code__c);
            }
            SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
            try{
                Booking__c bookRec = cusDomObj.retrieveBookingByIds(new List<string> {bookRec1}).get(0);
                Logger.logDebug('in service createSalesOrderInSAP, bookRecord: '+bookRec);
                logLst.add(tstLog);
                tstLog.Logging_Time__c = datetime.Now();
                tstLog.Logging_User__c = UserInfo.getUserId();
                tstLog.Related_Object__c = gtObjectName(bookRec.Id);
                tstLog.Booking__c = bookRec.Id;
                tstLog.Status__c = LOGINPROGRESS;
                tstLog.SAP_Message__c = 'Not sent';
                tstLog.Description__c = 'Create Request for Sales Order: '+bookRec.Name;
                tstLog.Type__c = serviceSettings.DeveloperName; 
                system.debug('1st interface log debug'+tstLog );

                //move ahead only if service is active          
                if(isServiceActive() && bookRec!= NULL)
                {
                    //Initialising Proxy classes

                    //ORL_SAP_SalesOrderCreateInterface.zcreate_customer pushCallObj = new ORL_SAP_SalesOrderCreateInterface.zcreate_customer();
                    ORL_SAP_SalesOrderCreateInterface.zcreate_so pushCallObj = new ORL_SAP_SalesOrderCreateInterface.zcreate_so();
                    pushCallObj.inputHttpHeaders_x = new Map<String,String>();
                    pushCallObj.inputHttpHeaders_x.put('Authorization', getAuthCode());
                    pushCallObj.endpoint_x  = serviceSettings.EndPointURL__c;
                    Logger.logDebug('In createSalesOrderInSAP, inputHttpHeaders_x'+pushCallObj.inputHttpHeaders_x);
                    Logger.logDebug('In createSalesOrderInSAP, endpoint_x'+pushCallObj.endpoint_x);

                    ORL_SAP_SalesOrderCreateInterface.ZSD_FM_SALESORDER_CREATEResponse_element response = new ORL_SAP_SalesOrderCreateInterface.ZSD_FM_SALESORDER_CREATEResponse_element();
                    ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_BILLING_PLAN BILLING_PLAN = new ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_BILLING_PLAN();
                    ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_CONDITION ORDER_CONDITIONS = new ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_CONDITION();
                    ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_HEADER ORDER_HEADER = new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_HEADER();
                    ORL_SAP_SalesOrderCreateInterface.ZVBAK_ADD_FIELDS ORDER_HEADER_ADDITIONAL_FIELDS = new ORL_SAP_SalesOrderCreateInterface.ZVBAK_ADD_FIELDS();
                    ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_ORDER_ITEM ORDER_ITEMS = new ORL_SAP_SalesOrderCreateInterface.TABLE_OF_ZSD_ST_ORDER_ITEM();
                    ORL_SAP_SalesOrderCreateInterface.TABLE_OF_BAPIRET2 RETURN_x = new ORL_SAP_SalesOrderCreateInterface.TABLE_OF_BAPIRET2();

                    string CUSTOMERNUMBER= bookRec.Booking_Number_SAP__c; //'31900477'
                    system.debug('Customer Number from Booking record'+CUSTOMERNUMBER);
                    
                    //Retrieve Records from Domain and assign it to Request structure
                    //Billing Plan line item to be populated : correction to be made
                    List<Billing_Plan_Line_Item__c> listOfPaymentPlanLineItem = [SELECT id,Order__c,Milestone_Usage__c,Item_of_Payment_Plan__c,Payment_Date__c,Date_Description__c,Usage__c,Percentage_Of_Value_To_Be_Invoiced__c,Value_to_be_Billed__c,Milestone_Number__c,Terms_of_Payment_Key__c,Rule_In_Payment_Plan__c from Billing_Plan_Line_Item__c WHERE Payment_Plan__c =:bookRec.Billing_Plan__c];
                    System.debug('listOfPaymentPlanLineItem'+listOfPaymentPlanLineItem);
                    BILLING_PLAN.item= new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_BILLING_PLAN[]{};
                    if(listOfPaymentPlanLineItem != null){
                    for(Billing_Plan_Line_Item__c paymentPlanLineItem: listOfPaymentPlanLineItem){

                        //initialise BILLING_PLAN
                        //percent 1, value 2
                        //FAREG 1, FPROZ percentage
                        //FAReG 2, FAKWR
                        //MLSTN 0, TETXT
                        //MLSTN not 0, MLBEZ
                        ORL_SAP_SalesOrderCreateInterface.ZSD_ST_BILLING_PLAN BILLING_PLAN1 = new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_BILLING_PLAN();
                        BILLING_PLAN1.FPLTR=paymentPlanLineItem.Order__c != null ? string.valueof(paymentPlanLineItem.Order__c):'';//paymentPlanLineItem.Item_of_Payment_Plan__c!=null?paymentPlanLineItem.Item_of_Payment_Plan__c:'';
                        BILLING_PLAN1.FKDAT=formatDate(paymentPlanLineItem.Payment_Date__c);
                        if(paymentPlanLineItem.Milestone_Number__c > '0'){
                            BILLING_PLAN1.MLBEZ=paymentPlanLineItem.Milestone_Usage__c!=null?string.valueof(paymentPlanLineItem.Milestone_Usage__c):'';
                            BILLING_PLAN1.TETXT= '';
                        }
                        else {
                            BILLING_PLAN1.MLBEZ='';
                            BILLING_PLAN1.TETXT=paymentPlanLineItem.Date_Description__c!=null?string.valueof(paymentPlanLineItem.Date_Description__c):'';
                        
                        }
                        BILLING_PLAN1.FPROZ=paymentPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c!=null?string.valueof(paymentPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c):'';
                        BILLING_PLAN1.FAKWR='';
                        /*if(paymentPlanLineItem.Rule_In_Payment_Plan__c == '1'){
                            
                            BILLING_PLAN1.FPROZ=paymentPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c!=null?string.valueof(paymentPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c):'';
                            BILLING_PLAN1.FAKWR='';//paymentPlanLineItem.Value_to_be_Billed__c!=null?string.valueOf(paymentPlanLineItem.Value_to_be_Billed__c):'';
                        
                        }
                        else if(paymentPlanLineItem.Rule_In_Payment_Plan__c == '2'){
                            BILLING_PLAN1.FPROZ='';//paymentPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c!=null?string.valueof(paymentPlanLineItem.Percentage_Of_Value_To_Be_Invoiced__c):'';
                            BILLING_PLAN1.FAKWR=paymentPlanLineItem.Value_to_be_Billed__c!=null?string.valueOf(paymentPlanLineItem.Value_to_be_Billed__c):'';
                        
                        }*/
                        
                        BILLING_PLAN1.FAREG= '1';//paymentPlanLineItem.Rule_In_Payment_Plan__c !=null?string.valueof(paymentPlanLineItem.Rule_In_Payment_Plan__c):'';
                        
                        BILLING_PLAN1.MLSTN=paymentPlanLineItem.Milestone_Number__c!=null?string.valueof(paymentPlanLineItem.Milestone_Number__c):'';
                        BILLING_PLAN1.ZTERM=paymentPlanLineItem.Terms_of_Payment_Key__c!=null?string.valueof(paymentPlanLineItem.Terms_of_Payment_Key__c):'';
                        //BILLING_PLAN1.FPFIX=paymentPlanLineItem.ID_For_Adopting_Billing__c!=null?paymentPlanLineItem.ID_For_Adopting_Billing__c:'';
                        
                        BILLING_PLAN.item.add(BILLING_PLAN1);
                        
                        system.debug('BILLING_PLAN1.FPLTR'+BILLING_PLAN1.FPLTR);
                        system.debug('BILLING_PLAN1.FKDAT'+BILLING_PLAN1.FKDAT);
                        system.debug('BILLING_PLAN1.TETXT'+BILLING_PLAN1.TETXT);
                        system.debug('BILLING_PLAN1.MLBEZ'+BILLING_PLAN1.MLBEZ);
                        system.debug('BILLING_PLAN1.FAREG'+BILLING_PLAN1.FAREG);
                        system.debug('BILLING_PLAN1.FPROZ'+BILLING_PLAN1.FPROZ);
                        system.debug('BILLING_PLAN1.FAKWR'+BILLING_PLAN1.FAKWR);
                        system.debug('BILLING_PLAN1.MLSTN'+BILLING_PLAN1.MLSTN);
                        system.debug('BILLING_PLAN1.ZTERM'+BILLING_PLAN1.ZTERM);
                        

                    }
                    }

                    //initialise ORDER_CONDITIONS
                    ORDER_CONDITIONS.item= new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_CONDITION[]{};
                    
                    if(bookRec.Basic_Cost__c!= null && bookRec.Basic_Cost__c>0){
                    ORL_SAP_SalesOrderCreateInterface.ZSD_ST_CONDITION ORDER_CONDITIONS1 = new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_CONDITION();
                    ORDER_CONDITIONS1.ITM_NUMBER= '000010';//bookRec.Sales_Document_Seq__c != null?bookRec.Sales_Document_Seq__c:'';
                    ORDER_CONDITIONS1.COND_RATE= bookRec.Basic_Cost__c!= null?string.valueOf(bookRec.Basic_Cost__c):'';
                    ORDER_CONDITIONS1.COND_TYPE= 'ZPR0';
                    ORDER_CONDITIONS.item.add(ORDER_CONDITIONS1);
                    system.debug('ORDER_CONDITIONS1.ITM_NUMBER'+ORDER_CONDITIONS1.ITM_NUMBER);
                    system.debug('ORDER_CONDITIONS1.COND_RATE'+ORDER_CONDITIONS1.COND_RATE);
                    system.debug('ORDER_CONDITIONS1.COND_TYPE'+ORDER_CONDITIONS1.COND_TYPE);
                    }
                    
                    if(bookRec.Floor_Rise_Cost__c!= null && bookRec.Floor_Rise_Cost__c>0){
                    ORL_SAP_SalesOrderCreateInterface.ZSD_ST_CONDITION ORDER_CONDITIONS2 = new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_CONDITION();
                    ORDER_CONDITIONS2.ITM_NUMBER= '000010';//bookRec.Sales_Document_Seq__c != null? bookRec.Sales_Document_Seq__c:'';
                    ORDER_CONDITIONS2.COND_TYPE= 'VA0F';
                    ORDER_CONDITIONS2.COND_RATE= bookRec.Floor_Rise_Cost__c != null?string.valueof(bookRec.Floor_Rise_Cost__c):'';                
                    ORDER_CONDITIONS.item.add(ORDER_CONDITIONS2);
                    system.debug('ORDER_CONDITIONS2.ITM_NUMBER'+ORDER_CONDITIONS2.ITM_NUMBER);
                    system.debug('ORDER_CONDITIONS2.COND_RATE'+ORDER_CONDITIONS2.COND_RATE);
                    system.debug('ORDER_CONDITIONS2.COND_TYPE'+ORDER_CONDITIONS2.COND_TYPE);
                    }
                    
                    if(bookRec.PLC_Cost__c!= null && bookRec.PLC_Cost__c>0){
                    ORL_SAP_SalesOrderCreateInterface.ZSD_ST_CONDITION ORDER_CONDITIONS3 = new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_CONDITION();
                    ORDER_CONDITIONS3.ITM_NUMBER= '000010';//bookRec.Sales_Document_Seq__c != null? bookRec.Sales_Document_Seq__c:'';
                    ORDER_CONDITIONS3.COND_RATE= bookRec.PLC_Cost__c != null?string.valueof(bookRec.PLC_Cost__c):'';
                    ORDER_CONDITIONS3.COND_TYPE= 'ZPLC';
                    ORDER_CONDITIONS.item.add(ORDER_CONDITIONS3);
                    
                    system.debug('ORDER_CONDITIONS3.ITM_NUMBER'+ORDER_CONDITIONS3.ITM_NUMBER);
                    system.debug('ORDER_CONDITIONS3.COND_RATE'+ORDER_CONDITIONS3.COND_RATE);
                    system.debug('ORDER_CONDITIONS3.COND_TYPE'+ORDER_CONDITIONS3.COND_TYPE);
                    }
                        
                    //initialise ORDER_HEADER----
                    ORDER_HEADER.SFDCID=bookRec.id;
                    ORDER_HEADER.VKORG=bookRec.CompanyName__c != null ? string.valueOf(bookRec.CompanyName__c):'';
                    system.debug('Company name in create method'+ORDER_HEADER.VKORG);
                    ORDER_HEADER.VTWEG=(mapOfBookingSource != null && !mapOfBookingSource.isEmpty() && mapOfBookingSource.size()>0?  mapOfBookingSource.get(bookRec.Distribution_channel__c):'');
                    ORDER_HEADER.WERKS=bookRec.PlantCode__c != null ? bookRec.PlantCode__c:'';
                    ORDER_HEADER.AUART=bookRec.Tower_Name__c;
                    ORDER_HEADER.BSTKD=bookRec.Customer_Reference_Number__c != null ? bookRec.Customer_Reference_Number__c:'';
                    ORDER_HEADER.BSTDK=formatDate(bookRec.Booking_Date__c);//bdStr;//bookRec.Booking_Date__c!=null?String.valueOf(bookRec.Booking_Date__c):'';
                    ORDER_HEADER.AUGRU=bookRec.Order_Reason__c!=null?bookRec.Order_Reason__c:'';
                    ORDER_HEADER.AUDAT=formatDate(bookRec.Booking_Date__c);//dStr;//bookRec.Booking_Date__c!=null?String.valueOf(bookRec.Booking_Date__c):'';
                    ORDER_HEADER.GWLDT=formatDate(bookRec.Allotment_Date__c);//allotdateStr;//bookRec.Allotment_Date__c!=null?String.valueOf(bookRec.Allotment_Date__c):'';
                    ORDER_HEADER.MAHDT=formatDate(bookRec.Agreement_Date__c);//agrdtStr;//bookRec.Agreement_Date__c!=null?String.valueOf(bookRec.Agreement_Date__c):'';
                    
                    system.debug('OH1'+ORDER_HEADER.SFDCID);
                    system.debug('ORDER_HEADER.VKORG'+ORDER_HEADER.VKORG);
                    system.debug('ORDER_HEADER.VTWEG'+ORDER_HEADER.VTWEG);
                    system.debug('ORDER_HEADER.WERKS'+ORDER_HEADER.WERKS);
                    system.debug('ORDER_HEADER.AUART'+ORDER_HEADER.AUART);
                    system.debug('ORDER_HEADER.BSTKD'+ORDER_HEADER.BSTKD);
                    system.debug('ORDER_HEADER.BSTDK'+ORDER_HEADER.BSTDK);
                    system.debug('ORDER_HEADER.AUGRU'+ORDER_HEADER.AUGRU);
                    system.debug('ORDER_HEADER.AUDAT'+ORDER_HEADER.AUDAT);
                    system.debug('ORDER_HEADER.GWLDT'+ORDER_HEADER.GWLDT);
                    system.debug('ORDER_HEADER.MAHDT'+ORDER_HEADER.MAHDT);
                    
                    system.debug('Aditya Bhasin Check');
                    //initialise ORDER_HEADER_ADDITIONAL_FIELDS
                    ORDER_HEADER_ADDITIONAL_FIELDS.ZZMKTVALUE=bookRec.Market_Value__c!=null?string.valueof(bookRec.Market_Value__c):'';
                    ORDER_HEADER_ADDITIONAL_FIELDS.ZZSTAMP=bookRec.Stampduty_Charges__c!=null?string.valueof(bookRec.Stampduty_Charges__c):'';
                    ORDER_HEADER_ADDITIONAL_FIELDS.ZZREGDATE=formatDate(bookRec.Registration_Date__c);//rdatStr;//bookRec.Registration_Date__c!=null?string.valueof(bookRec.Registration_Date__c):'';
                    ORDER_HEADER_ADDITIONAL_FIELDS.ZZNOCDATE=formatDate(bookRec.NOC_Date__c);//ndatStr;//bookRec.NOC_Date__c!=null?String.valueOf(bookRec.NOC_Date__c):'';
                    
                    system.debug('ORDER_HEADER_ADDITIONAL_FIELDS.ZZMKTVALUE'+ORDER_HEADER_ADDITIONAL_FIELDS.ZZMKTVALUE);
                    system.debug('ORDER_HEADER_ADDITIONAL_FIELDS.ZZSTAMP'+ORDER_HEADER_ADDITIONAL_FIELDS.ZZSTAMP);
                    system.debug('ORDER_HEADER_ADDITIONAL_FIELDS.ZZREGDATE'+ORDER_HEADER_ADDITIONAL_FIELDS.ZZREGDATE);
                    system.debug('ORDER_HEADER_ADDITIONAL_FIELDS.ZZNOCDATE'+ORDER_HEADER_ADDITIONAL_FIELDS.ZZNOCDATE);

                    //initialise ORDER_ITEMS
                    //Property Level Fields Mapped
                    
                    ORDER_ITEMS.item = new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM[]{};
                    ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM ORDER_ITEMS1= new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM();
                    ORDER_ITEMS1.POSNR='000010';//bookRec.Sales_Document_Seq__c!= null? bookRec.Sales_Document_Seq__c:'';
                    ORDER_ITEMS1.MATNR=bookRec.Material_No__c!= null? string.valueof(bookRec.Material_No__c):'';
                    ORDER_ITEMS1.ZMENG= bookRec.Carpet_Area__c!=null?string.valueof(bookRec.Carpet_Area__c):'';//'100.000'
                    ORDER_ITEMS1.ZIEME=bookRec.Carpet_Area_UOM__c!=null?bookRec.Carpet_Area_UOM__c:'';
                    
                    //Started Car parking mapping
                    system.debug('singlesingle'+bookRec.Single_Car_Parking__c);
                    system.debug('tandomtandomtandom'+bookRec.Tandem_Car_Parking__c);
                    system.debug('tripletripletripletripletriple'+bookRec.Triple_Car_Parking__c);
                    if (bookRec.Single_Car_Parking__c>0 && bookRec.Tandem_Car_Parking__c>0 && bookRec.Triple_Car_Parking__c>0){
                    single = '000020'; tandom ='000030'; triple ='000040';}
                    else if(bookRec.Single_Car_Parking__c<=0 && bookRec.Tandem_Car_Parking__c>0 && bookRec.Triple_Car_Parking__c>0){
                    tandom='000020'; triple='000030';}
                    else if(bookRec.Single_Car_Parking__c<=0 && bookRec.Tandem_Car_Parking__c<=0 && bookRec.Triple_Car_Parking__c>0){
                    triple='000020';}
                    else if(bookRec.Single_Car_Parking__c>0 && bookRec.Tandem_Car_Parking__c<=0 && bookRec.Triple_Car_Parking__c>0){
                    single='000020'; triple='000030';}
                    else if(bookRec.Single_Car_Parking__c>0 && bookRec.Tandem_Car_Parking__c<=0 && bookRec.Triple_Car_Parking__c<=0){
                    single='000020';}
                    else if(bookRec.Single_Car_Parking__c>0 && bookRec.Tandem_Car_Parking__c>0 && bookRec.Triple_Car_Parking__c<=0){
                    single='000020'; tandom='000030';}
                    else if(bookRec.Single_Car_Parking__c<=0 && bookRec.Tandem_Car_Parking__c>0 && bookRec.Triple_Car_Parking__c<=0){
                    tandom='000020';}
                    else if(bookRec.Single_Car_Parking__c<=0 && bookRec.Tandem_Car_Parking__c<=0 && bookRec.Triple_Car_Parking__c<=0){
                    single='0'; tandom='0'; triple='0';}
                    
                    system.debug('singlesingle'+single);
                    system.debug('tandomtandomtandom'+tandom);
                    system.debug('tripletripletripletripletriple'+triple);
                    if(bookRec.Single_Car_Parking__c != null && bookRec.Single_Car_Parking__c > 0){
                    ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM ORDER_ITEMS3= new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM();
                    
                    ORDER_ITEMS3.POSNR=single;//bookRec.Sales_Document_Seq_Single_Parking__c!= null? bookRec.Sales_Document_Seq_Single_Parking__c:'';
                    ORDER_ITEMS3.MATNR=bookRec.Material_No_Single_Parking__c!= null? string.valueof(bookRec.Material_No_Single_Parking__c):'';
                    ORDER_ITEMS3.ZMENG= bookRec.Single_Car_Parking__c!= null? string.valueof(bookRec.Single_Car_Parking__c):'';//bookRec.Carpet_Area__c!=null?string.valueof(bookRec.Carpet_Area__c):'';//'100.000'
                    ORDER_ITEMS3.ZIEME='EA';//bookRec.Carpet_Area_UOM__c!=null?bookRec.Carpet_Area_UOM__c:'';
                    
                    ORDER_ITEMS.item.add(ORDER_ITEMS3);
                    system.debug('ORDER_ITEMS1.POSNR'+ORDER_ITEMS3.POSNR);
                    system.debug('ORDER_ITEMS1.MATNR'+ORDER_ITEMS3.MATNR);
                    system.debug('ORDER_ITEMS1.ZMENG'+ORDER_ITEMS3.ZMENG);
                    system.debug('ORDER_ITEMS1.ZIEME'+ORDER_ITEMS3.ZIEME);
                    }
                    
                    if(bookRec.Tandem_Car_Parking__c != null && bookRec.Tandem_Car_Parking__c > 0){
                    ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM ORDER_ITEMS4= new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM();
                    
                    ORDER_ITEMS4.POSNR=tandom;//bookRec.Sales_Document_Seq_Tandom_Parking__c!= null? bookRec.Sales_Document_Seq_Tandom_Parking__c:'';
                    ORDER_ITEMS4.MATNR=bookRec.Material_No_Tandem_Parking__c!= null? string.valueof(bookRec.Material_No_Tandem_Parking__c):'';
                    ORDER_ITEMS4.ZMENG= bookRec.Tandem_Car_Parking__c!= null? string.valueof(bookRec.Tandem_Car_Parking__c):'';
                    ORDER_ITEMS4.ZIEME='EA';//bookRec.Carpet_Area_UOM__c!=null?bookRec.Carpet_Area_UOM__c:'';
                    
                    ORDER_ITEMS.item.add(ORDER_ITEMS4);
                    
                    system.debug('ORDER_ITEMS1.POSNR'+ORDER_ITEMS4.POSNR);
                    system.debug('ORDER_ITEMS1.MATNR'+ORDER_ITEMS4.MATNR);
                    system.debug('ORDER_ITEMS1.ZMENG'+ORDER_ITEMS4.ZMENG);
                    system.debug('ORDER_ITEMS1.ZIEME'+ORDER_ITEMS4.ZIEME);
                    }
                    
                    if(bookRec.Triple_Car_Parking__c != null && bookRec.Triple_Car_Parking__c > 0){
                    ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM ORDER_ITEMS5= new ORL_SAP_SalesOrderCreateInterface.ZSD_ST_ORDER_ITEM();
                    
                    ORDER_ITEMS5.POSNR=triple;//bookRec.Sales_Document_Seq_Triple_Parking__c!= null? bookRec.Sales_Document_Seq_Triple_Parking__c:'';
                    ORDER_ITEMS5.MATNR=bookRec.Material_No_Triple_Parking__c!= null? string.valueof(bookRec.Material_No_Triple_Parking__c):'';
                    ORDER_ITEMS5.ZMENG= bookRec.Triple_Car_Parking__c!= null? string.valueof(bookRec.Triple_Car_Parking__c):'';
                    ORDER_ITEMS5.ZIEME='EA';//bookRec.Carpet_Area_UOM__c!=null?bookRec.Carpet_Area_UOM__c:'';
                    
                    ORDER_ITEMS.item.add(ORDER_ITEMS5);
                    
                    system.debug('ORDER_ITEMS1.POSNR'+ORDER_ITEMS5.POSNR);
                    system.debug('ORDER_ITEMS1.MATNR'+ORDER_ITEMS5.MATNR);
                    system.debug('ORDER_ITEMS1.ZMENG'+ORDER_ITEMS5.ZMENG);
                    system.debug('ORDER_ITEMS1.ZIEME'+ORDER_ITEMS5.ZIEME);
                    }
                    //Finished Car parking mapping
                    
                    ORDER_ITEMS.item.add(ORDER_ITEMS1);
                    //ORDER_ITEMS.item.add(ORDER_ITEMS2);
                    //if(ORDER_ITEMS3 != null)
                    
                    system.debug('ORDER_ITEMS1.POSNR'+ORDER_ITEMS1.POSNR);
                    system.debug('ORDER_ITEMS1.MATNR'+ORDER_ITEMS1.MATNR);
                    system.debug('ORDER_ITEMS1.ZMENG'+ORDER_ITEMS1.ZMENG);
                    system.debug('ORDER_ITEMS1.ZIEME'+ORDER_ITEMS1.ZIEME);
                    
                    //bookRec.Move_to_SAP__c = false;
                    //cusDomObj.amendBooking(new list<Booking__c> {bookRec});
                    
                    
                    
                    response = pushCallObj.ZSD_FM_SALESORDER_CREATE(BILLING_PLAN,CUSTOMERNUMBER,ORDER_CONDITIONS,ORDER_HEADER,ORDER_HEADER_ADDITIONAL_FIELDS,ORDER_ITEMS,RETURN_x);
                    system.debug('@@@@@@@@'+response.toString());
                    Logger.logDebug('in service createSalesOrderInSAP, response: '+response);
                    Logger.logDebug('in service createSalesOrderInSAP, response.RETURN_x: '+response.RETURN_x);

                    system.debug('%%%%%%%'+response.RETURN_x.item);
                    ///Add logic of Response handling here
                    if(response.RETURN_x.item != NULL && !response.RETURN_x.item.isEmpty() && response != null && response.SALESDOCUMENT!= null ){
                        system.debug('Inside Responese Check'+response.SALESDOCUMENT);
                        bookRec.Sales_Document_SAP__c = response.SALESDOCUMENT;
                        bookRec.Move_to_SAP__c = false;
                        //system.debug('Inside Responese Check'+response.SALESDOCUMENT);
                        //system.debug('Inside Responese Check'+response.SALESDOCUMENT);
                        if(response.SALESDOCUMENT != null && !String.isBlank(bookRec.Sales_Document_SAP__c)){
                        bookRec.SAP_Sales_Order__c = true;
                        bookRec.Status__c = 'Booked';
                        bookRec.SAP_Status__c = bookRec.SAP_Status__c + ', Sales Order created in SAP successfully.';
                        }else{
                        bookRec.SAP_Status__c = bookRec.SAP_Status__c + ', Sales Order creation in SAP failed.';
                        }
                        system.debug('Inside Responese Check'+bookRec.SAP_Sales_Order__c);
                        cusDomObj.amendBooking(new list<Booking__c> {bookRec});
                        
                        Schema.DescribeFieldResult statField = SAP_Interface_Log__c.Status__c.getDescribe();    
                        integer statLen = statField.getLength();
                        Schema.DescribeFieldResult msgField = SAP_Interface_Log__c.SAP_Message__c.getDescribe();    
                        integer msgLen = msgField.getLength();

                        tstLog.Status__c = '';
                        tstLog.SAP_Message__c = '';

                        system.debug('2st interface log debug'+tstLog );

                        for(ORL_SAP_SalesOrderCreateInterface.BAPIRET2 retObj: response.RETURN_x.item){
                        string tempStat = tstLog.Status__c+' '+retObj.TYPE_x;
                        string tempMsg = tstLog.SAP_Message__c+' '+retObj.MESSAGE;
                        tstLog.Status__c = tempStat.length() <= statLen ? tempStat : tstLog.Status__c;
                        tstLog.SAP_Message__c = tempMsg.length() <= msgLen ? tempMsg : tstLog.SAP_Message__c;
                        }
                        system.debug('3rd interface log debug'+tstLog );
                    }
                    else{
                        tstLog.Status__c = 'No Response';
                        tstLog.SAP_Message__c = 'No Response Recieved from SAP';
                    }
                }

                else{
                    tstLog.Status__c = 'Failed';
                    tstLog.SAP_Message__c = 'Service Deactivated in Salesforce Or Booking does not exist';
                }     
            }
            catch(Exception ex){
                Logger.logException('Error in ORL_SAP_SalesOrderIntegrationService.createSalesOrderInSAP:'+ex.getMessage());
                tstLog.Status__c = 'Exception';
                tstLog.SAP_Message__c = ex.getMessage();
            }   

            createInterfaceLogs();
            Logger.logDebug('in service createSalesOrderInSAP, Logs created and service finished ');
        }
        catch(Exception ex){
            Logger.logException('Error in ORL_SAP_SalesOrderIntegrationService.createSalesOrderInSAP:'+ex.getMessage());
        }   
    }

public void updateSalesOrderInSAP(string bookRec1) {
  try{
    ORL_CustomerDomain cusDomObj = new ORL_CustomerDomain(); 
    serviceSettings = retrieveServiceSettings(system.label.ORL_SAP_SalesOrderUpdate);
    Logger.logDebug('in service updateResidentialCustomerInSAP, serviceSettings'+serviceSettings);
    SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
    try{
        Booking__c bookRec = cusDomObj.retrieveBookingByIds(new List<string> {bookRec1}).get(0);
        Logger.logDebug('in service updateResidentialCustomerInSAP, bookRecord: '+bookRec);
        
        logLst.add(tstLog);
        tstLog.Logging_Time__c = datetime.Now();
        tstLog.Logging_User__c = UserInfo.getUserId();
        tstLog.Related_Object__c = gtObjectName(bookRec.Id);
        tstLog.Booking__c = bookRec.Id;
        tstLog.Status__c = LOGINPROGRESS;
        tstLog.SAP_Message__c = 'Not sent';
        tstLog.Description__c = 'SalesOrder Update Request for Booking: '+bookRec.Name;
        tstLog.Type__c = serviceSettings.DeveloperName;
        
         //move ahead only if service is active          
         if(isServiceActive() && bookRec != NULL){
           
            //Initialising SAP EndPoints
            ORL_SAP_SalesOrderUpdateInterface.zchange_so pushUpdateObj = new ORL_SAP_SalesOrderUpdateInterface.zchange_so();
            pushUpdateObj.inputHttpHeaders_x = new Map<String,String>();
            pushUpdateObj.inputHttpHeaders_x.put('Authorization', getAuthCode());
            pushUpdateObj.endpoint_x  = serviceSettings.EndPointURL__c;
            Logger.logDebug('In updateSalesOrderInSAP, inputHttpHeaders_x'+pushUpdateObj.inputHttpHeaders_x);
            Logger.logDebug('In updateSalesOrderInSAP, endpoint_x'+pushUpdateObj.endpoint_x);
            
            //Initialising Proxy classes
            //ORL_SAP_SalesOrderUpdateInterface.ZSD_FM_SALESORDER_CHANGEResponse_element response= new ORL_SAP_SalesOrderUpdateInterface.ZSD_FM_SALESORDER_CHANGEResponse_element();
         
            ORL_SAP_SalesOrderUpdateInterface.TABLE_OF_BAPIRET2 response = new ORL_SAP_SalesOrderUpdateInterface.TABLE_OF_BAPIRET2();
            
            ORL_SAP_SalesOrderUpdateInterface.ZSO_HEADER ORDER_HEADER= new ORL_SAP_SalesOrderUpdateInterface.ZSO_HEADER();
            ORL_SAP_SalesOrderUpdateInterface.ZVBAK_ADD_FIELDS ORDER_HEADER_ADDITIONAL_FIELDS = new ORL_SAP_SalesOrderUpdateInterface.ZVBAK_ADD_FIELDS();
            ORL_SAP_SalesOrderUpdateInterface.TABLE_OF_BAPIRET2 RETURN_x = new ORL_SAP_SalesOrderUpdateInterface.TABLE_OF_BAPIRET2();
            String SALESDOCUMENT= bookRec.Sales_Document_SAP__c;
            
            
            //initializing ORDER_HEADER
            ORDER_HEADER.BSTDK= formatDate(bookRec.Booking_Date__c);
            ORDER_HEADER.AUGRU= bookRec.Order_Reason__c!=null?bookRec.Order_Reason__c:'';
            ORDER_HEADER.AUDAT=  formatDate(bookRec.Booking_Date__c);
            ORDER_HEADER.GWLDT=formatDate(bookRec.Allotment_Date__c);
            ORDER_HEADER.MAHDT= formatDate(bookRec.Agreement_Date__c);
            
            system.debug('ORDER_HEADER.BSTDK'+ORDER_HEADER.BSTDK);
            system.debug('ORDER_HEADER.AUGRU'+ORDER_HEADER.AUGRU);
            system.debug('ORDER_HEADER.AUDAT'+ORDER_HEADER.AUDAT);
            system.debug('ORDER_HEADER.GWLDT'+ORDER_HEADER.GWLDT);
            system.debug('ORDER_HEADER.MAHDT'+ORDER_HEADER.MAHDT);
            
            
            //initializing ORDER_HEADER_ADDITIONAL_FIELDS
            ORDER_HEADER_ADDITIONAL_FIELDS.ZZMKTVALUE= bookRec.Market_Value__c!=null?string.valueof(bookRec.Market_Value__c):''; //'123';
            ORDER_HEADER_ADDITIONAL_FIELDS.ZZSTAMP= bookRec.Stampduty_Charges__c!=null?string.valueof(bookRec.Stampduty_Charges__c):''; //'234';
            ORDER_HEADER_ADDITIONAL_FIELDS.ZZREGDATE=formatDate(bookRec.Registration_Date__c);//rdatStr; //'12.03.2019'
            ORDER_HEADER_ADDITIONAL_FIELDS.ZZNOCDATE=formatDate(bookRec.NOC_Date__c); //ndatStr; //'12.03.2019'
            
            system.debug('ORDER_HEADER_ADDITIONAL_FIELDS.ZZMKTVALUE'+ORDER_HEADER_ADDITIONAL_FIELDS.ZZMKTVALUE);
            system.debug('ORDER_HEADER_ADDITIONAL_FIELDS.ZZSTAMP'+ORDER_HEADER_ADDITIONAL_FIELDS.ZZSTAMP);
            system.debug('ORDER_HEADER_ADDITIONAL_FIELDS.ZZREGDATE'+ORDER_HEADER_ADDITIONAL_FIELDS.ZZREGDATE);
            system.debug('ORDER_HEADER_ADDITIONAL_FIELDS.ZZNOCDATE'+ORDER_HEADER_ADDITIONAL_FIELDS.ZZNOCDATE);
            
            
            response=pushUpdateObj.ZSD_FM_SALESORDER_CHANGE(ORDER_HEADER,ORDER_HEADER_ADDITIONAL_FIELDS,RETURN_x,SALESDOCUMENT);
            system.debug('RETURN_x @@@@@@@@'+pushUpdateObj.ZSD_FM_SALESORDER_CHANGE(ORDER_HEADER,ORDER_HEADER_ADDITIONAL_FIELDS,RETURN_x,SALESDOCUMENT));
            system.debug('Response from SalesOrder Update Call'+response);
            
            if(response.item != NULL && !response.item.isEmpty() && response != null){
                        system.debug('Inside Responese Check');
                        cusDomObj.amendBooking(new list<Booking__c> {bookRec});
                        Schema.DescribeFieldResult statField = SAP_Interface_Log__c.Status__c.getDescribe();    
                        integer statLen = statField.getLength();
                        Schema.DescribeFieldResult msgField = SAP_Interface_Log__c.SAP_Message__c.getDescribe();    
                        integer msgLen = msgField.getLength();

                        tstLog.Status__c = '';
                        tstLog.SAP_Message__c = '';

                        system.debug('2st interface log debug'+tstLog );

                        for(ORL_SAP_SalesOrderUpdateInterface.BAPIRET2 retObj: response.item){
                        string tempStat = tstLog.Status__c+' '+retObj.TYPE_x;
                        string tempMsg = tstLog.SAP_Message__c+' '+retObj.MESSAGE;
                        tstLog.Status__c = tempStat.length() <= statLen ? tempStat : tstLog.Status__c;
                        tstLog.SAP_Message__c = tempMsg.length() <= msgLen ? tempMsg : tstLog.SAP_Message__c;
                        }
                        system.debug('3rd interface log debug'+tstLog );
                    }
                    else{
                        tstLog.Status__c = 'No Response';
                        tstLog.SAP_Message__c = 'No Response Recieved from SAP';
                    } 

         }

                else{
                    tstLog.Status__c = 'Failed';
                    tstLog.SAP_Message__c = 'Service Deactivated in Salesforce Or Booking does not exist';
                }     
            }
            catch(Exception ex){
                Logger.logException('Error in ORL_SAP_SalesOrderIntegrationService.updateSalesOrderInSAP:'+ex.getMessage());
                tstLog.Status__c = 'Exception';
                tstLog.SAP_Message__c = ex.getMessage();
            }   

            createInterfaceLogs();
            Logger.logDebug('in service updateSalesOrderInSAP, Logs created and service finished ');
        }
        catch(Exception ex){
            Logger.logException('Error in ORL_SAP_SalesOrderIntegrationService.updateSalesOrderInSAP:'+ex.getMessage());
        }   
    }
}
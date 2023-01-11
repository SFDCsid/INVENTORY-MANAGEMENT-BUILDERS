/*
*  Author: Vivek S, Aditya Bhasin,Nistha Anand
*  Description: Integration service class for Customer Objects
*  Change Log: Customer Creation Residential Logic by Aditya Bhasin on 19.03.2019 
*  Change Log: Customer Updation Residential Logic by Aditya Bhasin on 28.03.2019 
*/
public class ORL_SAP_CustomerIntegrationService extends ORL_SAP_BaseIntegrationService {
    
public static final string LOGINPROGRESS = 'In Progress';
Map<String,String> mapOfSalutationCustomMetaData = new Map<String,String>();
Map<string,string> mapOfCountriesMetaData = new Map<String,String>();
Map<string,string> mapOfBookingSource = new Map<String,String>();
Map<string,Region__mdt> mapOfRegionMetaData= new Map<string,Region__mdt>();

//List<Salutation__mdt> listOfSalutationMetaData = [SELECT MasterLabel,Code__c FROM Salutation__mdt];

public void createResidentialCustomerInSAP(string bookId) {
  try{
    ORL_CustomerDomain cusDomObj = new ORL_CustomerDomain(); 
    serviceSettings = retrieveServiceSettings(system.label.ORL_SAP_CustomerCreate);
    Logger.logDebug('in service createResidentialCustomerInSAP, serviceSettings'+serviceSettings);
    SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
    try{
        Booking__c bookRec = cusDomObj.retrieveBookingByIds(new List<string> {bookId}).get(0);
        Logger.logDebug('in service createResidentialCustomerInSAP, bookRecord: '+bookRec);
        
        logLst.add(tstLog);
        tstLog.Logging_Time__c = datetime.Now();
        tstLog.Logging_User__c = UserInfo.getUserId();
        tstLog.Related_Object__c = gtObjectName(bookRec.Id);
        tstLog.Booking__c = bookRec.Id;
        tstLog.Status__c = LOGINPROGRESS;
        tstLog.SAP_Message__c = 'Not sent';
        tstLog.Description__c = 'Create Request for Booking: '+bookRec.Name;
        tstLog.Type__c = serviceSettings.DeveloperName;
        
         //move ahead only if service is active          
         if(isServiceActive() && bookRec != NULL){
           //Initialising Proxy classes
           ORL_SAP_CustomerCreateInterface.zcreate_customer pushCallObj = new ORL_SAP_CustomerCreateInterface.zcreate_customer();
           pushCallObj.inputHttpHeaders_x = new Map<String,String>();
           pushCallObj.inputHttpHeaders_x.put('Authorization', getAuthCode());
           pushCallObj.endpoint_x  = serviceSettings.EndPointURL__c;
           Logger.logDebug('In createResidentialCustomerInSAP, inputHttpHeaders_x'+pushCallObj.inputHttpHeaders_x);
           Logger.logDebug('In createResidentialCustomerInSAP, endpoint_x'+pushCallObj.endpoint_x);
           
           ORL_SAP_CustomerCreateInterface.ZSD_FM_CUSTOMER_CREATEResponse_element response = new ORL_SAP_CustomerCreateInterface.ZSD_FM_CUSTOMER_CREATEResponse_element();
           
           ORL_SAP_CustomerCreateInterface.TABLE_OF_ZSDST_CUSTOMER_ADDRESS CUSTOMER_ADDRESS = new ORL_SAP_CustomerCreateInterface.TABLE_OF_ZSDST_CUSTOMER_ADDRESS();
           
           ORL_SAP_CustomerCreateInterface.TABLE_OF_ZSDST_CUSTOMER_COMMUNICATION CUSTOMER_COMMUNICATION = new ORL_SAP_CustomerCreateInterface.TABLE_OF_ZSDST_CUSTOMER_COMMUNICATION();
           
           ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_HEADER CUSTOMER_HEADER = new ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_HEADER();
           
           ORL_SAP_CustomerCreateInterface.TABLE_OF_BAPIRET1 RETURN_x = new ORL_SAP_CustomerCreateInterface.TABLE_OF_BAPIRET1();
           
           //Retrieve Records from Domain and assign it to Request structure
           //Retrieve related Applicant records
          // list<Applicant__c> applRecs = cusDomObj.retrieveApplicantsByBookingId(bookRec.Id);
           List<Co_Owner__c> listOfCoOwner = [SELECT id,Contact_name__c,Name,PAN__c FROM Co_Owner__c WHERE Booking__c =: bookRec.id];
           for(Salutation__mdt obj1:[SELECT MasterLabel,Code__c FROM Salutation__mdt]){
                             mapOfSalutationCustomMetaData.put(obj1.MasterLabel,obj1.Code__c);
                                      }
            for(Country__mdt countryObj: [SELECT MasterLabel,Code__c FROM Country__mdt] ){
                
                mapOfCountriesMetaData.put(countryObj.MasterLabel,countryObj.Code__c);
            }   

            for(Region__mdt regionobj: [SELECT MasterLabel,Code__c,Country_Code__c FROM Region__mdt]){
                
                mapOfRegionMetaData.put(regionobj.MasterLabel,regionobj);
            }
            for(BookingSource__mdt bsrcobj: [SELECT MasterLabel,Code__c FROM BookingSource__mdt]){
                
                mapOfBookingSource.put(bsrcobj.MasterLabel,bsrcobj.Code__c);
            }
            //system.debug('Data from Custom Metadata'+mapOfCountriesMetaData);   
            //system.debug('mapOfRegionMetaDatamapOfRegionMetaData'+mapOfRegionMetaData.keyset());
            //system.debug('mapOfRegionMetaDatamapOfRegionMetaData'+mapOfRegionMetaData.values());            
            //system.debug('Data from Custom Metadata'+mapOfSalutationCustomMetaData);
            Logger.logDebug('in service createResidentialCustomerInSAP, co owner records: '+listOfCoOwner);
           
           //initialise CUSTOMER_HEADER
           
            CUSTOMER_HEADER.SFDCID=  string.valueOf(bookRec.id);
            CUSTOMER_HEADER.CUSTOMER_TYPE= 'R';
            CUSTOMER_HEADER.BUKRS= '';
            CUSTOMER_HEADER.VKORG= bookRec.CompanyName__c != null ? string.valueOf(bookRec.CompanyName__c) : '';
            CUSTOMER_HEADER.WERKS= bookRec.PlantCode__c != null ? string.valueOf(bookRec.PlantCode__c) : '';
            CUSTOMER_HEADER.VTWEG=(mapOfBookingSource != null && !mapOfBookingSource.isEmpty() && mapOfBookingSource.size()>0?  mapOfBookingSource.get(bookRec.Distribution_channel__c):'');
            //CUSTOMER_HEADER.VTWEG= bookRec.Opportunity__r.Enquiry_Type__c != null ? string.valueOf(bookRec.Opportunity__r.Enquiry_Type__c) : '';
            CUSTOMER_HEADER.TITLE_MEDI= (bookRec.Title__c !=null && mapOfSalutationCustomMetaData.size()>0 && !mapOfSalutationCustomMetaData.isEmpty())?mapOfSalutationCustomMetaData.get(bookRec.Title__c) :'';  //bookRec.Title__c != null ? string.valueOf(bookRec.Title__c) : '';
            //system.debug('Header Value+++'+CUSTOMER_HEADER.TITLE_MEDI);
            CUSTOMER_HEADER.NAME1= bookRec.Contact_Name__c != null ? string.valueOf(bookRec.Contact_Name__c) : '';
            CUSTOMER_HEADER.NAME2= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >0 ? listOfCoOwner.get(0).Contact_name__c : '');
            CUSTOMER_HEADER.NAME3= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >1 ? listOfCoOwner.get(1).Contact_name__c : '');
            CUSTOMER_HEADER.NAME4= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >2 ? listOfCoOwner.get(2).Contact_name__c : '');
            CUSTOMER_HEADER.NAME5= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >3 ? listOfCoOwner.get(3).Contact_name__c : '');
            CUSTOMER_HEADER.NAME6= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >4 ? listOfCoOwner.get(4).Contact_name__c : '');
            CUSTOMER_HEADER.NAME7= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >5 ? listOfCoOwner.get(5).Contact_name__c : '');
            CUSTOMER_HEADER.SORT1= bookRec.Unitcode__c != null ? string.valueOf(bookRec.Unitcode__c) : '';
            CUSTOMER_HEADER.SORT2= bookRec.Search_Term__c != null ? string.valueOf(bookRec.Search_Term__c) : '';
            CUSTOMER_HEADER.STCD1= bookRec.PAN_Number__c != null ? string.valueOf(bookRec.PAN_Number__c) : '';
            CUSTOMER_HEADER.STCD2= (listOfCoOwner!= NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >0 ? listOfCoOwner.get(0).PAN__c : '');
            system.debug('PAN Number on related Co Owner Object'+CUSTOMER_HEADER.STCD2);
            CUSTOMER_HEADER.STCD3= bookRec.GSTN__c != null ? string.valueOf(bookRec.GSTN__c) : '';
            CUSTOMER_HEADER.PAN_NUMBER= bookRec.PAN_Number__c != null ? string.valueOf(bookRec.PAN_Number__c) : '';
            system.debug('first co owner name'+CUSTOMER_HEADER.NAME2);
            system.debug('second co owner name'+CUSTOMER_HEADER.NAME3);
          
          
           //initialise CUSTOMER_ADDRESS
            ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_ADDRESS CUSTOMER_ADDRESS1 = new ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_ADDRESS();
            CUSTOMER_ADDRESS1.NAME_CO= bookRec.C_o_Name_Billing_Address__c != null ? string.valueOf(bookRec.C_o_Name_Billing_Address__c) : '';
            CUSTOMER_ADDRESS1.CITY1= bookRec.Billing_City__c != null ? string.valueOf(bookRec.Billing_City__c) : '';
            CUSTOMER_ADDRESS1.POST_CODE1= bookRec.Billing_Post_Code__c != null ? string.valueOf(bookRec.Billing_Post_Code__c) : '';
            //system.debug('Booking object postal code'+CUSTOMER_ADDRESS1.POST_CODE1);
            CUSTOMER_ADDRESS1.STREET= bookRec.Billing_Street__c != null ? string.valueOf(bookRec.Billing_Street__c) : '';
            CUSTOMER_ADDRESS1.STR_SUPPL1= bookRec.Billing_Str_Suppl1__c != null ? string.valueOf(bookRec.Billing_Str_Suppl1__c) : '';
            CUSTOMER_ADDRESS1.STR_SUPPL2= bookRec.Billing_Str_Suppl2__c != null ? string.valueOf(bookRec.Billing_Str_Suppl2__c) : '';
            CUSTOMER_ADDRESS1.STR_SUPPL3= bookRec.Billing_Str_Suppl3__c != null ? string.valueOf(bookRec.Billing_Str_Suppl3__c) : '';
            CUSTOMER_ADDRESS1.LOCATION= bookRec.Billing_Location__c != null ? string.valueOf(bookRec.Billing_Location__c) : '';
            //System.debug('Aditya Bhasin Check'+bookRec.Billing_Country__c);
            //System.debug('AdityaBhasinCOuntry'+mapOfCountriesMetaData.get(bookRec.Billing_Country__c));
            CUSTOMER_ADDRESS1.COUNTRY= (mapOfCountriesMetaData != null && !mapOfCountriesMetaData.isEmpty() && mapOfCountriesMetaData.size()>0?  mapOfCountriesMetaData.get(bookRec.Billing_Country__c):'');//bookRec.Billing_Country__c != null ? string.valueOf(bookRec.Billing_Country__c) : '';
            //system.debug('Booking Billing Country'+CUSTOMER_ADDRESS1.COUNTRY);
            //system.debug('Booking Billing Country'+mapOfRegionMetaData.get(bookRec.Billing_Region__c).Country_Code__c);
            //system.debug('Booking Billing Country'+mapOfCountriesMetaData.get(bookRec.Billing_Country__c));
            //system.debug('Booking Billing Country'+mapOfRegionMetaData.get(bookRec.Billing_Region__c).Code__c);
            if(mapOfRegionMetaData != null && mapOfRegionMetaData.size()>0 && mapOfCountriesMetaData != null 
            && mapOfCountriesMetaData.size()>0){
                if(mapOfRegionMetaData.get(bookRec.Billing_Region__c).Country_Code__c == mapOfCountriesMetaData.get(bookRec.Billing_Country__c)){
                CUSTOMER_ADDRESS1.REGION=mapOfRegionMetaData.get(bookRec.Billing_Region__c).Code__c;
                //mapOfRegionMetaData.get(bookRec.Billing_Region__c);
                //mapOfCountriesMetaData.get(bookRec.Billing_Country__c);
                }
            }
            //CUSTOMER_ADDRESS1.REGION= '13';//(mapOfRegionMetaData != null && !mapOfRegionMetaData.isEmpty() && mapOfRegionMetaData.size()>0?mapOfRegionMetaData.get(bookRec.Billing_Region__c):''); // bookRec.Billing_Region__c != null ? string.valueOf(bookRec.Billing_Region__c) : '';
            //System.debug('Billing Region in first method'+CUSTOMER_ADDRESS1.REGION);
      
            ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_ADDRESS CUSTOMER_ADDRESS2 = new ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_ADDRESS();
            CUSTOMER_ADDRESS2.NAME_CO= bookRec.C_o_Name_Mailing_Address__c != null ? string.valueOf(bookRec.C_o_Name_Mailing_Address__c) : '' ;
            CUSTOMER_ADDRESS2.CITY1= bookRec.Mailing_City__c != null ? string.valueOf(bookRec.Mailing_City__c) : '';
            CUSTOMER_ADDRESS2.POST_CODE1= bookRec.Mailing_Post_Code__c != null ? string.valueOf(bookRec.Mailing_City__c) : '';
            CUSTOMER_ADDRESS2.STREET= bookRec.Mailing_Street__c != null ? string.valueOf(bookRec.Mailing_Street__c) : '';
            CUSTOMER_ADDRESS2.STR_SUPPL1= bookRec.Mailing_Str_Suppl1__c != null ? string.valueOf(bookRec.Mailing_Str_Suppl1__c) : '';
            CUSTOMER_ADDRESS2.STR_SUPPL2= bookRec.Mailing_Str_Suppl2__c != null ? string.valueOf(bookRec.Mailing_Str_Suppl2__c) : '';
            CUSTOMER_ADDRESS2.STR_SUPPL3= bookRec.Mailing_Str_Suppl3__c != null ? string.valueOf(bookRec.Mailing_Str_Suppl3__c) : '';
            CUSTOMER_ADDRESS2.LOCATION= bookRec.Mailing_Location__c;
            CUSTOMER_ADDRESS2.COUNTRY= '';//(mapOfCountriesMetaData != null && !mapOfCountriesMetaData.isEmpty() && mapOfCountriesMetaData.size()>0?  mapOfCountriesMetaData.get(bookRec.Mailing_Country__c):'');//bookRec.Mailing_Country__c;
            
            CUSTOMER_ADDRESS2.REGION= ' ';//(mapOfRegionMetaData != null && !mapOfRegionMetaData.isEmpty() && mapOfRegionMetaData.size()>0?mapOfRegionMetaData.get(bookRec.Mailing_Region__c):''); //bookRec.Mailing_Region__c;
            //System.debug('Mailing region in first method'+CUSTOMER_ADDRESS2.REGION);
            
            CUSTOMER_ADDRESS.item = new ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_ADDRESS[]{};
            //System.debug('Aditya Bhasin Check'+CUSTOMER_ADDRESS1);
            CUSTOMER_ADDRESS.item.add(CUSTOMER_ADDRESS1);
            //CUSTOMER_ADDRESS.item.add(CUSTOMER_ADDRESS2);
    
           //initialise CUSTOMER_COMMUNICATION
            ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_COMMUNICATION CUSTOMER_COMMUNICATION1 = new ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_COMMUNICATION();
            CUSTOMER_COMMUNICATION1.INDICATOR= 'I';
            //System.debug('Aditya Bhasin Check'+bookRec.Telephone__c);
            CUSTOMER_COMMUNICATION1.TEL_NUMBER= bookRec.Telephone__c != null ? string.valueOf(bookRec.Telephone__c) : '';
            //System.debug('Aditya Bhasin Check');
            CUSTOMER_COMMUNICATION1.PRI_TEL_NUMBER= 'x';
            CUSTOMER_COMMUNICATION1.SMTP_ADDR= bookRec.Email__c != null ? string.valueOf(bookRec.Email__c) : '';
            //System.debug('Aditya Bhasin Check');
            CUSTOMER_COMMUNICATION1.PRI_SMTP_ADDR= 'x';
            CUSTOMER_COMMUNICATION1.MOB_NUMBER= bookRec.Mobile__c != null ? string.valueOf(bookRec.Mobile__c) : '';
            //System.debug('Aditya Bhasin Check');
            CUSTOMER_COMMUNICATION1.PRI_MOB_NUMBER= 'x';
            CUSTOMER_COMMUNICATION1.FAX_NUMBER= bookRec.Fax_Number__c != null ? string.valueOf(bookRec.Fax_Number__c) : '';
            //System.debug('Aditya Bhasin Check');
            CUSTOMER_COMMUNICATION1.PRI_FAX_NUMBER= 'x';
            CUSTOMER_COMMUNICATION.item = new ORL_SAP_CustomerCreateInterface.ZSDST_CUSTOMER_COMMUNICATION[]{};
            CUSTOMER_COMMUNICATION.item.add(CUSTOMER_COMMUNICATION1);
            
           Logger.logDebug('in service createResidentialCustomerInSAP, CUSTOMER_HEADER: '+CUSTOMER_HEADER); 
           Logger.logDebug('in service createResidentialCustomerInSAP, CUSTOMER_COMMUNICATION: '+CUSTOMER_COMMUNICATION);   
           Logger.logDebug('in service createResidentialCustomerInSAP, CUSTOMER_ADDRESS: '+CUSTOMER_ADDRESS);   
           
           response = pushCallObj.ZSD_FM_CUSTOMER_CREATE(CUSTOMER_ADDRESS,CUSTOMER_COMMUNICATION,CUSTOMER_HEADER,RETURN_x);
           
           Logger.logDebug('in service createResidentialCustomerInSAP, response: '+response);
           Logger.logDebug('in service createResidentialCustomerInSAP, response.RETURN_x: '+response.RETURN_x);
           
           ///Add logic of Response handling here
           if(response.RETURN_x != NULL && response.CUSTOMERNO != NULL){
                bookRec.Booking_Number_SAP__c = response.CUSTOMERNO;
                //bookRec.SAP_Sales_Order__c = true;
                bookRec.Move_to_SAP__c = false;
                if(response.CUSTOMERNO != null && !String.isBlank(bookRec.Booking_Number_SAP__c)){
                bookRec.SAP_Status__c = 'Customer Created in SAP successfully.';
                }else{bookRec.SAP_Status__c = 'Customer Creation in SAP failed.';}
                cusDomObj.amendBooking(new list<Booking__c> {bookRec});
                Schema.DescribeFieldResult statField = SAP_Interface_Log__c.Status__c.getDescribe();    
                integer statLen = statField.getLength();
                Schema.DescribeFieldResult msgField = SAP_Interface_Log__c.SAP_Message__c.getDescribe();    
                integer msgLen = msgField.getLength();
                
                tstLog.Status__c = '';
                tstLog.SAP_Message__c = '';
                
                for(ORL_SAP_CustomerCreateInterface.BAPIRET1 retObj: response.RETURN_x.item){
                  string tempStat = tstLog.Status__c+' '+retObj.TYPE_x;
                  string tempMsg = tstLog.SAP_Message__c+' '+retObj.MESSAGE;
                  tstLog.Status__c = tempStat.length() <= statLen ? tempStat : tstLog.Status__c;
                  tstLog.SAP_Message__c = tempMsg.length() <= msgLen ? tempMsg : tstLog.SAP_Message__c;
                }
            }else{
                tstLog.Status__c = 'No Response';
                tstLog.SAP_Message__c = 'No Response Recieved from SAP';
            }
           
         }else{
           tstLog.Status__c = 'Failed';
           tstLog.SAP_Message__c = 'Service Deactivated in Salesforce Or Booking does not exist';
         }     
    }catch(Exception ex){
        Logger.logException('Error in ORL_SAP_CustomerIntegrationService.createResidentialCustomerInSAP:'+ex.getMessage());
        tstLog.Status__c = 'Exception';
        tstLog.SAP_Message__c = ex.getMessage();
    }   
    
    createInterfaceLogs();
    Logger.logDebug('in service createResidentialCustomerInSAP, Logs created and service finished ');
  }catch(Exception ex){
       Logger.logException('Error in ORL_SAP_CustomerIntegrationService.createResidentialCustomerInSAP:'+ex.getMessage());
  }   
}//createResidentialCustomerInSAP


//updateResidentialCustomerInSAP
public void updateResidentialCustomerInSAP(string bookId) {
  try{
    ORL_CustomerDomain cusDomObj = new ORL_CustomerDomain(); 
    serviceSettings = retrieveServiceSettings(system.label.ORL_SAP_CustomerUpdate);
    Logger.logDebug('in service updateResidentialCustomerInSAP, serviceSettings'+serviceSettings);
    SAP_Interface_Log__c tstLog = new SAP_Interface_Log__c();
    try{
        Booking__c bookRec = cusDomObj.retrieveBookingByIds(new List<string> {bookId}).get(0);
        Logger.logDebug('in service updateResidentialCustomerInSAP, bookRecord: '+bookRec);
        
        logLst.add(tstLog);
        tstLog.Logging_Time__c = datetime.Now();
        tstLog.Logging_User__c = UserInfo.getUserId();
        tstLog.Related_Object__c = gtObjectName(bookRec.Id);
        tstLog.Booking__c = bookRec.Id;
        tstLog.Status__c = LOGINPROGRESS;
        tstLog.SAP_Message__c = 'Not sent';
        tstLog.Description__c = 'Update Request for Booking: '+bookRec.Name;
        tstLog.Type__c = serviceSettings.DeveloperName;
        
         //move ahead only if service is active          
         if(isServiceActive() && bookRec != NULL){
           //Initialising Proxy classes
           ORL_SAP_CustomerUpdateInterface.zchange_customer pushCallObj = new ORL_SAP_CustomerUpdateInterface.zchange_customer();
           
            pushCallObj.inputHttpHeaders_x = new Map<String,String>();
           pushCallObj.inputHttpHeaders_x.put('Authorization', getAuthCode());
           pushCallObj.endpoint_x  = serviceSettings.EndPointURL__c;
           Logger.logDebug('In createResidentialCustomerInSAP, inputHttpHeaders_x'+pushCallObj.inputHttpHeaders_x);
           Logger.logDebug('In createResidentialCustomerInSAP, endpoint_x'+pushCallObj.endpoint_x);
           ORL_SAP_CustomerUpdateInterface.ZSD_FM_CUSTOMER_CHANGEResponse_element  response = new ORL_SAP_CustomerUpdateInterface.ZSD_FM_CUSTOMER_CHANGEResponse_element ();
           
           ORL_SAP_CustomerUpdateInterface.TABLE_OF_ZSDST_CUSTOMER_ADDRESS CUSTOMER_ADDRESS = new ORL_SAP_CustomerUpdateInterface.TABLE_OF_ZSDST_CUSTOMER_ADDRESS();
           
           ORL_SAP_CustomerUpdateInterface.TABLE_OF_ZSDST_CUSTOMER_COMMUNICATION CUSTOMER_COMMUNICATION = new ORL_SAP_CustomerUpdateInterface.TABLE_OF_ZSDST_CUSTOMER_COMMUNICATION();
           
           ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_HEADER_CHANGE CUSTOMER_HEADER = new ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_HEADER_CHANGE();
           
           ORL_SAP_CustomerUpdateInterface.TABLE_OF_BAPIRET1 RETURN_x = new ORL_SAP_CustomerUpdateInterface.TABLE_OF_BAPIRET1();
           
           //Retrieve Records from Domain and assign it to Request structure
           //Retrieve related Applicant records
           //list<Applicant__c> applRecs = cusDomObj.retrieveApplicantsByBookingId(bookRec.Id);
            List<Co_Owner__c> listOfCoOwner = [SELECT id,Contact_name__c, Name,PAN__c FROM Co_Owner__c WHERE Booking__c =: bookRec.id];
            system.debug('Co owner list in update call'+listOfCoOwner);
             for(Salutation__mdt obj1:[SELECT MasterLabel,Code__c FROM Salutation__mdt]){
                mapOfSalutationCustomMetaData.put(obj1.MasterLabel,obj1.Code__c);
             }
             for(Country__mdt countryObj: [SELECT MasterLabel,Code__c FROM Country__mdt] ){                
                mapOfCountriesMetaData.put(countryObj.MasterLabel,countryObj.Code__c);
             }
             for(Region__mdt regionobj: [SELECT MasterLabel,Country_Code__c,Code__c FROM Region__mdt]){               
                mapOfRegionMetaData.put(regionobj.MasterLabel,regionobj);
             } 
            system.debug('Data from Custom Metadata'+mapOfSalutationCustomMetaData);

           
           //Logger.logDebug('in service updateResidentialCustomerInSAP, applicant Records: '+applRecs);
           
           //initialise CUSTOMER_HEADER
            CUSTOMER_HEADER.KUNNR= bookRec.Booking_Number_SAP__c;
            CUSTOMER_HEADER.CUSTOMER_TYPE= 'R';
            CUSTOMER_HEADER.BUKRS= '';
            CUSTOMER_HEADER.VKORG= bookRec.CompanyName__c != null ? string.valueOf(bookRec.CompanyName__c) : '';
            CUSTOMER_HEADER.WERKS= bookRec.PlantCode__c != null ? string.valueOf(bookRec.PlantCode__c) : '';
            CUSTOMER_HEADER.VTWEG= bookRec.Opportunity__r.Distribution_channel__c != null ? string.valueOf(bookRec.Opportunity__r.Distribution_channel__c) : '';
            CUSTOMER_HEADER.TITLE_MEDI= (bookRec.Title__c !=null && mapOfSalutationCustomMetaData.size()>0 && !mapOfSalutationCustomMetaData.isEmpty())?mapOfSalutationCustomMetaData.get(bookRec.Title__c) :'';
            system.debug('Header value in update method'+CUSTOMER_HEADER.TITLE_MEDI);
            CUSTOMER_HEADER.NAME1= bookRec.Contact_Name__c != null ? string.valueOf(bookRec.Contact_Name__c) : '';
            CUSTOMER_HEADER.NAME2= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >0 ? listOfCoOwner.get(0).Contact_name__c : '');
            CUSTOMER_HEADER.NAME3= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >1 ? listOfCoOwner.get(1).Contact_name__c : '');
            CUSTOMER_HEADER.NAME4= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >2 ? listOfCoOwner.get(2).Contact_name__c : '');
            CUSTOMER_HEADER.NAME5= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >3 ? listOfCoOwner.get(3).Contact_name__c : '');
            CUSTOMER_HEADER.NAME6= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >4 ? listOfCoOwner.get(4).Contact_name__c : '');
            CUSTOMER_HEADER.NAME7= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >5 ? listOfCoOwner.get(5).Contact_name__c : '');
            CUSTOMER_HEADER.SORT1= bookRec.Unitcode__c != null ? string.valueOf(bookRec.Unitcode__c) : '';
            CUSTOMER_HEADER.SORT2= bookRec.Search_Term__c != null ? string.valueOf(bookRec.Search_Term__c) : '';
            CUSTOMER_HEADER.STCD1= bookRec.PAN__c != null ? string.valueOf(bookRec.PAN__c) : '';
            CUSTOMER_HEADER.STCD2= (listOfCoOwner != NULL && !listOfCoOwner.isEmpty() && listOfCoOwner.size() >0 ? listOfCoOwner.get(0).PAN__c : '');
            system.debug('PAN number on related Co Owner object in update method'+CUSTOMER_HEADER.STCD2);
            CUSTOMER_HEADER.STCD3= bookRec.GSTN__c != null ? string.valueOf(bookRec.GSTN__c) : '';
            system.debug('gst number'+CUSTOMER_HEADER.STCD3);
            CUSTOMER_HEADER.PAN_NUMBER= bookRec.PAN__c != null ? string.valueOf(bookRec.PAN__c) : '';
            system.debug('pan number'+CUSTOMER_HEADER.PAN_NUMBER);
           
           //initialise CUSTOMER_ADDRESS
            ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_ADDRESS CUSTOMER_ADDRESS1 = new ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_ADDRESS();
            CUSTOMER_ADDRESS1.NAME_CO= bookRec.C_o_Name_Billing_Address__c != null ? string.valueOf(bookRec.C_o_Name_Billing_Address__c) : '';            
            CUSTOMER_ADDRESS1.CITY1= bookRec.Billing_City__c != null ? string.valueOf(bookRec.Billing_City__c) : '';
            CUSTOMER_ADDRESS1.POST_CODE1= bookRec.Billing_Post_Code__c != null ? string.valueOf(bookRec.Billing_Post_Code__c) : '';
            CUSTOMER_ADDRESS1.STREET= bookRec.Billing_Street__c != null ? string.valueOf(bookRec.Billing_Street__c) : '';
            CUSTOMER_ADDRESS1.STR_SUPPL1= bookRec.Billing_Str_Suppl1__c != null ? string.valueOf(bookRec.Billing_Str_Suppl1__c) : '';
            CUSTOMER_ADDRESS1.STR_SUPPL2= bookRec.Billing_Str_Suppl2__c != null ? string.valueOf(bookRec.Billing_Str_Suppl2__c) : '';
            CUSTOMER_ADDRESS1.STR_SUPPL3= bookRec.Billing_Str_Suppl3__c != null ? string.valueOf(bookRec.Billing_Str_Suppl3__c) : '';
            CUSTOMER_ADDRESS1.LOCATION= bookRec.Billing_Location__c != null ? string.valueOf(bookRec.Billing_Location__c) : '';
            CUSTOMER_ADDRESS1.COUNTRY= (mapOfCountriesMetaData != null && !mapOfCountriesMetaData.isEmpty() && mapOfCountriesMetaData.size()>0?  mapOfCountriesMetaData.get(bookRec.Billing_Country__c):'');//bookRec.Billing_Country__c;
            system.debug('Booking Billing Country'+CUSTOMER_ADDRESS1.COUNTRY);
            system.debug('Booking Billing Country'+mapOfRegionMetaData.get(bookRec.Billing_Region__c).Country_Code__c);
            system.debug('Booking Billing Country'+mapOfCountriesMetaData.get(bookRec.Billing_Country__c));
            system.debug('Booking Billing Country'+mapOfRegionMetaData.get(bookRec.Billing_Region__c).Code__c);
            if(mapOfRegionMetaData != null && mapOfRegionMetaData.size()>0 && mapOfCountriesMetaData != null 
            && mapOfCountriesMetaData.size()>0){
                if(mapOfRegionMetaData.get(bookRec.Billing_Region__c).Country_Code__c == mapOfCountriesMetaData.get(bookRec.Billing_Country__c)){
                CUSTOMER_ADDRESS1.REGION=mapOfRegionMetaData.get(bookRec.Billing_Region__c).Code__c;
                //mapOfRegionMetaData.get(bookRec.Billing_Region__c);
                //mapOfCountriesMetaData.get(bookRec.Billing_Country__c);
                }
            }
            //CUSTOMER_ADDRESS1.REGION= '13';//(mapOfRegionMetaData != null && !mapOfRegionMetaData.isEmpty() && mapOfRegionMetaData.size()>0?mapOfRegionMetaData.get(bookRec.Billing_Region__c):''); //bookRec.Billing_Region__c;
            /*system.debug('1st'+CUSTOMER_ADDRESS1.NAME_CO);
            system.debug('2nd'+CUSTOMER_ADDRESS1.CITY1);
            system.debug('3rd'+CUSTOMER_ADDRESS1.POST_CODE1);
            system.debug('4th'+CUSTOMER_ADDRESS1.STREET);
            system.debug('5th'+CUSTOMER_ADDRESS1.STR_SUPPL1);
            system.debug('6th'+CUSTOMER_ADDRESS1.STR_SUPPL2);
            system.debug('7th'+CUSTOMER_ADDRESS1.STR_SUPPL3);
            system.debug('8th'+CUSTOMER_ADDRESS1.LOCATION);
            system.debug('9th'+CUSTOMER_ADDRESS1.COUNTRY);
            system.debug('10th'+CUSTOMER_ADDRESS1.REGION);*/
            system.debug('Aditya Bhasin');
            ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_ADDRESS CUSTOMER_ADDRESS2 = new ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_ADDRESS();
            CUSTOMER_ADDRESS2.NAME_CO= bookRec.C_o_Name_Mailing_Address__c;
            CUSTOMER_ADDRESS2.CITY1= bookRec.Mailing_City__c;
            CUSTOMER_ADDRESS2.POST_CODE1= bookRec.Mailing_Post_Code__c;
            CUSTOMER_ADDRESS2.STREET= bookRec.Mailing_Street__c;
            CUSTOMER_ADDRESS2.STR_SUPPL1= bookRec.Mailing_Str_Suppl1__c;
            CUSTOMER_ADDRESS2.STR_SUPPL2= bookRec.Mailing_Str_Suppl2__c;
            CUSTOMER_ADDRESS2.STR_SUPPL3= bookRec.Mailing_Str_Suppl3__c;
            CUSTOMER_ADDRESS2.LOCATION= bookRec.Mailing_Location__c;
            
            CUSTOMER_ADDRESS2.COUNTRY=(mapOfCountriesMetaData != null && !mapOfCountriesMetaData.isEmpty() && mapOfCountriesMetaData.size()>0?  mapOfCountriesMetaData.get(bookRec.Mailing_Country__c):''); //bookRec.Mailing_Country__c;
            CUSTOMER_ADDRESS2.REGION='13';//(mapOfRegionMetaData != null && !mapOfRegionMetaData.isEmpty() && mapOfRegionMetaData.size()>0?mapOfRegionMetaData.get(bookRec.Mailing_Region__c):'');  //bookRec.Mailing_Region__c;
            system.debug('Aditya Bhasin');
            CUSTOMER_ADDRESS.item = new ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_ADDRESS[]{};
            CUSTOMER_ADDRESS.item.add(CUSTOMER_ADDRESS1);
            CUSTOMER_ADDRESS.item.add(CUSTOMER_ADDRESS2);
            system.debug('a'+CUSTOMER_ADDRESS2.NAME_CO);
            system.debug('b'+CUSTOMER_ADDRESS2.CITY1);
            system.debug('c'+CUSTOMER_ADDRESS2.POST_CODE1);
            system.debug('d'+CUSTOMER_ADDRESS2.STREET);
            system.debug('ee'+CUSTOMER_ADDRESS2.STR_SUPPL1);
            system.debug('ff'+CUSTOMER_ADDRESS2.STR_SUPPL2);
            system.debug('gg'+CUSTOMER_ADDRESS2.STR_SUPPL3);
            system.debug('hh'+ CUSTOMER_ADDRESS2.LOCATION); 
            system.debug('Aditya Bhasin');
           //initialise CUSTOMER_COMMUNICATION
            ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_COMMUNICATION CUSTOMER_COMMUNICATION1 = new ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_COMMUNICATION();
            CUSTOMER_COMMUNICATION1.INDICATOR= 'U';
            system.debug('Aditya Bhasin');
            CUSTOMER_COMMUNICATION1.TEL_NUMBER= bookRec.Telephone__c != null ? string.valueOf(bookRec.Telephone__c) : '';
            CUSTOMER_COMMUNICATION1.PRI_TEL_NUMBER= 'x';
            system.debug('Aditya Bhasin');
            CUSTOMER_COMMUNICATION1.SMTP_ADDR= bookRec.Email__c;
            CUSTOMER_COMMUNICATION1.PRI_SMTP_ADDR= 'x';
            system.debug('Aditya Bhasin');
            CUSTOMER_COMMUNICATION1.MOB_NUMBER= bookRec.Mobile__c;
            CUSTOMER_COMMUNICATION1.PRI_MOB_NUMBER= 'x';
            system.debug('Aditya Bhasin');
            CUSTOMER_COMMUNICATION1.FAX_NUMBER= bookRec.Fax_Number__c;
            CUSTOMER_COMMUNICATION1.PRI_FAX_NUMBER= 'x';
            system.debug('Aditya Bhasin');
            CUSTOMER_COMMUNICATION.item = new ORL_SAP_CustomerUpdateInterface.ZSDST_CUSTOMER_COMMUNICATION[]{};
            CUSTOMER_COMMUNICATION.item.add(CUSTOMER_COMMUNICATION1);
            system.debug('111'+CUSTOMER_COMMUNICATION1.INDICATOR);
            system.debug('222'+CUSTOMER_COMMUNICATION1.TEL_NUMBER);
            system.debug('333'+CUSTOMER_COMMUNICATION1.PRI_TEL_NUMBER);
            system.debug('444'+CUSTOMER_COMMUNICATION1.SMTP_ADDR);
            system.debug('555'+CUSTOMER_COMMUNICATION1.PRI_SMTP_ADDR);
            system.debug('666'+CUSTOMER_COMMUNICATION1.MOB_NUMBER);
            system.debug('777'+CUSTOMER_COMMUNICATION1.PRI_MOB_NUMBER);
            system.debug('888'+CUSTOMER_COMMUNICATION1.FAX_NUMBER);
            system.debug('999'+CUSTOMER_COMMUNICATION1.PRI_FAX_NUMBER);  
            
            system.debug('Aditya Bhasin');
            
            
           Logger.logDebug('in service updateResidentialCustomerInSAP, CUSTOMER_HEADER: '+CUSTOMER_HEADER); 
           Logger.logDebug('in service updateResidentialCustomerInSAP, CUSTOMER_COMMUNICATION: '+CUSTOMER_COMMUNICATION);   
           Logger.logDebug('in service updateResidentialCustomerInSAP, CUSTOMER_ADDRESS: '+CUSTOMER_ADDRESS);   
           
           response = pushCallObj.ZSD_FM_CUSTOMER_CHANGE(CUSTOMER_ADDRESS,CUSTOMER_COMMUNICATION,CUSTOMER_HEADER,RETURN_x);
           
           Logger.logDebug('in service updateResidentialCustomerInSAP, response: '+response);
           Logger.logDebug('in service updateResidentialCustomerInSAP, response.RETURN_x: '+response.RETURN_x);
           
           ///Add logic of Response handling here
           if(response.RETURN_x != NULL && response.STATUS != NULL){
                Schema.DescribeFieldResult statField = SAP_Interface_Log__c.Status__c.getDescribe();    
                integer statLen = statField.getLength();
                Schema.DescribeFieldResult msgField = SAP_Interface_Log__c.SAP_Message__c.getDescribe();    
                integer msgLen = msgField.getLength();
                
                tstLog.Status__c = '';
                tstLog.SAP_Message__c = '';
                
                for(ORL_SAP_CustomerUpdateInterface.BAPIRET1 retObj: response.RETURN_x.item){
                  string tempStat = tstLog.Status__c+'; '+retObj.TYPE_x;
                  string tempMsg = tstLog.SAP_Message__c+'; '+retObj.MESSAGE;
                  tstLog.Status__c = tempStat.length() <= statLen ? tempStat : tstLog.Status__c;
                  tstLog.SAP_Message__c = tempMsg.length() <= msgLen ? tempMsg : tstLog.SAP_Message__c;
                }
            }else{
                tstLog.Status__c = 'No Response';
                tstLog.SAP_Message__c = 'No Response Recieved from SAP';
            }
            
           
         }else{
           tstLog.Status__c = 'Failed';
           tstLog.SAP_Message__c = 'Service Deactivated in Salesforce Or Booking does not exist';
         }     
    }catch(Exception ex){
        Logger.logException('Error in ORL_SAP_CustomerIntegrationService.updateResidentialCustomerInSAP:'+ex.getMessage());
        tstLog.Status__c = 'Exception';
        tstLog.SAP_Message__c = ex.getMessage();
    }   
    
    createInterfaceLogs();
    Logger.logDebug('in service updateResidentialCustomerInSAP, Logs created and service finished ');
  }catch(Exception ex){
       Logger.logException('Error in ORL_SAP_CustomerIntegrationService.updateResidentialCustomerInSAP:'+ex.getMessage());
  }   
}//updateResidentialCustomerInSAP
}
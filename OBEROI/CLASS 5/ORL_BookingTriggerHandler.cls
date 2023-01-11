/*
*  Author: Vivek S, Aditya Bhasin
*  Description: Controller Class for the Booking Trigger
*  Change Log: Logic Added by Aditya Bhasin for Customer Creation 22.03.2019
*  Change Log: Logic Added by Aditya Bhasin for Customer Updation 28.03.2019
*  Change Log: Logic Added by Aditya Bhasin for Sales Order Creation and Updation 04.03.2019
*/
public class ORL_BookingTriggerHandler {

public static void onBeforeInsert(List<Booking__c> bookList) {  
   Id devRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Default Billing Plan').getRecordTypeId(); 
   Set<Id> setOppId = new Set<Id>(); 
   Set<Id> setPropertyId = new Set<Id>();
   Set<id> setTowerId = new Set<Id>();
   Set<id> setBillingPlanId = new Set<Id>();
   Map<Id,Payment_Plan__c> OppIdToBillingPlanMap = new map<Id,Payment_Plan__c>();
   Map<Id,Payment_Plan__c> PropertyIdToBillingPlanMap= new map<Id,Payment_Plan__c>();
   Map<Id,Id> TowerToPropertyMap = new map<Id,Id>();
   Map<Id,Booking__c> mapOfBookToProperty = new Map<id,Booking__c>();
   Map<Id,Payment_Plan__c> mapOfBP = new Map<id,Payment_Plan__c>();
   Map<Id,Opportunity> mapopp = new Map<Id,Opportunity>();
   List<Property__c> lstProperty = new List<Property__c>();
   for(Booking__c bookRec: bookList){

   //if(bookRec.Billing_Plan__c == ''){
        //mapopp.put(bookRec.Opportunity__c,bookRec);
        setBillingPlanId.add(bookRec.Billing_Plan__c);
        setOppId.add(bookRec.Opportunity__c);
        //setPropertyId.add(bookRec.Property__c);
        //mapOfBookToProperty.put(bookRec.Property__c,bookRec);
    // }
    }  
    for(Payment_Plan__c bpln : [select Site__c, Project__c, Property__c, Tower__c from Payment_Plan__c where ID IN : setBillingPlanId]){
        mapOfBP.put(bpln.Id,bpln);
    }
    for(Booking__c bookObj: bookList){
        //Added by Aditya Bhasin for Auto Populate Start
                     bookObj.Site__c = mapOfBP.get(bookObj.Billing_Plan__c).Site__c;
                     bookObj.Project__c = mapOfBP.get(bookObj.Billing_Plan__c).Project__c;
                     bookObj.Tower__c = mapOfBP.get(bookObj.Billing_Plan__c).Tower__c;
                     bookObj.Property__c = mapOfBP.get(bookObj.Billing_Plan__c).Property__c;
                     system.debug('111111111111111111111'+mapOfBP.get(bookObj.Billing_Plan__c));
                     system.debug('111111111111111111111'+mapOfBP.values());
                     system.debug('111111111111111111111'+mapOfBP.get(bookObj.Billing_Plan__c).Property__c);
                     system.debug('111111111111111111111'+bookObj.Property__c);
                     //Added by Aditya Bhasin for Auto Populate Stop
        setPropertyId.add(bookObj.Property__c);
        mapOfBookToProperty.put(bookObj.Property__c,bookObj);
    }
    for(Property__c propObj: [SELECT id,Tower__c,Booking__c,Temporary_Block__c,Block_Comments__c,Blocked_By__c,Blocked_By__r.Name FROM Property__c WHERE Id IN:mapOfBookToProperty.keyset()]){
        setTowerId.add(propObj.Tower__c);
        if(propObj.Temporary_Block__c == false
        && mapOfBookToProperty.size()>0 && !mapOfBookToProperty.isEmpty()){
            Booking__c bookObj=mapOfBookToProperty.get(propObj.id);
            //system.debug('lstPropertylstProperty'+bookObj.Id);
            bookObj.adderror('Please block a property before creating booking.');
        }
        if(propObj.Temporary_Block__c == true && propObj.Block_Comments__c != null 
        && mapOfBookToProperty.size()>0 && !mapOfBookToProperty.isEmpty()){ 
            if(propObj.Blocked_By__c != UserInfo.getUserId()){
            Booking__c bookObj=mapOfBookToProperty.get(propObj.id);
            //system.debug('lstPropertylstProperty'+bookObj.Id);
            bookObj.adderror('Property already Blocked by : '+propObj.Blocked_By__r.Name);
            }
        }
        
        
    }
      system.debug('@@setOppId'+setOppId);
      system.debug('@@setPropertyId'+setPropertyId);
      system.debug('@@setTowerId'+setTowerId);
      for(Payment_Plan__c payPlanObj :[SELECT id,Opportunity__c ,Property__c FROM Payment_Plan__c 
                                                   WHERE Opportunity__c IN: setOppId
                                                    AND Status__c='Approved'
                                                    AND Active__c= true
                                                    AND Property__c!= ''
                                                    ORDER BY createdDate desc limit 1]){
                    OppIdToBillingPlanMap.put(payPlanObj.Opportunity__c,payPlanObj);
       }
       
       for(Property__c propObj : [SELECT Id,Tower__c FROM Property__c
                               WHERE Id IN: setPropertyId]){
           TowerToPropertyMap.put(propObj.Tower__c,propObj.Id);
       }
       system.debug('@@TowerToPropertyMap'+TowerToPropertyMap);
       
       for(Payment_Plan__c payPlanObj :[SELECT Id,Tower__c,Property__c FROM Payment_Plan__c 
                                                   WHERE Tower__c IN: setTowerId
                                                    AND Active__c= true
                                                    AND Payment_Plan_Type__c='Non Scheme'
                                                    AND RecordTypeId=: devRecordTypeId]){
                    PropertyIdToBillingPlanMap.put(TowerToPropertyMap.get(payPlanObj.Tower__c),payPlanObj);
       }
             system.debug('@@OppIdToBillingPlanMap '+OppIdToBillingPlanMap );
             system.debug('@@PropertyIdToBillingPlanMap'+PropertyIdToBillingPlanMap);
        
         for(Booking__c bookObj: bookList){
             if(!OppIdToBillingPlanMap.isEmpty() && bookObj.Property__c == OppIdToBillingPlanMap.get(bookObj.Opportunity__c).Property__c){
                 //bookObj.Billing_Plan__c= OppIdToBillingPlanMap.get(bookObj.Opportunity__c).Id;
             }
             else if(!PropertyIdToBillingPlanMap.isEmpty()){
             system.debug('@@bookObj.Property__c'+bookObj.Property__c);
                 //bookObj.Billing_Plan__c= PropertyIdToBillingPlanMap.get(bookObj.Property__c).Id;
             }
             else{
                 //bookObj.addError('There is no default Booking Plan for corresponding Property.');
             }
         }
            
        
        //list<property__c> proplist = [SELECT id,name,Floor__r.id,Tower__c,Temporary_Block__c,Block_Comments__c,Blocked_By__c,Blocked_By__r.id FROM Property__c WHERE Id IN:setPropertyId];
            
            for(Opportunity opp: [select id, Account.PAN__pc,Account.PersonEmail,Site__r.Name,AccountId, 
                Account.Phone,Account.Locality__c,Account.House_No__c,Account.Street_2__c,Account.Street_3__c,
                Account.Street__c, Account.City__c, Account.Country_Picklist__c, Account.Postal_code__c,
                Partner_s_Firm_Name__c,Partner_s_Name__c,Partner_Email__c,Partner_Mobile__c,PCID__c,
                Account.PersonMobilePhone from Opportunity where ID IN: setOppId]){
                mapopp.put(opp.Id,opp);
            }
            for(Booking__c bookObj: bookList){
                if(bookObj.status__c == 'In Progress'){
                    //system.debug(''+bookObj.Opportunity__r.Primary_Contact__c);
                    //bookObj.Floor__c = bookObj.Property__r.floor__r.id;
                     bookObj.Primary_Applicants__c = mapopp.get(bookObj.Opportunity__c).AccountId;//bookObj.Opportunity__r.Primary_Contact__c;
                     bookObj.Billing_Street__c = mapopp.get(bookObj.Opportunity__c).Account.Street__c;
                     bookObj.Billing_City__c = mapopp.get(bookObj.Opportunity__c).Account.City__c;
                     bookObj.Billing_Country__c = mapopp.get(bookObj.Opportunity__c).Account.Country_Picklist__c;
                     bookObj.Billing_Location__c = mapopp.get(bookObj.Opportunity__c).Account.Locality__c;
                     bookObj.Billing_Post_Code__c = mapopp.get(bookObj.Opportunity__c).Account.Postal_code__c;
                     bookObj.Mobile__c = mapopp.get(bookObj.Opportunity__c).Account.PersonMobilePhone;
                     bookObj.Email__c = mapopp.get(bookObj.Opportunity__c).Account.PersonEmail;
                     bookObj.PAN_Number__c = mapopp.get(bookObj.Opportunity__c).Account.PAN__pc;
                     bookObj.Sales_Rep__c = Userinfo.getUserid();
                     bookObj.Telephone__c = mapopp.get(bookObj.Opportunity__c).Account.Phone;
                     bookObj.C_o_Name_Billing_Address__c = mapopp.get(bookObj.Opportunity__c).Account.House_No__c;
                     bookObj.Billing_Str_Suppl2__c = mapopp.get(bookObj.Opportunity__c).Account.Street_2__c;
                     bookObj.Billing_Str_Suppl3__c = mapopp.get(bookObj.Opportunity__c).Account.Street_3__c;
                     if(mapopp.size() > 0 &&!String.isBlank(mapopp.get(bookObj.Opportunity__c).Partner_s_Firm_Name__c)){
                     bookObj.Property_Consultant_s_Account_Name__c = mapopp.get(bookObj.Opportunity__c).Partner_s_Firm_Name__c;}
                     if(mapopp.size() > 0 &&!String.isBlank(mapopp.get(bookObj.Opportunity__c).Partner_s_Name__c)){
                     bookObj.Property_Consultant_s_Name__c = mapopp.get(bookObj.Opportunity__c).Partner_s_Name__c;}
                     if(mapopp.size() > 0 &&!String.isBlank(mapopp.get(bookObj.Opportunity__c).Partner_Mobile__c)){
                     bookObj.Property_Consultant_s_Mobile__c = mapopp.get(bookObj.Opportunity__c).Partner_Mobile__c;}
                     if(mapopp.size() > 0 &&!String.isBlank(mapopp.get(bookObj.Opportunity__c).Partner_Email__c)){
                     bookObj.Property_Consultant_s_Email__c = mapopp.get(bookObj.Opportunity__c).Partner_Email__c;}
                     if(mapopp.size() > 0 &&!String.isBlank(mapopp.get(bookObj.Opportunity__c).PCID__c)){
                     bookObj.RERA_Registration_No__c = mapopp.get(bookObj.Opportunity__c).PCID__c;}
                     
                     
                }
            }
        }


public static void onBeforeUpdate(List<Booking__c> bookList, map<id,Booking__c> oldBookMap) {    
    Id updateRTId = Schema.SObjectType.Booking__c.getRecordTypeInfosByName().get('Booking Locked').getRecordTypeId(); 
    //Booking__c bookRec = bookList.get(0);
    List<Booking__c> lstBooking = new List<Booking__c>();
    for(Booking__c bookRec : bookList){
        /*
    if(bookRec.Move_to_SAP__c && !oldBookMap.get(bookRec.Id).Move_to_SAP__c 
      && String.isBlank(oldBookMap.get(bookRec.Id).Booking_Number_SAP__c)){
      logger.logDebug('ORL_BookingTriggerHandler, onBeforeUpdate: calling Customer create service');
       ORL_SAP_IntegrationHelper.createResidentialCustomerInSAPFuture(bookRec.Id);
       
      logger.logDebug('ORL_BookingTriggerHandler, onBeforeUpdate: Trigger completed');
    }
    else if(bookRec.Move_to_SAP__c && !oldBookMap.get(bookRec.Id).Move_to_SAP__c
        && String.isNotBlank(oldBookMap.get(bookRec.Id).Booking_Number_SAP__c)){
      logger.logDebug('ORL_BookingTriggerHandler, onBeforeUpdate: calling Customer update service');
        if(bookRec.SAP_Sales_Order__c){
            ORL_SAP_IntegrationHelper.updateResidentialCustomerInSAPFuture(bookRec.Id);
            if(!String.isBlank(bookRec.Related_Jodi_Booking__c)){
             System.enqueueJob(new AsyncCustomerJodiUpdate(bookRec.Related_Jodi_Booking__c));
            }
        }
        else {
            ORL_SAP_IntegrationHelper.createSalesOrderInSAPFuture(bookRec.Id);
            if(!String.isBlank(bookRec.Related_Jodi_Booking__c)){
             System.enqueueJob(new AsyncSalesOrderJodi(bookRec.Related_Jodi_Booking__c));
            }
        }
       //bookRec.Move_to_SAP__c = false;
      logger.logDebug('ORL_BookingTriggerHandler, onBeforeUpdate: Trigger completed');
      
    }
    */
    // Creation of Sales Order if it fails in 1st place for Admin
    /*
    if(bookRec.SAP_Sales_Order__c && !oldBookMap.get(bookRec.Id).SAP_Sales_Order__c 
        && String.isNotBlank(oldBookMap.get(bookRec.Id).Booking_Number_SAP__c)){
      logger.logDebug('ORL_BookingTriggerHandler, onBeforeUpdate: calling Sales Order Create Service');
       ORL_SAP_IntegrationHelper.createSalesOrderInSAPFuture(bookRec.Id);
        if(!String.isBlank(bookRec.Related_Jodi_Booking__c)){
         System.enqueueJob(new AsyncSalesOrder(bookRec.Related_Jodi_Booking__c));
        }
       bookRec.SAP_Sales_Order__c = false;
      logger.logDebug('ORL_BookingTriggerHandler, onBeforeUpdate: Trigger completed');
      
    }*/
    /*else if(bookRec.Move_to_SAP__c && !oldBookMap.get(bookRec.Id).Move_to_SAP__c
        && String.isNotBlank(oldBookMap.get(bookRec.Id).Booking_Number_SAP__c) 
        && String.isNotBlank(oldBookMap.get(bookRec.Id).Sales_Document_SAP__c)){
      logger.logDebug('ORL_BookingTriggerHandler, onBeforeUpdate: calling Sales Order Update Service');
       ORL_SAP_IntegrationHelper.updateSalesOrderInSAPFuture(bookRec.Id);
       bookRec.Move_to_SAP__c = false;
      logger.logDebug('ORL_BookingTriggerHandler, onBeforeUpdate: Trigger completed');
      
    }*/
    
    //Lock record when changed status to booked
    if(!String.isBlank(bookRec.Status__c) && bookRec.Status__c != oldBookMap.get(bookRec.Id).Status__c && 
    bookRec.Status__c.equalsIgnoreCase('Booked')){
        /*List<Payment__c> lstPayment = [select id from Payment__c where Booking__c =: bookRec.Id];
        System.debug('lstPaymentlstPaymentlstPaymentlstPayment');
        if(lstPayment.isEmpty()){
        bookRec.addError('Please Add Initial Payment before changing status to Booked.');}*/
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitted for approval');
        req.setObjectId(bookRec.Id);
        Approval.ProcessResult approvalResult = Approval.process(req);
        System.debug('bookRec submitted for approval successfully: '+approvalResult.isSuccess());
        bookRec.RecordTypeId = updateRTId;
        if(!String.isBlank(bookRec.Related_Jodi_Booking__c)){
            Booking__c bkg = [select id, Status__c from Booking__c where id =: bookRec.Related_Jodi_Booking__c];
            bkg.Status__c = 'Booked';
            lstBooking.add(bkg);
        }
    }
    //Lock record when changed status to booked
   }
   //Restrict user to book the status logic start
   Booking__c bookRec = bookList.get(0);
   if(!String.isBlank(bookRec.Status__c) && bookRec.Status__c != oldBookMap.get(bookRec.Id).Status__c && 
    bookRec.Status__c.equalsIgnoreCase('Booked')){
        List<Payment__c> lstPayment = [select id from Payment__c where Booking__c =: bookRec.Id];
        System.debug('lstPaymentlstPaymentlstPaymentlstPayment');
        if(lstPayment.isEmpty()){
        bookRec.addError('Please Add Initial Payment before changing status to Booked.');}
        List<Id> lstCoOwnerId = new List<Id>();
        List<Id> lstKycId = new List<Id>();
        lstCoOwnerId.add(bookRec.Primary_Applicants__c);
        for(Co_Owner__c co : [Select id, Name, Person_Account__c from Co_Owner__c where Booking__c =: bookRec.Id 
        order by Name asc]){
            if(!String.isBlank(co.Person_Account__c)){
                lstCoOwnerId.add(co.Person_Account__c);
            }    
        }
        for(KYC_Details__c kyc : [select Person_Account__c from KYC_Details__c where Person_Account__c IN : lstCoOwnerId]){
            lstKycId.add(kyc.Person_Account__c);
        }
        system.debug('lstKycIdlstKycIdlstKycId'+lstKycId);
        system.debug('lstCoOwnerIdlstCoOwnerId'+lstCoOwnerId);
        for(string s : lstCoOwnerId){
            if(!lstKycId.contains(s)){
            system.debug('ssssssssssssssssssssssss'+s);
                bookRec.addError('Please complete KYC for Primary Applicant and Co-Owners.');
                }
        }
    }
   //Restrict user to book the status logic end
   if(lstBooking != null && lstBooking.size() > 0){
     update lstBooking;
   }
   Map<Id,Booking__c> mapOfBookToProperty = new Map<id,Booking__c>();
   Set<Id> setPropertyId = new Set<Id>();
   for(Booking__c bookRec1: bookList){

        setPropertyId.add(bookRec1.Property__c);
        mapOfBookToProperty.put(bookRec1.Property__r.id,bookRec1);
    }  
    
    for(Property__c propObj: [SELECT Tower__c,Temporary_Block__c,Block_Comments__c,Blocked_By__c,Blocked_By__r.id FROM Property__c WHERE Id IN:setPropertyId]){
   
        if(propObj.Temporary_Block__c == true && propObj.Block_Comments__c != null && propObj.Blocked_By__r.id != UserInfo.getUserId()){
        
            Booking__c bookObj=mapOfBookToProperty.get(propObj.id);
            //bookObj.adderror('Property already booked by another Sales Rep');
        }
        
    }
   
}

public static void onAfterInsert(List<Booking__c> bookList, map<id,Booking__c> oldBookMap) {    
  //Logic on after insert
  Map<Id,Id> mapOfBookToProperty = new Map<id,Id>();
       Map<Id,Opportunity> mapopp = new Map<Id,Opportunity>();
       List<Property__c> lstProperty = new List<Property__c>();
       Map<Id,Id> mapCOwner = new Map<Id,Id>();
        for(Booking__c bookRec: bookList){
            mapOfBookToProperty.put(bookRec.Property__c,bookRec.Id);
            mapCOwner.put(bookRec.Opportunity__c,bookRec.Id);
        }  
    
    for(Property__c propObj: [SELECT id,Tower__c,Booking__c,Temporary_Block__c,Block_Comments__c,Blocked_By__c,Blocked_By__r.Name FROM Property__c WHERE Id IN:mapOfBookToProperty.keyset()]){
        system.debug('propObjpropObj'+mapOfBookToProperty.get(propObj.Id));
        if(propObj.Temporary_Block__c == true && propObj.Blocked_By__c != null
        && propObj.Block_Comments__c != null 
        && propObj.Blocked_By__c == UserInfo.getUserId()
        && mapOfBookToProperty.size()>0 && !mapOfBookToProperty.isEmpty()){ 
        system.debug('propObjpropObj');
            propObj.Temporary_Block__c = false;
            propObj.Booking__c = mapOfBookToProperty.get(propObj.Id);   
            lstProperty.add(propObj);       
        }
    }
    if(lstProperty != null && lstProperty.size() > 0){
        update lstProperty;
    }
    List<Co_Owner__c> lstCowner = new List<Co_Owner__c>();
    for(Co_Owner__c co : [select id,Booking__c,Opportunity__c,Person_Account__c from Co_Owner__c 
        where Opportunity__c IN: mapCOwner.keyset()]){
        if(mapCOwner != null && mapCOwner.size() > 0 && mapCOwner.containskey(co.Opportunity__c)){
            Co_Owner__c bookingCoOwner = new Co_Owner__c();
            bookingCoOwner.Booking__c = mapCOwner.get(co.Opportunity__c);
            bookingCoOwner.Person_Account__c = co.Person_Account__c;
            lstCowner.add(bookingCoOwner);
        }
    }
    if(lstCowner != null && lstCowner.size() > 0){
        insert lstCowner;
    }
}

public static void onAfterUpdate(List<Booking__c> bookList, map<id,Booking__c> oldBookMap) {    
   //Logic on after Update   
    //If user Attach Billing Plan on booking record then Related Jodi Billing Plan will also be attached to Jodi Booking.
    //Logic to be added
    
}

}
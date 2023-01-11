public class BlockingClass2 {
    @AuraEnabled
    public static Opportunity getopp(String oppId){
        system.debug('oppid:' +oppId);
        list<Opportunity> oppname=[select id,name,Account.Name,Account.PersonMobilePhone,Account.PersonEmail from Opportunity where id =: oppId];
        return oppname[0];
        
    }
    @AuraEnabled
    public static Property__c getunit(String unitId){
        system.debug('unitid:' +unitId);
        list<Property__c> Prop = [select id, Name,Material_No__c From Property__c Where id =: UnitId];
        return Prop[0];
    }
   
   @AuraEnabled
   public static Id saveBlockingRecord(Blocking_Detail__c blockObj,string oppId,string unitId,string act){
        
        list<Opportunity> oppname=[select id,name,Account.Name,Account.PersonMobilePhone,Account.PersonEmail,AccountId from Opportunity where id =: oppId];
        list<Property__c> Prop = [select id, Name,Material_No__c From Property__c Where id =: UnitId];
       if(act == 'Blocked'){
        blockObj.Account_Name__c = oppname[0].AccountId;
        blockObj.Opportunity__c = oppname[0].id;
        blockObj.PersonMobilePhone__c = oppname[0].Account.PersonMobilePhone;
        blockObj.Person_Email__c=oppname[0].Account.PersonEmail;
        blockObj.Unit_No__c =Prop[0].Material_No__c;
        blockObj.Unit__c=Prop[0].id;
        //blockObj.Status__c='Blocking In Process';
        insert blockObj; 
       }
      
       system.debug('blockobj:'+blockObj);
       if(act=='Released'){
           System.debug('UnBlocked Code');            
           List<Blocking_Detail__c> blckDtls = [SELECT Id,Release_Comments__c,Comments__c,Token_Amount__c,Cheque_Number__c,Instrument_Date__c,Opportunity__c,Unit_Number__c,Unit__c,Unit__r.Material_No__c,Status__c,Person_Email__c,PersonMobilePhone__c,Account_Name__c,Sales_Manager__c,Sales_Manager_Email__c FROM Blocking_Detail__c WHERE Unit__c = :unitId AND Status__c = 'Blocked' ORDER BY CreatedDate DESC];           
           system.debug('Blocked Dtls: ' + blckDtls);
           Blocking_Detail__c UnblockingRecord = new Blocking_Detail__c();
           //UnblockingRecord.Status__c = 'Released In Process';   //UnblokingRecord.Status__c = 'Unreserved'; 
           //if(! blckDtls.isEmpty()){
               System.debug('Released Success');
           UnblockingRecord.Id = 'a18p0000004kT4v'; 
           UnblockingRecord.Account_Name__c = blckDtls[0].Account_Name__c;
           UnblockingRecord.Person_Email__c = blckDtls[0].Person_Email__c;
           UnblockingRecord.PersonMobilePhone__c = blckDtls[0].PersonMobilePhone__c;
           UnblockingRecord.Sales_Manager__c = blckDtls[0].Sales_Manager__c;
           UnblockingRecord.Sales_Manager_Email__c = blckDtls[0].Sales_Manager_Email__c;
           UnblockingRecord.Token_Amount__c = blckDtls[0].Token_Amount__c;
           UnblockingRecord.Instrument_Date__c = blckDtls[0].Instrument_Date__c;
           UnblockingRecord.Cheque_Number__c = blckDtls[0].Cheque_Number__c;
           UnblockingRecord.Release_Comments__c = blockObj.Release_Comments__c;
               System.debug('Released Success');
           //}   
           //UnblockingRecord.Id = 'a18p0000004kT4v';
           //UnblockingRecord.Release_Comments__c = blockObj.Release_Comments__c;
           update UnblockingRecord;			 
           }
           

        return blockObj.Id;
    }
}
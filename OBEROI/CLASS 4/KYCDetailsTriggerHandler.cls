/**
* @Author:      Nistha Anand
* @Company:  IBM
* @Date:        25/04/2019
* @Description: Handler Class for KYCDetailsTrigger on KYC Details Object.
*/

public class KYCDetailsTriggerHandler{

    public static void handleBeforeInsert(list<KYC_Details__c> listOfKYCDetails){

        Set<id> personAccountId = new Set<id>();
        Map<Id,Id> mapOfKYCDetailsToRelatedPersonAccount = new Map<Id,Id>();

        for(KYC_Details__c kycDetailsObj:listOfKYCDetails){

            personAccountId.add(kycDetailsObj.Person_Account__c);
            mapOfKYCDetailsToRelatedPersonAccount.put(kycDetailsObj.Id,kycDetailsObj.Person_Account__c);
        }

        List<Account> listOfRelatedPersonAccount = [SELECT PersonContactId FROM Account WHERE Id IN :personAccountId];
        Map<Id,Id> mapOfpersonAccountIdToPersonContactId = new Map<Id,Id>();
        for(Account relatedPersonAccountObj: listOfRelatedPersonAccount){
            mapOfpersonAccountIdToPersonContactId.put(relatedPersonAccountObj.id,relatedPersonAccountObj.PersonContactId);
        }

        system.debug('********'+MapOfpersonAccountIdToPersonContactId);

        List<Contact> listOfPersonContact=[SELECT id,Customer_Classification__c FROM Contact where Id IN:mapOfpersonAccountIdToPersonContactId.values()];
        Map<Id,String> mapOfPersonContact = new Map<Id,String>();
        for(Contact personContactObj: listOfPersonContact){
            mapOfPersonContact.put(personContactObj.id,personContactObj.Customer_Classification__c);
        }

        system.debug('$$$List of Person Contact$$$$'+listOfPersonContact);
        System.debug('!!!Map of person Contact!!!'+mapOfPersonContact);

        for(KYC_Details__c kycDetailsObj:listOfKYCDetails){
            system.debug('FINAL$$$$'+mapOfPersonContact.get(mapOfpersonAccountIdToPersonContactId.get(mapOfKYCDetailsToRelatedPersonAccount.get(kycDetailsObj.id))));
            if(kycDetailsObj.Record_Type__c != mapOfPersonContact.get(mapOfpersonAccountIdToPersonContactId.get(mapOfKYCDetailsToRelatedPersonAccount.get(kycDetailsObj.id)))){
                kycDetailsObj.addError('Please select KYC Record Type as per Related Person Account Customer Classification.');
            }
        }
    }
}
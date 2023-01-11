/**
* @Author:      Nistha Anand
* @Company:  IBM
* @Date:        25/04/2019
* @Description: Trigger for Matching Customer Classification and KYC Details Record Type.
*/

trigger KYCDetailsTrigger on KYC_Details__c (before insert){

    if(trigger.isBefore && trigger.isInsert){
        KYCDetailsTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}
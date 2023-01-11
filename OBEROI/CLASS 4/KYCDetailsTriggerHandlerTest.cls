/****************************************************************************************************
Class covered :
1. KYCDetailsTriggerHandler - 7/6/2019 - 100%

****************************************************************************************************/

@isTest(seeAllData=false)
public class KYCDetailsTriggerHandlerTest {
    static testMethod void testBeforeInsertKYC(){
        try{
            List<Account> lstAccount =TestDataFactory.createAccounts(2);
            insert lstAccount; 
            List<KYC_Details__c> kycLst = new List<KYC_Details__c>();
            Test.startTest();
            for (Integer i = 0 ; i < 2 ; i++ ) {            
                KYC_Details__c kyc = new KYC_Details__c();
                kyc.Person_Account__c = lstAccount[i].Id;
                kycLst.add(kyc);            
            }
            insert kycLst;
            Test.stopTest();
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Please select KYC Record Type as per Related Person Account Customer Classification.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        } 
    }
}
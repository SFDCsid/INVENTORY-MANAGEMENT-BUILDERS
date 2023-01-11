/****************************************************************************************************
Class covered :
1. OpportunityTriggerController - 7/6/2019 - 100%

****************************************************************************************************/
@isTest(seeAllData=false)
public with sharing class OpportunityTriggerControllerTest {
    public static void createData()
{
    Account accountRecord = new Account();
    accountRecord.Name = 'PYN estate';
    accountRecord.AccountNumber = '01235';
    insert accountRecord;
   
    Opportunity oppt = new Opportunity();
    oppt.Name ='Test123';
    oppt.AccountID = accountRecord.Id;
    oppt.StageName = 'Follow Up';
    oppt.Amount = 3000;
    oppt.CloseDate = System.today();
    insert oppt; 
    
}
    @IsTest    
public static void createQuickBookingTest(){
    createData();
    Map<Id,Id> mapIds = new Map<Id,Id>();
    test.startTest();
    try{
    Opportunity OpportunityIds=[Select Id from Opportunity where name='Test123'];
    Id oppid = OpportunityIds.id;
    mapIds.put(oppid,oppid );
    OpportunityTriggerController.createQuickBooking(mapIds);
    }
    Catch(Exception e){
        
    }
    test.stopTest();
    }
}
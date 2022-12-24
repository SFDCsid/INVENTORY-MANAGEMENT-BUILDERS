public with sharing class requisitionclass {
    @AuraEnabled (cacheable=true)
    public static  list<Milestone__c> MilestoneMethod(string Id){
        list<Milestone__c> milestonelist = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Start_Date__c, End_Date__c, Project_Manager__c, Duration__c FROM Milestone__c WHERE Id =:Id ];
      return milestonelist;
     
    }

    @AuraEnabled (cacheable=true)
    public static  list<Bill_Of_Material__c> BillMethod(string Id){
        list<Bill_Of_Material__c> billList = [SELECT   Id, Name , Milestone__c , Material__r.Name  FROM Bill_Of_Material__c  WHERE Milestone__c =:Id ];
      return billList;
     
    }
}

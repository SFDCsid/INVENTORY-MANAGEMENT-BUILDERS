public class SM_AssignmentController {
	@AuraEnabled
    public static Site_Visit__c getSVRecord(Id RecordSV) {
        Site_Visit__c svRecord = [SELECT Id, OwnerId, Project__r.Name, Sales_Manager__c, RR_Assignment_Type__c FROM Site_Visit__c 
                                  where Id =: RecordSV];
        if(svRecord != Null)
            return svRecord;
        else
            return Null;
    }
    
    @AuraEnabled
    public static List<Team_Members__c> getAllSalesManager(Site_Visit__c svRecord) {
        List<Team_Members__c> userList = [Select Id, User__r.Name, Availability__c, Last_Assignment_DateTime__c, Last_Assigned_Milliseconds__c, Assignment_Counter__c from Team_Members__c
                                       	  where Team__r.Project__c =: svRecord.Project__c AND IsActive__c = true AND Team__r.Team_Type__c = 'Sales Team'];
        return userList;
    }
    
    @AuraEnabled
    public static Team_Members__c checkUserAvailability(Id userId) {
        Team_Members__c salesManager = [Select Id, User__r.Name, Availability__c, Last_Assignment_DateTime__c, Last_Assigned_Milliseconds__c, Assignment_Counter__c from Team_Members__c 
                                        where Id =: userid AND IsActive__c = true];
        if(salesManager != Null)
            return salesManager;
        else
            return Null;
    }
    
    @AuraEnabled
    public static boolean assignSalesManager(Site_Visit__c svRecord, Team_Members__c salesManager) {
        svRecord.Sales_Manager__c = salesManager.User__r.Id;
        svRecord.RR_Assignment_Type__c = 'Manual Assignment';
        
        salesManager.Availability__c = false;
        salesManager.Last_Assignment_DateTime__c = system.now();
        salesManager.Last_Assigned_Milliseconds__c = system.now().millisecondGMT();
        salesManager.Assignment_Counter__c = salesManager.Assignment_Counter__c + 1;
        
        try {
            update svRecord;
            update salesManager;
            return true;
        } catch(Exception ex) {
            system.debug('Error: '+ex.getMessage());
            return false;   
        }
    }
}
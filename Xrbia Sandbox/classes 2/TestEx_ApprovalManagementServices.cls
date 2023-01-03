@isTest
public class TestEx_ApprovalManagementServices {
	@isTest
    public static Map<String, String> createCampaign() {
        Map<String, String> resultMap = new Map<String, String>();
        
        Project__c p = new Project__c();
        p.Name = 'Test Project';
        p.Marketing_Head__c = UserInfo.getUserId();
        insert p;
        resultMap.put('Project', p.Id);
        
        Marketing_Brief__c Mb = new Marketing_Brief__c();
        Mb.Project__c = p.Id;
        Mb.Start_Date__c = system.today();
        Mb.End_Date__c = system.today().addDays(30);
        Mb.Expected_Cost__c = 20000;
        Mb.Expected_Bookings__c = 20;
        Mb.Expected_Leads__c = 2000;
        Mb.Expected_Visits__c = 200;
        Mb.Status__c = 'In-process';
        insert Mb;
        resultMap.put('Marketing Brief', Mb.Id);
        
        Campaign__c c = new Campaign__c();
        c.RecordTypeId = Schema.SObjectType.Campaign__c.getRecordTypeInfosByName().get('TV Plan').getRecordTypeId();
        c.Name = 'Test Campaign';
        c.Marketing_Brief__c = Mb.Id;
        c.Project__c = p.Id;
        c.StartDate__c = system.today();
        c.EndDate__c = system.today().addDays(15);
        c.Status__c = 'Planning';
        c.Performance_Measure_On__c = 'Daily';
        c.Campaign_Code__c = 'Test Campaign';
        c.Planned_Cost__c = 10000;
        c.Planned_Leads__c = 1000;
        c.Planned_Visits__c = 100;
        c.Planned_Bookings__c = 10;
        c.Campaign_Type__c = 'TV Plan';
        c.Media__c = 'TV';
        insert c;
        resultMap.put('Campaign', c.Id);
        
        Campaign__c c1 = new Campaign__c();
        c1.RecordTypeId = Schema.SObjectType.Campaign__c.getRecordTypeInfosByName().get('Print Plan').getRecordTypeId();
        c1.Name = 'Test Campaign1';
        c1.Marketing_Brief__c = Mb.Id;
        c1.Project__c = p.Id;
        c1.StartDate__c = system.today();
        c1.EndDate__c = system.today().addDays(15);
        c1.Status__c = 'Planning';
        c1.Performance_Measure_On__c = 'Daily';
        c1.Campaign_Code__c = 'Test Campaign1';
        c1.Planned_Cost__c = 10000;
        c1.Planned_Leads__c = 1000;
        c1.Planned_Visits__c = 100;
        c1.Planned_Bookings__c = 10;
        c1.Campaign_Type__c = 'TV Plan';
        c1.Media__c = 'Print';
        insert c1;
        resultMap.put('Campaign 1', c1.Id);
        
        return resultMap;
    }
    
    @isTest
    public static void campaignApproval() {
        Map<String, String> resultMap = createCampaign();
        
        Marketing_Brief__c mb = [Select Id, Name, Send_for_Approval__c from Marketing_Brief__c where Id =: resultMap.get('Marketing Brief')];
        mb.Send_for_Approval__c = true;
        update mb;
        
        List<Ex_ApprovalManagementServices.approvalWrapper> wrappertotalList = Ex_ApprovalManagementServices.getApprovalList(0, 0, 'Total');
        List<Ex_ApprovalManagementServices.approvalWrapper> wrapperList = Ex_ApprovalManagementServices.getApprovalList(10, 0, '');
        List<Id> approveProcessId = new List<Id>();
        approveProcessId.add(wrapperList[0].workItemId);
        Boolean result = Ex_ApprovalManagementServices.approveCampaign(approveProcessId);
        system.assertEquals(true, result);
        
        List<Id> rejectProcessId = new List<Id>();
        rejectProcessId.add(wrapperList[1].workItemId);
        Boolean result1 = Ex_ApprovalManagementServices.rejectCampaign(rejectProcessId);
        system.assertEquals(true, result1);
    }
}
@isTest
public class Test_luxuryCustomerCont1 {
  @isTest
    public static void TestluxuryCustomer(){
        Map<String,Id> dataMap = TestDataFactory1.createData();
        Id projectId = dataMap.get('PROJECT');
        Project__c p = new Project__c();
        p.id = projectId;
        p.RecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Luxury').getRecordTypeId();
        p.name = 'Luxury';
        update p;
        lead l = new lead();
        
        
        Test.StartTest();
        PageReference pageRef2 = Page.luxuryCustomerform;
        Test.setCurrentPage(pageRef2);
        luxuryCustomerCont1 lcc = new luxuryCustomerCont1();
        lcc.sob1 = 'Direct';
        lcc.Salutation = 'Mr.';
        lcc.req = '4 BR';
        lcc.budget1 = '60 - 70 Cr';
        lcc.lastname = 'ABC';
        lcc.Property = 'Bungalow';
        lcc.l.FirstName = 'ABC';
        lcc.l.Residence_Location__c = 'pune';
        lcc.l.Company_Custom__c = 'stetig';
        lcc.Industry = 'Automobiles';
        lcc.indusifother = 'Tech Support';
        lcc.l.Designation__c = 'Dev';
        lcc.budget1 = '60 - 70 Cr';
        lcc.l.Preferred_Date__c = system.today();
        lcc.l.Company_Address__c = 'pune';
        lcc.yesno = 'No';
        //lcc.l.Hours__c = '10';
        //lcc.l.Minutes__c='10';
        lcc.restype = 'Rented';
        lcc.getResidencelist();        
        lcc.getSourcelist();
        lcc.l.Project__c = p.id;
        lcc.getBudgetlist();
        lcc.getSalutationlist();
        lcc.getPropertylist();
        lcc.getIndustrylist();
        lcc.getHourslist();
        lcc.getMinuteslist();
        lcc.getAMPMlist();
        lcc.getyesnolist();
        lcc.getRequirementslist();
        lcc.save();
        lcc.NewDataSheetButton();
        Test.StopTest();
    }
}
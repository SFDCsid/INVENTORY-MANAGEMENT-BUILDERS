@isTest
public class TestLeadConversionAuraController {
	public static Project__c createProject(Integer i) {
        Project__c p = new Project__c();
        p.Name = 'Project '+i;
        insert p;
        return p;
    }
    
    public static Lead createLead(Id pId) {
        Lead l = new Lead();
        l.Salutation = 'Mr.';
        l.FirstName = 'Test';
        l.LastName = 'Customer';
        l.MobilePhone = '1122334455';
        l.Email = 'customer@test.in';
        l.Phone = '6677889900';
        l.Alternate_Email__c = 'test@customer.in';
        l.Project__c = pId;
        l.Master_Source__c = 'Reference';
        l.Lead_Source__c = 'Customers';
        l.Reference_Name__c = 'Test Customer 2';
        insert l;
        return l;
    }
    
    @isTest
    public static void leadConversion() {
        Project__c p1 = createProject(1);
        Lead l1 = createLead(p1.Id);
        LeadConversionAuraController.leadConversionWrapper lc = LeadConversionAuraController.convertSelectedLead(l1.Id);
        
    }
}
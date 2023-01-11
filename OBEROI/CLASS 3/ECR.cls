public class ECR {
    public ECR__c e{get;set;}
    public Id optyId{get;set;}
    
    public ECR(ApexPages.StandardController controller){
        e = (ECR__c)controller.getRecord();
        if(ApexPages.currentPage().getParameters().get('optyid') != null &&
           ApexPages.currentPage().getParameters().get('optyid') != '') {
            e.Opportunity__c = ApexPages.currentPage().getParameters().get('optyid');
        }
    } 
    
    public List<SelectOption> getdynamiclist() {
        List<EOI__c> proList = [SELECT Id,Name FROM EOI__c];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Select an EOI','Select an EOI'));
        for(EOI__c pro:proList){
            options.add(new SelectOption(pro.id,pro.Name));    
        }
        return options;
    }
    
    public void updateEoi(){
    }
}
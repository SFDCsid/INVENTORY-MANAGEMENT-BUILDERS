public class CustomBillingPlan {

    public CustomBillingPlan() {

    }


    public Payment_Plan__c currentRecord{get; set;}
    public string recordId{get; set;}
    public boolean isScheme{get; set;}
    public boolean isCustom{get; set;}
    public boolean isSchemeJodi{get; set;}
    public boolean isCustomJodi{get; set;}
    public CustomBillingPlan(ApexPages.StandardController controller) {
        isScheme = false; isCustom = false; isSchemeJodi = false; isCustomJodi = false;
        currentRecord = [SELECT Id,Related_Jodi_Billing_Plan__c,RecordType.DeveloperName FROM Payment_Plan__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        if(currentRecord.RecordType.DeveloperName == 'Customize_Billing_Plan' 
        && String.isBlank(currentRecord.Related_Jodi_Billing_Plan__c)){
        isCustom = true;}
        if(currentRecord.RecordType.DeveloperName == 'Customize_Billing_Plan' 
        && !String.isBlank(currentRecord.Related_Jodi_Billing_Plan__c)){
        isCustomJodi = true;}
        if(currentRecord.RecordType.DeveloperName== 'Scheme_Billing_Plan'
        && String.isBlank(currentRecord.Related_Jodi_Billing_Plan__c)){
        isScheme = true;}
        if(currentRecord.RecordType.DeveloperName== 'Scheme_Billing_Plan'
        && !String.isBlank(currentRecord.Related_Jodi_Billing_Plan__c)){
        isSchemeJodi = true;}
       recordId = currentRecord.Id; 
    }
    public PageReference saveAttach( )
    {
        Id opId = apexpages.currentpage().getparameters().get('Id');
        PageReference pdfPage = new PageReference('/apex/ViewBillingPlan?id='+opId);        
        blob pg = (!Test.isRunningTest()) ? pdfPage.getContentAsPDF() : Blob.valueOf('testbody');
        DateTime d = system.NOW();
        system.debug('pg'+pg);
        Attachment attach1= new Attachment();
        attach1.ParentId = opId;
        attach1.Name = 'BillingPlan.pdf';
        attach1.Body=pg;
        attach1.contentType = 'application/pdf';
        insert attach1;
        Payment_Plan__c bp = [select id,PDF_Generated__c from Payment_Plan__c where id =: opId];
        bp.PDF_Generated__c = true;
        update bp;
        return pdfPage;
    }
}
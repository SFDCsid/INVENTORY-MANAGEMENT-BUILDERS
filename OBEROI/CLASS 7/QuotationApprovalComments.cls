public class QuotationApprovalComments {

    public ID QuotationId { get; set{
            QuotationId = value;
            if(QuotationId != null)
                createQuotationList();
                
        }
        }
    
    public List<Quotation__c> QuotationObj {get;set;}
    public string Link {get;set;}
    
     public String comments {
        get {
            if ( comments == null ) {
                ProcessInstanceStep lastStep = getLastApprovalStep();
                comments = ( lastStep != null ) ? lastStep.comments : '';
            }
            return comments;
        }
        private set;
    }
    
    
    public void createQuotationList(){
        Link=Url.getSalesforceBaseUrl().toExternalForm()+'/'+QuotationId;
        QuotationObj = [Select id,Name,Approved_by__c,Project__r.Name,Opportunity__r.Name,CreatedBy.Name,Property__r.House_Unit_No__c from
                        Quotation__c where id =: QuotationId];
    }
     public ProcessInstanceStep getLastApprovalStep() {
        List<ProcessInstanceStep> steps = new List<ProcessInstanceStep>([
            SELECT
                Comments
            FROM
                ProcessInstanceStep
            WHERE
                ProcessInstance.targetObjectId = : QuotationId 
            ORDER BY
                SystemModStamp DESC
            LIMIT
                1
        ]);
        return ( steps.size() > 0 ) ? steps[0] : null;
    }
}
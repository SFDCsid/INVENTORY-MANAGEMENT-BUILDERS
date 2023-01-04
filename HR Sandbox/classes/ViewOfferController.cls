public class ViewOfferController {
    public Id offerId{get;set;}
    public List<Offer__c> offerList{get;set;}
    public String inttext{get;set;}
 
    public ViewOfferController(){
        offerId = null;
        inttext = '';
        offerList = new List<Offer__c>();
        offerId = ApexPages.currentPage().getParameters().get('Id');
        
        if(offerId!=null){
            offerList = [SELECT Id,Name,Candidate_Name__c,Application__r.Name,Application__r.Position__r.Name,Package_Amount_LPA__c,Approval_Date__c,Valid_By_Date__c FROM Offer__c WHERE Id=:offerId];
            NumberTOWordConvertion nwcObj = new NumberTOWordConvertion();
            inttext = nwcObj.getNumberTOWordConvertion(offerlist[0].Package_Amount_LPA__c);
         }
        
    }    
}
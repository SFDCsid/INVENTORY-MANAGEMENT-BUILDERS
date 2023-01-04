public class OfferAcceptanceController {
    
    public List<Offer__c> offerlist{get;set;}
    public Id offerId{get;set;}
    public boolean showform {get;set;}
    public List<Offer__c> newList {get;set;}
    public boolean terms{get;set;}
    public String numInWords{get;set;}
    public OfferAcceptanceController(){
      
        offerId=null;
        terms = false;
        showform = true;
        numInWords = '';
        offerlist = new List<offer__c>();
        offerId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('Id='+offerId);
        
        if(offerId!=null){
            offerlist=[select id,Name,Offer_Status__c,Candidate_Name__c,Candidate__c,Application__r.Name,Application__r.Position__r.Name,Package_Amount_LPA__c,Valid_For_No_Of_Days__c,Valid_By_Date__c,Application__r.Candidate__c,Offer_Acceptance_Date__c from offer__c where Id=:offerId];
            if(!offerlist.isEmpty()){
                NumberTOWordConvertion nwcObj = new NumberTOWordConvertion();
                numInWords = nwcObj.getNumberTOWordConvertion(offerlist[0].Package_Amount_LPA__c);
                if(offerlist[0].Valid_By_Date__c<system.now()){
                   showform = false;
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'This offer is Expired.'));
                }else{
                   
                if(offerlist[0].Offer_Status__c=='Offer Accepted'){
                   showform = false;
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'This offer is already accepted.'));  
                } 
                if(offerlist[0].Offer_Status__c=='Offer Rejected'){
                   showform = false;
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'This offer is already rejected.'));  
                } 
                    
                }
            }
        }    
    }
    
    public void Accepted(){ 
        
        try{
             offerlist[0].Offer_Status__c='Offer Accepted';
             offerlist[0].Offer_Acceptance_Date__c = system.now(); //acceptance date
             update offerlist;
             showform = false;
             system.debug('Offer Accepted');  
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Thank you for accepting offer! You will receive your onboarding email soon..'));
        }catch(Exception e){
          system.debug('Exception='+e);  
        }
   
    }
    public void Rejected(){ 
        
          try{
           offerlist[0].Offer_Status__c='Offer Rejected';
           offerlist[0].Offer_Acceptance_Date__c = system.now(); //rejection date
           update offerlist;
           showform = false;        
           system.debug('Offer Rejected');  
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Thank you for your response!'));
        }catch(Exception e){
          system.debug('Exception='+e);  
        }
    }          

}
public class CustomerSurveyController {
    
    Public Id SVid {get;set;}
    //Public Site_Visit__c sv {get;set;}
    public String isError{get;set;}
    public String successMessage{get;set;}
    
    Public String feedbackText {get;set;}
    Public String overAllExpValue {get;set;}
    Public String locationValue {get;set;}
    Public String amenitiesValue {get;set;}
    Public String priceValue {get;set;}
    Public String developmentVal {get;set;}
    Public String possTimeValue {get;set;}
    Public String hospitalityValue {get;set;}
    Public String salesExpValue {get;set;}
    Public String CustomerRemarks {get;set;}
    Public String recommendValue {get;set;}
    public list < Site_Visit__c > sv {get;set;}
    
    Public Customer_Feedback__c cf {get;set;} 
    
    public List<SelectOption> getRevisit(){
        Schema.sObjectType sobject_type = Customer_Feedback__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Planning_Revisit__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    
    public CustomerSurveyController(){
        
        SVid = ApexPages.currentPage().getParameters().get('SVid');
        cf = new Customer_Feedback__c();
        sv = new list <Site_Visit__c>();
        sv = [SELECT Id,Name,Site_Visit__c.Opportunity__r.name,Site_Visit__c.Opportunity__r.owner.name
              FROM Site_Visit__c WHERE Id=:SVid]; 
        
    }
    
    
    
    public PageReference submit() {
        try{ 
            if(sv.size() >0 ){ 
                
                cf.Site_Visit__c = sv[0].id;
                cf.Opportunity__c = sv[0].Opportunity__c;
                cf.Overall_Experience__c = overAllExpValue;            
                //cf.Location__c = locationValue;
                //cf.Amenities_Facilities__c = amenitiesValue;
                //cf.Price__c = priceValue;
                //cf.Possession_Timelines__c = possTimeValue;
                //cf.Overall_Development__c = developmentVal;
                //cf.Hospitality__c = hospitalityValue;
                cf.Sales_Experience__c = salesExpValue;
                cf.Recommendation__c = recommendValue; 
                
                //cf.Your_valuable_suggestions_feedback__c = CustomerRemarks;
                insert cf;
                //sv[0].Is_Customer_Feedback_Given__c = true;
                update sv;
                Pagereference objReference = new Pagereference('/'+cf.id);
                objReference.setRedirect(true);
                return objReference;
                
            }
        }catch(exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Something went wrong '+e);
            ApexPages.addMessage(myMsg);
            System.debug('Exception e '+e);
            System.debug('Exception e '+e.getLineNumber());
            return null;
        }
        return null;        
    }
}
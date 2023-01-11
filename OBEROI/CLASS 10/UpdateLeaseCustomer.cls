public class UpdateLeaseCustomer{
    public string OppId{get;set;}
    public boolean status {get;set;}
    public account a{get;set;}
    list<opportunity> lstoppty = new list<opportunity>();
    public List <Channel_Partner_Project__c > CPProjetList {get;set;}
    
    public UpdateLeaseCustomer(){
        
        OppId = ApexPages.currentPage().getParameters().get('id');
        if(OppId != null)
        {
            //////////////////Ankur : Commenting out this line and added the next one to fetch an extra field on 18.11.2015 19:36 hrs//////////////////////////////////
            lstoppty = [Select id, Leasing_Project__c,name,Broker_Account__c,Account_Group1__c,Customer_Number__c,Company_Code1__c,Business_Entity_Number1__c,Title_Mr_Company__c,Cust_Name_1__c,Cust_Name_2__c,Cust_Name_3__c,Cust_Name_4__c,Cust_Name_5__c,Number_of_Rental_Object1__c,
                        Brand__c,Str_Suppl1__c,Str_Suppl2__c,Str_Suppl3__c,House_No__c,Building_Soc_House__c,Location_2__c,City__c,Region1__c,PAN_Number__c,PAN_Reference__c,GST__c,Reconciliation_Account__c,
                        Message_Type__c,Message__c,Mobile_Number_1__c,Email_Address_1__c,Mobile_Number_2__c,Email_Address_2__c,Mobile_Number_3__c,Email_Address_3__c,Mobile_Number_4__c,Email_Address_4__c,Mobile_Number_5__c,
                        Email_Address_5__c, Source_of_Walk_in_Booking__c from Opportunity where Id =: OppId];
            if(lstoppty[0].Broker_Account__c != null){
                a= [select id, broker_code__c from Account where id = : lstoppty[0].Broker_Account__c ];}
        }
        //flow(OppId);
    }
    Public void flow(){        //(string oppid1){
        // System.debug('Inside flow method'+a.id);
        TRY{
            if(lstoppty.size() > 0){
                if(lstoppty[0].Customer_Number__c != null){
                    Rest_Update_Leasing_customer ULC = new Rest_Update_Leasing_customer();
                    ULC.UpdateLCust(OppId);  
                }else{
                    system.debug('Custoner Code for this booking is blank.');
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Custoner Code for this opportunity is blank.'));
                
                }  
            }
           
        }CATCH(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, ' ' + e.getMessage()));
            System.debug('Your exception message here....'+e.getMessage());
        }
        
    }
    
    public PageReference incrementCounter() 
    {       
        if(OppId!= '')
        {
            pageReference P = new pageReference('/'+ OppId);
            return P;
        }
        return null;
    }
    public PageReference BackToBooking(){
        pageReference P = new pageReference('/'+ OppId);
        return P;
    }
}
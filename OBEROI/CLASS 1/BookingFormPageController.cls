public with sharing class BookingFormPageController{
    
    public  Booking__c bookingObj{get;set;}
    public  String bookdate{get;set;}
    public  String booingkdate{get;set;}
    public Co_Owner__c coownerObj {get;set;}
    public list<Billing_Plan_Line_Item__c> billingLineItems {get;set;}
    public String billingSubLineItemsHead {get;set;}
    public String billingSubLineItemsChild {get;set;}
    public Decimal TimeLinkedAmount{get;set;}
    public Boolean checkResidential{get;set;}
    public Boolean checkResidentialNRI{get;set;}
    //  public PageReference rtn;
    // public Boolean closeWindow {get;set;}
    public BookingFormPageController(ApexPages.StandardController controller){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Record successfully updated'));
        list<Billing_Plan_Sub_Line_Item__c> billingSubLineItems  = new list<Billing_Plan_Sub_Line_Item__c>();
        map<Id,List<Billing_Plan_Sub_Line_Item__c>> mapBpliToSubLi = new map<Id,List<Billing_Plan_Sub_Line_Item__c>>();
        Decimal totalAmount =  0.0;
        Integer TimeLinkedCount =0;
        bookingObj = new Booking__c();
        Decimal percSum = 0;
        bookingObj = [select Primary_Applicant__r.Nationality__c,Billing_Plan__r.Total_Sales_Amount__c,Billing_Plan__r.Total_Sales_Amount_Time_of_Booking__c,
                      Primary_Applicant__r.Residential_Status__c,Booking_Date__c,Booking_Amount__c,Broker_Company__c,Broker_Name__c, 
                      Primary_Applicant__r.name,Primary_Applicant__r.Billing_Street_2__c,Primary_Applicant__r.Billing_Street_3__c,
                      Primary_Applicant__r.Billing_Street_1__c,Primary_Applicant__r.Billing_House_No__c,Primary_Applicant__r.Contact_Person_Name__c,
                      Primary_Applicant__r.Billing_Pincode__c,Primary_Applicant__r.Billing_City__c,Primary_Applicant__r.Occupation__c,Primary_Applicant__r.Contact_Person_Relation_Designation__c,
                      Primary_Applicant__r.Company__c,Primary_Applicant__r.Company_Address__c,Primary_Applicant__r.Company_city__c,Primary_Applicant__r.Contact_Person_Email__c,
                      Primary_Applicant__r.Company_Pincode__c,Primary_Applicant__r.Phone,Primary_Applicant__r.Residence_Phone_Number__c,
                      Primary_Applicant__r.Telephone__c,Primary_Applicant__r.Email,Primary_Applicant__r.Designation__c, Property__r.Project_Name__c ,
                      Floor__r.Floor_Number__c, Tower__r.Tower_Name__c , Property__r.Net_Sales_Price__c,Booking_Flat_No__c ,
                      Project__r.MahaRERA_Registration_No__c  , Project__r.Registration_Vendor_Contact_Details__c , Project__r.Organization_Phone__c , 
                      Project__r.Subsidiary_Company_Name__c , Project__r.Company_Email__c, Project__r.Sales_Head__r.name,Booking__c.Billing_Plan__c,
                      Opportunity__r.Partner_s_Firm_Name__c,Opportunity__r.Partner_s_Name__c,Opportunity__r.Partner_Email__c,Opportunity__r.Partner_Mobile__c,
                      Property__r.Project_Name__r.Name,Property__r.Unit_Type__c
                      FROM Booking__c where id =:  ApexPages.currentPage().getParameters().get('Id')];
        
        DateTime dT = system.now();
        //bookdate = date.newinstance(dT.year(), dT.month(), dT.day());
        bookdate = dt.format('MM/dd/yyyy');
        
        if(bookingObj.Primary_Applicant__r.Residential_Status__c == 'Resident Citizen')
            checkResidential = true;
        
        else
            checkResidentialNRI = false;
        
        if(bookingObj != null){
            if(bookingObj.Booking_Date__c != null){
                DateTime dt1 = bookingObj.Booking_Date__c;  
                booingkdate = dt1.format('MM/dd/yyyy');
            }
            
            List<Co_Owner__c> coownerInstance  = [Select Bank_Confirmation_Letter__c    ,Board_Resolution__c    ,Booking__c ,Cert_of_Incorporation__c, Company_PAN__c   ,Contact__c ,HUF_PAN__c ,Latest_ITR_optional__c ,List_of_Designated_Partners__c ,List_of_Directors__c   ,List_of_HUF_Members__c ,List_of_Partners__c    ,List_of_Trustees__c    ,LLP_Agreement__c   ,LLP_PAN__c ,M_O_A_A_O_A__c ,NRI_Declaration__c ,OCI_PIO_Card__c    ,Opportunity__c ,PAN__c ,PAN_Card__c    ,Passport_Election_ID__c    ,Person_Account__c  ,Proprietorship_PAN__c  ,Registered_Partnership_Deed__c ,Registered_Trust_Deed__c   ,Resolution__c  
                                                  From Co_Owner__c where  Booking__c  =: bookingObj.id limit 1];
            
            
            if(coownerInstance.size()>0)
                coownerObj = coownerInstance[0];
            
            if(bookingObj.Billing_Plan__c != null){
                billingLineItems = [SELECT Name, Payment_Plan_Line_Item_Name__c,Milestone_Number__c,Payment_Group__c ,
                                    Discount_Amount__c,Amount__c,Terms_of_Payment_Key__c,Percentage__c,
                                    Percentage_Of_Value_To_Be_Invoiced__c 
                                    FROM Billing_Plan_Line_Item__c 
                                    WHERE Payment_Plan__c =: bookingObj.Billing_Plan__c order by  Order__c ASC];
                system.debug('billingLineItems============='+billingLineItems);
                
                for(Billing_Plan_Sub_Line_Item__c bpsli : [SELECT Name,Billing_Plan_Sub_Line_Item_Name__c,Milestone_Number__c,Billing_Plan_Line_Item__c,Amount_Percent_BSP__c,Terms_of_Payment_Key__c,Percentage_Of_Value_To_Be_Invoiced__c 
                                                           FROM Billing_Plan_Sub_Line_Item__c
                                                           WHERE Billing_Plan_Line_Item__r.Payment_Plan__c =: bookingObj.Billing_Plan__c ]){
                                                               if(mapBpliToSubLi.containsKey(bpsli.Billing_Plan_Line_Item__c)){
                                                                   mapBpliToSubLi.get(bpsli.Billing_Plan_Line_Item__c).add(bpsli);
                                                               } else{
                                                                   mapBpliToSubLi.put(bpsli.Billing_Plan_Line_Item__c, new List<Billing_Plan_Sub_Line_Item__c>{bpsli});
                                        
                                                               }
                                                           }
                
                for(Billing_Plan_Line_Item__c bpli: billingLineItems){
                    // To Update   if(bpli.Payment_Group__c=='IN' && bpli.Milestone_Number__c==0){
                    if(bpli.Payment_Group__c=='IN'){
                        billingSubLineItems = mapBpliToSubLi.get(bpli.Id); 
                    }                  
                }     
                
                for(Billing_Plan_Sub_Line_Item__c bpsliObj : billingSubLineItems){
                    percSum = percSum+Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c);
                    if(bpsliObj.Milestone_Number__c=='0'){
                        TimeLinkedCount= TimeLinkedCount+1;
                    }
                }
                //   system.debug('Amount---'+bookingObj.Billing_Plan__r.Total_Sales_Amount__c);
                //   TimeLinkedAmount = (percSum * bookingObj.Billing_Plan__r.Total_Sales_Amount__c) / 100;
                system.debug('Amount---'+bookingObj.Billing_Plan__r.Total_Sales_Amount_Time_of_Booking__c);
                TimeLinkedAmount = (percSum * bookingObj.Billing_Plan__r.Total_Sales_Amount_Time_of_Booking__c) / 100;
                billingSubLineItemsHead = 'Proportionate '+ billingSubLineItems.Size() +' installments upon casting of relevant slabs. Out of which '+ TimeLinkedCount +
                    ' relevent slabs have been casted and the amount of Rs.' + TimeLinkedAmount +' towards the Sale Price is payable as below.';
                billingSubLineItemsChild ='To be paid on or before 11/3/2019 along with any further milestones raised till then' ;         
            } 
        }
        // closeWindow = true;
        // attachPDF();
    }  
    public PageReference attachPDF() {
        
        List<Attachment> listExistingAttachment = [SELECT Id FROM Attachment WHERE parentId =: bookingObj.Id];
        if(listExistingAttachment.size()>0 && !listExistingAttachment.isEmpty()){
            delete listExistingAttachment ;
        }
        
        //generate and attach the PDF document
        PageReference pdfPage = Page.BookingFormAttach;
        pdfPage .getParameters().put('id',bookingObj.Id);
        Blob pdfBlob; 
        if(Test.isRunningTest()){
            pdfBlob = blob.valueOf('Test Attach PDF');
        }   
        else{
            pdfBlob = pdfPage.getContentasPDF();
        }
        Attachment attach = new Attachment(parentId = bookingObj.Id, Name = 'BookingForm.pdf', body = pdfBlob); 
        insert attach; 
        PageReference pageRef = New PageReference('/lightning/r/Booking__c/' +bookingObj.Id+ '/view');
        pageRef.setRedirect(true);
        return pageRef; 
    }
}

/*
Please find the objects for Booking form,

CUSTOMER/S DETAILS (TO BE FILLED IN BLOCK LETTERS) : Booking ->Primary Applicant
BOOKING DETAILS : Booking ->Primary Applicant
PROPERTY CONSULTANT DETAILS : from Booking-> Property->project
Booking Details : Booking
PAYMENT DETAILS  : BANK
KYC Details : Co-owner object
Acknowledgement : Booking- contact

PAYMENT DETAILS  : BANK -- Not able to Find Bank Object. - its record type of Account
PROPERTY CONSULTANT DETAILS :  from Booking-> Property->project  -- Not able to find Consultant details in Project --from Booking-> Property(related obj of Booking)->project(Lookup).*/
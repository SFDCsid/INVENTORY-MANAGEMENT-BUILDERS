public class BCEController {
    
    public id bookingId {get;set;}
    public Booking__c booking ;
    public Booking__c Jodibooking ;
    //public List<Billing_Plan_Line_Item__c> billingLineItems ;
    public Decimal inPercent {get;set;}
    public Decimal inAmount {get;set;}
    public boolean brokerrere {get;set;}
    public boolean brokerpan {get;set;}
    public boolean schemeBp{get;set;}
    public list<Co_Owner__c> Coowners{get;set;}
    //public list<Payment__c> payList {get;set;}
   
    public Booking__c getbooking(){
        booking = new Booking__c();
       
            system.debug('bookingId'+bookingId);        
        booking = [SELECT Project__c,Contact_Name__c,email__C,Fax_Number__c,Related_Jodi_Booking__c,Tandem_Car_Parking__c,Triple_Car_Parking__c,Billing_Plan__r.Total_Sales_Amount_At_Time_of_Booking__c,
                       mobile__C,Property__r.tower__r.Completion_Certificate_Date__c,Primary_Applicants__r.Customer_Classification__pc,property__r.House_Unit_No__c,RM_Name__c,
                       Tower_Name__c,Initial_Booking_Amount_Realised__c,Booking_Flat_No__c,Tower__r.Tower_Name__c,Tower__c,Basic_Cost__c,PLC_Cost__c,Project__r.Default_Car_Parking_Configuration__c,Project__r.Default_Car_Parking__c,RM_User__r.firstname,Contact_Email__c,Booking_Number_SAP__c,Opportunity__r.Opportunity_Number__c,Loan_Required__c,
                       Primary_Applicant__r.name, Primary_Applicant__r.AccountId,Property__r.Floor__r.Floor_Number__c, Primary_Applicant__r.PAN__c,Project__r.NAme,Property__r.Property_Type__c,Property__r.Project_Name__r.Registration_A_C_Name__c,Property__r.Project_Name__r.MahaRERA_Registration_No__c,Property__r.Project_Name__r.Expected_End_Date__c,Property__r.Project_Name__r.Project_Name__c,Booking_Through__c,Property_Consultant_s_Account_Name__c,RERA_Registration_No__c,
                       Primary_Applicant__r.Billing_Pincode__c,Billing_Plan__r.Total_Sales_Amount_Time_of_Booking__c,Primary_Applicant__r.Billing_City__c,Single_Car_Parking__c,Primary_Applicant__r.Billing_Street_1__c,Property__r.Floor__r.name,Project_Name__c,Total_Sales_Cost__c,property__r.Sale_Price_of_Balcony_Carpet_Area__c,property__r.Sale_Price_of_RERA_Carpet_Area__c,property__r.Net_Sales_Price__c,property__r.project_name__r.Subsidiary_Company_Name__c,property__r.project_name__r.Subsidiary_Company_Address__c,
                       Booking_Form_and_Mandatory_Documents__c,Pending_Documents_Remarks__c,
                       Brief_Information__c,Broker_PAN__c,Sales_Document_SAP__c,
                       Primary_Applicant__r.Billing_Street_2__c,property__r.tower__r.tower_name__C,property__r.project_name__r.Project_Area_Sq_ft__c,property__r.project_name__r.Street__c,property__r.project_name__r.city__c,property__r.project_name__r.location__c,property__r.project_name__r.State_Province__c,property__r.project_name__r.Country__c,Booking_Date__c,Primary_Applicant__r.Billing_House_No__c,Primary_Applicant__r.Billing_Street_3__c,Billing_Plan__c ,Primary_Applicant__r.MailingCountry , Contact__r.PAN__c ,Property__r.Carpet_Area_Sq_Mtr__c, Property__r.Carpet_Area__c 
                       FROM Booking__c WHERE Id=:bookingId];
            system.debug('Booking'+booking);
        Id SchemeBillingRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan').getRecordTypeId();
        Id NonSchemeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
        if(booking.billing_plan__r.recordtypeid == SchemeBillingRecordTypeId || 
        booking.billing_plan__r.recordtypeid == NonSchemeRecordTypeId){
            schemeBp = true;
        }
        brokerrere = false;
        brokerpan = false;
        Coowners = [select PAN__c,Contact_name__c,name,Account_Email__c from Co_Owner__c where Booking__c = :booking.Id];
        if(booking.RERA_Registration_No__c != null){
            brokerrere = true;
        }
        if(booking.Broker_PAN__c != null){
            brokerpan = true;
        }
            
        return booking;
    }
    /*
    public List<Billing_Plan_Line_Item__c> getbillingLineItems(){
        getbooking();
        system.debug('getbillingLineItems'+booking.Billing_Plan__c);
        List<Billing_Plan_Line_Item__c> billingLineItems = [SELECT Name, Payment_Plan_Line_Item_Name__c,Milestone_Number__c,Line_Item_Type__c,Payment_Group__c ,
                                Discount_Amount__c,Amount__c,Terms_of_Payment_Key__c,Percentage__c,Due_After_Days__c,description__c,
                                Percentage_Of_Value_To_Be_Invoiced__c 
                                FROM Billing_Plan_Line_Item__c 
                                WHERE Payment_Plan__c =: booking.Billing_Plan__c order by  Order__c ASC];
        system.debug('billingLineItems'+billingLineItems);
        inPercent = 0;
            inAmount = 0;
            for(Billing_Plan_Line_Item__c bpli : [select Percentage_Of_Value_To_Be_Invoiced__c,Discount_Amount__c 
            from Billing_Plan_Line_Item__c WHERE Payment_Plan__c =: booking.Billing_Plan__c
            AND Payment_Group__c ='IN']){
                inAmount = inAmount + bpli.Discount_Amount__c;
                inPercent = inPercent + Decimal.valueOf(bpli.Percentage_Of_Value_To_Be_Invoiced__c);
            }
            
        return billingLineItems;
    }*/
    public List<Billing_Plan_Line_Item__c> getbillingLineItems(){
        getbooking();
        List<Billing_Plan_Line_Item__c> billingLineItems = [SELECT Name, Payment_Plan_Line_Item_Name__c,Milestone_Number__c,Line_Item_Type__c,Payment_Group__c ,
                                Discount_Amount__c,Amount__c,Terms_of_Payment_Key__c,Percentage__c,Due_After_Days__c,description__c,
                                Percentage_Of_Value_To_Be_Invoiced__c 
                                FROM Billing_Plan_Line_Item__c 
                                WHERE Payment_Plan__c =: booking.Billing_Plan__c order by  Order__c ASC];
        system.debug('billingLineItems============='+billingLineItems);
            
        return billingLineItems;
    }
    public List<Billing_Plan_Line_Item__c> getbillinglineItemTimeLinked(){
        getbooking();
        List<Billing_Plan_Line_Item__c> billinglineItemTimeLinked =[SELECT Name, Payment_Plan_Line_Item_Name__c,Line_Item_Type__c,Milestone_Number__c,Payment_Group__c ,
                                Discount_Amount__c,Amount__c,Terms_of_Payment_Key__c,Percentage__c,Due_After_Days__c,description__c,
                                Percentage_Of_Value_To_Be_Invoiced__c 
                                FROM Billing_Plan_Line_Item__c 
                                WHERE Payment_Plan__c =: booking.Billing_Plan__c 
                                AND Line_Item_Type__c='Time Linked'
                                AND Payment_Group__c ='IN'
                                order by  Sequence_Number__c ASC];
             Integer CountTimeLinked = billinglineItemTimeLinked.size();  
              system.debug('I@@CountTimeLinked -->'+CountTimeLinked );
             Integer i= 0;
            
            inPercent = 0;
            inAmount = 0;
            for(Billing_Plan_Line_Item__c bpli : [select Percentage_Of_Value_To_Be_Invoiced__c,Discount_Amount__c 
            from Billing_Plan_Line_Item__c WHERE Payment_Plan__c =: booking.Billing_Plan__c
            AND Payment_Group__c ='IN']){
                inAmount = inAmount + bpli.Discount_Amount__c;
                inPercent = inPercent + Decimal.valueOf(bpli.Percentage_Of_Value_To_Be_Invoiced__c);
            }
            system.debug('inAmountinAmount'+inAmount);
            system.debug('inPercentinPercent'+inPercent);
              for(i=0; i<CountTimeLinked ; i++){
              system.debug('I@@i-->'+i);
                 if(i==CountTimeLinked-1){
                 system.debug('In');
                 system.debug('@@Date-->'+booking.Booking_Date__c);
                 system.debug('@@Date-->'+Integer.valueOf(billinglineItemTimeLinked[i].Due_After_Days__c));
                 system.debug('@@Date-->'+booking.Booking_Date__c.adddays(Integer.valueOf(billinglineItemTimeLinked[i].Due_After_Days__c)));
                  dateTime timeBookingDate = booking.Booking_Date__c.adddays(Integer.valueOf(billinglineItemTimeLinked[i].Due_After_Days__c)-1);
                 String timeBookingDateFormat = timeBookingDate.format('MM/dd/yyyy');
                 billinglineItemTimeLinked[i].Payment_Plan_Line_Item_Name__c= 'To be paid on or Before '+ timeBookingDateFormat + ' along with any further milestones raised till then';
                 billinglineItemTimeLinked[i].Description__c= 'To be paid on or Before '+ timeBookingDateFormat + ' along with any further milestones raised till then';
                 
                 system.debug('@@billinglineItemTimeLinked[i].Payment_Plan_Line_Item_Name__c-->'+billinglineItemTimeLinked[i].Payment_Plan_Line_Item_Name__c);
                 }
             }
            system.debug('@@billinglineItemTimeLinked----->'+billinglineItemTimeLinked);
        return billinglineItemTimeLinked;
    }
    public Payment__c getpayment(){
        getbooking();
        Payment__c payt = new Payment__c();
        payt.Amount__c = 0;
        List<Payment__c> Payment = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                                            SystemModstamp, Booking__c, Amount__c, Amount_Type__c, Payment_Date__c, Payment_Mode__c, 
                                                            RTGS_Cheque_Draft_No__c, Bank_Account__c, Instrument_Date__c, 
                                                            Bank_Name__c, Variable_Narration__c, Final_Narration__c, Bank_Address__c FROM Payment__c 
                                                            WHERE Booking__c =: booking.id order by CreatedDate DESC];
        for(Payment__c pt : Payment){
            payt.Amount__c = payt.Amount__c + pt.Amount__c;
        }
        return payt;
    }
    public string getAmountinwords(){
        getbooking();
        Payment__c payt = new Payment__c();
        payt.Amount__c = 0;
        List<Payment__c> Payment = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                                            SystemModstamp, Booking__c, Amount__c, Amount_Type__c, Payment_Date__c, Payment_Mode__c, 
                                                            RTGS_Cheque_Draft_No__c, Bank_Account__c, Instrument_Date__c, 
                                                            Bank_Name__c, Variable_Narration__c, Final_Narration__c, Bank_Address__c FROM Payment__c 
                                                            WHERE Booking__c =: booking.id order by CreatedDate DESC];
        for(Payment__c pt : Payment){
            payt.Amount__c = payt.Amount__c + pt.Amount__c;
        }
        String Amountinwords = Utility.changeToWords(string.valueOf(payt.Amount__c.intvalue()),true);
        return Amountinwords;
    }
    
    public Booking__c getJodibooking(){
        getbooking();
        
        booking__c jodiBooking = [SELECT Project__c,Contact_Name__c,email__C,Fax_Number__c,Tandem_Car_Parking__c,Triple_Car_Parking__c,Billing_Plan__r.Total_Sales_Amount_At_Time_of_Booking__c,
                       mobile__C,Property__r.tower__r.Completion_Certificate_Date__c,Primary_Applicants__r.Customer_Classification__pc,property__r.House_Unit_No__c,RM_Name__c,
                       Tower_Name__c,Initial_Booking_Amount_Realised__c,Booking_Flat_No__c,Tower__r.Tower_Name__c,Tower__c,Basic_Cost__c,PLC_Cost__c,Project__r.Default_Car_Parking_Configuration__c,Project__r.Default_Car_Parking__c,RM_User__r.firstname,Contact_Email__c,Booking_Number_SAP__c,Opportunity__r.Opportunity_Number__c,Loan_Required__c,
                       Primary_Applicant__r.name, Primary_Applicant__r.AccountId,Property__r.Floor__r.Floor_Number__c, Primary_Applicant__r.PAN__c,Project__r.NAme,Property__r.Property_Type__c,Property__r.Project_Name__r.Registration_A_C_Name__c,Property__r.Project_Name__r.MahaRERA_Registration_No__c,Property__r.Project_Name__r.Expected_End_Date__c,Property__r.Project_Name__r.Project_Name__c,Booking_Through__c,Property_Consultant_s_Account_Name__c,RERA_Registration_No__c,
                       Primary_Applicant__r.Billing_Pincode__c,Billing_Plan__r.Total_Sales_Amount_Time_of_Booking__c,Primary_Applicant__r.Billing_City__c,Single_Car_Parking__c,Primary_Applicant__r.Billing_Street_1__c,Property__r.Floor__r.name,Project_Name__c,Total_Sales_Cost__c,property__r.Sale_Price_of_Balcony_Carpet_Area__c,property__r.Sale_Price_of_RERA_Carpet_Area__c,property__r.Net_Sales_Price__c,property__r.project_name__r.Subsidiary_Company_Name__c,property__r.project_name__r.Subsidiary_Company_Address__c,
                       Primary_Applicant__r.Billing_Street_2__c,property__r.tower__r.tower_name__C,property__r.project_name__r.Project_Area_Sq_ft__c,property__r.project_name__r.Street__c,property__r.project_name__r.city__c,property__r.project_name__r.location__c,property__r.project_name__r.State_Province__c,property__r.project_name__r.Country__c,Booking_Date__c,Primary_Applicant__r.Billing_House_No__c,Primary_Applicant__r.Billing_Street_3__c,Billing_Plan__c ,Primary_Applicant__r.MailingCountry , Contact__r.PAN__c ,Property__r.Carpet_Area_Sq_Mtr__c, Property__r.Carpet_Area__c 
                       FROM Booking__c WHERE Id=:booking.Related_Jodi_Booking__c];
                                  
        return jodiBooking;
        
    }
    public Payment__c getJodipayment(){
        getJodibooking();
        List<Payment__c> Payment = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                                            SystemModstamp, Booking__c, Amount__c, Amount_Type__c, Payment_Date__c, Payment_Mode__c, 
                                                            RTGS_Cheque_Draft_No__c, Bank_Account__c, Instrument_Date__c, 
                                                            Bank_Name__c, Variable_Narration__c, Final_Narration__c, Bank_Address__c FROM Payment__c 
                                                            WHERE Booking__c =: booking.Related_Jodi_Booking__c order by CreatedDate DESC];
        return Payment[0];
    }
    public string getJodiAmountinwords(){
        getjodiBooking();
        List<Payment__c> Payment = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                                            SystemModstamp, Booking__c, Amount__c, Amount_Type__c, Payment_Date__c, Payment_Mode__c, 
                                                            RTGS_Cheque_Draft_No__c, Bank_Account__c, Instrument_Date__c, 
                                                            Bank_Name__c, Variable_Narration__c, Final_Narration__c, Bank_Address__c FROM Payment__c 
                                                            WHERE Booking__c =: booking.Related_Jodi_Booking__c order by CreatedDate DESC];
       String Amountinwords = Utility.changeToWords(string.valueOf(Payment[0].Amount__c.intvalue()),true);
        return Amountinwords;
    }
    public list<Payment__c> getpayList(){
        getbooking();
     //system.debug(bookingObj.id +'****');
        List<Payment__c> payList  = [Select Amount__c, Instrument_Date__c,name,Amount_Type__c,Bank_Account__c,Booking__c,Payment_Date__c,Payment_Mode__c,RTGS_Cheque_Draft_No__c, Bank_Account__r.name,Bank_Name__c
        From Payment__c WHERE Booking__c =: booking.id order by CreatedDate DESC];
        //system.debug(payList+'payList');
         return payList;
    }

}
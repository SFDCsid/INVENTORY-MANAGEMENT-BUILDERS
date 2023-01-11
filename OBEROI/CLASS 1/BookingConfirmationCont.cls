public with sharing class BookingConfirmationCont{
     public string BookingId {get;set;}
        /*get;
        set{
            BookingId = value;
            if(BookingId != null)
                createBookingList();
        }
    }*/
    public Booking__c bookingObj{get;set;}
    public List<Applicant__c> applicant1{get;set;}
    public List<Applicant__c> applicant2{get;set;}
    public List<Applicant__c> applicant3{get;set;}
    public List<Applicant__c> applicant4{get;set;}
    public List<Applicant__c> applicant5{get;set;}
    public List<Payment__c> payment{get;set;}
    public string  app1Name{get;set;}
    public string  app2Name{get;set;}
    public string  app3Name{get;set;}
    public string  app4Name{get;set;}
    public string  app5Name{get;set;}
    public string  city{get;set;}
    public string  chequeno{get;set;}
    public string  bankname{get;set;}
    public string  cheamount{get;set;}  
    public string  paymentdate{get;set;}
    public string  cheamountword{get;set;}
    public string  salesprice{get;set;}
    public string  bookingdate{get;set;}
    public string  partnersName{get;set;}
    public Integer totalINMilestones {get;set;}
    public Integer completedMilestoneSize {get;set;}
    public Integer INcompletedMilestoneSize {get;set;}
    public List<QuotationManagmentServices.PaymentMilestoneWrapper> pwListFinal {get;set;}
    public string completedMilestoneAmountSTR {get;set;}
    public string projectName {get;set;}
    public boolean allMilestoneCompleted {get;set;}
    public list<IN_MilestonesWrapper> IN_MilestonesList {get;set;}
    public string lastDateOfCompletedMilestones {get;set;}
    public string mainCharges {get;set;}
    
    public void getcreateBookingList(){
    
        app1Name = '';
        app2Name = '';
        app3Name = '';
        app4Name = '';
        app5Name = '';
        city = '';
        chequeno = '';
        bankname = '';
        partnersName = '';
        cheamount = '';
        cheamountword = '';
        paymentdate = '';
        salesprice = '';
        bookingdate = '';
        pwListFinal = new List<QuotationManagmentServices.PaymentMilestoneWrapper>();
        completedMilestoneAmountSTR = '';
        projectName = '';
        completedMilestoneSize = 0;
        INcompletedMilestoneSize = 0;
        allMilestoneCompleted = true;
        IN_MilestonesList = new list<IN_MilestonesWrapper>();
        lastDateOfCompletedMilestones = '';
        mainCharges = '';
        
        bookingObj = [Select id,Booking_Date__c,Booking_Through__c,Property__r.Is_Inclusive_Sale_Price__c,Tower_Name__c,CreatedBy.Name,CreatedBy.Email,CreatedBy.MobilePhone,Property__r.RM_Name__c,Property__r.Material_No__c,Property__r.House_Unit_No__c,Quotation__r.Total_Agreement_Value_Modified__c,Property__r.Tower_Name__c,Quotation__r.Effective_Sale_Price__c,
                      Opportunity__r.Partner_s_Firm_Name__c,Quotation__r.Total_CSGT_Modified__c,Quotation__r.Total_SGST_Modified__c,Quotation__c,Project__c,Project__r.name,Project__r.Maintenance_Charges__c,Quotation__r.Billing_Plan__c from Booking__c WHERE id =: BookingId];
        
         If(bookingObj != null){
                if(bookingObj.Project__c != null){
                    projectName = bookingObj.Project__r.name; 
                }
                if(bookingObj.Project__r.Maintenance_Charges__c != null){
                    mainCharges = bookingObj.Project__r.Maintenance_Charges__c;
                }
                applicant1 = [Select Id,Name,City__c,Salutation__c FROM Applicant__c WHERE Applicant_Number__c = 'Primary Applicant' AND Booking__c =: BookingId];
                
                //applicant1 = [Select Id,Name,City__c,Salutation__c,Applicant_Number__c FROM Applicant__c WHERE Applicant_Number__c != '' AND Booking__c =: BookingId];
                
                applicant2 = [Select Id,Name,Salutation__c  FROM Applicant__c WHERE Applicant_Number__c = 'Second Applicant' AND Booking__c =: BookingId];
                
                applicant3 = [Select Id,Name,Salutation__c  FROM Applicant__c WHERE Applicant_Number__c = 'Third Applicant' AND Booking__c =: BookingId];
                
                applicant4 = [Select Id,Name,Salutation__c  FROM Applicant__c WHERE Applicant_Number__c = 'Fourth Applicant' AND Booking__c =: BookingId];
                
                applicant5 = [Select Id,Name,Salutation__c  FROM Applicant__c WHERE Applicant_Number__c = 'Fifth Applicant' AND Booking__c =: BookingId];
                
                payment = [Select Payment_Mode__c,Payment_Date__c,RTGS_Cheque_Draft_No__c,Bank_Name__c,Amount__c,Instrument_Date__c 
                            FROM Payment__c WHERE Booking__c =: BookingId];
                            
                 /*if(applicant1.size() > 0){ 
                     if(applicant1[0].Applicant_Number__c == 'Primary Applicant'){
                        app1Name = applicant1[0].Salutation__c +' '+ applicant1[0].Name;
                        if(applicant1[0].City__c != null){
                            city = applicant1[0].City__c;
                        }
                    }
                    else if(applicant1[0].Applicant_Number__c == 'Second Applicant'){
                        app2Name = applicant1[0].Salutation__c +' '+ applicant1[0].Name;
                    }
                    else if(applicant1[0].Applicant_Number__c == 'Third Applicant'){
                        app3Name = applicant1[0].Salutation__c +' '+ applicant1[0].Name;
                    }
                    else if(applicant1[0].Applicant_Number__c == 'Fourth Applicant'){
                        app4Name = applicant1[0].Salutation__c +' '+ applicant1[0].Name;
                    }
                    else if(applicant1[0].Applicant_Number__c == 'Fifth Applicant'){
                        app5Name = applicant1[0].Salutation__c +' '+ applicant1[0].Name;
                    }
                 }*/
                 if(applicant1.size() > 0){
                    app1Name = applicant1[0].Salutation__c +' '+ applicant1[0].Name;
                    if(applicant1[0].City__c != null){
                        city = applicant1[0].City__c;
                    }
                 }
                 if(applicant2.size() > 0){
                    app2Name = applicant2[0].Salutation__c +' '+ applicant2[0].Name;
                    
                 }
                 if(applicant3.size() > 0){
                    app3Name = applicant3[0].Salutation__c +' '+ applicant3[0].Name;
                    
                 }
                 if(applicant4.size() > 0){
                    app4Name = applicant4[0].Salutation__c +' '+ applicant4[0].Name;
                    
                 }
                    
                 if(applicant5.size() > 0){
                    app5Name = applicant5[0].Salutation__c +' '+ applicant5[0].Name;
                    
                 }
                     
                if(payment.size() > 0){
                
                if(payment[0].Instrument_Date__c != null){
                    paymentdate = payment[0].Instrument_Date__c.format();
                }
                if(payment[0].RTGS_Cheque_Draft_No__c != null){
                    chequeno = payment[0].RTGS_Cheque_Draft_No__c;
                }
                if(payment[0].Bank_Name__c != null){
                    bankname = payment[0].Bank_Name__c;
                }
                if(payment[0].Amount__c != null){
                    cheamount = QuotationManagmentServices.INFormatR(payment[0].Amount__c);
                    
                }
                if(payment[0].Amount__c != null){
                    cheamountword = S_NumberToWord.convertNumbertoWords(Integer.valueof(payment[0].Amount__c));
                }
            }
        }
         if(bookingObj.Quotation__r.Total_Agreement_Value_Modified__c != null){
           if(bookingObj.Property__r.Is_Inclusive_Sale_Price__c != true){
                salesprice = QuotationManagmentServices.INFormatR(bookingObj.Quotation__r.Total_Agreement_Value_Modified__c);
           }else{
                Decimal InGSTSalePrice = bookingObj.Quotation__r.Total_Agreement_Value_Modified__c + bookingObj.Quotation__r.Total_CSGT_Modified__c + bookingObj.Quotation__r.Total_SGST_Modified__c;
                salesprice = QuotationManagmentServices.INFormatR(InGSTSalePrice);
           }
       }
       if(bookingObj.Opportunity__r.Partner_s_Firm_Name__c != Null){
           partnersName = bookingObj.Opportunity__r.Partner_s_Firm_Name__c;
       }
       if(bookingObj.Booking_Date__c != null){
          bookingdate = bookingObj.Booking_Date__c.format();
       }
       List< QuotationManagmentServices.PaymentMilestoneWrapper > pwList = QuotationManagmentServices.getCustomerViewPaymentSchedule(bookingObj.Quotation__c);
       List< Payment_Plan_Line_Item__c > ppl = [select id,name, Payment_Plan__c, Usage__c, Percentage_Of_Value_To_Be_Invoiced__c,
                    Payment_Group__c, Milestone_Number__c, Date_Description__c from Payment_Plan_Line_Item__c where 
                    Payment_Plan__c =: bookingObj.Quotation__r.Billing_Plan__c 
                    and Payment_Group__c = 'IN' and Is_IN00_01_Milesone__c = true
                    ];
        if(ppl != null && !ppl.isEmpty()){
            totalINMilestones = ppl.size();
            for(Payment_Plan_Line_Item__c pl : ppl){
                if(pl.Milestone_Number__c == '000000000000' && pl.Usage__c == null && pl.Date_Description__c != null){
                    completedMilestoneSize += 1;
                }else{
                    INcompletedMilestoneSize += 1;
                    allMilestoneCompleted = false;
                }
                
            }
        }else{
            allMilestoneCompleted = false;
        }
        decimal completedPercentage = 0;
        decimal completedAmount = 0;
        decimal completedCGST = 0;
        decimal completedSGST = 0;
        decimal completedTotalGST = 0;
        decimal completedMilestoneAmountD = 0;
       // Integer loc = 0;
        //Integer loc1 = 0;
       // boolean isAnyIN_Milestone = false;
       Integer s_No = 1;
        for(QuotationManagmentServices.PaymentMilestoneWrapper pw : pwList){
            if(pw.paymentGroup == 'IN' && pw.is_IN001Milestone){
               // isAnyIN_Milestone = true;
                if(allMilestoneCompleted){
                    system.debug('inside all completed');
                    pwListFinal.add(pw);
                    
                }else{
                    if(pw.isCompletedMilestone){
                        system.debug('hiiii');
                        IN_MilestonesWrapper INm = new IN_MilestonesWrapper();
                        INm.s_No = s_No;
                        INm.name = pw.milestoneName;
                        INm.amountD = pw.amountD;
                        INm.amountSTR = pw.amountSTR;
                        INm.due_Date = QuotationManagmentServices.customDateFormat(pw.dueDateINDATE);
                        IN_MilestonesList.add(INm);
                        completedMilestoneAmountD += pw.totalMilestoneD;
                        completedPercentage += pw.milestonePercentage;
                        completedAmount += pw.amountD;
                        completedCGST += pw.CGST_D;
                        completedSGST += pw.SGST_D;
                        completedTotalGST += pw.totalGST_D;
                        lastDateOfCompletedMilestones = QuotationManagmentServices.customDateFormat(pw.dueDateINDATE);
                       // loc1 = loc;
                    }else{
                        pwListFinal.add(pw);
                        allMilestoneCompleted = false;
                    }
                }
            }else{
                pwListFinal.add(pw);
            }
           // loc++;
        }
        /*if(allMilestoneCompleted && isAnyIN_Milestone){
            QuotationManagmentServices.PaymentMilestoneWrapper pw = new QuotationManagmentServices.PaymentMilestoneWrapper();
            pw.paymentGroup = 'IN'; 
            pw.amountD = completedAmount;
            pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD);
            pw.CGST_D = completedCGST;
            pw.CGST_STR = QuotationManagmentServices.INFormatR(pw.CGST_D);
            pw.SGST_D = completedSGST;
            pw.SGST_STR = QuotationManagmentServices.INFormatR(pw.SGST_D);
            pw.totalGST_D = completedTotalGST;
            pw.totalGST_STR = QuotationManagmentServices.INFormatR(pw.totalGST_D);
            pw.totalMilestoneD = completedMilestoneAmountD;
            pw.totalMilestoneSTR = QuotationManagmentServices.INFormatR(pw.totalMilestoneD);
            pw.milestonePercentage = completedPercentage;
            pw.isCompletedMilestone = true;
            pw.is_IN001Milestone = true;
            pwListFinal.add(loc1,pw);
        }*/
        if(!allMilestoneCompleted){
            for(QuotationManagmentServices.PaymentMilestoneWrapper pw : pwListFinal){
                if(pw.paymentGroup == 'IN' && pw.is_IN001Milestone){
                    pw.amountD += completedAmount;
                    //pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD);
                    pw.CGST_D += completedCGST;
                    pw.CGST_STR = QuotationManagmentServices.INFormatR(pw.CGST_D);
                    pw.SGST_D += completedSGST;
                    pw.SGST_STR = QuotationManagmentServices.INFormatR(pw.SGST_D);
                    pw.totalGST_D += completedTotalGST;
                    if(bookingObj.Property__r.Is_Inclusive_Sale_Price__c != true){
                        pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD);
                    }else{
                        pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD + pw.totalGST_D);  
                    }
                    pw.totalGST_STR = QuotationManagmentServices.INFormatR(pw.totalGST_D);
                    pw.totalMilestoneD += completedMilestoneAmountD;
                    pw.totalMilestoneSTR = QuotationManagmentServices.INFormatR(pw.totalMilestoneD);
                    pw.milestonePercentage += completedPercentage;
                }
            }
        }
        //completedMilestoneAmountSTR = QuotationManagmentServices.INFormatR(completedAmount);
        if(bookingObj.Property__r.Is_Inclusive_Sale_Price__c != true){
            completedMilestoneAmountSTR = QuotationManagmentServices.INFormatR(completedAmount);
        }else{
            completedMilestoneAmountSTR = QuotationManagmentServices.INFormatR(completedAmount + completedTotalGST);
        }    
        /////////// Change Completed milestone name
        if(IN_MilestonesList != null && !IN_MilestonesList.isEmpty()){
            for(IN_MilestonesWrapper mn : IN_MilestonesList){
                if(IN_MilestonesList.size() == mn.s_No){
                    mn.name = 'To be paid on or before ' + mn.due_Date + ' along with any further milestones raised till then';
                }
            }
        } 
    }
    Public Class IN_MilestonesWrapper{
        
        Public string name {get;set;}
        Public decimal amountD {get;set;}
        Public string amountStr {get;set;}
        Public Integer s_No {get;set;}
        Public string due_Date {get;set;}
        
        public IN_MilestonesWrapper(){
        
        }
    }
}
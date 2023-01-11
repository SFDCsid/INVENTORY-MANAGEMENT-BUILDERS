Public Class ViewBooking{
    public string BookId {get;set;}
    public Booking__c bookingObj{get;set;}
    public List<Applicant__c> applicant1{get;set;}
    public List<Booking__c> booklist{get;set;}
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
    public string  nationality{get;set;}
    public string  residentstatus{get;set;}
    public string  residentstatus2{get;set;}
    public string  residentstatus3{get;set;}
    public string  residentstatus4{get;set;}
    public string  residentstatus5{get;set;}
    public string  houseNo{get;set;} 
    public string  street{get;set;}
    public string  street1{get;set;}
    public string  street2{get;set;}
    public string  locality{get;set;}
    public string  city{get;set;}
    public string  pincode{get;set;}
    public string  billingadd{get;set;}
    public string  companyname{get;set;}
    public string  designation{get;set;}
    public string  companyadd{get;set;}
    public string  mobileno1{get;set;}
    public string  mobileno2{get;set;}
    public string  emailid{get;set;}
    public string  altemailid{get;set;}
    public string  carparkDetails{get;set;}
    public string  salesprice{get;set;}
    public string  paymentmode{get;set;}
    public string  chequeno{get;set;}
    public string  bankname{get;set;}
    public string  branch{get;set;}
    public string  branch2{get;set;}
    public string  cheamount{get;set;}  
    public string  paymentdate{get;set;}
    public string  pancardno{get;set;}
    public string  cheamountword{get;set;}
    public string  tdscompanyadd{get;set;}
    public string  paymentmode2{get;set;}
    public string  chequeno2{get;set;}
    public string  bankname2{get;set;}
    public string  cheamount2{get;set;}  
    public string  paymentdate2{get;set;}
    public string  cheamountword2{get;set;}
    public string  Bookingdate{get;set;}
    public string  mailingAdd{get;set;}
    public string  EnquiryType{get;set;}
    public string  BrokerAccount{get;set;}
    public string  BrokerAccount1{get;set;}
    public string  MAHARERARegistration{get;set;}
    public string  BaMobile{get;set;}
    public string  BaEmail{get;set;}
    public string  PartOffAddress{get;set;}
    public string  ContactPersonisSameasApplicant{get;set;}
    public string  reffBy{get;set;}
    public string  reffByProj{get;set;}
    public string  reffBytow{get;set;}
    public string  reffByFlat{get;set;}
    public string  reffEMPcode{get;set;}
    public string  contactpName{get;set;}
    public string  contactpRelation{get;set;}
    public string  contactpMobile{get;set;}
    public string  contactpEmail{get;set;}
    public Integer floorNo{get;set;}
    public Integer age{get;set;}
    public Integer carpetarea{get;set;}
    public Integer totalINMilestones {get;set;}
    public Integer completedMilestoneSize {get;set;}
    public Integer INcompletedMilestoneSize {get;set;}
    Public List<QuotationManagmentServices.PaymentMilestoneWrapper> pwListFinal {get;set;}
    public boolean allMilestoneCompleted {get;set;}
    public String billingPlan_Type {get;set;}
    public String completedMilestoneAmountSTR {get;set;}
    public list<IN_MilestonesWrapper> IN_MilestonesList {get;set;}
    public list<PaymentWrapper> PaymentList {get;set;}
    public string lastDateOfCompletedMilestones {get;set;}
    
    
    
    public ViewBooking(){
        app1Name = '';
        app2Name = '';
        app3Name = '';
        app4Name = '';
        app5Name = '';
        nationality = '';
        billingadd = '';
        residentstatus = '';
        residentstatus2 = '';
        residentstatus3 = '';
        residentstatus4 = '';
        residentstatus5 = '';
        houseNo = '';
        street = '';
        street1 = '';
        street2 = '';
        locality = '';
        city = '';
        pincode = '';
        companyname = '';
        designation = '';
        companyadd = '';
        mobileno1 = '';
        mobileno2 = '';
        emailid = '';
        altemailid = '';
        carparkDetails = '';
        salesprice = '';
        paymentdate = '';
        paymentmode = '';
        chequeno = '';
        bankname = '';
        branch = '';
        branch2 = '';
        cheamount = '';
        pancardno = '';
        cheamountword = '';
        tdscompanyadd = '';
        paymentdate2 = '';
        paymentmode2 = '';
        chequeno2 = '';
        bankname2 = '';
        contactpName = '';
        contactpRelation = '';
        contactpMobile = '';
        contactpEmail = '';
        cheamount2 = '';
        cheamountword2 = '';
        totalINMilestones = 0;
        floorNo = 0;
        age = 0;
        carpetarea = 0;
        bookingdate = '';
        mailingAdd = '';
        ContactPersonisSameasApplicant = '';
        EnquiryType = '';
        BrokerAccount = '';
        BrokerAccount1 = '';
        MAHARERARegistration ='';
        BaMobile ='';
        BaEmail = '';
        PartOffAddress = '';
        reffBy = '';
        reffByProj = '';
        reffBytow = '';
        reffByFlat = '';
        reffEMPcode = '';
        completedMilestoneSize = 0;
        INcompletedMilestoneSize = 0;
        pwListFinal = new List<QuotationManagmentServices.PaymentMilestoneWrapper>(); 
        allMilestoneCompleted = true;
        billingPlan_Type = '';
        completedMilestoneAmountSTR  = ' ';
        IN_MilestonesList = new list<IN_MilestonesWrapper>();
        PaymentList = new list<PaymentWrapper>();
        lastDateOfCompletedMilestones = '';
        
        if(ApexPages.currentPage().getParameters().containsKey('id') != null)
            BookId =  ApexPages.currentPage().getParameters().get('id');
        bookingObj = new Booking__c();
        //List<Booking__c> 
        booklist = new List<Booking__c>();
        
        System.debug('BookId : '+BookId);
            
        booklist = [Select id,Tower_Name__c,TDS_Paid_By__c,Future_Correspondence_Contact__c,Future_Correspondence_Contact_Name__c,Future_Correspondence_Contact_Email__c,Future_Correspondence_Contact_Phone__c,
        CreatedBy.Name,Property_Type_Name__c,Property__r.Project_Name__r.Name,Property__r.Unit_Type__c,Property__r.Project_Name__r.Subsidiary_Company_Name__c,Project__r.Name,Property__r.Carpet_Area__c,
        Property__r.Project_Name__r.Subsidiary_Company_Address__c,Property__r.Is_Inclusive_Sale_Price__c,Property__r.Project_Name__r.Other_Company_Postal_Code__c,Property__r.Project_Name__r.Other_Company_Phone__c,Property__r.House_Unit_No__c,
        Property__r.Project_Name__r.Other_Company_Fax__c,Property__r.Project_Name__r.Other_Company_Website__c,Opportunity__r.Enquiry_Type__c,Mode_of_Funding__c,Opportunity__r.Partner_s_Office_Address__c,
        C_o_Name_Mailing_Address__c,Mailing_Street__c,Mailing_Str_Suppl2__c,Mailing_Str_Suppl3__c,Mailing_Location__c,Mailing_Post_Code__c,Mailing_City__c,Mailing_Country__c,Mailing_Region__c,
        C_o_Name_Billing_Address__c,Billing_Street__c,Billing_Str_Suppl2__c,Billing_Str_Suppl3__c,Billing_Location__c,Billing_Post_Code__c,Billing_City__c,Billing_Country__c,Billing_Region__c,Quotation__r.Total_CSGT_Modified__c,Quotation__r.Total_SGST_Modified__c,
        Opportunity__r.Contact_Person_is_Same_as_Applicant__c,Opportunity__r.Contact_Person_Name__c,Opportunity__r.Contact_Person_Relation_Designation__c,Opportunity__r.Contact_Person_Mobile_1__c,Opportunity__r.Contact_Person_Email__c,
        Opportunity__c, Opportunity__r.Preferred_Mode_of_Communication__c,Opportunity__r.Nationality__c,Opportunity__r.OwnerId,Opportunity__r.Partner_s_Firm_Name__c,Opportunity__r.Partner_s_Name__c,Opportunity__r.Partner_s_RERA_Number__c,Opportunity__r.Partner_Email__c,Opportunity__r.Partner_Mobile__c,Property__r.Floor_Number__c,Property__r.Material_No__c,Quotation__r.Total_Agreement_Value_Modified__c,
        Opportunity__r.Broker_Account__r.MAHA_RERA_Registration__c,Opportunity__r.Broker_Account__r.Name_1__c,Opportunity__r.Broker_Account__r.Email_1__c,Opportunity__r.Broker_Account__r.Mobile_1__c,Opportunity__r.Broker_Account__r.Name,
        Quotation__r.Billing_Plan__r.Payment_Plan_Type__c,Quotation__r.OC_Received__c,Opportunity__r.Referred_By__c,Opportunity__r.Referred_Project__c,Opportunity__r.Referred_Tower__c,Opportunity__r.Referred_Flat__c,Opportunity__r.Referred_EMP_code__c,
        Quotation__r.Car_Park_Type_1__c,Quotation__r.Car_Park_Type_2__c,Quotation__r.Car_Park_Type_3__c,Quotation__r.Car_Park_Type_4__c,Quotation__r.Car_Park_Type_5__c,
        Quotation__r.Car_Park_Count_1__c,Quotation__r.Car_Park_Count_2__c,Quotation__r.Car_Park_Count_3__c,Quotation__r.Car_Park_Count_4__c,Quotation__r.Car_Park_Count_5__c,
        Quotation__r.Earmarked_Car_Parking_Type_1__c,Quotation__r.Earmarked_Car_Parking_Type_2__c,Quotation__r.Earmarked_Car_Parking_Type_3__c,Quotation__r.Earmarked_Car_Parking_Type_4__c,
        Quotation__r.Earmarked_Car_Parking_Type_5__c,Booking_Date__c,Quotation__r.Earmarked_Car_Parking_Count_1__c,Quotation__r.Earmarked_Car_Parking_Count_2__c,Quotation__r.Earmarked_Car_Parking_Count_3__c,
        Quotation__r.Earmarked_Car_Parking_Count_4__c,Quotation__r.Earmarked_Car_Parking_Count_5__c,Project__r.Subsidiary_Company_Name__c,Project__r.RERA_Description__c,Opportunity__r.Account.Company__pc,Opportunity__r.Account.Designation__pc,
        Project__r.Subsidiary_Company_Address__c,Project__r.Other_Company_Postal_Code__c,Quotation__r.id,Quotation__r.Billing_Plan__c
        from Booking__c WHERE id =: BookId];
        
        if(!booklist.isEmpty()){
            bookingObj = booklist[0];
        }
        System.debug('bookingObj:' +bookingObj);
        If(bookingObj != null){
            Date d = bookingObj.Booking_Date__c;
            //Bookingdate =  d.day()+'-'+ d.month()+'-'+d.year();
            
            billingPlan_Type = bookingObj.Quotation__r.Billing_Plan__r.Payment_Plan_Type__c;
                
                applicant1 = [Select Id,Name,Applicant_Number__c,Age__c,Salutation__c,Applicant_Name__c,PancardNo__c,Mobile_Number__c,Mailing_Address_same_as_PermanentAddress__c,
                            Email_Address__c,Street_1__c,City__c,State_Province__c,GSTN__c, Nationality__c,House_No__c,Locality__c,State__c,Country__c,
                            Street_2__c,Street_3__c,Pincode__c,Company_Name__c,Designation__c,Office_Address__c,Alternate_Mobile_No__c,
                            Alternate_Email_Id__c,Residential_Status__c,Pan_Card_Number_of_Authority_Signatory__c, Subtype_Of_Applicant__c,Mailing_House_No__c,Mailing_Street_1__c,Mailing_Street_2__c,
                            Mailing_Street_3__c,Mailing_Locality__c,Mailing_City__c,Mailing_State__c,Mailing_Pincode__c
                            FROM Applicant__c WHERE Applicant_Number__c = 'Primary Applicant' AND Booking__c =: BookId];
                
                applicant2 = [Select Id,Name,Applicant_Number__c,Applicant_Name__c,PancardNo__c,Mobile_Number__c,Email_Address__c,Salutation__c,Subtype_Of_Applicant__c  
                            FROM Applicant__c WHERE Applicant_Number__c = 'Second Applicant' AND Booking__c =: BookId];
                
                applicant3 = [Select Id,Name,Applicant_Number__c,Applicant_Name__c,PancardNo__c,Mobile_Number__c,Email_Address__c,Salutation__c,Subtype_Of_Applicant__c  
                            FROM Applicant__c WHERE Applicant_Number__c = 'Third Applicant' AND Booking__c =: BookId];
                
                applicant4 = [Select Id,Name,Applicant_Number__c,Applicant_Name__c,PancardNo__c,Mobile_Number__c,Email_Address__c,Salutation__c,Subtype_Of_Applicant__c  
                            FROM Applicant__c WHERE Applicant_Number__c = 'Fourth Applicant' AND Booking__c =: BookId];
                
                applicant5 = [Select Id,Name,Applicant_Number__c,Applicant_Name__c,PancardNo__c,Mobile_Number__c,Email_Address__c,Salutation__c,Subtype_Of_Applicant__c  
                            FROM Applicant__c WHERE Applicant_Number__c = 'Fifth Applicant' AND Booking__c =: BookId];
                            
                payment = [Select Payment_Mode__c,Payment_Date__c,RTGS_Cheque_Draft_No__c,Bank_Name__c,Amount__c,Instrument_Date__c,Branch_Name__c,Is_Token__c 
                            FROM Payment__c WHERE Is_Token__c = True AND Booking__c =: BookId];
        
        if(applicant1.size() > 0){
            app1Name = applicant1[0].Salutation__c +' '+ applicant1[0].Name;
            //app1Name = app1Name.toUpperCase();
            if(applicant1[0].Nationality__c != null){
                nationality = applicant1[0].Nationality__c;
            }
            if(applicant1[0]. Subtype_Of_Applicant__c != null){
                residentstatus = applicant1[0].Subtype_Of_Applicant__c;
            }
            if(applicant1[0].Age__c != null){
                age = Integer.valueof(applicant1[0].Age__c);
            }
            if(applicant1[0].House_No__c != null){
                houseNo = applicant1[0].House_No__c;
                billingadd = applicant1[0].House_No__c;
            }
            if(applicant1[0].Street_1__c != null){
                street = applicant1[0].Street_1__c;
                billingadd += ', ' + applicant1[0].Street_1__c;
            }
            if(applicant1[0].Street_2__c != null){
                street1 = applicant1[0].Street_2__c;
                billingadd += ', ' +applicant1[0].Street_2__c;
            }
            if(applicant1[0].Street_3__c != null){
                street2 = applicant1[0].Street_3__c;
                billingadd += ', ' + applicant1[0].Street_3__c;
            }
            if(applicant1[0].Locality__c != null){
                locality = applicant1[0].Locality__c;
                billingadd += ', ' + applicant1[0].Locality__c;
            }
            if(applicant1[0].City__c != null){
                city = applicant1[0].City__c;
                billingadd += ', ' + applicant1[0].City__c;
            }
            if(applicant1[0].Pincode__c != null){
                 pincode = applicant1[0].Pincode__c;
                 billingadd += '-' + applicant1[0].Pincode__c;
            }
            if(applicant1[0].State__c != null){
                billingadd += ', ' + applicant1[0].State__c;
            }
            if(applicant1[0].Country__c != null){
                billingadd += ', ' + applicant1[0].Country__c;
            }
            if(applicant1[0].Company_Name__c != null){
                 companyname = applicant1[0].Company_Name__c;
            }
            if(applicant1[0].Designation__c != null){
                designation = applicant1[0].Designation__c;
            }
            /*if(applicant1[0].Office_Address__c != null){
                companyadd = applicant1[0].Office_Address__c;
            }*/
            if(applicant1[0].Mobile_Number__c != null){
                mobileno1 = applicant1[0].Mobile_Number__c;
            }
            if(applicant1[0].Alternate_Mobile_No__c!= null){
                mobileno2 = applicant1[0].Alternate_Mobile_No__c;
            }
            if(applicant1[0].Email_Address__c != null){
                emailid = applicant1[0].Email_Address__c;
            }
            if(applicant1[0].Alternate_Email_Id__c != null){
                altemailid = applicant1[0].Alternate_Email_Id__c;
            }
            if(applicant1[0].PancardNo__c != null){
                pancardno = applicant1[0].PancardNo__c;
            }else if(applicant1[0].Pan_Card_Number_of_Authority_Signatory__c != null){
                pancardno = applicant1[0].Pan_Card_Number_of_Authority_Signatory__c;
            }
        }
        if(BookingObj.C_o_Name_Mailing_Address__c != null){
            mailingAdd = BookingObj.C_o_Name_Mailing_Address__c;
        }
        if(BookingObj.Mailing_Street__c != null){
            mailingAdd += ','+ BookingObj.Mailing_Street__c;
        }
        if(BookingObj.Mailing_Str_Suppl2__c != null){
            mailingAdd += ','+ BookingObj.Mailing_Str_Suppl2__c;
        }
        if(BookingObj.Mailing_Str_Suppl3__c != null){
            mailingAdd += ','+ BookingObj.Mailing_Str_Suppl3__c;
        }
        if(BookingObj.Mailing_Location__c != null){
            mailingAdd += ','+ BookingObj.Mailing_Location__c;
        }
        if(BookingObj.Mailing_City__c != null){
            mailingAdd += ','+ BookingObj.Mailing_City__c;
        
        if(BookingObj.Mailing_Post_Code__c != null){
            mailingAdd += '-'+ BookingObj.Mailing_Post_Code__c;
        }
        }
        if(BookingObj.Mailing_Region__c != null){
            mailingAdd += ','+ BookingObj.Mailing_Region__c;
        }
        
        If(BookingObj.Opportunity__r.Contact_Person_is_Same_as_Applicant__c != null){
            ContactPersonisSameasApplicant = BookingObj.Opportunity__r.Contact_Person_is_Same_as_Applicant__c;
        }
        
        If(BookingObj.Opportunity__r.Enquiry_Type__c != null){
            EnquiryType = BookingObj.Opportunity__r.Enquiry_Type__c;
        }
            
            
        //By shivam
        If(BookingObj.Opportunity__r.Broker_Account__c != null){
    If(BookingObj.Opportunity__r.Broker_Account__r.Name != null){
            BrokerAccount = BookingObj.Opportunity__r.Broker_Account__r.Name;
        }
        
        If(BookingObj.Opportunity__r.Broker_Account__r.Name_1__c != null){
            BrokerAccount1 = BookingObj.Opportunity__r.Broker_Account__r.Name_1__c;
        }
        
        If(BookingObj.Opportunity__r.Broker_Account__r.MAHA_RERA_Registration__c != null){
            MAHARERARegistration = BookingObj.Opportunity__r.Broker_Account__r.MAHA_RERA_Registration__c;
        }
        
        If(BookingObj.Opportunity__r.Broker_Account__r.Mobile_1__c != null){
            BaMobile = BookingObj.Opportunity__r.Broker_Account__r.Mobile_1__c;
        }
        
        If(BookingObj.Opportunity__r.Broker_Account__r.Email_1__c != null){
            BaEmail = BookingObj.Opportunity__r.Broker_Account__r.Email_1__c;
        }
}else{
    If(BookingObj.Opportunity__r.Partner_s_Firm_Name__c != null){
            BrokerAccount = BookingObj.Opportunity__r.Partner_s_Firm_Name__c;
        }
        
        If(BookingObj.Opportunity__r.Partner_s_Name__c != null){
            BrokerAccount1 = BookingObj.Opportunity__r.Partner_s_Name__c;
        }
        
        If(BookingObj.Opportunity__r.Partner_s_RERA_Number__c != null){
            MAHARERARegistration = BookingObj.Opportunity__r.Partner_s_RERA_Number__c;
        }
        
        If(BookingObj.Opportunity__r.Partner_Mobile__c  != null){
            BaMobile = BookingObj.Opportunity__r.Partner_Mobile__c ;
        }
        
        If(BookingObj.Opportunity__r.Partner_Email__c != null){
            BaEmail = BookingObj.Opportunity__r.Partner_Email__c;
        }
       }
        //By shivam end
       
        
            
        
        If(BookingObj.Opportunity__r.Partner_s_Office_Address__c != null){
            PartOffAddress = BookingObj.Opportunity__r.Partner_s_Office_Address__c;
        }
        
        
        If(BookingObj.Opportunity__r.Contact_Person_Name__c != null){
            contactpName = BookingObj.Opportunity__r.Contact_Person_Name__c;
        }
        
        If(BookingObj.Opportunity__r.Contact_Person_Relation_Designation__c != null){
            contactpRelation = BookingObj.Opportunity__r.Contact_Person_Relation_Designation__c;
        }
        
        If(BookingObj.Opportunity__r.Contact_Person_Mobile_1__c != null){
            contactpMobile = BookingObj.Opportunity__r.Contact_Person_Mobile_1__c;
        }
        
        If(BookingObj.Opportunity__r.Contact_Person_Email__c != null){
            contactpEmail = BookingObj.Opportunity__r.Contact_Person_Email__c;
        }
        
        If(BookingObj.Opportunity__r.Referred_By__c != null){
            reffBy = BookingObj.Opportunity__r.Referred_By__c;
        }
        If(BookingObj.Opportunity__r.Referred_Project__c != null){
            reffByProj = BookingObj.Opportunity__r.Referred_Project__c;
        }
        If(BookingObj.Opportunity__r.Referred_Tower__c != null){
            reffBytow = BookingObj.Opportunity__r.Referred_Tower__c;
        }
        If(BookingObj.Opportunity__r.Referred_Flat__c != null){
            reffByFlat = BookingObj.Opportunity__r.Referred_Flat__c;
        }
        
        If(BookingObj.Opportunity__r.Referred_EMP_code__c != null){
            reffEMPcode = BookingObj.Opportunity__r.Referred_EMP_code__c;
        }
        
        if(applicant2.size() > 0){
            app2Name = applicant2[0].Salutation__c +' '+ applicant2[0].Name;
            //app2Name = app2Name.toUpperCase();
            
            if(applicant2[0]. Subtype_Of_Applicant__c != null){
                residentstatus2 = applicant2[0].Subtype_Of_Applicant__c;
            }
        }
        if(applicant3.size() > 0){
            app3Name = applicant3[0].Salutation__c +' '+ applicant3[0].Name;
            //app3Name = app3Name.toUpperCase();
            if(applicant3[0]. Subtype_Of_Applicant__c != null){
                residentstatus3 = applicant3[0].Subtype_Of_Applicant__c;
            }
        }
        if(applicant4.size() > 0){
            app4Name = applicant4[0].Salutation__c +' '+ applicant4[0].Name;
            //app4Name = app4Name.toUpperCase();
            if(applicant4[0]. Subtype_Of_Applicant__c != null){
                residentstatus4 = applicant4[0].Subtype_Of_Applicant__c;
            }
        }
        
        if(applicant5.size() > 0){
            app5Name = applicant5[0].Salutation__c +' '+ applicant5[0].Name;
            //app5Name = app5Name.toUpperCase();
            if(applicant5[0]. Subtype_Of_Applicant__c != null){
                residentstatus5 = applicant5[0].Subtype_Of_Applicant__c;
            }
        }
        
        if(payment.size() > 0){
        
            if(payment[0].Payment_Mode__c != null){
                paymentmode = payment[0].Payment_Mode__c;
            }
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
            if(payment[0].Branch_Name__c != null){
                branch = payment[0].Branch_Name__c;
            }
        }
        Integer count1=1;
        for(Payment__c p:payment){
        
            PaymentWrapper payw = new PaymentWrapper();
            payw.pmode = p.Payment_Mode__c;
            payw.payNo = p.RTGS_Cheque_Draft_No__c;
            payw.pbankname = p.Bank_Name__c;
            payw.pbranch = p.Branch_Name__c;
            payw.isdate = p.Instrument_Date__c.format();
            payw.wcheamount = QuotationManagmentServices.INFormat(p.Amount__c);
            payw.count = count1;
            PaymentList.add(payw);
            count1++;
           
        }
        
        if(payment.size() > 1){
        
            if(payment[1].Payment_Mode__c != null){
                paymentmode2 = payment[1].Payment_Mode__c;
            }
            if(payment[1].Instrument_Date__c != null){
                paymentdate2 = payment[1].Instrument_Date__c.format();
            }
            if(payment[1].RTGS_Cheque_Draft_No__c != null){
                chequeno2 = payment[1].RTGS_Cheque_Draft_No__c;
            }
            if(payment[1].Bank_Name__c != null){
                bankname2 = payment[1].Bank_Name__c;
            }
            if(payment[1].Amount__c != null){
                cheamount2 = QuotationManagmentServices.INFormatR(payment[1].Amount__c);
                
            }
            if(payment[1].Amount__c != null){
                cheamountword2 = S_NumberToWord.convertNumbertoWords(Integer.valueof(payment[1].Amount__c));
            }
            if(payment[1].Branch_Name__c != null){
                branch2 = payment[1].Branch_Name__c;
            }
        }
        
           if(bookingObj.Property__r.Floor_Number__c != null){
              floorNo = Integer.valueof(bookingObj.Property__r.Floor_Number__c);
           }
           if(bookingObj.Property__r.Carpet_Area__c != null){
              carpetarea = Integer.valueof(bookingObj.Property__r.Carpet_Area__c);
           }
           
           if(bookingObj.Quotation__r.Total_Agreement_Value_Modified__c != null){
               if(bookingObj.Property__r.Is_Inclusive_Sale_Price__c != true){
                   salesprice = QuotationManagmentServices.INFormatR(bookingObj.Quotation__r.Total_Agreement_Value_Modified__c);
               }else{
                   Decimal InGSTSalePrice = bookingObj.Quotation__r.Total_Agreement_Value_Modified__c + bookingObj.Quotation__r.Total_CSGT_Modified__c + bookingObj.Quotation__r.Total_SGST_Modified__c;
                   salesprice = QuotationManagmentServices.INFormatR(InGSTSalePrice);
               }
           }
           Map<string,decimal> parkingMap = new Map<string,decimal>();
            for(Integer i=1;i<=5;i++){
                string earmarkedName = (string)bookingObj.Quotation__r.get('Earmarked_Car_Parking_Type_'+ i +'__c');
                decimal earmarkedCount = (decimal)bookingObj.Quotation__r.get('Earmarked_Car_Parking_Count_'+ i +'__c');
                if(string.isNotBlank(earmarkedName)){
                    earmarkedName = earmarkedName.toLowerCase();
                    earmarkedName = earmarkedName.substring(0,1).toUpperCase() + earmarkedName.substring(1,earmarkedName.length());
                }
                string additionalParkName = (String)bookingObj.Quotation__r.get('Car_Park_Type_'+ i +'__c');
                decimal additionalParkCount = (decimal)bookingObj.Quotation__r.get('Car_Park_Count_'+ i +'__c');
                
                if(string.isNotBlank(earmarkedName)){
                    if(parkingMap.containsKey(earmarkedName)){
                        decimal cc = parkingMap.get(earmarkedName);
                        cc = cc + earmarkedCount;
                        parkingMap.put(earmarkedName,cc);
                    }else{
                        parkingMap.put(earmarkedName,earmarkedCount);
                    }
                }
                
                if(string.isNotBlank(additionalParkName)){
                    additionalParkName = additionalParkName.toLowerCase();
                    additionalParkName = additionalParkName.substring(0,1).toUpperCase() + additionalParkName.substring(1,additionalParkName.length());
                    if(parkingMap.containsKey(additionalParkName)){
                        decimal cc = parkingMap.get(additionalParkName);
                        cc = cc + additionalParkCount;
                        parkingMap.put(additionalParkName,cc);
                    }else{
                        parkingMap.put(additionalParkName,additionalParkCount);
                    }
                }
                
            }             
            if(!parkingMap.isEMpty()){
                for(string st : parkingMap.keySet()){
                    if(string.isBlank(carparkDetails)){
                        carparkDetails = st + '-' + parkingMap.get(st);
                    }else{
                        carparkDetails += ', ' + st + '-' + parkingMap.get(st);
                    }
                }
            }
           
           if(bookingObj.Project__r.Subsidiary_Company_Address__c != null && bookingObj.Project__r.Other_Company_Postal_Code__c != null){
               tdscompanyadd = bookingObj.Project__r.Subsidiary_Company_Address__c +' - '+ bookingObj.Project__r.Other_Company_Postal_Code__c;
           }
           
           
           List<QuotationManagmentServices.PaymentMilestoneWrapper> pwList = QuotationManagmentServices.getCustomerViewPaymentSchedule(bookingObj.Quotation__r.id);
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
            decimal completedMilestoneAmountD = 0;
            decimal completedAmount = 0;
            decimal completedCGST = 0;
            decimal completedSGST = 0;
            decimal completedTotalGST = 0;
            //Integer loc = 0;
            //Integer loc1 = 0;
            //boolean isAnyIN_Milestone = false;
            Integer s_No = 1;
            for(QuotationManagmentServices.PaymentMilestoneWrapper pw : pwList){
                if(pw.paymentGroup == 'IN' && pw.is_IN001Milestone){
                    //isAnyIN_Milestone = true;
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
                                
                                system.debug('amountD******'+INm.amountD);
                                INm.due_Date = QuotationManagmentServices.customDateFormat(pw.dueDateINDATE);
                                IN_MilestonesList.add(INm);
                                completedMilestoneAmountD += pw.totalMilestoneD;
                                completedPercentage += pw.milestonePercentage;
                                completedAmount += pw.amountD;
                                completedCGST += pw.CGST_D;
                                completedSGST += pw.SGST_D;
                                completedTotalGST += pw.totalGST_D;
                                system.debug('completedTotalGST******'+completedTotalGST);
                               // loc1 = loc;
                                lastDateOfCompletedMilestones = QuotationManagmentServices.customDateFormat(pw.dueDateINDATE);
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
           /* if(allMilestoneCompleted && isAnyIN_Milestone){
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
                        
                        pw.CGST_D += completedCGST;
                        pw.CGST_STR = QuotationManagmentServices.INFormatR(pw.CGST_D);
                        pw.SGST_D += completedSGST;
                        pw.SGST_STR = QuotationManagmentServices.INFormatR(pw.SGST_D);
                        pw.totalGST_D += completedTotalGST;
                        system.debug('GST******'+pw.totalGST_D);
                        system.debug('AMount******'+pw.amountD);
                        if(bookingObj.Property__r.Is_Inclusive_Sale_Price__c != true){
                            pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD);
                        }else{
                            pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD + pw.totalGST_D);  
                        }
                        system.debug('amountSTR******'+pw.amountSTR);
                        pw.totalGST_STR = QuotationManagmentServices.INFormatR(pw.totalGST_D);
                        pw.totalMilestoneD += completedMilestoneAmountD;
                        pw.totalMilestoneSTR = QuotationManagmentServices.INFormatR(pw.totalMilestoneD);
                        pw.milestonePercentage += completedPercentage;
                    }
                }
            }
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
    }
    Public Void SaveQuote1(){
        //SendReceiptPDFEmail.SendPDL(BookId);
        // Reference the attachment page and pass in the receipt ID
        PageReference pdf =  Page.SendViewBookingForm;
        pdf.getParameters().put('id',BookId);
        pdf.setRedirect(true);
        Blob b;
        
        if(!Test.isRunningTest()) { 
          b = pdf.getContentAsPDF();
        } else if(Test.isRunningTest()){
          b = Blob.valueof('Some random String');
        }
       
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('BookingForm.pdf');        
        efa.setBody(b);
    
        //----------------Send Email-------------------------------------------------------------------------------
       
         Booking__c BookEmail = [Select Id, name,Property__r.House_Unit_No__c,Tower_Name__c,Opportunity__r.Owner.Email,Opportunity__r.Owner.MobilePhone,Project__r.Name,Future_Correspondence_Contact_Email__c,Future_Correspondence_Contact_Name__c
                                 From Booking__c  Where Id =: BookId];
        
        string subjectMail= 'Customer copy of Booking Form';
        string strHtmlBody = '';
        
            System.debug('app2Name:::::'+app2Name);
            strHtmlBody += 'Dear '+app1Name+', ';
                  if(app2Name != null && app2Name != ''){
                      strHtmlBody += ''+app2Name+', ';
                  }
                  if(app3Name != null && app3Name != ''){
                      strHtmlBody += ''+app3Name+', ';
                  }
                  if(app4Name != null && app4Name != ''){
                      strHtmlBody += ''+app4Name+', ';
                  }
                  if(app5Name != null && app5Name != ''){
                      strHtmlBody += ''+app5Name+', ';
                  }
            strHtmlBody +='<br/><br/>Congratulations on purchasing your home at '+BookEmail.Project__r.Name+' and thank you for choosing Oberoi Realty.<br/><br/>'+ 
                  'It was a pleasure interacting with you and assisting you through every step of this momentous journey.<br/><br/>'+ 
                  'Please find attached the copy of Booking Form for '+ BookEmail.Property__r.House_Unit_No__c +', '+ BookEmail.Tower_Name__c +' in '+ BookEmail.Project__r.Name +'.<br/><br/>'+
                  'Notes:<ul>'+
                  '<li>Applicable Taxes/ GST shall be levied as per existing rates and may be varied by the Government of India from time to time.</li>'+ 
                  '<li>Confirmation of booking is subject to clearance of the payment as part payment of Sale Price of the said premises. </li>'+
                  '<li>Terms and Conditions as set out in the Acceptance form are applicable.</li></ul>'+
                  'Should you need any further assistance, you may kindly contact me on '+BookEmail.Opportunity__r.Owner.MobilePhone+' or write to me at '+BookEmail.Opportunity__r.Owner.Email+'.<br/><br/>'+
                  'Thanks and Regards,<br/>'+
                  'Admin ';    
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setHtmlBody(strHtmlBody);
        
        list<string> lststringtoaddress=new  list<string>();
        list<string> lststringCCaddress=new  list<string>();
        system.debug('lststringtoaddress'+lststringtoaddress);
        
        lststringCCaddress.add('bhagyashri.gandhare@stetig.in');
        //lststringCCaddress.add(BookEmail.Owner.Email);
        lststringtoaddress.add(BookEmail.Future_Correspondence_Contact_Email__c);
        email.setToAddresses(lststringtoaddress);
        email.setCCAddresses(lststringCCaddress);
        email.setSubject(subjectMail);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        Messaging.sendEmail(new Messaging.Singleemailmessage[]{email});
        System.debug('After Mail Sent ');
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'Mail Send successfully.'));
        //PageReference pdf1 = new PageReference('/apex/Send_Email_to_Customer?id='+BookId);
        
    }
    public PageReference BackToBooking(){
        pageReference P = new pageReference('/'+ BookId);
        return P;
    }
    public Class PaymentWrapper{
        public string  pmode{get;set;}
        public string  payNo{get;set;}
        public string  pbankname{get;set;}
        public string  pbranch{get;set;}
        Public string  isdate{get;set;}
        Public string  wcheamount{get;set;}
        public string  cheamountword{get;set;}
        public Integer count{get;set;}
        
        public PaymentWrapper(){
         count=0;
         
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
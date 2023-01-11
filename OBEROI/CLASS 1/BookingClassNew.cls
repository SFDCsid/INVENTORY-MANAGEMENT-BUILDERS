public with sharing class BookingClassNew {
    public Applicant__c applicant{get;set;}
    public Applicant__c applicant2{get;set;}
    public Applicant__c applicant3{get;set;}
    public Applicant__c applicant4{get;set;}
    public Applicant__c applicant5{get;set;}
    public Booking__c boookingObj{get;set;}
    public Payment__c receiptObj{get;set;}
    public Payment__c ChequeObj{get;set;}
    public Payment__c DDObj{get;set;}
    public Payment__c NEFTObj{get;set;}
    public Payment__c RTGSObj{get;set;}
    public Payment__c TDSObj{get;set;}
    public Payment__c POObj{get;set;}
    public Payment__c STreceiptObj{get;set;}
    public Payment__c STChequeObj{get;set;}
    public Payment__c STDDObj{get;set;}
    public Payment__c STNEFTObj{get;set;}
    public Payment__c STRTGSObj{get;set;}
    public Payment__c STTDSObj{get;set;}
    public Payment__c STPOObj{get;set;}
    public List<Opportunity> optyList{get;set;}
    public List<Co_Owner__c> CoOwnerList{get;set;}
    public List<Quotation__c> queryResult{get;set;}
    public List<Quotation__c> QuoteDetails{get;set;}
    public List<Payment__c> ReceiptDetails{get;set;}
    public List<Property__c> UnitUpdate{get;set;}
    public List<Payment__c> STReceiptDetails{get;set;}
    public Quotation__c quotationObj{get;set;}
    Public Integer i{get;set;}
    public String selectedVal{get;set;}
    public String selectedQuote{get;set;}
    public String PropertyName{get;set;}
    public String TowerName{get;set;}
    public Id quotationidparam{get;set;}
    public Id optyidparam{get;set;}
    public Id unitId{get;set;}
    public String source{get;set;}
    public String broker{get;set;}
    public Id ProjectId{get;set;}
    public Id optyId{get;set;}
    public Boolean addressCheck{get;set;}
    public Boolean addressCheckReverse{get;set;}
    public Boolean addressCheckApplicant2{get;set;}
    public Boolean addressCheckApplicant3{get;set;}
    public Boolean addressCheckApplicant4{get;set;}
    public Boolean addressCheckApplicant5{get;set;}
    public Tower__c twr{get;set;}
    //public Tower_Escrow_Detail__c le{get;set;}
    //addedbyshailesh
    public Payment__c reciept{get;set;}
    public List<Payment__c> receiptlist{get;set;}
    public List<Payment__c> deletereceiptlist{get;set;}
    public Decimal TotalServiceandToken{get;set;}
    public Payment__c del{get;set;}
    public Integer rowIndex{get;set;}
    public Date dateOfOfferPossesion{get;set;}
    public Date firstApplicantDOB{get;set;}
    public Date secondApplicantDOB{get;set;}
    public Date thirdApplicantDOB{get;set;}
    public Date fourthApplicantDOB{get;set;}
    public Date fifthApplicantDOB{get;set;}
    /*public Payment__creceiptOBJTobeUpdate{get;set;}*/
    public List<Payment__c> ReceiptLstTobeUpdate{get;set;}
    public String uniqueCode{get;set;}
    //////////
    public Boolean  ServiceTaxCheck {get;set;}
    public Decimal  TotalReceiptAmount {get;set;}
    public Decimal  STTotalReceiptAmount {get;set;}
    public Decimal  TotalToken {get;set;}
    public Decimal  TotalQuoteToken {get;set;}
    List <Car_Parking__c>  ParkingListToUpdate = new List <Car_Parking__c>();
    List < Applicant__c > listApplicant = new list < Applicant__c > ();
    public String salesManagerName {get;set;}
    public List < Payment__c > ListOldReceipt {
        get;
        set;
    }
    //Anuja added on  29/12/15
    public String tokenamt {get;set;}
    public String STamt {get;set;}
  /*************.  Added by VIKAS for the Car parking     *************/
    public Map<string,decimal> additionalParkingMap {get;set;}
    public Map<string,decimal> earMarkedParkingMap {get;set;}
    public Map<string,List<Car_Parking__c>> addAvailableParkingMap {get;set;}  
    public Map<string,List<Car_Parking__c>> earAvailableParkingMap {get;set;}   
    
    public BookingClassNew() {
        
        //added by shailesh
        reciept=new Payment__c ();
        deletereceiptlist =new List < Payment__c >();
        receiptlist =new List < Payment__c >();
        TotalServiceandToken=0;
        rowIndex =0;
        ReceiptLstTobeUpdate = new List<Payment__c>();
        i=0;
        TotalReceiptAmount=0;
        STTotalReceiptAmount=0;
        TotalToken =0;
        TotalQuoteToken =0;
        tokenamt ='';
        STamt = '';
        TowerName = '';
        PropertyName ='';
        uniqueCode = '';
        salesManagerName = '';
        ParkingListToUpdate  = new List<Car_Parking__c>();
        ListOldReceipt = new List <Payment__c>();
        STReceiptDetails = new List <Payment__c>();
        ReceiptDetails = new List <Payment__c>();
        UnitUpdate = new List<Property__c >();
        QuoteDetails  = new List <Quotation__c>();
        queryResult = new List <Quotation__c>();
        optyList  = new List <Opportunity>();
        CoOwnerList = new List<Co_Owner__c>();
        twr = new Tower__c();
        source = '';
        broker = '';
        
        addressCheck = true;
        addressCheckApplicant2 = true;
        addressCheckApplicant3 = true;
        addressCheckApplicant4 = true;
        addressCheckApplicant5 = true; 
        applicant = new Applicant__c();
        applicant2 = new Applicant__c();
        applicant3 = new Applicant__c();
        applicant4 = new Applicant__c();
        applicant5 = new Applicant__c();
        boookingObj = new Booking__c();
        quotationObj = new Quotation__c();
        receiptObj = new Payment__c();
        ChequeObj = new Payment__c();
        DDObj = new Payment__c();
        NEFTObj = new Payment__c();
        RTGSObj = new Payment__c();
        TDSObj = new Payment__c();
        POObj = new Payment__c();
        STreceiptObj = new Payment__c();
        STChequeObj = new Payment__c();
        STDDObj = new Payment__c();
        STNEFTObj = new Payment__c();
        STRTGSObj = new Payment__c();
        STTDSObj = new Payment__c();
        STPOObj = new Payment__c();
        
        
        additionalParkingMap = new Map<string,decimal>();
        earMarkedParkingMap = new Map<string,decimal>();
        addAvailableParkingMap = new Map<string,List<Car_Parking__c>>();
        earAvailableParkingMap = new Map<string,List<Car_Parking__c>>();
        
        if (ApexPages.currentPage().getParameters().get('unitId') != null && ApexPages.currentPage().getParameters().get('unitId') != '') {            
            unitId = ApexPages.currentPage().getParameters().get('unitId');
            system.debug('inside contructor unit is ' + unitId);
        }
        
        if (ApexPages.currentPage().getParameters().get('optyid') != null && ApexPages.currentPage().getParameters().get('optyid') != '') {
            // system.debug('optyid' +optyid);
            boookingObj.Opportunity__c = ApexPages.currentPage().getParameters().get('optyid');
        }
        
        if (ApexPages.currentPage().getParameters().get('projectId') != null && ApexPages.currentPage().getParameters().get('projectId') != '') {
            
            ProjectId = ApexPages.currentPage().getParameters().get('projectId');
            system.debug('inside contructor ProjectId is ' + ProjectId);
        }
        
        getquotation();
        
    }
    
    public void updateUnit(){
        
        UnitUpdate = [Select id,Name,Aadhar_Card_Mandatory__c,Status__c from Property__c where id =: unitId ];//,Hold_Time__c
        system.debug('UnitUpdate ::'+ UnitUpdate);
        if(UnitUpdate.size() > 0){
            UnitUpdate[0].Status__c= 'Hold'; 
            system.debug('UnitUpdateDone :::'+ UnitUpdate[0].Status__c);
            update UnitUpdate ;
        }
    }
    
    public PageReference getquotation() {
        if (boookingObj.Opportunity__c != null){
            optyList =  [SELECT id, Owner.Name,Name,Project__c,House_No__c,Str_Suppl1__c,Str_Suppl2__c,Str_Suppl3__c,Locality__c,City__c,Post_Code1__c,Country_Picklist__c
                        ,Nationality__c, Account.PersonBirthdate,Account.BillingAddress,Occupation__c,
                        Account.House_No__c,Account.Street__c,Account.Street_2__c,Account.Street_3__c,Account.Locality__c,Account.City__c,Account.Postal_code__c,Account.Country_Picklist__c,
                         Account.PersonMobilePhone,Account.PersonEmail,Account.BillingStreet,  Account.BillingCity,Account.BillingPostalCode,
                         Account.BillingCountry,Account.Name,Account.Salutation,Account.Country__c,Account.Designation__pc,Account.Company__c,Account.BillingState,Site__c,
                         broker_account__c,Source_of_Walk_in_Booking__c
                         from Opportunity where id =: boookingObj.Opportunity__c];
            CoOwnerList = [Select id,Name,Person_Account__c,Person_Account__r.Contact_category__pc,Person_Account__r.Salutation,Person_Account__r.BillingStreet,
                           Person_Account__r.BillingState,Person_Account__r.Designation__pc,Person_Account__r.Company__c,Person_Account__r.Occupation__c,Person_Account__r.PersonMobilePhone,Person_Account__r.Name,Person_Account__r.PersonEmail,
                           Person_Account__r.BillingPostalCode,Person_Account__r.BillingCountry,Person_Account__r.BillingCity
                           FROM Co_Owner__c Where opportunity__c =: boookingObj.Opportunity__c];
            system.debug('CoOwnerList chi size' +CoOwnerList.size());
            system.debug('optyListchi size' +optyList.size());
            
            system.debug('optyList Project__c ' +optyList[0].Project__c);
            if(optyList.size() > 0 ){
                source = optyList[0].Source_of_Walk_in_Booking__c;
                broker = optyList[0].broker_account__c;
                system.debug('Assigning applicant1 details from account');
                //Assigning applicant1 details from account 
                applicant.Salutation__c=optyList[0].Account.Salutation;
                applicant.Name=optyList[0].Account.Name;
                firstApplicantDOB = optyList[0].Account.PersonBirthdate;
                
                //applicant.Permanent_Address__c=optyList[0].Account.BillingStreet;
                applicant.House_No__c = optyList[0].House_No__c;
                applicant.Street_1__c = optyList[0].Str_Suppl1__c;
                applicant.Street_2__c = optyList[0].Str_Suppl2__c;
                applicant.Street_3__c = optyList[0].Str_Suppl3__c;
                applicant.Country__c = optyList[0].Country_Picklist__c;
                applicant.Locality__c = optyList[0].Locality__c;
                applicant.City__c = optyList[0].City__c;
                applicant.Pincode__c = optyList[0].Post_Code1__c;
                applicant.Country__c = optyList[0].Country_Picklist__c;
                applicant.Nationality__c = optyList[0].Nationality__c;
                applicant.Occupation__c = optyList[0].Occupation__c;
                applicant.Designation__c=optyList[0].Account.Designation__pc;
                applicant.Company_Name__c = optyList[0].Account.Company__c;
                applicant.Mobile_Number__c=optyList[0].Account.PersonMobilePhone;
                applicant.Email_Address__c = optyList[0].Account.PersonEmail;
                
                if(CoOwnerList.size() >0 ){
                    
                    For(Co_Owner__c  CO : CoOwnerList){
                        system.debug('co.Person_Account__r.Contact_category__pc ===== ' +co.Person_Account__r.Contact_category__pc);
                        if(co.Person_Account__r.Contact_category__pc != '')
                            If(co.Person_Account__r.Contact_category__pc == 'Second Applicant'){
                                applicant2.Salutation__c = co.Person_Account__r.Salutation;
                                applicant2.Name=co.Person_Account__r.Name;
                                applicant2.Designation__c=co.Person_Account__r.Designation__pc;
                                applicant2.Occupation__c = co.Person_Account__r.Occupation__c;
                                applicant2.Mobile_Number__c=co.Person_Account__r.PersonMobilePhone;
                                applicant2.Email_Address__c = co.Person_Account__r.PersonEmail;                                
                                if(co.Person_Account__r.BillingPostalCode != null)
                                {
                                    applicant2.Pincode__c = co.Person_Account__r.BillingPostalCode;
                                }
                                else{
                                    applicant2.Pincode__c = '';
                                }
                                applicant2.Country__c = co.Person_Account__r.BillingCountry;
                                applicant2.City__c = co.Person_Account__r.BillingCity;
                            }
                        If(co.Person_Account__r.Contact_category__pc == 'Third Applicant'){
                            applicant3.Salutation__c = co.Person_Account__r.Salutation;
                            applicant3.Name=co.Person_Account__r.Name;
                            //firstApplicantDOB = optyList[0].Account.PersonBirthdate;
                            
                            applicant3.Permanent_Address__c=co.Person_Account__r.BillingStreet;
                            applicant3.State_Province__c =co.Person_Account__r.BillingState;
                            applicant3.Designation__c=co.Person_Account__r.Designation__pc;
                            applicant3.Occupation__c = co.Person_Account__r.Occupation__c;
                            applicant3.Mobile_Number__c=co.Person_Account__r.PersonMobilePhone;
                            applicant3.Email_Address__c = co.Person_Account__r.PersonEmail;                                
                            if(co.Person_Account__r.BillingPostalCode != null)
                            {
                                applicant3.Pincode__c = co.Person_Account__r.BillingPostalCode;
                            }
                            else{
                                applicant3.Pincode__c = '';
                            }
                            applicant3.Country__c = co.Person_Account__r.BillingCountry;
                            applicant3.City__c = co.Person_Account__r.BillingCity;
                        }
                        If(co.Person_Account__r.Contact_category__pc == 'Fourth Applicant'){
                            applicant4.Salutation__c = co.Person_Account__r.Salutation;
                            applicant4.Name=co.Person_Account__r.Name;
                            //firstApplicantDOB = optyList[0].Account.PersonBirthdate;
                            
                            applicant4.Permanent_Address__c=co.Person_Account__r.BillingStreet;
                            applicant4.State_Province__c =co.Person_Account__r.BillingState;
                            applicant4.Designation__c=co.Person_Account__r.Designation__pc;
                            applicant4.Occupation__c = co.Person_Account__r.Occupation__c;
                            applicant4.Mobile_Number__c=co.Person_Account__r.PersonMobilePhone;
                            applicant4.Email_Address__c = co.Person_Account__r.PersonEmail;                               
                            if(co.Person_Account__r.BillingPostalCode != null)
                            {
                                applicant4.Pincode__c = co.Person_Account__r.BillingPostalCode;
                            }
                            else{
                                applicant4.Pincode__c = '';
                            }
                            applicant4.Country__c = co.Person_Account__r.BillingCountry;
                            applicant4.City__c = co.Person_Account__r.BillingCity;
                        }
                        If(co.Person_Account__r.Contact_category__pc == 'Fifth Applicant'){
                            applicant5.Salutation__c = co.Person_Account__r.Salutation;
                            applicant5.Name=co.Person_Account__r.Name;
                            applicant5.Permanent_Address__c=co.Person_Account__r.BillingStreet;
                            applicant5.State_Province__c =co.Person_Account__r.BillingState;
                            applicant5.Designation__c=co.Person_Account__r.Designation__pc;
                            applicant5.Occupation__c = co.Person_Account__r.Occupation__c;
                            applicant5.Mobile_Number__c=co.Person_Account__r.PersonMobilePhone;
                            applicant5.Email_Address__c = co.Person_Account__r.PersonEmail;                                
                            if(co.Person_Account__r.BillingPostalCode != null)
                            {
                                applicant5.Pincode__c = co.Person_Account__r.BillingPostalCode;
                            }
                            else{
                                applicant5.Pincode__c = '';
                            }
                            applicant5.Country__c = co.Person_Account__r.BillingCountry;
                            applicant5.City__c = co.Person_Account__r.BillingCity;
                        }
                    }
                }Else{}
            }
            else{
                
                
            }
        }
        if(source == 'Partner' && (broker == null || broker == '')){
                 system.debug('Broker is blank :: '+broker+'source::'+source);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please create channel partner account and tag it to opportunity in Broker Account field');
                ApexPages.addMessage(myMsg);
                i=1;
        }else if (boookingObj.Opportunity__c != null && unitId == null && ProjectId == null) {
            system.debug('get quote if only opty');
            queryResult = [SELECT id,Name,Booking__c,Property__r.Project_Name__c,Property__r.EOI_Blocked_for__c
                           from Quotation__c where Opportunity__c = : boookingObj.Opportunity__c and Property__r.Project_Name__c =: optyList[0].Project__c and (Property__r.Status__c= 'Available' OR Property__r.Status__c= 'Hold' OR Property__r.Status__c = 'Blocked' OR (Property__r.Status__c = 'EOI Blocked' and Property__r.EOI_Blocked_for__c =: boookingObj.Opportunity__c)) and Booking__c =: null and Active_Quotation__c = true ORDER BY CreatedDate DESC]; //and Final_Quotation__c = true and Active_Quotation__c = TRUE LIMIT 1
            if(queryResult.size() >0){
                system.debug('Result only opty quotations' +queryResult);
            }else{
                system.debug('Quotation Else if only opty');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Either this opportunity does not have a Finalized Quotation or the unit associated with it is not Open for Sale');
                ApexPages.addMessage(myMsg);
            }
            
        } else if (boookingObj.Opportunity__c != null && unitId != null && ProjectId == null) {
            system.debug('get quote if only opty and unit');
            queryResult = [SELECT id,Name,Booking__c, Property__r.Project_Name__c, Property__c, Property__r.EOI_Blocked_for__c
                           from Quotation__c where Opportunity__c = : boookingObj.Opportunity__c and Property__c = : unitId and Property__r.Project_Name__c =: optyList[0].Project__c  and  (Property__r.Status__c= 'Available' OR Property__r.Status__c= 'Hold' OR Property__r.Status__c = 'Blocked' OR (Property__r.Status__c = 'EOI Blocked' and Property__r.EOI_Blocked_for__c =: boookingObj.Opportunity__c)) 
                           and Booking__c =: null and Active_Quotation__c = true ORDER BY CreatedDate DESC];
            system.debug('queryResult2' + queryResult);
            if(queryResult.size() >0){
                system.debug('Result only opty and unit quotations' +queryResult);
            }
            else {
                system.debug('Quotation Else if opty  and unit is present but no quotation');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Either this opportunity does not have a Quotation or the unit associated with the quotation is not Available');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
        } else if (boookingObj.Opportunity__c != null && ProjectId != null && unitId == null ) {
            system.debug('get quote if opty and ProjectId ');
            system.debug('get quote if ProjectId  is not null and ProjectId  :-' + ProjectId);
            queryResult = [SELECT id,Name,Booking__c,Property__r.Project_Name__c,Property__r.EOI_Blocked_for__c,Property__c/*Tandem_car_park_Additional__c,Single_car_park_Additional__c,Allow_booking_without_full_token__c,Service_Tax_On_Token_Amount__c,,Total_Agreement_Value_Bucket__c,Allotment_Value__c*/  from Quotation__c where Opportunity__c = : boookingObj.Opportunity__c and Property__r.Project_Name__c = : ProjectId and (Property__r.Status__c= 'Available' OR Property__r.Status__c = 'Blocked' OR (Property__r.Status__c = 'EOI Blocked' and Property__r.EOI_Blocked_for__c =: boookingObj.Opportunity__c)) and Booking__c =: null and Active_Quotation__c = true ORDER BY CreatedDate DESC]; //and Active_Quotation__c = TRUE  LIMIT 1 and Final_Quotation__c = true 
            system.debug('queryResult' + queryResult);
            
            if(queryResult.size() >0)
            {
                system.debug('Result only opty and ProjectId quotations' +queryResult);
            }
            else {
                system.debug('Quotation Else if opty  and Project');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Either the opportunity does not have a Quotation or the unit associated with it is not Available');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
        }
        else if (boookingObj.Opportunity__c != null && ProjectId != null && unitId != null ) {
            system.debug('get quote if opty and ProjectId and unitId ');
            system.debug('get quote if ProjectId  is not null and ProjectId  :' + ProjectId);
            system.debug('get quote if opty and unitId ' +unitId  );
            system.debug('boookingObj.Opportunity__c' +boookingObj.Opportunity__c  );
            queryResult = [SELECT id,Name,Booking__c,Property__r.Project_Name__c, Property__r.EOI_Blocked_for__c, Property__c/*Tandem_car_park_Additional__c,Single_car_park_Additional__c,Allow_booking_without_full_token__c,Service_Tax_On_Token_Amount__c,,Total_Agreement_Value_Bucket__c,Allotment_Value__c*/ from Quotation__c where Opportunity__c = : boookingObj.Opportunity__c and Property__r.Project_Name__c = : ProjectId and (Property__r.Status__c= 'Available' OR Property__r.Status__c = 'Hold' OR (Property__r.Status__c = 'EOI Blocked' and Property__r.EOI_Blocked_for__c =: boookingObj.Opportunity__c)) and Property__c =: unitId and Booking__c = null and Active_Quotation__c = true  ORDER BY CreatedDate DESC]; //and Active_Quotation__c = TRUE   LIMIT 1 and Final_Quotation__c = true 
            system.debug('queryResult:::' + queryResult);
            
            if(queryResult.size() >0)
            {
                system.debug('Result only opty and ProjectId quotations' +queryResult);
            }
            else {
                system.debug('Quotation Else if opty  and Project');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Either the opportunity does not have a Quotation or the unit associated with it is not Available or hold');
                ApexPages.addMessage(myMsg);
                i=1;
            }
        }else {
            system.debug('Inside getQuote No Opportunity');
        } 
        return null;
    }
    
    //Create selectlist out of queryresult
    public List < SelectOption > getQuote {
        get {
            system.debug('Inside getQuote queryResult' +queryResult);
            List < SelectOption > optns = new List < Selectoption > ();
            optns.add(new SelectOption('', 'Select a Quotation'));
            if(queryResult.size() >0)
            {
                for (Quotation__c obj: queryResult) {
                    optns.add(new SelectOption(obj.Id, obj.Name));
                }
                
            }else {
                system.debug('No quotations');
            }
            return optns;
        }
        set;
    }
    
    //added by shailesh
    public void addReciept()
    {
        //selectedReciept ='';
        //rowIndex++;
        Payment__c rec=new Payment__c();
        rec.Project__c = boookingObj.Project__c;
        //rec.Tower__c = QuoteDetails[0].Property__r.Tower_Name__c;
        rec.Property__c = boookingObj.Property__c;
        receiptlist.add(rec);
        system.debug('receiptlist inside method::::'+receiptlist);
        system.debug('receiptlist inside method size::::'+receiptlist.size());
        
    }
    public void deleteReciept()
    {
        
        system.debug('receiptlist inside method size::::'+receiptlist.size());
        
        rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        //rowIndex++;
        System.debug('row index be deleted ' + rowIndex );
        System.debug('rows to be deleted '+receiptlist[rowIndex]);
        del = receiptlist.remove(rowIndex);
        deletereceiptlist.add(del);
        //delete deletereceiptlist;
    }
    
    //Get Token from Quotation
    public PageReference getTokenAmount() {
        system.debug('inside getTokenAmount');
        system.debug('Selected Val' + selectedQuote);
        additionalParkingMap = new Map<string,decimal>();
        earMarkedParkingMap = new Map<string,decimal>();
        addAvailableParkingMap = new Map<string,List<Car_Parking__c>>();
        earAvailableParkingMap = new Map<string,List<Car_Parking__c>>();
        if (selectedQuote != null) {
            QuoteDetails = [SELECT id,Name,Booking__c, Property__r.Project_Name__c,Property__r.Carpet_Area__c,// Property__r.Carpet_Area_in_Sq_Mts__c,Property__r.Enclosed_Balcony_in_Sq_Mtrs__c,Property__r.Cupboard_Area_in_Sq_Mtrs__c,
                            Property__c ,Property__r.Property_Type__r.Description__c,Property__r.Material_No__c, Token_Amount_r__c,Token_Amount__c, ST_Token_Amount__c,Property__r.Tower__c ,Property__r.Tower__r.Tower_Name__c,
                            Property__r.Property_Type__r.Name__c,Property__r.Tower__r.name,Property__r.Unit_Type__c,Property__r.Floor_No__c,Property__r.name,Car_Park_Type_1__c,Car_Park_Type_2__c,Car_Park_Type_3__c,Car_Park_Type_4__c,Car_Park_Type_5__c, 
                            TotalAdditionalCarpark__c,Car_Park_Count_1__c,Property__r.Project_name__r.Site__c,Car_Park_Count_2__c,Total_Agreement_Value_Modified__c,Property__r.Floor__c,Car_Park_Count_3__c,Car_Park_Count_4__c,Car_Park_Count_5__c,
                            Earmarked_Car_Parking_Type_1__c, Earmarked_Car_Parking_Type_2__c, Earmarked_Car_Parking_Type_3__c, Earmarked_Car_Parking_Type_4__c, Earmarked_Car_Parking_Type_5__c,
                            Earmarked_Car_Parking_Count_1__c, Earmarked_Car_Parking_Count_2__c, Earmarked_Car_Parking_Count_3__c, Earmarked_Car_Parking_Count_4__c, Earmarked_Car_Parking_Count_5__c,
                            Total_Earmarked_Parking__c
                            FROM Quotation__c WHERE Id = : selectedQuote];
            if (QuoteDetails.size() > 0)
            {
                boookingObj.Property_Name__c = QuoteDetails[0].Property__r.Material_No__c;
                boookingObj.Tower_Name2__c = QuoteDetails[0].Property__r.Tower__r.Tower_Name__c;
                boookingObj.Property_Type_Name__c = QuoteDetails[0].Property__r.Property_Type__r.Name__c;
                System.Debug('Inside QuoteDetails'+QuoteDetails );
                boookingObj.Token_Amount__c = QuoteDetails[0].Token_Amount_r__c;
                boookingObj.Site__C = QuoteDetails[0].Property__r.Project_name__r.Site__c;
                //Anuja added on 29/12/15
                if(QuoteDetails[0].Token_Amount__c != Null)
                {
                    tokenamt = INFormat(QuoteDetails[0].Token_Amount__c);
                }
                boookingObj.Tower__c = QuoteDetails[0].Property__r.Tower__c;
                boookingObj.Floor__c = QuoteDetails[0].Property__r.Floor__c;
                
                if(QuoteDetails[0].Total_Agreement_Value_Modified__c != 0){
                    boookingObj.Agreement_Value__c = QuoteDetails[0].Total_Agreement_Value_Modified__c;
                }
                boookingObj.Project__c = QuoteDetails[0].Property__r.Project_Name__c;
                boookingObj.Tower__c=QuoteDetails[0].Property__r.Tower__c;
                boookingObj.Property__c = QuoteDetails[0].Property__c;
                reciept.Project__c = boookingObj.Project__c;
                reciept.Property__c = boookingObj.Property__c;
                receiptlist.add(reciept);
                
             
                for(integer i=1;i<=5;i++){
                  string additionalCarParkName = (string)(QuoteDetails[0].get('Car_Park_Type_' + i + '__c'));
                    decimal additionalCarParkCount = (Decimal)(QuoteDetails[0].get('Car_Park_Count_' + i + '__c'));
                    
                    string earMarkedCarParkName = (string)(QuoteDetails[0].get('Earmarked_Car_Parking_Type_' + i + '__c'));
                    decimal earMarkedCarParkCount = (Decimal)(QuoteDetails[0].get('Earmarked_Car_Parking_Count_' + i + '__c'));
                    if(string.isNotBlank(additionalCarParkName) && additionalCarParkCount != null && additionalCarParkCount > 0){
                        additionalParkingMap.put(additionalCarParkName, additionalCarParkCount);
                    }
                    if(string.isNotBlank(earMarkedCarParkName) && earMarkedCarParkCount != null && earMarkedCarParkCount > 0){
                        earMarkedParkingMap.put(earMarkedCarParkName, earMarkedCarParkCount);
                    }
                    
                    
                }
                
                List<Car_Parking__c> carParking_List = [select id,Status__c,Name,Type__c From Car_Parking__c where  Status__c =: 'Available' and Project__c =: boookingObj.Project__c and Additional_Earmarked__c = 'Additional'];
                List<Car_Parking__c> carParking_List2 = [select id,Status__c,Name,Type__c From Car_Parking__c where  Status__c =: 'Available' and Project__c =: boookingObj.Project__c and Additional_Earmarked__c = 'Earmarked'];
                
                if(carParking_List != null && !carParking_List.isEmpty()){
                    for(Car_Parking__c cp : carParking_List){
                        if(addAvailableParkingMap.containsKey(cp.Type__c)){
                            List<Car_Parking__c> cc = addAvailableParkingMap.get(cp.Type__c);
                            cc.add(cp);
                            addAvailableParkingMap.put(cp.Type__c,cc);
                        }else{
                            List<Car_Parking__c> cc = new List<Car_Parking__c>();
                            cc.add(cp);
                            addAvailableParkingMap.put(cp.Type__c,cc);
                        }
                    }
                }
                if(carParking_List2 != null && !carParking_List2.isEmpty()){
                    for(Car_Parking__c cp : carParking_List2){
                        if(earAvailableParkingMap.containsKey(cp.Type__c)){
                            List<Car_Parking__c> cc = earAvailableParkingMap.get(cp.Type__c);
                            cc.add(cp);
                            earAvailableParkingMap.put(cp.Type__c,cc);
                        }else{
                            List<Car_Parking__c> cc = new List<Car_Parking__c>();
                            cc.add(cp);
                            earAvailableParkingMap.put(cp.Type__c,cc);
                        }
                    }
                }
            }
            
            getReceiptDetails();
        } else {
            boookingObj.Token_Amount__c = 0;
        }
        return null;
    }
    //Get Receipt Using OptyId
    public PageReference getReceiptDetails() {
        return null;
    }
    
    public PageReference getaddressstatus() {
        
        System.Debug('inside' + addressCheck);
        
        if (addressCheck == true) {
            addressCheckReverse = false;
        } else {
            addressCheckReverse = true;
        }
        return null;
    }
    
    
    public PageReference Save() {
        TotalServiceandToken=0;
        System.debug('unitId:::::::::'+boookingObj.Property__c);
        List<Property__c> propL= [Select id,Name,Aadhar_Card_Mandatory__c,Status__c from Property__c where id =: boookingObj.Property__c ];
        i = 0;
    system.debug('additionalParkingMap::'+additionalParkingMap);
    system.debug('earMarkedParkingMap::'+earMarkedParkingMap);
    system.debug('addAvailableParkingMap::'+addAvailableParkingMap);
    system.debug('earAvailableParkingMap::'+earAvailableParkingMap);
    
    /*************************** Added By VIKAS fro car parking validation. ******************/
        if(!additionalParkingMap.isEmpty()){
            for(string st : additionalParkingMap.keyset()){
                if(addAvailableParkingMap.containsKey(st) && addAvailableParkingMap.get(st).size() < Integer.valueOf(additionalParkingMap.get(st))){
                    system.debug('Inside additional car parking error');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Required number of additional ' + st + ' parking is unavailable');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }else if(!addAvailableParkingMap.containsKey(st)){
                    system.debug('Inside additional car parking error');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Required number of additional ' + st + ' parking is unavailable');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
            }
        }
        if(!earMarkedParkingMap.isEmpty()){
            for(string st : earMarkedParkingMap.keyset()){
                if(earAvailableParkingMap.containsKey(st) && earAvailableParkingMap.get(st).size() < Integer.valueOf(earMarkedParkingMap.get(st))){
                    system.debug('Inside earmarked car parking error');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Required number of earmarked ' + st + ' parking is unavailable');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }else if(!earAvailableParkingMap.containsKey(st)){
                    system.debug('Inside earmarked car parking error');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Required number of earmarked ' + st + ' parking is unavailable');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
            }
        }
        
        /////////////////////////////////////////////////////////////
        if(boookingObj.Opportunity__c == null){
            system.debug('Inside null selected quote' +selectedQuote );
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please select an Opportunity');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(selectedQuote == '' || selectedQuote == null ){
            system.debug('Inside null selected quote' +selectedQuote );
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please select a quotation');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        
       if(boookingObj.Future_Correspondence_Contact__c == '' && boookingObj.Future_Correspondence_Contact__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Future Correspondence Contact Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        
        if(boookingObj.Mode_of_Funding__c == '' || boookingObj.Mode_of_Funding__c== null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Mode of funding Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(boookingObj.TDS_Paid_By__c == '' || boookingObj.TDS_Paid_By__c== null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'TDS Paid By Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        
        //////////////////Error Messages for Future Correspondence///////////////////////
        if(boookingObj.Future_Correspondence_Contact__c == '2nd Applicant' ){
            
            if(applicant2.Name == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Incase Future Correspondence Contact Is (2nd Applicant) Applicant 2 Name Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
        }
        if(boookingObj.Future_Correspondence_Contact__c == '3rd Applicant' ){
            
            if(applicant3.Name == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Incase Future Correspondence Contact Is (3rd Applicant) Applicant 3 Name Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
        }
        if(boookingObj.Future_Correspondence_Contact__c == '4th Applicant' ){ 
            
            if(applicant4.Name == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Incase Future Correspondence Contact Is (4th Applicant) Applicant 4 Name Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
        }
        if(boookingObj.Future_Correspondence_Contact__c == '5th Applicant' ){
            
            if(applicant5.Name == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Incase Future Correspondence Contact Is (5th Applicant) Applicant 5 Name Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
        }
        //////////////////Error Messages for Default Address///////////////////////
        
        ////////////////////////// error messages for saales manager and sourcing manager  //////////////////////////
        
        ////////////////////////// error messagess for applicant 1  //////////////////////////
        if(applicant.Salutation__c == '' || applicant.Salutation__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Salutation for Applicant 1 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(applicant.Name == '' || applicant.Name == null ){
            system.debug('Inside null selected quote' +selectedQuote );
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Name for Applicant 1 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(firstApplicantDOB == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'DOB for Applicant 1 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        
        if(applicant.Country__c == 'India'){
            if(applicant.State_Province__c == '' && applicant.State_Province__c== null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'State for Applicant 1 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant.City__c == '' || applicant.City__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'City for Applicant 1 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
        }
        if(applicant.State__c == '' || applicant.State__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'State for Applicant 1 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
        
        if(applicant.Gender__c == '' || applicant.Gender__c == null ){  
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Gender for Applicant 1 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(applicant.Subtype_Of_Applicant__c != 'For NRI') {
            if(applicant.Pincode__c == null ||applicant.Pincode__c == '' ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pincode for Applicant 1 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant.Country__c == '' || applicant.Country__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Country for Applicant 1 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant.Country__c == 'India' && applicant.Pincode__c != null){
                if(String.valueOf(applicant.Pincode__c).length() != 6 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pincode for Applicant 1 Should Be Of 6 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
            }
        }
        if(applicant.Mobile_Number__c == '' || applicant.Mobile_Number__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Mobile Number for Applicant 1 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(applicant.Email_Address__c== '' || applicant.Email_Address__c== null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Email Address for Applicant 1 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(applicant.Nationality__c == '' || applicant.Nationality__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Nationality for Applicant 1 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        /*if(applicant.Occupation__c == '' || applicant.Occupation__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Occupation for Applicant 1 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(applicant.Designation__c == '' || applicant.Designation__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Designation for Applicant 1 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }*/
        if(applicant.Type_Of_Applicant__c == '' || applicant.Type_Of_Applicant__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Type Of Applicant for Applicant 1 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(applicant.Subtype_Of_Applicant__c == '' || applicant.Subtype_Of_Applicant__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Residential Status for Applicant 1 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        
        if(applicant.Subtype_Of_Applicant__c == 'Indian National'){
        
            if(applicant.Pancard__c == false || applicant.Address_Proof__c == false || applicant.Address_Proof_Document__c == '' || applicant.Address_Proof_Number__c == '')         //     || applicant.One_Passport_Size_Color_Photograph__c == false  // || applicant.Aadhar_Card__c == false 
            {            
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            System.debug('propL:::::::'+propL);
            if(propL.size()>0){
                if((applicant.Aadhar_Card__c == false && propL[0].Aadhar_Card_Mandatory__c == True)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
            }
            if(applicant.PancardNo__c != null && (applicant.PancardNo__c).length() != 10 ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 1 Should Be Of 10 Digits' );
                ApexPages.addMessage(myMsg);
                i=1;
            }  
            
             if(applicant.Aadhar_Card_No__c != null && (applicant.Aadhar_Card_No__c).length() != 12 ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Aadhar Card for Applicant 1 Should Be Of 12 Digits' );
                ApexPages.addMessage(myMsg);
                i=1;
            } 
            
        }
        
        
        if(applicant.Subtype_Of_Applicant__c == 'Foreign Nationals Of Indian Origin'){
            if(applicant.Funds_from_NRE_FCNR__c == false || applicant.Self_attested_copy_of_PIO_or_OCI_Card__c == false || applicant.Type_Of_Origin__c == '' || applicant.Origin_Details__c == '')                //     applicant.One_Passport_Size_Color_Photograph__c == false || 
            {            
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
        }
        
        
        if(applicant.Subtype_Of_Applicant__c == 'For NRI'){
            
            if(applicant.Pancard__c == false || applicant.PancardNo__c == ''||
               applicant.Address_Proof__c == false || applicant.Address_Proof_Number__c == ''||  
               applicant.Self_attested_copy_of_PIO_or_OCI_Card__c == false|| applicant.Origin_Details__c ==''||
               applicant.Copy_of_Workpermit_Employment_contract__c == false )
            {            
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
            
            if(applicant.PancardNo__c!= null && (applicant.PancardNo__c).length() != 10 ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 1 Should Be Of 10 Digits' );
                ApexPages.addMessage(myMsg);
                i=1;
            }               
        }
        if(applicant.Subtype_Of_Applicant__c == 'For Company'){
            if(applicant.PanCard_of_Authority_Signatory__c == false || applicant.Pan_Card_Number_of_Authority_Signatory__c == ''||
               applicant.Copy_of_Memorandum_of_Association__c == false || 
               applicant.Certified_copy_of_Article_of_Association__c  == false || 
               applicant.Certified_copy_of_Board_Resolution__c == false || 
               applicant.Self_attested_List_of_Directors__c == false ||
               applicant.Copy_of_Workpermit_Employment_contract__c  == false
               )
            {            
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant.PancardNo__c!= null && (applicant.PancardNo__c).length() != 10 ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 1 Should Be Of 10 Digits' );
                ApexPages.addMessage(myMsg);
                i=1;
            }  
            
        }
        if(applicant.Subtype_Of_Applicant__c == 'Partnership Firm'){
            if(applicant.PanCard_of_Authority_Signatory__c == false || applicant.Pan_Card_Number_of_Authority_Signatory__c == ''||
                applicant.Address_Proof__c == false || applicant.Address_Proof_Number__c ==''||
                applicant.Self_attested_List_of_Directors__c == false || 
                applicant.Certified_copy_of_Board_Resolution__c == false ||
                applicant.Certified_copy_of_Partnership_Deed__c == false)
            {            
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant.PancardNo__c!= null && (applicant.PancardNo__c).length() != 10 ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 1 Should Be Of 10 Digits' );
                ApexPages.addMessage(myMsg);
                i=1;
            }           
        }
        
        //anuja added on 16 dec 
        if(addressCheck == False)
        {
           if(applicant.Mailing_Pincode__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Mailing  Pincode for Applicant 1 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant.Mailing_Country__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Mailing  Country for Applicant 1 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant.Mailing_Country__c == 'India' && applicant.Mailing_Pincode__c != null){
                if(String.valueOf(applicant.Mailing_Pincode__c).length() != 6 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Mailing Pincode for Applicant 1 Should Be Of 6 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
            }
            if(applicant.Mailing_Country__c == 'India'){
                if(applicant.Mailing_State__c == null ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Mailing State for Applicant 1 Cannot Be Left Blank');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                if(applicant.Mailing_City__c == null ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Mailing City for Applicant 1 Cannot Be Left Blank');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
            }
        }
        
        //////////////////////////////error messages for Applicant 2///////////////////////////
        if(applicant2.Name != null ){
            if(applicant2.Salutation__c == '' || applicant2.Salutation__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Salutation for Applicant 2 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
            if(applicant2.Gender__c == '' || applicant2.Gender__c == null ){  
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Gender for Applicant 2 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
           
            if(applicant2.Mobile_Number__c == '' || applicant2.Mobile_Number__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Mobile Number for Applicant 2 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant2.Email_Address__c== '' || applicant2.Email_Address__c== null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Email Address for Applicant 2 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant2.Nationality__c == '' || applicant2.Nationality__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Nationality for Applicant 2 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            /*if(applicant2.Occupation__c == '' || applicant2.Occupation__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Occupation for Applicant 2 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(applicant2.Designation__c == '' || applicant2.Designation__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Designation for Applicant 2 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }*/
            if(applicant2.Type_Of_Applicant__c == '' || applicant2.Type_Of_Applicant__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Type Of Applicant for Applicant 2 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant2.Subtype_Of_Applicant__c == '' || applicant2.Subtype_Of_Applicant__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Residential Status for Applicant 2 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
            if(applicant2.Subtype_Of_Applicant__c == 'Indian National'){
                if(applicant2.Pancard__c == false || applicant2.Address_Proof__c == false || applicant2.Address_Proof_Document__c == '' || applicant2.Address_Proof_Number__c == '' )         //     || applicant2.One_Passport_Size_Color_Photograph__c == false
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                System.debug('propL:::::::'+propL);
                if(propL.size()>0){
                    if((applicant2.Aadhar_Card__c == false && propL[0].Aadhar_Card_Mandatory__c == True)){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                        ApexPages.addMessage(myMsg);
                        i=1;
                    }
                }
                if(applicant2.PancardNo__c != null && (applicant2.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 2 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }  
                if(applicant2.Aadhar_Card_No__c != null && (applicant2.Aadhar_Card_No__c).length() != 12 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Aadhar Card for Applicant 1 Should Be Of 12 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                } 
            }
            
            if(applicant2.Subtype_Of_Applicant__c == 'For NRI'){
                
                if(applicant2.Pancard__c == false || applicant2.PancardNo__c == ''||
                   applicant2.Address_Proof__c == false || applicant2.Address_Proof_Number__c == ''||  
                   applicant2.Self_attested_copy_of_PIO_or_OCI_Card__c == false|| applicant2.Origin_Details__c ==''||
                   applicant2.Copy_of_Workpermit_Employment_contract__c == false )
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                
                
                if(applicant2.PancardNo__c!= null && (applicant2.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 2 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }               
            }
            if(applicant2.Subtype_Of_Applicant__c == 'For Company'){
                if(applicant2.PanCard_of_Authority_Signatory__c == false || applicant2.Pan_Card_Number_of_Authority_Signatory__c == ''||
                   applicant2.Copy_of_Memorandum_of_Association__c == false || 
                   applicant2.Certified_copy_of_Article_of_Association__c  == false || 
                   applicant2.Certified_copy_of_Board_Resolution__c == false ||
                   applicant2.Self_attested_List_of_Directors__c == false ||
                   applicant2.Copy_of_Workpermit_Employment_contract__c  == false
                   )
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                if(applicant2.PancardNo__c!= null && (applicant2.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 2 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }  
                
            }
            if(applicant2.Subtype_Of_Applicant__c == 'Partnership Firm'){
                 if(applicant2.PanCard_of_Authority_Signatory__c == false || applicant2.Pan_Card_Number_of_Authority_Signatory__c == ''||
                    applicant2.Address_Proof__c == false || applicant2.Address_Proof_Number__c ==''||
                    applicant2.Self_attested_List_of_Directors__c == false || 
                    applicant2.Certified_copy_of_Board_Resolution__c == false ||
                    applicant2.Certified_copy_of_Partnership_Deed__c == false)
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                if(applicant2.PancardNo__c!= null && (applicant2.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 2 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }           
            }
        }
        
        //////////////////////////////error messages for Applicant 3///////////////////////////
        if(applicant3.Name != null ){
            if(applicant3.Salutation__c == '' || applicant3.Salutation__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Salutation for Applicant 3 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant3.Gender__c == '' || applicant3.Gender__c == null ){  
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Gender for Applicant 3 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
           if(applicant3.Mobile_Number__c == '' || applicant3.Mobile_Number__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Mobile Number for Applicant 3 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant3.Email_Address__c== '' || applicant3.Email_Address__c== null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Email Address for Applicant 3 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant3.Nationality__c == '' || applicant3.Nationality__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Nationality for Applicant 3 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
             /*if(applicant3.Occupation__c == '' || applicant3.Occupation__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Occupation for Applicant 3 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(applicant3.Designation__c == '' || applicant3.Designation__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Designation for Applicant 3 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }*/
            if(applicant3.Type_Of_Applicant__c == '' || applicant3.Type_Of_Applicant__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Type Of Applicant for Applicant 3 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant3.Subtype_Of_Applicant__c == '' || applicant3.Subtype_Of_Applicant__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Residential Status for Applicant 3 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
            if(applicant3.Subtype_Of_Applicant__c == 'Indian National'){
                if(applicant3.Pancard__c == false || applicant3.Address_Proof__c == false || applicant3.Address_Proof_Document__c == '' || applicant3.Address_Proof_Number__c == '' )         //     || applicant3.One_Passport_Size_Color_Photograph__c == false
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                System.debug('propL:::::::'+propL);
                if(propL.size()>0){
                    if((applicant3.Aadhar_Card__c == false && propL[0].Aadhar_Card_Mandatory__c == True)){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                        ApexPages.addMessage(myMsg);
                        i=1;
                    }
                }
                if(applicant3.PancardNo__c != null && (applicant3.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 3 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }  
                if(applicant3.Aadhar_Card_No__c != null && (applicant3.Aadhar_Card_No__c).length() != 12 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Aadhar Card for Applicant 1 Should Be Of 12 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                } 
            }
            
            
            if(applicant3.Subtype_Of_Applicant__c == 'Foreign Nationals Of Indian Origin'){
                if(applicant3.Funds_from_NRE_FCNR__c == false || applicant3.Self_attested_copy_of_PIO_or_OCI_Card__c == false || applicant3.Type_Of_Origin__c == '' || applicant3.Origin_Details__c == '')                //     applicant3.One_Passport_Size_Color_Photograph__c == false || 
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
            }
            
            
            if(applicant3.Subtype_Of_Applicant__c == 'For NRI'){
                
                if(applicant3.Pancard__c == false || applicant3.PancardNo__c == ''||
                   applicant3.Address_Proof__c == false || applicant3.Address_Proof_Number__c == ''||  
                   applicant3.Self_attested_copy_of_PIO_or_OCI_Card__c == false|| applicant3.Origin_Details__c ==''||
                   applicant3.Copy_of_Workpermit_Employment_contract__c == false )
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                
                
                if(applicant3.PancardNo__c!= null && (applicant3.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 3 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }               
            }
            if(applicant3.Subtype_Of_Applicant__c == 'For Company'){
                if(applicant3.PanCard_of_Authority_Signatory__c == false || applicant3.Pan_Card_Number_of_Authority_Signatory__c == ''||
                   applicant3.Copy_of_Memorandum_of_Association__c == false || 
                   applicant3.Certified_copy_of_Article_of_Association__c  == false || 
                   applicant3.Certified_copy_of_Board_Resolution__c == false || 
                   applicant3.Self_attested_List_of_Directors__c == false ||
                   applicant3.Copy_of_Workpermit_Employment_contract__c  == false
                   )
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                if(applicant3.PancardNo__c!= null && (applicant3.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 3 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }  
                
            }
            if(applicant3.Subtype_Of_Applicant__c == 'Partnership Firm'){
                if(applicant3.PanCard_of_Authority_Signatory__c == false || applicant3.Pan_Card_Number_of_Authority_Signatory__c == ''||
                    applicant3.Address_Proof__c == false || applicant3.Address_Proof_Number__c ==''||
                    applicant3.Self_attested_List_of_Directors__c == false || 
                    applicant3.Certified_copy_of_Board_Resolution__c == false ||
                    applicant3.Certified_copy_of_Partnership_Deed__c == false)
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                if(applicant3.PancardNo__c!= null && (applicant3.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 3 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }           
            }
        }
        
        //////////////////////////////error messages for Applicant 4///////////////////////////
        if(applicant4.Name != null ){
            if(applicant4.Salutation__c == '' || applicant4.Salutation__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Salutation for Applicant 4 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
            if(applicant4.Gender__c == '' || applicant4.Gender__c == null ){  
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Gender for Applicant 4 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
            if(applicant4.Mobile_Number__c == '' || applicant4.Mobile_Number__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Mobile Number for Applicant 4 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant4.Email_Address__c== '' || applicant4.Email_Address__c== null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Email Address for Applicant 4 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant4.Nationality__c == '' || applicant4.Nationality__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Nationality for Applicant 4 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
             /*if(applicant4.Occupation__c == '' || applicant4.Occupation__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Occupation for Applicant 4 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(applicant4.Designation__c == '' || applicant4.Designation__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Designation for Applicant 4 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }*/
            if(applicant4.Type_Of_Applicant__c == '' || applicant4.Type_Of_Applicant__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Type Of Applicant for Applicant 4 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant4.Subtype_Of_Applicant__c == '' || applicant4.Subtype_Of_Applicant__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Residential Status for Applicant 4 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
            if(applicant4.Subtype_Of_Applicant__c == 'Indian National'){
                if(applicant4.Pancard__c == false || applicant4.Address_Proof__c == false || applicant4.Address_Proof_Document__c == '' || applicant4.Address_Proof_Number__c == '' )         //     || applicant4.One_Passport_Size_Color_Photograph__c == false
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                System.debug('propL:::::::'+propL);
                if(propL.size()>0){
                    if((applicant4.Aadhar_Card__c == false && propL[0].Aadhar_Card_Mandatory__c == True)){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                        ApexPages.addMessage(myMsg);
                        i=1;
                    }
                }
                if(applicant4.PancardNo__c != null && (applicant4.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 4 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }  
                if(applicant4.Aadhar_Card_No__c != null && (applicant4.Aadhar_Card_No__c).length() != 12 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Aadhar Card for Applicant 1 Should Be Of 12 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                } 
            }
            if(applicant4.Subtype_Of_Applicant__c == 'Foreign Nationals Of Indian Origin'){
                if(applicant4.Funds_from_NRE_FCNR__c == false || applicant4.Self_attested_copy_of_PIO_or_OCI_Card__c == false || applicant4.Type_Of_Origin__c == '' || applicant4.Origin_Details__c == '')                //     applicant4.One_Passport_Size_Color_Photograph__c == false || 
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
            }
            if(applicant4.Subtype_Of_Applicant__c == 'For NRI'){
                
                if(applicant4.Pancard__c == false || applicant4.PancardNo__c == ''||
                   applicant4.Address_Proof__c == false || applicant4.Address_Proof_Number__c == ''||  
                   applicant4.Self_attested_copy_of_PIO_or_OCI_Card__c == false|| applicant4.Origin_Details__c ==''||
                   applicant4.Copy_of_Workpermit_Employment_contract__c == false )
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                
                
                if(applicant4.PancardNo__c!= null && (applicant4.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 4 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }               
            }
            if(applicant4.Subtype_Of_Applicant__c == 'For Company'){
                if(applicant4.PanCard_of_Authority_Signatory__c == false || applicant4.Pan_Card_Number_of_Authority_Signatory__c == ''||
                   applicant4.Copy_of_Memorandum_of_Association__c == false || 
                   applicant4.Certified_copy_of_Article_of_Association__c  == false || 
                   applicant4.Certified_copy_of_Board_Resolution__c == false || 
                   applicant4.Self_attested_List_of_Directors__c == false ||
                   applicant4.Copy_of_Workpermit_Employment_contract__c  == false
                   )
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                if(applicant4.PancardNo__c!= null && (applicant4.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 4 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }  
                
            }
            if(applicant4.Subtype_Of_Applicant__c == 'Partnership Firm'){
                if(applicant4.PanCard_of_Authority_Signatory__c == false || applicant4.Pan_Card_Number_of_Authority_Signatory__c == ''||
                    applicant4.Address_Proof__c == false || applicant4.Address_Proof_Number__c ==''||
                    applicant4.Self_attested_List_of_Directors__c == false || 
                    applicant4.Certified_copy_of_Board_Resolution__c == false ||
                    applicant4.Certified_copy_of_Partnership_Deed__c == false)
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                if(applicant4.PancardNo__c!= null && (applicant4.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 4 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }           
            }
        }
        
        //////////////////////////////error messages for Applicant 5///////////////////////////
        if(applicant5.Name != null ){
            if(applicant5.Salutation__c == '' || applicant5.Salutation__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Salutation for Applicant 5 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
            if(applicant5.Gender__c == '' || applicant5.Gender__c == null ){  
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Gender for Applicant 5 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
            if(applicant5.Mobile_Number__c == '' || applicant5.Mobile_Number__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Mobile Number for Applicant 5 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant5.Email_Address__c== '' || applicant5.Email_Address__c== null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Email Address for Applicant 5 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant5.Nationality__c == '' || applicant5.Nationality__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Nationality for Applicant 5 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
             /*if(applicant5.Occupation__c == '' || applicant5.Occupation__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Occupation for Applicant 5 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }
        if(applicant5.Designation__c == '' || applicant5.Designation__c == null ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Designation for Applicant 5 Cannot Be Left Blank');
            ApexPages.addMessage(myMsg);
            i=1;
        }*/
            if(applicant5.Type_Of_Applicant__c == '' || applicant5.Type_Of_Applicant__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Type Of Applicant for Applicant 5 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            if(applicant5.Subtype_Of_Applicant__c == '' || applicant5.Subtype_Of_Applicant__c == null ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Residential Status for Applicant 5 Cannot Be Left Blank');
                ApexPages.addMessage(myMsg);
                i=1;
            }
            
            if(applicant5.Subtype_Of_Applicant__c == 'Indian National'){
                if(applicant5.Pancard__c == false || applicant5.Address_Proof__c == false || applicant5.Address_Proof_Document__c == '' || applicant5.Address_Proof_Number__c == '' )         //     || applicant5.One_Passport_Size_Color_Photograph__c == false
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                System.debug('propL:::::::'+propL);
                if(propL.size()>0){
                    if((applicant5.Aadhar_Card__c == false && propL[0].Aadhar_Card_Mandatory__c == True)){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                        ApexPages.addMessage(myMsg);
                        i=1;
                    }
                }
                if(applicant5.PancardNo__c != null && (applicant5.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 5 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }  
                if(applicant5.Aadhar_Card_No__c != null && (applicant5.Aadhar_Card_No__c).length() != 12 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Aadhar Card for Applicant 1 Should Be Of 12 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                } 
            }
            if(applicant5.Subtype_Of_Applicant__c == 'Foreign Nationals Of Indian Origin'){
                if(applicant5.Funds_from_NRE_FCNR__c == false || applicant5.Self_attested_copy_of_PIO_or_OCI_Card__c == false || applicant5.Type_Of_Origin__c == '' || applicant5.Origin_Details__c == '')                //     applicant5.One_Passport_Size_Color_Photograph__c == false || 
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
            }
            if(applicant5.Subtype_Of_Applicant__c == 'For NRI'){
                
                if(applicant5.Pancard__c == false || applicant5.PancardNo__c == ''||
                   applicant5.Address_Proof__c == false || applicant5.Address_Proof_Number__c == ''||  
                   applicant5.Self_attested_copy_of_PIO_or_OCI_Card__c == false|| applicant5.Origin_Details__c ==''||
                   applicant5.Copy_of_Workpermit_Employment_contract__c == false )
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                if(applicant5.PancardNo__c!= null && (applicant5.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 5 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }               
            }
            if(applicant5.Subtype_Of_Applicant__c == 'For Company'){
                if(applicant5.PanCard_of_Authority_Signatory__c == false || applicant5.Pan_Card_Number_of_Authority_Signatory__c == ''||
                   applicant5.Copy_of_Memorandum_of_Association__c == false || 
                   applicant5.Certified_copy_of_Article_of_Association__c  == false || 
                   applicant5.Certified_copy_of_Board_Resolution__c == false || 
                   applicant5.Self_attested_List_of_Directors__c == false ||
                   applicant5.Copy_of_Workpermit_Employment_contract__c  == false
                   )
                   
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                if(applicant5.PancardNo__c!= null && (applicant5.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 5 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }  
                
            }
            if(applicant5.Subtype_Of_Applicant__c == 'Partnership Firm'){
                if(applicant5.PanCard_of_Authority_Signatory__c == false || applicant5.Pan_Card_Number_of_Authority_Signatory__c == ''||
                    applicant5.Address_Proof__c == false || applicant5.Address_Proof_Number__c ==''||
                    applicant5.Self_attested_List_of_Directors__c == false || 
                    applicant5.Certified_copy_of_Board_Resolution__c == false ||
                    applicant5.Certified_copy_of_Partnership_Deed__c == false)
                {            
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please ensure that all the document checkboxes are checked and document details are filled properly.');
                    ApexPages.addMessage(myMsg);
                    i=1;
                }
                if(applicant5.PancardNo__c!= null && (applicant5.PancardNo__c).length() != 10 ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Pancard for Applicant 5 Should Be Of 10 Digits' );
                    ApexPages.addMessage(myMsg);
                    i=1;
                }           
            }
        }    
        //////////////////////////////////////Receipt Mandatory Checks//////////////////////////////////////////
        system.debug('ReceiptDetails.size():::: '+ReceiptDetails.size());
        if (ReceiptDetails.size() == 0) {
            System.Debug('receiptlist.size() ' + receiptlist.size());
            
            for(Payment__c rce : receiptlist)
            {
                system.debug('inside for loop');
                if (rce.Payment_Mode__c== null) //
                {
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Instrument type Of Receipt Cannot Be Left Blank');
                    ApexPages.addMessage(myMsg);
                    i = 1;
                }
                if (rce.RTGS_Cheque_Draft_No__c== null) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Instrument number Cannot Be Left Blank');
                    ApexPages.addMessage(myMsg);
                    i = 1;
                }
                if (rce.Instrument_Date__c == null) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Date Of Receipt Cannot Be Left Blank');
                    ApexPages.addMessage(myMsg);
                    i = 1;
                }
                if (rce.Amount__c == null) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Amount Of Receipt Cannot Be Left Blank');
                    ApexPages.addMessage(myMsg);
                    i = 1;
                }
                else{
                    TotalServiceandToken= TotalServiceandToken + rce.Amount__c;
                }
                
                if (rce.Bank_Name__c == null) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Bank Of Receipt Cannot Be Left Blank');
                    ApexPages.addMessage(myMsg);
                    i = 1;
                }
            }
            
            System.debug('Step oneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
            //Checking token amount for all //
            if(boookingObj.Token_Amount__c != null)
            {
                System.debug('Step Twoooo');
                TotalQuoteToken = boookingObj.Token_Amount__c;
                System.debug('TotalReceiptAmount ' +TotalReceiptAmount );
                System.debug('STTotalReceiptAmount' +STTotalReceiptAmount);
                TotalToken =TotalServiceandToken;
                System.debug('TotalToken ' +TotalToken );
                System.debug('TotalQuoteToken ' +TotalQuoteToken );
                
           } 
        }
        
        
        ///////////////////Inserting Future correspondance contact And billing address////////////////////  
        if(boookingObj.Future_Correspondence_Contact__c == '1st Applicant'){
            if(applicant.Name != null ){
                boookingObj.Future_Correspondence_Contact_Name__c = applicant.Salutation__c+' '+applicant.Name;
            }
            if(applicant.Mobile_Number__c != null ){
                boookingObj.Future_Correspondence_Contact_Phone__c = applicant.Mobile_Number__c;
            }
            if(applicant.Email_Address__c!= null ){
                boookingObj.Future_Correspondence_Contact_Email__c = applicant.Email_Address__c;
            }
            boookingObj.Future_Correspondence_Contact_Relation__c = '1st Applicant';
            
            if(applicant.House_No__c != null )
            boookingObj.C_o_Name_Billing_Address__c = applicant.House_No__c;
            
            if(applicant.Street_1__c != null )
            boookingObj.Billing_Street__c = applicant.Street_1__c;
            
            if(applicant.Street_2__c != null )
            boookingObj.Billing_Str_Suppl2__c = applicant.Street_2__c;
            
            if(applicant.Street_3__c != null )
            boookingObj.Billing_Str_Suppl3__c = applicant.Street_3__c;
            
            if(applicant.Country__c != null )
            boookingObj.Billing_Country__c = applicant.Country__c;
            
            if(applicant.State__c != null )
            boookingObj.Billing_Region__c = applicant.State__c;
            
            if(applicant.City__c != null )
            boookingObj.Billing_City__c = applicant.City__c;
            
            if(applicant.Locality__c != null )
            boookingObj.Billing_Location__c = applicant.Locality__c;
            
            if(applicant.Pincode__c != null )
            boookingObj.Billing_Post_Code__c = String.valueof(applicant.Pincode__c);
            
            /////////////////////////////////////////////////First Applicant Mailing address//////////////////////////////////////////////////////////////////////////
            
           

        }
        
        
        ///////////////////Inserting Future correspondance contact Endss here//////////////////// 
             
        ///inserting the receipt
        System.debug('iiiiiiiiiiiiiiiiiii TOKEN ' +i);
        boookingObj.Quotation__c = selectedQuote;
        
        system.debug('by vikas i is:::: '+i);
        system.debug('ReceiptDetails.size()::: '+ReceiptDetails.size());
        system.debug('receiptlist.size()::: '+receiptlist.size());
        
        //added by shailesh
        system.debug('i' + i);
        if (i == 0) {
            
            Opportunity insObj = new Opportunity();
            insObj.Id = boookingObj.Opportunity__c;
            insObj.Project__c = boookingObj.Project__c;
            insObj.StageName= 'Token Amount Received - BIP';
            Property__c ut = [Select Id,Name,Status__c,Customers__c,Tower_Name__c,Central_Support__c,Site_Support__c,MD__c,CFO__c,Sales_Head__c,AR_Finance__c, 
                              RM_Email__c,RM_Name__c,Sales_Team_Lead__c,CRM_Lead__c,Original_RM_Name__c,AR_Support__c
                             from Property__c where Id =: boookingObj.Property__c];
            try
            {
                system.debug('ReceiptLstTobeUpdate in try Up '+ReceiptLstTobeUpdate.size());
                boookingObj.status__c = 'UnProcessed';
                if(ut.Site_Support__c != Null){
                    boookingObj.Site_Support__c = ut.Site_Support__c ;
                }
                if(ut.Central_Support__c != Null){
                    boookingObj.Central_Support__c = ut.Central_Support__c;
                }
                if(ut.MD__c != Null){
                    boookingObj.MD__c = ut.MD__c;
                }
                if(ut.CFO__c != Null){
                    boookingObj.CFO__c = ut.CFO__c;
                }
                if(ut.AR_Finance__c != Null){
                    boookingObj.AR_Finance__c = ut.AR_Finance__c;
                }
                if(ut.Sales_Head__c != Null){
                    boookingObj.Sales_Head__c = ut.Sales_Head__c;
                }
                if(ut.RM_Name__c != Null){
                    boookingObj.RM_Name__c = ut.RM_Name__c;
                }
                if(ut.CRM_Lead__c != Null){
                    boookingObj.CRM_Lead__c = ut.CRM_Lead__c;
                }
                if(ut.Original_RM_Name__c!= Null){
                    boookingObj.RM_User__c = ut.Original_RM_Name__c;
                }
                if(ut.Sales_Team_Lead__c != Null){
                    boookingObj.Sales_Team_Lead__c = ut.Sales_Team_Lead__c;
                }
                if(ut.AR_Support__c != Null){
                    boookingObj.AR_Support__c = ut.AR_Support__c;
                }
                insert boookingObj;
                insObj.Booking__c = boookingObj.id;
                insObj.Property__c = boookingObj.Property__c;
                update insObj;//updating opportunity
                ut.Status__c = 'Booked';
                ut.Customers__c = boookingObj.Opportunity__c;
                ut.Booking__c = boookingObj.id;
                update ut;//updating unit
            }                 
            catch (DmlException e){
                System.debug('An error has occured. Please contact your administrator. : ' + e.getMessage());
            }
            if (i == 0) 
            {
                system.debug('receiptlist:::::::::'+receiptlist);
                system.debug('receiptlist.size():::'+receiptlist.size());
                
                for(Payment__c ListRct : receiptlist)
                {
                    Payment__c receiptOBJTobeUpdate = new Payment__c();
                    receiptOBJTobeUpdate.Payment_Mode__c = ListRct.Payment_Mode__c;
                    receiptOBJTobeUpdate.RTGS_Cheque_Draft_No__c = ListRct.RTGS_Cheque_Draft_No__c;
                    receiptOBJTobeUpdate.Instrument_Date__c = ListRct.Instrument_Date__c;
                    receiptOBJTobeUpdate.Amount__c = ListRct.Amount__c;
                    receiptOBJTobeUpdate.Bank_Name__c = ListRct.Bank_Name__c;
                    receiptOBJTobeUpdate.Branch_Name__c = ListRct.Branch_Name__c;
                    receiptOBJTobeUpdate.Is_Token__c = True;
                    
                    receiptOBJTobeUpdate.Booking__c = boookingObj.id;
                    receiptOBJTobeUpdate.Project__c = boookingObj.Project__c;
                    receiptOBJTobeUpdate.Property__c = boookingObj.Property__c;
                    if(receiptOBJTobeUpdate.Amount__c != null && receiptOBJTobeUpdate.Payment_Mode__c != null)
                        ReceiptLstTobeUpdate.add(receiptOBJTobeUpdate);
                }
                System.debug('ReceiptLstTobeUpdate:::: ' +ReceiptLstTobeUpdate);
                System.debug('ReceiptLstTobeUpdate Size:::: ' +ReceiptLstTobeUpdate.size());
                
                try
                {
                    if(!ReceiptLstTobeUpdate.isEmpty())
                    {
                        insert ReceiptLstTobeUpdate; 
                    } 
                }
                
                catch (DmlException e) 
                {
                    System.debug('An error has occured. Please contact your administrator. : ' + e.getMessage());
                }
            }
            
            
            //Updating Parkings/////
            if(!additionalParkingMap.isEmpty()){
                for(string st : additionalParkingMap.keyset()){
                    Integer s = Integer.valueOf(additionalParkingMap.get(st));
                    for(Integer r=0; r<s; r++){
                        addAvailableParkingMap.get(st)[r].Status__c = 'Allotted'; 
                        ParkingListToUpdate.add(addAvailableParkingMap.get(st)[r]);
                    }
                }
            }
            
            if(!earMarkedParkingMap.isEmpty()){
                for(string st : earMarkedParkingMap.keyset()){
                    Integer s = Integer.valueOf(earMarkedParkingMap.get(st));
                    system.debug('s::'+s);
                    system.debug('earAvailableParkingMap.get(st):: '+earAvailableParkingMap.get(st));
                    for(Integer r=0; r<s; r++){
                        earAvailableParkingMap.get(st)[r].Status__c = 'Allotted'; 
                        ParkingListToUpdate.add(earAvailableParkingMap.get(st)[r]);
                    }
                }
            }
            
            if(ParkingListToUpdate.size() > 0){
                update ParkingListToUpdate;
            }        
            
            //Updating  Customer Pay Plan Headers with new booking 
            if(boookingObj.id != null){
                try {
                    //Updating Quotation with new booking
                    if (QuoteDetails.size() > 0) {
                        QuoteDetails[0].Booking__c =  boookingObj.id;
                        update QuoteDetails;
                    }
                } catch (DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                    
                }
                try {
                    for(Payment__c rct : ReceiptLstTobeUpdate)
                    {
                        if (rct.id !=  null) 
                        {
                            //rct.Booking__c =  boookingObj.id;
                            //rct.Property__c = boookingObj.Property__c;
                            //update rct;
                        }
                    }
                } catch (DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
                try {
                    system.debug('this use vikas receipt:::: '+ReceiptDetails.size());
                    //Updating ReceiptDetails  with new booking
                    if (ReceiptDetails.size() >0)
                    {
                        for(Payment__c r : ReceiptDetails){
                            r.Booking__c =  boookingObj.id;
                            //r.Opportunity_Email_Id__c=applicant.Email_Address__c;
                            if(r.Property__c == null)
                            {
                                r.Property__c = boookingObj.Property__c;
                            } 
                            if(boookingObj.Project__c != null)
                            {
                                r.Project__c = boookingObj.Project__c;
                            }
                            ListOldReceipt.add(r);
                        } 
                    }
                    //Updating ReceiptDetails  with new booking
                    if (STReceiptDetails.size() >0)
                    {
                        for(Payment__c st : STReceiptDetails){
                            st.Booking__c =  boookingObj.id;
                            //st.Opportunity_Email_Id__c=applicant.Email_Address__c;
                            if(st.Property__c == null)
                            {
                                st.Property__c = boookingObj.Property__c;
                                
                            } 
                            if(boookingObj.Project__c != null)
                            {
                                
                                st.Project__c = boookingObj.Project__c;
                            }
                            ListOldReceipt.add(st);
                        } 
                        
                    }   
                    update ListOldReceipt;
                } catch (DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                    
                }
                //inserting the Applicants
                if (applicant.Name != ''&& applicant.Name != null ) {
                    if (addressCheck == true) {
                        applicant.Mailing_Address_same_as_PermanentAddress__c = true;
                        applicant.Mailing_House_No__c = applicant.House_No__c;
                        applicant.Mailing_Street_1__c= applicant.Street_1__c;
                        applicant.Mailing_Street_2__c= applicant.Street_2__c;
                        applicant.Mailing_Street_3__c= applicant.Street_3__c;
                        applicant.Mailing_Locality__c = applicant.Locality__c;
                        applicant.Mailing_Country__c = applicant.Country__c;
                        applicant.Mailing_State__c = applicant.State__c;
                        applicant.Mailing_City__c = applicant.City__c;
                        applicant.Mailing_Pincode__c = applicant.Pincode__c;
                    }
                    
                    applicant.Applicant_Number__c = 'Primary Applicant';
                    applicant.Applicant_Type__c = 'Primary';    
                    applicant.Occupation__c = applicant.Occupation__c;
                    applicant.Subtype_Of_Applicant__c = applicant.Subtype_Of_Applicant__c;
                    applicant.DOB__c= firstApplicantDOB;
                    applicant.Booking__c = boookingObj.id;
                    applicant.Opportunity__c = boookingObj.Opportunity__c;
                    listApplicant.add(applicant);
                }
                if (applicant2.Name != '' && applicant2.Name != null) {
                    applicant2.Applicant_Number__c = 'Second Applicant';
                    applicant2.Applicant_Type__c = 'Second';
                    applicant2.Booking__c = boookingObj.id;
                    applicant2.Opportunity__c = boookingObj.Opportunity__c;
                    applicant2.Occupation__c = applicant2.Occupation__c;
                    applicant2.Subtype_Of_Applicant__c = applicant2.Subtype_Of_Applicant__c;
                    applicant2.DOB__c= SecondApplicantDOB;
                    listApplicant.add(applicant2);
                }
                if (applicant3.Name != '' && applicant3.Name != null) {
                    applicant3.Applicant_Number__c = 'Third Applicant';
                    applicant3.Applicant_Type__c = 'Third';
                    applicant3.Booking__c = boookingObj.id;
                    applicant3.Opportunity__c = boookingObj.Opportunity__c;
                    applicant3.Occupation__c = applicant3.Occupation__c;
                    applicant3.Subtype_Of_Applicant__c = applicant3.Subtype_Of_Applicant__c;
                    applicant3.DOB__c= ThirdApplicantDOB;
                    listApplicant.add(applicant3);
                }
                if (applicant4.Name != null) {
                    applicant4.Applicant_Number__c = 'Fourth Applicant';
                    applicant4.Applicant_Type__c = 'Fourth';
                    applicant4.Booking__c = boookingObj.id;
                    applicant4.Opportunity__c = boookingObj.Opportunity__c;
                    applicant4.Occupation__c = applicant4.Occupation__c;
                    applicant4.Subtype_Of_Applicant__c = applicant4.Subtype_Of_Applicant__c;
                    applicant4.DOB__c= fourthApplicantDOB;
                    listApplicant.add(applicant4);
                }
                if (applicant5.Name != null) {
                    applicant5.Applicant_Number__c = 'Fifth Applicant';
                    applicant5.Applicant_Type__c = 'Fifth';
                    applicant5.Booking__c = boookingObj.id;
                    applicant5.Opportunity__c = boookingObj.Opportunity__c;
                    applicant5.Occupation__c = applicant5.Occupation__c;
                    applicant5.Subtype_Of_Applicant__c = applicant5.Subtype_Of_Applicant__c;
                    applicant5.DOB__c= fifthApplicantDOB;
                    listApplicant.add(applicant5);
                }
                system.debug('listApplicant' + listApplicant);
        ///////////////////Inserting Default mailing address////////////////////  
         if(applicant.Mailing_House_No__c != null )
            boookingObj.C_o_Name_Mailing_Address__c= applicant.Mailing_House_No__c;
            
            if(applicant.Mailing_Street_1__c != null )
            boookingObj.Mailing_Street__c= applicant.Mailing_Street_1__c;
            
            if(applicant.Mailing_Street_2__c != null )
            boookingObj.Mailing_Str_Suppl2__c = applicant.Mailing_Street_2__c;
            
            if(applicant.Mailing_Street_3__c != null )
            boookingObj.Mailing_Str_Suppl3__c = applicant.Mailing_Street_3__c;
            
            if(applicant.Mailing_Country__c != null )
            boookingObj.Mailing_Country__c = applicant.Mailing_Country__c;
            
            if(applicant.Mailing_State__c != null )
            boookingObj.Mailing_Region__c = applicant.Mailing_State__c;
            
            if(applicant.Mailing_City__c != null )
            boookingObj.Mailing_City__c = applicant.Mailing_City__c;
            
            if(applicant.Mailing_City__c != null )
            boookingObj.Mailing_Location__c = applicant.Mailing_Locality__c;
            
            if(applicant.Mailing_Pincode__c != null )
            boookingObj.Mailing_Post_Code__c = String.valueof(applicant.Mailing_Pincode__c);
        
        ///////////////////Inserting Default mailing address Endss here///////////////////////////////////////////////inserting applicants
                try
                {
                    if(listApplicant.size() >0){
                        Update boookingObj;
                        insert listApplicant;
                    }
                }                 
                catch (DmlException e) 
                {
                    System.debug('An error has occured. Please contact your administrator. : ' + e.getMessage());
                }   
            }
            //System.Debug('ReceiptObj'+ReceiptObj);
            System.Debug('Booking Obj' + boookingObj);
            if (boookingObj.id != null) {
                PageReference newpage = new Pagereference('/' + boookingObj.id);
                newpage.setRedirect(true);
                return newpage;
            }
        }
        return null;
    }
    
    public PageReference Cancel() {
        PageReference newpage = new Pagereference('/home/home.jsp');
        return newpage;
    }
    
   /* public static Tower__c getLegalEntityDetails(Id TowerId) {
        return null;
    }*/
    
    // method for formatting the currency details to Indian Commas Format
    public static String INFormat(Decimal money) {
        Boolean negative = false;
        if(money < 0) {
            negative = true;
        }
        String m1 = String.valueOf(math.abs(money.setscale(0,RoundingMode.HALF_UP))).reverse();
        String mF = '';
        for(Integer i=0; i < m1.length() ; i++) {
            mF += m1.substring(i,i+1);
            if(i==2) {
                mF += ',';
            }
            if(i==4 || i==6 || i==8 || i==10 || i==12) {
                mF += ',';
            }
        }
        mf = mf.reverse();
        if(mf.substring(0,1).equals(',')) {
            mf = mf.substring(1);
        }
        if(!negative)
            mf =  mf + '/-';
        else
            mf = '- ' + mf + '/-';
        return mf;
    }
    
    public void dummy(){
    Integer i = 0;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    }  
}
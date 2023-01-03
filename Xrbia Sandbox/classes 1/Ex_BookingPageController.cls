//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 27-10-2022
//-------------------------------------------//
public class Ex_BookingPageController {
    public Booking__c b {get;set;}
    public Id qId {get;set;}
    public Quotation__c q {get;set;}
    public Unit__c u {get;set;}
    public Opportunity__c op {get;set;}
    public Decimal agreementValue {get;set;}
    public Decimal agreementValueTax {get;set;}
    public Decimal SDRValue {get;set;}
    public Decimal SDRTax {get;set;}
    public Decimal count {get;set;}
    public String agreementValueString {get;set;}
    public String agreementValueTaxString {get;set;}
    public String SDRValueString {get;set;}
    public String SDRTaxString {get;set;}
    public Map<String, Decimal> carParkReqMap {get;set;}
    public Map<String, Decimal> carParkAvailableMap {get;set;}
    public Boolean error {get;set;}
    public String errorMsg {get;set;}
	public List<applicantWrapper> applicantWrapperList {get;set;}
    public Integer rowNum {get;set;}
    public Boolean valError {get;set;}
    public List<Receipt__c> recList {get;set;}
    //public List<receiptWrapper> lstReceipt {get;set;}
    public Receipt__c rec {get;set;}
    public Map<String, Team_Member__c> teamMemberMap {get;set;}
    
    public Ex_BookingPageController() {
        b = new Booking__c();
        qId = null;
        q = null;
        u = null;
        op = null;
        agreementValue = 0;
        agreementValueTax = 0;
        SDRValue = 0;
        count = 0;
        SDRTax = 0;
        agreementValueString = '';
        agreementValueTaxString = '';
        SDRValueString = '';
        SDRTaxString = '';
        carParkReqMap = new Map<String, Decimal>();
        carParkAvailableMap = new Map<String, Decimal>();
        error = false;
        errorMsg = '';
		valError = false;
        rec = new Receipt__c();
        applicantWrapperList = new List<applicantWrapper>();
        Applicant__c ap = new Applicant__c();
        applicantWrapperList.add(new applicantWrapper(ap));
        recList = new List<Receipt__c>();
        //lstReceipt = new List<receiptWrapper>();
        recList.add(rec);

        if(ApexPages.currentPage().getParameters().containsKey('qId')) {
            qId = (Id)ApexPages.currentPage().getParameters().get('qId'); 
        }

        if(qId != null) {
            q = Ex_InventoryPriceManagementServices.getQuotationInfo(qId);
            if(q != null) {
                if(String.isNotBlank(q.Quotation_Status__c) && (q.Quotation_Status__c.equalsIgnoreCase('Valid') || q.Quotation_Status__c.equalsIgnoreCase('Approved'))) {
                    b.Quotation__c = q.Id;
                    b.Payment_Scheme__c = q.Payment_Scheme__c;

                    //Get Agreement Value
                    for(Integer i = 1; i <= 5; i++) {
                        if(String.isNotBlank((String)q.get('Charge_Bucket_'+i+'__c')) && ((String)q.get('Charge_Bucket_'+i+'__c')).equalsIgnoreCase('Agreement Value')) { 
                            agreementValue = (Decimal)q.get('Charge_Bucket_'+i+'_Amount__c');
                            agreementValueTax = (Decimal)q.get('Charge_Bucket_'+i+'_Total_Tax__c');
                        }
                        if(String.isNotBlank((String)q.get('Charge_Bucket_'+i+'__c')) && ((String)q.get('Charge_Bucket_'+i+'__c')).equalsIgnoreCase('Statutory Charges')) { 
                            SDRValue = (Decimal)q.get('Charge_Bucket_'+i+'_Amount__c');
                            SDRTax = (Decimal)q.get('Charge_Bucket_'+i+'_Total_Tax__c');
                        }
                    }
                    b.Agreement_Value__c = agreementValue;
                    b.Agreement_Value_Tax__c = agreementValueTax;
                    b.SDR_Value__c = SDRValue;
                    b.SDR_Tax__c = SDRTax;
                    agreementValueString = Ex_InventoryPriceManagementServices.currencyFormat(agreementValue);
                    agreementValueTaxString = Ex_InventoryPriceManagementServices.currencyFormat(agreementValueTax);
                    SDRValueString = Ex_InventoryPriceManagementServices.currencyFormat(SDRValue);
                    SDRTaxString = Ex_InventoryPriceManagementServices.currencyFormat(SDRTax);

                    carParkReqMap = getCarParkRequested(q.Id);
                    op = Ex_InventoryPriceManagementServices.getOpportunityInfo(q.Opportunity__c);
                    u = Ex_InventoryPriceManagementServices.getUnitInfo(q.Unit__c);
                    teamMemberMap = new Map<String, Team_Member__c>();
                    
                    if(op != null) {
                        if(!op.IsActive__c) {
                            errorMsg = 'You Cannot Create Booking on Inactive Opportunity.';
                            error = true;
                        } else {
                            b.Opportunity__c = op.Id;
                            if(String.isNotBlank(op.Campaign_Type__c))
                                b.Campaign_Type__c = op.Campaign_Type__c;
                            if(String.isNotBlank(op.Media__c))
                                b.Media__c = op.Media__c;
                            if(String.isNotBlank(op.Channel_Partner__c))
                                b.Channel_Partner__c = op.Channel_Partner__c;
                            if(String.isNotBlank(op.Referrer_Name__c))
                                b.Referrer_Name__c = op.Referrer_Name__c;
                        }
                    }

                    if(u != null) {
                        if(u.Unit_Status__c.equalsIgnoreCase('Vacant')) {
                            b.Unit__c = u.Id;
                            b.Tower__c = u.Tower__c;
                            b.Project__c = u.Project__c;
                            
                            carParkAvailableMap = getCarParkAvailable(u.Project__c, u.Tower__c);
                            if(carParkReqMap != null) {
                                for(String cpType: carParkReqMap.keySet()) {
                                    if(carParkAvailableMap.containsKey(cpType)) {
                                        if(carParkReqMap.get(cpType) > carParkAvailableMap.get(cpType)) {
                                            errorMsg = 'Required Car Park Count is Not Available for Type: '+cpType+'. Required Count: '+carParkReqMap.get(cpType)+' Available Count: '+carParkAvailableMap.get(cpType);
                                            error = true;
                                        }
                                    } else {
                                        errorMsg = cpType + ' Car Park is Not Available.';
                                        error = true;
                                    }
                                }
                            }
                        } else {
                            errorMsg = 'Error: Unit is Not Available for Sale.';
                            error = true;
                        }
                    } else {
                        errorMsg = 'Error: Unit Details is Not Present on Quotation.';
                        error = true;
                    }
                } else {
                    errorMsg = 'Error: Selected Quotation is Not Valid.';
                    error = true;
                }
            } else {
                errorMsg = 'Error: Quotation Not Found. Please Contact Your System Administrator.';
                error = true;
            }
        } else {
            errorMsg = 'Error: Quotation Not Found. Please Contact Your System Administrator.';
            error = true;
        }
    }

    public void addApplicant() {
        Applicant__c ap = new Applicant__c();
        applicantWrapperList.add(new applicantWrapper(ap));
    }

    public void removeApplicant() {
        rowNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        applicantWrapperList.remove(rowNum - 1);
    }
    
    public void addRows(){
        Receipt__c rec =new Receipt__c();
        recList.add(rec);
        system.debug('receiptlist :: '+recList);
        system.debug('receiptlist size::'+recList.size());
    }
    
    public void rmvRows(){
        rowNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        system.debug('row number:: ' + rowNum);
        system.debug('Row Delete :: '+ recList[rowNum]);
        recList.remove(rowNum);
    }

    public Pagereference save() {
        system.debug('In Save Method: '+u);
        system.debug('In Save Method: '+b);
        b.Booking_Stages__c = 'Booking in-process';
        teamMemberMap = Ex_InventoryPriceManagementServices.getApprovalTeamMemberDetails(u.Project__c, 'Booking Approver Team');
        if(!teamMemberMap.isEmpty() && teamMemberMap != null) {
            for(String s: teamMemberMap.KeySet()) {
                if(s.equalsIgnoreCase('Level 1'))
                    b.Booking_Approver_Level_1__c = teamMemberMap.get(s).User__c;
                else if(s.equalsIgnoreCase('Level 2'))
                    b.Booking_Approver_Level_2__c = teamMemberMap.get(s).User__c;
                
            }
        }
        
        Id bId;
        if(!recList.isEmpty()) {
            Integer tcount = 0;
            for(Receipt__c rc : recList) {
                if(rc.isTokenAmount__c) {
                    tcount++;
                    if(tcount == 1) {
                        b.Amount__c = rc.Amount__c;
                        b.Bank_Name__c = rc.Bank_Name__c;
                        b.Receipt_Dated__c = rc.Dated__c;
                        b.Receipt_Type__c = rc.Receipt_Type__c;
                        b.Chq_No_UTR_TID_APPR_CODE__c = rc.Chq_No_UTR_TID_APPR_CODE__c;
                        //b.CBIL_Approved__c = 'No';
                        b.Drawn_on_Branch_Name__c = rc.Drawn_on_Branch_Name__c;
                        b.Payment_Mode__c = rc.Payment_Mode__c;
                        b.Transaction_Status__c = rc.Transaction_Status__c; 
                        b.payment_type__c = rc.payment_type__c;   
                    }
                    if(b.payment_mode__c != 'Cheque' || (b.payment_mode__c == 'Cheque' && b.Transaction_Status__c == 'Successful')) {
                        b.Booking_Sub_Stage__c = 'Amount Cleared';
                    } else {
                        b.Booking_Sub_Stage__c = 'Amount Collected';
                    }
                }
            }            
        }
        if(!applicantWrapperList.isEmpty() && applicantWrapperList != null) {
            for(applicantWrapper apw: applicantWrapperList) {
               if (apw.ap.Applicant_Number__c == 'Primary Applicant') {
                b.Primary_Applicant_Title__c = apw.ap.Applicant_Title__c;
                b.Primary_Applicant_Name__c = apw.ap.Name;
                b.Primary_Applicant_Mobile__c = apw.ap.Mobile_Number__c;
                b.Primary_Applicant_Email__c = apw.ap.Email__c;
               }
            }
        }
        System.debug(b.Id);
        Database.saveResult sr = Database.insert(b);
        if(sr.isSuccess()) {
            bId = sr.getId();
            List<Applicant__c> applicantList = new List<Applicant__c>();
            List<Car_Park__c> updateCarParkList = new List<Car_Park__c>();

            if(!applicantWrapperList.isEmpty() && applicantWrapperList != null) {
                for(applicantWrapper apw: applicantWrapperList) {
                    Applicant__c ap = new Applicant__c();
                    ap = apw.ap;
                    ap.Booking__c = bId;
                    ap.DOB__c = apw.applicantDOB;
                    applicantList.add(ap);
                }
            }

            if(!carParkReqMap.isEmpty() && carParkReqMap != null) {
                Integer cpCount = 0;
                System.debug('car park map: '+carParkReqMap.keySet());
                for(String cpType: carParkReqMap.keySet()) {
                    if(Integer.valueOf(carParkReqMap.get(cpType)) != null)
                        cpCount = Integer.valueOf(carParkReqMap.get(cpType));
                    System.debug('cp count: '+cpCount);
                    for(Car_Park__c cp: [Select Id, Name, Booking__c, Status__c, Type__c from Car_Park__c where Type__c =: cpType
                                         AND Status__c = 'Available' AND Project__c =: u.Project__c AND Tower__c =: u.Tower__c
                                         LIMIT :cpCount]) {
                    
                        cp.Booking__c = bId;
                        cp.Status__c = 'Booked';
                        updateCarParkList.add(cp);
                    }
                }
            }

            try {
                if(!recList.isEmpty()) {
                    for(Receipt__c rc : recList) {
                        rc.Booking__c = bId;
                    }
					insert recList;  
                }
                
                //Update Quotation
                q.Booking__c = bId;
                update q;

                //Update Unit
                u.Unit_Status__c = 'Booked';
                u.Booking__c = bId;
                u.Opportunity__c = op.Id;
                update u;

                //Update Opportunity
                op.StageName__c = 'Booking in-process';
                op.Sub_Stage__c = b.Booking_Sub_Stage__c;
                op.Booking__c = bId;
                op.Amount__c = b.Agreement_Value__c;
                op.Unit__c = u.Id;
                update op;

                if(!applicantList.isEmpty() && applicantList != null) {
                    insert applicantList;
                }
                if(!updateCarParkList.isEmpty() && updateCarParkList != null) {
                    update updateCarParkList;
                }
                return new PageReference('/lightning/r/Booking__c/' + sr.getId() + '/view');
            } catch(Exception ex) {
                system.debug('Error: '+ex.getMessage());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Booking Cannot be Proceed. Please Contact Your System Administrator.'));
                return null;
            }
        } else {
            for(Database.Error err : sr.getErrors()) {
                system.debug('Error: '+err);
            }
            errorMsg = 'Booking Cannot be Proceed. Please Contact Your System Administrator.';
            return null;
        }
    }

    public Map<String, Decimal> getCarParkRequested(Id qId) {
        Map<String, Decimal> carParkReqMap = new Map<String, Decimal>();
        List<Car_Park_Required__c> carParkReqList = [Select Id, Name, Car_Park_Type__c, Car_Park_Count__c from Car_Park_Required__c
                                                    where Quotation__c =: qId];
        system.debug('carParkReqList: '+carParkReqList);
        if(carParkReqList != null) {
            for(Car_Park_Required__c cpr: carParkReqList) {
                carParkReqMap.put(cpr.Car_Park_Type__c, cpr.Car_Park_Count__c);
            }
        }
        return carParkReqMap;
    }

    public Map<String, Decimal> getCarParkAvailable(Id pId, Id tId) {
        Map<String, Decimal> carParkAvailableMap = new Map<String, Decimal>();
        List<AggregateResult> carParkList = [Select COUNT(Id) carParkCount, Type__c from Car_Park__c where Project__c =: pId AND Tower__c =: tId
                                            AND Status__c = 'Available' GROUP BY Type__c ORDER BY Type__c];
        system.debug('carParkList: '+carParkList);
        if(carParkList != null) {
            for(AggregateResult ag: carParkList) {
                carParkAvailableMap.put((String) ag.get('Type__c'), (Decimal) ag.get('carParkCount'));
            }
        }
        return carParkAvailableMap;
    }
	
    public PageReference validateInput() {
        valError = False;
        errorMsg = '';
        
        if(b.Booking_Date__c == null) {
            valError = True;
            errorMsg = 'Please fill Booking Date.'; 
        }
        
        if(!applicantWrapperList.isEmpty() && applicantWrapperList != null) {
            for(Integer i = 1; i <= applicantWrapperList.size(); i++) {
                /*if(String.isBlank(applicantWrapperList[i-1].ap.Aadhar_Number__c)) {
                    valError = True;
            		errorMsg = 'Please fill Applicant '+i+' Aadhar Number.'; 
                } else {
                    if(applicantWrapperList[i-1].ap.Aadhar_Number__c.length() != 12) {
                        valError = True;
            			errorMsg = 'Please provide proper Applicant '+i+' Aadhar Number.'; 
                    }
                }
                if(String.isBlank(applicantWrapperList[i-1].ap.PAN_Number__c)) {
                    valError = True;
            		errorMsg = 'Please fill Applicant '+i+' PAN Number.'; 
                }
                if(applicantWrapperList[i-1].applicantDOB == null) {
                    valError = True;
            		errorMsg = 'Please fill Applicant '+i+' Date of Birth.'; 
                } 
                if(String.isBlank(applicantWrapperList[i-1].ap.Pin_Code__c)) {
                    valError = True;
            		errorMsg = 'Please fill Applicant '+i+' Pincode.'; 
                }
                if(String.isBlank(applicantWrapperList[i-1].ap.Mobile_Number__c)) {
                    valError = True;
            		errorMsg = 'Please fill Applicant '+i+' Mobile No.'; 
                }
                if(String.isBlank(applicantWrapperList[i-1].ap.Country__c)) {
                    valError = True;
            		errorMsg = 'Please fill Applicant '+i+' Country.'; 
                }*/
                if(String.isBlank(applicantWrapperList[i-1].ap.Applicant_Number__c)) {
                    valError = True;
            		errorMsg = 'Please fill Applicant '+i+' Number.'; 
                }
                if(String.isBlank(applicantWrapperList[i-1].ap.Name)) {
                    valError = True;
            		errorMsg = 'Please fill Applicant '+i+' Name.'; 
                }
                if(String.isBlank(applicantWrapperList[i-1].ap.Applicant_Title__c)) {
                    valError = True;
            		errorMsg = 'Please fill Applicant '+i+' Salutation.'; 
                }
            }
        }
        return null;
    }
    
    public class applicantWrapper {
        public Applicant__c ap {get;set;}
        public Date applicantDOB {get;set;}

        public applicantWrapper(Applicant__c ap) {
            this.ap = ap;
            this.applicantDOB = null;
        }
    }
}
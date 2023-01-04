public class Ex_BookingPageController {
    public Booking__c b {get;set;}
    public Id qId {get;set;}
    public Quotation__c q {get;set;}
    public Unit__c u {get;set;}
    public Opportunity_c__c op {get;set;}
    public Decimal agreementValue {get;set;}
    public Decimal agreementValueTax {get;set;}
    public Decimal SDRValue {get;set;}
    public Decimal SDRTax {get;set;}
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
    public List<Team_Members__c> tmList {get;set;}
    public List<Receipt__c> recList {get;set;}
    //public List<receiptWrapper> lstReceipt {get;set;}
    public Receipt__c rec {get;set;}
    
    public Ex_BookingPageController() {
        b = new Booking__c();
        qId = null;
        q = null;
        u = null;
        op = null;
        agreementValue = 0;
        agreementValueTax = 0;
        SDRValue = 0;
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
        tmList = new List<Team_Members__c>();
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
            q = InventoryPriceManagementServices.getQuotationInfo(qId);
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
                    agreementValueString = InventoryPriceManagementServices.currencyFormat(agreementValue);
                    agreementValueTaxString = InventoryPriceManagementServices.currencyFormat(agreementValueTax);
                    SDRValueString = InventoryPriceManagementServices.currencyFormat(SDRValue);
                    SDRTaxString = InventoryPriceManagementServices.currencyFormat(SDRTax);
                    
                    carParkReqMap = getCarParkRequested(q.Id);
                    op = InventoryPriceManagementServices.getOpportunityInfo(q.Opportunity__c);
                    u = InventoryPriceManagementServices.getUnitInfo(q.Unit__c);
                    
                    if(op != null) {
                        if(!op.Is_Active__c) {
                            errorMsg = 'You Cannot Create Booking on Inactive Opportunity.';
                            error = true;
                        } else {
                            b.Opportunity__c = op.Id;
                            if(String.isNotBlank(op.Master_Source__c))
                                b.Master_Source__c = op.Master_Source__c;
                            if(String.isNotBlank(op.Opportunity_Source__c))
                                b.Booking_Source__c = op.Opportunity_Source__c;
                            if(String.isNotBlank(op.Opportunity_Sub_Source__c))
                                b.Booking_Sub_Source__c = op.Opportunity_Sub_Source__c;
                            if(String.isNotBlank(op.Opportunity_Sub_Source_Details__c))
                                b.Booking_Sub_Source_Details__c = op.Opportunity_Sub_Source_Details__c;
                            if(String.isNotBlank(op.Other_Source_Details__c))
                                b.Other_Source_Details__c = op.Other_Source_Details__c;
                            if(String.isNotBlank(op.CP_Account__c))
                                b.CP_Account__c = op.CP_Account__c;
                            if(String.isNotBlank(op.Referrer_Name__c))
                                b.Referrer_Name_Account__c = op.Referrer_Name__c;
                            if(String.isNotBlank(op.CP_Project__c))
                                b.CP_Project__c = op.CP_Project__c;
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
        
        /*     if(op.Master_Source__c != b.Master_Source__c || op.Opportunity_Source__c != b.Booking_Source__c) {
b.Booking_Stages__c = 'Approval Required';
b.Source_Conflict_Approval_Required__c = true;

tmList = [Select Id, Name, User__c, Sequence_Number__c, User_Active_Status__c, Availability__c, Team__r.Project__c from Team_Members__c
where Team__r.Project__c =: b.Project__c AND Team__r.Team_Type__c = 'Booking Source Conflict Team' AND User_Active_Status__c = true ORDER BY Sequence_Number__c ASC];
system.debug('tmList: '+tmList);

if(!tmList.isEmpty() && tmList != null) {
for(Integer i = 1; i <= tmList.size(); i++) {
b.put('Source_Conflict_Approver_'+i+'__c', tmList[i-1].User__c);
}
}
} else {
b.Booking_Stages__c = 'Booking Confirmed';
} */
        
        Id bId;
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
                for(String cpType: carParkReqMap.keySet()) {
                    if(Integer.valueOf(carParkReqMap.get(cpType)) != null)
                    	cpCount = Integer.valueOf(carParkReqMap.get(cpType));
                    for(Car_Park__c cp: [Select Id, Name, Booking__c, Status__c from Car_Park__c where Type__c =: cpType
                                         AND Status__c = 'Available' AND Project__c =: u.Project__c AND Tower__c =: u.Tower__c
                                         LIMIT :cpCount]) {
                                             
                                             cp.Booking__c = bId;
                                             cp.Status__c = 'Booked';
                                             updateCarParkList.add(cp);
                                         }
                }
            }
            
            try {
                if (!recList.isEmpty()) {
                    for(Receipt__c rc : recList)
                    {
                        rc.Booking__c = bId;
                        //rc.Business_Account__c = lstBA[0].Id;
                        //rc.Favouring__c = lstBA[0].Account_Name__c;
                    }
                    insert recList;    
                }
                
                //Update Quotation
                q.Booking__c = bId;
                update q;
                
                //Update Unit
                u.Unit_Status__c = 'Booked';
                u.Booking__c = bId;
                u.Opportunity_c__c = op.Id;
                update u;
                
                //Update Opportunity
                op.Opportunity_Stage__c = 'Booked';
                op.Opportunity_Sub_Stage__c	 = '';
                op.Opportunity_Sub_Stage_Reason__c	 = '';
                op.Booking__c = bId;
                //  op.Amount = b.Agreement_Value__c;
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
                if(String.isBlank(applicantWrapperList[i-1].ap.Aadhar_Number__c)) {
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
                if(String.isBlank(applicantWrapperList[i-1].ap.PIN__c)) {
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
                }
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
        
        /*if(String.isBlank(b.Master_Source__c)) {
valError = True;
errorMsg = 'Please fill Master Source.';
} else if(String.isBlank(b.Booking_Source__c)) {
valError = True;
errorMsg = 'Please fill Booking Source.';
} else if(b.Master_Source__c == 'Channel Partner' && b.Booking_Source__c == 'Channel Partner') {          
if(String.isBlank(b.CP_Account__c)) {
valError = True;
errorMsg = 'Please fill Channel Partner Name.';
}*/
        /*     if(b.Channel_Partner_Amount__c == null) {
valError = True;
errorMsg = 'Please fill Channel Partner Amount.';
} 
} else if(b.Master_Source__c == 'Reference' && b.Booking_Source__c == 'Employees') {
if(String.isBlank(b.Referrer_Name_Account__c)) {
valError = True;
errorMsg = 'Please fill Employees Referrer Name.';
}*/
        /*   if(b.Reference_Amount__c == null) {
valError = True;
errorMsg = 'Please fill Employees Referrer Amount.';
} */
        /*} else if(b.Master_Source__c == 'Reference' && b.Booking_Source__c == 'Customers') {
if(String.isBlank(b.Referrer_Name_Account__c)) {
valError = True;
errorMsg = 'Please fill Customer Referrer Name.';
} */
        /*     if(b.Reference_Amount__c == null) {
valError = True;
errorMsg = 'Please fill Customer Referrer Amount.';
} */
        //}
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
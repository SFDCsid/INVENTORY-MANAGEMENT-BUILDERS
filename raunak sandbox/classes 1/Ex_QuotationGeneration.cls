public with sharing class Ex_QuotationGeneration {
    public Quotation__c q {get;set;}
    public Id uId {get;set;}
    public Id oppId {get;set;}
    public Unit__c u {get;set;}
    public Opportunity_c__c opp {get;set;}
    public Boolean page2 {get;set;}
    public String errorMsg {get;set;}
    public Boolean error {get;set;}
    public List<Payment_Scheme__c> schemeList {get;set;}
    public List<SelectOption> paymentSchemeList {get;set;}
    public Id selectedScheme {get;set;}
    public List<InventoryPriceManagementServices.CarParkWrapper> carParkList {get;set;}
    public Decimal carParkPrice {get;set;}
	public List<Discount__c> discountList {get;set;}
    public Map<String, List<Discount__c>> discountGroupMap {get;set;}
    public List<String> discountGroups {get;set;}
    public Map<Id, Decimal> originalDiscountMap {get;set;}
    public Decimal discountPrice {get;set;}
	public Map<String, Pricing_List__c> priceListMap {get;set;}
    public Map<String, List<String>> priceListGroupMap {get;set;}
    public Map<String, Decimal> allPriceOriginalInfoMap {get;set;}
    public Map<String, String> allPriceOriginalInfoFormattedMap {get;set;}
    public Map<String, Decimal> allPriceInfoMap {get;set;}
    public Map<String, String> allPriceInfoFormattedMap {get;set;}
    public Map<String, Boolean> priceDifferenceMap {get;set;}
	public Project__c project {get;set;} 
	public List<InventoryPriceManagementServices.PaymentMilestoneWrapper> paymentMilestoneWrapperList {get;set;}

    public Ex_QuotationGeneration() {
        q = new Quotation__c();
        uId = null;
        oppId = null;
        u = null;
        opp = null;
        page2 = false;
        errorMsg = '';
        error = false;

        schemeList = new List<Payment_Scheme__c>();
        paymentSchemeList = new List<SelectOption>();
        selectedScheme = null;
        
        carParkList = new List<InventoryPriceManagementServices.CarParkWrapper>();
        carParkPrice = 0;

        discountList = new List<Discount__c>();
        discountGroupMap = new Map<String,List<Discount__c>>();
        discountGroups = new List<String>();
        originalDiscountMap = new Map<Id, Decimal>();
        discountPrice = 0;
        project = new Project__c();

        priceListMap = new Map<String, Pricing_List__c>();
        priceListGroupMap = new Map<String, List<String>>();
        allPriceOriginalInfoMap = new Map<String, Decimal>();
        allPriceOriginalInfoFormattedMap = new Map<String, String>();
        allPriceInfoMap = new Map<String, Decimal>();
        allPriceInfoFormattedMap = new Map<String, String>();
        priceDifferenceMap = new Map<String, Boolean>();

        paymentMilestoneWrapperList = new List<InventoryPriceManagementServices.PaymentMilestoneWrapper>();

        if(ApexPages.currentPage().getParameters().containsKey('uId')) {
            uId = (Id)ApexPages.currentPage().getParameters().get('uId'); 
        }
        if(ApexPages.currentPage().getParameters().containsKey('oppId')) {
            oppId = (Id)ApexPages.currentPage().getParameters().get('oppId');
        }
        if(uId != null) {
            u = InventoryPriceManagementServices.getUnitInfo(uId);
            if(u != null) {
                if(u.Unit_Status__c != 'Vacant') {
                    errorMsg = 'Error: Unit Not Available For Sale.';
                    error = true;
                } else {
                    q.Unit__c = u.Id;
                    q.Tower__c = u.Tower__c;
                    q.Project__c = u.Project__c;
                    project = [Select Id, Name, Level_1__c ,Level_2__c, Car_Park_Maintained_At__c from Project__c where Id =: u.Project__c];
                    if(project != null) {
                        if(project.Level_1__c != null) {
                            q.Level_1_Approver__c = project.Level_1__c;    
                        }
                        if(project.Level_2__c != null) {
                            q.Level_2_Approver__c = project.Level_2__c;
                        }
                    }
                    if(oppId != null) {
                        opp = InventoryPriceManagementServices.getOpportunityInfo(oppId);
                        if(opp != null) {
                            if(!opp.Is_Active__c) {
                                errorMsg = 'Error: You are Not Able to Create Quotation on Inactive Opportunity.';
                                error = true;
                            } else if(opp.Project__c != u.Project__c) {
                                errorMsg = 'Error: Project of Opportunity & Unit are Not Same.';
                                error = true;
                            } else {
                                q.Opportunity__c = opp.Id;
                                schemeList = InventoryPriceManagementServices.getPaymentSchemeInfo(u.Tower__c);
                                if(schemeList != null && !schemeList.isEmpty()) {
                                    for(Payment_Scheme__c ps: schemeList) {
                                        paymentSchemeList.add(new SelectOption(ps.Id, ps.Name));
                                    }
                                    if(project.Car_Park_Maintained_At__c.equalsIgnoreCase('Project')) {
                                        carParkList = InventoryPriceManagementServices.getCarParkInfo(project.Car_Park_Maintained_At__c, u.Project__c);
                                    } else if(project.Car_Park_Maintained_At__c.equalsIgnoreCase('Sector')) {
                                        carParkList = InventoryPriceManagementServices.getCarParkInfo(project.Car_Park_Maintained_At__c, u.Tower__r.Sector__c);
                                    } else if(project.Car_Park_Maintained_At__c.equalsIgnoreCase('Tower')) {
                                        carParkList = InventoryPriceManagementServices.getCarParkInfo(project.Car_Park_Maintained_At__c, u.Tower__c);
                                    }
                                    
                                    priceListMap = InventoryPriceManagementServices.getPriceListMap(u.Id);
                                    priceListGroupMap = InventoryPriceManagementServices.getPriceListGroupMap(u.Id);
                                }
                            }
                        } else {
                            errorMsg = 'Error: Opportunity is Not Found. Please Contact Your System Administrator.';
                            error = true;
                        }
                    } else {
                        errorMsg = 'Error: Opportunity is Not Found. Please Contact Your System Administrator.';
                        error = true;
                    }
                }
            } else {
                errorMsg = 'Error: Unit is Not Found. Please Contact Your System Administrator.';
                error = true;
            }
        } else {
            errorMsg = 'Error: Unit is Not Found. Please Contact Your System Administrator.';
            error = true;
        }
    }

    public void schemeSelect() {
        if(selectedScheme != null) {
            Payment_Scheme__c ps = [Select Id, Name from Payment_Scheme__c where Id =: selectedScheme];
            if(ps != null) {
                discountList = InventoryPriceManagementServices.getTowerLevelDiscountInfo(u.Project__c,u.Tower__c);
                originalDiscountMap = new Map<Id, Decimal>();

                if(discountList != null) {
                    for(Discount__c d: discountList) {
                        if(discountGroupMap.containsKey(d.Grouping__c)) {
                            discountGroupMap.get(d.grouping__c).add(d);
                        } else {
                            List<Discount__c> dTempList = new List<Discount__c>();
                            dTempList.add(d);
                            discountGroupMap.put(d.Grouping__c, dTempList);
                            discountGroups.add(d.Grouping__c);
                        }
                        if(d.Discount_Type__c.equalsIgnoreCase('PSF')) {
                            originalDiscountMap.put(d.Id, d.PSF_Amount__c);
                            system.debug('originalDiscountMap'+originalDiscountMap);
                        }
                        if(d.Discount_Type__c.equalsIgnoreCase('Lumpsum')) {
                            originalDiscountMap.put(d.Id, d.Amount__c);
                        } 
                        if(d.Discount_Type__c.equalsIgnoreCase('Percentage')) {
                            originalDiscountMap.put(d.Id, d.Percentage_of_AV__c);
                        }
                    }
                    discountGroups.sort();
                }
            }
        }
        allPriceOriginalInfoMap = InventoryPriceManagementServices.getAllPriceInfo(u.Id, priceListGroupMap, priceListMap, 0, 0);
        system.debug('allPriceOriginalInfoMap: '+allPriceOriginalInfoMap);
        if(allPriceOriginalInfoMap != null && !allPriceOriginalInfoMap.isEmpty()) {
            for(String ch: allPriceOriginalInfoMap.keySet()) {
                allPriceOriginalInfoFormattedMap.put(ch, InventoryPriceManagementServices.currencyFormat(allPriceOriginalInfoMap.get(ch)));
            }
        }
        allPriceInfoMap = InventoryPriceManagementServices.getAllPriceInfo(u.Id, priceListGroupMap, priceListMap, 0, 0);
        system.debug('allPriceInfoMap: '+allPriceInfoMap);
        if(allPriceInfoMap != null && !allPriceInfoMap.isEmpty()) {
            for(String ch: allPriceInfoMap.keySet()) {
                allPriceInfoFormattedMap.put(ch, InventoryPriceManagementServices.currencyFormat(allPriceInfoMap.get(ch)));
                if(allPriceInfoMap.get(ch) != allPriceOriginalInfoMap.get(ch)) {
                    priceDifferenceMap.put(ch, true);
                } else {
                    priceDifferenceMap.put(ch, false);
                }
            }
        }
        
        //Get Payment Break-Up as per Payment Scheme
        system.debug('scheme selected: '+selectedScheme);
        paymentMilestoneWrapperList = InventoryPriceManagementServices.getPaymentSummaryInfo(u.Id, selectedScheme, allPriceInfoMap, priceListMap);

    }

    public PageReference addCarPark() {
        carParkPrice = 0;
        error = false;
        errorMsg = '';

        if(carParkList != null) {
            for(InventoryPriceManagementServices.CarParkWrapper cp: carParkList) {
                if(cp.carParkAvailableCount < cp.carParkRequiredCount) {
                    error = true;
                    errorMsg = 'Error: You are Not Allowed to Apply More Car Park Than Available Count.';
                    return null;
                } else {
                    carParkPrice += cp.carParkRequiredCount * cp.carParkAmount;
                }
            }
        }
        allPriceInfoMap = InventoryPriceManagementServices.getAllPriceInfo(u.Id, priceListGroupMap, priceListMap, carParkPrice, discountPrice);
        //Agreement Value is changed after car park charges are added then recalculate discounts
        applyDiscount();
        if(allPriceInfoMap != null && !allPriceInfoMap.isEmpty()) {
            for(String ch: allPriceInfoMap.keySet()) {
                allPriceInfoFormattedMap.put(ch, InventoryPriceManagementServices.currencyFormat(allPriceInfoMap.get(ch)));
                if(allPriceInfoMap.get(ch) != allPriceOriginalInfoMap.get(ch)) {
                    priceDifferenceMap.put(ch, true);
                } else {
                    priceDifferenceMap.put(ch, false);
                }
            }
        }

        //Get Payment Break-Up as per Payment Scheme
        paymentMilestoneWrapperList = InventoryPriceManagementServices.getPaymentSummaryInfo(u.Id, selectedScheme, allPriceInfoMap, priceListMap);
        return null;
    }

    public PageReference applyDiscount() {
        discountPrice = 0;
        error = false;
        errorMsg = '';

        if(discountList != null) {
            Map<String, Integer> appliedDiscountGroupCountMap = new Map<String, Integer>();
            for(String gr: discountGroups) {
                Integer count = 0;
                for(Discount__c d: discountGroupMap.get(gr)) {
                    if(d.Applied__c) {
                        count++;
                    }
                }
                appliedDiscountGroupCountMap.put(gr, count);
            }
            for(String gr: discountGroups) {
                if(appliedDiscountGroupCountMap.get(gr) > 1) {
                    error = true;
                    errorMsg += 'You Cannot apply More Than One Discount from a Specifc Group: '+gr;
                }
            }
            if(error) {
                return null;
            }

            for(Discount__c d : discountList) {
                if(originalDiscountMap.containsKey(d.Id)) {
                    if(d.Applied__c) {
                        if(d.Discount_Type__c.equalsIgnoreCase('PSF')) {
                            if(d.PSF_Amount__c == null || d.PSF_Amount__c < 0) {
                                d.Applied__c = false;
                                error = true;
                                errorMsg = 'Please Provide Valid PSF Amount';
                                return null;
                            } else if(originalDiscountMap.get(d.Id) < d.PSF_Amount__c ) {
                                d.Applied__c = false;
                                error = true;
                                errorMsg = 'PSF Cannot be Increased Beyond What is Already Defined';
                                return null;
                            } else 
                            {
                             if(d.PSF_Amount__c != Null && u.Total_Carpet_Area_Sq_Ft__c != Null)
                             {
                               d.Total__c =(d.PSF_Amount__c * u.Total_Carpet_Area_Sq_Ft__c).setscale(2, RoundingMode.HALF_UP);  
                               system.debug('d.Total__c'+d.Total__c);
                             }
                             else
                             {
                               d.Total__c = 0; 
                                }
                                if(d.Discount_Category__c.equalsIgnoreCase('Discount')) {
                                    if(d.Total__c == Null)
                                    d.Total__c = 0;
                                    discountPrice += d.Total__c;   //error after discount
                                  system.debug('discountPrice' + discountPrice);

                                }
                            }
                        }
                        if(d.Discount_Type__c.equalsIgnoreCase('Lumpsum')) {
                            if(d.Amount__c == null || d.Amount__c < 0) {
                                d.Applied__c = false;
                                error = true;
                                errorMsg = 'Please Provide Valid Amount';
                                return null;
                            } else if(originalDiscountMap.get(d.Id) < d.Amount__c ) {
                                d.Applied__c = false;
                                error = true;
                                errorMsg = 'Amount Cannot be Increased Beyond What is Already Defined';
                                return null;
                            } else {
                                d.Total__c = d.Amount__c.setscale(2, RoundingMode.HALF_UP);
                                if(d.Discount_Category__c.equalsIgnoreCase('Discount')) {
                                    discountPrice += d.Total__c;
                                }
                            }
                        }
                    }
                }
            }

            /*
                For Percentage type discount:
                1] Get new agreement value after deducting Lumpsum & PSF discount
                2] Then calculate percentage discount on new agreement value
            */
            for(Discount__c d : discountList) {
                if(originalDiscountMap.containsKey(d.Id)) {
                    if(d.applied__c) {
                        if(d.Discount_Type__c.equalsIgnoreCase('Percentage')) {
                            if(d.Percentage_Of_AV__c == null || d.Percentage_Of_AV__c < 0) {
                                d.Applied__c = false;
                                error = true;
                                errorMsg = 'Please Provide Valid Percentage';
                                return null;
                            } else if(originalDiscountMap.get(d.Id) < d.Percentage_Of_AV__c) {
                                d.Applied__c = false;
                                error = true;
                                errorMsg = 'Percentage Cannot be Increased Beyond What is Already Defined';
                                return null;
                            } else {
                                allPriceInfoMap = InventoryPriceManagementServices.getAllPriceInfo(u.Id, priceListGroupMap, priceListMap, carParkPrice, discountPrice);
                               
                                d.Total__c = ((d.Percentage_Of_AV__c * allPriceInfoMap.get('Agreement Value')) / 100).setscale(2, RoundingMode.HALF_UP);
                               system.debug('d.Total__c '+d.Total__c );
                                if(d.Discount_Category__c.equalsIgnoreCase('Discount')) {
                                    discountPrice += d.Total__c;
                                    system.debug('discountPrice '+ discountPrice );
                                }
                            }
                        }
                    }
                }
            }
        }

        //Recalculate agreement value after deducting percentage discount
        allPriceInfoMap = InventoryPriceManagementServices.getAllPriceInfo(u.Id, priceListGroupMap, priceListMap, carParkPrice, discountPrice);
        if(allPriceInfoMap != null && !allPriceInfoMap.isEmpty()) {
            for(String ch: allPriceInfoMap.keySet()) {
                allPriceInfoFormattedMap.put(ch, InventoryPriceManagementServices.currencyFormat(allPriceInfoMap.get(ch)));
                if(allPriceInfoMap.get(ch) != allPriceOriginalInfoMap.get(ch)) {
                    priceDifferenceMap.put(ch, true);
                } else {
                    priceDifferenceMap.put(ch, false);
                }
            }
        }
        //Get Payment Break-Up as per Payment Scheme
        paymentMilestoneWrapperList = InventoryPriceManagementServices.getPaymentSummaryInfo(u.Id, selectedScheme, allPriceInfoMap, priceListMap);
        return null;
    }

    public pageReference continueMethod() {
        page2 = true;
        return null;
    }

    public PageReference save() {
        error = false;
        errorMsg = '';
        q.Payment_Scheme__c = selectedScheme;

        if(priceListGroupMap != null && !priceListGroupMap.isEmpty()) {
            Integer i = 1;
            for(String bucket: priceListGroupMap.keySet()) {
                q.put('Charge_Bucket_'+i+'__c', bucket);
                q.put('Charge_Bucket_'+i+'_Amount__c', allPriceInfoMap.get(bucket));
                q.put('Charge_Bucket_'+i+'_SGST__c', allPriceInfoMap.get(bucket+' SGST'));
                q.put('Charge_Bucket_'+i+'_CGST__c', allPriceInfoMap.get(bucket+' CGST'));
                q.put('Charge_Bucket_'+i+'_Total_Tax__c', allPriceInfoMap.get(bucket+' TAX'));
                i++;
            }
        }
        if(allPriceInfoMap.containsKey('Total Discount Price')) {
            q.Total_Discount__c = allPriceInfoMap.get('Total Discount Price');
        }
        
        if(discountList != null && !discountList.isEmpty()) {
            for(Discount__c d : discountList) {
                if(d.Applied__c) {
                    if(d.Discount_Category__c.equalsIgnoreCase('Discount')) {
                        if(d.Category__c.equalsIgnoreCase('Approved')) {
                            if(q.Total_Approved_Discount__c == null)
                                q.Total_Approved_Discount__c = 0;
                            if(d.Total__c != Null)
                            q.Total_Approved_Discount__c += d.Total__c;   //error after discount
                        } else if(d.Category__c.equalsIgnoreCase('Unapproved')) {
                            if(q.Total_Unapproved_Discount__c == null)
                                q.Total_Unapproved_Discount__c = 0;
                            if(d.Total__c != Null)
                                d.Total__c = 0;
                            q.Total_Unapproved_Discount__c += d.Total__c;  //error after discount
                        }
                    } else if(d.Discount_Category__c.equalsIgnoreCase('Credit Note')) {
                        if(q.Total_Credit_Note_Amount__c == null)
                            q.Total_Credit_Note_Amount__c = 0;
                        q.Total_Credit_Note_Amount__c += d.Total__c;
                    }
                }
            }
        }
        /*if(q.Total_Unapproved_Discount__c > 0) {
            q.Discount_Approval_Required__c = true;
            Map<String, Team_Members__c> teamMemberMap = new Map<String, Team_Members__c>();
            teamMemberMap = InventoryPriceManagementServices.getApprovalTeamMemberDetails(u.Project__c, 'Unapproved Discount Team');
            
            if(!teamMemberMap.isEmpty() && teamMemberMap != null) {
                for(String s: teamMemberMap.KeySet()) {
                    if(s.equalsIgnoreCase('Level 1'))
                        q.Level_1_Approver__c = teamMemberMap.get(s).User__c;
                    else if(s.equalsIgnoreCase('Level 2'))
                        q.Level_2_Approver__c = teamMemberMap.get(s).User__c;
                    else if(s.equalsIgnoreCase('Level 3'))
                        q.Level_3_Approver__c = teamMemberMap.get(s).User__c;
                }
            }
        }*/
        
        Id qId = null;
        Database.saveResult sr = Database.insert(q);
        if(sr.isSuccess()) {
            qId = sr.getId();
            List<Charge_Detail__c> chargeDetailsList = new List<Charge_Detail__c>();
            List<Discount_Applied__c> discountAppliedList = new List<Discount_Applied__c>();
            List<Car_Park_Required__c> carParkReqList = new List<Car_Park_Required__c>();
            List<Payment_Milestone__c> paymentMilestoneList = new List<Payment_Milestone__c>();

            if(priceListGroupMap != null && !priceListGroupMap.isEmpty()) {
                for(String bucket: priceListGroupMap.keySet()) {
                    for(String priceName: priceListGroupMap.get(bucket)) {
                        Charge_Detail__c chDetail = new Charge_Detail__c();
                        chDetail.Name = priceName;
                        if(priceListMap.containsKey(priceName))
                            chDetail.Charge_Description__c = priceListMap.get(priceName).Charge_Description__c;
                        chDetail.Charge_Bucket__c = bucket;
                        chDetail.Charge_Amount__c = allPriceInfoMap.get(priceName);
                        chDetail.Charge_SGST__c = allPriceInfoMap.get(priceName+' SGST');
                        chDetail.Charge_CGST__c = allPriceInfoMap.get(priceName+' CGST');
                        chDetail.Charge_Total_Tax__c = allPriceInfoMap.get(priceName+' TAX');
                        if(chDetail.Charge_Rate__c!= NULL)
                        chDetail.Charge_Rate__c = (allPriceInfoMap.get(priceName) / u.Saleable_Area__c).setscale(2, RoundingMode.HALF_UP);
                        chDetail.Quotation__c = qId;
                        chargeDetailsList.add(chDetail);
                    }
                }
            }

            if(discountList != null && !discountList.isEmpty()) {
                for(Discount__c d : discountList) {
                    if(d.Applied__c) {
                        Discount_Applied__c da = new Discount_Applied__c();
                        da.Quotation__c = qId;
                        da.Amount__c = d.Amount__c;
                        system.debug('da.Amount__c'+da.Amount__c);
                        da.Percentage_of_AV__c = d.Percentage_of_AV__c;
                        system.debug('da.Percentage_of_AV__c '+da.Percentage_of_AV__c );
                        da.PSF_Amount__c = d.PSF_Amount__c;
                        system.debug('da.PSF_Amount__c'+da.PSF_Amount__c);
                        da.Discount_Type__c = d.Discount_Type__c;
                        da.Category__c = d.Category__c;
                        da.Discount_Category__c = d.Discount_Category__c;
                        da.Description__c = d.Description__c;
                        da.Discount_Reason__c = d.Discount_Reason__c;
                        da.Total__c = d.Total__c;
                        system.debug('da.Total__c'+da.Total__c);
                        da.Discount__c = d.Id;
                        
                        discountAppliedList.add(da);
                    }
                }
            }

            if(carParkList != null && !carParkList.isEmpty()) {
                for(InventoryPriceManagementServices.CarParkWrapper cp: carParkList) {
                    if(cp.carParkRequiredCount > 0) {
                        Car_Park_Required__c cpr = new Car_Park_Required__c();
                        cpr.Quotation__c = qId;
                        cpr.Car_Park_Type__c = cp.carParkType;
                        cpr.Car_Park_Count__c = cp.carParkRequiredCount;
                        cpr.Car_Park_Amount__c = cp.carParkAmount * cp.carParkRequiredCount;
                        carParkReqList.add(cpr);
                    }
                }
            }

            if(paymentMilestoneWrapperList != null && !paymentMilestoneWrapperList.isEmpty()) {
                for(InventoryPriceManagementServices.PaymentMilestoneWrapper pmw: paymentMilestoneWrapperList) {
                    if(pmw.pm != null) {
                        pmw.pm.Quotation__c = qId;
                        paymentMilestoneList.add(pmw.pm);
                    }
                }
            }

            if(!chargeDetailsList.isEmpty() && chargeDetailsList != null) {
                insert chargeDetailsList;
            }
            if(!discountAppliedList.isEmpty() && discountAppliedList != null) {
                insert discountAppliedList;
            }
            if(!carParkReqList.isEmpty() && carParkReqList != null) {
                insert carParkReqList;
            }
            if(!paymentMilestoneList.isEmpty() && paymentMilestoneList != null) {
                insert paymentMilestoneList;
            }

            return new PageReference('/lightning/r/Quotation__c/' + sr.getId() + '/view');
        } else {
            for(Database.Error err : sr.getErrors()) {
                system.debug('Error: '+err);
            }
            errorMsg = 'Quotation Cannot be Saved. Please Contact Your System Administrator.';
            return null;
        }
    }

    public pageReference resetQuote() {
        system.debug('In ResetQoute Method');
        page2 = false;
        PageReference pageRef;
        pageRef = new PageReference('/apex/Ex_QuotationGeneration?oppId='+oppId+'&uId='+uId); 
        pageRef.setRedirect(true);
        return pageRef;
    }
}
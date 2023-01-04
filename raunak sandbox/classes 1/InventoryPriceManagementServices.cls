public with sharing class InventoryPriceManagementServices {
    
    public static Unit__c getUnitInfo(Id uId) {
        List<Unit__c> unitList = new List<Unit__c>();
        String[] types = new String[]{'Unit__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ', Project__r.Name, Tower__r.Name, Tower__r.Sector__c from Unit__c Where Id = \''+uId+'\''; 
        system.debug(soqlQuery);
        unitList = Database.query(soqlQuery);
        if (unitList.size() > 0) {
            return unitList[0];
        } else {
            return null;
        }
    }

    public static Opportunity_c__c getOpportunityInfo(Id oppId) {
        List<Opportunity_c__c> oppList = new List<Opportunity_c__c>();
        String[] types = new String[]{'Opportunity_c__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ' from Opportunity_c__c Where Id = \''+oppId+'\''; 
        system.debug(soqlQuery);
        oppList = Database.query(soqlQuery);
        if (oppList.size() > 0) {
            return oppList[0];
        } else {
            return null;
        }
    }

    public static List<Payment_Scheme__c> getPaymentSchemeInfo(Id tId) {
        List<Payment_Scheme__c> schemeList = new List<Payment_Scheme__c>();
        String[] types = new String[]{'Payment_Scheme__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ' from Payment_Scheme__c Where Tower__c = \''+tId+'\' AND Active__c = true'; 
        system.debug(soqlQuery);
        schemeList = Database.query(soqlQuery);
        if (schemeList.size() > 0) {
            return schemeList;
        } else {
            return null;
        }
    }

    public static List<CarParkWrapper> getCarParkInfo(String maintainType, Id recordId) {
        List<CarParkWrapper> carParkList = new List<CarParkWrapper>();
		List<AggregateResult> cpList = new List<AggregateResult>();
        
        if(maintainType.equalsIgnoreCase('Project')) {
            cpList = [Select Count(Id) cpCount, Type__c, MAX(Amount__c) cpAmount from Car_Park__c
                      where Status__c = 'Available' AND Project__c =: recordId
                      GROUP BY Type__c ORDER BY Type__c];
        } else if(maintainType.equalsIgnoreCase('Sector')) {
            cpList = [Select Count(Id) cpCount, Type__c, MAX(Amount__c) cpAmount from Car_Park__c
                      where Status__c = 'Available' AND Sector__c =: recordId
                      GROUP BY Type__c ORDER BY Type__c];
        } else if(maintainType.equalsIgnoreCase('Tower')) {
            cpList = [Select Count(Id) cpCount, Type__c, MAX(Amount__c) cpAmount from Car_Park__c
                      where Status__c = 'Available' AND Tower__c =: recordId
                      GROUP BY Type__c ORDER BY Type__c];
        }
        system.debug('cpList: '+cpList);
        
        if(!cpList.isEmpty()) {
            for(AggregateResult ag: cpList) {
                carParkList.add(new CarParkWrapper((String)ag.get('Type__c'), (Decimal)ag.get('cpCount'), (Decimal)ag.get('cpAmount'), 0, currencyFormat((Decimal)ag.get('cpAmount'))));
            }
        }
        return carParkList;
    }

    public static List<Discount__c> getProjectLevelDiscountInfo(Id pId) {
        List<Discount__c> discountList = new List<Discount__c>();
        String[] types = new String[]{'Discount__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ' from Discount__c Where Project__c = \''+pId+'\' AND Active__c = true'; 
        system.debug(soqlQuery);
        discountList = Database.query(soqlQuery);
        if (discountList.size() > 0) {
            return discountList;
        } else {
            return null;
        }
    }

    public static List<Discount__c> getTowerLevelDiscountInfo(Id pId, Id tId) {
        List<Discount__c> discountList = new List<Discount__c>();
        String[] types = new String[]{'Discount__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ' from Discount__c Where Project__c = \''+pId+'\' AND Tower__c = \''+tId+'\' AND Active__c = true'; 
        system.debug(soqlQuery);
        discountList = Database.query(soqlQuery);
        if (discountList.size() > 0) {
            return discountList;
        } else {
            return null;
        }
    }

    public static Map<String, Decimal> getAllPriceInfo(Id uId, Map<String, List<String>> priceListGroupMap, Map<String, Pricing_List__c> priceListMap, Decimal carParkPrice, Decimal discountPrice) {
        Unit__c u = getUnitInfo(uId);

        if(u != null) {
            Map<String, Decimal> allPriceInfoMap = new Map<String, Decimal>();
            
            Pricing_List__c pl = new Pricing_List__c();
            pl.Unit__c = u.Id;
            pl.Charge_Bucket__c = 'Agreement Value';
            pl.Charge_Name__c = 'Car Parking Charges';
            pl.Charge_Type__c = 'Lumpsum';
            pl.Charge_Amount__c = carParkPrice;
            priceListMap.put(pl.Charge_Name__c, pl);
            
            allPriceInfoMap.put('Total Car Park Price', carParkPrice);

            for(String priceGroup: priceListGroupMap.keySet()) {
                if(!priceGroup.equalsIgnoreCase('Statutory Charges')) {
                    for(String priceList: priceListGroupMap.get(priceGroup)) {
                        Decimal amount = 0;
                        Decimal sgst = 0;
                        Decimal cgst = 0;

                        if(priceListMap.containsKey(priceList)) {
                            if(priceListMap.get(priceList).Charge_Name__c.equalsIgnoreCase('Car Parking Charges')) {
                                amount = carParkPrice;
                                sgst = (((carParkPrice / 100) * priceListMap.get('Basic Charge').GST__c) / 2).setscale(0,RoundingMode.HALF_UP);
                                cgst = (((carParkPrice / 100) * priceListMap.get('Basic Charge').GST__c) / 2).setscale(0,RoundingMode.HALF_UP);
                            } else {
                                amount = (priceListMap.get(priceList).Actual_Cost__c).setscale(0,RoundingMode.HALF_UP);
                                system.debug('amount:::::::::::'+amount+ 'checkMap'+priceListMap.get(priceList).Actual_Cost__c );
                                sgst = (priceListMap.get(priceList).GST_Amount__c / 2).setscale(0,RoundingMode.HALF_UP);
                                system.debug('sgst:::::::::::'+sgst+ 'checkMap'+priceListMap.get(priceList).GST_Amount__c / 2 );
                                cgst = (priceListMap.get(priceList).GST_Amount__c / 2).setscale(0,RoundingMode.HALF_UP);
                            }
                            allPriceInfoMap.put(priceList, amount);
                            allPriceInfoMap.put(priceList+' SGST', sgst);
                            allPriceInfoMap.put(priceList+' CGST', cgst);
                            allPriceInfoMap.put(priceList+' TAX', (sgst + cgst));
                        
                            //Grouping Pricing Information
                            if(allPriceInfoMap.containsKey(priceListMap.get(priceList).Charge_Bucket__c)) {
                                allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c, allPriceInfoMap.get(priceListMap.get(priceList).Charge_Bucket__c) + amount);
                                allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' SGST', allPriceInfoMap.get(priceListMap.get(priceList).Charge_Bucket__c+' SGST') + sgst);
                                allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' CGST', allPriceInfoMap.get(priceListMap.get(priceList).Charge_Bucket__c+' CGST') + cgst);
                                allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' TAX', allPriceInfoMap.get(priceListMap.get(priceList).Charge_Bucket__c+' TAX') + sgst + cgst);
                                allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' SIZE', allPriceInfoMap.get(priceListMap.get(priceList).Charge_Bucket__c+' SIZE') + 1);
                            } else {
                                allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c, amount);
                                allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' SGST', sgst);
                                allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' CGST', cgst);
                                allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' TAX', sgst + cgst);
                                allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' SIZE', 1);
                            }
                        }
                    }
                }
            }

            if(allPriceInfoMap.containsKey('Agreement Value')) {
                if(discountPrice != 0) {
                    //Discount Price will be deducted from Basic Charge also recalculate taxes
                    allPriceInfoMap.put('Basic Charge', allPriceInfoMap.get('Basic Charge') - discountPrice);
                    Decimal sgstBasic =  (((allPriceInfoMap.get('Basic Charge') / 100) * priceListMap.get('Basic Charge').GST__c) / 2).setscale(0,RoundingMode.HALF_UP);
                    Decimal cgstBasic =  (((allPriceInfoMap.get('Basic Charge') / 100) * priceListMap.get('Basic Charge').GST__c) / 2).setscale(0,RoundingMode.HALF_UP);
                    allPriceInfoMap.put('Basic Charge SGST', sgstBasic);
                    allPriceInfoMap.put('Basic Charge CGST', cgstBasic);
                    allPriceInfoMap.put('Basic Charge TAX', sgstBasic + cgstBasic);

                    //Discount Price will be deducted from Agreement Value Group also recalculate taxes
                    allPriceInfoMap.put('Agreement Value', allPriceInfoMap.get('Agreement Value') - discountPrice);
                    Decimal sgstBasicDiff = ((priceListMap.get('Basic Charge').GST_Amount__c / 2) - sgstBasic).setscale(0,RoundingMode.HALF_UP);
                    Decimal cgstBasicDiff = ((priceListMap.get('Basic Charge').GST_Amount__c / 2) - cgstBasic).setscale(0,RoundingMode.HALF_UP);
                    allPriceInfoMap.put('Agreement Value SGST', allPriceInfoMap.get('Agreement Value SGST') - sgstBasicDiff);
                    allPriceInfoMap.put('Agreement Value CGST', allPriceInfoMap.get('Agreement Value CGST') - cgstBasicDiff);
                    allPriceInfoMap.put('Agreement Value TAX', allPriceInfoMap.get('Agreement Value TAX') - sgstBasicDiff - cgstBasicDiff);
                }
                allPriceInfoMap.put('Total Discount Price', discountPrice);
            }

            if(priceListGroupMap.containsKey('Statutory Charges')) {
                Decimal amount = 0;
                Decimal sgst = 0;
                Decimal cgst = 0;

                for(String priceList: priceListGroupMap.get('Statutory Charges')) {
                    if(priceListMap.get(priceList).Charge_Type__c.equalsIgnoreCase('Percentage')) {
                        if(allPriceInfoMap.containsKey('Agreement Value')) {
                            amount = ((allPriceInfoMap.get('Agreement Value') * priceListMap.get(priceList).Charge_Percentage__c) / 100).setscale(0,RoundingMode.HALF_UP);
                            sgst = (((amount / 100) * priceListMap.get(priceList).GST__c) / 2).setscale(0,RoundingMode.HALF_UP);
                            cgst = (((amount / 100) * priceListMap.get(priceList).GST__c) / 2).setscale(0,RoundingMode.HALF_UP);
                        }   
                    } else {
                        amount = (priceListMap.get(priceList).Actual_Cost__c).setscale(0,RoundingMode.HALF_UP);
                        sgst = (((amount / 100) * priceListMap.get(priceList).GST__c) / 2).setscale(0,RoundingMode.HALF_UP);
                        cgst = (((amount / 100) * priceListMap.get(priceList).GST__c) / 2).setscale(0,RoundingMode.HALF_UP);
                    }
                    allPriceInfoMap.put(priceList, amount);
                    allPriceInfoMap.put(priceList+' SGST', sgst);
                    allPriceInfoMap.put(priceList+' CGST', cgst);
                    allPriceInfoMap.put(priceList+' TAX', (sgst + cgst));

                    //Grouping Pricing Information
                    if(allPriceInfoMap.containsKey(priceListMap.get(priceList).Charge_Bucket__c)) {
                        allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c, allPriceInfoMap.get(priceListMap.get(priceList).Charge_Bucket__c) + amount);
                        allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' SGST', allPriceInfoMap.get(priceListMap.get(priceList).Charge_Bucket__c+' SGST') + sgst);
                        allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' CGST', allPriceInfoMap.get(priceListMap.get(priceList).Charge_Bucket__c+' CGST') + cgst);
                        allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' TAX', allPriceInfoMap.get(priceListMap.get(priceList).Charge_Bucket__c+' TAX') + sgst + cgst);
                        allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' SIZE', allPriceInfoMap.get(priceListMap.get(priceList).Charge_Bucket__c+' SIZE') + 1);
                    } else {
                        allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c, amount);
                        allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' SGST', sgst);
                        allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' CGST', cgst);
                        allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' TAX', sgst + cgst);
                        allPriceInfoMap.put(priceListMap.get(priceList).Charge_Bucket__c+' SIZE', 1);
                    }
                }
            }
            return allPriceInfoMap;
        } else {
            return null;
        }
    }

    public static Map<String, Pricing_List__c> getPriceListMap(Id uId) {
        if(uId != null) {
            Map<String, Pricing_List__c> priceListMap = new Map<String, Pricing_List__c>();
            List<Pricing_List__c> priceList = getPriceListInfo(uId);

            if(priceList != null) {
                for(Pricing_List__c pl: priceList) {
                    priceListMap.put(pl.Charge_Name__c, pl);
                }
            }
            return priceListMap;
        } else {
            return null;
        }
    }

    public static Map<String, List<String>> getPriceListGroupMap(Id uId) {
        if(uId != null) {
            Map<String, List<String>> priceListGroupMap = new Map<String, List<String>>();
            List<Pricing_List__c> priceList = getPriceListInfo(uId);

            if(priceList != null) {
                for(Pricing_List__c pl: priceList) {
                    if(priceListGroupMap.containsKey(pl.Charge_Bucket__c)) {
                        priceListGroupMap.get(pl.Charge_Bucket__c).add(pl.Charge_Name__c);
                    } else {
                        List<String> newList = new List<String>();
                        newList.add(pl.Charge_Name__c);
                        priceListGroupMap.put(pl.Charge_Bucket__c, newList);
                    }
                }
                if(priceListGroupMap.containsKey('Agreement Value') ){
                    priceListGroupMap.get('Agreement Value').add('Car Parking Charges');
                }
            }
            return priceListGroupMap;
        } else {
            return null;
        }
    }

    public static List<Pricing_List__c> getPriceListInfo(Id uId) {
        List<Pricing_List__c> priceList = new List<Pricing_List__c>();
        String[] types = new String[]{'Pricing_List__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ' from Pricing_List__c Where Unit__c = \''+uId+'\''; 
        system.debug(soqlQuery);
        priceList = Database.query(soqlQuery);
        if (priceList.size() > 0) {
            return priceList;
        } else {
            return null;
        }
    }

    public static List<PaymentMilestoneWrapper> getPaymentSummaryInfo(Id uId, Id schemeId, Map<String, Decimal> allPriceInfoMap, Map<String, Pricing_List__c> priceListMap) {
        List<PaymentMilestoneWrapper> paymentMilestoneWrapperList = new List<PaymentMilestoneWrapper>();
        List<Payment_Scheme_Milestone__c> psMilestoneList = getPaymentSchemeMilestoneInfo(schemeId);
        Unit__c u = getUnitInfo(uId);
        
        if(u != null) {
            List<Construction_Stage__c> cStageList = getConsturctionStageList(u.Project__c, u.Tower__c);
            List<SelectOption> cStageOptionList = new List<SelectOption>();
            if(cStageList != null && !cStageList.isEmpty()) {
                cStageOptionList.add(new SelectOption('', '--None--'));
                for(Construction_Stage__c cs : cStageList) {
                    cStageOptionList.add(new SelectOption(cs.Id, cs.Name));
                }
            }
            Map<Id, Construction_Stage__c> cStageMap = getConstructionStagesMap(u.Project__c, u.Tower__c);

            if(psMilestoneList != null) {
                Decimal tokenAmount = 0;
                Decimal grandAmount = 0;
                Decimal grandPercentage = 0;
                Decimal grandSGST = 0;
                Decimal grandCGST = 0;
                Decimal grandTotalTax = 0;
                Decimal grandTotal = 0;

                for(Payment_Scheme_Milestone__c psm: psMilestoneList) {
                    Decimal amount = 0;
                    Decimal percentage = 0;
                    Decimal sgst = 0;
                    Decimal cgst = 0;
                    Decimal totalTax = 0;
                    Decimal total = 0;
                    Boolean agMilestone = false;

                    Payment_Milestone__c pm = new Payment_Milestone__c();
                    pm.Milestone_Name__c = psm.Milestone_Name__c;
                    pm.Milestone_Type__c = psm.Milestone_Type__c;
                    pm.No_of_Days__c = psm.No_of_Days__c;
                    pm.Construction_Stage__c = psm.Construction_Stage__c;
                    pm.Deduct_Token__c = psm.Deduct_Token__c;
                    pm.Sequence_No__c = psm.Sequence_No__c;
                    //pm.Registration_Milestone__c = psm.Registration_Milestone__c;
                    if(String.isNotBlank(psm.Milestone_Type__c) && psm.Milestone_Type__c.equals('Date Linked')) {
                        if(psm.No_of_Days__c != null) {
                            pm.Due_Date__c = System.today().addDays(Integer.valueOf(psm.No_of_Days__c));
                        }

                    } else if(String.isNotBlank(psm.Milestone_Type__c) && psm.Milestone_Type__c.equals('Construction Linked')) {
                        Date completionDate = null;
                        Boolean IsMilestoneAchieved = false;
                        system.debug('testcs'+cStageMap.get(psm.Construction_Stage__c));
                        Construction_Stage__c cStage = cStageMap.get(psm.Construction_Stage__c);
							
                        if(cStage.Actual_Completion_Date__c != null && cStage.Actual_Completion_Date__c > System.today()) {
                            completionDate = cStage.Actual_Completion_Date__c;
                        } else if(cStage.Actual_Completion_Date__c != null && cStage.Actual_Completion_Date__c <= System.today()) {
                            completionDate = system.today().addDays(60);
                            IsMilestoneAchieved = True;
                        }  else if(cStage.Expected_Completion_Date__c != null && cStage.Expected_Completion_Date__c > System.today()) {
                            completionDate = cStage.Expected_Completion_Date__c;
                        } else if(cStage.Expected_Completion_Date__c != null && cStage.Expected_Completion_Date__c <= System.today()) {
                            completionDate = system.today();
                        }   
                        if (completionDate == null) {
                            completionDate = system.today().addDays(365);
                        }
                        pm.Due_Date__c = completionDate.addDays(Integer.valueOf(psm.No_of_Days__c));

                        if(IsMilestoneAchieved) {
                            pm.Milestone_Complete_At_Booking__c = true;
                        } else {
                            pm.Milestone_Complete_At_Booking__c = false;
                        }
                    }

                    for(Integer i = 1; i <= 5; i++) {
                        if(String.isNotBlank((String)psm.get('Charge_Bucket_'+i+'__c'))) { 
                            pm.put('Charge_Bucket_'+i+'__c', psm.get('Charge_Bucket_'+i+'__c'));
                            
                            if(((String)psm.get('Charge_Bucket_'+i+'__c')).equalsIgnoreCase('Agreement Value')) {
                                //Calculation for agreement value bucket
                                if(((String)psm.get('Charge_Bucket_'+i+'_Type__c')).equalsIgnoreCase('Percentage') && psm.get('Charge_Bucket_'+i+'_Percentage__c') != null && psm.get('Charge_Bucket_'+i+'_Percentage__c') != 0) {
                                    system.debug('Percentage: '+(Decimal)psm.get('Charge_Bucket_'+i+'_Percentage__c'));
                                    system.debug('Agreement Value: '+allPriceInfoMap.get('Agreement Value'));
                                   
                                    amount = (((Decimal)psm.get('Charge_Bucket_'+i+'_Percentage__c') * allPriceInfoMap.get('Agreement Value')) / 100);
                                    system.debug('tesssssss'+(Decimal)psm.get('Charge_Bucket_'+i+'_Percentage__c'));
                                   percentage = (Decimal)psm.get('Charge_Bucket_'+i+'_Percentage__c');
                                    
                                } else {
                                    amount = (Decimal)psm.get('Charge_Bucket_'+i+'_Amount__c');
                                    percentage = (((Decimal)psm.get('Charge_Bucket_'+i+'_Amount__c') / allPriceInfoMap.get('Agreement Value')) * 100).setscale(2,RoundingMode.HALF_UP);
                                }
                                if(psm.Token_Amount__c != null && psm.Token_Amount__c != 0) {
                                    tokenAmount = psm.Token_Amount__c;
                                }
                                if(psm.Deduct_Token__c && tokenAmount != 0) {
                                    amount = amount - tokenAmount;
                                    percentage = ((amount / allPriceInfoMap.get('Agreement Value')) * 100).setscale(2,RoundingMode.HALF_UP);
                                }
                                if(priceListMap != null && priceListMap.containsKey('Basic Charge')) {
                                    sgst = (((amount / 100) * priceListMap.get('Basic Charge').GST__c) / 2).setscale(0,RoundingMode.HALF_UP);
                                    cgst = (((amount / 100) * priceListMap.get('Basic Charge').GST__c) / 2).setscale(0,RoundingMode.HALF_UP);
                                }
                                agMilestone = true;
                                totalTax = sgst + cgst;
                                total = amount + totalTax;
                                grandAmount += amount;
                                grandPercentage += percentage;
                                grandSGST += sgst;
                                grandCGST += cgst;
                                grandTotalTax += totalTax;
                                grandTotal += total;

                                pm.put('Charge_Bucket_'+i+'_Amount__c', amount);
                                pm.put('Charge_Bucket_'+i+'_Percentage__c', percentage);
                                pm.put('Charge_Bucket_'+i+'_SGST__c', sgst);
                                pm.put('Charge_Bucket_'+i+'_CGST__c', cgst);
                                pm.put('Charge_Bucket_'+i+'_Total_Tax__c', totalTax);
                            } else {
                                //Calculation for other than agreement value bucket
                                Decimal amountOther = 0;
                                Decimal sgstOther = 0;
                                Decimal cgstOther = 0;
                                Decimal totalTaxOther = 0;

                                pm.put('Charge_Bucket_'+i+'_Percentage__c', (Decimal)psm.get('Charge_Bucket_'+i+'_Percentage__c'));
                                
								
                                amountOther = (((Decimal)psm.get('Charge_Bucket_'+i+'_Percentage__c') * allPriceInfoMap.get((String)psm.get('Charge_Bucket_'+i+'__c'))) / 100);
                                pm.put('Charge_Bucket_'+i+'_Amount__c', amountOther);
                                
                                if(allPriceInfoMap.get((String)psm.get('Charge_Bucket_'+i+'__c')+' TAX') != null && allPriceInfoMap.get((String)psm.get('Charge_Bucket_'+i+'__c')+' TAX') != 0) {
                                    sgstOther = ((allPriceInfoMap.get((String)psm.get('Charge_Bucket_'+i+'__c')+' TAX') / 100) * (Decimal)psm.get('Charge_Bucket_'+i+'_Percentage__c')).setscale(0,RoundingMode.HALF_UP);
                                    cgstOther = ((allPriceInfoMap.get((String)psm.get('Charge_Bucket_'+i+'__c')+' TAX') / 100) * (Decimal)psm.get('Charge_Bucket_'+i+'_Percentage__c')).setscale(0,RoundingMode.HALF_UP);
                                }
                                totalTaxOther = sgstOther + cgstOther;
                                pm.put('Charge_Bucket_'+i+'_SGST__c', sgstOther);
                                pm.put('Charge_Bucket_'+i+'_CGST__c', cgstOther);
                                pm.put('Charge_Bucket_'+i+'_Total_Tax__c', totalTaxOther);
                            }
                        }
                    }
                    paymentMilestoneWrapperList.add(new PaymentMilestoneWrapper(psm, pm, pm.Milestone_Name__c, percentage, amount.round(System.RoundingMode.HALF_UP), currencyFormat(amount), totalTax, currencyFormat(totalTax), total, currencyFormat(total), agMilestone, pm.Milestone_Complete_At_Booking__c/*, pm.Registration_Milestone__c*/));
                }
                paymentMilestoneWrapperList.add(new PaymentMilestoneWrapper(null, null, 'Total', grandPercentage, grandAmount.round(System.RoundingMode.HALF_UP), currencyFormat(grandAmount), grandTotalTax, currencyFormat(grandTotalTax), grandTotal, currencyFormat(grandTotal), true, false/*, false*/));
            }
        }
        return paymentMilestoneWrapperList;
    }

    public static List<Payment_Scheme_Milestone__c> getPaymentSchemeMilestoneInfo(Id schemeId) {
        List<Payment_Scheme_Milestone__c> psMilestoneList = new List<Payment_Scheme_Milestone__c>();
        String[] types = new String[]{'Payment_Scheme_Milestone__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ' from Payment_Scheme_Milestone__c Where Payment_Scheme__c = \''+schemeId+'\' ORDER BY Sequence_No__c ASC'; 
        system.debug(soqlQuery);
        psMilestoneList = Database.query(soqlQuery);
        if (psMilestoneList.size() > 0) {
            return psMilestoneList;
        } else {
            return null;
        }
    }

    public static List<Construction_Stage__c> getConsturctionStageList(Id pId, Id tId) {
        List<Construction_Stage__c> cStageList = new List<Construction_Stage__c>();
        String[] types = new String[]{'Construction_Stage__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ' from Construction_Stage__c Where Tower__c = \''+tId+'\' AND Tower__r.Project__c = \''+pId+'\' ORDER BY Sequence_Number__c ASC'; 
        system.debug(soqlQuery);
        cStageList = Database.query(soqlQuery);
        if (cStageList.size() > 0) {
            return cStageList;
        } else {
            return null;
        }
    }

    public static Map<Id, Construction_Stage__c> getConstructionStagesMap(Id pId, Id tId) {
        Map<Id, Construction_Stage__c> cStageMap = new Map<Id, Construction_Stage__c>();
        List<Construction_Stage__c> cStageList = getConsturctionStageList(pId, tId);

        if(cStageList != null) {
            for(Construction_Stage__c cs: cStageList) {
                cStageMap.put(cs.Id, cs);
            }
        }
        return cStageMap;
    }

    public static Quotation__c getQuotationInfo(Id qId) {
        List<Quotation__c> qList = new List<Quotation__c>();
        String[] types = new String[]{'Quotation__c'};
        string queryFields = '';
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
            string sObjectname = res.getName();
            Map <String, Schema.SObjectField> fieldMap = res.fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMap.Values()) { 
                schema.describefieldresult dfield = sfield.getDescribe();
                String fieldLabel = dfield.getLabel();
                
                if(queryFields == null || queryFields == '') {
                    queryFields = dField.getName();
                } else {
                    queryFields = queryFields + ', ' + dField.getName();
                }
            }
        }
        String soqlQuery = 'Select ' + queryFields  + ' from Quotation__c Where Id = \''+qId+'\''; 
        system.debug(soqlQuery);
        qList = Database.query(soqlQuery);
        if (qList.size() > 0) {
            return qList[0];
        } else {
            return null;
        }
    }
    
    public static Map<String, Team_Members__c> getApprovalTeamMemberDetails(Id pId, String teamName) {
        Map<String, Team_Members__c> teamMemberMap = new Map<String, Team_Members__c>();
        List<Team__c> teamList = new List<Team__c>();
        List<Team_Members__c> teamMemberList = new List<Team_Members__c>();
        
        teamList = [Select Id, Name, Project__c, Team_Type__c from Team__c where Name =: teamName];
        system.debug('teamList: '+teamList);
        
        if(!teamList.isEmpty() && teamList != null) {
            teamMemberList = [Select Id, Name, User__c, Team__c, User_Active_Status__c, Availability__c, Sequence_Number__c from Team_Members__c
                              where Team__c =: teamList[0].Id AND User_Active_Status__c = true ORDER BY Sequence_Number__c ASC];
            system.debug('teamMemberList: '+teamMemberList);
            
            if(!teamMemberList.isEmpty() && teamMemberList != null) {
                for(Team_Members__c tm: teamMemberList) {
                    teamMemberMap.put('Level '+tm.Sequence_Number__c, tm);
                }
            }
        }
        return teamMemberMap;
    }

    public class CarParkWrapper {
        public String carParkType {get;set;}
        public Decimal carParkAvailableCount {get;set;}
        public Decimal carParkAmount {get;set;}
        public Decimal carParkRequiredCount {get;set;}
        public String carParkAmountString {get;set;}

        public CarParkWrapper(String cpType, Decimal cpAvailableCount, Decimal cpAmount, Decimal cpRequiredCount, String cpAmountString) {
            this.carParkType = cpType;
            this.carParkAvailableCount = cpAvailableCount;
            this.carParkAmount = cpAmount;
            this.carParkRequiredCount = cpRequiredCount;
            this.carParkAmountString = cpAmountString;
        }
    }

    public class PaymentMilestoneWrapper {
        public Payment_Scheme_Milestone__c psm {get;set;}
        public Payment_Milestone__c pm {get;set;}
        public String milestoneName {get;set;}
        public Decimal percentage {get;set;}
        public String percentageString {get;set;}
        public Decimal amount {get;set;}
        public String amountString {get;set;}
        public Decimal tax {get;set;}
        public String taxString {get;set;}
        public Decimal total {get;set;}
        public String totalString {get;set;}
        public Boolean agMilestone {get;set;}
        public String completedMilestone {get;set;}
        //public Boolean registrationMilestone {get;set;}

        public PaymentMilestoneWrapper(Payment_Scheme_Milestone__c psm, Payment_Milestone__c pm, String milestoneName, Decimal percentage, Decimal amount, String amountString, Decimal tax, String taxString, Decimal total, String totalString, Boolean agMilestone, Boolean completedMilestone/*, Boolean registrationMilestone*/) {
            this.psm = psm;
            this.pm = pm;
            this.milestoneName = milestoneName;
            this.Percentage = percentage;
            this.percentageString = String.valueOf(percentage)+'%';
            this.amount = amount;
            this.amountString = amountString;
            this.tax = tax;
            this.taxString = taxString;
            this.total = total;
            this.totalString = totalString;
            this.agMilestone = agMilestone;
            //this.registrationMilestone = registrationMilestone;
            if(completedMilestone)
                this.completedMilestone = 'background-color:#D7BF5E';
        }
    }

    public static String currencyFormat(Decimal amt) {
        String formattedAmount = '';
        Decimal tempAmt = amt.setscale(2,RoundingMode.HALF_UP);
        String stringAmt = tempAmt.toPlainString();
        String decimalPart;
        List<String> tempStr = new List<String>();
        if(String.isNotBlank(stringAmt)) {
            tempStr = stringAmt.split('\\.');
            if(tempStr != null && tempStr.size() ==2) {
                decimalPart = tempStr[1];
            }
        }
        formattedAmount = (tempAmt.format().contains('.')?tempAmt.format():(tempAmt.format()+'.'+decimalPart));
        return formattedAmount+ '/-';
    }
}
public with sharing class QuotationApprovalTemplate {

    Public String qId {get;set;}
    Public List<Quotation__c> qList {get;set;}
    Public String pName_tName {get;set;}
    Public String address {get;set;}
    Public String customerName {get;set;}
    Public String nationality {get;set;}
    Public String designation {get;set;}
    Public String booking_Type {get;set;}
    Public List<Billing_Plan_Line_Item__c> billingItemList {get;set;}
    //Public Map<Id, list<Quotation_Billing_Line_Item__c>> qItemMap {get;set;}
    Public List<String> additonalComments {get;set;}
    Public Map<string,Discount__C> originalDiscountMap{get;set;}
    Public Map<string,Decimal> appiledDiscountMap{get;set;}
    Public string revisedParking{get;set;}
    Public Map<Id, WrapperClass> wrapperMap {get;set;}
    Public Map<string, WrapperClass> originalBillingPlanMap {get;set;}
    //Public Map<string, WrapperClass> modifiedBillingPlanMap {get;set;}
    public string OriginalParking {get;set;}
    public set<string> groupName {get;set;}
    public Integer totalINMilestones {get;set;}
    public Integer completedMilestoneSize {get;set;}
    public Integer INcompletedMilestoneSize {get;set;}
    public string completedMilestoneAmountSTR {get;set;}
    public string modifiedSalesValue {get;set;}
    public string originalSalesValue {get;set;}
    public List<QuotationManagmentServices.PaymentMilestoneWrapper> pwListFinal {get;set;}
    public boolean allMilestoneCompleted {get;set;}
    public string originalCPFirmName {get;set;}
    public string revisedCPFirmName {get;set;}
    public list<IN_MilestonesWrapper> IN_MilestonesList {get;set;}
    public string lastDateOfCompletedMilestones {get;set;}
    
    public QuotationApprovalTemplate() {
        qList = new List<Quotation__c>();
        pName_tName = '';
        address = '';
        customerName = '';  
        nationality = '';
        designation = '';
        booking_Type = '';  
        billingItemList = new List<Billing_Plan_Line_Item__c>();
       // qItemMap = new Map<Id, list<Quotation_Billing_Line_Item__c>>();
        additonalComments = new List<String>();
        originalDiscountMap = new Map<string,Discount__C>();
        appiledDiscountMap = new Map<string,decimal>(); 
        revisedParking = '';
        wrapperMap = new Map<Id, WrapperClass>();
        OriginalParking = '';
        originalBillingPlanMap = new Map<string, WrapperClass>();
        groupName = new set<string>();
        //modifiedBillingPlanMap = new Map<string, WrapperClass>();
        INcompletedMilestoneSize = 0;
        completedMilestoneSize = 0;
        totalINMilestones = 0;
        pwListFinal = new List<QuotationManagmentServices.PaymentMilestoneWrapper>();
        allMilestoneCompleted = true;
        originalCPFirmName = '';
        revisedCPFirmName = '';
        IN_MilestonesList = new list<IN_MilestonesWrapper>();
        lastDateOfCompletedMilestones = '';
              
        if(ApexPages.currentPage().getParameters().containsKey('qId') != null)
            qId =  ApexPages.currentPage().getParameters().get('qId'); 
            DescribeSObjectResult describeResult = Quotation__c.getSObjectType().getDescribe();  
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            String query = ' SELECT ' + String.join( fieldNames, ',' ) + ',Project__r.name,Project__r.Broker_Percentage__c,Tower__r.Name,Property__r.name,' +
                         'Property__r.House_Unit_No__c,Property__r.Property_Type__c,Property__r.Is_Inclusive_Sale_Price__c,Project__r.Terms_And_Conditions__c,'+
                         'Opportunity__R.Account.House_No__c,Opportunity__R.Account.Street__c,Opportunity__R.Account.Street_2__c,' + 
                         'Opportunity__R.Account.Street_3__c,Opportunity__R.Account.Locality__c,Opportunity__R.Account.City__c,' +
                         'Opportunity__R.Account.Postal_code__c,Opportunity__R.Account.Country_Picklist__c,Opportunity__R.Account.firstName,Opportunity__R.Account.Salutation,' +
                         'Opportunity__R.Account.lastName,Opportunity__R.Account.Resident_Status__pc,Opportunity__R.Account.Designation__pc,Opportunity__R.Account.Company__pc,' +
                         'Opportunity__R.Account.Occupation__c,Billing_Plan__R.Billing_Plan_Name__c,Billing_Plan__R.Record_Type_Name__c,' +
                         'Opportunity__R.Enquiry_Type__c,Opportunity__R.Change_In_Booking_Source__c,Opportunity__R.Partner_s_Name__c,Opportunity__R.Name,' +
                         'Opportunity__R.Brokerage_Percentage__c,Property__r.Material_No__c,Tower__r.Tower_Name__c,Channel_Partner__R.Name,' +
                         'Opportunity__R.Broker_Account__c,Opportunity__R.Broker_Account__r.Name,Opportunity__R.Broker_Account__r.Name_1__c,Channel_Partner__R.Name_1__c' + 
                         ' FROM ' + describeResult.getName() + ' where id=' + '\'' + qId + '\''; 
            qList = Database.query( query );   
            if(!qList.isEmpty()){
                pName_tName = qList[0].Project__r.name + '/' + qList[0].Tower__r.Tower_Name__c + '/' + qList[0].Property__r.House_Unit_No__c;
                if(qList[0].Opportunity__R.Account.House_No__c != null)
                    address = qList[0].Opportunity__R.Account.House_No__c;
                if(qList[0].Opportunity__R.Account.Street__c != null)
                    address += ', ' + qList[0].Opportunity__R.Account.Street__c;  
                if(qList[0].Opportunity__R.Account.Street_2__c != null)
                    address += ', ' + qList[0].Opportunity__R.Account.Street_2__c;   
                if(qList[0].Opportunity__R.Account.Street_3__c != null)
                    address += ', ' + qList[0].Opportunity__R.Account.Street_3__c;    
                if(qList[0].Opportunity__R.Account.Locality__c != null)
                    address += ', ' + qList[0].Opportunity__R.Account.Locality__c;    
                if(qList[0].Opportunity__R.Account.City__c != null)
                    address += ', ' + qList[0].Opportunity__R.Account.City__c; 
                if(qList[0].Opportunity__R.Account.Postal_code__c != null)
                    address += ', ' + qList[0].Opportunity__R.Account.Postal_code__c;
                if(qList[0].Opportunity__R.Account.Country_Picklist__c != null)
                    address += ', ' + qList[0].Opportunity__R.Account.Country_Picklist__c;   
                
                //if(qList[0].Opportunity__R.Account.Salutation != null)
                    //customerName = qList[0].Opportunity__R.Account.Salutation;
                if(qList[0].Opportunity__R.Name != null)
                    customerName = qList[0].Opportunity__R.Name;
                //if(qList[0].Opportunity__R.Account.lastName != null)
                    //customerName +=  ' ' + qList[0].Opportunity__R.Account.lastName;
                
                if(qList[0].Opportunity__R.Account.Resident_Status__pc != null)
                    nationality = qList[0].Opportunity__R.Account.Resident_Status__pc;

                if(qList[0].Opportunity__R.Account.Company__pc != null)
                    designation = qList[0].Opportunity__R.Account.Company__pc;
                if(qList[0].Opportunity__R.Account.Designation__pc != null)
                    designation += ' - ' +qList[0].Opportunity__R.Account.Designation__pc;   
                    
                    
                if(qList[0].Billing_Plan__R.Billing_Plan_Name__c!= null)    
                    booking_Type = qList[0].Billing_Plan__R.Billing_Plan_Name__c;
                
                if(qList[0].Opportunity__R.Broker_Account__c != null){
                    originalCPFirmName = qList[0].Opportunity__R.Broker_Account__R.Name;
                }
                if(qList[0].Opportunity__R.Broker_Account__c != null){
                    originalCPFirmName +=' - '+ qList[0].Opportunity__R.Broker_Account__R.Name_1__c;
                }
                
                if(qList[0].Channel_Partner__c != null){
                    revisedCPFirmName = qList[0].Channel_Partner__R.Name;
                }
                if(qList[0].Channel_Partner__c != null){
                    revisedCPFirmName +=' - '+ qList[0].Channel_Partner__R.Name_1__c;
                }

                if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){        
                    modifiedSalesValue = QuotationManagmentServices.INFormatR(qList[0].Total_Agreement_Value_Modified__c);  
                    originalSalesValue = QuotationManagmentServices.INFormatR(qList[0].Total_Agreement_Value_Original__c);
                }else{
                    modifiedSalesValue = QuotationManagmentServices.INFormatR(qList[0].Total_Agreement_Value_Inc_GST_Modified__c);  
                    originalSalesValue = QuotationManagmentServices.INFormatR(qList[0].Total_Agreement_Value_Inc_GST_Original__c);
                }
                
                Map<Id,Billing_Plan_Line_Item__c> bplMap = new Map<Id,Billing_Plan_Line_Item__c>();
                billingItemList = [select id,name,Payment_Plan_Line_Item_Name__c,Payment_Group__c,Milestone_Number__c,
                                Payment_Plan__c,Line_Item_Type__c,Terms_of_Payment_Key__c,Percentage_Of_Value_To_Be_Invoiced__c,
                                Order__c,Usage__c,Date_Description__c,Due_After_Days__c, Is_IN00_01_Milesone__c
                                from Billing_Plan_Line_Item__c where Payment_Plan__c =: qList[0].Billing_Plan__C order by Order__c ASC];
               
               List<QuotationManagmentServices.PaymentMilestoneWrapper> pwList = QuotationManagmentServices.getCustomerViewPaymentSchedule(qList[0].id);
                List< Payment_Plan_Line_Item__c > ppl = [select id,name, Payment_Plan__c, Usage__c, Percentage_Of_Value_To_Be_Invoiced__c,
                            Payment_Group__c, Milestone_Number__c, Date_Description__c from Payment_Plan_Line_Item__c where 
                            Payment_Plan__c =: qList[0].Billing_Plan__c 
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
                decimal completedMilestoneAmountD = 0;
                decimal completedPercentage = 0;
                decimal completedAmount = 0;
                decimal completedCGST = 0;
                decimal completedSGST = 0;
                decimal completedTotalGST = 0;
               // Integer loc = 0;
                //Integer loc1 = 0;
                Integer due_Days = 0;
                Integer s_No = 1;
                //boolean isAnyIN_Milestone = false;
                for(QuotationManagmentServices.PaymentMilestoneWrapper pw : pwList){
                    if(pw.paymentGroup == 'IN' && pw.is_IN001Milestone){
                        //isAnyIN_Milestone = true;
                        if(allMilestoneCompleted){
                            system.debug('inside all completed');
                            pwListFinal.add(pw);
                            
                        }else{
                            if(pw.isCompletedMilestone){
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
                                due_Days = pw.dueDays;
                                lastDateOfCompletedMilestones = QuotationManagmentServices.customDateFormat(pw.dueDateINDATE);
                               // loc1 = loc;
                                s_No = s_No + 1; 
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
                    pw.dueDays = due_Days;
                    pwListFinal.add(loc1,pw);
                } */
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
                            pw.totalGST_STR = QuotationManagmentServices.INFormatR(pw.totalGST_D);
                            if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){
                                pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD);
                            }else{
                                pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD + pw.totalGST_D);
                            }
                            pw.totalMilestoneD += completedMilestoneAmountD;
                            pw.totalMilestoneSTR = QuotationManagmentServices.INFormatR(pw.totalMilestoneD);
                            pw.milestonePercentage += completedPercentage;
                            pw.dueDays = due_Days;
                        }
                    }
                }
                if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){
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
                for(Billing_Plan_Line_Item__c bl : billingItemList){
                    if((bl.Payment_Group__c != 'IN') || (bl.Payment_Group__c == 'IN' && !bl.Is_IN00_01_Milesone__c)){
                        if(originalBillingPlanMap.containsKey(bl.Terms_of_Payment_Key__c)){
                            WrapperClass wp = new WrapperClass();
                            wp = originalBillingPlanMap.get(bl.Terms_of_Payment_Key__c);
                            wp.milestoneName = bl.Payment_Plan_Line_Item_Name__c;
                            wp.percentage += decimal.valueOf(bl.Percentage_Of_Value_To_Be_Invoiced__c);
                            wp.dusDays = string.valueOf(bl.Due_After_Days__c);
                            wp.mAmount = null;
                            wp.payment_group = bl.Payment_Group__c ;
                            wp.termKey = bl.Terms_of_Payment_Key__c;
                            originalBillingPlanMap.put(bl.Terms_of_Payment_Key__c,wp);
                            
                        }else{
                            WrapperClass wp = new WrapperClass();
                            wp.milestoneName = bl.Payment_Plan_Line_Item_Name__c;
                            wp.percentage = decimal.valueOf(bl.Percentage_Of_Value_To_Be_Invoiced__c);
                            wp.dusDays = string.valueOf(bl.Due_After_Days__c);
                            wp.mAmount = null;
                            wp.payment_group = bl.Payment_Group__c;
                            wp.termKey = bl.Terms_of_Payment_Key__c;
                            originalBillingPlanMap.put(bl.Terms_of_Payment_Key__c ,wp);
                        }
                        groupName.add(bl.Terms_of_Payment_Key__c);
                    }else{
                        if(originalBillingPlanMap.containsKey(bl.Payment_Group__c)){
                            WrapperClass wp = new WrapperClass();
                            wp = originalBillingPlanMap.get(bl.Payment_Group__c);
                            wp.milestoneName = bl.Payment_Plan_Line_Item_Name__c;
                            wp.percentage += decimal.valueOf(bl.Percentage_Of_Value_To_Be_Invoiced__c);
                            wp.dusDays = string.valueOf(bl.Due_After_Days__c);
                            wp.mAmount = null;
                            wp.termKey = bl.Terms_of_Payment_Key__c;
                            wp.payment_group = bl.Payment_Group__c ;
                            originalBillingPlanMap.put(bl.Payment_Group__c,wp);
                            
                        }else{
                            WrapperClass wp = new WrapperClass();
                            wp.milestoneName = bl.Payment_Plan_Line_Item_Name__c;
                            wp.percentage = decimal.valueOf(bl.Percentage_Of_Value_To_Be_Invoiced__c);
                            wp.dusDays = string.valueOf(bl.Due_After_Days__c);
                            wp.mAmount = null;
                            wp.payment_group = bl.Payment_Group__c ;
                            wp.termKey = bl.Terms_of_Payment_Key__c;
                            originalBillingPlanMap.put(bl.Payment_Group__c ,wp);
                        }
                        groupName.add(bl.Payment_Group__c);
                    }
                    
                }
                
                for(string obj : originalBillingPlanMap.keySet()){
                
                   //WrapperClass wp = new WrapperClass();
                   Date stdate;
                   Integer duedays = Integer.valueof(originalBillingPlanMap.get(obj).dusDays); 
                   system.debug('duedays : ' +duedays);
                   system.debug('created Date:' +qList[0].createdDate);
                   if(duedays > 0){
                       duedays  = duedays-1;
                       stdate = ((qList[0].createdDate).date().addDays(duedays));
                   }
                   String mlName = originalBillingPlanMap.get(obj).milestoneName; 
                   
                   if(mlName.containsIgnoreCase('<Date>') || mlName.containsIgnoreCase('< Date >') 
                       || mlName.containsIgnoreCase('«Date»') ){
                        mlName = mlName.replace('<Date>',QuotationManagmentServices.customDateFormat(stdate));
                        mlName = mlName.replace('< Date >',QuotationManagmentServices.customDateFormat(stdate));
                        mlName = mlName.replace('«Date»',QuotationManagmentServices.customDateFormat(stdate));
                    }
                    originalBillingPlanMap.get(obj).milestoneName = mlName;   
                }
                if(string.isNotBlank(qList[0].Additional_Comments__c)){
                    additonalComments = qList[0].Additional_Comments__c.split('#');
                }  
                List<Discount__C> discountList = QuotationManagmentServices.getProjectLevelDiscounts(qList[0].Project__c);   
                if(discountList != null && !discountList.isEmpty()){
                    for(Discount__C d : discountList){
                        originalDiscountMap.put(d.Reason__c,d); 
                    }
                }
                   
                List<Discount_Applied__c> discountAppliedList = [select id,name,PSF_Lumpsum_Percentage__c,Quotation__c,Reason__c,
                                          Total_Amount__c,Type__c from Discount_Applied__c where quotation__c =: qList[0].id];      
                for(Discount_Applied__c ds : discountAppliedList){
                    if(originalDiscountMap.containsKey(ds.Reason__c)){
                        appiledDiscountMap.put(ds.Reason__c, ds.PSF_Lumpsum_Percentage__c); 
                    }
                }       
                for(string key : originalDiscountMap.keySet()){
                    if(!appiledDiscountMap.containsKey(key)){
                        appiledDiscountMap.put(key,0);
                    }
                }       
                Map<string,decimal> parkingMap = new Map<string,decimal>();
                for(Integer i=1;i<=5;i++){
                    string earmarkedName = (string)qList[0].get('Earmarked_Car_Parking_Type_'+ i +'__c');
                    decimal earmarkedCount = (decimal)qList[0].get('Earmarked_Car_Parking_Count_'+ i +'__c');
                    if(string.isNotBlank(earmarkedName)){
                        earmarkedName = earmarkedName.toLowerCase();
                        earmarkedName = earmarkedName.substring(0,1).toUpperCase() + earmarkedName.substring(1,earmarkedName.length());
                        if(string.isBlank(OriginalParking)){
                            OriginalParking =  earmarkedName + '-' + earmarkedCount;
                        }else{
                            OriginalParking +=  ', ' + earmarkedName + '-' + earmarkedCount;
                        } 
                    }
                    string additionalParkName = (String)qList[0].get('Car_Park_Type_'+ i +'__c');
                    decimal additionalParkCount = (decimal)qList[0].get('Car_Park_Count_'+ i +'__c');
                    
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
                        if(string.isBlank(revisedParking)){
                            revisedParking = st + '-' + parkingMap.get(st);
                        }else{
                            revisedParking += ', ' + st + '-' + parkingMap.get(st);
                        }
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
    
    public Class WrapperClass{
    
        public string milestoneName {get;set;}
        public decimal percentage {get;set;}
        public string dusDays {get;set;}
        public string mAmount {get;set;}
        public Decimal mAmountD {get;set;}
        public string payment_group {get;set;}
        public string termKey {get;set;}
    
        public WrapperClass(string milestoneName, decimal percentage, string dusDays, decimal mAmount, string payment_group, string termKey){
            this.milestoneName = milestoneName;
            this.percentage = percentage;
            this.dusDays = string.valueOf(dusDays);
            this.mAmount = QuotationManagmentServices.INFormatR(mAmount);
            this.payment_group = payment_group;
            this.termKey = termKey;
            this.mAmountD = mAmount;
        }
        public WrapperClass(){
        
        }
    
    }
}
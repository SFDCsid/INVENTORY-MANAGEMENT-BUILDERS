Public Class ViewQuotation{

public string qId {get;set;}
Public List<Quotation__c> qList {get;set;}
public string QuotDate {get;set;}
public string BookingDate {get;set;}
public string totalSaleValue {get;set;}
public string effectiveSalePrice {get;set;}
public Decimal effectiveSalePriceD {get;set;}
public string GST_impact_absorbed {get;set;}
public List<QuotationManagmentServices.PaymentMilestoneWrapper> pwList {get;set;}
public List<QuotationManagmentServices.PaymentMilestoneWrapper> pwListFinal {get;set;}
public string totalPercentage{get;set;}
public string totalPMAmount{get;set;}
public string EtotalPMAmount{get;set;}
public string totalGST{get;set;}
public string totalAmount{get;set;}
public string totalOtherCharges{get;set;}
public list<OCWrapper> ocList {get;set;}
public Integer completedMilestoneSize {get;set;}
public Integer INcompletedMilestoneSize {get;set;}
public Decimal completedMilestoneAmountD {get;set;}
public String completedMilestoneAmountSTR {get;set;}
public String completedMilestoneEXAmountSTR {get;set;}
public list<IN_MilestonesWrapper> IN_MilestonesList {get;set;}
public String billingPlan_Type {get;set;}
public boolean allMilestonesCompleted {get;set;}
public string lastDateOfCompletedMilestones {get;set;}
public Integer totalINMilestones {get;set;}
public List<carParkingWrapper> parkingList {get;set;}
public General_Clause__c generalClauses {get;set;}
public boolean ISgeneralClauses {get;set;}
public Decimal ExclusiveamountD {get;set;}
public String ExclusiveamountS {get;set;}
public String QuotationName {get;set;}
public boolean ValidQuote {get;set;}


public String TotalGstForEffectiveS {get;set;}

     public ViewQuotation(){
        qList = new List<Quotation__c>();
        pwList = new List<QuotationManagmentServices.PaymentMilestoneWrapper>();
        ocList = new list<OCWrapper>();
        completedMilestoneSize = 0;
        INcompletedMilestoneSize = 0;
        completedMilestoneAmountD = 0;
        completedMilestoneAmountSTR = '';
        completedMilestoneEXAmountSTR = '';
        IN_MilestonesList = new list<IN_MilestonesWrapper>();
        billingPlan_Type = '';
        allMilestonesCompleted = true;
        pwListFinal = new List<QuotationManagmentServices.PaymentMilestoneWrapper>();
        lastDateOfCompletedMilestones = '';
        totalINMilestones = 0;
        parkingList = new List<carParkingWrapper>();
        generalClauses = new General_Clause__c ();
        ISgeneralClauses = false;
        
        if(ApexPages.currentPage().getParameters().containsKey('qId') != null)
            qId =  ApexPages.currentPage().getParameters().get('qId'); 
        DescribeSObjectResult describeResult = Quotation__c.getSObjectType().getDescribe();  
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = ' SELECT ' + String.join( fieldNames, ',' ) + ',Project__r.name,Tower__r.Name,Project__r.Effective_Sale_Price_Applicable__c,' +
                     'Property__r.name,Property__r.House_Unit_No__c,Property__r.Is_Inclusive_Sale_Price__c,Property__r.Property_Type__c,Project__r.Terms_And_Conditions__c,'+
                     'Billing_Plan__r.Payment_Plan_Type__c,Property__r.Material_No__c, Tower__r.Tower_Name__c,Booking__r.Booking_Date__c,' +
                     'Billing_Plan__r.Scheme_Specific_Clauses__c,Property__r.ITC_Benefit_Applicable__c' + 
                     ' FROM ' + describeResult.getName() + ' where id=' + '\'' + qId + '\''; 
        qList = Database.query( query );
        QuotationName = qList[0].Name;
        QuotDate = ((qList[0].createdDate).date()).format();
        if(qList[0].Booking__c != null){
            BookingDate = (qList[0].Booking__r.Booking_Date__c).format();
        }
        if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){
            totalSaleValue = QuotationManagmentServices.INFormatR(qList[0].Total_Agreement_Value_Modified__c);
        }else{
            totalSaleValue = QuotationManagmentServices.INFormatR(qList[0].Total_Agreement_Value_Modified__c + qList[0].Total_CSGT_Modified__c + qList[0].Total_SGST_Modified__c);
        }
        if(qList[0].Effective_Sale_Price__c != null && qList[0].Effective_Sale_Price__c > 0){
            effectiveSalePrice = QuotationManagmentServices.INFormatR(qList[0].Effective_Sale_Price__c);
            //effectiveSalePriceD = qList[0].Effective_Sale_Price__c;
            GST_impact_absorbed = QuotationManagmentServices.INFormatR(qList[0].Total_Agreement_Value_Modified__c - qList[0].Effective_Sale_Price__c);
        }
        billingPlan_Type = qList[0].Billing_Plan__r.Payment_Plan_Type__c;
        
   /********** Get General clauses  **********************/      
        List<General_Clause__c> generalClausesList = [select Id,name, Active__c, Clauses__c, Object__c from General_Clause__c where Active__c = true and Object__c = 'Quotation'];
        if(generalClausesList != null && !generalClausesList.isEmpty()){
            generalClauses = generalClausesList[0];
            ISgeneralClauses = true;
        }
        
        
    /************************* Fetch payment milestone for this Quotation   *********************/
        pwList = QuotationManagmentServices.getCustomerViewPaymentSchedule(qId);    
        Decimal grandTotal = 0;
        Decimal EgrandTotal = 0;
        Decimal grandPerc = 0;
        Decimal grandamount = 0;
        Decimal grandGST = 0;
        system.debug('Pwlist size::::'+Pwlist.size());
        for(QuotationManagmentServices.PaymentMilestoneWrapper pw : pwList){
            grandTotal += pw.totalMilestoneD;
            EgrandTotal += pw.EtotalMilestoneD;
            grandPerc += pw.milestonePercentage;
            grandamount += pw.amountD;
            grandGST += pw.totalGST_D;
            
        }
        totalPMAmount = QuotationManagmentServices.INFormatR(grandTotal);
        EtotalPMAmount = QuotationManagmentServices.INFormatR(EgrandTotal);
        totalAmount = QuotationManagmentServices.INFormatR(grandamount);
        totalPercentage = string.valueOf(grandPerc);
        totalGST = QuotationManagmentServices.INFormatR(grandGST);
        ExclusiveamountD = qList[0].Effective_Sale_Price__c;
        ExclusiveamountS= QuotationManagmentServices.INFormatR(ExclusiveamountD);
        QuotationManagmentServices.GSTWrapper gp = QuotationManagmentServices.getTaxValue(qList[0].Effective_Sale_Price__c, qList[0].Property__c);
        TotalGstForEffectiveS = QuotationManagmentServices.INFormatR(gp.totalGST);

        
        if((qList[0].Active_Quotation__c && qList[0].Quote_Status__c == 'Valid') || qList[0].Booking__c != Null){
            ValidQuote = True;
        }Else{
            ValidQuote = False;
        }
        
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
                    system.debug('inside false');
                    INcompletedMilestoneSize += 1;
                    allMilestonesCompleted = false;
                }
                
            }
        }else{    
            system.debug('inside empty');
            allMilestonesCompleted = false;
        }  
        system.debug('completedMilestoneSize::'+completedMilestoneSize);  
        decimal completedPercentage = 0;
        decimal completedAmount = 0;
        decimal EcompletedAmount = 0;
        decimal completedCGST = 0;
        decimal completedSGST = 0;
        decimal completedTotalGST = 0;
        decimal EcompletedTotalGST = 0;
       // Decimal ExclusiveamountD = 0;
        //String ExclusiveamountS= '';
        //Integer loc = 0;
        //Integer loc1 = 0;
        Integer s_No = 1;
        //boolean isAnyIN_Milestone = false;
        system.debug('allMilestonesCompleted::'+allMilestonesCompleted);
        for(QuotationManagmentServices.PaymentMilestoneWrapper pw : pwList){
            system.debug('Terms_of_Payment_Key:: '+ pw.Terms_of_Payment_Key);
            if(pw.paymentGroup == 'IN' && pw.is_IN001Milestone){
                if(allMilestonesCompleted){
                    system.debug('inside all completed');
                    pwListFinal.add(pw);
                }else{
                    
                    if(pw.isCompletedMilestone){
                        system.debug('hiiii::: completed::');
                        IN_MilestonesWrapper INm = new IN_MilestonesWrapper();
                        INm.s_No = s_No;
                        INm.name = pw.milestoneName;
                        INm.amountD = pw.amountD;
                        INm.amountSTR = pw.amountSTR;
                        INm.EXamountD = pw.EffectiveAmountD;
                        INm.EXamountSTR = pw.EffectiveAmountS;

                        INm.due_Date = QuotationManagmentServices.customDateFormat(pw.dueDateINDATE);
                        IN_MilestonesList.add(INm);
                        completedMilestoneAmountD += pw.totalMilestoneD;
                        completedPercentage += pw.milestonePercentage;
                        completedAmount += pw.amountD;
                        EcompletedAmount += pw.EffectiveAmountD;
                        completedCGST += pw.CGST_D;
                        completedSGST += pw.SGST_D;
                        completedTotalGST += pw.totalGST_D;
                        EcompletedTotalGST += pw.GstForEffective;
                        
                        lastDateOfCompletedMilestones = QuotationManagmentServices.customDateFormat(pw.dueDateINDATE);
                        //loc1 = loc; 
                        s_No = s_No + 1;                   
                    }else{
                        system.debug('hiiii::: INcompleted');
                        allMilestonesCompleted = false;
                        pwListFinal.add(pw);
                    }
                }
            }else{
                system.debug('hiiii::: else IN completed');
                pwListFinal.add(pw);
            }
            //loc++;
        }
       
        if(!allMilestonesCompleted){
            system.debug('inside some IN milestones are completed condition');
            for(QuotationManagmentServices.PaymentMilestoneWrapper pw : pwListFinal){
                if(pw.paymentGroup == 'IN' && pw.is_IN001Milestone){
                    system.debug('bye');
                    pw.amountD += completedAmount;
                    pw.amountSTR = QuotationManagmentServices.INFormatR(pw.amountD);
                    pw.CGST_D += completedCGST;
                    pw.CGST_STR = QuotationManagmentServices.INFormatR(pw.CGST_D);
                    pw.SGST_D += completedSGST;
                    pw.SGST_STR = QuotationManagmentServices.INFormatR(pw.SGST_D);
                    pw.totalGST_D += completedTotalGST;
                    pw.totalGST_STR = QuotationManagmentServices.INFormatR(pw.totalGST_D);
                    pw.totalMilestoneD += completedMilestoneAmountD;
                    pw.totalMilestoneSTR = QuotationManagmentServices.INFormatR(pw.totalMilestoneD);
                    pw.milestonePercentage += completedPercentage;
                    Pw.GstForEffective += EcompletedTotalGST;
                    Pw.GstForEffectiveS = QuotationManagmentServices.INFormatR(pw.GstForEffective);
                    pw.EffectiveAmountD += EcompletedAmount;
                    pw.EffectiveAmountS = QuotationManagmentServices.INFormatR(pw.EffectiveAmountD);
                    pw.TotalGstNamountD = pw.EffectiveAmountD + pw.GstForEffective;
                    pw.TotalGstNamountS = QuotationManagmentServices.INFormatR(pw.TotalGstNamountD);
                    System.debug('pw.EffectiveAmountD ::'+pw.EffectiveAmountD );  
                }
            }
           
        }
        //pwListFinal.sort();
        if(qList[0].Property__r.Is_Inclusive_Sale_Price__c != true){
            completedMilestoneAmountSTR = QuotationManagmentServices.INFormatR(completedAmount);
            completedMilestoneEXAmountSTR = QuotationManagmentServices.INFormatR(EcompletedAmount);
        }else{
            completedMilestoneAmountSTR = QuotationManagmentServices.INFormatR(completedAmount + completedTotalGST);
            completedMilestoneEXAmountSTR = QuotationManagmentServices.INFormatR(EcompletedAmount);
        }
    /////////// Change Completed milestone name
        if(IN_MilestonesList != null && !IN_MilestonesList.isEmpty()){
            for(IN_MilestonesWrapper mn : IN_MilestonesList){
                if(IN_MilestonesList.size() == mn.s_No){
                    mn.name = 'To be paid on or before ' + mn.due_Date + ' along with any further milestones raised till then';
                }
            }
        }    
        
        
   /************************* Fetch Additional charges **********************/   
       decimal ocTotal = 0;
       List<Other_Charges__c> ocListFromMaster = QuotationManagmentServices.getOtherChargesList(qList[0].Property__r.Property_Type__c);
       if(ocListFromMaster != null && !ocListFromMaster.isEmpty()){
           for(Other_Charges__c ocR : ocListFromMaster){
               string amtStr = '';
                if(string.isNotBlank(ocR.At_Actual__c)){
                    amtStr = ocR.At_Actual__c;
                }else{
                    amtStr = '₹ ' + QuotationManagmentServices.INFormatR(ocR.Discount_Amount__c);
                }
                
                OCWrapper oc = new OCWrapper();
                oc.chargeName = ocR.Description__c;
                oc.chargeAmountD = ocR.Discount_Amount__c;
                oc.chargeAmountSTR = amtStr;
                ocTotal += oc.chargeAmountD;
                ocList.add(oc);
           }
       }
       
        totalOtherCharges = QuotationManagmentServices.INFormatR(ocTotal);
        
    /****************** Add Car parking Details. ****************************/
        map<string,Integer> parkingMap = new Map<string,Integer>();
        for(Integer i=1;i<=5;i++){
            string earmarkedName = (string) qList[0].get('Earmarked_Car_Parking_Type_' + i +'__c');
            decimal earmarkedCOunt = (decimal) qList[0].get('Earmarked_Car_Parking_Count_' + i +'__c');
            string additionalParkingName = (string) qList[0].get('Car_Park_Type_' + i +'__c');
            decimal additionalParkingCOunt = (decimal) qList[0].get('Car_Park_Count_' + i +'__c');
            if(string.isNotBlank(earmarkedName) && earmarkedCOunt != null){
                earmarkedName = earmarkedName.toLowerCase();
                earmarkedName = earmarkedName.substring(0,1).toUpperCase() + earmarkedName.substring(1,earmarkedName.length());
                if(parkingMap.containskey(earmarkedName)){
                    Integer cc = parkingMap.get(earmarkedName) + Integer.valueOf(earmarkedCOunt);
                    parkingMap.put(earmarkedName, cc);
                }else{
                    Integer cc = Integer.valueOf(earmarkedCOunt);
                    parkingMap.put(earmarkedName, cc);
                }
            }
            
            if(string.isNotBlank(additionalParkingName) && additionalParkingCOunt != null){
                additionalParkingName = additionalParkingName.toLowerCase();
                additionalParkingName = additionalParkingName.substring(0,1).toUpperCase() + additionalParkingName.substring(1,additionalParkingName.length());
                if(parkingMap.containskey(additionalParkingName)){
                    Integer cc = parkingMap.get(additionalParkingName) + Integer.valueOf(additionalParkingCOunt);
                    parkingMap.put(additionalParkingName, cc);
                }else{
                    Integer cc = Integer.valueOf(additionalParkingCOunt);
                    parkingMap.put(additionalParkingName, cc);
                }
            }
        }    
        if(!parkingMap.isEmpty()){
            for(string st : parkingMap.keySet()){
                carParkingWrapper cp = new carParkingWrapper();
                cp.parkingName = 'Permission to park in Car Parking space/s ' + st + ' Configuration';
                cp.carParkCount = parkingMap.get(st);
                parkingList.add(cp);
            }
        }
        
    }
    
    Public PageReference closeM(){
        PageReference pgRef = new PageReference('/'+qId);
        pgRef.setRedirect(true);
        return pgRef;
    } 
    
   Public PageReference SaveQuote1(){
        
       /* PageReference pdfPage = new PageReference('/apex/ViewQuotation?qId='+qId);
        blob pg = null;
        DateTime d = system.NOW();
        system.debug('pg'+qId);
        
        if(Test.isRunningTest()){
           pg = Blob.valueOf('pg'); 
        } else {
         pg = pdfPage.getContentAsPDF(); 
        }
        
        Attachment attach1= new Attachment();
        attach1.ParentId = qId;
        attach1.Name = 'Quotation_'+QuotationName+'_'+d;
        
        attach1.Body=pg;
        attach1.contentType = 'application/pdf';
        insert attach1;
        return pdfPage;*/
        DateTime d = system.NOW();
        
        PageReference pdf = ApexPages.currentPage();
        system.debug ('calling getContent...');
        blob b = pdf.getContentAsPDF();
        
        ContentVersion cont = new ContentVersion();
        cont.Title = 'Quotation_'+qlist[0].Name+'_'+d;
        cont.VersionData = b;
        cont.PathOnClient =  'Quotation_'+qlist[0].Name+'_'+d+'.pdf';
        cont.ContentLocation = 'S';
        cont.Description =  'Quotation_'+qlist[0].Name+'_'+d;
        cont.TagCSV =  'Quotation_'+qlist[0].Name+'_'+d;
        insert cont;
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cont.id].ContentDocumentId;
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = qId; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        insert cDe;
        
        
        return pdf;
        
    }
    
    public class OCWrapper{
        public string chargeName {get;set;}
        public Decimal chargeAmountD {get;set;}
        public String chargeAmountSTR {get;set;}
        
        public OCWrapper(){
            
        }
    }
    
    Public Class IN_MilestonesWrapper{
        
        Public string name {get;set;}
        Public decimal amountD {get;set;}
        Public string amountStr {get;set;}
        Public decimal EXamountD {get;set;}
        Public string EXamountStr {get;set;}
        Public Integer s_No {get;set;}
        Public string due_Date {get;set;}
        
        public IN_MilestonesWrapper(){
        
        }
    }
    
    public class carParkingWrapper{
        public string parkingName {get;set;}
        public Integer carParkCount {get;set;}
    
        public carParkingWrapper(){
            
        }
        
    }
        
}
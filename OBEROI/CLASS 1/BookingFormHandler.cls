public class BookingFormHandler {
    public  Integer lstSize{get;set;}    
    public decimal discAmt {get;set;}
    Public String listSize{get;set;}
    Public String today{get;set;}
    public Integer age{get;set;}
    public string doSave{get;set;}
    public string type{get;set;} 
    public String SAPSync{get;set;} 
    public Booking__c booking{get;set;}
    public string totalsalespriceword{get;set;}
    Public String bookingId;
    Public List<Billing_Plan_Line_Item__c> ppliLst{get;set;}
    Public String todaydate{get;set;}
    Public String AccountPanNumber{get;set;}
    public string totalsalescosstinwords {get;set;}
    public string basiccosstinwords {get;set;}
    public string plccosstinwords {get;set;}
    public string CarParkinginwords {get;set;}
    public string TandomCarParkinginwords {get;set;}
    public string TripleCarParkinginwords {get;set;}
    public string totalsalescosst {get;set;}
    public list<Other_Charges__c> Additionalcharges{get;set;} 
    public list<Tower__c> liTowers{get;set;}
    public list<Co_Owner__c> Coowners{get;set;}
    public list<Billing_Plan_Line_Item__c> billingLineItems {get;set;}
    public list<Billing_Plan_Line_Item__c> billinglineItemTimeLinked {get;set;}
    public Map<string,Other_Charges__c> mapOtherChargesTable3 {get;set;}
    public Map<string,Other_Charges__c> mapOtherChargesTable4 {get;set;}
    public Decimal inPercent {get;set;}
    public String singlecarpark {get;set;}
    public String tandemcarpark {get;set;}
    public String triplecarpark {get;set;}
    public Decimal inAmount {get;set;}
    public boolean checkProp {get;set;}
    public Decimal salePricereraCarpetArea {get;set;}
    public decimal clbchag{get;set;}
    public decimal legalchag{get;set;}
    public decimal devchag{get;set;}
    public decimal societychag{get;set;}
    public decimal corpuschag{get;set;}
    public decimal sharechag{get;set;}
    public decimal munciplechag{get;set;}
    public decimal electrichag{get;set;}
    //public decimal munciplechag{get;set;}
    public boolean schemeBp{get;set;}
    public decimal SalePriceofBalconyCarpetArea{get;set;}
    public decimal SalePriceofRERACarpetArea{get;set;}
    public string SalePriceofBalconyCarpetAreaword{get;set;}
    public string PriceofITCBenefitNew{get;set;}
    public string effectiveSalePriceNew{get;set;}
    
    public string SalePriceofRERACarpetAreaword{get;set;}
    public BookingFormHandler(ApexPages.StandardController controller) {
        ppliLst = new List<Billing_Plan_Line_Item__c>();
        doSave = ApexPages.currentPage().getParameters().get('doSave'); 
        
        bookingId = ApexPages.currentPage().getParameters().get('id');
        booking = new Booking__c();
        
        
        if(bookingId != '' && bookingId != null ){
            booking = [SELECT PAN_Number__c,Title__c,Project__c,Contact_Name__c,ITC_Benefit_New__c,Effective_Sale_Price_New__c,email__C,Fax_Number__c,Tandem_Car_Parking__c,Triple_Car_Parking__c,Billing_Plan__r.Total_Sales_Amount_At_Time_of_Booking__c,
                       mobile__C,Property__r.tower__r.Completion_Certificate_Date__c,Primary_Applicants__r.Customer_Classification__pc,Property__r.Balcony_Terrace_Area_in_Sq_ft__c,Property__r.RERA_Carpet_Area_In_Sq_ft__c,Property__r.RERA_Carpet_Area_In_Sq_Mtr__c,
                       Tower_Name__c,Initial_Booking_Amount_Realised__c,Booking_Flat_No__c,Tower__r.Tower_Name__c,Tower__c,Basic_Cost__c,PLC_Cost__c,Project__r.Default_Car_Parking_Configuration__c,Project__r.Default_Car_Parking__c,
                       Primary_Applicant__r.name, Primary_Applicant__r.AccountId,Property__r.Floor__r.Floor_Number__c, Primary_Applicant__r.PAN__c,Project__r.NAme,Property__r.Property_Type__c,Property__r.Project_Name__r.Registration_A_C_Name__c,Property__r.Project_Name__r.MahaRERA_Registration_No__c,Property__r.Project_Name__r.Expected_End_Date__c,Property__r.Project_Name__r.Project_Name__c,
                       Primary_Applicant__r.Billing_Pincode__c,Billing_Plan__r.Total_Sales_Amount_Time_of_Booking__c,Primary_Applicant__r.Billing_City__c,Single_Car_Parking__c,Primary_Applicant__r.Billing_Street_1__c,Property__r.Floor__r.name,Project_Name__c,Total_Sales_Cost__c,property__r.Sale_Price_of_Balcony_Carpet_Area__c,property__r.Sale_Price_of_RERA_Carpet_Area__c,property__r.Net_Sales_Price__c,property__r.project_name__r.Subsidiary_Company_Name__c,property__r.project_name__r.Subsidiary_Company_Address__c,
                       Primary_Applicant__r.Billing_Street_2__c,property__r.tower__r.tower_name__C,property__r.project_name__r.Project_Area_Sq_ft__c,property__r.project_name__r.Street__c,property__r.project_name__r.city__c,property__r.project_name__r.location__c,property__r.project_name__r.State_Province__c,property__r.project_name__r.Country__c,Booking_Date__c,Primary_Applicant__r.Billing_House_No__c,Primary_Applicant__r.Billing_Street_3__c,Billing_Plan__c ,Primary_Applicant__r.MailingCountry , Contact__r.PAN__c ,Property__r.Carpet_Area_Sq_Mtr__c, Property__r.Carpet_Area__c, 
                       Primary_Applicants__r.House_No__c,Primary_Applicants__r.Street__c,Primary_Applicants__r.Street_2__c,PAN__c,Primary_Applicants__r.PersonBirthdate,
                       Billing_Plan__r.recordtypeid,Tower__r.Bank_account_of_the_Promoter__c,property__r.Property_Type_Name__c,C_o_Name_Mailing_Address__c,Mailing_City__c,Mailing_Country__c,Mailing_Location__c,Mailing_Post_Code__c,Mailing_Street__c,Mailing_Str_Suppl3__c,Mailing_Str_Suppl2__c,
                       C_o_Name_Billing_Address__c,Billing_Street__c,Billing_Str_Suppl2__c,Billing_Str_Suppl3__c,Property__r.Floor__r.SuperScript__c,
                       Billing_City__c,Billing_Post_Code__c,Primary_Applicants__r.Salutation,Billing_Location__c,Billing_Country__c,
                       Primary_Applicants__r.Name,Primary_Applicants__r.Street_3__c,Primary_Applicants__r.City__c,Primary_Applicants__r.PAN__pc,Primary_Applicants__r.Postal_code__c
                       FROM Booking__c WHERE Id=:bookingId];
            
            schemeBp = false;
            Id SchemeBillingRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Scheme Billing Plan').getRecordTypeId();
            Id NonSchemeRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Non Scheme Billing Plan').getRecordTypeId();
            Id CustomRecordTypeId = Schema.SObjectType.Payment_Plan__c.getRecordTypeInfosByName().get('Customize Billing Plan').getRecordTypeId();
            
            if(booking.billing_plan__r.recordtypeid == SchemeBillingRecordTypeId ){
                //|| booking.billing_plan__r.recordtypeid == NonSchemeRecordTypeId){
                schemeBp = true;
            }
            todaydate = booking.Booking_Date__c.day() + '/' + booking.Booking_Date__c.month() + '/' + booking.Booking_Date__c.year();}
        Decimal netamt = 0;
        //Changes Added by Vaidehi for NRI Declaration Form
        today = string.valueOf(system.today());
        if(booking.Primary_Applicants__r.PersonBirthdate != null)
            age = system.today().year() - booking.Primary_Applicants__r.PersonBirthdate.year();
        //Changes Finished
        netamt = booking.Total_Sales_Cost__c - booking.property__r.Sale_Price_of_Balcony_Carpet_Area__c;
        SalePriceofBalconyCarpetArea = (booking.Total_Sales_Cost__c*booking.property__r.Balcony_Terrace_Area_in_Sq_ft__c)/(booking.property__r.RERA_Carpet_Area_In_Sq_ft__c+booking.property__r.Balcony_Terrace_Area_in_Sq_ft__c);
        SalePriceofRERACarpetArea = booking.Total_Sales_Cost__c - SalePriceofBalconyCarpetArea;
        List<String> args = new String[]{'0','number','###,###,###'};
            salePricereraCarpetArea = netamt.setScale(0, RoundingMode.HALF_UP);
        
        if(booking.Single_Car_Parking__c >0){
            singlecarpark = '0';
            singlecarpark = String.valueOf(booking.Single_Car_Parking__c);
            //CarParkinginwords = numberToEnglish(booking.Single_Car_Parking__c.intvalue()); 
            CarParkinginwords = Utility.changeToWords(string.valueOf(booking.Single_Car_Parking__c.intvalue()),true);
            CarParkinginwords = CarParkinginwords.replace(' Only', '');
        }
        else{
            CarParkinginwords =  Utility.changeToWords(string.valueOf(0),true);
        }
        if(booking.Tandem_Car_Parking__c>0){
            
            tandemcarpark = '0';
            tandemcarpark = String.valueOf(booking.Tandem_Car_Parking__c);
            //CarParkinginwords = numberToEnglish(booking.Single_Car_Parking__c.intvalue()); 
            TandomCarParkinginwords = Utility.changeToWords(string.valueOf(booking.Tandem_Car_Parking__c.intvalue()),true);
            TandomCarParkinginwords = TandomCarParkinginwords.replace(' Only', '');
        }
        else{
            TandomCarParkinginwords =  Utility.changeToWords(string.valueOf(0),true);
        }
        if(booking.Triple_Car_Parking__c>0){
            triplecarpark = '0';
            triplecarpark = String.valueOf(booking.Triple_Car_Parking__c);
            //CarParkinginwords = numberToEnglish(booking.Single_Car_Parking__c.intvalue()); 
            TripleCarParkinginwords = Utility.changeToWords(string.valueOf(booking.Triple_Car_Parking__c.intvalue()),true);
            TripleCarParkinginwords = TripleCarParkinginwords.replace(' Only', '');
        }
        else{
            TripleCarParkinginwords  =  Utility.changeToWords(string.valueOf(0),true);
        }
        
        if(booking.Total_Sales_Cost__c != null){
            totalsalescosstinwords = Utility.changeToWords(string.valueOf(booking.Total_Sales_Cost__c.round().intValue()),true);
        }
        else{
            totalsalescosstinwords = Utility.changeToWords(string.valueOf(0),true);
        }
        
        if(salePricereraCarpetArea > 0){
            basiccosstinwords = Utility.changeToWords(string.valueOf(salePricereraCarpetArea.intValue()),true);
        }
        else{
            basiccosstinwords = Utility.changeToWords(string.valueOf(0),true);
        }
        if(SalePriceofBalconyCarpetArea > 0){
            SalePriceofBalconyCarpetAreaword = Utility.changeToWords(string.valueOf(SalePriceofBalconyCarpetArea.round().intValue()),true);
        }
        else{
            SalePriceofBalconyCarpetAreaword = Utility.changeToWords(string.valueOf(0),true);
        }
        if(SalePriceofRERACarpetArea > 0){
            SalePriceofRERACarpetAreaword = Utility.changeToWords(string.valueOf(SalePriceofRERACarpetArea.round().intValue()),true);
        }
        else{
            basiccosstinwords = Utility.changeToWords(string.valueOf(0),true);
        }
        
        if(booking.property__r.Sale_Price_of_Balcony_Carpet_Area__c != null){
            plccosstinwords = Utility.changeToWords(string.valueOf(booking.property__r.Sale_Price_of_Balcony_Carpet_Area__c.round().intValue()),true);
        }
        else{
            plccosstinwords = Utility.changeToWords(string.valueOf(0),true);
        }
        
        if(booking.ITC_Benefit_New__c != null){
            PriceofITCBenefitNew = Utility.changeToWords(string.valueOf(booking.ITC_Benefit_New__c.round().intValue()),true);
        }
        else{
            PriceofITCBenefitNew = Utility.changeToWords(string.valueOf(0),true);
        }
        
        if(booking.Effective_Sale_Price_New__c != null){
            effectiveSalePriceNew = Utility.changeToWords(string.valueOf(booking.Effective_Sale_Price_New__c.round().intValue()),true);
        }
        else{
            effectiveSalePriceNew = Utility.changeToWords(string.valueOf(0),true);
        }
        
        Additionalcharges = [select name,Description__c,Discount_Amount__c from Other_Charges__c 
                             where Property_Type__c = :booking.Property__r.Property_Type__c];
        system.debug('Additionalcharges'+Additionalcharges);
        //mapOtherChargesTable3 = new Map<string,Other_Charges__c>();
        //mapOtherChargesTable4 = new Map<string,Other_Charges__c>();
        
        for(Other_Charges__c OC: Additionalcharges){
            
            if(OC.name.contains('Society') ){
                societychag = 0;
                societychag = OC.Discount_Amount__c;
            }
            else if(OC.name.contains('Club')){
                clbchag = 0;
                clbchag = OC.Discount_Amount__c;
            }
            else if(OC.name.contains('Legal')){
                legalchag = 0;
                legalchag = OC.Discount_Amount__c;
            }
            else if(OC.name.contains('Development')){
                devchag = 0;
                devchag = OC.Discount_Amount__c;
            }
            else if(OC.name.contains('Share')){
                if(booking.Primary_Applicants__r.Customer_Classification__pc == 'Individual'){
                    sharechag = 0;
                    sharechag = 600;
                }
                else if(booking.Primary_Applicants__r.Customer_Classification__pc == 'Company'){
                    sharechag = 0;
                    sharechag = 1200;
                }
                
            }
            else if(OC.name.contains('Corpus')){
                corpuschag = 0;
                corpuschag = OC.Discount_Amount__c;
            }
            else if(OC.name.contains('Municipal')){
                munciplechag = 0;
                munciplechag = OC.Discount_Amount__c;
            }
            
            
        }
        
        
        
        
        liTowers = [select Tower_Name__c from tower__c where Project_Name__c = :booking.property__r.Project_Name__c];
        Coowners = [select PAN__c,Contact_name__c,name,Salutation__c from Co_Owner__c where Booking__c = :booking.Id];
        /*PAYMENT PLAN LINE ITEMS*/
        Decimal firstelement = 0;
        Decimal firstelementvalue = 0;
        if(booking.Billing_Plan__c != null){
            billingLineItems = [SELECT Name, Payment_Plan_Line_Item_Name__c,Milestone_Number__c,Line_Item_Type__c,Payment_Group__c ,
                                Discount_Amount__c,Amount__c,Terms_of_Payment_Key__c,Percentage__c,Due_After_Days__c,description__c,
                                Percentage_Rate__c,Percentage_Of_Value_To_Be_Invoiced__c 
                                FROM Billing_Plan_Line_Item__c 
                                WHERE Payment_Plan__c =: booking.Billing_Plan__c order by  Order__c ASC];
            system.debug('billingLineItems============='+billingLineItems);
            for (Billing_Plan_Line_Item__c bpli: billingLineItems){
                if(bpli.Payment_Plan_Line_Item_Name__c.startsWith('Proportionate')){
                    string initialPart = bpli.Description__c.substring(0,bpli.Description__c.indexof('Rs. '));
                    string amount;
                    
                    amount = bpli.Description__c.substring(bpli.Description__c.indexof('Rs. ')+4,bpli.Description__c.indexof('towards')-1);
                    
                    List<String> args1 = new String[]{'0','number','###,###,##0.00'};
                        String amountFormat = String.format(integer.valueOf(amount).format(), args1);
                    bpli.Description__c = initialPart +'Rs. '+ amountFormat + ' towards the Sale Price is payable as below';
                    system.debug('Bifurcate'+initialPart+amountFormat)   ;  
                    
                }
                
                if(bpli.description__c.startsWith('To be paid on or before') && !bpli.description__c.endswith('Earnest Money)') && !bpli.description__c.endswith('Plinth')){
                    datetime actualdate = booking.Booking_Date__c.adddays(Integer.valueOf(bpli.Due_After_Days__c)-1);
                    
                    bpli.description__c = 'To be paid on or before '+actualdate.format('MM/dd/yyyy');
                }
                if(bpli.description__c.startsWith('To be paid on or before') && bpli.description__c.endswith('Earnest Money)') && !bpli.description__c.endswith('Plinth')){
                    datetime actualdate = booking.Booking_Date__c.adddays(Integer.valueOf(bpli.Due_After_Days__c)-1);
                    
                    bpli.description__c = 'To be paid on or before '+actualdate.format('MM/dd/yyyy')+' upon Execution and Registration of the Agreement (balance 50% of the Earnest Money)';
                }
            }
            
            
            billinglineItemTimeLinked =[SELECT Name, Payment_Plan_Line_Item_Name__c,Line_Item_Type__c,Milestone_Number__c,Payment_Group__c ,
                                        Discount_Amount__c,Amount__c,Terms_of_Payment_Key__c,Percentage__c,Due_After_Days__c,description__c,
                                        Percentage_Rate__c,Percentage_Of_Value_To_Be_Invoiced__c 
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
            checkProp = false;
            for(Billing_Plan_Line_Item__c bpli : [select Description__c,Payment_Plan_Line_Item_Name__c,Percentage_Rate__c,Percentage_Of_Value_To_Be_Invoiced__c,Discount_Amount__c 
                                                  from Billing_Plan_Line_Item__c WHERE Payment_Plan__c =: booking.Billing_Plan__c
                                                  AND Payment_Group__c ='IN']){
                                                      inAmount = inAmount + bpli.Discount_Amount__c;
                                                      inPercent = inPercent + Decimal.valueOf(bpli.Percentage_Of_Value_To_Be_Invoiced__c);
                                                      if(bpli.Payment_Plan_Line_Item_Name__c.startsWith('Proportionate')){
                                                          checkProp = true;
                                                          
                                                      }
                                                  }
            system.debug('inAmountinAmount'+inAmount);
            system.debug('inPercentinPercent'+inPercent);
            //Changes Added By Vaidehi
             discAmt = 0.00;
                lstSize =1;
                if(billingLineItems.size()>0){
                for (Billing_Plan_Line_Item__c pp: billingLineItems){
                    if(!pp.Terms_of_Payment_Key__c.contains('IN')){                        
                        lstSize = lstSize+1;
                        discAmt =pp.Discount_Amount__c.setScale(0,RoundingMode.HALF_UP) + discAmt;
                        system.debug('pp.Discount_Amount__c'+pp.Terms_of_Payment_Key__c+pp.Discount_Amount__c);
                    } 
                    
                }
                if(inAmount == 0){
                system.debug('tttt'+inAmount);
                lstSize = lstSize-1;
                }
 
                discAmt = discAmt.setScale(0)+(inAmount.setScale(0,RoundingMode.HALF_UP));                
                system.debug(discAmt+'$$$$$');
                integer size = billingLineItems.size() -1;
                discAmt = discAmt- (billingLineItems[size].Discount_Amount__c.setScale(0, RoundingMode.HALF_UP));
                discAmt = (booking.Billing_Plan__r.Total_Sales_Amount_At_Time_of_Booking__c.setScale(0, RoundingMode.HALF_UP) - discAmt.setScale(0,RoundingMode.HALF_UP))  ;
                discAmt = discAmt.setScale(0,RoundingMode.HALF_UP);
               system.debug(discAmt+'$$$$$$');
            }
            //Changes Finished            
            map<Id,List<Billing_Plan_Sub_Line_Item__c>> mapBpliToSubLi = new map<Id,List<Billing_Plan_Sub_Line_Item__c>>();
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
                if(billinglineItemTimeLinked[i].description__c.startsWith('To be paid on or before') && !billinglineItemTimeLinked[i].description__c.endswith('milestones raised till then') && !billinglineItemTimeLinked[i].description__c.endswith('Plinth')){
                    datetime actualdate = booking.Booking_Date__c.adddays(Integer.valueOf(billinglineItemTimeLinked[i].Due_After_Days__c)-1);
                    
                    billinglineItemTimeLinked[i].description__c = 'To be paid on or before '+actualdate.format('MM/dd/yyyy');
                }
            }
            system.debug('@@billinglineItemTimeLinked----->'+billinglineItemTimeLinked);
            for(Billing_Plan_Sub_Line_Item__c bpsli : [SELECT Name,Billing_Plan_Sub_Line_Item_Name__c,Milestone_Number__c,Billing_Plan_Line_Item__c,Amount_Percent_BSP__c,Terms_of_Payment_Key__c,Percentage_Of_Value_To_Be_Invoiced__c 
                                                       FROM Billing_Plan_Sub_Line_Item__c
                                                       WHERE Billing_Plan_Line_Item__r.Payment_Plan__c =: booking.Billing_Plan__c ]){
                                                           if(mapBpliToSubLi.containsKey(bpsli.Billing_Plan_Line_Item__c)){
                                                               mapBpliToSubLi.get(bpsli.Billing_Plan_Line_Item__c).add(bpsli);
                                                           } else{
                                                               mapBpliToSubLi.put(bpsli.Billing_Plan_Line_Item__c, new List<Billing_Plan_Sub_Line_Item__c>{bpsli});
                                                           }
                                                       }
        }
        
        /*       
if(ppliLst != null && ppliLst.size() > 0){
for(Payment_Plan_Line_Items__c ppli :ppliLst){
if(firstelement == 0){
String var1 = String.valueof((ppli.PropStrength__Amount__c != null ? ppli.PropStrength__Amount__c:0).setScale(0));
String var2 = 'Rupees ' + Utilities.changeToWords(String.valueof((ppli.PropStrength__Amount__c != null ? ppli.PropStrength__Amount__c:0).setScale(0)), true);
String var3 = ppli.PropStrength__Description__c;
firstelementvalue = (ppli.PropStrength__Amount__c != null ? ppli.PropStrength__Amount__c:0);
//bookingamount = String.valueof(ppli.PropStrength__Amount__c.setScale(0));
paymentPlanWrapperLst.add(new paymentplanwrapper(var1, var2, var3));
} else if(firstelement == 1){
String var4 = String.valueof(((ppli.PropStrength__Amount_Percent__c*totalsaleprice/100)-firstelementvalue).setScale(0));
String var5 = 'Rupees ' + Utilities.changeToWords(String.valueof(((ppli.PropStrength__Amount_Percent__c*totalsaleprice/100)-firstelementvalue).setScale(0)), true);
String var6 = ppli.PropStrength__Description__c;
numberofdays = String.valueof(ppli.PropStrength__Due_After_Days__c);
paymentPlanWrapperLst.add(new paymentplanwrapper(var4, var5, var6));
} else {
String var7 = String.valueof((ppli.PropStrength__Amount_Percent__c*totalsaleprice/100).setScale(0));
String var8 = 'Rupees ' + Utilities.changeToWords(String.valueof((ppli.PropStrength__Amount_Percent__c*totalsaleprice/100).setScale(0)), true);
String var9 = ppli.PropStrength__Description__c;
paymentPlanWrapperLst.add(new paymentplanwrapper(var7, var8, var9));
}

firstelement = firstelement + 1;
}

}
*/
        // totalsalespriceword = Utilities.changeToWords(String.valueof(booking.Total_Sales_Cost__c), true);   
    }
    
    public pageReference savePDF(){ 
        type = ApexPages.currentPage().getParameters().get('type');
        SAPSync = ApexPages.currentPage().getParameters().get('SAPsync');
        system.debug('new type_____>'+type +SAPSync);
        string pagename ;
        if(Test.isRunningTest()){
            pagename = 'Test' ;
            
        }
        else{
            pagename  = ApexPages.currentPage().geturl();
        }
        
        if(doSave == 'No'){ return null; } 
        //if(type =='Acceptance' && SAPSync== '0'){
        if(pagename.contains('Acceptance')){  //Test.isRunningTest() || 
            String name;
            id bookingId1 = ApexPages.currentPage().getParameters().get('id');
            if(Test.isRunningTest()) {
                name = '/apex/Acceptance'; }
            else { name = '/apex/'+ ApexPages.currentPage().geturl().substringBetween('apex/', '?'); }
            //system.debug('name'+name);
            //PageReference pagePdf = new PageReference('/apex/Wrapper_ORL_AcceptanceForm'); 
            PageReference pagePdf = new PageReference(name);
            pagePdf.getParameters().put('id', bookingId1 ); 
            pagePdf.getParameters().put('doSave', 'No'); 
            pagePdf.getParameters().put('type', 'Acceptance'); 
            Blob pdfPageBlob; 
            if(Test.isRunningTest()) {
                pdfPageBlob = blob.valueOf('Unit.Test'); }
            else {pdfPageBlob = pagePdf.getContentAsPDF(); }
            
            Attachment a = new Attachment();
            a.Body = pdfPageBlob; 
            a.ParentID = bookingId1; 
            a.Name = 'Acceptance Form.pdf'; 
            a.Description = 'Acceptance Form'; 
            insert a; 
            
            return pagePdf;
        } else if(type =='TDSSelfDeclaration' && SAPSync== '0'){
            id bookingId1 = ApexPages.currentPage().getParameters().get('id');
            
            PageReference pagePdf = new PageReference('/apex/ORL_TDSSelfDeclaration'); 
            pagePdf.getParameters().put('id', bookingId1 ); 
            pagePdf.getParameters().put('doSave', 'No'); 
            Blob pdfPageBlob; 
            if(Test.isRunningTest()) {
                pdfPageBlob = blob.valueOf('Unit.Test'); }
            else {pdfPageBlob = pagePdf.getContentAsPDF(); }
            
            Attachment a = new Attachment();
            a.Body = pdfPageBlob; 
            a.ParentID = bookingId1; 
            a.Name = 'TDS Self Declaration.pdf'; 
            a.Description = 'TDS Self Declaration Form'; 
            insert a; 
            
            return pagePdf;
        }else if(type =='AuthLetterCompany' && SAPSync== '0'){
            id bookingId1 = ApexPages.currentPage().getParameters().get('id');
            
            PageReference pagePdf = new PageReference('/apex/ORL_AuthtoCompany'); 
            pagePdf.getParameters().put('id', bookingId1 ); 
            pagePdf.getParameters().put('doSave', 'No'); 
            Blob pdfPageBlob; 
            if(Test.isRunningTest()) {
                pdfPageBlob = blob.valueOf('Unit.Test'); }
            else {pdfPageBlob = pagePdf.getContentAsPDF(); }
            
            Attachment a = new Attachment();
            a.Body = pdfPageBlob; 
            a.ParentID = bookingId1; 
            a.Name = 'Auth to Company.pdf'; 
            a.Description = 'Auth to Company Form'; 
            insert a; 
            
            return pagePdf;
        }else if(type =='AuthLetterSelf' && SAPSync== '0'){
            id bookingId1 = ApexPages.currentPage().getParameters().get('id');
            
            PageReference pagePdf = new PageReference('/apex/ORL_AuthLetter_Self'); 
            pagePdf.getParameters().put('id', bookingId1 ); 
            pagePdf.getParameters().put('doSave', 'No'); 
            Blob pdfPageBlob; 
            if(Test.isRunningTest()) {
                pdfPageBlob = blob.valueOf('Unit.Test'); }
            else {pdfPageBlob = pagePdf.getContentAsPDF(); }
            
            Attachment a = new Attachment();
            a.Body = pdfPageBlob; 
            a.ParentID = bookingId1; 
            a.Name = 'Auth Self Letter.pdf'; 
            a.Description = 'Auth Self Form'; 
            insert a; 
            
            return pagePdf;
        }else if(type =='AuthToCompany' && SAPSync== '0'){
            id bookingId1 = ApexPages.currentPage().getParameters().get('id');
            
            PageReference pagePdf = new PageReference('/apex/ORL_AuthLetter_AuthtoCompany'); 
            pagePdf.getParameters().put('id', bookingId1 ); 
            pagePdf.getParameters().put('doSave', 'No'); 
            Blob pdfPageBlob; 
            if(Test.isRunningTest()) {
                pdfPageBlob = blob.valueOf('Unit.Test'); }
            else {pdfPageBlob = pagePdf.getContentAsPDF(); }
            
            Attachment a = new Attachment();
            a.Body = pdfPageBlob; 
            a.ParentID = bookingId1; 
            a.Name = 'Auth Letter Auth to Company.pdf'; 
            a.Description = 'Auth to Company Form'; 
            insert a; 
            
            return pagePdf;
        }else if(type =='Booking' && SAPSync== '0'){
            id bookingId1 = ApexPages.currentPage().getParameters().get('id');
            
            PageReference pagePdf = new PageReference('/apex/BookingForm'); 
            pagePdf.getParameters().put('id', bookingId1 ); 
            pagePdf.getParameters().put('doSave', 'No'); 
            Blob pdfPageBlob; 
            if(Test.isRunningTest()) {
                pdfPageBlob = blob.valueOf('Unit.Test'); }
            else {pdfPageBlob = pagePdf.getContentAsPDF();} 
            
            Attachment a = new Attachment();
            a.Body = pdfPageBlob; 
            a.ParentID = bookingId1; 
            a.Name = 'Booking Form.pdf'; 
            a.Description = 'BookingForm'; 
            insert a; 
            
            return pagePdf;
        }
        //Added By Vaidehi for NRI Declaration Form
        //Changes Started
        else if(type =='NRIDeclaration' && SAPSync== '0'){
            id bookingId1 = ApexPages.currentPage().getParameters().get('id');
            
            PageReference pagePdf = new PageReference('/apex/ORL_NRIDeclarationForm'); 
            pagePdf.getParameters().put('id', bookingId1 ); 
            pagePdf.getParameters().put('doSave', 'No'); 
            Blob pdfPageBlob; 
            if(Test.isRunningTest()) {
                pdfPageBlob = blob.valueOf('Unit.Test'); }
            else {pdfPageBlob = pagePdf.getContentAsPDF();} 
            
            Attachment a = new Attachment();
            a.Body = pdfPageBlob; 
            a.ParentID = bookingId1; 
            a.Name = 'NRI Declaration Form.pdf'; 
            a.Description = 'NRI Declaration Form'; 
            insert a; 
            
            return pagePdf;
        }
        //Changes Finished
        return null;  
        
    }
    static String[] firstTwenty = new String[] { 'NIL','One','Two','Three','Four','Five','Six','Seven','Eight','Nine',
        'Ten','Eleven','Twelve','Thirteen','Fourteen','Fifteen','Sixteen','Seventeen','Eighteen','Ninteen' };
            static String[] tens = new String[] { '','','Twenty','Thirty','Forty','Fifty','Sixty','Seventy','Eighty','Ninety' };
                static String[] powers = new String[] { 'Crore','Lakh','Thousand','Hundred' };
                    static Integer[] thresholds = new Integer[] { 100000000, 100000, 1000, 100 };    
                        static String[] convert(Integer value) {
                            String[] result = new String[0];
                            Boolean less20 = value < 20, less100 = value < 100;
                            if(less20) {
                                result.add(firstTwenty[value]);
                            } else if(less100) {
                                Integer tenValue = value / 10, oneValue = Math.mod(value, 10);
                                result.add(tens[tenValue]);
                                if(oneValue > 0) {
                                    result.add(firstTwenty[oneValue]);
                                }
                            }
                            if(less100) {
                                return result;
                            }
                            if(value > 0) {
                                for(Integer index = 0; index < thresholds.size(); index++) {
                                    if(thresholds[index] <= value) {
                                        result.addAll(convert(value / thresholds[index]));
                                        result.add(powers[index]);
                                        value = Math.mod(value, thresholds[index]);
                                    }
                                }
                                if(value > 0) {
                                    result.addAll(convert(value));
                                }
                            }
                            return result;
                        }
    public static String numberToEnglish(Integer value) {
        return value != null && value >= 0? String.join(convert(value),' '): '';
    }
    
}
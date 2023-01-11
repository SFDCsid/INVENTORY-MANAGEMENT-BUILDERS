public class BookingFormHandlerNew {
    
    
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
    public string totalsalescosst {get;set;}
    public list<Other_Charges__c> Additionalcharges{get;set;} 
    public list<Tower__c> liTowers{get;set;}
    public list<Co_Owner__c> Coowners{get;set;}
    public list<Billing_Plan_Line_Item__c> billingLineItems {get;set;}
    public list<Billing_Plan_Line_Item__c> billinglineItemTimeLinked {get;set;}
    public BookingFormHandlerNew(ApexPages.StandardController controller) {
        ppliLst = new List<Billing_Plan_Line_Item__c>();
        doSave = ApexPages.currentPage().getParameters().get('doSave'); 
        
        bookingId = ApexPages.currentPage().getParameters().get('id');
        booking = new Booking__c();
        
        
        if(bookingId != '' && bookingId != null ){
            booking = [SELECT Project__c,Contact_Name__c,email__C,Fax_Number__c,mobile__C,Tower_Name__c,Initial_Booking_Amount_Realised__c,Booking_Flat_No__c,Tower__r.Tower_Name__c,Tower__c,Basic_Cost__c,PLC_Cost__c,Project__r.Default_Car_Parking_Configuration__c,Project__r.Default_Car_Parking__c,
                       Primary_Applicant__r.name, Primary_Applicant__r.AccountId,Property__r.Floor__r.Floor_Number__c, Primary_Applicant__r.PAN__c,Project__r.NAme,Property__r.Property_Type__c,Property__r.Project_Name__r.Registration_A_C_Name__c,Property__r.Project_Name__r.MahaRERA_Registration_No__c,Property__r.Project_Name__r.Expected_End_Date__c,Property__r.Project_Name__r.Project_Name__c,
                       Primary_Applicant__r.Billing_Pincode__c,Billing_Plan__r.Total_Sales_Amount_Time_of_Booking__c,Primary_Applicant__r.Billing_City__c,Single_Car_Parking__c,Primary_Applicant__r.Billing_Street_1__c,Property__r.Floor__r.name,Project_Name__c,Total_Sales_Cost__c,property__r.Sale_Price_of_Balcony_Carpet_Area__c,property__r.Sale_Price_of_RERA_Carpet_Area__c,property__r.Net_Sales_Price__c,property__r.project_name__r.Subsidiary_Company_Name__c,property__r.project_name__r.Subsidiary_Company_Address__c,
                       Primary_Applicant__r.Billing_Street_2__c,property__r.tower__r.tower_name__C,property__r.project_name__r.Project_Area_Sq_ft__c,property__r.project_name__r.Street__c,property__r.project_name__r.city__c,property__r.project_name__r.location__c,property__r.project_name__r.State_Province__c,property__r.project_name__r.Country__c,Booking_Date__c,Primary_Applicant__r.Billing_House_No__c,Primary_Applicant__r.Billing_Street_3__c,Billing_Plan__c ,Primary_Applicant__r.MailingCountry , Contact__r.PAN__c ,Property__r.Carpet_Area_Sq_Mtr__c, Property__r.Carpet_Area__c 
                       FROM Booking__c WHERE Id=:bookingId];
        
        todaydate = booking.Booking_Date__c.day() + '/' + booking.Booking_Date__c.month() + '/' + booking.Booking_Date__c.year();}
        if(booking.Single_Car_Parking__c != null){
            //CarParkinginwords = numberToEnglish(booking.Single_Car_Parking__c.intvalue()); 
            CarParkinginwords = Utility.changeToWords(string.valueOf(booking.Single_Car_Parking__c.intvalue()),true);
        }
        else{
            CarParkinginwords =  Utility.changeToWords(string.valueOf(0),true);
        }
        
        if(booking.Total_Sales_Cost__c != null){
            totalsalescosstinwords = Utility.changeToWords(string.valueOf(booking.property__r.Net_Sales_Price__c.intValue()),true);
        }
        else{
            totalsalescosstinwords = Utility.changeToWords(string.valueOf(0),true);
        }
        
        if(booking.Basic_Cost__c != null){
            basiccosstinwords = Utility.changeToWords(string.valueOf(booking.property__r.Sale_Price_of_RERA_Carpet_Area__c.intValue()),true);
        }
        else{
            basiccosstinwords = Utility.changeToWords(string.valueOf(0),true);
        }
        
        if(booking.PLC_Cost__c != null){
            plccosstinwords = Utility.changeToWords(string.valueOf(booking.property__r.Sale_Price_of_Balcony_Carpet_Area__c.intValue()),true);
        }
        else{
            plccosstinwords = Utility.changeToWords(string.valueOf(0),true);
        }
        Additionalcharges = [select Description__c,Discount_Amount__c from Other_Charges__c where Property_Type__c = :booking.Property__r.Property_Type__c];
        system.debug('Additionalcharges'+Additionalcharges);
        liTowers = [select Tower_Name__c from tower__c where Project_Name__c = :booking.property__r.Project_Name__c];
        Coowners = [select pan__C,Contact_name__c,name from Co_Owner__c where Booking__c = :booking.Id];
        /*PAYMENT PLAN LINE ITEMS*/
        Decimal firstelement = 0;
        Decimal firstelementvalue = 0;
        if(booking.Billing_Plan__c != null){
             billingLineItems = [SELECT Name, Payment_Plan_Line_Item_Name__c,Milestone_Number__c,Line_Item_Type__c,Payment_Group__c ,
                                Discount_Amount__c,Amount__c,Terms_of_Payment_Key__c,Percentage__c,Due_After_Days__c,description__c,
                                Percentage_Of_Value_To_Be_Invoiced__c 
                                FROM Billing_Plan_Line_Item__c 
                                WHERE Payment_Plan__c =: booking.Billing_Plan__c order by  Order__c ASC];
            system.debug('billingLineItems============='+billingLineItems);
            
            billinglineItemTimeLinked =[SELECT Name, Payment_Plan_Line_Item_Name__c,Line_Item_Type__c,Milestone_Number__c,Payment_Group__c ,
                                Discount_Amount__c,Amount__c,Terms_of_Payment_Key__c,Percentage__c,Due_After_Days__c,description__c,
                                Percentage_Of_Value_To_Be_Invoiced__c 
                                FROM Billing_Plan_Line_Item__c 
                                WHERE Payment_Plan__c =: booking.Billing_Plan__c 
                                AND Line_Item_Type__c='Time Linked'
                                AND Payment_Group__c ='IN'
                                order by  Sequence_Number__c ASC];
             Integer CountTimeLinked = billinglineItemTimeLinked.size();  
              system.debug('I@@CountTimeLinked -->'+CountTimeLinked );
             Integer i= 0;
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
                 system.debug('@@billinglineItemTimeLinked[i].Payment_Plan_Line_Item_Name__c-->'+billinglineItemTimeLinked[i].Payment_Plan_Line_Item_Name__c);
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
        
        if(doSave == 'No'){ return null; } 
        if(type =='Acceptance' && SAPSync== '0'){
            id bookingId1 = ApexPages.currentPage().getParameters().get('id');
            
            PageReference pagePdf = new PageReference('/apex/ORL_AcceptanceForm'); 
            pagePdf.getParameters().put('id', bookingId1 ); 
            pagePdf.getParameters().put('doSave', 'No'); 
            pagePdf.getParameters().put('type', 'Acceptance'); 
            Blob pdfPageBlob; 
            pdfPageBlob = pagePdf.getContentAsPDF(); 
            
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
            pdfPageBlob = pagePdf.getContentAsPDF(); 
            
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
            pdfPageBlob = pagePdf.getContentAsPDF(); 
            
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
            pdfPageBlob = pagePdf.getContentAsPDF(); 
            
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
            pdfPageBlob = pagePdf.getContentAsPDF(); 
            
            Attachment a = new Attachment();
            a.Body = pdfPageBlob; 
            a.ParentID = bookingId1; 
            a.Name = 'Auth Letter Auth to Company.pdf'; 
            a.Description = 'Auth to Company Form'; 
            insert a; 
            
            return pagePdf;
        }else if(type =='Booking' && SAPSync== '0'){
            id bookingId1 = ApexPages.currentPage().getParameters().get('id');
            
            PageReference pagePdf = new PageReference('/apex/tablebookingForm'); 
            pagePdf.getParameters().put('id', bookingId1 ); 
            pagePdf.getParameters().put('doSave', 'No'); 
            Blob pdfPageBlob; 
            pdfPageBlob = pagePdf.getContentAsPDF(); 
            
            Attachment a = new Attachment();
            a.Body = pdfPageBlob; 
            a.ParentID = bookingId1; 
            a.Name = 'Booking Form.pdf'; 
            a.Description = 'BookingForm'; 
            insert a; 
            
            return pagePdf;
        }
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
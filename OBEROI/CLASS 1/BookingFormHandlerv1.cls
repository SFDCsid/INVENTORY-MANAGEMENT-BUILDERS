public class BookingFormHandlerv1 {
 

public string doSave{get;set;}
public string type{get;set;} 
public String SAPSync{get;set;} 
public Booking__c booking{get;set;}
public string totalsalespriceword{get;set;}
Public String bookingId;
Public List<Billing_Plan_Line_Item__c> ppliLst{get;set;}
Public String todaydate{get;set;}
Public String AccountPanNumber{get;set;}
public BookingFormHandlerv1(ApexPages.StandardController controller) {
    ppliLst = new List<Billing_Plan_Line_Item__c>();
    doSave = ApexPages.currentPage().getParameters().get('doSave'); 
    todaydate = system.today().day() + '/' + system.today().month() + '/' + system.today().year();
    bookingId = ApexPages.currentPage().getParameters().get('id');
    booking = new Booking__c();
    if(bookingId != '' && bookingId != null ){
        booking = [SELECT Project__c,Contact_Name__c,Tower_Name__c,Initial_Booking_Amount_Realised__c,Booking_Flat_No__c,Tower__r.Tower_Name__c,Tower__c,Project__r.Default_Car_Parking_Configuration__c,Project__r.Default_Car_Parking__c,
                    Primary_Applicant__r.name, Primary_Applicant__r.AccountId, Primary_Applicant__r.PAN__c,Project__r.NAme,
                   Primary_Applicant__r.Billing_Pincode__c,Primary_Applicant__r.Billing_City__c,Primary_Applicant__r.Billing_Street_1__c,Property__r.Floor__r.name,Project_Name__c,Total_Sales_Cost__c,
                   Primary_Applicant__r.Billing_Street_2__c,Primary_Applicant__r.Billing_House_No__c,Primary_Applicant__r.Billing_Street_3__c,Billing_Plan__c ,Primary_Applicant__r.MailingCountry , Contact__r.PAN__c ,Property__r.Carpet_Area_Sq_Mtr__c, Property__r.Carpet_Area__c 
                   FROM Booking__c WHERE Id=:bookingId];
    }
    
    
          /*PAYMENT PLAN LINE ITEMS*/
      Decimal firstelement = 0;
      Decimal firstelementvalue = 0;
       if(booking.Billing_Plan__c != null)
              ppliLst = [Select id,Name,Due_After_Days__c, Amount__c, Amount_Percent_BSP__c, Discount_Amount__c , Description__c

                     from Billing_Plan_Line_Item__c where Payment_Plan__c =: booking.Billing_Plan__c Order By Name ASC NULLS LAST];
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
}
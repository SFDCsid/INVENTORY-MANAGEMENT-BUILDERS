public with sharing class BookingFormPageControllerTable{
    public  Integer lstSize{get;set;}    
    public  decimal discAmt {get;set;}
    public  Booking__c bookingObj{get;set;}
    public  Payment__c payment{get;set;}
    public  String bookdate{get;set;}
    public  String booingkdate{get;set;}
    Public List<kycwrapper> kycwrapperList {get;set;}
    public List<Co_Owner__c> KYCDetailLst{get;set;}
    //Public List<Id> lstCoOwnerId{get;set;}
    public List<KYC_Details__c> lstKycDetail  {get;set;}
    public List<KYC_Details__c> lstKycDetailNew  {get;set;}
    public KYC_Details__c kycNew  {get;set;}
    public List<Account> lstKyc  {get;set;}
    //public Co_Owner__c coownerObj {get;set;}
    //Public List<Co_Owner__c> coownerInstance{get; set;}
    public list<Billing_Plan_Line_Item__c> billingLineItems {get;set;}
    public Decimal inPercent {get;set;}
    public Decimal inAmount {get;set;}
    public list<Payment__c> payList {get;set;}
    public list<Billing_Plan_Line_Item__c> billinglineItemTimeLinked {get;set;}
    // public String billingSubLineItemsHead {get;set;}
    // public String billingSubLineItemsChild {get;set;}
    // public Decimal TimeLinkedAmount{get;set;}
    public Boolean checkResidential{get;set;}
    public Boolean checkResidentialNRI{get;set;}
    //  public PageReference rtn;
    // public Boolean closeWindow {get;set;}
    public BookingFormPageControllerTable(ApexPages.StandardController controller){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Record successfully updated'));
        list<Billing_Plan_Sub_Line_Item__c> billingSubLineItems  = new list<Billing_Plan_Sub_Line_Item__c>();
        map<Id,List<Billing_Plan_Sub_Line_Item__c>> mapBpliToSubLi = new map<Id,List<Billing_Plan_Sub_Line_Item__c>>();
        Decimal totalAmount =  0.0;
        kycwrapperList = new List<kycwrapper>();
        Integer TimeLinkedCount =0;
        bookingObj = new Booking__c();
        Decimal percSum = 0;
        
        
        
        
        bookingObj = [select RERA_Registration_No__c,Primary_Applicants__c,Primary_Applicants__r.Resident_Status__pc,Primary_Applicants__r.Nationality__pc,Billing_Plan__r.Total_Sales_Amount__c,
                      Billing_Plan__r.Total_Sales_Amount_Time_of_Booking__c,property__r.Property_Type_Name__c,
                      Booking_Date__c,Booking_Amount__c,Broker_Company__c,Broker_Name__c, Primary_Applicants__r.Salutation,
                      Primary_Applicants__r.Name,Billing_Str_Suppl1__c,Billing_Str_Suppl2__c,Billing_Str_Suppl3__c,TDS_Paid_By__c,
                      Primary_Applicants__r.Customer_Classification__pc,Opportunity__r.PCID__c,
                      C_o_Name_Billing_Address__c,Opportunity__r.Source_of_Walk_in_Booking__c,
                      Primary_Applicants__r.Occupation__pc,Opportunity__r.Enquiry_Type__c,
                      Primary_Applicants__r.Company__c,Primary_Applicants__r.Company_Address__pc,Billing_City__c,Email__c,
                      Opportunity__r.How_did_You_Hear_About_Us__c,Opportunity__r.Preferred_Mode_of_Communication__c,
                      Telephone__c,Primary_Applicants__r.Designation__pc, Property__r.Project_Name__c ,
                      Opportunity__r.Broker_Account__r.MAHA_RERA_Registration__c,Billing_Plan__r.Total_Sales_Amount_At_Time_of_Booking__c,
                      Floor__r.Floor_Number__c, Tower__r.Tower_Name__c , Property__r.Net_Sales_Price__c,Booking_Flat_No__c ,
                      Opportunity__r.Broker_Account__r.Name,Opportunity__r.Purpose_of_Buying__c,
                      Project__r.MahaRERA_Registration_No__c  , Project__r.Registration_Vendor_Contact_Details__c , 
                      Project__r.Organization_Phone__c ,Loan_Amount__c,Loan_Required__c, Bank_Name__c,
                      Project__r.Subsidiary_Company_Name__c , Project__r.Company_Email__c, Project__r.Sales_Head__r.name,
                      Booking__c.Billing_Plan__c,Triple_Car_Parking__c,Tandem_Car_Parking__c,Single_Car_Parking__c,
                      Opportunity__r.Partner_s_Firm_Name__c,Opportunity__r.Partner_s_Name__c,Opportunity__r.Partner_Email__c,
                      Opportunity__r.Partner_Mobile__c, Property__r.Project_Name__r.Name,Property__r.Unit_Type__c, 
                      Property__r.Floor_Number__c,Property__r.Tower__r.Tower_Name__c,Primary_Applicants__r.Company__pc,
                      Total_Sales_Cost__c,Billing_Street__c,Primary_Applicants__r.Residential_Status__pc,
                      Billing_Post_Code__c,Mobile__c,Property__r.Project_Name__r.Subsidiary_Company_Name__c,
                      Property__r.Project_Name__r.Subsidiary_Company_Address__c,Property__r.Project_Name__r.Other_Company_Postal_Code__c,
                      Property__r.Project_Name__r.Other_Company_Phone__c,Property__r.Project_Name__r.Other_Company_Fax__c,
                      Property__r.Project_Name__r.Other_Company_Website__c,Primary_Applicants__r.Company_city__pc,
                      Primary_Applicants__r.Address_for_Correspondence__pc,Billing_Location__c,Primary_Applicants__r.Company_Pincode__pc,
                      Primary_Applicants__r.Office_Phone_Number__pc,Primary_Applicants__r.Other_Mobile_Number__pc
                      FROM Booking__c where id =:  ApexPages.currentPage().getParameters().get('Id')];
        
        DateTime dT = system.now();
        //bookdate = date.newinstance(dT.year(), dT.month(), dT.day());
        bookdate = dt.format('MM/dd/yyyy');
        
        if(bookingObj.Primary_Applicants__r.Residential_Status__pc == 'Resident Citizen')
            checkResidential = true;
        
        else
            checkResidentialNRI = false;
        
        if(bookingObj != null){
            if(bookingObj.Booking_Date__c != null){
                bookdate = bookingObj.Booking_Date__c.day() + '/' + bookingObj.Booking_Date__c.month() + '/' + bookingObj.Booking_Date__c.year();
            } else{
                bookdate = '';
            }
            
            
            
            /*  if(bookingObj.Booking_Date__c != null){
DateTime dt1 = bookingObj.Booking_Date__c;  
booingkdate = dt1.format('MM/dd/yyyy');
}*/
            //List<Payment__c> payList = new List<Payment__c>();
            system.debug(bookingObj.id +'****');
            payList  = [Select Amount__c, Instrument_Date__c,name,Amount_Type__c,Bank_Account__c,Booking__c,Payment_Date__c,Payment_Mode__c,RTGS_Cheque_Draft_No__c, Bank_Account__r.name,Bank_Name__c
                        From Payment__c where  Booking__c  =: bookingObj.id];
            system.debug(payList+'payList');
            
            //New code
            KYCDetailLst = [select Salutation__c,Contact_name__c from Co_Owner__c where Booking__c =: bookingObj.Id order by NAME ASC]; 
            // if(OfferId != null && OfferId != '')
            /*KYCDetailLst = [Select id, Person_Account__c,Bank_Confirmation_Letter__c, Board_Resolution__c, Cert_of_Incorporation__c, Company_PAN__c, 
Contact__c,Contact__r.Name,Contact__r.Customer_Classification__c,  HUF_PAN__c, Latest_ITR_optional__c, List_of_Designated_Partners__c, 
List_of_Directors__c, List_of_HUF_Members__c, List_of_Partners__c, List_of_Trustees__c, LLP_Agreement__c, 
LLP_PAN__c, M_O_A_A_O_A__c, NRI_Declaration__c, OCI_PIO_Card__c, PAN_Card__c, Passport_Election_ID__c, 
Proprietorship_PAN__c, Registered_Partnership_Deed__c, Registered_Trust_Deed__c, Resolution__c,Person_Account__r.Name,Person_Account__r.Salutation
from Co_Owner__c where Booking__c =: bookingObj.Id order by NAME ASC];*/
            
            //KYCDetailLst = [Select Person_Account__c from Co_Owner__c where Booking__c =: bookingObj.Id];             
            //lstCoOwnerId = [Select id, Person_Account__c from Co_Owner__c where Booking__c =: bookingObj.Id order by NAME ASC];
            //system.debug('KYCDetailLstKYCDetailLst'+KYCDetailLst);
            /*for(Co_Owner__c co : KYCDetailLst){
system.debug('payListpayList'+co);
if(!String.isBlank(co.Person_Account__c)){
system.debug('payListpayList'+co.Person_Account__c);
lstCoOwnerId.add(co.Person_Account__c);
}
}*/
            Map<String,String> mapCoOwnerId = new Map<String,String>();
            List<Co_Owner__c> lstCoOnwer = new List<Co_Owner__c>();
            List<Id> lstCoOwnerId = new List<Id>();
            lstCoOwnerId.add(bookingObj.Primary_Applicants__c);
            for(Co_Owner__c co : [Select id, Name, Person_Account__c from Co_Owner__c where Booking__c =: bookingObj.Id 
                                  order by Name asc]){
                                      //system.debug('payListpayList'+co);
                                      if(!String.isBlank(co.Person_Account__c)){
                                          //system.debug('payListpayList'+co.Person_Account__c);
                                          // mapCoOwnerId.put(co.Person_Account__c,co.Name);
                                          lstCoOnwer.add(co);
                                          lstCoOwnerId.add(co.Person_Account__c);
                                      }
                                  }
            system.debug('lstCoOwnerIdlstCoOwnerId'+lstCoOwnerId);
            //List<Id> lstKyc = new List<Id>();
            lstKyc = null;  
            
            lstKycDetail = new List<KYC_Details__c>();
            //lstKycDetailNew.add(kycNew1);         
            if(lstCoOwnerId != null && lstCoOwnerId.size()>0){
                lstKycDetailNew = [Select id, Person_Account__c,Person_Account__r.Name, Person_Account__r.Customer_Classification__pc,
                                   Board_Resolution__c, Cert_of_Incorporation__c, Company_PAN__c,HUF_PAN__c, 
                                   Latest_ITR_optional__c, List_of_Designated_Partners__c, List_of_Directors__c, 
                                   List_of_HUF_Members__c, List_of_Partners__c, List_of_Trustees__c, LLP_Agreement__c, 
                                   LLP_PAN__c, M_O_A_A_O_A__c, NRI_Declaration__c, OCI_PIO_Card__c, PAN_Card__c, 
                                   Passport_Election_ID__c, Proprietorship_PAN__c, Registered_Partnership_Deed__c, 
                                   Registered_Trust_Deed__c, Resolution__c,Bank_Confirmation_Letter__c
                                   from KYC_Details__c where Person_Account__c IN : lstCoOwnerId];//mapCoOwnerId.values()];
                //System.debug('AAAAAAAAAAAAAAAAAAAAAAAAAAa'+lstKycDetail);
                for(KYC_Details__c kpc : lstKycDetailNew){
                    if(kpc.Person_Account__c == bookingObj.Primary_Applicants__c){
                        lstKycDetail.add(kpc);}
                }
                for(integer i=0;i<lstCoOnwer.size();i++){
                    for(KYC_Details__c kpc : lstKycDetailNew){
                        if(kpc.Person_Account__c != bookingObj.Primary_Applicants__c 
                           && kpc.Person_Account__c == lstCoOnwer[i].Person_Account__c){
                               lstKycDetail.add(kpc);
                           }                   
                    }
                }
                //lstKycDetail.sort();
                System.debug('AAAAAAAAAAAAAAAAAAAAAAAAAAa'+lstKycDetail);
                if(lstKycDetail != null && lstKycDetail.size()>0){
                    
                    
                    for(KYC_Details__c kyc : lstKycDetail){
                        //system.debug('11111111111'+!lstCoOwnerId.Contains(kyc.Person_Account__c));
                        
                        if(!lstCoOwnerId.Contains(kyc.Person_Account__c)){
                            for(Account ka : [select id,name,Customer_Classification__pc from Account where Id =: kyc.Person_Account__c]){
                                lstKyc.add(ka);}
                            system.debug('11111111111'+lstKyc);
                        }
                        if(kyc.Person_Account__r.Customer_Classification__pc == 'Individual'){
                            List<string> pendingdocslist = new List<string>();                 
                            if(kyc.Passport_Election_ID__c == false){
                                pendingdocslist.add('Passport/Election ID');
                            } 
                            if(kyc.PAN_Card__c == false){
                                pendingdocslist.add('PAN Card');
                            }
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(kyc.Person_Account__r.Name, pendingdocstring));
                            }
                        } else if(kyc.Person_Account__r.Customer_Classification__pc== 'NRI'){
                            List<string> pendingdocslist = new List<string>();
                            if(kyc.Passport_Election_ID__c == false){
                                pendingdocslist.add('Passport/Election ID');
                            } 
                            if(kyc.PAN_Card__c == false){
                                pendingdocslist.add('PAN Card');
                            }
                            if(kyc.NRI_Declaration__c == false){
                                pendingdocslist.add('NRI Declaration Form');
                            }
                            if(kyc.OCI_PIO_Card__c == false){
                                pendingdocslist.add('OCI/PIO Card');
                            }
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(kyc.Person_Account__r.Name, pendingdocstring));
                            }
                        } else if(kyc.Person_Account__r.Customer_Classification__pc == 'HUF'){
                            List<string> pendingdocslist = new List<string>();
                            if(kyc.HUF_PAN__c == false){
                                pendingdocslist.add('HUF PAN');
                            } 
                            if(kyc.List_of_HUF_Members__c == false){
                                pendingdocslist.add('List of HUF Members');
                            }
                            if(kyc.Bank_Confirmation_Letter__c == false){
                                pendingdocslist.add('Bank Confirmation Letter');
                            }
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(kyc.Person_Account__r.Name, pendingdocstring));
                            }
                        } else if(kyc.Person_Account__r.Customer_Classification__pc == 'Company'){
                            List<string> pendingdocslist = new List<string>();
                            if(kyc.Board_Resolution__c == false){
                                pendingdocslist.add('Board Resolution');
                            } 
                            if(kyc.List_of_Directors__c == false){
                                pendingdocslist.add('List of Directors');
                            }
                            if(kyc.M_O_A_A_O_A__c == false){
                                pendingdocslist.add('M.O.A. & A.O.A.');
                            }
                            if(kyc.Company_PAN__c == false){
                                pendingdocslist.add('Company PAN');
                            }
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(kyc.Person_Account__r.Name, pendingdocstring));
                            }
                        } else if(kyc.Person_Account__r.Customer_Classification__pc == 'Partnership'){
                            List<string> pendingdocslist = new List<string>();
                            if(kyc.Passport_Election_ID__c == false){
                                pendingdocslist.add('Passport/Election ID');
                            } 
                            if(kyc.PAN_Card__c == false){
                                pendingdocslist.add('PAN Card');
                            }
                            if(kyc.Registered_Partnership_Deed__c == false){
                                pendingdocslist.add('Registered Partnership Deed');
                            }
                            if(kyc.List_of_Partners__c == false){
                                pendingdocslist.add('List of Partners');
                            }
                            if(kyc.Resolution__c == false){
                                pendingdocslist.add('Resolution');
                            }
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(kyc.Person_Account__r.Name, pendingdocstring));
                            }
                        } else if(kyc.Person_Account__r.Customer_Classification__pc == 'Proprietorship'){
                            List<string> pendingdocslist = new List<string>();
                            if(kyc.Bank_Confirmation_Letter__c == false){
                                pendingdocslist.add('Bank Confirmation Letter');
                            } 
                            if(kyc.Proprietorship_PAN__c == false){
                                pendingdocslist.add('Proprietorship PAN');
                            }
                            if(kyc.Latest_ITR_optional__c == false){
                                pendingdocslist.add('Latest ITR (optional)');
                            }
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(kyc.Person_Account__r.Name, pendingdocstring));
                            }
                        } else if(kyc.Person_Account__r.Customer_Classification__pc == 'Trust'){
                            List<string> pendingdocslist = new List<string>();
                            if(kyc.Registered_Trust_Deed__c == false){
                                pendingdocslist.add('Registered Trust Deed');
                            } 
                            if(kyc.List_of_Trustees__c == false){
                                pendingdocslist.add('List of Trustees');
                            }
                            if(kyc.Resolution__c == false){
                                pendingdocslist.add('Resolution');
                            }
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(kyc.Person_Account__r.Name, pendingdocstring));
                            }
                        } else if(kyc.Person_Account__r.Customer_Classification__pc == 'LLP'){
                            List<string> pendingdocslist = new List<string>();
                            if(kyc.LLP_Agreement__c == false){
                                pendingdocslist.add('LLP Agreement');
                            } 
                            if(kyc.LLP_PAN__c == false){
                                pendingdocslist.add('LLP PAN');
                            }
                            if(kyc.Cert_of_Incorporation__c == false){
                                pendingdocslist.add('Cert of Incorporation');
                            }
                            if(kyc.List_of_Designated_Partners__c == false){
                                pendingdocslist.add('List of Designated Partners');
                            }
                            if(kyc.Resolution__c == false){
                                pendingdocslist.add('Resolution');
                            }
                            if(kyc.Bank_Confirmation_Letter__c == false){
                                pendingdocslist.add('Bank Confirmation Letter');
                            }
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(kyc.Person_Account__r.Name, pendingdocstring));
                            }
                        }
                    } 
                }
                else  {
                    for(Account pa : [select id,name,Customer_Classification__pc from Account where Id IN: lstCoOwnerId]){
                        if(pa.Customer_Classification__pc == 'Individual'){
                            List<string> pendingdocslist = new List<string>();                 
                            pendingdocslist.add('Passport/Election ID');
                            pendingdocslist.add('PAN Card');
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
                            }
                        } else if(pa.Customer_Classification__pc== 'NRI'){
                            List<string> pendingdocslist = new List<string>();
                            pendingdocslist.add('Passport/Election ID');
                            pendingdocslist.add('PAN Card');
                            pendingdocslist.add('NRI Declaration Form');
                            pendingdocslist.add('OCI/PIO Card');
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
                            }
                        } else if(pa.Customer_Classification__pc == 'HUF'){
                            List<string> pendingdocslist = new List<string>();
                            pendingdocslist.add('HUF PAN');
                            pendingdocslist.add('List of HUF Members');
                            pendingdocslist.add('Bank Confirmation Letter');
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
                            }
                        } else if(pa.Customer_Classification__pc == 'Company'){
                            List<string> pendingdocslist = new List<string>();
                            pendingdocslist.add('Board Resolution');
                            pendingdocslist.add('List of Directors');
                            pendingdocslist.add('M.O.A. & A.O.A.');
                            pendingdocslist.add('Company PAN');
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
                            }
                        } else if(pa.Customer_Classification__pc == 'Partnership'){
                            List<string> pendingdocslist = new List<string>();
                            pendingdocslist.add('Passport/Election ID');
                            pendingdocslist.add('PAN Card');
                            pendingdocslist.add('Registered Partnership Deed');
                            pendingdocslist.add('List of Partners');
                            pendingdocslist.add('Resolution');
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
                            }
                        } else if(pa.Customer_Classification__pc == 'Proprietorship'){
                            List<string> pendingdocslist = new List<string>();
                            pendingdocslist.add('Bank Confirmation Letter');
                            pendingdocslist.add('Proprietorship PAN');
                            pendingdocslist.add('Latest ITR (optional)');
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
                            }
                        } else if(pa.Customer_Classification__pc == 'Trust'){
                            List<string> pendingdocslist = new List<string>();
                            pendingdocslist.add('Registered Trust Deed');
                            pendingdocslist.add('List of Trustees');
                            pendingdocslist.add('Resolution');
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
                            }
                        } else if(pa.Customer_Classification__pc == 'LLP'){
                            List<string> pendingdocslist = new List<string>();
                            pendingdocslist.add('LLP Agreement');
                            pendingdocslist.add('LLP PAN');
                            pendingdocslist.add('Cert of Incorporation');
                            pendingdocslist.add('List of Designated Partners');
                            pendingdocslist.add('Resolution');
                            pendingdocslist.add('Bank Confirmation Letter');
                            if(pendingdocslist.size()>0 && pendingdocslist != null){
                                String pendingdocstring = String.join(pendingdocslist, ', ');
                                kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
                            }
                        }
                    }
                }
                /*
system.debug('lstKyclstKyclstKyc'+lstKyc);
if(lstKyc != null && lstKyc.size()>0)
for(Account pa : lstKyc){
if(pa.Customer_Classification__pc == 'Individual'){
List<string> pendingdocslist = new List<string>();                 
pendingdocslist.add('Passport/Election ID');
pendingdocslist.add('PAN Card');
if(pendingdocslist.size()>0 && pendingdocslist != null){
String pendingdocstring = String.join(pendingdocslist, ', ');
kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
}
} else if(pa.Customer_Classification__pc== 'NRI'){
List<string> pendingdocslist = new List<string>();
pendingdocslist.add('Passport/Election ID');
pendingdocslist.add('PAN Card');
pendingdocslist.add('NRI Declaration Form');
pendingdocslist.add('OCI/PIO Card');
if(pendingdocslist.size()>0 && pendingdocslist != null){
String pendingdocstring = String.join(pendingdocslist, ', ');
kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
}
} else if(pa.Customer_Classification__pc == 'HUF'){
List<string> pendingdocslist = new List<string>();
pendingdocslist.add('HUF PAN');
pendingdocslist.add('List of HUF Members');
pendingdocslist.add('Bank Confirmation Letter');
if(pendingdocslist.size()>0 && pendingdocslist != null){
String pendingdocstring = String.join(pendingdocslist, ', ');
kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
}
} else if(pa.Customer_Classification__pc == 'Company'){
List<string> pendingdocslist = new List<string>();
pendingdocslist.add('Board Resolution');
pendingdocslist.add('List of Directors');
pendingdocslist.add('M.O.A. & A.O.A.');
pendingdocslist.add('Company PAN');
if(pendingdocslist.size()>0 && pendingdocslist != null){
String pendingdocstring = String.join(pendingdocslist, ', ');
kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
}
} else if(pa.Customer_Classification__pc == 'Partnership'){
List<string> pendingdocslist = new List<string>();
pendingdocslist.add('Passport/Election ID');
pendingdocslist.add('PAN Card');
pendingdocslist.add('Registered Partnership Deed');
pendingdocslist.add('List of Partners');
pendingdocslist.add('Resolution');
if(pendingdocslist.size()>0 && pendingdocslist != null){
String pendingdocstring = String.join(pendingdocslist, ', ');
kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
}
} else if(pa.Customer_Classification__pc == 'Proprietorship'){
List<string> pendingdocslist = new List<string>();
pendingdocslist.add('Bank Confirmation Letter');
pendingdocslist.add('Proprietorship PAN');
pendingdocslist.add('Latest ITR (optional)');
if(pendingdocslist.size()>0 && pendingdocslist != null){
String pendingdocstring = String.join(pendingdocslist, ', ');
kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
}
} else if(pa.Customer_Classification__pc == 'Trust'){
List<string> pendingdocslist = new List<string>();
pendingdocslist.add('Registered Trust Deed');
pendingdocslist.add('List of Trustees');
pendingdocslist.add('Resolution');
if(pendingdocslist.size()>0 && pendingdocslist != null){
String pendingdocstring = String.join(pendingdocslist, ', ');
kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
}
} else if(pa.Customer_Classification__pc == 'LLP'){
List<string> pendingdocslist = new List<string>();
pendingdocslist.add('LLP Agreement');
pendingdocslist.add('LLP PAN');
pendingdocslist.add('Cert of Incorporation');
pendingdocslist.add('List of Designated Partners');
pendingdocslist.add('Resolution');
pendingdocslist.add('Bank Confirmation Letter');
if(pendingdocslist.size()>0 && pendingdocslist != null){
String pendingdocstring = String.join(pendingdocslist, ', ');
kycwrapperList.add(new kycwrapper(pa.Name, pendingdocstring));
}
}
}*/
            }
            
            //List<Co_Owner__c> coownerInstance  = [Select Bank_Confirmation_Letter__c    ,Board_Resolution__c    ,Booking__c ,Cert_of_Incorporation__c, Company_PAN__c   ,Contact__c ,HUF_PAN__c ,Latest_ITR_optional__c ,List_of_Designated_Partners__c ,List_of_Directors__c   ,List_of_HUF_Members__c ,List_of_Partners__c    ,List_of_Trustees__c    ,LLP_Agreement__c   ,LLP_PAN__c ,M_O_A_A_O_A__c ,NRI_Declaration__c ,OCI_PIO_Card__c    ,Opportunity__c ,PAN__c ,PAN_Card__c    ,Passport_Election_ID__c    ,Person_Account__c,Person_Account__r.Name,Person_Account__r.Salutation,Proprietorship_PAN__c  ,Registered_Partnership_Deed__c ,Registered_Trust_Deed__c   ,Resolution__c,Contact__r.name,Contact_name__c
            //From Co_Owner__c where  Booking__c  =: bookingObj.id limit 1];
            
            
            // if(coownerInstance.size()>0)
            // coownerObj = coownerInstance[0];
            
            if(bookingObj.Billing_Plan__c != null){
                billingLineItems = [SELECT Name, Payment_Plan_Line_Item_Name__c,Milestone_Number__c,Line_Item_Type__c,Payment_Group__c ,
                                    Percentage_Rate__c,Discount_Amount__c,Amount__c,Terms_of_Payment_Key__c,Percentage__c,Due_After_Days__c,
                                    Percentage_Of_Value_To_Be_Invoiced__c 
                                    FROM Billing_Plan_Line_Item__c 
                                    WHERE Payment_Plan__c =: bookingObj.Billing_Plan__c order by  Order__c ASC];
                
                inAmount = 0;
                inPercent = 0;
                for(Billing_Plan_Line_Item__c bpli : [select Percentage_Of_Value_To_Be_Invoiced__c,Percentage_Rate__c,Discount_Amount__c 
                                                      from Billing_Plan_Line_Item__c WHERE Payment_Plan__c =: bookingObj.Billing_Plan__c
                                                      AND Payment_Group__c ='IN']){
                                                          inAmount = inAmount + bpli.Discount_Amount__c;
                                                          inPercent = inPercent + Decimal.valueOf(bpli.Percentage_Of_Value_To_Be_Invoiced__c);
                                                      }
                system.debug('inAmountinAmount'+inAmount);
                system.debug('inPercentinPercent'+inPercent);
                //Changes Added By Vaidehi
                discAmt = 0.00;
                lstSize =1;
                for (Billing_Plan_Line_Item__c pp: billingLineItems){
                    if(!pp.Terms_of_Payment_Key__c.contains('IN')){                        
                        lstSize = lstSize+1;
                        discAmt =pp.Discount_Amount__c.setScale(0,RoundingMode.HALF_UP) + discAmt;
                        system.debug('pp.Discount_Amount__cBBBOOOOO)'+pp.Terms_of_Payment_Key__c+pp.Discount_Amount__c.setScale(0,RoundingMode.HALF_UP));
                    } 
                    
                }
                if(inAmount == 0){
                system.debug('tttt'+inAmount);
                lstSize = lstSize-1;
                }
                discAmt = discAmt+inAmount.setScale(0,RoundingMode.HALF_UP);
                system.debug(discAmt+'$$$$$');
                integer size = billingLineItems.size() -1;
                discAmt = discAmt -  billingLineItems[size].Discount_Amount__c.setScale(0,RoundingMode.HALF_UP);
                discAmt = bookingObj.Billing_Plan__r.Total_Sales_Amount_At_Time_of_Booking__c.setScale(0,RoundingMode.HALF_UP) - discAmt.setScale(0,RoundingMode.HALF_UP)  ;
               system.debug(discAmt+'$$$$$$'+lstSize);
               discAmt = discAmt.setScale(0,RoundingMode.HALF_UP);
               //Changes Finished
                billinglineItemTimeLinked =[SELECT Name, Payment_Plan_Line_Item_Name__c,Line_Item_Type__c,Milestone_Number__c,Payment_Group__c ,
                                            Discount_Amount__c,Amount__c,Terms_of_Payment_Key__c,Percentage__c,Due_After_Days__c,
                                            Percentage_Rate__c,Percentage_Of_Value_To_Be_Invoiced__c 
                                            FROM Billing_Plan_Line_Item__c 
                                            WHERE Payment_Plan__c =: bookingObj.Billing_Plan__c 
                                            AND Line_Item_Type__c='Time Linked'
                                            AND Payment_Group__c ='IN'
                                            order by  Sequence_Number__c ASC];
                Integer CountTimeLinked = billinglineItemTimeLinked.size();  
                system.debug('I@@CountTimeLinked -->'+CountTimeLinked );
                Integer i= 0;                 
                for(i=0; i<CountTimeLinked ; i++){
                    system.debug('I@@i-->'+i);
                    if(i==CountTimeLinked-1){
                        system.debug('In');
                        system.debug('@@Date-->'+bookingObj.Booking_Date__c);
                        system.debug('@@Date-->'+Integer.valueOf(billinglineItemTimeLinked[i].Due_After_Days__c));
                        system.debug('@@Date-->'+bookingObj.Booking_Date__c.adddays(Integer.valueOf(billinglineItemTimeLinked[i].Due_After_Days__c)));
                        dateTime timeBookingDate = bookingObj.Booking_Date__c.adddays(Integer.valueOf(billinglineItemTimeLinked[i].Due_After_Days__c)-1);
                        String timeBookingDateFormat = timeBookingDate.format('MM/dd/yyyy');
                        billinglineItemTimeLinked[i].Payment_Plan_Line_Item_Name__c= 'To be paid on or Before '+ timeBookingDateFormat + ' along with any further milestones raised till then';
                        system.debug('@@billinglineItemTimeLinked[i].Payment_Plan_Line_Item_Name__c-->'+billinglineItemTimeLinked[i].Payment_Plan_Line_Item_Name__c);
                    }
                }
                system.debug('@@billinglineItemTimeLinked----->'+billinglineItemTimeLinked);
                /*for(Billing_Plan_Sub_Line_Item__c bpsli : [SELECT Name,Billing_Plan_Sub_Line_Item_Name__c,Milestone_Number__c,Billing_Plan_Line_Item__c,Amount_Percent_BSP__c,Terms_of_Payment_Key__c,Percentage_Of_Value_To_Be_Invoiced__c 
FROM Billing_Plan_Sub_Line_Item__c
WHERE Billing_Plan_Line_Item__r.Payment_Plan__c =: bookingObj.Billing_Plan__c ]){
if(mapBpliToSubLi.containsKey(bpsli.Billing_Plan_Line_Item__c)){
mapBpliToSubLi.get(bpsli.Billing_Plan_Line_Item__c).add(bpsli);
} else{
mapBpliToSubLi.put(bpsli.Billing_Plan_Line_Item__c, new List<Billing_Plan_Sub_Line_Item__c>{bpsli});
}
}*/
                
                /*  for(Billing_Plan_Line_Item__c bpli: billingLineItems){
// To Update   if(bpli.Payment_Group__c=='IN' && bpli.Milestone_Number__c==0){
if(bpli.Payment_Group__c=='IN'){
billingSubLineItems = mapBpliToSubLi.get(bpli.Id); 
}                  
}     
*/
                /* for(Billing_Plan_Sub_Line_Item__c bpsliObj : billingSubLineItems){
percSum = percSum+Decimal.valueOf(bpsliObj.Percentage_Of_Value_To_Be_Invoiced__c);
if(bpsliObj.Milestone_Number__c=='0'){
TimeLinkedCount= TimeLinkedCount+1;
}
}
*/
                //   system.debug('Amount---'+bookingObj.Billing_Plan__r.Total_Sales_Amount__c);
                //   TimeLinkedAmount = (percSum * bookingObj.Billing_Plan__r.Total_Sales_Amount__c) / 100;
                system.debug('Amount---'+bookingObj.Billing_Plan__r.Total_Sales_Amount_Time_of_Booking__c);
                //   TimeLinkedAmount = (percSum * bookingObj.Billing_Plan__r.Total_Sales_Amount_Time_of_Booking__c) / 100;
                //   billingSubLineItemsHead = 'Proportionate '+ billingSubLineItems.Size() +' installments upon casting of relevant slabs. Out of which '+ TimeLinkedCount +
                //                               ' relevent slabs have been casted and the amount of Rs.' + TimeLinkedAmount +' towards the Sale Price is payable as below.';
                //   billingSubLineItemsChild ='To be paid on or before 11/3/2019 along with any further milestones raised till then' ;         
            } 
        }
        // closeWindow = true;
        // attachPDF();
    }
    
    Public class kycwrapper{
        Public string accountname{get;set;}
        Public string pendingdoc{get;set;}
        
        Public kycwrapper(String accountname, String pendingdoc){
            
            this.accountname = accountname;
            this.pendingdoc = pendingdoc;
            
        }
    }
    
    public PageReference attachPDF() {
        
        List<Attachment> listExistingAttachment = [SELECT Id FROM Attachment WHERE parentId =: bookingObj.Id];
        if(listExistingAttachment.size()>0 && !listExistingAttachment.isEmpty()){
            delete listExistingAttachment ;
        }
        
        //generate and attach the PDF document
        PageReference pdfPage = Page.BookingFormAttach;
        pdfPage .getParameters().put('id',bookingObj.Id);
        Blob pdfBlob; 
        if(Test.isRunningTest()){
            pdfBlob = Blob.valueOf('Hello Abc, Testing here');
        } else {
            pdfBlob = pdfPage.getContentasPDF();
        }
        // pdfBlob = pdfPage.getContentasPDF();
        Attachment attach = new Attachment(parentId = bookingObj.Id, Name = 'BookingForm.pdf', body = pdfBlob); 
        insert attach; 
        PageReference pageRef = New PageReference('/lightning/r/Booking__c/' +bookingObj.Id+ '/view');
        pageRef.setRedirect(true);
        return pageRef; 
    }
}

/*
Please find the objects for Booking form,

CUSTOMER/S DETAILS (TO BE FILLED IN BLOCK LETTERS) : Booking ->Primary Applicant
BOOKING DETAILS : Booking ->Primary Applicant
PROPERTY CONSULTANT DETAILS : from Booking-> Property->project
Booking Details : Booking
PAYMENT DETAILS  : BANK
KYC Details : Co-owner object
Acknowledgement : Booking- contact

PAYMENT DETAILS  : BANK -- Not able to Find Bank Object. - its record type of Account
PROPERTY CONSULTANT DETAILS :  from Booking-> Property->project  -- Not able to find Consultant details in Project --from Booking-> Property(related obj of Booking)->project(Lookup).*/
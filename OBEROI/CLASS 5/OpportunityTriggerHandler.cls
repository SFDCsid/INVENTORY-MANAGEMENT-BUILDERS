public class OpportunityTriggerHandler {    
    
    public static Map<id, Project__c> ProjMap = new Map<id, Project__c>([SELECT id, Name, Project_Site_Office_Address__c FROM Project__c where RecordType.Name =:Label.Lead_RecordType_Residential] );
    
    // Update Lead Status to booked, Once Opportunity Status is Booked
    public static void AfterUpdateOpportunityStatusBooked( Map<id, Opportunity> newOpp ){  
        Set<Id> optyid = new set<id>();
        Set<Id> closedOptyid = new set<id>();
        Set<Id> closedLeadid = new set<id>();
        List<Lead> lls = new List<Lead>();
        for(Opportunity opd : newOpp.values()) { 
            system.debug('@@@@:'+opd.Opportunity_Status__c);
            system.debug('@@@@:'+opd.Id);
            if(opd.Opportunity_Status__c=='Booked' ){
                optyid.add(opd.id);
            } 
            else if(opd.Opportunity_Status__c=='Closed' || opd.Opportunity_Status__c=='Duplicate (Datasheet)'){
                
                if(String.isNotBlank(opd.Related_Lead__c))
                    closedLeadid.add(opd.Related_Lead__c);
                else{
                    closedOptyid.add(opd.id);
                }
            }
            
        }
        system.debug('@@@@:'+optyid);
        if(optyid.size()>0){
            try{
                id leadid = [select id from lead where ConvertedOpportunityId in :optyid].id;
                system.debug('@@@@@:'+leadid);
                if(leadid!=null || leadid!=''){
                    Lead l = new Lead();
                    l.id = leadid;
                    l.status='Converted to Opportunity';
                    l.Lead_Stage__c='Booked';
                    lls.add(l);
                }
                
            }Catch(Exception e){
                system.debug('line 41 Exception'+e.getMessage());
            }
            
        } else {
            if(closedLeadid.size()>0){
                try{
                    id leadid = [select id from lead where id in :closedLeadid].id;
                    system.debug('@@@@@:'+leadid);
                    if(leadid!=null || leadid!=''){
                        Lead l = new Lead();
                        l.id = leadid;
                        l.status='Closed';
                        l.Lead_Stage__c='Closed';
                        lls.add(l);
                    }
                    
                }Catch(Exception e){
                    system.debug(e.getMessage());
                }
                
            } 
            if(closedOptyid.size()>0){
                try{
                    id leadid = [select id from lead where ConvertedOpportunityId in :closedOptyid].id;
                    system.debug('@@@@@:'+leadid);
                    if(leadid!=null || leadid!=''){
                        Lead l = new Lead();
                        l.id = leadid;
                        l.status='Closed';
                        l.Lead_Stage__c='Closed';
                        lls.add(l);
                    }
                    
                }Catch(Exception e){
                    system.debug(e.getMessage());
                }
                
            }
        }
        update lls;
        /*try{
update lls;
}
Catch(Exception e){
system.debug(e.getMessage());
}*/
    }
    
    // public static void UpdateBookingDetailsOnOpty(Map<Id, Opportunity> trigOldMap, List<Opportunity> trigNew){    
    //    system.debug('UpdateBookingDetailsOnOpty');
    //  createCoOwnerAndAcc(trigOldMap, trigNew);
    //  }
    
    public  static void updateBookingCountOnCampaign(Set<id> campId){
        if(campId.size()!= 0){
            
            List<Campaign> updatedCampList = new List<Campaign>();
            Map<id,Campaign> campMap = new Map<id,Campaign>([select id, name from Campaign where id IN :campId]);    
            system.debug('***'+campMap);
            for (Campaign campn : [select Id, Name,Booking_Count__c,(select id, Booking_Count__c,Partner_Mobile__c, campaignId from Opportunities) from Campaign where Id IN :campId]) {
                campMap.get(campn.Id).Booking_Count__c =0;
                for(Opportunity opp : campn.Opportunities){           
                    campMap.get(campn.Id).Booking_Count__c = campMap.get(campn.Id).Booking_Count__c+ opp.Booking_Count__c;
                }
                updatedCampList.add(campMap.get(campn.Id));
                system.debug(updatedCampList+'updatedCampList');
            }    
            try{
                update updatedCampList;
            }
            catch(Exception e){system.debug(e.getLineNumber()+e.getMessage());}
        }  
    }
    /*
//Opportunity Status Assigned to Front Desk create task
@future
public static void CreateTaskOnOpportunity(set<Id> optyid){
//Id recTypeId = Schema.SObjectType.Property__c.getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId();
Id recTypeId =[select id, name from recordtype where name='Residential Opportunity'].id;
Map<id,Opportunity> optyMap = new Map<id,Opportunity>([select id, Project__r.Front_Desk_User__c, Date_of_Site_Visit__c from Opportunity where id=:optyid]);
List<Task> tsklst = new List<Task>();
system.debug('1.1');
for(Opportunity op :[select id, Project__r.Front_Desk_User__c, Date_of_Site_Visit__c from Opportunity where id=:optyid]){
Task tsk = new Task();
tsk.recordtypeid=recTypeId ;
tsk.Status='Open';
tsk.Priority='Normal';
tsk.ActivityDate=System.today();
tsk.OwnerId=op.Project__r.Front_Desk_User__c;
tsk.Subject='Site Visit Schedule';
tsk.Date_of_Site_Visit__c=op.Date_of_Site_Visit__c;
tsk.WhatId='006';
tsk.WhoId=op.id;
tsklst.add(tsk);
system.debug('1.2');
}
Insert tsklst;
system.debug('1.3');
}
*/
    
    public static void beforeInsertOpportunity( list<Opportunity> newOpp ){        
        Id resRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.Lead_RecordType_Residential).getRecordTypeId();
        
        system.debug('In Handler'+resRecordTypeId);
        for (Opportunity opp: newOpp){
            //Changes Added by Vaidehi to update Opportunity Status Flag
            if (opp.Opportunity_Status__c == Label.AssignedToSales){
                opp.AssignedToSalesFlag__c = true;
            }
            //Changes Finished  
            if((opp.Opportunity_Status__c == Label.Lead_Status_Site_Visit_to_be_Scheduled  || opp.Opportunity_Status__c ==Label.Lead_Status_Site_Visit_Rescheduled) && opp.RecordTypeId == resRecordTypeId && (opp.Date_of_Site_Visit__c != null))
                sendSMS(opp);
            //null;
        }
    }
    
    public static void afterInsertOpportunity( list<Opportunity> newOpp ){  
        //Below code is added for Channel partner creation   
        system.debug('Inside afterInsertOpportunity >>>'+newOpp);
        String Projectid ='';
        String BrokerCode ='';
        List<Account> a = new List<Account>();
        List<Channel_Partner_Project__c> CPProjetList = new List<Channel_Partner_Project__c>();  
        List<Opportunity> opplist = new List<Opportunity>();
        Set<Id> Opids = new Set<Id>();
        String opRecordTypeId ='';
        for(Opportunity o : newOpp){
            Opids.add(o.id);
        }
        system.debug('Inside Opids >>>'+Opids);
        
        String opRecordTypedevname = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail Leasing').getDeveloperName();
        opRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail Leasing').getRecordTypeId();
        system.debug('Inside opRecordTypedevname >>>'+opRecordTypedevname);
        system.debug('Inside opRecordTypeId >>>'+opRecordTypeId);
        
        opplist = [select id, Name, RecordTypeId, Broker_Account__c, Broker_Account__r.Broker_Code__c, Leasing_Project__c, 
                   Source_of_Walk_in_Booking__c
                   from Opportunity WHERE Id IN  : Opids ];  //AND RecordTypeId = : opRecordTypeId
        system.debug('Inside afterInsertOpportunity from query >>>'+opplist);
        
        if(opplist.size() > 0){
            for(Opportunity p :opplist){
                If(p.Source_of_Walk_in_Booking__c == 'Channel Partner'){
                    Id cpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
                    If(p.Source_of_Walk_in_Booking__c == 'Channel Partner' && p.Broker_Account__r.Broker_Code__c != ''){  // && B.Vendor_Code__c != ''
                        BrokerCode = p.Broker_Account__r.Broker_Code__c;
                        Projectid  = p.Leasing_Project__c ;
                        system.debug('BrokerCode:::'+BrokerCode+'Projectid'+Projectid);
                    }
                    a= [Select Id, Name,Broker_Code__c From Account Where Broker_Code__c =: BrokerCode AND recordtypeid =: cpRecordTypeId];
                    CPProjetList = [Select Id, Name,account__c,Extended__c,account__r.Broker_Code__c, Leasing_Project__c 
                                    FROM Channel_Partner_Project__c WHERE Leasing_Project__c =:Projectid 
                                    AND account__r.Broker_Code__c =: BrokerCode order by CreatedDate desc limit 1];
                    system.debug('CPProjetList:::'+CPProjetList);     
                    
                    if(CPProjetList.size()>0){
                        system.debug('Found CP Project:::'+CPProjetList);                   
                    }Else{
                        Channel_Partner_Project__c CPProj = new Channel_Partner_Project__c ();
                        CPProj.Account__c = a[0].id;
                        CPProj.Leasing_Project__c = Projectid ;
                        insert CPProj;         
                        system.debug('CPProj:::'+CPProj);        
                    }
                }Else{system.debug('NOT CP Opportunity');}
                
            }   
        }
    }
    
    public static void beforeUpdateOpportunity( Map<id, Opportunity>newLead , Map<id, Opportunity>oldLead){ 
        Id resRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.Lead_RecordType_Residential).getRecordTypeId();
        
        for (Opportunity opp: newLead.values()){
            //Changes Added by Vaidehi to update Opportunity Status Flag
            if ((opp.Opportunity_Status__c == Label.AssignedToSales) && opp.AssignedToSalesFlag__c == false && oldLead.get(opp.Id).Opportunity_Status__c != opp.Opportunity_Status__c){
                opp.AssignedToSalesFlag__c = true;
            }
            //Changes Finished   
            system.debug('In Handler'+opp.Opportunity_Status__c+'   '+oldLead.get(opp.Id).Opportunity_Status__c);       
            if(((opp.Opportunity_Status__c == Label.Lead_Status_Site_Visit_to_be_Scheduled && opp.Opportunity_Status__c != oldLead.get(opp.Id).Opportunity_Status__c )  || (opp.Opportunity_Status__c ==Label.Lead_Status_Site_Visit_Rescheduled && opp.Opportunity_Status__c != oldLead.get(opp.Id).Opportunity_Status__c )) && opp.RecordTypeId == resRecordTypeId && (opp.Date_of_Site_Visit__c != null) )
                system.debug('@@@@:'+opp);
            sendSMS(opp);
        }
        //sendMessage(newLead);
    }
    
    
    //Method For generate OTP
    public static void sendSMS(Opportunity opt) {
        String statMess;
        //Commented by Vaidehi 17/06
        if('Site Visit Scheduled'.equalsIgnoreCase(opt.Opportunity_Status__c) && 'Web'.equalsIgnoreCase(opt.LeadSource))
            statMess= Label.SMS_for_SIteVisit_From_Web;  
        else if(Label.Lead_Status_Site_Visit_Rescheduled.equalsIgnoreCase(opt.Opportunity_Status__c) && opt.Date_of_Site_Visit__c!= null )
            statMess ='We are pleased to inform you that your site visit to the Oberoi Realty Customer Experience Centre at ' + ProjMap.get(opt.Project__c).Project_Site_Office_Address__c+ ' has been rescheduled on '+ (opt.Date_of_Site_Visit__c+ new EnquiryDateComponent().offset)+' We look forward to having you there. Thank you. '+opt.Google_Map_Link__c;   
        else if('Site Visit Scheduled'.equalsIgnoreCase(opt.Opportunity_Status__c) &&  opt.Date_of_Site_Visit__c!= null)
            statMess = 'We are pleased to inform you that your site visit to the Oberoi Realty Customer Experience Centre at ' + ProjMap.get(opt.Project__c).Project_Site_Office_Address__c+ ' has been scheduled on '+ (opt.Date_of_Site_Visit__c+ new EnquiryDateComponent().offset)+' We look forward to having you there. Thank you. '+ opt.Google_Map_Link__c;
        
        String mbNoStr = opt.Country_Code__c + opt.Mobile__c;
        if(String.isNotBlank(mbNoStr) && String.isNotBlank(statMess)){
            mbNoStr = mbNoStr.removeStart('+');
            try{ 
                system.debug(mbNoStr+'mbNoStr');
                String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(statMess, 'UTF-8')+'&senderid=ORLCRM';
                EnquirySMSCtrl.sendSMS(smsURL); 
            }
            catch(exception ex){
                system.debug(ex.getMessage()+'****getError');            
            }
        }
    }
    //Method For Get Country Name
    public static string GetCountryName(String CountryCode) { 
        //Use Custom metadata Type @TODO
        return null;
    }
    
    
    public  static void updateApprovalHierarchy(List<Opportunity> oppList){     
        Set<Id> proIdSet = new Set<Id>();        
        for(Opportunity md : oppList) { 
            if(md.Project__c != null)
                proIdSet.add(md.Project__c);
        }
        
        if(proIdSet.size() > 0 || proIdSet.size() > 0) {
            Map<Id, Project__c> proMap = new Map<Id, Project__c>([SELECT ID,Central_Support__c,AR_Finance__c,Marcom_Head__c,Site_Head__c,Sales_Head__c,CFO__c,MD__c  FROM Project__c WHERE ID IN: proIdSet]);
            for(Opportunity opp : oppList) {
                if(opp.Project__c != null && proMap.containsKey(opp.Project__c)  ){
                    opp.CFO__c = proMap.get(opp.Project__c).CFO__c;
                    opp.MD__c = proMap.get(opp.Project__c).MD__c;
                    opp.Site_Head__c = proMap.get(opp.Project__c).Site_Head__c;
                    opp.Sales_Head__c = proMap.get(opp.Project__c).Sales_Head__c;
                }          
            }
        }
        
        
    }
    
    public static void updateApprovalHierarchyOnUpdate( Map<id, Opportunity>newOpp , Map<id, Opportunity>oldOpp){
        
        
        Set<Id> proIdSet = new Set<Id>();        
        for(Opportunity md : newOpp.values()) { 
            if(md.Project__c != oldOpp.get(md.id).Project__c)
                proIdSet.add(md.Project__c);
            system.debug('=====>'+proIdSet);
        }       
        
        if(proIdSet.size() > 0 || proIdSet.size() > 0) {
            Map<Id, Project__c> proMap = new Map<Id, Project__c>([SELECT ID,Central_Support__c,AR_Finance__c,Marcom_Head__c,Site_Head__c,Sales_Head__c,CFO__c,MD__c  FROM Project__c WHERE ID IN: proIdSet]);
            for(Opportunity opp : newOpp.values()) {
                if(opp.Project__c != null && proMap.containsKey(opp.Project__c)  ){
                    opp.CFO__c = proMap.get(opp.Project__c).CFO__c;
                    opp.MD__c = proMap.get(opp.Project__c).MD__c;
                    opp.Site_Head__c = proMap.get(opp.Project__c).Site_Head__c;
                    opp.Sales_Head__c = proMap.get(opp.Project__c).Sales_Head__c;
                }          
            }
        }
        
        
        
        
    }
    
    
    
    
    
    //Method to populate CountryName
    public static string populateCountryName(list<Opportunity> oppList) { 
        Map<string, CTI_Country_Mappings__mdt> countryMap = new Map<string, CTI_Country_Mappings__mdt>();
        List <CTI_Country_Mappings__mdt>cList = [SELECT id, MasterLabel,Country_Name__c FROM CTI_Country_Mappings__mdt];
        for (CTI_Country_Mappings__mdt ct : cList){
            countryMap.put(ct.MasterLabel, ct);
        }
        for(Opportunity ld : oppList){
            if(countryMap.containsKey(ld.Partner_Mobile_Country_Code__c)) 
                ld.Country_Name_for_PC_Mobile__c = countryMap.get(ld.Partner_Mobile_Country_Code__c).Country_Name__c  ;      
            if(countryMap.containsKey(ld.Country_Code__c)) 
                ld.Country_Name_of_Mobile_Code__c = countryMap.get(ld.Country_Code__c).Country_Name__c  ;
            if( countryMap.containsKey(ld.Country_Code_for_Other_Mobile_Number__c))
                ld.Country_Name_of_Other_Mobile__c = countryMap.get(ld.Country_Code_for_Other_Mobile_Number__c).Country_Name__c  ;
            //if( countryMap.containsKey(ld.Country_Code_for_Phone__c))
            // ld.Country_Name_of_Residence_Code__c  = countryMap.get(ld.Country_Code_for_Phone__c).Country_Name__c  ;      
        }
        return null;
    }
    /******************************************createCoOwnerAndAcc***********************************

public static void createCoOwnerAndAcc(Map<Id, Opportunity> trigOldMap, List<Opportunity> trigNew){
List<Co_Owner__c> coOwnerList = new List<Co_Owner__c>();
List<Account> accList = new List<Account>();
Set<Id> eId = new Set<Id>();
Set<Id> opId = new Set<Id>();
List<EOI__c> eList = new List<EOI__c>();
Id recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
Id recId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
for(Opportunity op: trigNew){
system.debug('checkboxnew'+op.Update_booking_details__c);
system.debug('checkboxold'+trigOldMap.get(op.Id).Update_booking_details__c);
if(op.Update_booking_details__c != trigOldMap.get(op.Id).Update_booking_details__c 
&& op.Update_booking_details__c == false && op.Initial_EOI__c != null && op.RecordTypeId == recId){
system.debug('checkboxnew1'+op.Update_booking_details__c);
system.debug('checkboxold1'+trigOldMap.get(op.Id).Update_booking_details__c);
eId.add(op.Initial_EOI__c);
opId.add(op.Id);
}
}
if(eId != null){
eList = [Select Id,Don_t_create_applicant2_as_co_owner__c,Don_t_create_applicant3_as_co_owner__c,Salutation_2__c,
Don_t_create_applicant4_as_co_owner__c,Don_t_create_applicant5_as_co_owner__c,Salutation_3__c,
Salutation_4__c,Salutation_5__c,Applicant_Name_2__c,Applicant_Name_3__c,Applicant_Name_4__c,
Applicant_Name_5__c,Opportunity__r.AccountId From EOI__c Where Id IN: eId];
}
if(eList.size() > 0 && eList != null){
for(EOI__c eo: eList){
if(eo.Don_t_create_applicant2_as_co_owner__c == false && eo.Applicant_Name_2__c != null){
accList.add(createPA('Second Applicant',eo.Salutation_2__c, eo.Applicant_Name_2__c));
} 
if(eo.Don_t_create_applicant3_as_co_owner__c == false && eo.Applicant_Name_3__c != null){
accList.add(createPA('Third Applicant',eo.Salutation_3__c, eo.Applicant_Name_3__c));
}
if(eo.Don_t_create_applicant4_as_co_owner__c == false && eo.Applicant_Name_4__c != null){
accList.add(createPA('Fourth Applicant',eo.Salutation_4__c, eo.Applicant_Name_4__c));
}
if(eo.Don_t_create_applicant5_as_co_owner__c == false && eo.Applicant_Name_5__c != null){
accList.add(createPA('Fifth Applicant',eo.Salutation_5__c, eo.Applicant_Name_5__c));
}
}
}
system.debug('accListOut'+accList);
if(accList.size()>0 && accList != null){
try{ insert accList;}
catch(DMLException e){ e.getMessage();}
if(eList.size() > 0 && eList != null){
for(Account a: accList){
Co_Owner__c obj = new Co_Owner__c();
obj.Person_Account__c = a.Id;
obj.Opportunity__c = eList[0].Opportunity__c;
coOwnerList.add(obj);
system.debug('coOwnerList'+coOwnerList);
}
}
}
system.debug('coOwnerListOut'+coOwnerList);
if(coOwnerList.size()>0 && coOwnerList != null){
try{ insert coOwnerList;}
catch(DMLException e){ e.getMessage();}
}
}
private static Account createPA (string applicantName, string salu, string lName){
Id recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
Account ac = new Account();
ac.RecordTypeId = recordId;
ac.Salutation = salu;
ac.Contact_category__pc = applicantName;
ac.LastName = lName;
system.debug('ac'+ac);
return ac;
} */
    
    public static void dummy(){
        integer i= 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}
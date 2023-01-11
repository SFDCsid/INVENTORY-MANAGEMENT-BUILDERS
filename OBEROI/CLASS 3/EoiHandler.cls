public class EoiHandler {
    public static void CreateAccountandTagEoi(List<EOI__c> eList){
        System.debug('Inside CreateAccountandTagEoi methode');
        Map<EOI__c,Account> eoiAccountMap = new Map<EOI__c,Account>();
        Map<EOI__c,Lead> eoiLeadMap = new Map<EOI__c,Lead>();
        Id recordId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        List<Opportunity> optyList = new List<Opportunity>();
        Map<EOI__c,Opportunity> tagEoiOptyMap = new Map<EOI__c,Opportunity>();
        List<Id> eoiIdList = new List<Id>();
        
        for(EOI__c l:eList){
            Lead le = new Lead();
            //le.Site__c = l.Project__r.Site__c;      //did changes on 1 Dec 2022
            le.Project__c = l.Project__r.Id;        //did changes on 1 Dec 2022
            le.LastName = l.Applicant_Name_1__c;
            le.Company = l.Project__r.Name +' - '+ l.Project__r.Site__c;
            le.MobilePhone = l.Mobile_No_1__c;
            le.Email = l.Email__c;
            le.Status = 'Open';
            le.Lead_Stage__c = 'Open';
            le.Data_Sheet_Submitted__c = true;
            le.Data_Sheet_Submitted_Date__c = system.today();
            le.EOI_URL__c = l.EOI_URL__c;
            le.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
            //   le.EOI__c = l.Id;
            
            System.debug(' lead -- ' + le);
            eoiLeadMap.put(l,le);
            
            Account ac = new Account();
            ac.Salutation = l.Salutation_1__c;
            ac.LastName = l.Applicant_Name_1__c ;
            ac.PersonMobilePhone = l.Mobile_No_1__c;
            ac.personEmail = l.Email__c;
            ac.City__c = l.City__c;
            ac.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            List<Account> accList1 = new List<Account>();
            accList1.add(ac);
            eoiAccountMap.put(l,ac);
        }
        insert eoiAccountMap.values();
        insert eoiLeadMap.values();
        System.debug('eoiAccountMap==>'+eoiAccountMap);
        
        for(EOI__c l:eoiAccountMap.keyset()){
            eoiIdList.add(l.Id);
        }
        
        for(EOI__c l:eoiAccountMap.keyset()){
            Opportunity op = new Opportunity();
            op.Name = l.Salutation_1__c + ' ' +l.Applicant_Name_1__c ;
            op.StageName = 'New';  
            op.CloseDate = System.today()+60;
            op.RecordTypeId = recordId;
            op.Project__c = l.project__c;
            op.IsOptyCreatedByEOI__c = true;
            if (eoiAccountMap.containsKey(l)) {
                Account acc = new Account();
                acc = eoiAccountMap.get(l);
                if(acc != NULL){
                    op.AccountId = acc.id;
                }
            }
            op.Site__c = l.Project__r.Site__c;
            tagEoiOptyMap.put(l,op);
        }
        insert tagEoiOptyMap.values();
        System.debug('Insert Inside tagEoiOptyMap methode');
        
        for(EOI__c e:tagEoiOptyMap.keyset()){
            
            if (tagEoiOptyMap.containsKey(e)) {
                Opportunity opty = tagEoiOptyMap.get(e);
                Lead le = eoiLeadMap.get(e);
                if(opty != NULL){
                    Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(le.id);
                    lc.ConvertedStatus = 'Converted to Opportunity';
                    lc.accountid = opty.AccountId;
                    lc.opportunityid = opty.Id;
                    
                    Database.LeadConvertResult lcr = Database.convertLead(lc);  
                    
                    System.assert( lcr.isSuccess());  
                    System.debug('opty,Id===>'+opty.id);
                    e.Opportunity__c = opty.id;
                    e.EOI_Scenario__c = 'New Lead Created and Converted';
                }
            }
        }
    } 
    
    public static void TagEoi(Map<EOI__c,List<Opportunity>> OptyProjectDupMap){
        System.debug('Inside TagEoi methode');
        List<EOI__c> enqList = new List<EOI__c>();
        List<Opportunity> optyNewList = new List<Opportunity>();
        Map<Opportunity,EOI__c> updateOptyMap = new Map<Opportunity,EOI__c>(); 
        Map<EOI__c,Opportunity> optyNewMap = new Map<EOI__c,Opportunity>(); 
        Id recordId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        
        for(EOI__c l:OptyProjectDupMap.keyset()){                                    // This for loop is for create new opportunity and update eoi
            for(Opportunity op : OptyProjectDupMap.get(l))
                     if(op.StageName != 'New' && op.StageName != 'Follow Up'){                 //if(op.StageName != 'New' || op.StageName != 'Follow Up'){                 //op.StageName == 'Lost' op.Booking__c != null ||                 //op.StageName == 'Lost' op.Booking__c != null ||           
                    Opportunity op1 = new Opportunity();
                    op1.Name =  l.Salutation_1__c + ' ' +l.Applicant_Name_1__c  ;
                    op1.StageName = 'New';  
                    op1.CloseDate = System.today()+60;
                    op1.RecordTypeId = recordId;
                    op1.Project__c = l.project__c;
                    op1.Site__c = l.Project__r.Site__c;
                    op1.IsOptyCreatedByEOI__c = true;
                    op1.AccountId = op.AccountId;
                    op1.Mobile__c = l.Mobile_No_1__c;
                    op1.Email__c = l.Email__c;
                    op1.Initial_EOI__c = l.id;
                    system.debug('l.id'+l.id);
                    optyNewList.add(op1);
                    optyNewMap.put(l,op1);
                    
                }else{
                    system.debug('Inside else');
                    l.Opportunity__c = op.id;
                    l.Account__c = op.AccountId;
                    l.EOI_Scenario__c = 'EOI Tagged';
                    updateOptyMap.put(op,l);
                } 
            enqList.add(l);
            
        }
        
        system.debug('enqList:::::::::'+enqList);
        
        System.debug('start here');
        List<EOI__c> eoiList = new List<EOI__c>();
         List<Opportunity> opList = new List<Opportunity>();
        List<Account> accList = new List<Account>();
        
        for(Opportunity op:updateOptyMap.keyset()){
            
            if (updateOptyMap.containsKey(op)) {
                EOI__c en = new EOI__c();
                en = updateOptyMap.get(op);
                op.IsExistingOpty__c = true;
                opList.add(op);
                accList.add(op.Account);
            }
        }
        system.debug('updateOptyMap:::::::::'+updateOptyMap);
        if(updateOptyMap.size()==0){                           // This if loop is for insert new opportunity and tag to eoi
            insert optyNewList[0];
            System.debug('Insert Inside TagEoi methode');
            system.debug('optyNewList[0]:::::::::'+optyNewList[0]);
        
        
        for(EOI__c l : optyNewMap.keySet()){
            if(l.Project__r.Site__c == optyNewList[0].Site__c){//optyNewMap.get(l). Site__c){ changed by bhagyashri
                Opportunity op = optyNewList[0];//optyNewMap.get(l);
                l.Opportunity__c = op.id;
                l.Account__c = op.AccountId;
                l.EOI_Scenario__c = 'New Opportunity Created';
                updateOptyMap.put(op,l);
                eoiList.add(l);
            }
            
        }
        }
        system.debug('eoiList:::::::::'+eoiList);
        //update eoiList;
        update opList;
        update accList;
    }
    
    public static void CreateOptyANDTagEoi(Map<EOI__c,List<Account>> NoOptyAccountEmailDupMap){
        System.debug('Inside CreateOptyANDTagEoi methode');
        List<Opportunity> optyList = new List<Opportunity>();
        Map<EOI__c,List<Opportunity>> tagEnquiryMap = new Map<EOI__c,List<Opportunity>>();
        Map<EOI__c,Opportunity> tagEoiOptyMap = new Map<EOI__c,Opportunity>();
        Id recordId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        
        for(EOI__c l:NoOptyAccountEmailDupMap.keyset()){
            Opportunity op = new Opportunity();
            op.Name =  l.Salutation_1__c + ' ' +l.Applicant_Name_1__c  ;
            op.StageName = 'New';  
            op.CloseDate = System.today()+60;
            op.RecordTypeId = recordId;
            op.Project__c = l.project__c;
            op.Site__c = l.Project__r.Site__c;
            op.IsOptyCreatedByEOI__c = true;
            op.Mobile__c = l.Mobile_No_1__c;
            op.Email__c = l.Email__c;
            if (NoOptyAccountEmailDupMap.containsKey(l)) {
                List<Account> accList = new List<Account>();
                accList = NoOptyAccountEmailDupMap.get(l);
                if(accList != NULL && accList.size()>0){
                    op.AccountId = accList[0].id;
                    op.Account = accList[0];
                }
            }
            tagEoiOptyMap.put(l,op);
        }
        System.debug('Insert Inside CreateOptyANDTagEoi methode');
        insert tagEoiOptyMap.values();
        
        for(EOI__c e:tagEoiOptyMap.keyset()){
            if (tagEoiOptyMap.containsKey(e)) {
                Opportunity opty = new Opportunity();
                opty = tagEoiOptyMap.get(e);
                if(opty != NULL){
                    System.debug('opty,Id===>'+opty.id);
                    e.Opportunity__c = opty.id;
                    e.EOI_Scenario__c = 'New Opportunity Created';
                }
            }
        }
    }
    
    
  /*  public static void updateLeadEOITags(List<EOI__c> eoiList) {
        Set<String> phoneNs = new Set<String>();
        Set<String> emailIds = new Set<String>();
        Set<String> Sites = new Set<String>();
        Set<EOI__c> eoiSet = new Set<EOI__c>();
        Map<String, EOI__c> matchedEOI = new Map<String, EOI__c>();
        List<Lead> updateLeads = new List<Lead>();
        
        for(EOI__c ei : eoiList){
            eoiSet.add(ei);
        }
        
        for(EOI__c ie : [Select id, Name, Project__r.Name, Email__c, Mobile_No_1__c, Project__r.Site__c from EOI__c where id In: eoiSet ]){
                phoneNs.add(ie.Mobile_No_1__c);
                emailIds.add(ie.Email__c);
                Sites.add(ie.Project__r.Name +' - ' + ie.Project__r.Site__c);
            system.debug('phoneNs  '+ ie.Mobile_No_1__c);
            system.debug('emailIds  '+ ie.Email__c);
            system.debug('Sites  '+ ie.Project__r.Name +' - ' + ie.Project__r.Site__c);
            
            matchedEOI.put(ie.Mobile_No_1__c + ie.Email__c + ie.Project__r.Name +' - ' + ie.Project__r.Site__c , ie);
        }
        
         system.debug('matchedEOI  '+ matchedEOI.Keyset());
        system.debug('matchedEOI  '+ matchedEOI.values().size());
        
        Map<Id, Lead> leadMap = new Map<Id, Lead>([Select id, Name, Company, MobilePhone, Email, Status,EOI__c from Lead 
                                                   where MobilePhone IN: phoneNs AND Email IN: emailIds AND Company IN: Sites]);
        system.debug('leadMap  '+ leadMap.size());
        
        for(Lead le : leadMap.values()){
            String key = le.MobilePhone + le.Email + le.Company;
            System.debug('Key --- ' + key);
            if(matchedEOI.containsKey(key)){
                le.EOI__c = matchedEOI.get(key).id;
                updateLeads.add(le);
            }
            
        }
        
        try{
             update updateLeads;   
        }Catch(Exception e){
            SYstem.debug('EXCEPTION___' + e.getMessage());
        }
        
            
            }*/
}
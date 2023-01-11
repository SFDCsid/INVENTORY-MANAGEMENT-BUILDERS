public class OpportunityHandler1 {
    
     /******************************************createCoOwnerAndAcc************************************/
    
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
    }

}
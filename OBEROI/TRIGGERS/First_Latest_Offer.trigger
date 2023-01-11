trigger First_Latest_Offer on Offer__c (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        List<Offer__c> off = Trigger.New;
        Id oppId = off[0].Opportunity__c;
        List<Offer__c> foffer = new List<Offer__c>();
        foffer = [Select id,name,Opportunity__c from Offer__c where Opportunity__c =: oppId order by CreatedDate ASC];
        List<Offer__c> loffer = new List<Offer__c>();
        loffer = [Select id,name,Opportunity__c from Offer__c where Opportunity__c =: oppId order by CreatedDate DESC];
        List<Opportunity> oppL = [select id, name,First_Offer__c,Latest_offer__c from Opportunity where id =: oppId];
        oppL[0].First_Offer__c = foffer[0].Id;
        oppL[0].Latest_offer__c = loffer[0].Id;
        update oppL;
    }
}
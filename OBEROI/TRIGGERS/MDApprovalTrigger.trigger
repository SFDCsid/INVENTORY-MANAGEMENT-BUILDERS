trigger MDApprovalTrigger on MD_Approval__c (before insert, before update) {
if(trigger.isBefore && (trigger.isInsert || Trigger.isUpdate)) {
        Set<Id> proIdSet = new Set<Id>();
        Set<Id> propIdSet = new Set<Id>();
        list<MD_Approval__c> mdList = new list<MD_Approval__c>();
        list<Id> mdApprovalList = new list<Id>();
       // list<Approval.ProcessSubmitRequest> mdApprovalList = new list<Approval.ProcessSubmitRequest>();
        list<Id> mdApList = new list<Id>();
        for(MD_Approval__c md : trigger.new) {            
            if(md.Project__c != null)
                proIdSet.add(md.Project__c); 
             if(md.Property__c != null)
                propIdSet.add(md.Property__c); 
        }
       
        if(proIdSet.size() > 0 || propIdSet.size() > 0) {
            Map<Id, Project__c> proMap = new Map<Id, Project__c>([SELECT ID,Central_Support__c,AR_Finance__c,Marcom_Head__c,Site_Head__c,Sales_Head__c,CFO__c,MD__c,Marcom_Manager__c  FROM Project__c WHERE ID IN: proIdSet]);
            Map<Id, Property__c> propMap = new Map<Id, Property__c>([SELECT ID,CRM_Lead__c,Original_RM_Name__c,Site_Head__c,CFO__c,MD__c, AR_Finance__c, Central_Support__c  FROM Property__C WHERE ID IN: propIdSet]); 
            
            for(MD_Approval__c md : trigger.new) {
                //(md.Department__c =='Sales' || md.Department__c =='Marcomm' || md.Department__c =='Support')
                if(md.Project__c != null && proMap.containsKey(md.Project__c)  ){
                    md.CFO__c = proMap.get(md.Project__c).CFO__c;
                    md.MD__c = proMap.get(md.Project__c).MD__c;
                    md.Site_Head__c = proMap.get(md.Project__c).Site_Head__c;
                    md.Sales_Head__c = proMap.get(md.Project__c).Sales_Head__c;
                    md.Marcomm_Head__c = proMap.get(md.Project__c).Marcom_Head__c;
                    md.Marcomm_Manager__c = proMap.get(md.Project__c).Marcom_Manager__c;
                    
                } 
                if((md.Department__c =='CRM' || md.Department__c =='Luxury') && md.Property__c != null && propMap.containsKey(md.Property__c) ){
                    md.RM__c = propMap.get(md.Property__c).Original_RM_Name__c;
                    md.CRM_Lead__c = propMap.get(md.Property__c).CRM_Lead__c;
                    md.Verified_By_AR__c = propMap.get(md.Property__c).AR_Finance__c ;
                    md.Verified_By_Support__c = propMap.get(md.Property__c).Central_Support__c ;
                   
                }
                md.Submitter_Name__c = UserInfo.getUserId();
            }
          
        }
    }




}
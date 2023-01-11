trigger CreateCheckListTrig on Case (After Insert,before Insert,before Update,After Update) {
    if(Trigger.isAfter && Trigger.isInsert){
        List<Checklist__c> ClistToinsert = new List<Checklist__c>();
        for(case ca : Trigger.New){
            if(ca.stage__c != '' && ca.stage__c != null && ca.stage__c != 'Close' && ca.stage__c != 'New' &&  ca.stage__c != 'Demand Reminder' && ca.stage__c != 'Confirm Possession schedule' && ca.stage__c != 'RM Verification' && ca.stage__c != 'Finance Verification'){
                
                String CaseRecordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(ca.recordtypeid).getName();
                String caseType = ca.Type;
                Id CheklistReordType;
                If(String.isNotBlank(caseType))
                    CheklistReordType = Schema.SObjectType.Checklist__C.getRecordTypeInfosByName().get(caseType).getRecordTypeId();
                system.debug('caseType::::'+caseType);
                system.debug('CheklistReordType::::'+CheklistReordType);
                If(CheklistReordType != Null){
                    Checklist__c Cl = New Checklist__c();
                    Cl.Recordtypeid = CheklistReordType;
                    Cl.Case__c = ca.id; 
                    Cl.Name = CaseRecordTypeName; 
                    ClistToinsert.add(Cl);
                }
            }            
        }
        Insert ClistToinsert;
    }
    
    if(Trigger.isbefore && Trigger.isUpdate){
        set<id> bookid = new set<id>(); 
        set<id> LProjid = new set<id>();
        List<Case_Owner_Assignment_Matrix__c> COMList = new list<Case_Owner_Assignment_Matrix__c>();
        Set<String> CaseRecordTypeName = New Set<String>();
        Set<String> CaseStage = New Set<String>();
        String Ownerid = '';
        list<case> listToUpdate = new List<case>();
        
        List<Booking__c> booklist = new List<Booking__c>();
        List<Property__c> proplist = new List<Property__c>();
        List<Leasing_Project__c> LProjList = new List<Leasing_Project__c>();
        for(case ca : Trigger.New){
            bookid.add(ca.Booking__c);
            LProjid.add(ca.Leasing_Project__c);
            if(ca.stage__c != trigger.oldmap.get(ca.id).stage__c && ca.stage__c == 'Close' && ca.stage__c != 'New' && ca.stage__c != 'Demand Reminder'){
                ca.status = 'Closed';
            }else{
                CaseRecordTypeName.add(Schema.SObjectType.Case.getRecordTypeInfosById().get(ca.recordtypeid).getName());
                if(ca.stage__c != '' && ca.stage__c != trigger.oldmap.get(ca.id).stage__c && ca.stage__c != 'Close'){
                    CaseStage.add(ca.stage__c);                   
                }
            }
            
            if(ca.Stage__c =='AR Verification' && ca.RecordTypeId=='012p0000000TZ2z' && Trigger.oldmap.get(ca.id).Stage__c=='Finance Verification'){
                List<ContentDocumentLink> files = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId =:ca.id];
                if(files.size()==0){
                    ca.addError( ' Please Uplode Files ');  
                }
            }
            
        }
        System.debug('LProjid'+LProjid);
        booklist = [Select id,Name,RM_User__c,Site_Support__c,Central_Support__c,AR_Support__c,Opportunity__r.OwnerId,Property__r.Finance_Subvention_interest_user__c,Property__r.AR_Subvention_interest_user__c FROM Booking__c Where Id in: bookid Limit 1];
        LProjList = [Select id,name,Leasing_Team__c,Legal_1__c,Leasing_HOD__c,Account_Team__c from Leasing_Project__c where Id in: LProjid Limit 1];
        COMList = [Select id,Name,Case_Stage_Name__c,Case_Stage_Owner__c FROM Case_Owner_Assignment_Matrix__c WHERE Name in: CaseRecordTypeName AND Case_Stage_Name__c in: CaseStage limit 1];
        if(COMList.size()>0){
            if(booklist.size()>0){
                if(COMList[0].Case_Stage_Owner__c == 'RM')
                    Ownerid = booklist[0].RM_User__c;
                if(COMList[0].Case_Stage_Owner__c == 'L1')
                    Ownerid = booklist[0].Site_Support__c;
                if(COMList[0].Case_Stage_Owner__c == 'L2')
                    Ownerid = booklist[0].Central_Support__c;
                if(COMList[0].Case_Stage_Owner__c == 'Account')
                    Ownerid = booklist[0].AR_Support__c;
                if(COMList[0].Case_Stage_Owner__c == 'Sales Manager')
                    Ownerid = booklist[0].Opportunity__r.OwnerId;
                if(COMList[0].Case_Stage_Owner__c == 'Finance')
                    Ownerid = booklist[0].Property__r.Finance_Subvention_interest_user__c;
                if(COMList[0].Case_Stage_Owner__c == 'AR')
                    Ownerid = booklist[0].Property__r.AR_Subvention_interest_user__c;
                
            }
            if(LProjList.size()>0){
                if(COMList[0].Case_Stage_Owner__c == 'Leasing Team')
                    Ownerid = LProjList[0].Leasing_Team__c;
                if(COMList[0].Case_Stage_Owner__c == 'Legal')
                    Ownerid = LProjList[0].Legal_1__c;
                if(COMList[0].Case_Stage_Owner__c == 'Account Team')
                    Ownerid = LProjList[0].Account_Team__c;
                if(COMList[0].Case_Stage_Owner__c == 'Leasing HOD')
                    Ownerid = LProjList[0].Leasing_HOD__c;
            }
            System.debug('Owerner id::::'+Ownerid);
        }
        for(case ca : Trigger.New){
            if(Ownerid != ''){
                Ca.ownerid = Ownerid;
                //listToUpdate.add(ca);
            }Else{}
        }
        //Update listToUpdate;
        
    }
    if(Trigger.isBefore && Trigger.isInsert){
        List<Case> c = Trigger.New;
        if(c[0].Booking__c != Null){
            Id bid = c[0].Booking__c;
            List<Booking__c> bList = [Select id,Name,Central_Support__c,Head_of_Marketing__c,CRM_Lead__c,Sales_Head__c,CFO__c,MD__c FROM Booking__c Where Id =: bid Limit 1];
            c[0].CRM_Lead__c = bList[0].CRM_Lead__c;
            c[0].Sales_Head__c = bList[0].Sales_Head__c;
            c[0].CFO__c = bList[0].CFO__c;
            c[0].MD__c = bList[0].MD__c;
            c[0].Support_Head__c = bList[0].Central_Support__c;
            c[0].Head_of_Marketing__c = bList[0].Head_of_Marketing__c;
        }
        
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        //String profileName = [select Name from profile where id = :UserInfo.getProfileId()].Name;
        for(case ca : Trigger.New){
            If(trigger.oldmap.get(ca.id).stage__c == 'Close'){   //ca.stage__c != trigger.oldmap.get(ca.id).stage__c &&
                ca.addError('This case has been already closed');
            }
            
            /*if(Trigger.oldMap.get(ca.id).ownerid != UserInfo.getUserId() && profileName != 'System Administrator'){
ca.addError('You have no access to edit this Record');
}*/
        }        
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        List<Case> updateC = new List<Case>();
        for(case ca : Trigger.New){
            if(ca.Stage__c == 'Review by client' && ca.Changes_requested__c != trigger.oldmap.get(ca.id).Changes_requested__c && ca.Changes_requested__c == 'Yes'){
                ca.Stage__c = 'Generate Term Sheet';
                ca.Changes_requested__c = '';
            }
            if(ca.Stage__c == 'Review the L&L shared by legal' && ca.Changes_requested__c != trigger.oldmap.get(ca.id).Changes_requested__c && ca.Changes_requested__c == 'Yes'){
                ca.Stage__c = 'Review L&L and other docs by Legal';
                ca.Changes_requested__c = '';
            }
            if(ca.Stage__c == 'Review by brand/client on drafts sent in email' && ca.Changes_requested_2__c != trigger.oldmap.get(ca.id).Changes_requested_2__c && ca.Changes_requested_2__c == 'Yes'){
                ca.Stage__c = 'Prepare the revised drafts and share with legal';
                //ca.Changes_requested_2__c = '';
            }else if(ca.Stage__c == 'Review by brand/client on drafts sent in email' && ca.Changes_requested_2__c != trigger.oldmap.get(ca.id).Changes_requested_2__c && ca.Changes_requested_2__c == 'No'){
                ca.Stage__c = 'Send L&L and other docs hard copy for brand/client signing';
                //ca.Changes_requested_2__c = '';
            }
            /*if(ca.Stage__c == 'Prepare the revised drafts and share with legal' && ca.Changes_requested_3__c != trigger.oldmap.get(ca.id).Changes_requested_3__c && ca.Changes_requested_3__c == 'Yes'){
ca.Stage__c = 'Review L&L and other docs by Legal';
ca.Changes_requested_3__c = '';
}*/
        }
    }
}
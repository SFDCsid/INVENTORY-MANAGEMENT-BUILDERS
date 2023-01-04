public class CustomDuplicationHandlerServices {
    // Declarations Starts here//
        public List<Lead_c__c> duplicateLeadList {get;set;}
        public Map<string,Lead_c__c> newLeadMapByPhone {get;set;}
        public Map<string,list<Lead_c__c>> newLeadMapByAltPhone {get;set;}
        public Map<string,Account> newAccountMapByPhone {get;set;}
        // Declarations ends here ///
    // Custructor starts //
    public CustomDuplicationHandlerServices() {
        duplicateLeadList = new List<Lead_c__c>();
        newLeadMapByPhone = new Map<String,Lead_c__c>();
        newLeadMapByAltPhone = new Map<string,List<Lead_c__c>>();
        newAccountMapByPhone = new Map<string,Account>();
    }
    // Constructor End //
    // Master duplicate calling
    public List<duplicateWrapper> masterduplicateCalling(List<Lead_c__c> leadList)
    {
        List<duplicateWrapper> duplicateLeadList = new List<duplicateWrapper>();
        system.debug(duplicationCheckPhone(leadList));
        duplicateLeadList = duplicationCheckPhone(leadList);
        system.debug(duplicateLeadList);
        if (duplicateLeadList.isEmpty())
        {
            duplicateLeadList = duplicationCheckEmail(leadList);
            system.debug(duplicateLeadList);
        }

        if(!leadList.isEmpty())
        {
            System.debug(duplicateLeadList);
            if(!duplicateLeadList.isEmpty())
            {

                if(leadList[0].Id == duplicateLeadList[0].recordId)
                {
                    //Id removeid = duplicateLeadList[0].recordId;
                    duplicateLeadList.clear();
                }
            }
            System.debug(duplicateLeadList);
        }
        
        return duplicateLeadList;
    }
    // Master Duplicate calling
    // Duplicate Record check
    public List<duplicateWrapper> duplicationCheckPhone(List<Lead_c__c> leadList)
    {
        List<Lead_c__c> duplicateLeadList = new List<Lead_c__c>();
        List<Account> duplicateAccountList = new List<Account>();
        List<duplicateWrapper> duplicateWrapperList = New List<duplicateWrapper>();
        System.debug('In side primary phone number check ::'+leadList);
        for(Lead_c__c leadRecord : leadList)
        {
            if(leadRecord.Mobile__c   != Null)
            {
                newLeadMapByPhone.put(leadRecord.Mobile__c , leadRecord);
                
            } 
            if(leadRecord.Alternate_Mobile_No__c != Null)
            {   
                newLeadMapByPhone.put(leadRecord.Alternate_Mobile_No__c, leadRecord);
            }
        }
        
        System.debug(newLeadMapByPhone);
        
        if(!newLeadMapByPhone.isEmpty())
        {
            duplicateAccountList = [Select id, LastName,PersonMobilePhone,Phone,PersonEmail,Alternate_Email_Id__c from Account 
                                    where (PersonMobilePhone IN: newLeadMapByPhone.keyset() OR Phone IN: newLeadMapByPhone.keyset())];
            
        }

        if(!duplicateAccountList.isEmpty())
        {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
                for(Account dupeAcc:duplicateAccountList)
                {
                
                    duplicateWrapper dw = new duplicateWrapper();
                    dw.name = dupeAcc.LastName;
                    dw.recordId = dupeAcc.Id;
                    tempWrapper.add(dw);
                }
            duplicateWrapperList.addAll(tempWrapper);
        }

        
        else {
            duplicateLeadList = [select id, Name, Mobile__c,ownerId from Lead_c__c
                            where (Mobile__c IN: newLeadMapByPhone.keyset() OR Alternate_Mobile_No__c IN: newLeadMapByPhone.keyset())];
            System.debug('Duplicate Lead Record found :: '+ duplicateLeadList);
        }

        if (!duplicateLeadList.isEmpty())
        {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
                for(Lead_c__c dupeLead:duplicateLeadList)
                {
                
                    duplicateWrapper dw = new duplicateWrapper();
                    dw.name= dupeLead.Name;
                    dw.recordId = dupeLead.Id;
                    if(dupeLead.Id != leadList[0].id)
                        tempWrapper.add(dw);
                }
                
            duplicateWrapperList.addAll(tempWrapper);
            
        }
        
        system.debug(duplicateWrapperList);
        return duplicateWrapperList;
    }
    // Duplicate check on email ////
    public List<duplicateWrapper> duplicationCheckEmail(List<Lead_c__c> leadList)
    {
        List<Lead_c__c> duplicateLeadList = new List<Lead_c__c>();
        List<Account> duplicateAccountList = new List<Account>();
        List<duplicateWrapper> duplicateWrapperList = New List<duplicateWrapper>();
        System.debug('In side primary phone number check ::'+leadList);
        for(Lead_c__c leadRecord : leadList)
        {
            if(leadRecord.Email__c != Null)
            {
                newLeadMapByPhone.put(leadRecord.Email__c, leadRecord);
            }

            if(leadRecord.Alternate_Email_Id__c != Null)
            {
                newLeadMapByPhone.put(leadRecord.Alternate_Email_Id__c, leadRecord);
            }
        }
        
        System.debug(newLeadMapByPhone);
        
        if(!newLeadMapByPhone.isEmpty())
        {
            duplicateAccountList = [Select id, LastName,PersonMobilePhone,Phone,PersonEmail,Alternate_Email_Id__c from Account 
                                    where (PersonEmail IN: newLeadMapByPhone.keyset() OR Alternate_Email_Id__c IN: newLeadMapByPhone.keyset())];
            
        }
        if(!duplicateAccountList.isEmpty())
        {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
                for(Account dupeAcc:duplicateAccountList)
                {
                
                    duplicateWrapper dw = new duplicateWrapper();
                    dw.name = dupeAcc.LastName;
                    dw.recordId = dupeAcc.Id;
                    tempWrapper.add(dw);
                }
            duplicateWrapperList.addAll(tempWrapper);
        }
        
        else {
            duplicateLeadList = [select id, Name, Email__c, Mobile__c,Alternate_Mobile_No__c,ownerId 
                                from Lead_c__c
                                where (Email__c IN: newLeadMapByPhone.keyset() OR Alternate_Email_Id__c IN: newLeadMapByPhone.keyset())];
            System.debug('Duplicate Lead Record found :: '+ duplicateLeadList);
        }

        if (!duplicateLeadList.isEmpty())
        {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
                for(Lead_c__c dupeLead:duplicateLeadList)
                {
                    
                    duplicateWrapper dw = new duplicateWrapper();
                    dw.name = dupeLead.Name;
                    dw.recordId = dupeLead.Id;
                    if(dupeLead.Id != leadList[0].id)
                    tempWrapper.add(dw);
                }
            duplicateWrapperList.addAll(tempWrapper);
            
        }
        //duplicateWrapperList.addAll(tempWrapper);
        system.debug(duplicateWrapperList);
        return duplicateWrapperList;

    }

    //Master method for account insert update duplicate check
    public List<duplicateWrapper> accountMasterduplicateCalling(List<Account> accountList)
    {
        List<duplicateWrapper> duplicateAccountList = new List<duplicateWrapper>();
        system.debug(accountDuplicationCheckPhone(accountList));
        duplicateAccountList = accountDuplicationCheckPhone(accountList);
        system.debug(duplicateAccountList);
        if (duplicateAccountList.isEmpty())
        {
            duplicateAccountList = accountDuplicationCheckEmail(accountList);
            system.debug(duplicateAccountList);
        }

        /*if(!accountList.isEmpty())
        {
            System.debug(duplicateAccountList);
            if(!duplicateAccountList.isEmpty())
            {

                if(accountList[0].Id == duplicateAccountList[0].recordId)
                {
                    //Id removeid = duplicateAccountList[0].recordId;
                    duplicateAccountList.clear();
                }
            }
            System.debug(duplicateAccountList);
        }*/
        
        return duplicateAccountList;
    }
// Duplicate check on Phone ////
    public List<duplicateWrapper> accountDuplicationCheckPhone(List<Account> accountList)
    {
        List<Lead_c__c> duplicateLeadList = new List<Lead_c__c>();
        List<Account> duplicateAccountList = new List<Account>();
        List<duplicateWrapper> duplicateWrapperList = New List<duplicateWrapper>();
        System.debug('In side primary phone number check ::'+accountList);
        for(Account accountRecord : accountList)
        {
            if(accountRecord.PersonMobilePhone != Null)
            {
                newAccountMapByPhone.put(accountRecord.PersonMobilePhone, accountRecord);
            }

            if(accountRecord.Phone != Null)
            {
                newAccountMapByPhone.put(accountRecord.Phone, accountRecord);
            }
        }
        
        System.debug(newAccountMapByPhone);
        
        if(!newAccountMapByPhone.isEmpty())
        {
            duplicateLeadList = [select id, Name, Email__c, Mobile__c,Last_Name__c,Alternate_Mobile_No__c,Alternate_Email_Id__c,ownerId
                                from Lead_c__c
                                where (Mobile__c IN: newAccountMapByPhone.keyset() OR Alternate_Mobile_No__c IN: newAccountMapByPhone.keyset())];
            System.debug('Duplicate Lead Record found :: '+ duplicateLeadList);
            }
        if (!duplicateLeadList.isEmpty())
        {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
                for(Lead_c__c dupeLead:duplicateLeadList)
                {
                
                    duplicateWrapper dw = new duplicateWrapper();
                    dw.Name= dupeLead.Last_Name__c ;
                    dw.recordId = dupeLead.Id;
                    tempWrapper.add(dw);
                }
            duplicateWrapperList.addAll(tempWrapper);
            
        }
        
        else {
            duplicateAccountList = [Select id, LastName,PersonMobilePhone,Phone,PersonEmail,Alternate_Email_Id__c 
                                    from Account 
                                    where (PersonMobilePhone IN: newAccountMapByPhone.keyset() OR Phone IN: newAccountMapByPhone.keyset())];
        }
        system.debug('Duplicate Wrapper List::: '+ duplicateWrapperList);
        if(!duplicateAccountList.isEmpty())
        {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
                for(Account dupeAcc:duplicateAccountList)
                {
                
                    duplicateWrapper dw = new duplicateWrapper();
                    dw.name = dupeAcc.LastName;
                    dw.recordId = dupeAcc.Id;
                    if(dupeAcc.Id != accountList[0].id)
                        tempWrapper.add(dw);
                }
            duplicateWrapperList.addAll(tempWrapper);
        }
        
        
        //duplicateWrapperList.addAll(tempWrapper);
        system.debug(duplicateWrapperList);
        return duplicateWrapperList;

    }
    // Duplicate check on email ////
    public List<duplicateWrapper> accountDuplicationCheckEmail(List<Account> accountList)
    {
        List<Lead_c__c> duplicateLeadList = new List<Lead_c__c>();
        List<Account> duplicateAccountList = new List<Account>();
        List<duplicateWrapper> duplicateWrapperList = New List<duplicateWrapper>();
        System.debug('In side primary Phone check ::'+accountList);
        for(Account accountRecord : accountList)
        {
            if(accountRecord.PersonEmail != Null)
            {
                newAccountMapByPhone.put(accountRecord.PersonEmail, accountRecord);
            }

            if(accountRecord.Alternate_Email_Id__c != Null)
            {
                newAccountMapByPhone.put(accountRecord.Alternate_Email_Id__c, accountRecord);
            }
        }
        
        System.debug(newAccountMapByPhone);
        
        if(!newAccountMapByPhone.isEmpty())
        {
            duplicateLeadList = [select id, Name, Email__c,Last_Name__c, Mobile__c,Alternate_Mobile_No__c,ownerId
                                from Lead_c__c
                                where (Email__c IN: newAccountMapByPhone.keyset() OR Alternate_Email_Id__c IN: newAccountMapByPhone.keyset())];
            System.debug('Duplicate Lead Record found :: '+ duplicateLeadList);
        }
        
        if (!duplicateLeadList.isEmpty())
        {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
                for(Lead_c__c dupeLead:duplicateLeadList)
                {
                
                    duplicateWrapper dw = new duplicateWrapper();
                    dw.Name = dupeLead.Last_Name__c;
                    dw.recordId = dupeLead.Id;
                    tempWrapper.add(dw);
                }
            duplicateWrapperList.addAll(tempWrapper);
            
        }
        
        
        else {
            duplicateAccountList = [Select id, LastName,PersonMobilePhone,Phone,PersonEmail,Alternate_Email_Id__c 
                                    from Account 
                                    where (PersonEmail IN: newAccountMapByPhone.keyset() OR Alternate_Email_Id__c IN: newAccountMapByPhone.keyset())];
        }
        
        if(!duplicateAccountList.isEmpty())
        {
            List<duplicateWrapper> tempWrapper = new List<duplicateWrapper>();
                for(Account dupeAcc:duplicateAccountList)
                {
                
                    duplicateWrapper dw = new duplicateWrapper();
                    dw.name = dupeAcc.LastName;
                    dw.recordId = dupeAcc.Id;
                    if(dupeAcc.Id != accountList[0].Id)
                        tempWrapper.add(dw);
                }
            duplicateWrapperList.addAll(tempWrapper);
        }

        //duplicateWrapperList.addAll(tempWrapper);
        system.debug(duplicateWrapperList);
        return duplicateWrapperList;

    }
    
    // Wrapper for duplicate information
    public class duplicateWrapper
    {
        public string name;
        public id recordId;
    }
      
}
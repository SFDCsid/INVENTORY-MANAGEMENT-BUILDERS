/*
*Author: Vivek S
*Date: 25/02/2019
*Description: Domain Layer methods for SOQL/DML operations
*/ 
//TODO: add method headers
public virtual class ORL_CustomerDomain{

public static final string CONTACTSTR = 'Contact';
public static final string ACCOUNTSTR = 'Account';
public static final string OPPTYSTR = 'Opportunity';
public static final string CONTRACTSTR = 'Contract';
public static final string BOOKING = 'Booking__c';
public static final string APPLICANT = 'Applicant__c';

public virtual list<Booking__c> retrieveBookingByIds(List<string> idSet){
    
    list<Booking__c> bookLst = new list<Booking__c>();
    try{
       String qry = ORL_Util.buildQueryWithReference(BOOKING,'Opportunity__r.Distribution_channel__c')+' Where id IN: idSet'; 
       Logger.logDebug(qry);
       bookLst = Database.Query(qry);
       Logger.logDebug(string.valueOf(bookLst));
    }catch(Exception ex){
       Logger.logDebug('ORL_CustomerDomain:'+ex.getMessage());
    }   
    
    return bookLst;
}

public virtual list<Contract> retrieveContractByIds(List<string> idSet){
    
    list<Contract> conLst = new list<Contract>();
    try{
       String qry = ORL_Util.buildQueryWithReference(CONTRACTSTR,'Opportunity__r.Distribution_channel__c')+' Where id IN: idSet'; 
       Logger.logDebug(qry);
       conLst = Database.Query(qry);
       Logger.logDebug(string.valueOf(conLst));

    }catch(Exception ex){
       Logger.logDebug('ORL_CustomerDomain:'+ex.getMessage());
    }   
    
    return conLst;
}

public virtual list<Applicant__c> retrieveApplicantsByBookingId(id bookId){
    
    list<Applicant__c> applLst = new list<Applicant__c>();
    try{
       String qry = ORL_Util.buildQuery(APPLICANT)+' Where Booking__c =: bookId'; 
       Logger.logDebug(qry);
       applLst = Database.Query(qry);
       Logger.logDebug(string.valueOf(applLst));

    }catch(Exception ex){
       Logger.logDebug('ORL_CustomerDomain:'+ex.getMessage());
    }   
    
    return applLst;
}

public virtual list<Applicant__c> retrieveApplicantsByContractId(id bookId){
    
    list<Applicant__c> applLst = new list<Applicant__c>();
    try{
       String qry = ORL_Util.buildQuery(APPLICANT)+' Where Contract__c =: bookId'; 
       Logger.logDebug(qry);
       applLst = Database.Query(qry);
       Logger.logDebug(string.valueOf(applLst));

    }catch(Exception ex){
       Logger.logDebug('ORL_CustomerDomain:'+ex.getMessage());
    }   
    
    return applLst;
}

///*************************************************Start: DML Operations*************************************//
//update Booking Records
public virtual void amendBooking(list<Booking__c> bookLst){
    try{
       Database.update(bookLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_CustomerDomain:'+ex.getMessage());
       throw ex;
    }   
}//amendBooking

//update Booking Records
public virtual void amendContracts(list<Contract> bookLst){
    try{
       Database.update(bookLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_CustomerDomain:'+ex.getMessage());
       throw ex;
    }   
}//amendContracts

///*************************************************End: DML Operations*************************************//


}//ORL_CustomerDomain
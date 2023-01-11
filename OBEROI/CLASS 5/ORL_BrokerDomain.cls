/*
*Author: Aditya Bhasin
*Date: 14/03/2019
*Description: Domain Layer methods for SOQL/DML operations
*/ 
//TODO: add method headers
public virtual class ORL_BrokerDomain{

public static final string BROKER = 'Vendor__c';


///*************************************************Start: DML Operations*************************************//
//insert Broker Records
public virtual void insertBroker(list<Vendor__c> brLst){
    try{
       Database.insert(brLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_BrokerDomain:'+ex.getMessage());
    }   
}

//update Payment Plan Records
public virtual void updateBroker(list<Vendor__c> brLst){
    try{
       Database.update(brLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_BrokerDomain:'+ex.getMessage());
    }   
}
///*************************************************End: DML Operations*************************************//



}
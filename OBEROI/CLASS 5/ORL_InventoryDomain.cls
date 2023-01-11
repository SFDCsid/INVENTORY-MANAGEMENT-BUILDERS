/*
*Author: Vivek S
*Date: 28/01/2019
*Description: Domain Layer methods for SOQL/DML operations
*/ 
//TODO: add method headers
public virtual class ORL_InventoryDomain{

public list<Property_Type__c> propertyTypeLst = new list<Property_Type__c>();
public list<Property__c> propertyLst = new list<Property__c>();
public map<string,Property_Type__c> propertyTypeSAPMap = new map<string,Property_Type__c>();
public map<string,Property__c> propertySAPMap = new map<string,Property__c>();
public map<string, Project__c> projectCodeMap = new map<string, Project__c>();
public map<string,Property__c> rentalPropertyMap = new map<string,Property__c>();

public static final string PROPERTYTYPE = 'Property_Type__c';
public static final string PROPERTY = 'Property__c';
public static final string PROJECT = 'Project__c';
public static final string TOWER = 'Tower__c';

//SOQL to retrieve Property Types Records
public virtual list<Property_Type__c> retrievePropTypeByIds(List<string> idSet){

    try{
       String qry = ORL_Util.buildQuery(PROPERTYTYPE)+' Where id IN: idSet'; 
       Logger.logDebug(qry);
       propertyTypeLst = Database.Query(qry);
       Logger.logDebug(string.valueOf(propertyTypeLst));

    }catch(Exception ex){
       Logger.logDebug('ORL_InventoryDomain:'+ex.getMessage());
    }   
    
    return propertyTypeLst;

}//retrievePropTypeByIds

//SOQL to retrieve Property Records
public virtual list<Property__c> retrievePropByIds(List<string> idSet){

    try{
       
       String qry = ORL_Util.buildQuery(PROPERTY)+' Where id IN: idSet'; 
       Logger.logDebug(qry);
       propertyLst = Database.Query(qry);
       Logger.logDebug(string.valueOf(propertyLst));

    }catch(Exception ex){
       Logger.logDebug('ORL_InventoryDomain:'+ex.getMessage());
    }   
    
    return propertyLst;

}//retrievePropByIds

//SOQL to retrieve Property Types Records using SAP id
public virtual map<string,Property_Type__c> retrievePropTypeBySAPIds(List<string> idSet){

    try{
       
       String qry = ORL_Util.buildQuery(PROPERTYTYPE)+' Where Material_No__c IN: idSet'; 
       Logger.logDebug(qry);
       list<Property_Type__c> propertyTypeLstV2 = Database.Query(qry);
       
       if(propertyTypeLstV2 != NULL){
         Logger.logDebug(string.valueOf(propertyTypeLstV2));
         for(Property_Type__c ptyObj: propertyTypeLstV2){
            propertyTypeSAPMap.put(ptyObj.Material_No__c,ptyObj); 
         }
       }
       Logger.logDebug(string.valueOf(propertyTypeSAPMap));

    }catch(Exception ex){
       Logger.logDebug('ORL_InventoryDomain:'+ex.getMessage());
    }   
    
    return propertyTypeSAPMap;

}//retrievePropTypeBySAPIds

//SOQL to retrieve Property Records using SAP id
public virtual map<string,Property__c> retrievePropBySAPIds(List<string> idSet){

    try{
       
       String qry = ORL_Util.buildQuery(PROPERTY)+' Where Material_No__c IN: idSet'; 
       Logger.logDebug(qry);
       list<Property__c> propertyLstV2 = Database.Query(qry);
       
       if(propertyLstV2 != NULL){
         Logger.logDebug(string.valueOf(propertyLstV2));
         for(Property__c ptyObj: propertyLstV2){
            propertySAPMap.put(ptyObj.Material_No__c,ptyObj); 
         }
       }
       Logger.logDebug(string.valueOf(propertySAPMap));

    }catch(Exception ex){
       Logger.logDebug('ORL_InventoryDomain:'+ex.getMessage());
    }   
    
    return propertySAPMap;

}//retrievePropBySAPIds

//SOQL to retrieve Property Records using SAP id
public virtual map<string,Property__c> retrieveRentalPropBySAPIds(List<string> idSet){

    try{
       
       String qry = ORL_Util.buildQuery(PROPERTY)+' Where Number_of_Rental_Unit__c IN: idSet'; 
       Logger.logDebug(qry);
       list<Property__c> propertyLstV2 = Database.Query(qry);
       
       if(propertyLstV2 != NULL){
         Logger.logDebug(string.valueOf(propertyLstV2));
         for(Property__c ptyObj: propertyLstV2){
            rentalPropertyMap.put(ptyObj.Number_of_Rental_Unit__c,ptyObj); 
         }
       }
       Logger.logDebug(string.valueOf(rentalPropertyMap));

    }catch(Exception ex){
       Logger.logDebug('ORL_InventoryDomain:'+ex.getMessage());
    }   
    
    return rentalPropertyMap;

}//retrievePropBySAPIds


//SOQL to retrieve Project records referring Project code
public virtual map<string, Project__c> retrieveProjectBySAPCodes(list<string> codesLst){

    try{
       String qry = ORL_Util.buildQuery(PROJECT)+' Where SAP_Project_Code__c IN: codesLst'; 
       Logger.logDebug(qry);
       list<Project__c> projectLstV2 = Database.Query(qry);
       
       if(projectLstV2 != NULL){
         Logger.logDebug(string.valueOf(projectLstV2));
         for(Project__c ptyObj: projectLstV2){
            projectCodeMap.put(ptyObj.SAP_Project_Code__c,ptyObj); 
         }
       }
       Logger.logDebug(string.valueOf(projectCodeMap));

    }catch(Exception ex){
       Logger.logDebug(ex.getMessage());
    }   

return projectCodeMap;

}

//SOQL to retrieve Project records referring Plant code
public virtual map<string, Project__c> retrieveProjectByPlant(list<string> codesLst){

    try{
       String qry = ORL_Util.buildQuery(PROJECT)+' Where Plant__c IN: codesLst'; 
       Logger.logDebug(qry);
       list<Project__c> projectLstV2 = Database.Query(qry);
       
       if(projectLstV2 != NULL){
         Logger.logDebug(string.valueOf(projectLstV2));
         for(Project__c ptyObj: projectLstV2){
            projectCodeMap.put(ptyObj.Plant__c,ptyObj); 
         }
       }
       Logger.logDebug('Returning Project from Domain:'+string.valueOf(projectCodeMap));

    }catch(Exception ex){
       Logger.logDebug(ex.getMessage());
    }   

return projectCodeMap;

}

//SOQL to retrieve Tower records referring code
public virtual map<string,map<string,Tower__c>> retrieveTowerByName(list<string> codesLst, list<string> plntCodes){
    map<string,map<string,Tower__c>> towerMap = new map<string,map<string,Tower__c>>();
    try{
       String qry = ORL_Util.buildQueryWithReference(TOWER,'Project_Name__r.Plant__c,Project_Name__r.Id')+' Where Tower_Name__c IN: codesLst AND Project_Name__r.Plant__c IN: plntCodes'; 
       Logger.logDebug(qry);
       list<Tower__c> towerLstV2 = Database.Query(qry);
       if(towerLstV2 != NULL){
         Logger.logDebug(string.valueOf(towerLstV2));
         for(Tower__c ptyObj: towerLstV2){
            if(!towerMap.containsKey(ptyObj.Project_Name__r.Plant__c)){
               towerMap.put(ptyObj.Project_Name__r.Plant__c, new map<string,Tower__c>());  
            }
            towerMap.get(ptyObj.Project_Name__r.Plant__c).put(ptyObj.Tower_Name__c,ptyObj);  
         }
       }
       Logger.logDebug('Returning Tower from Domain:'+string.valueOf(towerMap));

    }catch(Exception ex){
       Logger.logDebug(ex.getMessage());
    }   

return towerMap;

}

///*************************************************Start: DML Operations*************************************//
//insert property type Records
public virtual void insertPropertyTypes(list<Property_Type__c> propTypeLst){
    try{
       Database.insert(propTypeLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_InventoryDomain:'+ex.getMessage());
    }   
}//insertPropertyTypes

//insert property Records
public virtual void insertProperties(list<Property__c> propLst){
    try{
        Database.insert(propLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_InventoryDomain:'+ex.getMessage());
       throw ex;
    }   
}//insertProperties

//update property type Records
public virtual void amendPropertyTypes(list<Property_Type__c> propTypeLst){
    try{
       Database.update(propTypeLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_InventoryDomain:'+ex.getMessage());
    }   
}//amendPropertyTypes

//update property Records
public virtual void amendProperties(list<Property__c> propLst){
    try{
        Database.update(propLst);
    }catch(Exception ex){
       Logger.logDebug('ORL_InventoryDomain:'+ex.getMessage());
       throw ex;
    }   
}//amendProperties
///*************************************************End: DML Operations*************************************//

}//ORL_InventoryDomain
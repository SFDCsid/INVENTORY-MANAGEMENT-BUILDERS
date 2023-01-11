/*
*  Author: Vivek S
*  Description: Controller Class for the Property Trigger
*  Change Log: Created-15022019
*/
public class ORL_PropertyTriggerHandler {
    
    public static void onBeforeInsert(List<Property__c> propList) {    
        //Logic on Before Insert
    }
    
    public static void onBeforeUpdate(List<Property__c> propList, map<id,Property__c> oldPropMap) {    
        //Call methods from integration layer to push records to SAP
        list<string> invIds = new list<string>();
        Set<string> stPropIds = new Set<string>();
        Map<Id,Id> mapUserRec = new Map<Id,Id>();
        Map<Id,Property__c> mapProprec = new Map<Id,Property__c>();
        Id recTypeId = Schema.SObjectType.Property__c.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
        for(Property__c pObj: propList){
            if(pObj.Move_to_SAP__c && !oldPropMap.get(pObj.Id).Move_to_SAP__c){
                invIds.add(pObj.Id);
                pObj.Move_to_SAP__c = false;
            }
            //Added to restrict Sales Rep to block only one property for Project
            if(pObj.Temporary_Block__c && !oldPropMap.get(pObj.Id).Temporary_Block__c){
                if(!pObj.Is_Jodi_Flat__c){
                stPropIds.add(pObj.Project_Name__c);
                //mapUserRec.put(pObj.Project_Name__c,UserInfo.getUserId());
                mapProprec.put(UserInfo.getUserId(),pObj);
                }
                //else { pObj.addError('You cannot block Jodi Property.');}
            }
            system.debug('mapUserRecmapUserRec'+mapProprec);
            system.debug('mapUserRecmapUserRec'+stPropIds);
            system.debug('mapUserRecmapUserRec'+UserInfo.getUserId());
            
        }
        String profileName = [Select Id,Name from Profile where Id=:Userinfo.getProfileId()].Name;
        for(Property__c pr : [select id,Project_Name__c,Temporary_Block__c,Blocked_By__c,isUpdatedfromUI__c,Blocked_By__r.profile.name from Property__c 
        where Temporary_Block__c = true and Project_Name__c IN : stPropIds]){
            system.debug('mapUserRecmapUserRec'+pr.Project_Name__c);
            system.debug('mapUserRecmapUserRec'+pr.Temporary_Block__c);
            //system.debug('mapUserRecmapUserRec'+!oldPropMap.get(pr.Id).Temporary_Block__c);
            //system.debug('mapUserRecmapUserRec'+!String.isBlank(pr.Blocked_By__c));
            //system.debug('mapUserRecmapUserRec'+(pr.Blocked_By__c));
            //system.debug('mapUserRecmapUserRec'+mapProprec.containsKey(pr.Blocked_By__c));
            
            if(pr.Temporary_Block__c && !String.isBlank(pr.Blocked_By__c)
            && mapProprec.containsKey(pr.Blocked_By__c)){
            //&& profileName == 'Sales Rep'){
                system.debug('mapUserRecmapUserRec');
                Property__c prt = mapProprec.get(pr.Blocked_By__c);
                if(pr.Project_Name__c == prt.Project_Name__c && pr.isUpdatedfromUI__c == false && pr.Blocked_By__r.profile.name == 'Sales Rep'){
                prt.addError('A Sales Representative can only block one property in a Project at a time.');
                }
            }
           
        }        
        Logger.logDebug('Before calling Push request for update:'+invIds);
        if(!invIds.isEmpty()){
            //ORL_SAP_IntegrationHelper.updateInventoryInSAPFuture(invIds);
        }
    }
    
   /* public static void onAfterInsert(List<Property__c> propList) {    
        //Call methods from integration layer to push records to SAP
        list<string> invIds = new list<string>();
        for(Property__c pObj: propList){
            if(pObj.Move_to_SAP__c){
                invIds.add(pObj.Id);
            }
        }
        Logger.logDebug('Before calling Push request for insert:'+invIds);
        if(!invIds.isEmpty()){
            ORL_SAP_IntegrationHelper.createInventoryInSAPFuture(invIds);
        }
        
    }*/
    
    public static void onAfterUpdate(List<Property__c> propList, map<id,Property__c> oldPropMap) {    
        //Logic on after Update
        Set<string> stPropIds = new Set<string>();
        Map<Id,Property__c> mapProprec = new Map<Id,Property__c>();
        for(Property__c pObj: propList){
            //Added to restrict Sales Rep to block only one property for Project
            if(pObj.Temporary_Block__c && !oldPropMap.get(pObj.Id).Temporary_Block__c){
                if(!pObj.Is_Jodi_Flat__c){
                stPropIds.add(pObj.Project_Name__c);
                mapProprec.put(UserInfo.getUserId(),pObj);
                }
            }
            system.debug('mapUserRecmapUserRec'+mapProprec);
            system.debug('mapUserRecmapUserRec'+stPropIds);
            system.debug('mapUserRecmapUserRec'+UserInfo.getUserId());           
        }
        for(Property__c pr : [select id,Project_Name__c,Temporary_Block__c,Blocked_By__c from Property__c 
        where Temporary_Block__c = true and Project_Name__c IN : stPropIds]){
            system.debug('mapUserRecmapUserRec'+pr);
            system.debug('mapUserRecmapUserRec'+pr.Temporary_Block__c);
            //system.debug('mapUserRecmapUserRec'+!oldPropMap.get(pr.Id).Temporary_Block__c);
            //system.debug('mapUserRecmapUserRec'+!String.isBlank(pr.Blocked_By__c));
            //system.debug('mapUserRecmapUserRec'+(pr.Blocked_By__c));
            //system.debug('mapUserRecmapUserRec'+mapProprec.containsKey(pr.Blocked_By__c));
            if(pr.Temporary_Block__c && !String.isBlank(pr.Blocked_By__c)
            && mapProprec.containsKey(pr.Blocked_By__c) 
            && mapProprec.get(pr.Blocked_By__c).Blocked_By__c != pr.Blocked_By__c){
                system.debug('mapUserRecmapUserRec');
                Property__c prt = mapProprec.get(pr.Blocked_By__c);
                //prt.addError('A Sales Representative can only block one property in a Project at a time.');
            }
        }
    }
    
    /**
* @Author: Ravi Kumar K
* @Company: IBM
* @date: 19/03/2019
* @description: added the Method which will not allow a sales Rep to Block two properties for the single Project
* @param: input : List of Property and Old Instance of Property records and methodName which is either Insert or Update
* @return: void
*/
    
    public static void propertyCheck(List<Property__c> propertyList,map<id,Property__c> oldPropMap){
        system.debug('inside property check');
        Set<Property__c> properties = new Set<Property__c>();
        For(Property__c singleProperty:propertyList){
            if(singleProperty.Blocked_By__c!=oldPropMap.get(singleProperty.Id).Blocked_By__c && singleProperty.Temporary_Block__c==true
              && singleProperty.Blocked_By__c!=null)
                System.debug('test__'+singleProperty.Blocked_By__c);
                properties.add(singleProperty);
        }
        //Map is wrong one Project can have 
        if(properties.size()>0){
            system.debug('Property---'+properties.size());
        Map<Id,List<Id>> projectUserMap = new Map<Id,List<Id>>();
         List<Id> blockedByUserIdList = new List<Id>(); 
            //List<Property__c> PropList = [SELECT Project_Name__c,Blocked_By__c,Temporary_Block__c FROM Property__c WHERE Temporary_Block__c=true];
        For(Property__c singleProperty:[SELECT Project_Name__c,Blocked_By__c,Temporary_Block__c FROM Property__c WHERE Temporary_Block__c=true]){
            //system.debug('PropList---'+PropList.size());
            if(projectUserMap.containsKey(singleProperty.Project_Name__c)){
                blockedByUserIdList.add(singleProperty.Blocked_By__c);
                System.debug('projectUserMap__'+projectUserMap);
            }else{
                blockedByUserIdList.add(singleProperty.Blocked_By__c);
                projectUserMap.put(singleProperty.Project_Name__c,blockedByUserIdList);   
            } 
        } 
       
            For(Property__c singleProperty:properties){
                 System.debug('ProjName__'+singleProperty.Project_Name__c);
                System.debug('Existing__'+projectUserMap.get(singleProperty.Project_Name__c));
                System.debug('New__'+singleProperty.Blocked_By__c);
                if(projectUserMap.get(singleProperty.Project_Name__c)!=null){
                    if(projectUserMap.get(singleProperty.Project_Name__c).contains(singleProperty.Blocked_By__c)){
                    //singleProperty.Blocked_By__c.addError(Label.ORL_BlockProperty);
                } 
                }
            }
        }
    }
    
    public static void autoPopulateBlockedBy(List<Property__c> propertyList,map<id,Property__c> oldPropMap){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        for(Property__c singleProperty:propertyList){
            if(profileName == 'System Administrator' || profileName == 'Sales Rep'){
                if(singleProperty.Temporary_Block__c==true && singleProperty.Temporary_Block__c!=oldPropMap.get(singleProperty.Id).Temporary_Block__c){
                    singleProperty.Blocked_By__c = UserInfo.getUserId();
                }
                if(singleProperty.Temporary_Block__c==false){
                    singleProperty.Blocked_By__c = NULL;
                    singleProperty.Block_Comments__c = '';
                }
            }
                
        }
    }
    public static void autoBlockGrande(List<Property__c> propertyList,map<id,Property__c> oldPropMap){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        map<Id,Property__c> mapProperty = new map<Id,Property__c>();
        //map<Id,Property__c> mapunblockProperty = new map<Id,Property__c>();
        Set<Id> stProperty = new Set<Id>();
        system.debug('stPropertystProperty');
        for(Property__c pr : propertyList){
            system.debug('Property__c pr:'+pr.Temporary_Block__c);
            system.debug('oldPropMap.get(pr.Id).Temporary_Block__c: '+oldPropMap.get(pr.Id).Temporary_Block__c);
            
            system.debug('stPropertystProperty'+pr.Related_Jodi_Property__c);
            if(pr.Temporary_Block__c==true && pr.Temporary_Block__c!=oldPropMap.get(pr.Id).Temporary_Block__c){
                //pr.Related_Jodi_Property__r.
                //mapProperty.put(pr.Related_Jodi_Property__c,pr.Id);
                system.debug('stPropertystProperty');
                mapProperty.put(pr.Related_Jodi_Property__c,pr);
                //stProperty.add(pr.Related_Jodi_Property__c);
            }
            else if (pr.Temporary_Block__c==false && pr.Temporary_Block__c!=oldPropMap.get(pr.Id).Temporary_Block__c){
                system.debug('stPropertystProperty');
                //mapunblockProperty.put(pr.Related_Jodi_Property__c,pr);
                stProperty.add(pr.Related_Jodi_Property__c);
            }
        }
        system.debug('stPropertystProperty'+stProperty);
        if(mapProperty != null && mapProperty.size() > 0){
            List<Property__c> lstProperty = new List<Property__c>();
            for(Property__c pr : [select id,Is_Jodi_Flat__c,Temporary_Block__c,Related_Jodi_Property__c from Property__c where Id IN: mapProperty.keyset()]){
                system.debug('stPropertystProperty'+pr.Id);
                if(pr.Temporary_Block__c==false){
                    pr.isUpdatedfromUI__c=false;
                    pr.Temporary_Block__c=true;
                    pr.Block_Comments__c = mapProperty.get(pr.Id).Block_Comments__c;
                    //pr.Blocked_By__c = mapProperty.get(pr.Id).Blocked_By__c;
                    system.debug('stPropertystProperty');
                    lstProperty.add(pr);
                }
            }
            if(lstProperty != null && lstProperty.size()>0){
                update lstProperty;
            }
        }
        if(stProperty != null && stProperty.size() > 0){
            List<Property__c> lstProperty = new List<Property__c>();
            for(Property__c pr : [select id,Temporary_Block__c,Related_Jodi_Property__c from Property__c where Id IN: stProperty]){
                system.debug('stPropertystProperty'+pr.Id);
                if(pr.Temporary_Block__c==true){
                    pr.Temporary_Block__c=false;
                    pr.isUpdatedfromUI__c=true;
                    pr.Block_Comments__c = '';
                    //pr.Blocked_By__c = mapProperty.get(pr.Id).Blocked_By__c;
                    system.debug('stPropertystProperty');
                    lstProperty.add(pr);
                }
            }
            if(lstProperty != null && lstProperty.size()>0){
                update lstProperty;
            }
        }
    }   
}
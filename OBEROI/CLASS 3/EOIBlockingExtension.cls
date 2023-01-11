public with sharing class EOIBlockingExtension{
    public Id OptyId {get; set;}     
    public Id UnitId {get; set;}
    public String act {get; set;}
    public list<property__c> Prop {get; set;}
    public String SuccessMsg {get;set;}
    public EOIBlockingExtension(){
     
    }
    public void updateUnit(){
        UnitId = ApexPages.currentPage().getParameters().get('unitId');
        OptyId = ApexPages.currentPage().getParameters().get('oppId');
        act = ApexPages.currentPage().getParameters().get('action');
        if(act == 'Blocked'){
        Prop  = new list<property__c>();
        list<property__c> jProp = new list<property__c>();
        list<Opportunity> oppList = new list<Opportunity>();
        list<property__c> updateprop = new list<property__c>();
        list<property__c> updatejprop = new list<property__c>();
        Prop = [select id, Name,Material_No__c,Status__c,Jodi_Property__c,EOI_Block__c,EOI_Blocked_for__c,EOI_Blocked_for__r.Name,EOI_Blocked_for__r.Id From property__c Where id =: UnitId AND Status__c =: 'Available'];
        if(Prop.size()>0){
            jProp = [select id, Name,Material_No__c,Status__c,Jodi_Property__c,EOI_Block__c,EOI_Blocked_for__c,EOI_Blocked_for__r.Name From property__c Where Jodi_Property__c =: Prop[0].id AND Status__c =: 'Available'];
        }
        List<Opportunity> oppL = [select id,name,Cloned_Opportunity_Id__c from Opportunity where id =: OptyId];
        if(oppL[0].Cloned_Opportunity_Id__c == null){
            oppList = [select id,name,Cloned_Opportunity_Id__c from Opportunity where Cloned_Opportunity_Id__c =: OptyId];
        }else{
            oppList = [select id,name,Cloned_Opportunity_Id__c from Opportunity where id =: oppL[0].Cloned_Opportunity_Id__c];
        }
        try{
            if(jProp.size()>0){
                if(Prop.size() > 0){
                    Prop[0].Status__c = 'EOI Blocked';
                    Prop[0].EOI_Blocked_Date__c = System.Today();
                    Prop[0].EOI_Blocked_By__c = UserInfo.getUserId();
                    Prop[0].EOI_Block__c = True;
                    Prop[0].EOI_Blocked_for__c = OptyId;
                    updateprop.add(Prop[0]);
                    jProp[0].Status__c = 'EOI Blocked';
                    jProp[0].EOI_Blocked_Date__c = System.Today();
                    jProp[0].EOI_Blocked_By__c = UserInfo.getUserId();
                    jProp[0].EOI_Block__c = True;
                    if(oppList.size()>0){
                        jProp[0].EOI_Blocked_for__c = oppList[0].id;
                    }
                    updatejprop.add(jProp[0]);
                }else{
                    SuccessMsg = 'The Unit is not available for EOI Blocking.';
                }
                if(oppList.size()>0){
                  update updateprop;
                  update updatejprop;
                  SuccessMsg = 'Jodi Unit '+Prop[0].Material_No__c+', '+jProp[0].Material_No__c+' Blocked Successfully.';//\nOpportunity : '+Prop[0].EOI_Blocked_for__r.Name+', '+jProp[0].EOI_Blocked_for__r.Name;
                }else{
                  SuccessMsg = 'Cloned opportunity not found.';
                }
                
            }else{
                if(Prop.size() > 0){
                    
                        Prop[0].Status__c = 'EOI Blocked';
                        Prop[0].EOI_Blocked_Date__c = System.Today();
                        Prop[0].EOI_Blocked_By__c = UserInfo.getUserId();
                        Prop[0].EOI_Block__c = True;
                        Prop[0].EOI_Blocked_for__c = OptyId;
                        updateprop.add(Prop[0]);
                        SuccessMsg = 'Unit '+Prop[0].Material_No__c+' Blocked Successfully.';
                    }else{
                        SuccessMsg = 'This Unit is not available for EOI Blocking.';
                    }
                    update updateprop;
            }
            system.debug('Unit__c:'+updateprop);
            
        }catch(Exception e){
            SuccessMsg = e.getMessage();
        }
        
       }
       else{
           list<property__c> Prop  = new list<property__c>();
            list<property__c> jProp = new list<property__c>();
            list<Opportunity> oppList = new list<Opportunity>();
            list<property__c> updateprop = new list<property__c>();
            list<property__c> updatejprop = new list<property__c>();
            Prop = [select id, Name,Material_No__c,Status__c,EOI_Blocked_By__c,Booking__c,Jodi_Property__c,EOI_Block__c,EOI_Blocked_for__c,EOI_Blocked_for__r.Name From property__c Where id =: UnitId AND Status__c != 'Available'];
            if(Prop.size()>0){
                jProp = [select id, Name,Material_No__c,EOI_Blocked_By__c,Booking__c,Status__c,Jodi_Property__c,EOI_Block__c,EOI_Blocked_for__c,EOI_Blocked_for__r.Name From property__c Where Jodi_Property__c =: Prop[0].id AND Status__c != 'Available'];
            }
            String profileName = [select Name from profile where id = :UserInfo.getProfileId()].Name;
            if(jProp.size()>0){
                    system.debug('Inner Unblock');
                    if(Prop.size() > 0){
                        if(UserInfo.getUserId() != Prop[0].EOI_Blocked_By__c && profileName != 'System Administrator'){
                            SuccessMsg = 'You Cannot unblock this Jodi Unit.';
                        }else{
                            if(Prop[0].Booking__c == Null && jProp[0].Booking__c == Null){
                                Prop[0].Status__c = 'Available';
                                updateprop.add(Prop[0]);
                                jProp[0].Status__c = 'Available';
                                updatejprop.add(jProp[0]);
                                update updateprop;
                                update updatejprop;
                                SuccessMsg = 'EOI Jodi Unit UnBlock Successfully.';//\nOpportunity : '+Prop[0].EOI_Blocked_for__r.Name+', '+jProp[0].EOI_Blocked_for__r.Name;
                            }else{
                                SuccessMsg = 'You can not unblock this property because this is jodi property and its another property booking is done.';
                            }
                            
                        }
                    }
            }else{
                system.debug('Inner Unblock');
                    if(Prop.size() > 0){
                        if(UserInfo.getUserId() != Prop[0].EOI_Blocked_By__c && profileName != 'System Administrator'){
                            SuccessMsg = 'You Cannot unblock this Unit.';
                        }else{
                            Prop[0].Status__c = 'Available';
                            updateprop.add(Prop[0]);
                            update updateprop;
                            SuccessMsg = 'EOI Unit UnBlock Successfully.';//\nOpportunity : '+Prop[0].EOI_Blocked_for__r.Name;
                        }
                    }
            }
       }
    }
    public PageReference BackToOpportunity(){
        pageReference P = new pageReference('/'+ OptyId);
        return P;
    }
     public PageReference BackToProperty(){
        system.debug('id is '+ UnitId);
        pageReference PP = new pageReference('/apex/ORL_Inventory?oppid='+ OptyId);
        return PP;
    }
    
        
   
}
({
    fetchListOfRecordTypes: function(component, event, helper) {
        var action = component.get("c.fetchRecordTypeValues");
        var action1 = component.get("c.fetchsiteProject");
        var CampID = component.get("v.recordId");
        var campRec;
        var projId;
        component.set("v.cId", CampID);         
        action.setParams({
            campId : CampID            
        }); 
        action1.setParams({
            campId : CampID            
        }); 
        action1.setCallback(this, function(response) {
            campRec = response.getReturnValue(); 
            //component.set("v.projId",campRec.Project__c );
            if(campRec != null)
                projId = campRec.Project__c;
        });        
        action.setCallback(this, function(response) {
            var custs = [];
            var adData = response.getReturnValue();
            component.set("v.lstOfRecordType", response.getReturnValue());
            for(var key in adData){
                custs.push({value:adData[key], key:key});
            }            
            if(custs[0] != undefined){
                var recName = custs[0].value.DeveloperName;
                if(recName== $A.get("$Label.c.ORL_Campaign_Advertisement")  ){
                    component.set("v.flag", false);
                    sforce.one.createRecord('Campaign',custs[0].value.Id,{ 
                        Marketing_Channel__c : CampID,  
                        Project__c : projId,
                    });
                }else if(recName== $A.get("$Label.c.ORL_Campaign_Marketing_Channel")){
                    component.set("v.flag", false);  
                    sforce.one.createRecord('Campaign',custs[0].value.Id,{ 
                        Marketing_Campaign__c : CampID,  
                    });
                }else if( recName== $A.get("$Label.c.ORL_Campaign_Marketing_Campaign_Multi_Project")){
                    component.set("v.flag", false);  
                    sforce.one.createRecord('Campaign',custs[0].value.Id,{ 
                        Marketing_Plan__c : CampID,  
                    });
                }else {
                    component.set("v.flag", true);  
                    // sforce.one.createRecord('Campaign',custs[0].value.Id);
                }
            }
        }); 
        $A.enqueueAction(action1);
        $A.enqueueAction(action);
        
    },
    
    /*  createRecord: function(component, event, helper) {
        var recordTypeId = component.find("selectid").get("v.value");
        alert(recordTypeId);
        // alert('recordTypeId ---->> ' + recordTypeId);
       // $A.get('e.force:closeQuickAction').fire();
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Campaign",
             "recordTypeId": recordTypeId
        });
        createRecordEvent.fire();
    }*/
    
    handleChangeButtonGroup:function(cmp, event, helper){
        var auraIdField = event.getSource().get("v.value");
        cmp.set("v.RId", auraIdField);        
    },
    
    createRecord: function(component, event, helper) {
        //var action = component.get("c.fetchsiteProject");
        //var action = component.get("c.fetchsiteProject");
        var recordTypeId = component.get("v.RId");
        var CampID = component.get("v.cId");
       /* action.setParams({
            campId : CampID            
        });
        action.setCallback(this, function(response) {                        
            var cData = response.getReturnValue();
            component.set("v.test", (response.getReturnValue().Site__c).substring(0, 15));           
        });
        var val= component.get("v.test");
        */
        // var recordTypeId = component.find("selectid").get("v.value");
        if(!$A.util.isEmpty(recordTypeId) && !$A.util.isUndefined(recordTypeId)){          
            sforce.one.createRecord('Campaign',recordTypeId,{ 
               // Site__c : val,
                Marketing_Plan__c : CampID, 
            });	
            
        }  
       // $A.enqueueAction(action);
        
    },
    
    
    cancelRecord: function(component, event, helper) { 
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            recordId: component.get("v.recordId")
            //slideDevName: "detail"
        });
        alert('fire'+component.get("v.recordId"));
        navEvent.fire();          
    },
    
    
    
    
})
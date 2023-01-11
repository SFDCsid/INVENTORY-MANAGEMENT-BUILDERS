({
    Init : function(component,event, helper) {
        component.set("v.StartDate", "2019-07-01");
        component.set("v.EndDate","2019-07-01"); 
        var siteList;
        var action = component.get("c.listSite");
        action.setCallback(this, function(response) {
            component.set("v.siteList",response.getReturnValue() );
            // siteList = response.getReturnValue(); 
        });
        $A.enqueueAction(action);
    },
    
    
    
    GenerateReport: function(component, event, helper) {
        var startDate = component.get("v.StartDate");
        var EndDate = component.get("v.EndDate");
        var action = component.get("c.leadCountBasedonCampaign");
        var siteId = component.find("PicklistId").get("v.value");        
        
        if(EndDate >= startDate){            
            action.setParams({
                startDate : startDate,
                EndDate : EndDate,
                siteID : siteId
            }); 
            action.setCallback(this, function(response) {
                campRec = response.getReturnValue(); 
                //component.set("v.projId",campRec.Project__c );
                
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
                    
                }
            }); 
            
            $A.enqueueAction(action);
        } else{
            alert('Please Enter Valid Date Range.');
        }
    },
})
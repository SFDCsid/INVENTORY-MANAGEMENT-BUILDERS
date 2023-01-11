({
    getPMTUsers : function(component,event, helper) {
        var action = component.get("c.getPMTUsers");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.pmtUsers", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    getLastAssignedId : function(component,event, helper) {
        var action = component.get("c.getLastAssignedId");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.lastAssignedId", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    savePMTUserRecords : function(component,event, helper) {
        var action = component.get("c.savePMTUserRecords");
        
        action.setParams({"inputUsers":JSON.stringify(component.get("v.pmtUsers"))});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                 $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    }
})
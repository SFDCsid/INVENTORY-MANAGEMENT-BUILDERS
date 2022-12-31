({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.clickToCall");
        action.setParams({ 'recordId' : component.get("v.recordId") }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get("e.force:closeQuickAction").fire();

                component.set("v.Ids",response.getReturnValue()); 
            } 
        });  
        $A.enqueueAction(action); 

    }
})
({
	doInit : function(component, event, helper) {
        var action = component.get("c.cloneToOpportunity");
        action.setParams({Id :component.get("v.recordId"),
                          oppName :component.get("v.oppName")});
        action.setCallback(this, function(result) { 
            var state = result.getState();
            if (state === "SUCCESS") { 
                var response = result.getReturnValue(); 
                var toastEvent = $A.get("e.force:showToast"); 
                if (response.Result == "Success"){
                    toastEvent.setParams({ 
                        "title": "Success",
                        "message": "Opportunity \""+response.Name+"\" was cloned Successfully.", 
                        "type": "success",
                        "duration":"5000"
                    });
                } else {
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Unable to clone opportunity. Please contact your administrator for help.", 
                        "type": "error",
                        "duration":"5000"
                    });
                }
                toastEvent.fire();
                var navEvt = $A.get("e.force:navigateToSObject"); 
                navEvt.setParams({ "recordId": response.Id,
                                  "slideDevName": "detail" });
                navEvt.fire(); 
            }
        });
        $A.enqueueAction(action);
    },
})
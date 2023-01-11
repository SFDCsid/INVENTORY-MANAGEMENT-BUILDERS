({
    doInit : function(component, event, helper) {
        // Get a reference to the getWeather() function defined in the Apex controller
        var action = component.get("c.Consolidate");
        action.setParams({
            "BillingId": component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.isSuccess", response.getReturnValue());
            if(component.get("v.isSuccess")){
                component.set("v.msg", "Billing Plan Line Items Computed Sucessfully");
            }else{
               component.set("v.msg", "Something went wrong Please try again or contact your administrator");
            }
        });
        $A.enqueueAction(action);
    }
})
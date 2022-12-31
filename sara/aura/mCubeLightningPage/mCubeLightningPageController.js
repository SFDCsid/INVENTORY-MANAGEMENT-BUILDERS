({
	doInit : function(component, event, helper) {
        var recId=component.get("v.recordId");
		var action = component.get("c.callRecords");
        action.setParams({ 'recId' : recId }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.callrecords",response.getReturnValue()); 
             } 
        });  
        $A.enqueueAction(action);  
	}
})
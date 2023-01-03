({
	getApproval : function(component) {
		var list_size = component.get("v.list_size");
        var counter = component.get("v.counter");
        
        var action = component.get("c.getApprovalList");
        action.setParams({ "list_size" : list_size , "counter" : counter, "type" : 'Other'});
        // Register the callback function
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                component.set('v.approvalWrapperList', response.getReturnValue());
                if(component.get("v.approvalWrapperList").Null) {
                    component.set("v.isError",true);
                	component.set("v.msg", 'No Campaign Available For Approval.');
                }
                if(component.get("v.counter") > 0) {
                    component.set("v.disablePrevious", false);
                } else {
                    component.set("v.disablePrevious", true);
                }
                if(component.get("v.counter") + component.get("v.list_size") < component.get("v.total_size")) {
                    component.set("v.disableNext", false);
                } else {
                    component.set("v.disableNext", true);
                }
                if(component.get("v.total_size") % component.get("v.list_size") > 0) {
                    const calVar = Math.ceil(component.get("v.total_size") / component.get("v.list_size"));
                    component.set("v.total_Pages", calVar);
                } else {
                    const calVar = Math.trunc(component.get("v.total_size") / component.get("v.list_size"));
                    component.set("v.total_Pages", calVar);
                }
                component.set("v.page_Number", (component.get("v.counter") / component.get("v.list_size")) + 1);

            }
        });
        //Enqueue the action so that the framework processes it
        $A.enqueueAction(action);
	}
})
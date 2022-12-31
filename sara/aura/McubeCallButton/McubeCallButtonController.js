({
	doInit : function(component, event, helper) {
		    var action = component.get("c.readNumbers");
            action.setParams({ 'recordId' : component.get("v.recordId") });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                     console.log(response.getReturnValue());
                     component.set("v.numbers", response.getReturnValue())
                } 
            });  
            $A.enqueueAction(action);
	},
    dialNumbers : function(component, event, helper) {
		    var action = component.get("c.clickToCallNumber"); 
            action.setParams({ 'recordId' : component.get("v.recordId"),'numberSelected' : component.get("v.selectedNumber") });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "type": "success",
                                "message": "The call has been placed successfully."
                            });
                            toastEvent.fire();
                    }else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error",
                                "type": "error",
                                "message": "Something went wrong"
                            });
                            toastEvent.fire();
                        
                    }
                } 
            });  
            $A.enqueueAction(action);
	}
})
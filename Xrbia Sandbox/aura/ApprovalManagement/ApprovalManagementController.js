({
	doInit : function(component, event, helper) {
        var action = component.get("c.getApprovalList");
        action.setParams({ "list_size" : 0, "counter" : 0, "type" : 'Total'});
        // Register the callback function
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                if(response.getReturnValue() != null) {
                    component.set("v.total_size", response.getReturnValue().length);
                } else {
                    component.set("v.total_size", 0);
                }
                helper.getApproval(component);
            }
        });
        //Enqueue the action so that the framework processes it
        $A.enqueueAction(action);
	},

    next : function(component, event, helper) {
        component.set("v.counter", component.get("v.counter") + component.get("v.list_size"));
        helper.getApproval(component);
    },

    previous : function(component, event, helper) {
        component.set("v.counter", component.get("v.counter") - component.get("v.list_size"));
        helper.getApproval(component);
    },

    first : function(component, event, helper) {
        component.set("v.counter", 0);
        helper.getApproval(component);
    },

    last : function(component, event, helper) {
        var calVariable = component.get("v.total_size") % component.get("v.list_size");
        component.set("v.counter", component.get("v.total_size") - calVariable);
        helper.getApproval(component);
    },

    selectFunction : function(component, event, helper) {
        var selectedValue = event.getSource().get('v.value');

        if(event.getSource().get('v.checked') == true) {
            component.get("v.processItemSet").push(selectedValue);
        } else if(event.getSource().get('v.checked') == false) {
            for(var i = 0; i < component.get("v.processItemSet").length; i++) {
                if(component.get("v.processItemSet")[i] === selectedValue) {
                    component.get("v.processItemSet").splice(i, 1);
                }
            }
        }
    },

    campaignApprove : function(component, event, helper) {
        var action = component.get("c.approveCampaign");
        action.setParams({ 
            "processItemList": component.get("v.processItemSet")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                var response = response.getReturnValue();
                if(response == true) {
                    $A.get('e.force:refreshView').fire();
                    
                    /*Raise success toast*/
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Approved Successfully!',
                        duration:' 5000',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                } else {
                    /*Raise Error toast*/
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Error Occured While Processing. Please Contact Your System Administrator',
                        duration:' 5000',
                        type: 'error',
                        mode: 'dismissible'  
                    }); 
                    toastEvent.fire();
                }
            }
		});
        //Enqueue the action so that the framework processes it
        $A.enqueueAction(action);
    },

    campaignReject : function(component, event, helper) {
        var action = component.get("c.rejectCampaign");
        action.setParams({ 
            "processItemList": component.get("v.processItemSet") 
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                var response = response.getReturnValue();
                if(response == true) {
                    $A.get('e.force:refreshView').fire();
                    
                    /*Raise success toast*/
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Rejected Successfully!',
                        duration:' 5000',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                } else {
                    /*Raise Error toast*/
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Error Occured While Processing. Please Contact Your System Administrator',
                        duration:' 5000',
                        type: 'error',
                        mode: 'dismissible'  
                    }); 
                    toastEvent.fire();
                }
            }
		});
        //Enqueue the action so that the framework processes it
        $A.enqueueAction(action);
    }
})
({  
	doInit : function(component, event, helper) {
        var action = component.get("c.getSVRecord");
        action.setParams({
            "RecordSV": component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                //alert('getSV: '+response.getReturnValue());
                component.set("v.SVRecord", response.getReturnValue());
                if(component.get("v.SVRecord.Is_Sales_Manager_Assigned__c") == true) {
                    component.set("v.isError",true);
                	component.set("v.msg", 'Sales Manager Is Already Assigned.');
                } else {
                    //alert('In Else');
                    helper.GetAllPunchPointHelper(component, event);
                }
            }
        });
        //Enqueue the action so that the framework processes it
        $A.enqueueAction(action);
    },
    
    asignSalesManager : function(component, event, helper) {
    	var UserId = event.srcElement.id;
       
        var action = component.get("c.checkUserAvailability");
        action.setParams({
            "userId": UserId
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                component.set("v.salesManager", response.getReturnValue());
                if(component.get("v.salesManager.Availability__c") == false) {
                    component.set("v.isError",true);
                	component.set("v.msg", 'Sales Manager Is Not Available.');
                } else {
                    helper.assignSalesManager(component, event);
                }
            }
		});
        //Enqueue the action so that the framework processes it
        $A.enqueueAction(action);
        //helper.GetaasignmanagerHelper(component, event, UserId);
        //helper.GetUserafterassignHelper(component, event, UserId);
	}
})
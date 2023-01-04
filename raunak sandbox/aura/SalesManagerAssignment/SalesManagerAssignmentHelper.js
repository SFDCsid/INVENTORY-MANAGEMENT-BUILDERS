({
    GetAllPunchPointHelper : function(component, event) {
        //alert('Inside GetAllPunchPointHelper');
        var action = component.get('c.getAllSalesManager');// from apex class,calling  the method
        action.setParams({
            "svRecord": component.get("v.SVRecord")
        });
        //Parameter pass to that method which is present in apex class
        //get result in call back
        action.setCallback(this, function(response){
            //alert('In Response: '+response.getState());
            var state = response.getState();	// succes or failure result
            if(state === 'SUCCESS') {
                console.log("Suceess Do init" + state);
               	//alert('get SM: '+response.getReturnValue());
                component.set("v.userList", response.getReturnValue());
                if(component.get("v.userList") == null) {
                    component.set("v.isError",true);
                	component.set("v.msg", 'No Sales Manager Available For Assigning.');
                }
            }
        });
        $A.enqueueAction(action); 	// calling action main step
    },
    assignSalesManager : function(component, event) {
        // alert('Inside assignSalesManager');
        var action = component.get('c.assignSalesManager');		// from apex class,calling  the method
        action.setParams({
            "svRecord": component.get("v.SVRecord"),
            "salesManager": component.get("v.salesManager")
        });
        //Parameter pass to that method which is present in apex class
        //get result in call back
        action.setCallback(this, function(response){
            //alert('In Response: '+response.getState());
            var state = response.getState();	// succes or failure result
            if(state === 'SUCCESS') {
				var result = response.getReturnValue();
                
                if(result == true) {
                    $A.get('e.force:refreshView').fire();
                    
                    /*Raise success toast*/
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Sales Manager Assigned! Thank You.',
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
        $A.enqueueAction(action);	// calling action main step
    }
})
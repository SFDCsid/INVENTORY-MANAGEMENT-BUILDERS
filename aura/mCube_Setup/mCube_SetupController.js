({
    handleClick : function(component, event, helper) {
        var api= component.get("v.apiName");
        if(api!=null){
            var action = component.get("c.apiCreate");
            action.setParams({ 'api' : fieldApiName });
            action.setParams({ 'apiField' : fieldApiName }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    alert('successfully created!')
                } 
            });  
            $A.enqueueAction(action);  
        }
    }
})
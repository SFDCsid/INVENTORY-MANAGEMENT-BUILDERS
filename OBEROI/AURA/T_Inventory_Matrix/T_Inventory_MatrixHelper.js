({
	viewFloor : function(component, event, helper) {
        //alert('Inside');
        var towerId = event.target.dataset.id;
        //alert("towerId=>"+towerId);
        var action1 = component.get("c.getFloor");
        action1.setParams({
            "towerId" : towerId
        });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.floorList", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action1);
        
    }
})
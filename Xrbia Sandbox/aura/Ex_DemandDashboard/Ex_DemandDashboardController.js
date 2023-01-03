({
    doInit : function(component, event, helper) {
        var action = component.get("c.getProjectTowerMap");
        // Register the callback function
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                if(response.getReturnValue() != null) {
                    var projectTower = response.getReturnValue();
                    var projectTowerList = [];

                    for(var key in projectTower) {
                        projectTowerList.push({project:key, value:projectTower[key]});
                    }
                    component.set("v.projectTowerMap", projectTowerList);
                } else {
                    alert('No Demand');
                }
            }
        });
        //Enqueue the action so that the framework processes it
        $A.enqueueAction(action);
	}
})
({
	invoke : function(component, event, helper) {
		var objn = component.get("v.ObjName");
        var fldn = component.get("v.FldName");
        var action = component.get("c.getDocType");
        action.setParams({
            "objectName":objn,
            "FieldName":fldn
        });
        action.setCallback(this,function(response){
        	var state = response.getState();
            if(state==="SUCCESS"){
                var res = response.getReturnValue();
                component.set("v.result",res);
            }
        });
        $A.enqueueAction(action);
	}
})
({
    doInit : function(cmp, event, helper) {
        console.log('Inside doinit method');
        var oppId = cmp.get("v.oppId");
        var unitId = cmp.get("v.unitId");
        var act = cmp.get("v.action");
        console.log(oppId);
        console.log(unitId);
        console.log(act);
        var action = cmp.get("c.getopp");
        action.setParams({'oppId':oppId});
         action.setCallback(this, function(actionResult) {
               cmp.set('v.opp',actionResult.getReturnValue());
        });
        
        $A.enqueueAction(action);   
       console.log('Inside doinit method');
        var action1 = cmp.get("c.getunit");
        action1.setParams({'unitId':unitId});
        
       action1.setCallback(this, function(actionResult) {
            cmp.set('v.unit',actionResult.getReturnValue());
        });
        $A.enqueueAction(action1);
        console.log('Inside doinit method');   
	},
    save : function(component, event, helper){
            var oppId = component.get("v.oppId");
        	var unitId = component.get("v.unitId");
            var act = component.get("v.action");
            console.log(oppId);
            console.log(unitId);
            console.log(act);
    		var action = component.get("c.saveBlockingRecord");
            action.setParams({"blockObj":component.get("v.Block"),
                              'oppId':oppId,
                              'unitId':unitId,
                              'act':act});
            action.setCallback(this,function(result){
            component.set("v.isShow",false);
          
        });
         $A.enqueueAction(action);
	},
    cancel : function(component, event, helper){
        window.close();
    }
})
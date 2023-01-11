({
    copyDataToTask : function(component, event, helper) {
        var action = component.get('c.getTypeFromLead');
        var leadId = component.get("v.recordId");
        action.setParams({
            recId : leadId            
        });
        action.setCallback(this, function(res) { 
            helper.handleCallback(component, event, helper,res);             
            $A.get("e.force:closeQuickAction").fire();
            // $A.get('e.force:refreshView').fire();             
        });
        $A.enqueueAction(action);  
    },
    
    
    handleCallback : function(component, event, helper,res){
        if (res.getState() === 'SUCCESS') {            
            var tkId = res.getReturnValue();
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": tkId
            });
            navEvt.fire();
        }
    },
})
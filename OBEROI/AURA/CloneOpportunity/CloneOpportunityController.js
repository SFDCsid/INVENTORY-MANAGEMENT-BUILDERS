({
    handleinit : function(component, event, helper) {
        let recordId = component.get("v.recordId");
         
        let action = component.get("c.getOppName");
        console.log(recordId);
        action.setParams({
            oppId : recordId
        });
        action.setCallback(this,function(data){
            
            console.log(data.getReturnValue());
            component.set("v.opportunityName",data.getReturnValue() );
        });
        
        $A.enqueueAction(action);
        
         
    } ,
    handleClone: function(component,  event, helper) {
        var recordId = component.get("v.recordId");
        var oppName = component.get("v.opportunityName");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CloneOpportunityChild",
            componentAttributes: {
                recordId : recordId,
                oppName : oppName
            }
        });
        evt.fire();
    },
    handleCancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    
    
})
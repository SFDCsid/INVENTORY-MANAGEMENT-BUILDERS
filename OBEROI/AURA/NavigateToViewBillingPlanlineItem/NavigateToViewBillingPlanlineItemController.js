({
    doInit: function(component, event, helper) { 
        var fieldValue = component.get('v.recordId');
        var evt = $A.get("e.force:navigateToComponent");
        console.log('Event '+evt);
      //  var billingPlanObjValue = component.get("v.billingplan");
        evt.setParams({
            componentDef  : "c:ReadOnlyBillingPlanLineItem" ,
            componentAttributes : {
                billingPlanId : component.get("v.recordId") 
            }
        });
        evt.fire();
    },
})
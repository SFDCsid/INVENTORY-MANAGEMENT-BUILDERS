({
    fetchBillingPlans : function(component,event,helper,oppIdValue) {
        var action = component.get('c.getBillingPlan');
        action.setParams({    
            oppID : oppIdValue
        });
        action.setCallback(this, function(res) { 
            if (res.getState() === 'SUCCESS') {
                var BillingObj = res.getReturnValue();
                component.set("v.billingPlanObj",BillingObj);
                alert(BillingObj);
            }
            else if(res.getState() === "ERROR"){
                alert('No Billing Plan is associated with Opportunity.');
            }         
        });
        $A.enqueueAction(action);    
    },
})
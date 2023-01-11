({
	loadBillingData : function(component, event, helper) {
        var action = component.get('c.getBillingPlanDetails');
        var billingPlanValue = component.get("v.billingPlanId");
        action.setParams({
            bpID : billingPlanValue           
        });
        action.setCallback(this, function(res) { 
            this.handleCallback(component, event, helper,res);                     
        });
        $A.enqueueAction(action);  
    },
    handleCallback : function(component, event, helper,res){
        if (res.getState() === 'SUCCESS') {
            var result = res.getReturnValue();
            var resultValue = JSON.stringify(result);
            var bilList =[]; 
            if(!$A.util.isEmpty(resultValue) && !$A.util.isUndefined(resultValue)){
                component.set("v.bpList",result);              
            }     
            var bilList = component.get("v.bpList");         
            component.set('v.bpliList', bilList[0].bplitemList);
        }
    },
     navigateToObj : function (component, event, helper,recId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recId,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
})
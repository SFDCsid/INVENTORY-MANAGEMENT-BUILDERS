({
    doInit : function(component, event, helper) {
        console.log('parent call 11');
        var fieldValue = component.get('v.recordId');
        component.find('input_field_Opp').set('v.value', fieldValue);
    },
    handleSuccess : function(component, event, helper) {
        var BillingPlanObjId = event.getParams().response;
        console.log(BillingPlanObjId.id);
        helper.navigatetoLineItem(component, event, helper,BillingPlanObjId.id);  
    }, 
    
    cancel : function(component, event, helper){
       
        helper.navigatebackToOpportunity(component, event, helper);
       }
    /* callSaveComp : function(component, event, helper){
        console.log('callSaveComp11');
        helper.saveBillingPlan(component, event, helper);
       var evt = $A.get("e.force:navigateToComponent");
        console.log('Event '+evt);
        var billingPlanObjValue = component.get("v.billingplan");
        evt.setParams({
            componentDef  : "c:ParentCustomizedPaymentPlan" ,
            componentAttribute : {
                billingObj : billingPlanObjValue,
                oppId : component.get('v.recordId')
            }
        });
        evt.fire(); 
    },*/
})
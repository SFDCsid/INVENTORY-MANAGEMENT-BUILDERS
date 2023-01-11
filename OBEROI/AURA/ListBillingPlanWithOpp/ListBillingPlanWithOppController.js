({
    doInit : function(component, event, helper) {
        var oppIdValue = component.get('v.recordId');
        helper.fetchBillingPlans(component,event,helper,oppIdValue);
    },
    handleRadioGroupChange : function(component, event, helper){
        alert('check');
    }
})
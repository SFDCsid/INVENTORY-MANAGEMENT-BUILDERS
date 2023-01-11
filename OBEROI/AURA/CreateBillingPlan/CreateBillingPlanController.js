({
    doInit : function(component, event, helper) {
        console.log('Final');
        var fieldValue = component.get('v.recordId');
        component.find('input_field_Opp').set('v.value',fieldValue);
        helper.fetchOppDetails(component,event,helper);  
    },
    handleSubmit :  function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        var projectVal = component.find('input_project').get('v.value');
        console.log(projectVal);
        var towId = component.find('input_tower').get('v.value');
        eventFields["Tower__c"] = towId;
        //  eventFields["Tower__c"] = "Test Value";
        component.find('myform').submit(eventFields);
    },
    handleSuccess : function(component, event, helper) {
        var BillingPlanObjId = event.getParams().response;
        console.log('BillingPlanObjId',BillingPlanObjId.id);
        console.log('project',BillingPlanObjId.Project__c);
        helper.navigatetoLineItem(component, event, helper,BillingPlanObjId.id);  
    }, 
    fetchTower : function(component, event, helper) {
        helper.fetchTowerValues(component, event, helper);
        
        //  debugger;
        //alert(projectVal);
        //  component.find('input_tower').set('v.value',dataValu);
        //   console.log(towValue);
    },
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
    cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire()
    }
})
({
    // Fetch the scanners from the Apex controller
    /*	getMetaDataList: function(component) {
          console.log('in action');
         // this.getHealthResultList(component);
        var action = component.get('c.getScannersMetaData');
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.metadataList',actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
         
      }*/
    saveBillingPlan :function(component, event, helper){
        console.log('saveBillingPlantest1111');
        var billingPlanObj = component.get("v.billingplan");
        console.log('@@billingPlanObj'+billingPlanObj);
        var action = component.get('c.saveBillingPlan');
        action.setParams({
            ppObj : billingPlanObj,
            oppId : component.get("v.recordId")          
        });
        action.setCallback(this, function(res) { 
            helper.handleCallback(component, event, helper,res);                     
        });
        $A.enqueueAction(action);  
    },
    handleCallback : function(component, event, helper,res){
        console.log('state'+res.getState());
        if (res.getState() === 'SUCCESS') {
            console.log('In');
            var bpId = res.getReturnValue();
              console.log('re11'+ bpId);
           	 helper.navigatetoLineItem(component, event, helper,bpId);  
        } 
        else if(res.getState() === "ERROR"){
            alert('Please add Default Payment Plan.');
        }
    },
    navigatetoLineItem : function(component, event, helper,bpId){
        console.log('bpId'+bpId);
        var fieldValue = component.get('v.recordId');
    var evt = $A.get("e.force:navigateToComponent");
        console.log('Event '+evt);
        var billingPlanObjValue = component.get("v.billingplan");
        evt.setParams({
            componentDef  : "c:ParentCustomizedPaymentPlanV1" ,
            componentAttributes : {
                billingPlanId : bpId
            }
        });
        evt.fire();
},
    
    navigatebackToOpportunity : function(component,event,helper){
     var navEvt = $A.get("e.force:navigateToSObject");
     navEvt.setParams({
             "recordId": component.get("v.recordId") 
        });
        navEvt.fire(); 
    }
})
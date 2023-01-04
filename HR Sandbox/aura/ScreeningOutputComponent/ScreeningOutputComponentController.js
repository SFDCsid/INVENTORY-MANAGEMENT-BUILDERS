({
    init : function(component, event, helper) {
            
        helper.getRecord(component);
     },
        handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Record updated successfully.",
            "type": 'success'
        });
        toastEvent.fire();
        	component.set('v.showEditable', false);
    },
    editMethod : function(component, event, helper) {
        	component.set('v.showEditable', true);
            console.log('showEditable::true');
    },
    cancelMethod : function(component, event, helper) {
        	component.set('v.showEditable', false);
        console.log('showEditable::false');
    },
    
    acceptMethod : function(component, event, helper) {
         
        console.log('AcceptMethod');
        
        var hideModal = component.get('v.showModal');
        component.set('v.showModal', !hideModal);
        
        var action =component.get("c.acceptScreeningInfo");
        var rec =component.get("v.screeningId");
        action.setParams({"recordId" : rec});
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if (state === "SUCCESS") {
                alert(response.getReturnValue());
                if(response.getReturnValue()){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Screening Accepted Successfully.",
            "type": 'success'
        });
        toastEvent.fire(); 
                    $A.get('e.force:refreshView').fire(); 
                }else{
                     var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Please add vacancy.",
            "type": 'error'
        });
        toastEvent.fire();
                         
                }
             }else{ 
          var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Failed to update status.",
            "type": 'error'
        });
        toastEvent.fire();
                         
            }
        });
       
        $A.enqueueAction(action);  
    },
    rejectMethod : function(component, event, helper) {
          //	component.set('v.showEditable', true);
        console.log('RejectMethod');
          
     var hideModal = component.get('v.showModal2');
        component.set('v.showModal2', !hideModal);  
       var action =component.get("c.rejectScreeningInfo");
        var rec =component.get("v.screeningId");
        action.setParams({"recordId" : rec});
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Screening Rejected Successfully.",
            "type": 'success'
        });
        toastEvent.fire();
                    $A.get('e.force:refreshView').fire(); 
                }else{
                     var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Failed to update status.",
            "type": 'error'
        });
        toastEvent.fire();
                         
                }
             }else{ 
          var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Failed to update status.",
            "type": 'error'
        });
        toastEvent.fire();
                         
            }
        });
       
        $A.enqueueAction(action);    
    },
     handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
      showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
    
    openConfirmDialog : function(component, event, helper) {
        var showModal = component.get('v.showModal');
        component.set('v.showModal', !showModal);
    },
    openRejectDialog : function(component, event, helper) {
        var showModal = component.get('v.showModal2');
        component.set('v.showModal2', !showModal);
    },
    closeModal : function(component, event, helper) {
        var showModal = component.get('v.showModal');
        component.set('v.showModal', !showModal);
    },
    closeModal2 : function(component, event, helper) {
        var hideModal = component.get('v.showModal2');
        component.set('v.showModal2', !hideModal);
    }
})
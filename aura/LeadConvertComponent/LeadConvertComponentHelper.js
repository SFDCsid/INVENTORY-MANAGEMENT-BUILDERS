({
	convertMethod : function(component) {
		
         var action = component.get("c.convertSelectedLead");  
         var rec =component.get("v.recordId");
         action.setParams({"recordId" : rec});
         action.setCallback(this, function(response){
                
             var state = response.getState();
             if (state === "SUCCESS") {
                  
                 if(response.getReturnValue()!= null) {
                     //alert('Lead is converted sucessfully.');
                      var responseVal = response.getReturnValue();
                      if(responseVal.isSuccess){
                     var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                         title : 'Success',
                         message: responseVal.message,
                         duration:' 5000',
                         key: 'info_alt',
                         type: 'success',
                         mode: 'pester'
                     });
                     toastEvent.fire();
                     var dismissActionPanel = $A.get("e.force:closeQuickAction");
                 dismissActionPanel.fire();
                     var navEvt = $A.get("e.force:navigateToSObject");
                     navEvt.setParams({
                         "recordId": responseVal.redirectId,
                     });
                     
                     navEvt.fire();
                 }else {
 
                 //alert('Error occurred while converting lead. '+response.getState());
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     title : 'Error',
                     message:  responseVal.message,
                     duration:' 5000',
                     key: 'info_alt',
                     type: 'error',
                     mode: 'pester'
                 });
                 toastEvent.fire();
                 var dismissActionPanel = $A.get("e.force:closeQuickAction");
                 dismissActionPanel.fire();
             }
                 }
             } else {
                 var responseVal = response.getReturnValue();
                     alert('isSuccess::'+responseVal.isSuccess);
                 //alert('Error occurred while converting lead. '+response.getState());
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     title : 'Error',
                     message:  responseVal.message,
                     duration:' 5000',
                     key: 'info_alt',
                     type: 'error',
                     mode: 'pester'
                 });
                 toastEvent.fire();
                 var dismissActionPanel = $A.get("e.force:closeQuickAction");
                 dismissActionPanel.fire();
             }
		});
        $A.enqueueAction(action);
	}
})
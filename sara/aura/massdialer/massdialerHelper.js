({
	callmethod : function(component, event, helper) { 
        var action = component.get("c.readCall");  
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var call = response.getReturnValue();
               // component.set("v.callstatus", response.getReturnValue());
                component.set("v.recordId",call.Id);
            }  
            setTimeout(function(){  helper.callmethod(component, event, helper) }, 2000);
        });
        $A.enqueueAction(action);
    },showToast : function(component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Success!",
        "message": "The record has been added successfully."
    });
    toastEvent.fire();
},nextDial: function(component, event, helper) { 
        
         var ids = component.get('v.items');
         var recordId = component.get('v.recordId');
         for(var i=0;i<ids.length;i++){
             if(ids[i].Id == recordId ){  
                 if(ids.length > i+1){
                     component.set('v.recordId', ids[i+1].Id  ); 
                     component.find('editform').set('v.mode','edit');
                      
                 } 
                
             }
            
         }  
        
    },
    
    
    
})
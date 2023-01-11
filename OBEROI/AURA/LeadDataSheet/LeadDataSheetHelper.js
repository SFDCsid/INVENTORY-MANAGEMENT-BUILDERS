({
    showLeadSheet : function(component, event, helper) {
        var action = component.get('c.getLeadDetails');
        var leadId = component.get("v.recordId");
        action.setParams({
            recId : leadId            
        });
        action.setCallback(this, function(res) { 
            helper.handleCallback(component, event, helper,res);             
            $A.get("e.force:closeQuickAction").fire();
            // $A.get('e.force:refreshView').fire();             
        });
        $A.enqueueAction(action);  
    },
    
    
    handleCallback : function(component, event, helper,res){
        if (res.getState() === 'SUCCESS') {
            var result = res.getReturnValue();
            if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                alert('done'); 
                var attId = res.getReturnValue();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": attId
                });
                navEvt.fire();
            }
            
        } 
        else if(res.getState() === "ERROR"){
            alert('Please add Default Payment Plan.');
        }
    },
})
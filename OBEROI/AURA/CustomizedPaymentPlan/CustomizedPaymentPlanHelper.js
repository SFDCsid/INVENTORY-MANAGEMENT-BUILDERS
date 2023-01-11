({
    loadPropDetailsData : function(component, event, helper) {
        var action = component.get('c.getOfferDetails');
        var oppId = component.get("v.recordId");
        action.setParams({
            recId : oppId            
        });
        action.setCallback(this, function(res) { 
            helper.handleCallback(component, event, helper,res);             
            //$A.get("e.force:closeQuickAction").fire();
            // $A.get('e.force:refreshView').fire();             
        });
        $A.enqueueAction(action);  
    },
    
     createObjectData: function(component, event,helper) {
        // get the contactList from component and add(push) New Object to List  
        var RowItemList = component.get("v.ppList");
        var ids= event.getParam("indexVar") +1;
        console.log('event.getParam("indexVar")'+ids);
        RowItemList.push({            
            'Id': '',
            'Order': ''
        });
        // set the updated list to attribute (contactList) again    
        component.set("v.ppList", RowItemList);
    },
    
    
    
    handleCallback : function(component, event, helper,res){
        if (res.getState() === 'SUCCESS') {            
            
            var result = res.getReturnValue();
            
            if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                component.set("v.ppList",result);                                
                console.log(component.get("v.ppList")+' **ppDetails');
                
            }
        } else if(res.getState() === "ERROR"){
            alert('Error in calling server side action');
        }
    },
})
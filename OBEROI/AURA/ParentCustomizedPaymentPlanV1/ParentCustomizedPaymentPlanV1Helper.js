({
    createObjectData: function(component, event,helper) {
        // get the contactList from component and add(push) New Object to List  
        var RowItemList = component.get("v.finalMList");
        var addRow = helper.checkMaxLimit(component, event, helper);
        if(addRow == true){
        var rowIndex = event.currentTarget.parentElement.parentElement.id ;
        rowIndex++;
        RowItemList.splice(rowIndex,0,{            
            'Name': '',
            'Description': ''
        });
        // set the updated list to attribute (Line Item) again  
        component.set("v.finalMList", RowItemList);
        }
        else{
            alert('Limit exceed');
        }
    },
    
    checkMaxLimit : function(component, event, helper) {
    },
    
    loadPropDetailsData : function(component, event, helper) {
        var action = component.get('c.getBillingPlanDetails');
        var billingPlanValue = component.get("v.billingPlanId");
        console.log('@@billingPlanValue'+billingPlanValue);
        action.setParams({
            bpID : billingPlanValue            
        });
        action.setCallback(this, function(res) { 
            helper.handleCallback(component, event, helper,res);                     
        });
        $A.enqueueAction(action);  
    },
    
    
    handleCallback : function(component, event, helper,res){
        if (res.getState() === 'SUCCESS') {
            var result = res.getReturnValue();
            var resultValue = JSON.stringify(result);
            var milList =[]; 
            if(!$A.util.isEmpty(resultValue) && !$A.util.isUndefined(resultValue)){
                component.set("v.ppList",result);              
            }     
            var milList = component.get("v.ppList");         
            component.set('v.finalMList', milList[0].bplitemList);
            console.log('@@metadata'+JSON.stringify(milList[0].metadataGroupingList));
            component.set('v.metadata',milList[0].metadataGroupingList);
        }/*
        else if(res.getState() === "ERROR"){
            alert('Please add Default Payment Plan.');
        }*/
    },
    
    //For Save oppty is working as expected mnList needs to check
    saveData : function(component, event, helper) {
        var action = component.get('c.saveWrapperDetails');
        var mList = [];
        mList = component.get("v.finalMList");
     //   var oppDetails =[];
      //  oppDetails = component.get("v.ppList");
        
    //   console.log(JSON.stringify(mList[0].mnsList)	+'oppDetails');
  //  console.log('AdityaBhasin');
       action.setParams({
           billingPlanId : component.get("v.billingPlanId"),
           bpLineList : mList           
        });
        
        action.setCallback(this, function(res) { 
            helper.handleCallbackForSave(component, event, helper,res);
            alert(res.getReturnValue());
                       
        });
        $A.enqueueAction(action);  
    },
    
    handleCallbackForSave : function(component, event, helper,res){
        if (res.getState() === 'SUCCESS') {
            var result = res.getReturnValue();
            helper.navigateToPlan(component, event, helper);
          //  alert(result);
            if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                //component.set("v.ppList",result);              
            }
       //  alert('Done');
        } 
        else if(res.getState() === "ERROR"){
            console.log(res.getReturnValue()+'%%');
            alert('Error in Server calling action.');
        }
    },
    navigateToPlan : function (component, event, helper) {
    var navEvt = $A.get("e.force:navigateToSObject");
    navEvt.setParams({
      "recordId": component.get("v.billingPlanId"),
      "slideDevName": "detail"
    });
    navEvt.fire();
	},
    
    deleteBillingPlan: function(component, event, helper){
         var action = component.get('c.deleteBillingPlanOnCancel');
         action.setParams({
           ppObj : component.get("v.billingPlanId")
                     
        });
         action.setCallback(this, function(res) { 
             if (res.getState() === 'SUCCESS') {
             var navEvt = $A.get("e.force:showToast");
                 toastEvent.setParams({
                   "title": "Success!",
                    "message": "Billing Plan has been Deleted successfully."
    });
         navEvt.fire(); 
             }                   
        });
          $A.enqueueAction(action); 
        
    }
    
    
    
    
})
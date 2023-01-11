({
    createObjectData: function(component, event,helper) {
        // get the contactList from component and add(push) New Object to List  
        var RowItemList = component.get("v.finalMList");
        var rowIndex = event.currentTarget.parentElement.parentElement.id ;
        rowIndex++;
        RowItemList.splice(rowIndex,0,{            
            'Name': '',
            'Description': ''
        });
        // set the updated list to attribute (Line Item) again  
        component.set("v.finalMList", RowItemList);
    },
    checkPercLimit : function(component, event, helper) {
        var RowItemList = component.get("v.finalMList");
        var target = event.getSource();  
        console.log(RowItemList.length);
        for(var PercentageSum = 0, j = 0; j < RowItemList.length; j++){
            //  alert(RowItemList[j].Percentage_Of_Value_To_Be_Invoiced__c);
            PercentageSum += parseFloat(RowItemList[j].Percentage_Of_Value_To_Be_Invoiced__c);
        }
        console.log(PercentageSum);
        if(PercentageSum > 100){
            // alert('Percentage Exceed');
            target.set("v.errors", [{message:"Total % is greater than 100"}]);
        }
        else{
            target.set("v.errors", null);   
        }
    },
    checkMaxLimit : function(component, event, helper) {
        console.log('Check limit');
        var RowItemList = component.get("v.finalMList");
        var target = event.getSource();  
        var txtVal = target.get("v.value") ;
        //  alert(txtVal);
        //    var NameValue = event.getParam("value"); 
        var milList = component.get("v.metadata"); 
        //  alert(JSON.stringify(milList));
        var maxCount;
        
        for (var i = 0; i < milList.length; i++) {
            
            if(milList[i].Detailed_Description__c==txtVal){
                maxCount= milList[i].Max_Occurance__c;
                break;
            }
        }
        //  alert(maxCount);
        var count = 0;
        for (var j = 0; j < RowItemList.length; j++) {
            if(RowItemList[j].Payment_Plan_Line_Item_Name__c == txtVal){
                count++;
            }
        }
        //  alert(count);
        if( count > maxCount){
            //alert('Limit exceed');
            target.set("v.errors", [{message:"Limit Exceed"}]);
        } 
        else{
            target.set("v.errors", null);   
        }
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
            //   alert(res.getReturnValue());
            
        });
        $A.enqueueAction(action);  
    },
    
    handleCallbackForSave : function(component, event, helper,res){
        if (res.getState() === 'SUCCESS') {
            var result = res.getReturnValue();
            if(result==true){
                helper.navigateToObj(component, event, helper,component.get("v.billingPlanId"));
            }
            else{
                alert('Property is not related to Tower!!');
            }
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
    navigateToObj : function (component, event, helper,recId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recId,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    navigateToOpp : function (component, event, helper) {
        var action = component.get('c.deleteBillingPlanOnCancel');
        action.setParams({
            ppObj : component.get("v.billingPlanId")
            
        });
        action.setCallback(this, function(res) { 
            if (res.getState() === 'SUCCESS') {
                //   alert('Success');
                helper.navigateToObj(component, event, helper,component.get("v.oppId"));
            }                   
        });
        $A.enqueueAction(action); 
    },
    loadBillingPlanObj : function(component, event, helper) {
        console.log('y11');
        var action = component.get("c.BillingPlanObj");
        action.setParams({ bpId : component.get("v.billingPlanId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            alert(state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                alert(result);
                var output =component.set('v.billingplan',result);
            }
            else if (state === "ERROR") {
            }
        });
        $A.enqueueAction(action); 
    },
})
({
    createObjectData: function(component, event,helper) {
        // get the contactList from component and add(push) New Object to List  
        //  alert('Test 11');
        var RowItemList = component.get("v.finalMList");
        var rowIndex = event.currentTarget.parentElement.parentElement.id ;
        console.log('rowIndex',rowIndex);
        var txtVal = RowItemList[rowIndex].Payment_Plan_Line_Item_Name__c;
        var maxLimitCheck =  this.checkMaxLimit(component, event, helper, txtVal);
        // alert(maxLimitCheck);
        /*  if(rowIndex==undefined || rowIndex=='' || rowIndex==null){
            RowItemList.push({            
                'Order__c': '',
                'Payment_Plan_Line_Item_Name__c': '',
                'Line_Item_Type__c':'Time Linked',
                'Due_After_Days__c':'',
                'Percentage_Of_Value_To_Be_Invoiced__c':''
            });
        }
        else{ */
        if(maxLimitCheck == true){
          //  var addkey =1;
           // var selectedPaymentKey = RowItemList[rowIndex].Terms_of_Payment_Key__c;
            //   alert('selectedPaymentKey'+selectedPaymentKey);
            //var selectedpaymentGroup = selectedPaymentKey.slice(0, 3);
            //   alert('selectedpaymentGroup'+selectedpaymentGroup);
            //var paymentGroupCount = [];
            //for(var i=0; i<RowItemList.length; i++){
              //  var loopPaymentKey = RowItemList[i].Terms_of_Payment_Key__c;
                //   alert('loopPaymentKey'+loopPaymentKey);
                // var loopPaymentGroup = loopPaymentKey.slice(0, 3);
                //  alert('loopPaymentGroup'+loopPaymentGroup);
                //if(loopPaymentGroup==selectedpaymentGroup){
                  //  var loopPaymentGroupCount = loopPaymentKey.substr(loopPaymentKey.length - 1);
                    //   alert('loopPaymentGroupCount'+loopPaymentGroupCount);
                    //paymentGroupCount.push(loopPaymentGroupCount);
                //}
            //}
            //var maxValue = Math.max.apply( Math, paymentGroupCount);
            //    alert('maxValue'+maxValue);
            //var toAddCount = parseInt(maxValue)+parseInt(addkey);
            //var keyToAdd = selectedpaymentGroup+toAddCount;
            //   console.log('txtVal',txtVal);
            rowIndex++;
            RowItemList.splice(rowIndex,0,{            
                'Order__c': '',
                'Payment_Plan_Line_Item_Name__c': txtVal,
                'Line_Item_Type__c':'Time Linked',
                'Due_After_Days__c':'',
                'Percentage_Of_Value_To_Be_Invoiced__c':''
            });
            // set the updated list to attribute (Line Item) again  
            //   alert('set list');
            component.set("v.finalMList", RowItemList);
        }
        //    alert('checkmax');
        
        //   alert('Out');
        //    }
    },
    checkPercLimit : function(component, event, helper,targetValue,keyid) {
        var RowItemList = component.get("v.finalMList");
        var PercentageSum = 0;
        for(var j = 0; j < RowItemList.length; j++){
            //  alert('before',RowItemList[j].Percentage_Of_Value_To_Be_Invoiced__c);
            if(RowItemList[j].Percentage_Of_Value_To_Be_Invoiced__c == undefined){
                //   alert('Percentage field is mandatory');
            }
            else{
                PercentageSum += parseFloat(RowItemList[j].Percentage_Of_Value_To_Be_Invoiced__c);
            }
        }
        RowItemList[keyid].Percentage_Of_Value_To_Be_Invoiced__c = targetValue;
        component.set("v.finalMList",RowItemList);
        PercentageSum = PercentageSum + parseInt(targetValue);
        if(PercentageSum != 100.00){
            this.showToast(component, event, helper,'Percentage is not equal to 100%', 'warning','pester');
            this.calcAmountVal(component, event, helper);
        }
        else{
            this.calcAmountVal(component, event, helper);
        }
    },
    calcAmountVal : function(component, event, helper){
        var target = event.target.id;  
        var targetValue = event.target.value;  
        var clickId = target;		//0-perBSP
        var len = clickId.length;   //8
        var index = clickId.indexOf("-");
        var keyid = clickId.substr(0,(index));
        var totalCostPlan=component.get('v.billingplan');
        var totalCost = totalCostPlan[0].Total_Sales_Amount__c;
        var perAmount = (totalCost/100)*targetValue;
        var roundPerAmount = parseFloat(perAmount).toFixed(2);
        document.getElementById(keyid+"-amountBSP").value= roundPerAmount;  
        var RowItemList = component.get("v.finalMList");
        //  alert('after ',RowItemList[1].Percentage_Of_Value_To_Be_Invoiced__c);
    },
    checkMaxLimit : function(component, event, helper, txtVal) {
        //   alert('max');
        var RowItemList = component.get("v.finalMList");
        //  var target = event.getSource();  
        // var txtVal = target.get("v.value") ;
        //  alert(RowItemList);
        console.log(txtVal);
        var milList = component.get("v.metadata"); 
        var maxCount;
        for (var i = 0; i < milList.length; i++) {
            if(milList[i].Detailed_Description__c==txtVal){
                maxCount= milList[i].Max_Occurance__c;
                break;
            }
            else if(txtVal=='To be paid on or Before'){
                maxCount=5;
                break;
            }
        }
        console.log(maxCount);
        var count = 0;
        for (var j = 0; j < RowItemList.length; j++) {
            if(RowItemList[j].Payment_Plan_Line_Item_Name__c == txtVal){
                count++;
            }
        }
        console.log(count);
        if( count >= maxCount){
            //  target.set("v.errors", [{message:"Limit Exceed"}]);
            this.showToast(component, event, helper,'Limit Exceed for Line Item--.'+txtVal, 'error','dismissible');
            return false;
        } 
        else{
            // target.set("v.errors", null);   
            return true;
        }
    },
    checkMinLimit : function(component, event, helper, txtVal) {
	//	alert('Min Call');
        var RowItemList = component.get("v.finalMList");
        console.log(txtVal);
        var milList = component.get("v.metadata"); 
        var minCount;
        for (var i = 0; i < milList.length; i++) {
            if(milList[i].Detailed_Description__c==txtVal){
                minCount= milList[i].Min_Occurence__c;
                break;
            }
            else if(txtVal=='To be paid on or Before'){
                minCount=1;
                break;
            }
        }
        console.log(minCount);
        var count = 0;
        for (var j = 0; j < RowItemList.length; j++) {
            if(RowItemList[j].Payment_Plan_Line_Item_Name__c == txtVal){
                count++;
            }
        }
        console.log('count');
          console.log(count);
        if( count == minCount){
            //  target.set("v.errors", [{message:"Limit Exceed"}]);
            this.showToast(component, event, helper,'You cannot delete this line item.', 'error','dismissible');
            return false;
        } 
        else{
            return true;
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
            this.handleCallback(component, event, helper,res);                     
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
        }
    },
    
    //To Save Billing Plan Line Items 
    saveData : function(component, event, helper) {
        //  alert('Save 111 ');
        var mList = [];
        mList = component.get("v.finalMList");
        console.log(JSON.stringify(mList));
        //  alert(mList.length);
        var i=1;
        for(var j = 0; j < mList.length; j++){
            //  alert('j'+j);
            //  alert('j+1'+j+1);
            //   alert('Add-->'+parseInt(j)+1);
            // alert('Before'+mList[j].Sequence_Number__c);
            
            mList[j].Sequence_Number__c=parseInt(j)+parseInt(i);
            //  alert('After'+mList[j].Sequence_Number__c);
            // alert( mList[i].Sequence_Number__c);
            //alert(j);
            //   alert('j+1 after'+j+1);
            // alert('@@'+mList[j].Sequence_Number__c);
        }
        
        //  alert('mList'+JSON.stringify(mList)); 
        var action = component.get('c.saveWrapperDetails');
        action.setParams({
            billingPlanId : component.get("v.billingPlanId"),
            bpLineList : mList           
        });
        action.setCallback(this, function(res) { 
            helper.handleCallbackForSave(component, event, helper,res);          
        });
        $A.enqueueAction(action);  
    },
    
    handleCallbackForSave : function(component, event, helper,res){
        //  alert('Call');
        if (res.getState() === 'SUCCESS') {
            var result = res.getReturnValue();
            //    alert(result);
            if(result=='Missing Fields'){
                this.showToast(component, event, helper,'Please enter all required fields: Name,Percentage & Due After Days', 'error','dismissible');
                //  alert('Please enter all required fields: Name,Percentage & Due After Days');
            }
            else if(result=='Percentage zero'){
                this.showToast(component, event, helper,'Percentage value cannot be 0%.', 'error','dismissible');
                // alert('Percentage cannot be more than 100 %');
            }
                else if(result=='Percentage mismatch'){
                    this.showToast(component, event, helper,'Percentage is not equal to 100 %.', 'error','dismissible');
                    // alert('Percentage cannot be more than 100 %');
                }
                    else if(result=='Successful'){
                        this.showToast(component, event, helper,'Billing Plan Line Items has been updated successfully.', 'success','pester');
                        // alert('Successful');
                        this.navigateToObj(component, event, helper,component.get("v.billingPlanId"));
                    }
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
                this.navigateToObj(component, event, helper,component.get("v.oppId"));
            }                   
        });
        $A.enqueueAction(action); 
    },
    loadBillingPlanObj : function(component, event, helper) {
        var action = component.get("c.BillingPlanObj");
        action.setParams({ bpId : component.get("v.billingPlanId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var output =component.set('v.billingplan',result);
              //  this.calculateTotalAmount(component, event,helper);
            }
            else if (state === "ERROR") {
            }
        });
        $A.enqueueAction(action); 
    },
    showToast : function(component, event, helper,message, type, mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message:message,
            duration:' 5000',
            type: type,
            mode: mode
        });
        toastEvent.fire();
    },
})
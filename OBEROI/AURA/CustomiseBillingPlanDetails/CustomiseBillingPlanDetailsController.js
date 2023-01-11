({
    // function call on component Load
    doInit: function(component, event, helper) { 
      console.log('test11');
     //  alert('ma');
        helper.loadPropDetailsData(component, event,helper);
        helper.loadBillingPlanObj(component, event,helper);
    },
    
    // function for save the Records 
    Save: function(component, event, helper) {
        component.find("editForm").submit();
     //   alert('Save');
        helper.saveData(component, event,helper);      
    },
    // function for create new object Row in Contact List 
    AddNewRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute        
        var rowIndex = event.currentTarget.parentElement.parentElement.id;
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
        
       
        
    },
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute 
        var rowIndex = event.currentTarget.parentElement.parentElement.id;
        console.log("Row No : " + rowIndex);
        var AllRowsList = component.get("v.finalMList");
        var txtVal = AllRowsList[rowIndex].Payment_Plan_Line_Item_Name__c;
        var checkMin = helper.checkMinLimit(component, event, helper, txtVal);
       // alert('checkMin'+checkMin);
        if(checkMin == true){
            AllRowsList.splice(rowIndex, 1);
        	component.set("v.finalMList", AllRowsList);
        }
    },
    calculateMax: function(component, event, helper) {
        console.log('Check 11');
     
        helper.checkMaxLimit(component, event, helper);
    },
    calculatePerc: function(component, event, helper) {
        console.log('Check perc');
        helper.checkPercLimit(component, event, helper);
    },
    Cancel: function(component, event, helper) {
        helper.navigateToObj(component, event, helper,component.get("v.billingPlanId"));
    },
  
    calculateBSP: function(component, event, helper){
        var target = event.target.id;  
         var clickId = target;	
        var len = clickId.length;   //8
        var index = clickId.indexOf("-");
        var keyid = clickId.substr(0,index);
        var targetValue = event.target.value;  
        helper.checkPercLimit(component, event, helper,targetValue,keyid);
         var RowItemList = component.get("v.finalMList");
        console.log(JSON.stringify(RowItemList));
        console.log(RowItemList[1].Percentage_Of_Value_To_Be_Invoiced__c);
      
    },  
})
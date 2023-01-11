({
    
    // function call on component Load
    doInit: function(component, event, helper) { 
        console.log('C');
        helper.loadBillingPlanObj(component, event,helper);
        helper.loadPropDetailsData(component, event,helper);
    },
    
    // function for save the Records 
    Save: function(component, event, helper) {
        console.log('Check 11');
        component.find("editForm").submit();
        helper.saveData(component, event,helper);      
    },
    
    /* // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        //alert(index);        
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.ppList");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.ppList", AllRowsList);
    },*/
    
    // function for create new object Row in Contact List 
    AddNewRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute        
        var rowIndex = event.currentTarget.parentElement.parentElement.id   ;
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute 
        var rowIndex = event.currentTarget.parentElement.parentElement.id   ;
        console.log("Row No : " + rowIndex);
        
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.finalMList");
        AllRowsList.splice(rowIndex, 1);
        // set the contactList after remove selected row element  
        component.set("v.finalMList", AllRowsList);
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
        helper.navigateToOpp(component, event, helper);
    },
    calculateBSP: function(component, event, helper){
        alert('aaee');
         var target = event.getSource();  
        var txtVal = target.get("v.value") ;
        alert(txtVal);
       var basicCostValue=component.get('v.billingplan');
        var basicCost=basicCostValue[0].Basic_Cost_Formula__c;
        component.set("v.amount",basicCost);
        alert(basicCost);
      //  var value=component.find("amounntBSP");
       // alert(value);
        //alert(value.get("v.value"));
    },
    calculateFSL: function(component, event, helper){
        
    }
})
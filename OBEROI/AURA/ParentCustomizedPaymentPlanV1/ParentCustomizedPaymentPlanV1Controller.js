({
    
    // function call on component Load
    doInit: function(component, event, helper) { 
        console.log('Child component 1111');
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
    
    cancel: function(component, event, helper){
       // var BPId : component.get("v.billingPlanId");
        helper.deleteBillingPlan(component, event, helper);
        
        
        
    }
})
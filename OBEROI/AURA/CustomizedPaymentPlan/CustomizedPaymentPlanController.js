({
    loadPropDetails : function(component, event, helper) {
        helper.loadPropDetailsData(component, event, helper);
    },
     AddNewRowee : function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
       console.log(component.get("v.ppList").oppObj+'***child**');
        component.getEvent("AddRowEvt").setParams({"indexVar" : component.get("v.newIndex") }).fire();     
    },
    
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.newIndex") }).fire();
    }, 
    
    
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        alert(index);        
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        alert(index);
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.ppList");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.ppList", AllRowsList);
    },
})
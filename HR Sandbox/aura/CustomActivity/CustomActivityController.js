({

    toggleAcitivity : function(component, event, helper) {

        // toggle ‘slds-is-open’ class to expand/collapse activity section

        $A.util.toggleClass(component.find("expId"), "slds-is-open");

    },   

})
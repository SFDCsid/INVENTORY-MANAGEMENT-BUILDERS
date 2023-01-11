({
    init : function(component, event, helper) {
        /*var elements = component.find("unitCard");
        $A.util.toggleClass(elements, "slds-hide");*/
        var pageReference = component.get("v.pageReference");
        component.set("v.refRecordId", pageReference.state.c__refRecordId);
        var action = component.get("c.getOpportunity");
        action.setParams({
            "oppId" : pageReference.state.c__refRecordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.towerList", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    viewUnits : function(component, event, helper) {
        /*var elements = component.find("unitCard");
        $A.util.toggleClass(elements, "slds-show");*/
        var towerId = event.target.dataset.id;
        //alert("towerId=>"+towerId);
        
        var action = component.get("c.getunits");
        action.setParams({
            "towerId" : towerId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.unitList", response.getReturnValue());
                component.set("v.showFloor", true);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        
        var elements = component.find("towerCard");
        $A.util.toggleClass(elements, "slds-hide");
        //alert('Outside');
        helper.viewFloor(component, event, helper);
    },

    unitDetails : function(component, event, helper) {
        var unitId = event.target.dataset.id;
        //alert("Show Unit Details"+unitId);
        var action = component.get("c.getunit");
        component.set("v.selectedUnitId", unitId);
        action.setParams({
            "unitId" : unitId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Unit", response.getReturnValue());
                //alert("Unit Details:-"+response.getReturnValue());
                component.set("v.showUnit", true);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    
    openQuotation : function(component, event, helper) {
        var optyId = component.get('v.refRecordId');
        var unitId = component.get('v.selectedUnitId');
        window.open('/apex/Quotation?&unitId='+unitId+'&oppId='+optyId,'_blank');
    },
    
    openBlock : function(component, event, helper) {
        var optyId = component.get('v.refRecordId');
        var unitId = component.get('v.selectedUnitId');
        window.open('/apex/BlockingPage?&unitid='+unitId+'&optyid='+optyId+'&action=Blocked','_blank');
    },
    
})
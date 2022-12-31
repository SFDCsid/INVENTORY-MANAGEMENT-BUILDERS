({
    getDetails : function(component, event, helper, payload) {
       if(payload.User_Id__c == $A.get( "$SObjectType.CurrentUser.Id" )){
              component.set('v.displayCall', true); 
            if(payload.Record_Id__c != undefined && payload.Record_Id__c != null){
                    component.set('v.recordId', payload.Record_Id__c); 
                    component.set('v.objectName', payload.ObjectName__c); 
                 
                    component.set('v.displayCall', true);
            } 
            helper.openUtility(component, event, helper);
           
        }
    },
    
    openUtility : function(component, event, helper) {
        var utilityAPI = component.find("utilitybar");
        var utilityId = utilityAPI.getEnclosingUtilityId();
        utilityAPI.openUtility(utilityId);
    },
    
    closeUtility : function(component, event, helper) {
        var utilityAPI = component.find("utilitybar");
        var utilityId = utilityAPI.getEnclosingUtilityId();
        utilityAPI.minimizeUtility();
    },
    
    reset : function(component, event, helper) {
        helper.closeUtility(component, event, helper);
        component.set('v.displayCall', false);
        component.set('v.recordId', '');
    },
    
    openOverlay : function(component, event, helper, objectName, header) {
        var modalBody;
        $A.createComponent("c:LeadGeneration", {
            objectName: objectName,
            header: header,
            isModalOpen: true,
            recordId: "anything",
            isSales: component.get("v.isSales"),
            isIncomingCall : true,
            mobileNumber: component.get("v.mobileNumber"),
            source: component.get("v.source"),
            subSource : component.get("v.subSource"),
            project: component.get("v.project")
        },
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       header: "Application Confirmation",
                                       body: modalBody,
                                       showCloseButton: true,
                                       closeCallback: function() {
                                           
                                       }
                                   })
                               }
                           });
    }
})
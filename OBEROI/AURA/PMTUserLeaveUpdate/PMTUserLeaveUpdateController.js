({
	doInit : function(component, event, helper) {
        helper.getPMTUsers(component);
        helper.getLastAssignedId(component);
	},
    saveRecords : function(component, event, helper) {
        helper.savePMTUserRecords(component);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Info Message',
            message: 'Records has been saved...',
            duration:' 3000',
            key: 'info_alt',
            type: 'info',
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
    cancel : function(component, event, helper) {
         $A.get('e.force:refreshView').fire();
    }
})
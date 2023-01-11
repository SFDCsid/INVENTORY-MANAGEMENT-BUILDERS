({
    myAction : function(component, event, helper) {  
    }, 
    cancelAction : function(component, event) {
        var recId = component.get("v.recordId");
        sforce.one.navigateToSObject(recId);
        /*var navEvt = $A.get("e.force:navigateToSObject");
 navEvt.setParams({
 recordId: "001p000000lCBxjAAG",
 });
 navEvt.fire();
       console.log(navEvt);*/
   },  
    /* 
    cancelAction : function(component,  helper) {
     var sevent = $A.get('e.force:navigateToObjectHome');

sevent.setParams({
    scope: 'Contact'
});

sevent.fire();
    }, */
    
})
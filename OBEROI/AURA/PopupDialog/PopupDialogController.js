({
   openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
   
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
      //helper.gotoURL(component);

      var urlEvent = $A.get("e.force:navigateToURL");
      urlEvent.setParams({
      "url": "/apex/ORL_Inventory"
      });
      urlEvent.fire();

   },
 
   submit: function(component, event, helper) {
      // Display alert message on the click on the "Like and Close" button from Model Footer 
      // and set set the "isOpen" attribute to "False for close the model Box.
      //alert('thanks for like Us :)');
	component.set("v.isOpen", false);
    var commentsControl = component.find("inputValue");
    console.log("commentsControl:"+commentsControl.get("v.value"));
    var leadvalue = commentsControl.get("v.value");
    console.log("leadvalueleadvalue:"+leadvalue);
    var action = component.get("c.getleadConvertprocess");
       //console.log('actionactionaction'+action);
       action.setParams({ 
           leadnumber : leadvalue
       });
       action.setCallback(this, function(res) { 
        //helper.handleCallback(component, event, helper,res);   
        console.log('Success result'+res.getReturnValue());
        console.log('Success result'+res.getState());
        var opp = res.getReturnValue();
        console.log('Opportunity'+opp);
        var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": opp,
                "slideDevName": "detail"
            });
        navEvt.fire();
        });
        $A.enqueueAction(action);  
   }
})
({
    doInit : function(component, event, helper) {
        const empApi = component.find('empApi');
        empApi.setDebugFlag(true);
        const replayId = -1; 
        empApi.subscribe('/event/CtiNotification__e', replayId, $A.getCallback(eventReceived => {
              helper.getDetails(component, event, helper, eventReceived.data.payload);        
        }))
            .then(subscription => {
            console.log('Subscribed to channel ', subscription.channel);
        });
    },
            
  navigateToRecord : function(component, event, helper) {
      var navEvt = $A.get("e.force:navigateToSObject");
      navEvt.setParams({
          "recordId": component.get('v.recordId'),
          "slideDevName": "detail"
      });
      navEvt.fire();  
      helper.reset(component, event, helper);
  },
  
   
})
({
      // Fetch the scanners from the Apex controller
    	getMetaDataList: function(component) {
          console.log('in action');
         // this.getHealthResultList(component);
        var action = component.get('c.getScannersMetaData');
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.metadataList',actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
         
      }
    })
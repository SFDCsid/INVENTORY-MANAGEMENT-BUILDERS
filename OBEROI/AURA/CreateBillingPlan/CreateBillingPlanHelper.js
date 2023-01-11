({
    // Fetch the scanners from the Apex controller
    /*	getMetaDataList: function(component) {
          console.log('in action');
         // this.getHealthResultList(component);
        var action = component.get('c.getScannersMetaData');
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.metadataList',actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
         
      }*/
    fetchOppDetails :function(component, event, helper){
        console.log('call');
        var action = component.get('c.OppProjDetailsWrapper');
        action.setParams({    
            oppID : component.get('v.recordId')
        });
        action.setCallback(this, function(res) { 
            if (res.getState() === 'SUCCESS') {
                console.log('In l');
                var TowerObj = res.getReturnValue();
                component.set("v.mapProjToTower",TowerObj[0].mapProjecttoTower);  
              //  alert(JSON.stringify(TowerObj[0].oppObj));
              //  alert(TowerObj[0].oppObj.Project__r.Name);
                component.set("v.defProj",TowerObj[0].oppObj.Project__r.Id);  
                var fieldValueProj = component.get('v.defProj');
              //  alert('fieldValueProj',fieldValueProj);
                component.find('input_project').set('v.value',fieldValueProj);
                helper.fetchTowerValues(component, event, helper);
                //   alert( component.get("v.mapProjToTower"));
            } 
            else if(res.getState() === "ERROR"){
                alert('No Tower associated with project.');
            }         
        });
        $A.enqueueAction(action);  
        
    },
    saveBillingPlan :function(component, event, helper){
        console.log('saveBillingPlantest1111');
        var billingPlanObj = component.get("v.billingplan");
        console.log('@@billingPlanObj'+billingPlanObj);
        var action = component.get('c.saveBillingPlan');
        action.setParams({
            ppObj : billingPlanObj,
            oppId : component.get("v.recordId")          
        });
        action.setCallback(this, function(res) { 
            helper.handleCallback(component, event, helper,res);                     
        });
        $A.enqueueAction(action);  
    },
    handleCallback : function(component, event, helper,res){
        console.log('state'+res.getState());
        if (res.getState() === 'SUCCESS') {
            console.log('In');
            var bpId = res.getReturnValue();
            console.log('re11'+ bpId);
            helper.navigatetoLineItem(component, event, helper,bpId);  
        } 
        else if(res.getState() === "ERROR"){
            alert('Please add Default Payment Plan.');
        }
    },
    navigatetoLineItem : function(component, event, helper,bpId){
        console.log('bpId'+bpId);
        var fieldValue = component.get('v.recordId');
        var evt = $A.get("e.force:navigateToComponent");
        console.log('Event '+evt);
        var billingPlanObjValue = component.get("v.billingplan");
        evt.setParams({
            componentDef  : "c:ParentCustomizedPaymentPlan" ,
            componentAttributes : {
                billingPlanId : bpId,
                oppId : component.get("v.recordId") 
            }
        });
        evt.fire();
    },
    fetchTowerValues : function(component, event, helper,bpId){
        console.log('fetch details final');
        var mapValues = component.get("v.mapProjToTower");
//        alert(mapValues);
        var projectVal = component.find('input_project').get('v.value');
        console.log(projectVal);
        var dataValu= mapValues[projectVal];
        component.set("v.towers",dataValu);
    },
})
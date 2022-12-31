({
	doInit : function(component, event, helper) {
       var mode = component.get('v.mode'); 
        if(mode == 'inbound'){ 
            helper.callmethod(component, event, helper);            
        }else{
            var action = component.get("c.masdialinit"); 
             action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    component.set("v.items", response.getReturnValue());
                } else {
                    console.log('Problem getting account, response state: ' + state);
                }
            });
            $A.enqueueAction(action);
            
        }
       
        
        
        
    },selectItem: function(component, event, helper) { 
        component.find('editform').set('v.mode','edit')
        component.set('v.recordId',   event.currentTarget.dataset.id );  
    },handleSubmit: function(component, event, helper) {
           event.preventDefault();       // stop the form from submitting
           component.set('v.savetype',   'Save' );  
           component.find('editform').submit();
    }
    ,handleSubmitNext: function(component, event, helper) {
           event.preventDefault();       // stop the form from submitting
           component.set('v.savetype',   'SaveNext' );  
           component.find('editform').submit();
        
    },cancelEdit: function(component, event, helper) {
           event.preventDefault();       // stop the form from submitting
          component.find('editform').set('v.mode','view')

    },nextDial: function(component, event, helper) { 
        helper.nextDial(component, event, helper); 
    },onload:function(component, event, helper) {
         
     },
    onsuccess : function(component, event, helper) {  
         var ids = component.get('v.items');
         var recordId = component.get('v.recordId');
         for(var i=0;i<ids.length;i++){
             if(ids[i].Id == recordId ){ 
                 
                 if(ids.length > i+1){  
                     component.set('v.recordId', ids[i+1].Id  ); 
                     document.getElementById(ids[i+1].Id).scrollIntoView({ behavior: 'smooth', block: 'center'});
                     var action = component.get("c.clickToCall");  
                     action.setParams({'leadId': ids[i+1].Id });
                     action.setCallback(this, function(response) {
                         component.find('editform').set('v.mode','edit');
                          
                     });
                    $A.enqueueAction(action);
                     
                 } 
                
             }
            
         }
        
        
    },onstart : function(component, event, helper) {
         var ids = component.get('v.items');
        component.set('v.recordId',ids[0].Id );
          
                 var action = component.get("c.clickToCall");  
                 action.setParams({'leadId': ids[0].Id });
                 action.setCallback(this, function(response) {
                    var state = response.getState();
                     component.find('editform').set('v.mode','edit')
                });
                $A.enqueueAction(action);
             
    }
    ,onReque : function(component, event, helper) {
             var ids = component.get('v.items');
             var item;
             var  idx 
             var recordId = event.currentTarget.dataset.id;
             for(var i=0;i<ids.length;i++){ 
                 if(recordId == ids[i].Id ){ 
                      item = ids[i];
                     idx = i;
                 }
             } 
             ids.push(item);
             if(idx){
               delete ids[idx];
             }    
             component.set('v.recordId', ids[idx+1].Id  ); 
             component.set('v.items', ids );
             helper.showToast(component, event, helper);
    }
})
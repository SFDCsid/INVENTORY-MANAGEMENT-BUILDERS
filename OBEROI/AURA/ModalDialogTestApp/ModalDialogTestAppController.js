({
    dialogCallback: function(component, event, helper) {
        var context = event.getParam('context');
        var confirmResult = event.getParam('confirmResult');
        var inputResult = event.getParam('inputResult');
        var dialogType = event.getParam('dialogType');
        console.log(event.getParams());
        component.set('v.dialogResult', confirmResult);
        component.set('v.dialogInputResult', inputResult);
        component.set('v.dialogStatus',(context)?context.action:dialogType);        
    },
    showInput: function(component, event, helper) {        
            helper.showDialog(component, 'INPUT', 
                              'INPUT DIALOG',
                              'Hello!',
                              'My Code is ',
                              'Unique Code...', 
                              {
                                  action: helper.C.ACTIONS.SHOW_INPUT
                              },
                              true);
    
    },
})
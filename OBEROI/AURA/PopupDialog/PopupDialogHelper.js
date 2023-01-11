({
	handleCallback : function(component, event, helper,res){
        if (res.getState() === 'SUCCESS') {            
            var result = res.getReturnValue();
            console.log('Success result');
        }else if(res.getState() === "ERROR"){
            alert('Error in calling server side action');
        }
    },
    gotoURL : function (component, event) {
        
    }
})
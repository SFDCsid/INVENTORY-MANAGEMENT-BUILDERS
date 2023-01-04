({
	getRecord : function(component) {
		  var rec =component.get("v.recordId");
        //component.set('v.recordId', 'a0e0w000000iHMbAAM');
         var action =component.get("c.getScreeningInfo");
        var rec =component.get("v.recordId");
        action.setParams({"recordId" : rec});
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if (state === "SUCCESS") {
                   var responseVal = response.getReturnValue();
                component.set("v.screeningId", responseVal.recordId);
                //alert(responseVal.showBtn);
                component.set("v.showBtnSection", responseVal.showBtn);
             }else{ 
                console.log("failed to fetch record");
            }
        });
       
        $A.enqueueAction(action);
	}
})
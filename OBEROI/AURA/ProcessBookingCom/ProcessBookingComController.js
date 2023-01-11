({
	doInit : function(cmp, event, action) {
        console.log('Inside doinit method');
        var Id = cmp.get("v.Id");
        console.log(Id);
        var action = cmp.get("c.processBooking");
        action.setParams({"BookingId":Id});
        
        action.setCallback(this, function(response) {
            cmp.set("v.isSuccess", response.getReturnValue());
            console.log(cmp.get("v.isSuccess"));
            cmp.set("v.msg", cmp.get("v.isSuccess"));
            
        });
        $A.enqueueAction(action);
    }
})
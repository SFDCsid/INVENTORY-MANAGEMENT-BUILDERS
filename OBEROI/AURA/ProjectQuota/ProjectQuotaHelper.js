({
    showToast : function(component, event, helper, strTitle, strmessage, strType) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'sticky',
            type : strType,
            title: strTitle,
            message : strmessage
        });
        toastEvent.fire();
    },
    
    validateDate: function(component, event, helper) {
        
    },
    
    findMonthsInDates: function(component, event, helper, dtStart, dtEnd) {
        let iTotalMonths = helper.monthDiff(new Date(dtStart), new Date(dtEnd));
        const mapMonths = { 0 : "January", 1 : "February", 2 : "March", 3 : "April", 4 : "May", 5 : "June", 6 : "July", 7 : "August", 8 : "September", 9 : "October", 10 : "November", 11 : "December" }
        let startMonth = new Date(dtStart).getMonth();
        let startYear = new Date(dtStart).getFullYear();
        var monthsData = [];
        let nextYear;
        for(var iIndex = 0; iIndex < iTotalMonths; iIndex++) {
            if(iIndex == 0) {
                monthsData.push({ label : mapMonths[startMonth] + '-' + startYear, year: startYear, month: mapMonths[startMonth], targetValue: ''});
            } else if(startMonth == 12){
                startMonth = 0;
                nextYear = startYear++;
                monthsData.push({label : mapMonths[startMonth] + '-' + nextYear, year: nextYear, month: mapMonths[startMonth], targetValue: ''});
            } else {
                monthsData.push({label : mapMonths[startMonth] + '-' + startYear, year: startYear, month: mapMonths[startMonth], targetValue: ''});
            }
            startMonth++;
        }
        component.set("v.monthsWiseProject", monthsData)
    },
    
    monthDiff: function(d1, d2) {
        debugger;
        var months;
        months = (d2.getFullYear() - d1.getFullYear()) * 12;
        months -= d1.getMonth();
        months += d2.getMonth() + 1;
        return months <= 0 ? 0 : months;
    },
    
    save: function(component, event, helper) {
        
    }
})
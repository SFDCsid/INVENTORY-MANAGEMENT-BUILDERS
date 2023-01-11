({
    onQuotaTypeChange : function(component, event, helper) {
        let actionGetProject = component.get("c.getProjectList");
        actionGetProject.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS') {
                let projectList = response.getReturnValue();
                let projectOptions = [];
                let projectWithTargetAmount = [];
                if(projectList && projectList.length > 0) {
                    for(let project in projectList) {
                        projectOptions.push({ label: projectList[project].Name, id: projectList[project].Id });
                        projectWithTargetAmount.push({ label: projectList[project].Name, id: projectList[project].Id, targetValue: '' })
                    }
                    component.set('v.options', projectOptions);
                    component.set('v.projectsWiseMonth', projectWithTargetAmount);
                } else {
                    helper.showToast(component, event, helper, 'Failed!', 'There is no Project record', 'error');
                }
            }
        });
        $A.enqueueAction(actionGetProject);
    },
    
    handleStartChange: function(component, event, helper) {
        let dtStart = component.get("v.startDuration");
        let dtEnd = component.get("v.endDuration");
        debugger;
        if(!$A.util.isEmpty(dtStart) && !$A.util.isEmpty(dtEnd)) {
            helper.findMonthsInDates(component, event, helper, dtStart, dtEnd);
        }
    },
    
    handleEndChange: function(component, event, helper) {
        let dtStart = component.get("v.startDuration");
        let dtEnd = component.get("v.endDuration");
        if(!$A.util.isEmpty(dtStart) && !$A.util.isEmpty(dtEnd)) {
            helper.findMonthsInDates(component, event, helper, dtStart, dtEnd);
        }
    },
    
    save: function(component, event, helper) {
        debugger;
        if(component.get('selectedQuota') == 'project') {
            let projId = component.find("selProject").get("v.value");
            let monthsWiseProject = component.get("v.monthsWiseProject");
			let projectWiseTargets = [];
            for(let projectData in monthsWiseProject) {
                if(!$A.util.isEmpty(monthsWiseProject[projectData].targetValue)) {
                    let projectWiseTarget = {
                        projectId : projId,
                        target : monthsWiseProject[projectData].targetValue,
                        year : monthsWiseProject[projectData].year,
                        month : monthsWiseProject[projectData].month
                    };
                    projectWiseTargets.push(projectWiseTarget);
                }
            }
        } else if(component.get('selectedQuota') == 'month') {
            let mnth = component.find("selMonth").get("v.value");
            let yr = new Date().getFullYear();
            let monthWiseTargets = [];
            var monthWiseProjects = component.get("v.projectsWiseMonth");
            for(let projectData in monthWiseProjects) {
                if(!$A.util.isEmpty(monthWiseProjects[projectData].targetValue)) {
                    let monthWiseTarget = {
                        projectId : monthWiseProjects[projectData].id,
                        target : monthWiseProjects[projectData].targetValue,
                        year : yr,
                        month : mnth
                    };
                    monthWiseTargets.push(monthWiseTarget);
                }
            }
            console.log(dataList[0].id + "---" + monthWiseTargets);
        }
        
    }
})
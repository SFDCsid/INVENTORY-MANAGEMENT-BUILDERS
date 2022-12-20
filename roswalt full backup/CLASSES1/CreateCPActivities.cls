public with sharing class CreateCPActivities {
    public Decimal latitude {get;set;}
    public Decimal longitude {get;set;}
    public Task cpTask {get;set;}
    public Id cpId {get;set;}
    
    public CreateCPActivities()
    {
        cpId = ApexPages.currentPage().getParameters().get('id');
        system.debug(cpId);
        cpTask = new Task();
        cpTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Log A Call').getRecordTypeId();
        cpTask.Subject = 'CP Call';
        latitude = 0.00;
        longitude = 0.00;
        system.debug(latitude);
        system.debug(longitude);
    }
    
    public pageReference insertTask()
    {
        system.debug(latitude);
        system.debug(longitude);
        system.debug('CP Id'+ cpId);
        cpTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Log A Call').getRecordTypeId();
        cpTask.Location__latitude__s = latitude;
        cpTask.Location__Longitude__s = longitude;
        cpTask.Subject = 'CP Meeting';
        cpTask.WhatId = cpId;
        insert cpTask;
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
        PageReference pg = new PageReference('/'+cpId);
        pg.setRedirect(true);
        return pg; 
    }
    
    public pageReference insertCPMeetingTask()
    {
        system.debug(latitude);
        system.debug(longitude);
        system.debug('CP Id'+ cpId);
        //cpTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CP Meeting').getRecordTypeId();
        cpTask.Location__latitude__s = latitude;
        cpTask.Location__Longitude__s = longitude;
        //cpTask.Subject = 'CP Meeting';
        cpTask.WhatId = cpId;
        insert cpTask;
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
        PageReference pg = new PageReference('/'+cpId);
        pg.setRedirect(true);
        return pg;
    }
    
}
global class DSRReportController {

    global String selectPro  {get;set;}
    global String selectCam  {get;set;}
    global string ProjectId  {get;set;}
    global string CampaignId {get;set;}
    public string datefilter {get;set;}
    
    global List<AggregateResult> LeadOwnerWiseAggregation
    {
        get;set;
    }
    
    global Map<string , List<AggregateResult>> mapSMOppAgrList
    {
        get;set;
    }
    
    /*public List<SelectOption> getItems {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('--Select Date Filter--','--Select Date Filter--'));
            options.add(new SelectOption('TODAY','TODAY'));
            options.add(new SelectOption('YESTERDAY','YESTERDAY'));
            options.add(new SelectOption('THIS_MONTH','THIS_MONTH'));
            options.add(new SelectOption('LAST_MONTH','LAST_MONTH'));
            return options;
           
        }
        set;
    }*/
    
    global List<SelectOption> getProjectList {
        get {
           
            ProjectId = '';
            List<Lead> lList = new List<Lead>();
            List<Project__c> projectList = new List<Project__c> ();
           
            if(ProjectId != '') {
                projectList = [Select Id, Name from Project__c where id=:ProjectId ORDER BY Name ASC];
            } else {
                projectList = [Select Id, Name from Project__c ORDER BY Name ASC];
            }
            system.debug('projectList: '+projectList);
           
            List<SelectOption> proList = new List<SelectOption>();
            proList.add(new selectOption('','-- Select Project --'));
            for(Project__c p : projectList) {
                proList.add(new selectOption(p.Id, p.Name));
            }
           
            return proList;
        }
        set;
    }
    
    global List<SelectOption> getCampaignList {
        get {
           
            CampaignId = '';
            List<Opportunity> oppList = new List<Opportunity>();
            List<Campaign> CampaignList = new List<Campaign> ();
           
            if(CampaignId != '') {
                CampaignList = [Select Id, Name from Campaign where id=:CampaignId ORDER BY Name ASC];
            } else {
                CampaignList = [Select Id, Name from Campaign ORDER BY Name ASC];
            }
            system.debug('CampaignList: '+CampaignList);
           
            List<SelectOption> camList = new List<SelectOption>();
            camList.add(new selectOption('','-- Select Campaign --'));
            for(Campaign c : CampaignList) {
                camList.add(new selectOption(c.Id, c.Name));
            }
           
            return camList;
        }
        set;
    }
  
    global DSRReportController()
    {
        system.debug('selected Project: '+selectPro);
    }
    
    global void displayResults(){
        mapSMOppAgrList = new Map<string , List<AggregateResult>>();
        
        Decimal Lead_Count = 0;
        
        Map<string , List<Lead>> mapleadList = new Map<string , List<Lead>>();
        
        LeadOwnerWiseAggregation = [SELECT Owner.Name lo,COUNT(MobilePhone) lcount,COUNT(Presales_Call__c)ccount FROM Lead 
            						Where Project__c =: selectPro 
                                    AND CreatedDate = TODAY
                                     GROUP BY Owner.Name ];
        
        system.debug('Leadcount: '+LeadOwnerWiseAggregation);
        for(AggregateResult agr: LeadOwnerWiseAggregation)
        {
            if(mapSMOppAgrList.containsKey((string)agr.get('lo')))
            {
                mapSMOppAgrList.get((string)agr.get('lo')).add(agr);
            }
            else
            {
                List<AggregateResult> tempLstAgr = new List<AggregateResult>();
                tempLstAgr.add(agr);
                mapSMOppAgrList.put((string)agr.get('lo'),tempLstAgr);
            }
            
        }
    }
}
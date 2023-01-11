public class PMTServiceWrapper{
    public String team; //PMT
    public String campaignId;   //CampaignId
    public String LeadId; //PMT
    public cls_leads[] leads;
    public class cls_leads {
    public String leadId;   //00Qp0000004Htgm
    public String callerName;   //ABC
    public String siteId;   //SiteId
    public String siteName; //Site Name
    public String projectName;  //Enigma
    public String projectId;    //projectId
    public String CTI_Agent_ID; // PMT owner -- Modified on 15-05
    }
    public PMTServiceWrapper(){
         leads = new list<cls_leads>();
    }
    public static PMTServiceWrapper parse(String json){
        return (PMTServiceWrapper) System.JSON.deserialize(json, PMTServiceWrapper.class);
    }

/*
    static testMethod void testParse() {
        String json=        '{'+
        '  "team": "PMT",'+
        '  "campaignId": "CampaignId",'+
        '  "leads": ['+
        '    {'+
        '      "leadId": "00Qp0000004Htgm",'+
        '      "callerName": "ABC",'+
        '      "siteId": "SiteId",'+
        '      "siteName": "Site Name",'+
        '      "projectName": "Enigma",'+
        '      "projectId": "projectId"'+
        '    },'+
        '    {'+
        '      "leadId": "00Qp0000004Htgn",'+
        '      "callerName": "ABC",'+
        '      "siteId": "SiteId",'+
        '      "siteName": "Site Name",'+
        '      "projectName": "Enigma",'+
        '      "projectId": "projectId"'+
        '    }'+
        '  ]'+
        '}'+
        '';
        PMTServiceWrapper obj = parse(json);
        System.assert(obj != null);
    }
    */
}
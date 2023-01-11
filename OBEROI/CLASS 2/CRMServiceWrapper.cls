public class CRMServiceWrapper{
    public String team; //CRM
    public String contactId;    //contactId
    public String callerName;   //Contact Name or Lead Name
    public String userId; //CRM User Id
    public String leadId;
    public cls_projects[] projects;
    public class cls_projects {
        public String projectSearchTerm;    //OSC
        public String projectId;    //
        public String siteId;   //SiteId
        public String siteName; //Site Name
        public String opportunityId;    //
        public String opportunityName;  //Opportunity Name
        public cls_towers[] towers;
    }
    public class cls_towers {
        public String towerSearchTerm;  //OSC-A
        public String towerId;  //
        public cls_units[] units;
    }
    public  class cls_units {
        public String unitSearchTerm;   //OSC-A-101
        public String unitId;   //
        public String bookingId;    //
    }
    public static CRMServiceWrapper parse(String json){
        return (CRMServiceWrapper) System.JSON.deserialize(json, CRMServiceWrapper.class);
    }
/*
    static testMethod void testParse() {
        String json=        '{'+
        '  "team": "CRM",'+
        '  "contactId": "contactId",'+
        '  "callerName": "Contact Name or Lead Name",'+
        '  "projects": ['+
        '    {'+
        '      "projectSearchTerm": "OSC",'+
        '      "projectId": "",'+
        '      "siteId": "SiteId",'+
        '      "siteName": "Site Name",'+
        '      "opportunityId": "",'+
        '      "opportunityName": "Opportunity Name",'+
        '      "towers": ['+
        '        {'+
        '          "towerSearchTerm": "OSC-A",'+
        '          "towerId": "",'+
        '          "units": ['+
        '            {'+
        '              "unitSearchTerm": "OSC-A-101",'+
        '              "unitId": "",'+
        '              "bookingId": ""'+
        '            },'+
        '            {'+
        '              "unitSearchTerm": "OSC-A-102",'+
        '              "unitId": "",'+
        '              "bookingId": ""'+
        '            }'+
        '          ]'+
        '        }'+
        '      ]'+
        '    }'+
        '  ]'+
        '}'+
        '';
        CRMServiceWrapper obj = parse(json);
        System.assert(obj != null);
    }
    */
}
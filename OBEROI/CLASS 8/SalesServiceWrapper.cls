public class SalesServiceWrapper{
    public String team; //Sales
    public String contactId;    //contactId
    public String callerName;   //Contact Name
    public String userId; //Id of Sales User
    public String brokerId;
	public String brokerAgency;
    public String opportunityId;
    public cls_projects[] projects;
    public SalesServiceWrapper(){
        projects = new list<cls_projects >();
        
    }
    public class cls_projects {
        public String projectSearchTerm;    //OSC
        public String projectId;    //
        public String siteId;   //SiteId
        public String siteName; //Site Name
        public String opportunityName; //Opp Name
        public String opportunityId;    //OpportunityId
        public cls_booking[] booking;
        public cls_Projects(){
            booking= new list<cls_booking>();
        }
    }
    public class cls_booking {
        public String towerSearchTerm;  //OSC-A
        public String towerId;  //TowerId1
        public String unitSearchTerm;   //OSC-A-101
        public String unitId;   //UnitId1
        public String bookingId;    //bookingId
    }
    public static SalesServiceWrapper parse(String json){
        return (SalesServiceWrapper) System.JSON.deserialize(json, SalesServiceWrapper.class);
    }
/*
    static testMethod void testParse() {
        String json=        '{'+
        '  "team": "Sales",'+
        '  "contactId": "contactId",'+
        '  "callerName": "Contact Name",'+
        '  "projects": ['+
        '    {'+
        '      "projectSearchTerm": "OSC",'+
        '      "projectId": "",'+
        '      "siteId": "SiteId",'+
        '      "siteName": "Site Name",'+
        '      "opportunity Name": "Opp Name",'+
        '      "opportunityId": "OpportunityId",'+
        '      "booking": ['+
        '        {'+
        '          "towerSearchTerm": "OSC-A",'+
        '          "towerId": "TowerId1",'+
        '          "unitSearchTerm": "OSC-A-101",'+
        '          "unitId": "UnitId1",'+
        '          "bookingId": "bookingId"'+
        '        },'+
        '        {'+
        '          "towerSearchTerm": "OSC-A",'+
        '          "towerId": "TowerId1",'+
        '          "unitSearchTerm": "OSC-A-102",'+
        '          "unitId": "UnitId2",'+
        '          "bookingId": "bookingId"'+
        '        }'+
        '      ]'+
        '    }'+
        '  ]'+
        '}'+
        '';
        SalesServiceWrapper obj = parse(json);
        System.assert(obj != null);
    }*/
}
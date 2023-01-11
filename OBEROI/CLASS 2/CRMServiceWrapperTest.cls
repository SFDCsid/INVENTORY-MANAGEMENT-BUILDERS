@isTest
public class CRMServiceWrapperTest {
    static String json;
 @TestSetup
    private static void createTestData() {
        json=        '{'+
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
    }
     @isTest static void test() {
         
     CRMServiceWrapper.parse(json);
     }
}
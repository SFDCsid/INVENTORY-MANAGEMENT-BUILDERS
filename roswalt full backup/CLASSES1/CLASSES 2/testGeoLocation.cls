@isTest
public class testGeoLocation {
    
    static testMethod void testParse() {
		String json=		'{'+
		'   "results" : ['+
		'      {'+
		'         "address_components" : ['+
		'            {'+
		'               "long_name" : "Aundh",'+
		'               "short_name" : "Aundh",'+
		'               "types" : [ "political", "sublocality", "sublocality_level_1" ]'+
		'            },'+
		'            {'+
		'               "long_name" : "Pune",'+
		'               "short_name" : "Pune",'+
		'               "types" : [ "locality", "political" ]'+
		'            },'+
		'            {'+
		'               "long_name" : "Pune",'+
		'               "short_name" : "Pune",'+
		'               "types" : [ "administrative_area_level_2", "political" ]'+
		'            },'+
		'            {'+
		'               "long_name" : "Maharashtra",'+
		'               "short_name" : "MH",'+
		'               "types" : [ "administrative_area_level_1", "political" ]'+
		'            },'+
		'            {'+
		'               "long_name" : "India",'+
		'               "short_name" : "IN",'+
		'               "types" : [ "country", "political" ]'+
		'            }'+
		'         ],'+
		'         "formatted_address" : "Aundh, Pune, Maharashtra, India",'+
		'         "geometry" : {'+
		'            "bounds" : {'+
		'               "northeast" : {'+
		'                  "lat" : 18.570025,'+
		'                  "lng" : 73.82245309999999'+
		'               },'+
		'               "southwest" : {'+
		'                  "lat" : 18.545373,'+
		'                  "lng" : 73.79222399999999'+
		'               }'+
		'            },'+
		'            "location" : {'+
		'               "lat" : 18.5601649,'+
		'               "lng" : 73.8031335'+
		'            },'+
		'            "location_type" : "APPROXIMATE",'+
		'            "viewport" : {'+
		'               "northeast" : {'+
		'                  "lat" : 18.570025,'+
		'                  "lng" : 73.82245309999999'+
		'               },'+
		'               "southwest" : {'+
		'                  "lat" : 18.545373,'+
		'                  "lng" : 73.79222399999999'+
		'               }'+
		'            }'+
		'         },'+
		'         "place_id" : "ChIJzUFgOki_wjsRLTrf2X7gaNk",'+
		'         "types" : [ "political", "sublocality", "sublocality_level_1" ]'+
		'      }'+
		'   ],'+
		'   "status" : "OK"'+
		'}';
         Id reTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('CP Log A Call').getRecordTypeId();
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Channel Partner' and SObjectType = 'Account'];
        Account a = new Account(lastName='test', personEmail = 'test@gmail.com', MahaRERA_Registration_No__c= 'test9158747991', RecordType = personAccountRecordType);
        insert a;
        Task t = new Task();
        t.Subject = 'New Task';
        t.Location__latitude__s = 67.00;
        t.Location__Longitude__s = 67.00;
        t.Geo_address__c = 'Test Address';
        t.Description='test comments';
        t.RecordTypeId = reTypeId;
        t.WhatId = a.Id;
        insert t;
        JSONGeoParser jobj = JSONGeoParser.parse(json);
        Decimal strlat  = 18.5620944;
        Decimal strlon  = 73.8301322;
        UpdateLiveAddressOnTask ul = new UpdateLiveAddressOnTask();
        UpdateLiveAddressOnTask.trackGMap(t.Id, strlat, strlon);
        
        
        
    }
    
	@isTest
    public static void createCPMeetingTask()
    {
        Test.startTest();
        
         RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Channel Partner' and SObjectType = 'Account'];
        Account a = new Account(lastName='test', personEmail = 'test@gmail.com', MahaRERA_Registration_No__c= 'test9158747991', RecordType = personAccountRecordType);
        insert a;
        
        Id reTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('CP Log A Call').getRecordTypeId();
        Task t = new Task();
        t.Subject = 'New Task';
        t.Location__latitude__s = 67.00;
        t.Location__Longitude__s = 67.00;
        t.Geo_address__c = 'Test Address';
        t.Description='test comments';
        t.RecordTypeId = reTypeId;
         t.WhatId = a.Id;
        insert t;
        
        Task t1 = new Task();
        t1.Subject = 'CP Meeting';
        t1.Location__latitude__s = 68.00;
        t1.Location__Longitude__s = 68.00;
        t1.Geo_address__c = 'Test Address1';
        t1.Remarks__c ='test comments';
        t1.RecordTypeId = reTypeId;
        insert t1;
        
        
        UpdateLiveAddressOnTask ulp = new UpdateLiveAddressOnTask();
        CreateCPActivities ccpa = new CreateCPActivities();
        ccpa.insertCPMeetingTask();
        PageReference pageRef = Page.CPMeetingActivityPage;
        pageRef.getParameters().put('accId', a.id);  
        Test.setCurrentPage(pageRef);
        
        ccpa.insertTask();
        ccpa.latitude = 67.00;
        ccpa.longitude = 67.00;
        Test.stopTest();
    }
}
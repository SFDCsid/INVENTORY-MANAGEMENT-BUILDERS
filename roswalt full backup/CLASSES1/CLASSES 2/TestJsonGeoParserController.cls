@isTest
public class TestJsonGeoParserController 
{
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
		//cabLocationJSONParser obj = cabLocationJSONParser.parse(json);
		//System.assert(obj != null);
        JSONGeoParser jobj = JSONGeoParser.parse(json);
        JSONParserController jcon = JSONParserController.parse(json);
	}
}
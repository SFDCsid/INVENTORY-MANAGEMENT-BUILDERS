public class UpdateLiveAddressOnTask {
    public String ipAddress{get;set;}
    public string lat {get;set;}
    public string lon {get;set;}
    public task tk {get;set;}
    //public string[] stringArray {get;set;}
    public UpdateLiveAddressOnTask()
    {
        lat = '';
        lon = '';
        
        ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        system.debug('My ip address:: '+ ipAddress);
        tk = new Task();
    }
    
    @future(callout=true)
    public static void trackGMap(Id tsk, Decimal strlat, Decimal strlon)
    {
        system.debug('Task:: ' + tsk);
        Task tk = new Task();
        tk = [Select Id, WhoId, Geo_address__c, Location__latitude__s, Location__Longitude__s
              from Task
              where Id =: tsk];
        string address = strlat+'+'+strlon; ////'18.5620944+73.8301322';
        string key = 'AIzaSyBDIoHdRMym2mao5Ujvri3W0XTr1FU2cKc';  // comments this key when got actual key
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        
        string endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&key='+key;
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        if(!Test.isRunningTest())
        {
            httpResponse response = httpProtocol.send(request);
            system.debug('Response:::'+ response.getBody());
        
        //string res ='{"results" : [{"address_components" : [{"long_name" : "1600","short_name" : "1600","types" : [ "street_number" ]},{"long_name" : "Amphitheatre Pkwy","short_name" : "Amphitheatre Pkwy","types" : [ "route" ]},{"long_name" : "Mountain View","short_name" : "Mountain View","types" : [ "locality", "political" ]},{"long_name" : "Santa Clara County","short_name" : "Santa Clara County","types" : [ "administrative_area_level_2", "political" ]},{"long_name" : "California","short_name" : "CA","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "United States","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "94043","short_name" : "94043","types" : [ "postal_code" ]}],"formatted_address" : "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA","geometry" : {"location" :{"lat" : 37.4224764,"lng" : -122.0842499},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 37.4238253802915,"lng" : -122.0829009197085 },"southwest" : {"lat" : 37.4211274197085,"lng" : -122.0855988802915}}}, "place_id" : "ChIJ2eUgeAK6j4ARbn5u_wAGqWA", "plus_code": {"compound_code": "CWC8+W5 Mountain View, California, United States", "global_code": "849VCWC8+W5" },"types" : [ "street_address" ]}],"status" : "OK"}';
        Map<String,String> fieldValuesMap  = new Map<String,String>();
        JSONGeoParser jResult = new JSONGeoParser();
        jResult = JSONGeoParser.parse(response.getBody());
        List<JSONGeoParser.Results > lstJResult = new List<JSONGeoParser.Results>();
        lstJResult = jResult.Results;
        system.debug(lstJResult);
        
        string stringArray = '';
        stringArray = string.valueOf(lstJResult[0].formatted_address);
        /*for(JSONGeoParser.Results jr :lstJResult)
        {
            system.debug('formatted address:: '+ jr.formatted_address);
            stringArray = string.valueOf(jr.formatted_address);
            system.debug('String formatted Address:: '+ stringArray);
        }*/
        system.debug('Formatted Address :: '+ stringArray);
        tk.Geo_address__c = stringArray;
        update tk;
        }
    }
}
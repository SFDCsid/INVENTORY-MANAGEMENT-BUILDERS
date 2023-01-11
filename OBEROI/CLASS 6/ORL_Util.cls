/****************************************************************************************************************
    @author        Vivek S
    @date          
    @description   Common methods to be placed here
    ****************************************************************************************************************/

public class ORL_Util{

static Map<String, Schema.SObjectType> globaldescribe = Schema.getGlobalDescribe();

    public static String buildQuery(String objType) {
        String queryString = 'SELECT ';
        try {
            // Get object fields and add to query string
            Map<String, Schema.SObjectField> fm = globaldescribe.get(objType).getDescribe().fields.getMap();
            for (String name : fm.keySet()) {
                Schema.DescribeFieldResult res = fm.get(name).getDescribe();
                if (res!=null){   
                    // && res.isAccessible())
                    queryString = queryString + res.getName() + ',';
                }   
            }
            
            // Remove last comma
            queryString = queryString.substring(0,queryString.length()-1);       
            queryString = queryString + ' FROM ' + objType;
        } catch(Exception e) {
            Logger.LogException(e.getMessage());
        } 
        return queryString;
    }
    
    public static String buildQueryWithReference(String objType, string refFields) {
        String queryString = 'SELECT '+refFields+ ',';
        try {
            // Get object fields and add to query string
            Map<String, Schema.SObjectField> fm = globaldescribe.get(objType).getDescribe().fields.getMap();
            for (String name : fm.keySet()) {
                Schema.DescribeFieldResult res = fm.get(name).getDescribe();
                if (res!=null){   
                    // && res.isAccessible())
                    queryString = queryString + res.getName() + ',';
                }   
            }
            
            // Remove last comma
            queryString = queryString.substring(0,queryString.length()-1);       
            queryString = queryString + ' FROM ' + objType;
        } catch(Exception e) {
            Logger.LogException(e.getMessage());
        } 
        return queryString;
    }
    
    public static String gtRecordtypeId(String objType, string DevName) {
        String RecTypeId;
        try {
            RecTypeId = [SELECT Id, Name, DeveloperName 
                         FROM RecordType 
                         WHERE SObjectType =: objType
                         AND DeveloperName =: DevName].Id;

        } catch(Exception e) {
            Logger.LogException(e.getMessage());
        } 
        
        return RecTypeId;
    }
}
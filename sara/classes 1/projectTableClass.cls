public with sharing class projectTableClass {
    public projectTableClass() {

    }
    @AuraEnabled (cacheable=true)
    public static map<Id , string> excecutiveMethod(){
    map<Id , string> excecutivemap= new map<Id , string>();
    list<User> excecutivelist = [SELECT Id,Name FROM User];
    for(User pMap : excecutivelist){
        excecutivemap.put(pMap.Id , pMap.Name);
    }
    return excecutivemap;
    }
}
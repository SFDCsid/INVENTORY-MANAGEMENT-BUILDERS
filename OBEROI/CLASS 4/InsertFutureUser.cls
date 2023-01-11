public class InsertFutureUser {
    @future
    public static void insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        UserRole r = [SELECT Id FROM UserRole ][0];
        User futureUser = new User(firstname = 'Future', lastname = 'User',
                                   alias = 'future', defaultgroupnotificationfrequency = 'N',
                                   digestfrequency = 'N', email = 'test@test.org',
                                   emailencodingkey = 'UTF-8', languagelocalekey='en_US', 
                                   localesidkey='en_US', profileid = p.Id, 
                                   timezonesidkey = 'America/Los_Angeles',
                                   username = 'futureuser@test.org1',
                                   userpermissionsmarketinguser = false,
                                   userpermissionsofflineuser = false, userroleid = r.Id);
        insert(futureUser);
    }
}
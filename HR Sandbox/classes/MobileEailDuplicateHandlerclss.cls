public class MobileEailDuplicateHandlerclss {
    public static void MobileEmailDuplicate(List<Candidate__c> listOfCandidate){
    
     // Set to store email ids
    Set <String> emailSet = new Set<String>(); 
    // Set to store phone numbers
    Set <String> phoneSet = new Set<String>(); 
    
    // Iterate through each Contact and add their email and phone number to their respective Sets
    for (Candidate__c con:listOfCandidate) {
        If(con.Email__c != NULL )
        {emailSet.add(con.Email__c);}
         If(con.Alternate_Email__c != NULL)
            {emailSet.add(con.Alternate_Email__c);}
         If(con.Mobile__c != NULL)
         {phoneSet.add(con.Mobile__c);}
          If(con.Alternate_Mobile__c != NULL)
          {phoneSet.add(con.Alternate_Mobile__c);}
        
    }

    // New list to store the found email or phone numbers
    List <Candidate__c> contactList = new List<Candidate__c>();

    // Populating the list using SOQL
    contactlist = [SELECT Email__c,Alternate_Email__c,Mobile__c,Alternate_Mobile__c FROM Candidate__c WHERE  Email__c IN :emailSet OR Mobile__c IN :phoneSet OR Alternate_Email__c IN :emailSet OR Alternate_Mobile__c IN :phoneSet 
              ];

    // Iterating through each Contact record to see if the same email or phone was found
    for (Candidate__c con:listOfCandidate) {
         
        If (contactList.size() > 0   ) {
            system.debug(contactlist);
            // Displaying the error
            con.adderror( 'Duplicate Candidate Found' );
        }
    }
}
   ///////////////////////
    public static void MobileEmailDuplicateExists(List<Candidate__c> listOfCandidate){
    
     // Set to store email ids
    Set <String> emailSet = new Set<String>(); 
    // Set to store phone numbers
    Set <String> phoneSet = new Set<String>(); 
    
    // Iterate through each Contact and add their email and phone number to their respective Sets
    for (Candidate__c con:listOfCandidate) {
        If(con.Email__c != NULL )
        {emailSet.add(con.Email__c);}
         If(con.Alternate_Email__c != NULL)
            {emailSet.add(con.Alternate_Email__c);}
         If(con.Mobile__c != NULL)
         {phoneSet.add(con.Mobile__c);}
          If(con.Alternate_Mobile__c != NULL)
          {phoneSet.add(con.Alternate_Mobile__c);}
        
    }

    // New list to store the found email or phone numbers
    List <Candidate__c> contactList = new List<Candidate__c>();

    // Populating the list using SOQL
    contactlist = [SELECT Email__c,Alternate_Email__c,Mobile__c,Alternate_Mobile__c FROM Candidate__c WHERE  Email__c IN :emailSet OR Mobile__c IN :phoneSet OR Alternate_Email__c IN :emailSet OR Alternate_Mobile__c IN :phoneSet 
              ];

    // Iterating through each Contact record to see if the same email or phone was found
    for (Candidate__c con:listOfCandidate) {
         
        If (contactList.size() > 0   ) {
            system.debug(contactlist);
            // Displaying the error
            con.adderror('Same Combination of Record already Inserted in' +'<a href=https://excellerconsultancy.secure.force.com/ScreeningForm?id='+con.Id+'>Click here </a> <br/></br>');
        }
    }
} 
    
}
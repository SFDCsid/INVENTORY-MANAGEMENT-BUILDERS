public class AccountTriggerHandler {
	public static void beforeInsert(List<Account> accountList) {
        AccountHandlerServices.duplicationCheck(accountList);
    }
    
    public static void beforeUpdate(Map<Id, Account> oldMap, Map<Id, Account> newMap) {
        List<Account> aList = new List<Account>();
        
        for(Account oldAccount: oldMap.values()) {
            Account newAccount = newMap.get(oldAccount.Id);
            
            if(oldAccount.PersonMobilePhone != newAccount.PersonMobilePhone || oldAccount.Phone != newAccount.Phone || oldAccount.PersonEmail != newAccount.PersonEmail || oldAccount.Alternate_Email__c != newAccount.Alternate_Email__c)
                aList.add(newAccount);
        }
        if(!aList.isEmpty() && aList != null)
            AccountHandlerServices.duplicationCheck(aList);
    }
}
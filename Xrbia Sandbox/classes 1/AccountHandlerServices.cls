//-------------------------------------------//
//  Project: XRBIA Developers
//  Created By: Exceller Consultancy
//  Created Date: 03-10-2022
//-------------------------------------------//
public class AccountHandlerServices {
	public static void duplicationCheck(List<Account> accountList) {
        Map<Account, List<DuplicationHandlerServices.duplicateWrapper>> duplicateWrapperMap = new Map<Account, List<DuplicationHandlerServices.duplicateWrapper>>();
        duplicateWrapperMap = DuplicationHandlerServices.duplicationCheckAcccount(accountList);
        
        for(Account a: accountList) {
            if(duplicateWrapperMap.containsKey(a)) {
                for(DuplicationHandlerServices.duplicateWrapper dw: duplicateWrapperMap.get(a)) {
                    if(!test.isRunningTest())
                    	a.addError('Duplicate Account Found with Name: '+dw.dupAccount.LastName+' & Id: '+dw.dupAccount.Account_Id__c);
                }
            }
        }
    }
}
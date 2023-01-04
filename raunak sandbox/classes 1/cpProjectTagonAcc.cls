public class cpProjectTagonAcc {
    
 public static string checkDuplicateCPProject(CP_Project__c cpp) {
    List<CP_Project__c> listCPP = new List<CP_Project__c>();
    listCPP = [Select Id,Name, CP_Project_Name__c 
                from CP_Project__c 
                where CP_Project_Name__c =: cpp.CP_Project_Name__c and CP_Account__c =: cpp.CP_Account__c];
    System.debug('List CPP : '+ listCPP);
    if (!listCPP.isEmpty()) {
        return 'CP Project Already Exist.';
    }            
    else {
        return '';
    }
 }

 public static string formDuplication(Forms__c fm) {
    List<Forms__c> listForms = new List<Forms__c>();
    listForms = [Select Id, Name 
                    from Forms__c 
                    where RecordTypeId =: fm.RecordTypeId 
                    and Account__c =: fm.Account__c];

    System.debug('List Forms: '+ listForms);
    if (!listForms.isEmpty()) {
        return 'Forms has already created.';
    }  
    else {
        return '';
    }              
 }
    
}
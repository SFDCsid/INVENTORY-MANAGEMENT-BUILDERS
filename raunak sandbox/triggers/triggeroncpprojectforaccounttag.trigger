//(CP_Project__c
trigger triggeroncpprojectforaccounttag on CP_Project__c (before insert) {
  if(Trigger.isBefore) {
      if(Trigger.isInsert){
        string msg = '';
        for (CP_Project__c cpp : trigger.new) {
          msg = cpProjectTagonAcc.checkDuplicateCPProject(cpp);  
          if (msg != '') {
            cpp.addError(msg);
          }
      }
    }
  }
}
trigger trgFormValidation on Forms__c (before insert) {
    if (trigger.isInsert) {
        if (trigger.isBefore) {
            string msg = '';
            for (Forms__c fm : trigger.new) {
                msg = cpProjectTagonAcc.formDuplication(fm);
                if (msg != '') {
                    fm.addError(msg);
                }
            }
        }
    }
}
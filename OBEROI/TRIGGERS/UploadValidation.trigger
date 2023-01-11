trigger UploadValidation on ContentDocumentLink (before insert,After insert) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        for(contentDocumentLink cdl : Trigger.new){
          /*      List<Related_Document_History__c> RDHList = [select id,name,Submitted_for_Approval__c from Related_Document_History__c where id =: cdl.LinkedEntityid and Submitted_for_Approval__c =: true];
            if(RDHList.size()>0){
                cdl.adderror('Document cannot be uploaded in case '+RDHList[0].name+ ' Submited or Approved');
            }  */
           
        }
    }
}
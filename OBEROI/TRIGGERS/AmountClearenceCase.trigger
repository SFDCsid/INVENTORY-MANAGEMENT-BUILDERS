trigger AmountClearenceCase on SAP_Receipts_and_Credit_Note__c (After Update,After Insert) {

    if(Trigger.isAfter && Trigger.isUpdate){
        Set<id> bookid = New Set<id>();
        for(SAP_Receipts_and_Credit_Note__c SRC : Trigger.New){ 
            if(SRC.Booking__c != null){
                bookid.add(SRC.Booking__c);
            }
        }
        system.debug('bookid::::'+bookid);
        List<Booking__c> book = [select id,name,Token_Amount_Clearence__c,Token_Amount_Clearence_Date__c,Token_Amount_Checkbounce__c 
                                 from Booking__c where id IN : bookid];
        for(SAP_Receipts_and_Credit_Note__c SRC : Trigger.New){ 
            if(book.size()>0){
                for(Booking__c b: book){
                    if(SRC.Booking__c == b.Id){
                        if(SRC.Payment_term_key__c == 'BD01' && SRC.Doc_Type_Description__c == 'RECEIPT' && SRC.Status__c != Trigger.oldmap.get(SRC.id).Status__c && SRC.Status__c == 'CLEAR' ){
                          
                                b.Token_Amount_Clearence__c = True;
                                b.Token_Amount_Clearence_Date__c = SRC.Clearing_Date__c;
                                b.Registration_Process_Email__c = True;
                            
                        }
                        else if((SRC.Status__c == Trigger.oldmap.get(SRC.id).Status__c && SRC.Status__c == 'CLEAR') && SRC.Doc_Type_Description__c == 'RECEIPT' && (SRC.Payment_term_key__c != Trigger.oldmap.get(SRC.id).Payment_term_key__c && SRC.Payment_term_key__c == 'BD01')){
                          
                                b.Token_Amount_Clearence__c = True;
                                b.Token_Amount_Clearence_Date__c = SRC.Clearing_Date__c;
                                b.Registration_Process_Email__c = True;
                            
                        }
                        else if(SRC.Payment_term_key__c == 'BD01' && SRC.Doc_Type_Description__c == 'CHEQUE_BOUNCE' && 
                        SRC.Status__c != Trigger.oldmap.get(SRC.id).Status__c && SRC.Status__c == 'CHEQUE_BOUNCE' ){
                          
                                b.Token_Amount_Checkbounce__c = True;
                            
                        }
                    }
                }
            }
        }
         Update book;
        System.debug('book::'+book); 
    }
   
    if(Trigger.isAfter && Trigger.isInsert){
       
        Set<id> bookid = New Set<id>();
        for(SAP_Receipts_and_Credit_Note__c SRC : Trigger.New){ 
            if(SRC.Booking__c != null){
                bookid.add(SRC.Booking__c);
            }
        }
        List<Booking__c> book = [select id,name,Token_Amount_Clearence__c,Token_Amount_Clearence_Date__c,Token_Amount_Checkbounce__c 
                                 from Booking__c where id IN : bookid];
        for(SAP_Receipts_and_Credit_Note__c SRC : Trigger.New){
            if(book.size()>0){
                for(Booking__c b: book){
                    if(SRC.Booking__c == b.Id){
                        if(SRC.Payment_term_key__c == 'BD01' && SRC.Doc_Type_Description__c == 'RECEIPT' && SRC.Status__c == 'CLEAR' ){ //SRC.Status__c != Trigger.oldmap.get(SRC.id).Status__c &&
                          
                                b.Token_Amount_Clearence__c = True;
                                b.Token_Amount_Clearence_Date__c = SRC.Clearing_Date__c;
                                b.Registration_Process_Email__c = True;
                            
                        }
                        else if(SRC.Payment_term_key__c == 'BD01' && SRC.Doc_Type_Description__c == 'CHEQUE_BOUNCE' && SRC.Status__c == 'CHEQUE_BOUNCE' ){ //SRC.Status__c != Trigger.oldmap.get(SRC.id).Status__c &&               
                                
                                b.Token_Amount_Checkbounce__c = True;
                            
                        }
                       
                   }
               }
            }
        }
         Update book;
        System.debug('book::'+book); 
    }

}
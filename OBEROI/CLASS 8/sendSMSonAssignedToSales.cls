public class sendSMSonAssignedToSales {
    
    @InvocableMethod
    public static void checkForStatus( list<Opportunity> newOpp ){        
        String statMess;
        list<Opportunity> oppList = new List<Opportunity>();
        set<Id> ownerIDSet = new set<Id>(); 
        
        //set<Id> opp_id = new set<Id>(); 
        //list<Opportunity> opp_list_with_account = new list<Opportunity>(); 
        
        Id resRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.Lead_RecordType_Residential).getRecordTypeId();
        for(Opportunity op : newOpp){
            ownerIDSet.add(op.ownerId);
            //opp_id.add(op.id);
        }
        //opp_list_with_account = [select id,name,Project_Name_Copy__c,Country_Code__c,Account.firstname,account.lastname,OwnerId,RecordTypeId,Data_Sheet_Submitted__c ,Sent_SMS_on_Assigned_to_Sales_Flag__c ,Mobile__c 
        //from opportunity 
        //where id in :opp_id];
        
        
        Map<id, User> ownerMap = new Map<id, User>([SELECT id, mobilePhone,Name, firstName FROM User where id IN : ownerIDSet]);
        string ownerMobile;
        string ownerName;
        for (Opportunity opp: newOpp){
            Opportunity opt =new Opportunity();
            if(opp.OwnerId != null){
                ownerMobile = ownerMap.get(opp.OwnerId).MobilePhone != null ? ownerMap.get(opp.OwnerId).MobilePhone : '';
                ownerName = ownerMap.get(opp.OwnerId).FirstName != null ? ownerMap.get(opp.OwnerId).FirstName : '';
            }
            // if(opp.Opportunity_Status__c == Label.AssignedToSales && opp.RecordTypeId == resRecordTypeId ){
            if(opp.RecordTypeId == resRecordTypeId && opp.Data_Sheet_Submitted__c == true  && opp.Sent_SMS_on_Assigned_to_Sales_Flag__c ==false ){
                statMess ='Dear ' +opp.name+', Thank you for visiting Oberoi Realty at '+opp.Project_Name_Copy__c +'. For further assistance, you can reach me at '+ownerMobile+'.Thanks, '+ ownerName ; 
                sendSMS(statMess ,opp );
                opt.Id = opp.Id;
                opt.Sent_SMS_on_Assigned_to_Sales_Flag__c = true;                
            }
            oppList.add(opt);
        }       
        update oppList;
    }
    
    
    public static void sendSMS(string msg, Opportunity opp) { 
        String mbNoStr = opp.Country_Code__c+opp.Mobile__c ;
        mbNoStr = mbNoStr.replaceAll('/[^0-9]/g','');
        mbNoStr = mbNoStr.remove('(');
        mbNoStr = mbNoStr.remove(')');
        mbNoStr = mbNoStr.remove('+');
        mbNoStr = mbNoStr.remove('-');
        mbNoStr = mbNoStr.remove(' ');
        try{ 
            system.debug('mbNoStr__'+mbNoStr);
            String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=344188&username=9819776359&password=Oberoi@888&To='+mbNoStr+'&Text='+EncodingUtil.urlEncode(msg,'UTF-8')+'&senderid=ORLCRM';
            EnquirySMSCtrl.sendSMS(smsURL); 
        }
        catch(exception ex){
            system.debug(ex.getMessage()+'****getError'+ex.getLineNumber());        
        }
    }
    
    
}
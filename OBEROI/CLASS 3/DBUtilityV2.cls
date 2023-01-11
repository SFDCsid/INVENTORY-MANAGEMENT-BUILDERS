public with sharing class DBUtilityV2 {

    public static list<objectClass> standardObjList = new list<objectClass> ();
    public static list<objectClass> customObjList= new list<objectClass> ();  
    public static list<objectClass> allObjList= new list<objectClass> ();  
    public static list<fieldClass> allFieldsList= new list<fieldClass> ();  
    
    public static  integer numberOfObject;
    public static set<string> objectSet = new set<string>();
    public String selectedVal {get;set;} 
    public SMS_Template__c templateRecord {get;set;}
    public SMS_Template__c templateRecordDetails{get;set;} 
    public id templateid {get;set;} 
    Public String messageContentNew {get;set;} 
    Public String myMsg1 {get;set;} 
    Public String mobile {get;set;} 
    //This is a variable to check if we're done with the Iteration.
    public static string isIterationDone{get;set;}
    
    public Id myId {get; set;}  
    public String sObjName {get; set;}  
    
    //Anuja Added this contructor to query templates on page load based on id passed at the  url
    public  DBUtilityV2(){ 
       myMsg1 ='';
        if(ApexPages.currentPage().getParameters().get('id')!='')
        {
            myId = ApexPages.currentPage().getParameters().get('id');
            mobile  = ApexPages.currentPage().getParameters().get('mob');
            sObjName = myId.getSObjectType().getDescribe().getName();
        } 
    }
    //Anuja Added code for contructor ends here
   
    //Anuja Added this method to get all templates of the standard object passed 
  public List<SMS_Template__c> gettempl{
       get { 
       List<SMS_Template__c> templateRecord = new List<SMS_Template__c>([Select Id,Name,Content__c from SMS_Template__c Where Context_Object__c =: sObjName]);
       system.debug(templateRecord);
       return templateRecord;
       }set;  
  }
    
    public pageReference Preview(){
        system.debug('template id '+templateid);
        templateRecordDetails =[Select Id, Content__c, Template_Number__c, Context_Object__c  FROM SMS_Template__c where id  =: templateid];
        messageContentNew  = generateSMSMessageFromTemplate(templateRecordDetails.Template_Number__c,myId,sObjName);
        return null;
    }
    public pageReference Send(){
        templateRecordDetails =[Select Id,Name, Content__c, Template_Number__c, Context_Object__c  FROM SMS_Template__c where id  =: templateid];
        messageContentNew  = generateSMSMessageFromTemplate(templateRecordDetails.Template_Number__c,myId,sObjName);
        
        if(messageContentNew != null && mobile != '')
        {
           Map<string,SMS_Vendor_Details__mdt> vendorMap = SMS_Vendor_Details__mdt.getAll();
           string userName = vendorMap.get('Bulk_Push').UserName__c;
           string password = vendorMap.get('Bulk_Push').Password__c;
           string feedId = vendorMap.get('Bulk_Push').FeedId__c;
           string senderId = vendorMap.get('Bulk_Push').SenderId__c;
           
            
           String  smsURL ='http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid='+ feedId +'&username='+ userName +'&password='+password +'&To='+String.valueof(mobile)+'&Text='+EncodingUtil.urlEncode(messageContentNew, 'UTF-8')+'&senderid='+senderId;  
           system.debug('smsURL:::'+smsURL);
           EnquirySMSCtrl.sendSMS(smsURL);
          /*  SMS_Schedule_SMS_c__c SmsRecObj = new SMS_Schedule_SMS_c__c();
            SmsRecObj.Immediate__c = True;            
            SmsRecObj.SMS_Template__c = templateid;
            SmsRecObj.Sender_Mobile__c = mobile;  
            if(sObjName == 'Lead')
            {
            SmsRecObj.Lead_Lookup__c = myId;  
            SmsRecObj.Context_Record__c  = myId ;        
            }  
            if(sObjName == 'Opportunity')
            {
            SmsRecObj.Opportunity_Lookup__c = myId;
            SmsRecObj.Context_Record_Opportunity__c = myId;
            }      
            SmsRecObj.SMS_Long_text__c =  messageContentNew;    //EncodingUtil.URLENCODE(messageContentNew,'UTF-8');
            insert SmsRecObj;
            system.debug('SmsRecObj id' +SmsRecObj.id); */
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm,'  Message sent successfully.');
            ApexPages.addMessage(myMsg);
            Task t = new Task();
            t.subject = 'SMS Sent - ' + templateRecordDetails.Name;
            t.Priority = 'Normal';
            t.Status = 'COmpleted';
            t.Description = messageContentNew;
            if(sObjName == 'Lead')
            {
                t.whoId = myId; 
            }else if(sObjName == 'Opportunity'){
                t.whatId = myId;
            } 
            insert t;
        }
        else{
        myMsg1 ='yes';
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'  Message cannot be sent either mobileno. or some fields are missing.');
        ApexPages.addMessage(myMsg);
        
        }
     return null;
    }
    public pageReference Cancel(){
    return null;
    }
    
    //Anuja Added method ends here
    @remoteAction
    public static list<objectClass> ObjectList(){
       list<schema.sObjectType> allObjects = Schema.getGlobalDescribe().Values();
        //get number of objects available for iteration.
       numberOfObject = allObjects.size();
       isIterationDone = 'No';
        // check if we have all the objects added in the list
        if((customObjList.size() + standardObjList.size())<numberOfObject){
            integer i=0;
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
                //We will iterate over this list only 99 times as there is governer limit of 100 childrelationship describes per invocations.
                    //adding the object name to the set, so that we do not add duplicates to the list.
                    if(!objectSet.contains(objTyp.getDescribe().getName())){
                        i++;
                        objectSet.add(objTyp.getDescribe().getName());
                        //check if its a custom or standard object.
                        if(objTyp.getDescribe().isCustom()){
                            customObjList.add(new objectClass(objTyp.getDescribe().getLabel(), objTyp.getDescribe().getName(), objTyp.getDescribe().getKeyPrefix(),  objTyp.getDescribe().isCustomSetting(),objTyp.getDescribe().isCustom()));
                            if(!objTyp.getDescribe().getLabel().contains('Histo') && !objTyp.getDescribe().getLabel().contains('DupeCatcher') && !objTyp.getDescribe().getLabel().contains('Dc') && !objTyp.getDescribe().isCustomSetting() && !objTyp.getDescribe().getLabel().contains('Override Cache')) {
                              allObjList.add(new objectClass(objTyp.getDescribe().getLabel(), objTyp.getDescribe().getName(), objTyp.getDescribe().getKeyPrefix(),  objTyp.getDescribe().isCustomSetting(),objTyp.getDescribe().isCustom()));
                            }
                        }else{
                            standardObjList.add(new objectClass(objTyp.getDescribe().getLabel(), objTyp.getDescribe().getName(), objTyp.getDescribe().getKeyPrefix(),  objTyp.getDescribe().isCustomSetting(),objTyp.getDescribe().isCustom()));
                            if(objTyp.getDescribe().getLabel() == 'Account' || objTyp.getDescribe().getLabel() == 'Lead' || objTyp.getDescribe().getLabel() == 'Opportunity') {
                                allObjList.add(new objectClass(objTyp.getDescribe().getLabel(), objTyp.getDescribe().getName(), objTyp.getDescribe().getKeyPrefix(),  objTyp.getDescribe().isCustomSetting(),objTyp.getDescribe().isCustom()));
                            }
                        }
                    }
            }
        }
        return allObjList;
    }
    
    @remoteAction
    public static List<fieldClass> getFields(String[]  objList) {
        Boolean isReference = false;
        String referenceTo = null;
        
        Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(objList);
        System.debug('DescREsults:' + descResult);
        Map<String, Schema.SObjectField> objectFields = descResult[0].fields.getMap();
        for(String fieldApiName : objectFields.keySet()) {
            Schema.DescribeFieldResult dr = objectFields.get(fieldApiName).getDescribe();
            if(dr.getType().name() == 'Reference') {
                isReference = true;
                referenceTo = dr.getReferenceTo()[0].getDescribe().getName() + ':' + dr.getRelationShipName();
            } else {
                referenceTo = dr.getName() + ':' + dr.getName();
            }
            allFieldsList.add(new fieldClass(dr.getlabel(), dr.getName(),dr.isCustom(), isReference, referenceTo));
            isReference = false;
            referenceTo = null;
        }
        System.debug('all fields:' + allFieldsList);
        return allFieldsList;
    }
    
    @remoteAction
    public static void saveTemplate(String contextObj, String Template, String templateName) {
        SMS_Template__c templateObj = new SMS_Template__c(Name=templateName, Context_Object__c=contextObj,Content__c = Template);
        String query = 'Select ';
        String[] fieldList = template.split(' ');
        String[] mergeFieldList = new List<String>();
        System.debug(fieldList);
        for(Integer i=0; i<fieldList.size(); i++) {
            if(fieldList[i].contains('{!')) {
                String mergeField = fieldList[i].substringBetween('!','}');
                mergeFieldList.add(mergeField);
                query += mergeField +',';
            }
        }
        query = query.substring(0,query.length() -1) + ' FROM ' + contextObj;
        templateObj.Query__c = query;
        insert templateObj;
    }
    
    //public static void generateSMSMessageFromTemplate(String TemplateNumber, Id contextRecordId, String contextObj) {
    public String generateSMSMessageFromTemplate(String TemplateNumber, Id contextRecordId, String contextObj) {
    system.debug('Inside generateSMSMessageFromTemplate ------------');
        List<SMS_Template__c> template = [Select Id, Content__c, Template_Number__c, Context_Object__c, Query__c  FROM SMS_Template__c
        
                                            where Template_Number__c =:TemplateNumber and Context_Object__c =:contextObj LIMIT 1];
                                             system.debug('Inside generateSMSMessageFromTemplate ------------'+template );
        String query = '';
        if(template.size() != 0) {
            query = template[0].Query__c + ' where Id =' + '\'' + contextRecordId + '\'';
        }   
        system.debug('Inside generateSMSMessageFromTemplate ------------'+template );
        
        String target = contextObj+'.';
        String updatedTemplate = template[0].content__c.replaceAll(target,'');
        String[] fieldList = updatedTemplate.split(' ');
        String[] mergeFieldList = new List<String>();
        String messageContent = '';
        System.debug(fieldList);
        for(Integer i=0; i<fieldList.size(); i++) {
            String value = fieldList[i];
            if(fieldList[i].contains('{!')) {
                String mergeField = fieldList[i].substringBetween('!','}');
               //system.debug('mergeField:::'+mergeField);
                mergeFieldList.add(mergeField);
            } 
        }
        String fieldValue ='';
        Map<String,String> mergeFieldValMap = new Map<String,String>();
        List<sObject> queryResults = Database.query(query);
        Sobject level1Obj, level2Obj, level3Obj;
        for(sObject result:queryResults) {
            for(String field : mergeFieldList) {
               // system.debug('field:::'+field);
                if(field.contains('.')) {
                    String[] rlnobjList = field.split('\\.');
                    System.debug('rlnList:' + field + rlnobjList);
                    Integer rlnCount = rlnobjList.size() -1;
                    System.debug('rlnCount :' +rlnCount );
                    level1Obj  = null;
                    level2Obj = null;
                    level3Obj = null;
                    fieldValue = '';
                    if(rlnCount == 3){
                          level1Obj = result.getSObject(rlnobjList[0]);
                        if(level1Obj != null)
                           level2Obj = level1Obj.getSObject(rlnObjList[1]);
                         if(level2Obj != null) 
                          level3Obj = level2Obj.getSObject(rlnObjList[2]);
                        if(level3Obj != null)
                          fieldValue = string.valueOf(level3Obj.get(rlnObjList[3]));
                    }else if(rlnCount == 2 ){
                        level1Obj = result.getSObject(rlnobjList[0]);
                        if(level1Obj != null)
                          level2Obj = level1Obj.getSObject(rlnObjList[1]);
                        if(level2Obj != null)
                          fieldValue = string.valueOf(level2Obj.get(rlnObjList[2]));
                    } else if(rlnCount == 1 ){
                        level1Obj = result.getSObject(rlnobjList[0]);
                        System.debug('fieldValue' +level1Obj ); 
                        //Anuja added this on 12/jan/16 for displaying error message over page if some data are missing 
                        if(level1Obj != null)
                        {
                            myMsg1 ='';
                            fieldValue = string.valueOf(level1Obj.get(rlnObjList[1]));
                        }
                        else{
                             myMsg1 ='yes';
                             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,' Some fields are missing in the record.');
                             ApexPages.addMessage(myMsg);
                        }
                        
                    } else {
                        fieldValue = '<BLANK>';
                    }
                } else {
                    fieldValue = String.valueOf(result.get(field));
                }      
                mergeFieldValMap.put(field,fieldValue);
            }
        }
        System.debug('Merge Fields Key: Values' + mergeFieldValMap);
        for(Integer i=0; i<fieldList.size(); i++) {
            String value='';
            if(fieldList[i].contains('{!')) {
                String mergeField = fieldList[i].substringBetween('!','}');
                if(mergeFieldValMap.containsKey(mergeField))
                value = mergeFieldValMap.get(mergeField) + ' ';
            } else {
                value = fieldList[i] + ' ';
            }
            messageContent += value;
        }
        System.debug('Message Content:' + messageContent);
        return messageContent;
    }
    
   //This is a wrapper class. 
   public class objectClass{
        public string label{get;set;}
        public string apiName{get;set;}
        public string keyPrefix{get;set;}
        public boolean isCustomSet{get;set;}
        public boolean isCustomObj{get;set;}
        
        public objectClass(string lab, string api, string prefix,  boolean isCustomSetting, boolean isCustomObj){
            this.label = lab;
            this.apiName = api;
            this.KeyPrefix = prefix;
            this.isCustomSet = isCustomSetting;
            this.isCustomObj = isCustomObj;
        }
    }
    
   public class fieldClass{
        public string label{get;set;}
        public string apiName{get;set;}
        public Boolean isReference{get;set;}
        public boolean isCustom{get;set;}
        public String referenceTo{get;set;}
        
        public fieldClass(string lab, string api, boolean isCustom, boolean isReference, String referenceTo){
            this.label = lab;
            this.apiName = api;
            this.isCustom = isCustom;
            this.isReference = isReference;
            this.referenceTo = referenceTo;
        }
    }
}
global without sharing class mCubeController {

    public static string searchObject(string mobilenumber,string landingnumber, string userId){ 
        string projectId = ''; 
        string projectCluster = '';
        List<Project__c> projectsList = [select id,Name from Project__c];  
        List<Lead> leadlist= new List<Lead>();
        List<Campaign> clist = new List<Campaign>();
        clist = [select Id,Name,SRD__c,Project__c, Project__r.Cluster__c, Master_Source__c,Lead_Source__c, Lead_Sub_Source__c ,Lead_Sub_Source_Details__c  from Campaign where Is_CTI_Campaign__c=True and IsActive=True and   Virtual_Number__c =: landingnumber limit 1];
        system.debug('clist: '+clist);
        
        if(!clist.isEmpty() && clist.size() == 1) {
            projectId =  clist[0].Project__c;
            projectCluster = cList[0].Project__r.Cluster__c;
            //leadlist = [select id,Project__r.Name from lead where Is_Active__c=True and Cluster__c =: projectCluster and  Mobilephone =:mobilenumber and IsConverted = false order by lastmodifieddate desc limit 1 ]; //Project__c =:projectId 
        } /*else {
            leadlist = [select id,Project__r.Name from lead where Is_Active__c=True and Mobilephone =:mobilenumber and IsConverted = false order by lastmodifieddate desc limit 1 ]; //Project__c =:projectId 
        }*/
      
        List<account> acclist = [select id from account where (PersonMobilePhone=:mobilenumber OR Phone=:mobilenumber) order by lastmodifieddate limit 1];
        if(acclist.size() > 0) { 
            List<Opportunity> opplist = [select id,Project__r.Name from Opportunity where accountId=:acclist[0].id and Is_Active__c = True and Cluster__c =: projectCluster order by lastmodifieddate desc limit 1 ]; //Project__c =:projectId
            if(opplist.size() > 0){
                return opplist[0].id;
            } else {

               list<lead> exisitingLead = [ select id,name from lead where (Mobilephone =:mobilenumber OR Phone=:mobilenumber) and IsConverted = false and Is_Active__c=True limit 1 ];
               if(exisitingLead.size()>0)
               {
                   return exisitingLead[0].id;
               }
             else
                {
                    leadlist = [select id,Project__r.Name from lead where Is_Active__c=True and Cluster__c =: projectCluster and (Mobilephone =:mobilenumber OR Phone=:mobilenumber) and IsConverted = false order by lastmodifieddate desc limit 1 ];
                System.debug('Search Mobile numaber'+mobilenumber+'===>'+leadlist);
                
                if(leadlist.size() > 0){
                    return leadlist[0].id;
                } else {
                    Lead l = new Lead();
                    l.MobilePhone = mobilenumber;
                    if(!clist.isEmpty() && clist.size() == 1) {
                        l.Campaign_Custom__c = clist[0].Id;
                        l.Project__c = clist[0].Project__c; 
                        l.Cluster__c = cList[0].Project__r.Cluster__c;
                        l.Campaign_Code__c = clist[0].SRD__c;
                        l.Master_Source__c = clist[0].Master_Source__c;
                        l.Lead_Source__c = clist[0].Lead_Source__c;
                        l.Lead_Sub_Source__c = clist[0].Lead_Sub_Source__c;
                        l.Lead_Sub_Source_Details__c = clist[0].Lead_Sub_Source_Details__c;
                    }
                    l.Lastname = 'Customer';
                    l.status = 'Incoming';  
                    l.Lead_Sub_Stage__c = 'Open';
                    l.Lead_Sub_Stage_Reason__c = 'Incoming call or lead which is not serviced ';
                    l.ownerId = userId;
                  	l.New_Lead__c=true;
                    
                    Database.DMLOptions dml = new Database.DMLOptions();
                    dml.DuplicateRuleHeader.AllowSave = true;
                    Database.SaveResult sr = Database.insert(l, dml); 
                    if(sr.isSuccess()) {   
                        return sr.getId();
                    } else {
                        return null;
                    }
                }   
                }
                                
           
            }
        } else {
            //Last MOdi
            list<lead> exisitingLead = [ select id,name from lead where (Mobilephone =:mobilenumber OR Phone=:mobilenumber) and IsConverted = false and Is_Active__c=True limit 1 ];
               if(exisitingLead.size()>0)
               {
                   return exisitingLead[0].id;
               }
            else{
                            leadlist = [select id,Project__r.Name from lead where Is_Active__c=True and Cluster__c =: projectCluster and (Mobilephone =:mobilenumber OR Phone=:mobilenumber) and IsConverted = false order by lastmodifieddate desc limit 1 ]; //Project__c =:projectId 
          	/*if(leadlist.size() == 0) {
                leadlist = [select id,Project__r.Name from lead where Is_Active__c=True and Mobilephone =:mobilenumber and IsConverted = false order by lastmodifieddate desc limit 1 ]; //Project__c =:projectId   
            }*/
 			System.debug('Search Mobile numaber'+mobilenumber+'===>'+leadlist);
            if(leadlist.size() > 0){
                return leadlist[0].id; 
            } else {
                Lead l = new Lead();
                l.MobilePhone = mobilenumber;
                if(!clist.isEmpty() && clist.size() == 1 ) {
                    l.Campaign_Custom__c = clist[0].Id;
                    l.Project__c = clist[0].Project__c; 
                    l.Cluster__c = cList[0].Project__r.Cluster__c;
                    l.Campaign_Code__c = clist[0].SRD__c;
                    l.Master_Source__c = clist[0].Master_Source__c;
                    l.Lead_Source__c = clist[0].Lead_Source__c;
                    l.Lead_Sub_Source__c = clist[0].Lead_Sub_Source__c;
                    l.Lead_Sub_Source_Details__c = clist[0].Lead_Sub_Source_Details__c;
                }
                l.Lastname = 'Customer';
                l.status = 'Incoming';  
                l.Lead_Sub_Stage__c = 'Open';
                l.Lead_Sub_Stage_Reason__c = 'Incoming call or lead which is not serviced ';
                l.ownerId = userId;
				l.New_Lead__c=true;
                
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true;
                Database.SaveResult sr = Database.insert(l, dml); 
                if(sr.isSuccess()) {   
                    return sr.getId();
                } else {
                    return null;
                }
            } 
            }
            
            
      
        }  
    
    } 
    
    
    @auraenabled
    webservice static List<string> readNumbers(String recordId) { 
        list<string> numbers = new list<string> ();
        string  mcubeObjectName = id.valueof( recordId).getSObjectType().getDescribe().getName() ;  
        List<MCUBE_Object_Api__c> mcubeObjectList =[select id,name,Field_to_Compare_Mobile_Incoming_Number__c from MCUBE_Object_Api__c where name =:mcubeObjectName ];
        string fieldsToquery = '';
        for(MCUBE_Object_Api__c m:  mcubeObjectList){
            if(!fieldsToquery.contains(m.Field_to_Compare_Mobile_Incoming_Number__c)){
               fieldsToquery =  fieldsToquery+','+ m.Field_to_Compare_Mobile_Incoming_Number__c;
            }
        }
        String condtn='Id='+'\''+recordId+'\'';
        String xQuery='Select id '+fieldsToquery+ ' from '+mcubeObjectName+' where '+condtn;
        system.debug(xQuery);         
        sObject so = Database.query(xQuery);
        for(MCUBE_Object_Api__c m:  mcubeObjectList){
            system.debug(m.Field_to_Compare_Mobile_Incoming_Number__c);
            system.debug((string)so.get(m.Field_to_Compare_Mobile_Incoming_Number__c));
            numbers.add((string)so.get(m.Field_to_Compare_Mobile_Incoming_Number__c));
        }
        system.debug(numbers);
        return numbers;
    
    }
    
    
    
    
    @auraenabled 
    webservice static boolean clickToCallNumber(String recordId, String numberSelected) { 
       
        string  mcubeObjectName = id.valueof( recordId).getSObjectType().getDescribe().getName() ;  
        MCUBE_Object_Api__c mcubeObject=[select id,name,Field_to_Compare_Mobile_Incoming_Number__c,LandingNumber__c from MCUBE_Object_Api__c where name =:mcubeObjectName  limit 1];
        String condtn='Id='+'\''+recordId+'\'';
        String xQuery='Select id,'+mcubeObject.Field_to_Compare_Mobile_Incoming_Number__c+ ' from '+mcubeObjectName+' where '+condtn;
       
        
        system.debug(xQuery);         
        List<sObject> l = Database.query(xQuery);
        system.debug(l);        
        
        // Lead l =  [select id, Mobilephone from Lead where id=: leadId ];
        User u = [select mobilePhone from user where id=:userinfo.getUserId()];
        String m= numberSelected; 
        
        u.mobilePhone = u.mobilePhone.replace('+91','')  ; 
        u.mobilePhone = u.mobilePhone.replace('+','')  ;  
        u.mobilePhone=  u.mobilePhone.replaceAll('\\(', '');
        u.mobilePhone=  u.mobilePhone.replaceAll('\\)', '');
        u.mobilePhone=  u.mobilePhone.replaceAll(' ', '');
        if(m != null){
                m= m.replace('+91','')  ; 
                m=  m.replaceAll('\\(', '');
                m=  m.replaceAll('\\)', ''); 
                m=  m.replaceAll(' ', ''); 
        }
     
       Mcube__mdt api1 =  [select Value__c from Mcube__mdt where DeveloperName ='APIKey'];
       Mcube__mdt api2 =  [select Value__c from Mcube__mdt where DeveloperName ='callbackUrl'];
        
        string url  =   'http://mcube.vmc.in/api/outboundcall?apikey='+api1.Value__c  +'&exenumber='+u.mobilePhone+'&custnumber='+m+'&refid='+l[0].get('Id')+'&url='+api2.Value__c +'/calland?refid='+l[0].get('Id');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        system.debug(url);
        if(!test.isRunningTest()){
            HttpResponse response = http.send(request);
            String var= response.getBody() ;
            system.debug(var);  
            if(response.getStatusCode() == 200 ){
              return true;
            }
            return false;
        }
       
        return false;
        
    }
     @auraenabled
    webservice static boolean clickToCall(String recordId) { 
       
        string  mcubeObjectName = id.valueof( recordId).getSObjectType().getDescribe().getName() ;  
        MCUBE_Object_Api__c mcubeObject=[select id,name,Field_to_Compare_Mobile_Incoming_Number__c,LandingNumber__c from MCUBE_Object_Api__c where name =:mcubeObjectName  limit 1];
        String condtn='Id='+'\''+recordId+'\'';
        String xQuery='Select id,'+mcubeObject.Field_to_Compare_Mobile_Incoming_Number__c+ ' from '+mcubeObjectName+' where '+condtn;
       
        
        system.debug(xQuery);         
        List<sObject> l = Database.query(xQuery);
        system.debug(l);        
        
        // Lead l =  [select id, Mobilephone from Lead where id=: leadId ];
        User u = [select mobilePhone from user where id=:userinfo.getUserId()];
        String m= String.valueof(l[0].get(mcubeObject.Field_to_Compare_Mobile_Incoming_Number__c));
        
        u.mobilePhone = u.mobilePhone.replace('+91','')  ; 
        u.mobilePhone = u.mobilePhone.replace('+','')  ;  
        u.mobilePhone=  u.mobilePhone.replaceAll('\\(', '');
        u.mobilePhone=  u.mobilePhone.replaceAll('\\)', '');
        u.mobilePhone=  u.mobilePhone.replaceAll(' ', '');
        if(m != null){
                m= m.replace('+91','')  ; 
                m=  m.replaceAll('\\(', '');
                m=  m.replaceAll('\\)', ''); 
                m=  m.replaceAll(' ', ''); 
        }
     
       Mcube__mdt api1 =  [select Value__c from Mcube__mdt where DeveloperName ='APIKey'];
       Mcube__mdt api2 =  [select Value__c from Mcube__mdt where DeveloperName ='callbackUrl'];
        
        string url  =   'http://mcube.vmc.in/api/outboundcall?apikey='+api1.Value__c  +'&exenumber='+u.mobilePhone+'&custnumber='+m+'&refid='+l[0].get('Id')+'&url='+api2.Value__c +'/calland?refid='+l[0].get('Id');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        
        if(!test.isRunningTest()){
            HttpResponse response = http.send(request);
            String var= response.getBody() ;
            system.debug(var);  
            if(response.getStatusCode() == 200 ){
              return true;
            }
            return false;
        }
       
        return false;
        
    }
    public static void inboundCall(){ 
        String data = apexpages.currentpage().getparameters().get('data');
        string mobileNumber =''; 
                if(data != null){ 
                    data = EncodingUtil.urlDecode(data, 'UTF-8');            
                    callWrapper cw = (callWrapper)JSON.deserialize(data,callWrapper.class);   
                    List<Task> clist=[select id from Task where Call_ID__c =: cw.callid ];
                    Task c = new Task(); 
                    system.debug(cw.callfrom);
                    system.debug(cw);
                   
                    List<User> u=new List<User>();  
                    if(   cw.executive == null){   
                          u = [select id from user where (mobilephone  =: '+91 ' + cw.empnumber OR mobilephone  =: cw.empnumber) limit 1]; 
                        if(u.size()==0){
                            u = [select id from user where Id=:userinfo.getUserId() Limit 1];
                        }
                          u[0].LastAssignmentTime__c  = decimal.valueof(  system.now().gettime() );
                          if(cw.dialstatus  == 'CONNECTING'){ 
                               string objectId = searchObject(cw.callfrom,  cw.landingnumber, u[0].Id); 
                              if(objectId.startsWith('00Q' )){
                                  c.whoid = objectId;
                              }else{
                                  c.WhatId = objectId; 
                              } 
                              DateTime start = System.Now();
                              c.activitydate  = date.today(); 
                              if(cw.calltype!='CallBack')
                              {
                              c.subject  = 'Inbound Call'; 
                              c.Call_Type__c='Inbound Call'; 
                              }else
                              {
                              c.subject  = 'CallBack'; 
                              c.Call_Type__c='CallBack'; 
                              }
                              c.Call_ID__c = cw.CallId;
                              c.Call_From__c = cw.callfrom; 
                              c.Start_Time__c =   Datetime.valueof(cw.starttime).addHours(-5).addMinutes(-30); 
                              c.Call_ID__c = cw.callid;
                              c.Call_To__c=cw.empnumber;
                              c.Recording_File__c=cw.filename;
                              c.landing_number__c = cw.landingNumber;
                              c.Status__c=cw.dialstatus; 
                              c.OwnerId = u[0].Id;
                              //c.Next_Follow_up_Date__c  = date.today();
                              c.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId(); 
                              if(!test.isRunningTest()){
                                    insert c;  
                               }
                               sendNotification(cw.callfrom, objectId , u[0].id,  (  objectId.startsWith('00Q' )? 'Lead':'Opportunity' )   );
        
                    }else  
                    { 
          //update Lead owner for Call Routing    
                list<Lead> leadToUpdate=[select id,Project__r.Name,Mobilephone,New_Lead__c from lead where Is_Active__c=True and Mobilephone =:cw.callfrom and IsConverted = false order by lastmodifieddate desc limit 1  ];	
                
                        System.debug(leadToUpdate);
                      if(leadtoUpdate.size()>0)
                {
                   if(leadToUpdate[0].New_Lead__c==true)   
                   {
                      leadToUpdate[0].New_Lead__c=false; 
                      leadToUpdate[0].ownerId = u[0].id;
                       update leadToUpdate[0];
                   }
                }
                         if(cList.size() == 1){
                            c = [select id from task where Call_ID__c =: cw.callid ];
                            c.End_Time__c = Datetime.valueof(cw.endtime).addHours(-5).addMinutes(-30);
                            c.Status__c=cw.dialstatus;
                            c.Recording_File__c= cw.filename;
                            if(!test.isRunningTest()){
                                    update c;  
                            }
                        }
                    }
                  
                   
                        
                        
               }
                   
                    
           if(cw.executive != null){ 
                
            if (    cw.status == 'ORIGINATE')
            {
                
                u = [select id from user where (mobilephone  =: '+91 ' + cw.executive OR mobilephone  =: cw.executive) limit 1];
                if(u.size()==0){
                    u = [select id from user where Id=:userinfo.getUserId() Limit 1];
                  }
                c = new Task(); 
                if(cw.refid.startsWith('00Q' )){
                    c.whoid = cw.refid;
                }else{
                    c.WhatId = cw.refid; 
                } 
                DateTime start = System.Now();
                c.activitydate  = date.today(); 
                c.subject  = 'Outbound Call'; 
                c.Call_ID__c = cw.CallId;
                c.Call_From__c = cw.executive; 
                c.Start_Time__c =   Datetime.valueof(cw.starttime).addHours(-5).addMinutes(-30); 
                c.Call_ID__c = cw.callid;
                c.Call_Type__c='Outbound Call'; 
                c.Call_To__c=cw.customer;
                c.Recording_File__c=cw.filename;
                c.landing_number__c = cw.landingNumber; 
                c.Status__c=cw.status;  
                c.OwnerId = u[0].Id;
                //c.Next_Follow_up_Date__c  = date.today();
                c.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Presales Call').getRecordTypeId(); 
                if(!test.isRunningTest()){
                    insert c;  
                 }
 
            }else   
            {                  
                if(cList.size() == 1){  
                    Task  c1 = [select id from Task where Call_ID__c =: cw.callid ];
                    c1.End_Time__c = Datetime.valueof(cw.endtime).addhours(-5).addMinutes(-30); 
                    c1.Status__c=cw.status;
                    c1.Recording_File__c= cw.filename;
                    if(!test.isRunningTest()){
                                    update c1;  
                    }
                }
            }
          } 
                 
           }   
       }
 
    
     public static void sendNotification(string mobile, string recordId,String userId, string objectName){
        
            CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='Mcube_Notification']; 
                // Create a new custom notification
                Messaging.CustomNotification notification = new Messaging.CustomNotification(); 
                // Set the contents for the notification
                notification.setTitle('Incoming Call');
                notification.setBody('You Have a call on ' + system.now()); 
         
                // Set the notification type and target
                notification.setNotificationTypeId(notificationType.Id);
                notification.setTargetId(recordId);
                
                // Actually send the notification
                try {
                    notification.send(new set<string> {userId});
                }
                catch (Exception e) {
                    System.debug('Problem sending notification: ' + e.getMessage());
                }  
           
        
            List<CtiNotification__e> publishEvents = new List<CtiNotification__e>();
            CtiNotification__e eve = new CtiNotification__e();  
            eve.User_Id__c = userId;
            eve.Record_Id__c = recordId; 
            eve.ObjectName__c = objectName;
            publishEvents.add(eve);   
            if(!publishEvents.isEmpty()){
                EventBus.publish(publishEvents);
            }
    }
    
    
    
       public class  callWrapper{
        
        String refid;
        String  callid ;
        String callfrom; 
        string starttime ;
        String   filename; 
        String calid;
        string pulse;
        string source;
        String custfeedback;
        String exefeedback;
        String dialstatus;
        String callerbusiness;
        String callername;
        String remark;
        String calleraddress;
        String caller_email;
        String rate;
        string empnumber;
        string   endtime;
        String eid ;
        String empid;
        string gid;
        String empemail;
        String status;
        String executive;
        String customer;
        string LandingNumber;
        string calltype;
    }      
            
}
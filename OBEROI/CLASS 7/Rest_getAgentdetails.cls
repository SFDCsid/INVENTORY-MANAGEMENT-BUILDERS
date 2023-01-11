@RestResource(urlMapping='/getAgentId/*')

global class Rest_getAgentdetails {
    @Httppost
    global static Rest_Result Rest_getAgentdetails(String Mobile,String VirtualNumber)       
    {
        
        system.debug('Mobile=='+Mobile);
        Rest_Result r = new Rest_Result();   
        
        List<Lead> lList = new List<Lead>();
        List<User> UserList = new List<User>();
        
        lList = [Select Id, Name, OwnerId, MobilePhone From Lead
       Where MobilePhone =:Mobile and Virtual_Number_Text__c=:VirtualNumber];
       
        
        If(lList.Size() >0 && lList.Size() != Null){
            If(lList[0].OwnerId != Null){
                 UserList = [Select Id, Name, CTI_Agent_ID__c, CTI_Extension__c,campaign_name__c, MobilePhone
                             From User Where Id =: lList[0].OwnerId];
            }else{
                
            }
          
            If(UserList.Size()>0 && UserList.Size() != Null){
           
                IF(UserList[0].CTI_Agent_ID__c != Null){
                    r.agentid = UserList[0].CTI_Agent_ID__c;           //OzoneTel AgentId
                    r.Agent_username = UserList[0].CTI_Extension__c;
                    r.Campaign_name = UserList[0].campaign_name__c;
                    r.Agent_Mobile = UserList[0].MobilePhone;
                    r.status = 200;
                    r.message = 'Success';  
                    return r;
                }else{
                    r.status = 300;
                    r.message = 'AgentId not found ';  
                    return r;
                }
            }else{
                r.status = 400;
                r.message = 'Agent not found ';  
                return r;
            }
        }else{
            r.status = 500;
            r.message = 'record not found ';  
            return r;
        }
        
    }
    
    global class Rest_Result{
        global Integer status ;
        global String message ; 
        global String agentid;
        global String Agent_username;
        global String Campaign_name;
        global String Agent_Mobile;
    }
}
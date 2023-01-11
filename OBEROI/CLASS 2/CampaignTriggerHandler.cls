public class CampaignTriggerHandler {
public static boolean  isFirstRunAdvt=false;
public static boolean  isFirstRunAdvtupdate=false;
public static boolean  isFirstRunChannel=false;
public static boolean  isFirstRunCampaign=false;
//public static Decimal campCount =0;
public static string listString;

public static Id advtRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(System.Label.ORL_Campaign_Advertisement).getRecordTypeId();
public static Id campMultiRTId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(System.Label.ORL_Campaign_Marketing_Campaign_Multi_Project).getRecordTypeId();
public static Id campSingleRTId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(System.Label.ORL_Campaign_Marketing_Campaign_Single_Project).getRecordTypeId();
public static Id channRTId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(System.Label.ORL_Campaign_Marketing_Channel).getRecordTypeId();
public static Id planHOCommonRTId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(System.Label.ORL_Campaign_Marketing_Plan_HO_Common).getRecordTypeId();
public static Id plansiteSpecRTId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(System.Label.ORL_Campaign_Marketing_Plan_Site_Specific).getRecordTypeId();

public static Map<id, Campaign> ChannelMap = new MAp<id, Campaign>([SELECT id,Hierarchy_Channel_Cost__c,Total_Advrt_Utilization_Budget_Till_Date__c,startDate,EndDate,Marketing_Campaign__c, NAme, Booking_Count__c FROM Campaign WHERE RecordTypeId=:channRTId ]);
public static Map<id, Campaign> CampaignMap = new MAp<id, Campaign>([SELECT id, startDate,EndDate,Marketing_Plan__c,Total_Advrt_Utilization_Budget_Till_Date__c, NAme,Hierarchy_Campaign_Cost__c, Booking_Count__c FROM Campaign WHERE RecordTypeId=:campSingleRTId OR RecordTypeId=:campMultiRTId ]);
//Map<id, Campaign> multiCampaignMap = new MAp<id, Campaign>([SELECT id, NAme, Booking_Count__c FROM Campaign WHERE RecordTypeId=:campMultiRTId ]);       
public static Map<id, Campaign> PlanMap = new MAp<id, Campaign>([SELECT id, RecordTypeId,startDate,EndDate, NAme, Total_Advrt_Utilization_Budget_Till_Date__c,Booking_Count__c,Hierarchy_Plan_Cost__c FROM Campaign WHERE RecordTypeId=:plansiteSpecRTId OR RecordTypeId=:planHOCommonRTId]);


//Integer a = myDecimal.intValue();
//public static Map<id, Project__c> ProjMap = new Map<id, Project__c>([SELECT id, Name, Project_Site_Office_Address__c FROM Project__c where RecordType.Name =:Label.Lead_RecordType_Residential] );
public static void beforeInsertCampaign( list<Campaign> newCamp ){
    system.debug(plansiteSpecRTId+'plansiteSpecRTId');
    list<Campaign> channelList = new list<Campaign>();
    list<Campaign> CampaignList = new list<Campaign>();
    list<Campaign> planList = new list<Campaign>();
    list<Campaign> advtbudgetupdateList = new list<Campaign>();
    Decimal campCount =0;
    Decimal totalCost =0;
    
    map<string,string> mapCheckDuplicate = new map<string,String>();
    for (Campaign cp: newCamp){
        campaign campn = new Campaign();
        system.debug('In New Trigger Loop'+cp.Marketing_Channel__c + ' -- '+advtRecordTypeId+' -- '+cp.RecordTypeId);
        if(cp.RecordTypeId == advtRecordTypeId && cp.Marketing_Channel__c != null){
            if(!mapCheckDuplicate.containsKey(cp.Marketing_Channel__c)){
                mapCheckDuplicate.put(cp.Marketing_Channel__c,cp.Marketing_Channel__c);
                if(cp.Advertisement_Cost__c !=null){
                    campn.id = cp.Marketing_Channel__c ; 
                    //Added on 17/05 
                    campn.Total_Advrt_Utilization_Budget_Till_Date__c =  ChannelMap.get(cp.Marketing_Channel__c).Total_Advrt_Utilization_Budget_Till_Date__c + cp.Advertisement_Cost__c;                   
                    campaign campn1 = new Campaign();
                    totalCost = ChannelMap.get(cp.Marketing_Channel__c).Hierarchy_Channel_Cost__c;
                    totalCost = totalCost+cp.Advertisement_Cost__c;
                    campn.Hierarchy_Channel_Cost__c = totalCost;
                }if(cp.Booking_Count__c!= null){
                    campn.id = cp.Marketing_Channel__c ;
                    campCount = ChannelMap.get(cp.Marketing_Channel__c).Booking_Count__c;
                    campCount = campCount+cp.Booking_Count__c;
                    campn.Booking_Count__c = campCount;
                }
                system.debug('&&&&&'+campn);
                channelList.add(campn); 
            }                
        }//Checking for M Channel and updateing M Campaign
        else if(cp.RecordTypeId == channRTId  &&  cp.Marketing_Campaign__c != null){
            system.debug('RT--->'+cp.RecordTypeId);
            system.debug(cp.Booking_Count__c+'cp.Booking_Count__c');
            if(!mapCheckDuplicate.containsKey(cp.Marketing_Campaign__c  )){
                mapCheckDuplicate.put(cp.Marketing_Campaign__c  ,cp.Marketing_Campaign__c  );
                if(cp.Marketing_Channel_Cost__c!= null){
                    campn.id = cp.Marketing_Campaign__c  ; 
                     //Added on 17/05 
                    campn.Total_Advrt_Utilization_Budget_Till_Date__c =  CampaignMap.get(cp.Marketing_Campaign__c).Total_Advrt_Utilization_Budget_Till_Date__c + cp.Total_Advrt_Utilization_Budget_Till_Date__c;                   
                    totalCost = CampaignMap.get(cp.Marketing_Campaign__c).Hierarchy_Campaign_Cost__c  ;
                    totalCost = totalCost+cp.Marketing_Channel_Cost__c;
                    campn.Hierarchy_Campaign_Cost__c = totalCost;
                }if (cp.Booking_Count__c!= null) {
                    campn.id = cp.Marketing_Campaign__c  ;
                    campCount = CampaignMap.get(cp.Marketing_Campaign__c).Booking_Count__c;
                    campCount = campCount+cp.Booking_Count__c;
                    campn.Booking_Count__c = campCount;
                }
                system.debug('&&&&&'+campn);
                CampaignList.add(campn); 
            } 
        }//Checking for M Campaign and updateing M Plan
        else if((cp.RecordTypeId == campMultiRTId || cp.RecordTypeId == campSingleRTId) && cp.Marketing_Plan__c != null){
            system.debug('RT--->'+cp.RecordTypeId);
            system.debug(cp.Booking_Count__c+'cp.Booking_Count__c');
            if(!mapCheckDuplicate.containsKey(cp.Marketing_Plan__c)){
                mapCheckDuplicate.put(cp.Marketing_Plan__c,cp.Marketing_Plan__c);
                //if(cp.Booking_Count__c == null)cp.Booking_Count__c =0;
                if(cp.Marketing_Campaign_Cost__c != null){
                    campn.id = cp.Marketing_Plan__c ; 
                     //Added on 17/05 
                    campn.Total_Advrt_Utilization_Budget_Till_Date__c =  PlanMap.get(cp.Marketing_Plan__c).Total_Advrt_Utilization_Budget_Till_Date__c + cp.Total_Advrt_Utilization_Budget_Till_Date__c;     
                    totalCost = PlanMap.get(cp.Marketing_Plan__c).Hierarchy_Plan_Cost__c  ;
                    totalCost = totalCost+cp.Marketing_Campaign_Cost__c;
                    campn.Hierarchy_Plan_Cost__c = totalCost;
                }if ( cp.Booking_Count__c!= null ){
                    campn.id = cp.Marketing_Plan__c ; 
                    campCount = PlanMap.get(cp.Marketing_Plan__c).Booking_Count__c;                    
                    campCount = campCount+cp.Booking_Count__c;
                    campn.Booking_Count__c = campCount;
                }system.debug('&&&&&'+campn);
                planList.add(campn); 
            } 
        }
        
    }
    if(isFirstRunAdvt==false && channelList.size()> 0){
        try{
            update channelList;                
            isFirstRunAdvt=true;
        }catch(exception e){
            errorMessage(newCamp ,e.getMessage());
        }  
        
    } if(isFirstRunChannel==false && CampaignList.size()>0 ){ 
        try{
            update CampaignList;
            isFirstRunChannel=true;
        }catch(exception e){
            errorMessage(newCamp ,e.getMessage());
        }  
        
    } if(isFirstRunCampaign==false && planList.size()>0){
        try{
            update planList;
            isFirstRunCampaign=true;
        }catch(exception e){
            errorMessage(newCamp ,e.getMessage());
        }  
        
    }
}




public static void beforeUpdateCampaign( Map<id, Campaign> newCampMap , Map<id, Campaign> oldCampMap){
    list<Campaign> channelList = new list<Campaign>();
    list<Campaign> CampaignList = new list<Campaign>();
    list<Campaign> planList = new list<Campaign>();
    Decimal campaignCount =0;
    Decimal PlanCount =0;
    Decimal channelcount =0;
    Decimal ChannelSum =0;
    Decimal CampaignSum =0;
    Decimal PlanSum =0;
    Decimal advtBudget =0;
    
    map<string,string> mapCheckDuplicate = new map<string,String>();
    for (Campaign cp: newCampMap.values()){
        campaign campn = new Campaign();
        system.debug('In New Trigger Loop');
        if(cp.RecordTypeId == advtRecordTypeId  && cp.Marketing_Channel__c != null){
            if(!mapCheckDuplicate.containsKey(cp.Marketing_Channel__c)){
                mapCheckDuplicate.put(cp.Marketing_Channel__c,cp.Marketing_Channel__c);
                //if(oldCampMap.get(cp.id).Booking_Count__c != cp.Booking_Count__c){
               
                if(cp.Advertisement_Cost__c != null){
                    campn.id = cp.Marketing_Channel__c ; 
                    //Added on 17/05
                    if(ChannelMap.get(cp.Marketing_Channel__c).Total_Advrt_Utilization_Budget_Till_Date__c != null && cp.Advertisement_Cost__c != null)
                    advtBudget = ChannelMap.get(cp.Marketing_Channel__c).Total_Advrt_Utilization_Budget_Till_Date__c+ cp.Advertisement_Cost__c;
                    if(oldCampMap.get(cp.id).Advertisement_Cost__c != null)
                    advtBudget = advtBudget - oldCampMap.get(cp.id).Advertisement_Cost__c;
                    campn.Total_Advrt_Utilization_Budget_Till_Date__c = advtBudget;
                    ChannelSum = ChannelMap.get(cp.Marketing_Channel__c).Hierarchy_Channel_Cost__c ;
                    ChannelSum = ChannelSum + cp.Advertisement_Cost__c ;
                    ChannelSum = ChannelSum - (oldCampMap.get(cp.id).Advertisement_Cost__c);                    
                    campn.Hierarchy_Channel_Cost__c = (ChannelSum < 0) ? 0 : ChannelSum ;
                }/*
                if( cp.Booking_Count__c!= null ){
                    campn.id = cp.Marketing_Channel__c ;
                    channelcount = ChannelMap.get(cp.Marketing_Channel__c).Booking_Count__c;
                    channelcount = channelcount+cp.Booking_Count__c;
                    channelcount = channelcount - oldCampMap.get(cp.id).Booking_Count__c;
                    system.debug('channelcount&*&*'+channelcount+'$$'+cp.Booking_count__c);
                    campn.Booking_Count__c = (channelcount < 0) ? 0 : channelcount ;
                }*/
                system.debug('&&&&&'+campn);
                channelList.add(campn); 
                // }
            }                
        }//Checking for M Channel and updateing M Campaign
        else if(cp.RecordTypeId == channRTId  &&  cp.Marketing_Campaign__c != null){                
            if(!mapCheckDuplicate.containsKey(cp.Marketing_Campaign__c  )){
                mapCheckDuplicate.put(cp.Marketing_Campaign__c  ,cp.Marketing_Campaign__c   );
                system.debug( oldCampMap.get(cp.id).Booking_Count__c+' oldCampMap.get(cp.id).Booking_Count__c;');
                //   if(oldCampMap.get(cp.id).Booking_Count__c != cp.Booking_Count__c){
                if(cp.Marketing_Channel_Cost__c != null){
                    campn.id = cp.Marketing_Campaign__c ; 
                    //Added on 17/05
                    if(CampaignMap.get(cp.Marketing_Campaign__c ).Total_Advrt_Utilization_Budget_Till_Date__c != null && cp.Total_Advrt_Utilization_Budget_Till_Date__c != null)
                    advtBudget = CampaignMap.get(cp.Marketing_Campaign__c ).Total_Advrt_Utilization_Budget_Till_Date__c+ cp.Total_Advrt_Utilization_Budget_Till_Date__c;
                    if(oldCampMap.get(cp.id).Total_Advrt_Utilization_Budget_Till_Date__c != null && advtBudget != null)
                    advtBudget = advtBudget - oldCampMap.get(cp.id).Total_Advrt_Utilization_Budget_Till_Date__c;
                    if(advtBudget != null)
                    campn.Total_Advrt_Utilization_Budget_Till_Date__c = advtBudget;
                    if(CampaignMap.get(cp.Marketing_Campaign__c ).Hierarchy_Campaign_Cost__c != null)
                    CampaignSum = CampaignMap.get(cp.Marketing_Campaign__c ).Hierarchy_Campaign_Cost__c ;
                    if(cp.Marketing_Channel_Cost__c != null)
                    CampaignSum = CampaignSum + cp.Marketing_Channel_Cost__c ;
                    if(oldCampMap.get(cp.id).Marketing_Channel_Cost__c != null)
                    CampaignSum = CampaignSum - oldCampMap.get(cp.id).Marketing_Channel_Cost__c;  
                    if(CampaignSum != null)           
                    campn.Hierarchy_Campaign_Cost__c = (CampaignSum < 0) ? 0 : CampaignSum ;
                }
                /*if(cp.Booking_Count__c!= null) {
                    campn.id = cp.Marketing_Campaign__c  ; 
                    campaignCount = CampaignMap.get(cp.Marketing_Campaign__c).Booking_Count__c;
                    campaignCount = campaignCount+cp.Booking_Count__c;
                    campaignCount = campaignCount - oldCampMap.get(cp.id).Booking_Count__c;
                    campn.Booking_Count__c = (campaignCount < 0) ? 0 : campaignCount;
                }*/ 
                CampaignList.add(campn); 
                
                //  }
            } 
        }//Checking for M Campaign and updateing M Plan
        else if((cp.RecordTypeId == campMultiRTId || cp.RecordTypeId == campSingleRTId) &&  cp.Marketing_Plan__c != null){
            system.debug('RT--->'+cp.RecordTypeId);
            system.debug(cp.Booking_Count__c+'cp.Booking_Count__c');
            if(!mapCheckDuplicate.containsKey(cp.Marketing_Plan__c)){
                mapCheckDuplicate.put(cp.Marketing_Plan__c,cp.Marketing_Plan__c);
                if(cp.Marketing_Campaign_Cost__c != null){
                    campn.id = cp.Marketing_Plan__c ;
                     //Added on 17/05
                     if(PlanMap.get(cp.Marketing_Plan__c ).Total_Advrt_Utilization_Budget_Till_Date__c != null && cp.Total_Advrt_Utilization_Budget_Till_Date__c != null)
                     advtBudget = PlanMap.get(cp.Marketing_Plan__c ).Total_Advrt_Utilization_Budget_Till_Date__c+ cp.Total_Advrt_Utilization_Budget_Till_Date__c;
                    if(oldCampMap.get(cp.id).Total_Advrt_Utilization_Budget_Till_Date__c != null)
                    advtBudget = advtBudget - oldCampMap.get(cp.id).Total_Advrt_Utilization_Budget_Till_Date__c;
                    
                    if(advtBudget != null)
                    campn.Total_Advrt_Utilization_Budget_Till_Date__c = advtBudget; 
                    
                    if(PlanMap.get(cp.Marketing_Plan__c ).Hierarchy_Plan_Cost__c  != null)
                    PlanSum = PlanMap.get(cp.Marketing_Plan__c ).Hierarchy_Plan_Cost__c ;
                    if(cp.Marketing_Campaign_Cost__c  !=null && PlanSum != null)
                    PlanSum = PlanSum + cp.Marketing_Campaign_Cost__c ;
                    if((oldCampMap.get(cp.id).Marketing_Campaign_Cost__c) != null)
                    PlanSum = PlanSum - (oldCampMap.get(cp.id).Marketing_Campaign_Cost__c); 
                    IF( PlanSum != null)                  
                    campn.Hierarchy_Plan_Cost__c = (PlanSum < 0) ? 0 : PlanSum ;
                    
                }
                /*if( cp.Booking_Count__c!= null ){
                    campn.id = cp.Marketing_Plan__c ; 
                    PlanCount = PlanMap.get(cp.Marketing_Plan__c).Booking_Count__c;                    
                    PlanCount = PlanCount+cp.Booking_Count__c;
                    PlanCount = PlanCount - oldCampMap.get(cp.id).Booking_Count__c;
                    campn.Booking_Count__c = (PlanCount < 0) ? 0 : PlanCount;
                }*/
                planList.add(campn); 
                //  }
            } 
        }
        
    }
    
    if(isFirstRunAdvt==false && channelList.size()>0 ){
        try{ update channelList;
            isFirstRunAdvt=true;
           }catch(Exception e){
               errorMessage(newCampMap.values() ,e.getMessage()); 
           }
    } if(isFirstRunChannel==false && CampaignList.size()>0 ){
        try{
            update CampaignList;            
            isFirstRunChannel=true;
        }catch(exception e){
            errorMessage(newCampMap.values() ,e.getMessage());
        }           
        
    } if(isFirstRunCampaign==false && planList.size()>0 ){
        try{
            update planList;
            isFirstRunCampaign=true;
        }catch(exception e){
            errorMessage(newCampMap.values() ,e.getMessage());
        }
    }
}

//Added by Ravi Kumar K
public static void updateCampaingonVirtualNumber(List<Campaign> newCampaingList,Map<id,Campaign> oldCampaingMap, String methodName){ 
    // System.debug(12345);
    Map<Id,Id> virtualNumberMap = new Map<Id,Id>();
    Id recTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Advertisement').getRecordTypeId();
    Set<Id> virtualSet = new Set<Id>();
    Set<Id> virtualdupSet = new Set<Id>();
    For (Campaign singleCampaign: newCampaingList){
        if(methodName=='insert'){
            if(singleCampaign.Virtual_Number__c!=null && singleCampaign.recordTypeId==recTypeId){
                virtualNumberMap.put(singleCampaign.Virtual_Number__c,singleCampaign.Id);
                virtualSet.add(singleCampaign.Virtual_Number__c);
            } 
        }if(methodName=='update'){
            System.debug('1234');
            if(singleCampaign.Virtual_Number__c!=null && singleCampaign.recordTypeId==recTypeId
               && singleCampaign.Virtual_Number__c!=oldCampaingMap.get(singleCampaign.Id).Virtual_Number__c){
                   System.debug('555');
                   virtualdupSet.add(oldCampaingMap.get(singleCampaign.Id).Virtual_Number__c);
                   virtualNumberMap.put(singleCampaign.Virtual_Number__c,singleCampaign.Id);
                   virtualSet.add(singleCampaign.Virtual_Number__c);
               } 
        } 
    }
    if(virtualSet.size()>0){
        List<Virtual_Number__c> virtualNumberList = [SELECT Advertisement__c FROM Virtual_Number__c WHERE Id=:virtualSet];
        List<Virtual_Number__c> dupvirtualNumberList = [SELECT Advertisement__c FROM Virtual_Number__c WHERE Id=:virtualdupSet];
        Map<String,String> errorDetailsMap = new Map<String,String>();
        if(virtualNumberList.size()>0  ){
            For(Virtual_Number__c sinlgeVirtualNumber:virtualNumberList){
                sinlgeVirtualNumber.Advertisement__c = virtualNumberMap.get(sinlgeVirtualNumber.Id);
            }
             For(Virtual_Number__c sinlgeVirtualNumber: dupvirtualNumberList){
                sinlgeVirtualNumber.Advertisement__c = null;
            }
            try{
                update virtualNumberList;  
                update dupvirtualNumberList; 
            }
            catch(Exception e){
                String errorMsg = e.getMessage();
                String errorMsgValidation = errorMsg.substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION, ', ': ');
                String errorMsgId = errorMsg.substringBetween('id ', ';');
                System.debug('errorMsg__'+errorMsgId);
                errorDetailsMap.put(errorMsgId,errorMsgValidation);
            }
            For (Campaign singleCampaign: newCampaingList){
                if(errorDetailsMap.get(singleCampaign.Virtual_Number__c)!=null){
                    singleCampaign.addError(errorDetailsMap.get(singleCampaign.Virtual_Number__c));
                }
            }
        }
    }
    
}



public static void beforeInsertValidation( list<Campaign> newCamp ){    
    boolean isValidScope=true;
    Id mCampaign;
    set<Id>campId = new set<Id>();    
    Id mPlan;
    /* for (Campaign cp :newCamp){
     if(cp.Virtual_Number__c != null)
     campId.add(cp.Virtual_Number__c);
     }*/
   // Map<id, Virtual_Number__c> vNoMap = new Map<id, Virtual_Number__c>([SELECT id, name, Advertisement__c FROM Virtual_Number__c where id in :campId]);
    
    for (Campaign cp :newCamp)
        if(cp.recordtypeId == advtRecordTypeId && cp.MArketing_channel__c!= null){
        system.debug('test');
         //Check for M Plan is generic or not and update field and based on field trigger Validation Rule
         system.debug('***'+cp.Marketing_Channel__r.Marketing_Campaign__c+'*****'+cp.Marketing_Channel__r.Marketing_Campaign__r.Marketing_Plan__c);
                if(ChannelMap.get(cp.Marketing_Channel__c).Marketing_Campaign__c != null ){
                mCampaign = ChannelMap.get(cp.Marketing_Channel__c).Marketing_Campaign__c ;
                if(CampaignMap.get(mCampaign).Marketing_Plan__c != null){
                mPlan = CampaignMap.get(mCampaign).Marketing_Plan__c;
                if(PlanMap.get(mPlan).RecordTypeId == planHOCommonRTId){
                  cp.Is_Parent_Plan_is_Generic__c = true;          
                }}}else{
                cp.Is_Parent_Plan_is_Generic__c = false;
                }
            if(cp.StartDate < ChannelMap.get(cp.MArketing_channel__c).StartDate || cp.EndDate > ChannelMap.get(cp.MArketing_channel__c).EndDate){
                cp.addError('Advertisement Start and End Date should be between Marketing Channel Date.');
                isValidScope=false;
            }
            //Checking for duplicte Virtual No
          /*  if(cp.Virtual_Number__c != null ){
            if((vNoMap.get(cp.Virtual_Number__c).advertisement__c != null)){
               cp.addError('This Virtual No is already in use.');
               isValidScope=false;
               }
            }*/
            
        } else if(cp.recordtypeId == channRTId && cp.MArketing_Campaign__c!= null ){                
            if(cp.StartDate < CampaignMap.get(cp.MArketing_Campaign__c).StartDate || cp.EndDate > CampaignMap.get(cp.MArketing_Campaign__c).EndDate){
                cp.addError('Marketing Channel Start and End Date should be between Marketing Campaign Date.');
                isValidScope=false;
            }
        } else if((cp.recordtypeId == campMultiRTId  || cp.recordTypeId == campSingleRTId) && cp.MArketing_Plan__c!=null ){
            system.debug('CampaignMap'+PlanMap+'**'+cp.MArketing_Plan__c);
            if(cp.StartDate < PlanMap.get(cp.MArketing_Plan__c).StartDate || cp.EndDate > PlanMap.get(cp.MArketing_Plan__c).EndDate){
                cp.addError('Marketing Campaign Start and End Date should be between Marketing Plan Date.');
                isValidScope=false;
            }
        }
    if(isValidScope){
        beforeInsertCampaign(newCamp);
    }
}

public static void beforeUpdateValidation( Map<id, Campaign> newCampMap , Map<id, Campaign> oldCampMap){
    boolean isValidScope=true;
    set<Id>campId = new set<Id>();
   /*  for (Campaign cp :newCampMap.values()){
     if(cp.Virtual_Number__c != null)
     campId.add(cp.Virtual_Number__c);
     }*/
    //Map<id, Virtual_Number__c> vNoMap = new Map<id, Virtual_Number__c>([SELECT id, name, Advertisement__c FROM Virtual_Number__c where id in :campId]);
    
    for (Campaign cp :newCampMap.Values())
       if(cp.StartDate != oldCampMap.get(cp.id).startDate || cp.StartDate != oldCampMap.get(cp.id).EndDate || cp.Virtual_Number__c != oldCampMap.get(cp.id).Virtual_Number__c){
            if(cp.recordtypeId == advtRecordTypeId &&( cp.StartDate!= null || cp.EndDate != null || cp.Virtual_Number__c != null) && cp.MArketing_channel__c!= null){
                if(cp.StartDate < ChannelMap.get(cp.MArketing_channel__c).StartDate || cp.EndDate > ChannelMap.get(cp.MArketing_channel__c).EndDate){
                    cp.addError('Advertisement Start and End Date should be between Marketing Channel Date.');
                    isValidScope=false;
                }
             /*   if(campId.size()!= 0 && (vNoMap.get(cp.Virtual_Number__c).advertisement__c != null) && vNoMap.get(cp.Virtual_Number__c).advertisement__c!= cp.id){
               cp.addError('This Virtual No is already in use.');
               isValidScope=false;
            }*/
            }else if(cp.recordtypeId == channRTId &&( cp.StartDate!= null || cp.EndDate != null) && cp.MArketing_Campaign__c != null ){
                if(cp.StartDate < CampaignMap.get(cp.MArketing_Campaign__c).StartDate || cp.EndDate > CampaignMap.get(cp.MArketing_Campaign__c).EndDate){
                    cp.addError('Marketing Channel Start and End Date should be between Marketing Campaign Date.');
                    isValidScope=false;
                }
            } else if((cp.recordtypeId == campMultiRTId  || cp.recordTypeId == campSingleRTId) &&( cp.StartDate!= null || cp.EndDate != null) && cp.MArketing_Plan__c!= null ){
                if(cp.StartDate < PlanMap.get(cp.MArketing_Plan__c).StartDate || cp.EndDate > PlanMap.get(cp.MArketing_Plan__c).EndDate){
                    cp.addError('Marketing Campaign Start and End Date should be between Marketing Plan Date.');
                    isValidScope=false;
                }
            }
        }
    if(isValidScope){
        beforeUpdateCampaign(newCampMap ,oldCampMap);
    }
    
}


public static string errorMessage(List<Campaign>newCampList ,string eMessage){
    for (Campaign cp: newCampList){
        if(eMessage.contains(Label.Validation_Error_On_Campaign)){
            cp.adderror(Label.Validation_Error_On_Campaign);
        }else{
            cp.addError(Label.Internal_Error_Message);
        }
    }
    return null;
}

public static void afterInsertCampaign( Map<id, Campaign>newCamp ){ 
    
    //sendMessage(newLead);
}
/*   
///update remaining budget to parent
Public static void UpdateRemaining(id Campaignid){

Id PlanSiteRecordTypeId = Schema.SObjectType.campaign.getRecordTypeInfosByName().get('Marketing Plan - Site Specific').getRecordTypeId();    
Id AdvertisementRecordTypeId = Schema.SObjectType.campaign.getRecordTypeInfosByName().get('Advertisement').getRecordTypeId();
Id PlanHORecordTypeId = Schema.SObjectType.campaign.getRecordTypeInfosByName().get('Marketing Plan - HO Common').getRecordTypeId();
Id ChannelRecordTypeId = Schema.SObjectType.campaign.getRecordTypeInfosByName().get('Marketing Channel').getRecordTypeId();
Id CampaignSingleRecordTypeId = Schema.SObjectType.campaign.getRecordTypeInfosByName().get('Marketing Campaign Single Project').getRecordTypeId();
Id CampaignMultiRecordTypeId = Schema.SObjectType.campaign.getRecordTypeInfosByName().get('Marketing Campaign Multi Project').getRecordTypeId();

Map<id,campaign> mapParCampaign = new Map<id, Campaign>([select id,Marketing_Plan_Cost__c,Marketing_Campaign_Cost__c,Marketing_Channel_Cost__c,Advertisement_Cost__c,ParentId,RecordTypeId,Remaining_Budget__c from campaign where id=:Campaignid]);
List<campaign> updCampLst = new List<Campaign>();
decimal BudgetAmt=0;
//id CampParentId; 

//do{
    List<campaign> CampLst = new List<campaign>([select Marketing_Plan_Cost__c,Marketing_Campaign_Cost__c,Marketing_Channel_Cost__c,Advertisement_Cost__c,ParentId,RecordTypeId,Remaining_Budget__c from campaign where id=:Campaignid]);
    
    for(Campaign camp : CampLst){
        if(camp.RecordTypeId==AdvertisementRecordTypeId){
            BudgetAmt = BudgetAmt + camp.Advertisement_Cost__c;
            //CampParentId = camp.ParentId;
        }
        else if(camp.RecordTypeId==ChannelRecordTypeId){
            BudgetAmt = BudgetAmt + camp.Marketing_Channel_Cost__c;
            //CampParentId = camp.ParentId;
        }
        else if(camp.RecordTypeId==CampaignSingleRecordTypeId || camp.RecordTypeId==CampaignMultiRecordTypeId){
            BudgetAmt = BudgetAmt + camp.Marketing_Campaign_Cost__c;
            //CampParentId = camp.ParentId;
        }
        else if(camp.RecordTypeId==PlanSiteRecordTypeId || camp.RecordTypeId==PlanHORecordTypeId){
            BudgetAmt = BudgetAmt + camp.Marketing_Plan_Cost__c;
            //CampParentId = camp.ParentId;
        }
    }
    
    // Update Parent Remaining Budget Amount
    if(Campaignid<>null){
            if(mapParCampaign.get(Campaignid).RecordTypeId==ChannelRecordTypeId){
                Campaign c = new Campaign();
                c.id = Campaignid;
                c.Remaining_Budgets__c = mapParCampaign.get(Campaignid).Marketing_Channel_Cost__c - BudgetAmt;
                updCampLst.add(c);
            }
            else if(mapParCampaign.get(Campaignid).RecordTypeId==CampaignSingleRecordTypeId || mapParCampaign.get(Campaignid).RecordTypeId==CampaignMultiRecordTypeId){
                Campaign c = new Campaign();
                c.id = Campaignid;
                c.Remaining_Budgets__c = mapParCampaign.get(Campaignid).Marketing_Campaign_Cost__c - BudgetAmt;
                updCampLst.add(c);
            }
            else if(mapParCampaign.get(Campaignid).RecordTypeId==PlanSiteRecordTypeId || mapParCampaign.get(Campaignid).RecordTypeId==PlanHORecordTypeId){
                Campaign c = new Campaign();
                c.id = Campaignid;
                c.Remaining_Budgets__c = mapParCampaign.get(Campaignid).Marketing_Plan_Cost__c - BudgetAmt;
                updCampLst.add(c);
            }
    }
    //Campaignid = CampParentId;
    
// }while(Campaignid !='' || Campaignid !=null);
if(updCampLst.Size()>0){
    update updCampLst;
}
}*/



public static void afterDeleteCampaign(list<Campaign>oldList){
system.debug(plansiteSpecRTId+'plansiteSpecRTId');
    list<Campaign> channelList = new list<Campaign>();
    list<Campaign> CampaignList = new list<Campaign>();
    list<Campaign> planList = new list<Campaign>();
    list<Campaign> advtbudgetupdateList = new list<Campaign>();
    Decimal campCount =0;
    Decimal totalCost =0;
    
    map<string,string> mapCheckDuplicate = new map<string,String>();
    for (Campaign cp: oldList){
        campaign campn = new Campaign();
        system.debug('In New Trigger Loop'+cp.Marketing_Channel__c + ' -- '+advtRecordTypeId+' -- '+cp.RecordTypeId);
        if(cp.RecordTypeId == advtRecordTypeId && cp.Marketing_Channel__c != null){
            if(!mapCheckDuplicate.containsKey(cp.Marketing_Channel__c)){
                mapCheckDuplicate.put(cp.Marketing_Channel__c,cp.Marketing_Channel__c);
                if(cp.Advertisement_Cost__c !=null){
                    campn.id = cp.Marketing_Channel__c ; 
                    //Added on 17/05 
                    campn.Total_Advrt_Utilization_Budget_Till_Date__c =  ChannelMap.get(cp.Marketing_Channel__c).Total_Advrt_Utilization_Budget_Till_Date__c - cp.Advertisement_Cost__c;                   
                   // campaign campn1 = new Campaign();
                    totalCost = ChannelMap.get(cp.Marketing_Channel__c).Hierarchy_Channel_Cost__c;
                    totalCost = totalCost - cp.Advertisement_Cost__c;
                    campn.Hierarchy_Channel_Cost__c = totalCost;
                }if(cp.Booking_Count__c!= 0 || cp.Booking_Count__c!= null){
                    campn.id = cp.Marketing_Channel__c ;
                    campCount = ChannelMap.get(cp.Marketing_Channel__c).Booking_Count__c;
                    campCount = campCount - cp.Booking_Count__c;
                    campn.Booking_Count__c = campCount;
                }
                system.debug('&&&&&'+campn);
                channelList.add(campn); 
            }                
        }//Checking for M Channel and updateing M Campaign
        else if(cp.RecordTypeId == channRTId  &&  cp.Marketing_Campaign__c != null){
            system.debug('RT--->'+cp.RecordTypeId);
            system.debug(cp.Booking_Count__c+'cp.Booking_Count__c');
            if(!mapCheckDuplicate.containsKey(cp.Marketing_Campaign__c  )){
                mapCheckDuplicate.put(cp.Marketing_Campaign__c  ,cp.Marketing_Campaign__c  );
                if(cp.Marketing_Channel_Cost__c!= null){
                    campn.id = cp.Marketing_Campaign__c  ; 
                     //Added on 17/05 
                    campn.Total_Advrt_Utilization_Budget_Till_Date__c =  CampaignMap.get(cp.Marketing_Campaign__c).Total_Advrt_Utilization_Budget_Till_Date__c - cp.Total_Advrt_Utilization_Budget_Till_Date__c;                   
                    totalCost = CampaignMap.get(cp.Marketing_Campaign__c).Hierarchy_Campaign_Cost__c  ;
                    totalCost = totalCost - cp.Marketing_Channel_Cost__c;
                    campn.Hierarchy_Campaign_Cost__c = totalCost;
                }if (cp.Booking_Count__c!= 0 || cp.Booking_Count__c!= null) {
                    campn.id = cp.Marketing_Campaign__c  ;
                    campCount = CampaignMap.get(cp.Marketing_Campaign__c).Booking_Count__c;
                    campCount = campCount - cp.Booking_Count__c;
                    campn.Booking_Count__c = campCount;
                }
                system.debug('&&&&&'+campn);
                CampaignList.add(campn); 
            } 
        }//Checking for M Campaign and updateing M Plan
        else if((cp.RecordTypeId == campMultiRTId || cp.RecordTypeId == campSingleRTId) && cp.Marketing_Plan__c != null){
            system.debug('RT--->'+cp.RecordTypeId);
            system.debug(cp.Booking_Count__c+'cp.Booking_Count__c');
            if(!mapCheckDuplicate.containsKey(cp.Marketing_Plan__c)){
                mapCheckDuplicate.put(cp.Marketing_Plan__c,cp.Marketing_Plan__c);
                //if(cp.Booking_Count__c == null)cp.Booking_Count__c =0;
                if(cp.Marketing_Campaign_Cost__c != null){
                    campn.id = cp.Marketing_Plan__c ; 
                     //Added on 17/05 
                    campn.Total_Advrt_Utilization_Budget_Till_Date__c =  PlanMap.get(cp.Marketing_Plan__c).Total_Advrt_Utilization_Budget_Till_Date__c - cp.Total_Advrt_Utilization_Budget_Till_Date__c;     
                    totalCost = PlanMap.get(cp.Marketing_Plan__c).Hierarchy_Plan_Cost__c  ;
                    totalCost = totalCost - cp.Marketing_Campaign_Cost__c;
                    campn.Hierarchy_Plan_Cost__c = totalCost;
                }if (cp.Booking_Count__c!= 0 || cp.Booking_Count__c!= null ){
                    campn.id = cp.Marketing_Plan__c ; 
                    campCount = PlanMap.get(cp.Marketing_Plan__c).Booking_Count__c;                    
                    campCount = campCount - cp.Booking_Count__c;
                    campn.Booking_Count__c = campCount;
                }system.debug('&&&&&'+campn);
                planList.add(campn); 
            } 
        }
        
    }
    if(isFirstRunAdvt==false && channelList.size()> 0){
        try{
            update channelList;                
            isFirstRunAdvt=true;
        }catch(exception e){
            errorMessage(oldList ,e.getMessage());
        }  
        
    } if(isFirstRunChannel==false && CampaignList.size()>0 ){ 
        try{
            update CampaignList;
            isFirstRunChannel=true;
        }catch(exception e){
            errorMessage(oldList ,e.getMessage());
        }  
        
    } if(isFirstRunCampaign==false && planList.size()>0){
        try{
            update planList;
            isFirstRunCampaign=true;
        }catch(exception e){
            errorMessage(oldList ,e.getMessage());
        }  
        
    }
}

public static void bookingCountlogic(List<Campaign> campList , Map<id, Campaign> oldCampMap){
    list<Campaign> channelList = new list<Campaign>();
    list<Campaign> CampaignList = new list<Campaign>();
    list<Campaign> planList = new list<Campaign>();
    Decimal campaignCount =0;
    Decimal PlanCount =0;
    Decimal channelcount =0;
    Decimal ChannelSum =0;
    Decimal CampaignSum =0;
    Decimal PlanSum =0;
    Decimal advtBudget =0; 
    Set<String> stCampaign = new Set<String>();
    Set<String> stChannRT = new Set<String>();
    Set<String> stCampRT = new Set<String>();
    map<string,string> mapCheckDuplicate = new map<string,String>();
    for(Campaign cp : campList){
        if(cp.Booking_Count__c!= null){
            stCampaign.add(cp.Id);
        }/*
        if(cp.RecordTypeId == advtRecordTypeId  && cp.Marketing_Channel__c != null && cp.Booking_Count__c!= null){
            stCampaign.add(cp.Id);
        }
        if(cp.RecordTypeId == channRTId  && cp.Marketing_Campaign__c != null && cp.Booking_Count__c!= null){
            stChannRT.add(cp.Id);
        }
        if((cp.RecordTypeId == campMultiRTId || cp.RecordTypeId == campSingleRTId) && cp.Marketing_Plan__c != null 
        && cp.Booking_Count__c!= null){
            stCampRT.add(cp.Id);
        }*/
    }   
    
    for (Campaign campn : [select RecordTypeId,Id,Marketing_Channel__r.Booking_Count__c,Booking_Count__c,Marketing_Channel__r.RecordTypeId,
    Marketing_Campaign__r.RecordTypeId, Marketing_Campaign__c, Marketing_Campaign__r.Booking_Count__c,
    Marketing_Plan__r.RecordTypeId, Marketing_Plan__r.Booking_Count__c, Marketing_Plan__c from Campaign where Id IN :stCampaign]) {
        system.debug('campn.Marketing_Channel__r.RecordTypeId'+campn.Marketing_Channel__r.RecordTypeId);
        system.debug('channRTIdchannRTIdchannRTId'+channRTId);
        if(campn.RecordTypeId == advtRecordTypeId && campn.Marketing_Channel__r.RecordTypeId == channRTId){
            Campaign newcamp = new Campaign();  
            newcamp.id = campn.Marketing_Channel__c;
            channelcount = campn.Marketing_Channel__r.Booking_Count__c;
            channelcount = channelcount+campn.Booking_Count__c;
            channelcount = channelcount - oldCampMap.get(campn.id).Booking_Count__c;
            newcamp.Booking_Count__c = (channelcount < 0) ? 0 : channelcount ;
            channelList.add(newcamp);
            //break;
        }
        if(campn.RecordTypeId == channRTId && (campn.Marketing_Campaign__r.RecordTypeId == campSingleRTId ||
        campn.Marketing_Campaign__r.RecordTypeId == campMultiRTId)){
            
            Campaign newcamp = new Campaign();  
            newcamp.id = campn.Marketing_Campaign__c;
            campaignCount = campn.Marketing_Campaign__r.Booking_Count__c;
            campaignCount = campaignCount+campn.Booking_Count__c;
            campaignCount = campaignCount - oldCampMap.get(campn.id).Booking_Count__c;
            newcamp.Booking_Count__c = (campaignCount < 0) ? 0 : campaignCount ;
            CampaignList.add(newcamp);
            //break;
        }
        if((campn.RecordTypeId == campSingleRTId || campn.RecordTypeId == campMultiRTId) 
        && (campn.Marketing_Plan__r.RecordTypeId == plansiteSpecRTId || campn.Marketing_Plan__r.RecordTypeId == planHOCommonRTId)){
            
            Campaign newcamp = new Campaign();  
            newcamp.id = campn.Marketing_Plan__c;
            PlanCount = campn.Marketing_Plan__r.Booking_Count__c;
            PlanCount = PlanCount+campn.Booking_Count__c;
            PlanCount = PlanCount - oldCampMap.get(campn.id).Booking_Count__c;
            newcamp.Booking_Count__c = (PlanCount < 0) ? 0 : PlanCount ;
            planList.add(newcamp);
            //break;
        }
    }
    system.debug('channelListchannelListchannelListchannelListchannelList'+channelList);
    system.debug('CampaignListCampaignListCampaignListCampaignList'+CampaignList);
    if(channelList.size()>0 ){
        update channelList;
    }
    if(CampaignList.size()>0 ){
        update CampaignList;
    }
    if(planList.size()>0 ){
        update planList;
    }
}


}